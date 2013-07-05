package;

/**
*   Flixel Tools
*   Command Line utitity to create flixel samples, project templates
*   Ability to batch compile the samples for validation
*   Basic find and replace tool for old HaxeFlixel code
*
*   @author Chris Decoster aka impaler
*   @author Joshua Granick for methods used from openfl-tools
*
*/
import utils.PathHelper;

import haxe.Json;
import haxe.io.Bytes;
import haxe.io.Path;
import project.Haxelib;
import project.Platform;
import helpers.FileHelper;
import helpers.PlatformHelper;
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

class FlxCommandLineTools
{
    public static var name = "HaxeFlixel";
    public static var alias = "flixel";
    public static var version = "0.0.1";
    public static var flixelVersion:String;

    // Parsed commands to execute
    public static var commandsSet:Commands;

    // Build Results
    public static var PASSED:String = "PASSED";
    public static var FAILED:String = "FAILED";

    /**
     * Echo some information about HaxeFlixel to the command line
     * @return
     */
    private static function displayInfo():Void
    {
        // Get the current flixel version
        if (flixelVersion == null) 
        {
            var flixelPath:String = PathHelper.getHaxelib(new Haxelib("flixel"));
            var jsonContent:String = File.getContent(flixelPath + "haxelib.json");
            var jsonData:HaxelibJSON = Json.parse(jsonContent);
            flixelVersion = jsonData.version;
        }

        Sys.println("                 _   _               ______ _  _          _");
        Sys.println("                | | | |              |  ___| ||_|        | |");
        Sys.println("                | |_| | __ ___  _____| |_  | |____  _____| |");
        Sys.println("                |  _  |/ _` \\ \\/ / _ \\  _| | || \\ \\/ / _ \\ |");
        Sys.println("                | | | | (_| |>  <  __/ |   | || |>  <  __/ |");
        Sys.println("                |_| |_|\\__,_/_/\\_\\___\\_|   |_||_/_/\\_\\___|_|");
        Sys.println("");
        Sys.println("");
        Sys.println("                   Powered by the Haxe Toolkit and OpenFL");
        Sys.println("     Please visit www.haxeflixel.com for community support and ressources!");
        Sys.println("");
        Sys.println("                    " + name + " Command-Line Tools (" + version + ")");

        if (flixelVersion == "0.0.1")   
        {
            Sys.println("                     flixel is currently not installed!");
        }
        else 
        {
            Sys.println("                    Current flixel version: " + flixelVersion);
        }

        Sys.println("                  Use \"" + alias + " help\" for available commands");
        Sys.println("");
    }

    public static function main():Void
    {
        // Parse the arguments
        commandsSet = processArguments();
        // Sys.println(commandsSet);

        // Choose the argument method
        if (commandsSet.help)
        {
            displayHelp();
        }
        else if (commandsSet.create)
        {
            createSample(commandsSet.createName);
        }
        else if (commandsSet.template)
        {
            createTemplate(commandsSet.createName);
        }
        else if (commandsSet.setup)
        {
            setupTools();
        }
        else if (commandsSet.list)
        {
            if (!commandsSet.listSamples && !commandsSet.listTemplates)
            {
                scanTemplates();
                Sys.println("");
                scanSamples();
            }
            else if (commandsSet.listSamples)
            {
                scanSamples();
            }
            else if (commandsSet.listTemplates)
            {
                scanTemplates();
            }
        }
        else if (commandsSet.validate)
        {
            validateProject();
        }
        else if (commandsSet.convert)
        {
            convertProject();
        }
        else if (commandsSet.download)
        {
            downloadSamples();
        }
        else
        {
            displayInfo();
        }
    }

    /**
     * Display a listing of available commands
     * @return
     */
    private static function displayHelp():Void
    {
        Sys.println("");

        Sys.println(name + " Command-Line Tools (" + version + ")");

        Sys.println("");

        Sys.println(" Setup the tools to use the " + alias + " alias");
        Sys.println(" Usage : haxelib run " + alias + "-tools setup");

        Sys.println("");

        Sys.println(" Create a sample by name");
        Sys.println(" Usage : " + alias + " create <name>");

        Sys.println("");

        Sys.println(" Create a project template");
        Sys.println(" Usage : " + alias + " template -name <project_name> -class <class_name> -screen <width_value> <height_value>");

        Sys.println("");

        Sys.println(" List available samples and templates");
        Sys.println(" Usage : " + alias + " list");

        Sys.println("");

        Sys.println(" Download all the HaxeFlixel samples");
        Sys.println(" Usage : " + alias + " download samples");

        Sys.println("");

        Sys.println(" List available samples");
        Sys.println(" Usage : " + alias + " list samples");

        Sys.println("");

        Sys.println(" List available templates");
        Sys.println(" Usage : " + alias + " list templates");

        Sys.println("");

        Sys.println(" To compile your HaxeFlixel projects use the openfl");
        Sys.println(" Usage : openfl help");

        Sys.println("");
    }

    /**
     * Create a template by name
     * @param  ?name the name to create the template
     * @return
     */
    public static function createTemplate(?name:String):Void
    {
        if (name == null)
        {
            Sys.println(" Creating default template");
            name = "basic";
        }

        if (name != "flashdevelop-basic") 
        {
            var templates = scanTemplates("", "", false);

            if (templates.get(name) != null)
            {
                var destination = Sys.getCwd() + commandsSet.projectName;

                Sys.println(" - Creating " + name);

                FileHelper.recursiveCopy(templates.get(name), destination);

                if (FileSystem.isDirectory(destination))
                {
                    modifyTemplate(destination);

                    Sys.println(" - Created " + name);
                    Sys.println(destination);
                }
                else
                {
                    Sys.println(" There was a problem creating " + destination);
                }
            }
            else
            {
                Sys.println(" Error there is no sample with the name of " + name);
            }
        }
        else
        {
            if (PlatformHelper.hostPlatform == Platform.WINDOWS)
            {
                var fdTemplatePath = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates/flashdevelop-basic/";
                helpers.ProcessHelper.openFile(fdTemplatePath, "FlxTemplate.fdz");
            } 
            else
            {
                Sys.println("Sorry Flash Develop only supports WINDOWS");
            }
        }
    }

    /**
     * Recursivley alter the template files
     * @param  templatePath to modify
     * @return
     */
    private static function modifyTemplate(templatePath:String):Void
    {
        for (fileName in FileSystem.readDirectory(templatePath))
        {
            if (FileSystem.isDirectory(templatePath + "/" + fileName))
            {
                Sys.println("File dir: " + templatePath + "/" + fileName);
                modifyTemplate(templatePath + "/" + fileName);
            }
            else
            {
                if (StringTools.endsWith(fileName, ".tpl"))
                {
                    var text = sys.io.File.getContent(templatePath + "/" + fileName);
                    text = projectTemplateReplacements(text);
                    var newFileName = projectTemplateReplacements(fileName.substr(0, -4));

                    var o = sys.io.File.write(templatePath + "/" + newFileName, true);
                    o.writeString(text);
                    o.close();

                    FileSystem.deleteFile(templatePath + "/" + fileName);
                }
            }
        }
    }

    /**
     * Process the template based on preset find and replacements from commandsSet
     * @param  source text from template file
     * @return  the altered text for the template file
     */
    public static inline function projectTemplateReplacements(source:String):String
    {
        source = StringTools.replace(source, "${PROJECT_NAME}", commandsSet.projectName);
        source = StringTools.replace(source, "${PROJECT_CLASS}", commandsSet.projectClass);
        source = StringTools.replace(source, "${WIDTH}", cast(commandsSet.projectWidth));
        source = StringTools.replace(source, "${HEIGHT}", cast(commandsSet.projectHeight));

        return source;
    }

    /**
     * Scan the templates Directory for listing them in the command line
     * @param  templatesPath the path to scan
     * @param  prefix the prefix to use while listing each template
     * @param  display whether to echo each template
     * @return  a Map containing the name of the template as the key and the template path as the value
     */
    public static function scanTemplates(templatesPath:String = "", prefix:String = " - ", display:Bool = true):Map<String, String>
    {
        var templatesPath = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates";
        var templates = new Map<String, String>();

        if(display)
            Sys.println("Listing templates from " + templatesPath);

        for (name in FileSystem.readDirectory(templatesPath))
        {
            if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(templatesPath + "/" + name))
            {
                if (display)
                    Sys.println(prefix + name);

                templates.set(name, templatesPath + "/" + name);
            }
        }
        return templates;
    }

    /**
     * Download the HaxeFlixel Samples from github using haxelib
     * @return
     */
    public static function downloadSamples():Void
    {
        var path = PathHelper.getHaxelib (new Haxelib ("flixel-samples"));

        if ( path == "")
        {
            Sys.command("haxelib git flixel-samples https://github.com/HaxeFlixel/flixel-samples.git");
            Sys.command("flixel list samples");
            Sys.println("");
            Sys.println(" Create a sample by name");
            Sys.println(" Usage : " + alias + " create <name>");
        }
        else
        {
            Sys.println( " You already have flixel-samples installed" );
            Sys.println( path );
        }
    }

    /**
     * Convert an old HaxeFlixel project
     * @return
     */
    public static function convertProject()
    {
        if(StringTools.startsWith(commandsSet.fromDir,"./"))
        {
            commandsSet.fromDir = commandsSet.fromDir.substring(2);
        }

        if(StringTools.endsWith( commandsSet.fromDir,"/" ))
        {
            commandsSet.fromDir = commandsSet.fromDir.substring(0,commandsSet.fromDir.length-1);
        }

        var convertProjectPath = Sys.getCwd() + commandsSet.fromDir;

        if(FileSystem.exists(convertProjectPath))
        {            
            Sys.println(" Converting :" + convertProjectPath);

            //backup existing project by renaming it with _bup suffix
            if(!commandsSet.noBackup)
            {
                var backupFolder = convertProjectPath + "_bup";
                if(!FileSystem.exists(backupFolder))
                    FileHelper.recursiveCopy(convertProjectPath, backupFolder);
            }

            convertProjectPath += "/source";
            convertProjectFolder(convertProjectPath);

            Sys.println(" Warning although this command updates a lot, its not perfect.");
            Sys.println(" Please visit haxeflixel.com/wiki/convert for further documentation on converting old code.");
        } else {
            Sys.println("Warning cannot find " + convertProjectPath);
        }
    }

    /**
     * Recursively use find and replace on *.hx files inside a project directory
     * @param  projectPath to recursivley scan
     * @return
     */
    public static function convertProjectFolder(projectPath:String)
    {
        for (fileName in FileSystem.readDirectory(projectPath))
        {
            if (FileSystem.isDirectory(projectPath + "/" + fileName))
            {
                convertProjectFolder(projectPath + "/" + fileName);
            }
            else
            {
                if (StringTools.endsWith(fileName, ".hx"))
                {
                    var filePath = projectPath + "/" + fileName;
                    var sourceText = sys.io.File.getContent(filePath);
                    var originalText = Reflect.copy(sourceText);

                    var replacements = HaxeFlixelLegacy.findAndReplaceMap;

                    for (fromString in replacements.keys())
                    {
                        var toString = replacements.get(fromString);
                        sourceText = StringTools.replace(sourceText, fromString, toString);
                    }

                    if(originalText != sourceText)
                    {
                        Sys.println( "Updated " + fileName );

                        FileSystem.deleteFile(filePath);
                        var o = sys.io.File.write(filePath, true);
                        o.writeString(sourceText);
                        o.close();
                    }
                }
            }
        }
    }

    /**
     * Validate an openfl project by compiling it and checking the result
     * @return
     */
    public static function validateProject()
    {
        if(commandsSet.recursive)
        {
            compileAllSamples();
        }
        else 
        {
            if(StringTools.startsWith(commandsSet.fromDir,"./"))
            {
                commandsSet.fromDir = commandsSet.fromDir.substring(2);
            }

            if(StringTools.endsWith( commandsSet.fromDir,"/" ))
            {
                commandsSet.fromDir = commandsSet.fromDir.substring(0,commandsSet.fromDir.length-1);
            }

            //todo
            var validateProjectPath = Sys.getCwd() + commandsSet.fromDir;
            Sys.println("Validate " + validateProjectPath);
        }
    }

    /**
     * Build an openfl target
     * @param  target the openfl target to build
     * @param  project the project object to build from
     * @param  display echo progress on the command line
     * @return BuildResult the result of the compilation
     */
    public static function buildProject(target:String, project:SampleProject, display:Bool = false):BuildResult
    {
        if(target == "native")
        {
            if (PlatformHelper.hostPlatform == Platform.WINDOWS)
            {
                target = "windows";
            }
            else if( PlatformHelper.hostPlatform == Platform.MAC )
            {
                target = "mac";
            } 
            else if (PlatformHelper.hostPlatform == Platform.LINUX)
            {
                target = "linux";
            }
        }

        var buildCommand = "haxelib run openfl build " + project.PROJECTXMLPATH + " " + target;

        if(display)
        {
            Sys.println("");
            Sys.println(" Compile " + target + ":: " + buildCommand);
        }

        var compile = Sys.command(buildCommand);

        if(display)
        {
            Sys.println("");
            Sys.println(" " + target + "::" + getResult(compile));
        }

        var project:BuildResult = 
        { 
            result : getResult(compile),
            project : project,
        };
        
        return project;
    }

    /**
     * Return a friendly result string based on an Int value
     * @param  result
     * @return string PASSED or FAILED
     */
    public static inline function getResult(result:Int):String
    {  
        if(result == 0)
        {
            return PASSED;
        }
        else
        {
            return FAILED;
        }
    }

    /**
     * Copy the simple bash or bat scripts to your system depending on the OS
     * It will enable the flixel command alias after you run setup
     * @return
     */
    public static function setupTools():Void
    {
        var haxePath = Sys.getEnv("HAXEPATH");

        if (PlatformHelper.hostPlatform == Platform.WINDOWS)
        {
            if (haxePath == null || haxePath == "")
            {
                haxePath = "C:\\HaxeToolkit\\haxe\\";
            }
            File.copy(PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "\\\\bin\\flixel.bat", haxePath + "\\flixel.bat");
        }
        else
        {
            if (haxePath == null || haxePath == "")
            {
                haxePath = "/usr/lib/haxe";
            }
            Sys.command("sudo", [ "cp", PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "bin/flixel.sh", haxePath + "/flixel" ]);
            Sys.command("sudo chmod 755 " + haxePath + "/flixel");
            Sys.command("sudo ln -s " + haxePath + "/flixel /usr/bin/flixel");
        }

        Sys.println("You have now setup HaxeFlixel");
        Sys.command("flixel");
    }

    /**
     * Process the command arguments
     * @return a Commands Class with the value of the commands to execute
     */
    private static function processArguments():Commands
    {

        var arguments = Sys.args();
        // Sys.println(arguments.toString());

        if (arguments.length > 0)
        {
            // Last argument is the current haxelib path
            var lastArgument = "";

            for (i in 0...arguments.length)
            {
                lastArgument = arguments.pop();
                if (lastArgument.length > 0) break;
            }

            lastArgument = new Path (lastArgument).toString();

            if (((StringTools.endsWith(lastArgument, "/") && lastArgument != "/") || StringTools.endsWith(lastArgument, "\\")) && !StringTools.endsWith(lastArgument, ":\\"))
            {
                lastArgument = lastArgument.substr(0, lastArgument.length - 1);
            }
            //set the current directory to the haxelib
            if (FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument))
            {
                // toolsPath = lastArgument;
                Sys.setCwd(lastArgument);
            }
        }

        commandsSet = new Commands();

        var length = arguments.length;
        var index = 0;

        if (arguments[index] == "help")
        {
            commandsSet.help = true;
        }
        else if (arguments[index] == "create")
        {
            commandsSet.create = true;
            if (arguments[index++] != null)
                commandsSet.createName = arguments[index++];
        }
        else if (arguments[index] == "list")
        {
            commandsSet.list = true;
            processListArgs(arguments);
        }
        else if (arguments[index] == "setup")
        {
            commandsSet.setup = true;
        }
        else if (arguments[index] == "template")
        {
            commandsSet.template = true;
            processTemplateArgs(arguments);
        }
        else if (arguments[index] == "convert")
        {
            processConvertArgs(arguments);
        }
        else if (arguments[index] == "validate")
        {
            commandsSet.validate = true;
            processValidateArgs(arguments);
        }
        else if (arguments[index] == "download")
        {
            commandsSet.download = true;
        }

        processAdditionalArgs(arguments);

        return commandsSet;
    }

    private static inline function processValidateArgs(args:Array<String>):Void
    {
        if( args[1]!=null)
        {
            commandsSet.fromDir = args[1];
        } 
        else
        {
            Sys.println("Warning, you have not set a project Path for validate");
        }
    }

    private static inline function processConvertArgs(args:Array<String>):Void
    {
        if( args[1]!=null)
        {
            commandsSet.fromDir = args[1];
            commandsSet.convert = true;
        }
        else
        {
            Sys.println("Warning, you have not set a project Path for convert");
        }
    }

    private static inline function processListArgs(args:Array<String>):Void
    {
        var index = 0;
        var length = args.length;

        while (index < args.length)
        {
            if (args[index] == "samples")
            {
                index++;
                commandsSet.listSamples = true;
            }
            else if (args[index] == "templates")
            {
                index++;
                commandsSet.listTemplates = true;
            }
            index++;
        }
    }

    private static inline function processTemplateArgs(args:Array<String>):Void
    {
        var index = 0;
        var length = args.length;

        while (index < args.length)
        {
            if (args[index] == "-name" && index + 1 < length)
            {
                index++;
                commandsSet.projectName = args[index];
            }
            else if (args[index] == "-class" && index + 1 < length)
            {
                index++;
                commandsSet.projectClass = args[index];
            }
            else if (args[index] == "-screen" && index + 2 < length)
            {
                index++;
                commandsSet.projectWidth = cast(args[index]);
                index++;
                commandsSet.projectHeight = cast(args[index]);
            }
            else if (args[index] != null && args[index] != 'template')
            {
                commandsSet.createName = cast(args[index]);
            }
            index++;
        }
    }

    private static inline function processAdditionalArgs(args:Array<String>):Void
    {
        var index = 0;
        var length = args.length;

        while (index < args.length)
        {
            if (args[index] == "-R")
            {
                index++;
                commandsSet.recursive = true;
            }
            else if (args[index] == "-B")
            {
                index++;
                commandsSet.noBackup = true;
            }

            index++;
        }
    }

    /**
     * Validate all the samples recursivley
     * @param  location of the samples directory to scan and validate
     * @return
     */
    public static function compileAllSamples(location:String = ""):Void
    {
        if(location=="")
        {
            Sys.println(" Copying all samples into the current working directory.");

            var samplesPath = PathHelper.getHaxelib(new Haxelib ("flixel-samples"));
            location = Sys.getCwd() + "flixel-samples-validation/";
            FileHelper.recursiveCopy(samplesPath, location);
        }

        var projects = scanProjectXML(location,false);

        var results = new Array<BuildResult>();
        var flashOnly = new Array<SampleProject>();
        var nonFlash = new Array<SampleProject>();
        var allTargets = new Array<SampleProject>();

        Sys.println(" " + Lambda.count(projects) + " samples available to compile.");

        for ( project in projects.keys() )
        {
            var projectObject = projects.get(project);
            var sampleProject:SampleProject = projectObject;

            if(sampleProject.TARGETS != null)
            {            
                if(sampleProject.TARGETS == "FlashOnly")
                {
                    flashOnly.push(sampleProject);
                }
                else if(sampleProject.TARGETS == "NonFlash")
                {
                    nonFlash.push(sampleProject);
                }
                else if(sampleProject.TARGETS == "All") 
                {
                    allTargets.push(sampleProject); 
                }
            }
            else  
            {
                Sys.println(" Error no valid samples were found.");
                return;
            }
        }

        Sys.println("");
        Sys.println(" - Samples for all targets");

        for ( sample in allTargets )
        {
            var sampleProject:SampleProject = sample;
            Sys.println(" Building::" + sampleProject.NAME);

            results.push(buildProject("flash", sampleProject));
            // results.push(buildProject("neko", sampleProject));
            // results.push(buildProject("native", sampleProject));
            // results.push(buildProject("html5", sampleProject));
        }

        Sys.println("");
        Sys.println(" - Samples Flash target only");

        for ( sample in flashOnly )
        {
            var sampleProject:SampleProject = sample;
            Sys.println(" Building::" + sampleProject.NAME);

            results.push(buildProject("flash", sampleProject));

        }

        Sys.println("");
        Sys.println(" - Samples for CPP target only");

        for ( sample in nonFlash )
        {
            var sampleProject:SampleProject = sample;
            Sys.println(" Building::" + sampleProject.NAME);

            results.push(buildProject("neko", sampleProject));
            // results.push(buildProject("native", sampleproject));
        }

        Sys.println ("");

        for ( result in results )
        {
            var sampleProjectResult:BuildResult = result;
            Sys.println ("-------------------------------------------------");
            Sys.println (sampleProjectResult.project.NAME);
            Sys.println (sampleProjectResult.result);
            Sys.println (sampleProjectResult.project.TARGETS);
            Sys.println (sampleProjectResult.project.PROJECTXMLPATH);
            Sys.println ("-------------------------------------------------");
        }
    }

    /**
    *   Scans a path for openfl/nme project files
    *   @author Joshua Granick a private method in openfl-tools
    *   @return the path of the project file found
    **/
    private static function findProjectFile(path:String):String
    {
        if (FileSystem.exists(PathHelper.combine(path, "Project.hx")))
        {
            return PathHelper.combine(path, "Project.hx");
        }
        else if (FileSystem.exists(PathHelper.combine(path, "project.nmml")))
        {
            return PathHelper.combine(path, "project.nmml");
        }
        else if (FileSystem.exists(PathHelper.combine(path, "project.xml")))
        {
            return PathHelper.combine(path, "project.xml");
        }
        else
        {
            var files = FileSystem.readDirectory(path);
            var matches = new Map <String, Array <String>> ();
            matches.set("nmml", []);
            matches.set("xml", []);
            matches.set("hx", []);

            for (file in files)
            {
                var path = PathHelper.combine(path, file);

                if (FileSystem.exists(path) && !FileSystem.isDirectory(path))
                {
                    var extension = Path.extension(file);

                    if ((extension == "nmml" && file != "include.nmml") || (extension == "xml" && file != "include.xml") || extension == "hx")
                    {
                        matches.get(extension).push(path);
                    }
                }
            }

            if (matches.get("nmml").length > 0)
            {
                return matches.get("nmml")[0];
            }

            if (matches.get("xml").length > 0)
            {
                return matches.get("xml")[0];
            }

            if (matches.get("hx").length > 0)
            {
                return matches.get("hx")[0];
            }
        }
        return "";
    }

    /**
    *   Use of findProjectFile from openfl-tools to find the project files of all samples
    **/
    public static function scanProjectXML(samplesPath:String = "", display:Bool = false):Map<String, SampleProject>
    {
        if(samplesPath == "")
        {
            samplesPath = PathHelper.getHaxelib(new Haxelib ("flixel-samples"));
        }

        if(display)
        {
            Sys.println(" Scan for samples in::" + samplesPath);
        }

        var samples = new Map<String, SampleProject>();

        for (name in FileSystem.readDirectory(samplesPath))
        {
            var folderPath = samplesPath + "/" + name;

            if(display)
                Sys.println(" ScanningFolder::" + samplesPath);
            
            if ( !StringTools.startsWith(name, ".") && FileSystem.isDirectory(folderPath) )
            {
                var projectXMLPath = findProjectFile(folderPath);

                if(display)
                    Sys.println(" ProjectXMLResult::" + projectXMLPath);

                if (projectXMLPath == "")
                {
                    if(name == "FlashOnly" || name == "NonFlash")
                    {
                        var subpath = folderPath;
                        var moreSamples = scanProjectXML(subpath,display);

                        for ( sample in moreSamples.keys() )
                        {
                            var projectObject = moreSamples.get(sample);
                            var project:SampleProject = projectObject;
                            project.TARGETS = name;

                            if (FileSystem.exists(project.PATH))
                            {
                                samples.set(project.NAME, project);
                            }
                        }
                    }
                }
                else
                {
                    var project:SampleProject = 
                    { 
                        NAME : name,
                        PATH : folderPath,
                        PROJECTXMLPATH : projectXMLPath,
                        TARGETS : "All",
                    };

                    if (FileSystem.exists(project.PATH))
                    {
                        samples.set(project.NAME, project);

                        if(display)
                            Sys.println(" Project::" + project);
                    }
                }
            }
        }
        return samples;
    }

   /**
     * Create a sample by recursivly copying the folder according to a name
     * @param  ?name the name of the sample to create
     * @return
     */
    public static function createSample(?name:String):Void
    {
        if (name == null)
        {
            Sys.println(" You have not provided a name to create.");
            Sys.println(" To list available templates and samples use the list command");
            Sys.println(" Usage : flixel list");
        }

        var samples = scanSamples("", "", false);

        if (samples.get(name) != null)
        {
            Sys.println(" - Creating " + name);

            var destination = Sys.getCwd() + name;
            FileHelper.recursiveCopy(samples.get(name), destination);

            if (FileSystem.isDirectory(destination))
            {
                Sys.println(" - Created " + name);
                Sys.println(destination);
            }
            else
            {
                Sys.println(" There was a problem creating " + destination);
            }
        }
        else
        {
            Sys.println(" Error there is no sample with the name of " + name);
        }
    }

    public static function scanSamples(samplesPath:String = "", prefix:String = " - ", display:Bool = true):Map<String, String>
    {
        // Sys.println("scan::" + samplesPath);

        if (samplesPath == "")
            samplesPath = PathHelper.getHaxelib(new Haxelib ("flixel-samples"));

        if(display)
            Sys.println("Listing samples from " + samplesPath);

        var samples = new Map<String, String>();

        for (name in FileSystem.readDirectory(samplesPath))
        {
                // Sys.println(name);
            if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(samplesPath + "/" + name))
            {
                if (name == "FlashOnly")
                {
                    if (display)
                    {
                        Sys.println(" - - (Flash Target Only)");
                    }

                    var flashOnlyPath = samplesPath + "FlashOnly/";
                    var flashOnlySamples = scanSamples(flashOnlyPath, " - - - ", display);
                    for (FlashOnlyName in flashOnlySamples.keys())
                    {
                        var key = flashOnlySamples.get(FlashOnlyName);
                        samples.set(key, FlashOnlyName);
                    }
                }
                else if (name == "NonFlash")
                {
                    if (display)
                    {
                        Sys.println(" - - (Non Flash Targets Only)");
                    }

                    var nonFlashPath = samplesPath + "NonFlash/";
                    var nonFlashSamples = scanSamples(nonFlashPath, " - - - ", display);
                    for (nonFlashName in nonFlashSamples.keys())
                    {
                        var key = nonFlashSamples.get(nonFlashName);
                        samples.set(key, nonFlashName);
                    }
                }
                else
                {
                    if (display)
                        Sys.println(prefix + name);

                    if (FileSystem.exists(samplesPath + name))
                    {
                        samples.set(name, samplesPath + name);
                    }
                }
            }
        }

        return samples;
    }

}

/**
 * Object used to process the command arguments
 * 
 */
class Commands
{
    public var validate:Bool = false;

    public var convert:Bool = false;

    public var help:Bool = false;

    public var download:Bool = false;

    public var setup:Bool = false;

    public var recursive:Bool = false;
    public var noBackup:Bool = false;

    public var create:Bool = false;
    public var createName:String;

    public var list:Bool = false;
    public var listSamples:Bool = false;
    public var listTemplates:Bool = false;

    public var template:Bool = false;

    public var projectName:String = "HaxeFlixelTemplate";
    public var projectClass:String = "HaxeFlixelTemplate";
    public var projectWidth:Int = 700;
    public var projectHeight:Int = 600;

    public var fromDir:String = "";
    public var toDir:String = "";

    public function new():Void {}
}

/**
 * Object to pass the build result of a project
 */
typedef BuildResult =
{
    private var result:String;
    private var project:SampleProject;
}

/**
 * Object to pass the data of a project
 */
typedef SampleProject =
{
    private var NAME:String;
    private var PATH:String;
    private var PROJECTXMLPATH:String;   
    private var TARGETS:String;   
}

/**
 * Definition of a haxelib json file
 */
typedef HaxelibJSON = {
    name:String,
    url:String,
    license:String,
    tags:Array<String>,
    description:String,
    version:String,
    releasenote:String,
    contributors:Array<String>,
    dependencies:Dynamic
}