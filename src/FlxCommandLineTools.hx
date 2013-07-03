package;

import helpers.FileHelper;
import sys.io.FileOutput;
import haxe.io.Bytes;
import haxe.io.Path;
import project.Haxelib;
import project.Platform;
import helpers.PathHelper;
import helpers.PlatformHelper;
import sys.FileSystem;
import sys.io.File;

class FlxCommandLineTools
{
    public static var name = "HaxeFlixel";
    public static var alias = "flixel";
    public static var version = "0.0.1";

    public static var templatesPath:String;
    public static var legacyConversionScriptPath:String;
    public static var as3ConversionScriptPath:String;

    public static var commandsSet:Commands;
    public static var replacements:Map<String, String>;

    public static function main():Void
    {
        commandsSet = processArguments();
        //        Sys.println(commandsSet);

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
        else
        {
            displayInfo(true);
        }
    }

    private static function displayInfo(showHint = false):Void
    {
        Sys.println(" _   _               ______ _ _          _");
        Sys.println("| | | |              |  ___| (_)        | |");
        Sys.println("| |_| | __ ___  _____| |_  | |___  _____| |");
        Sys.println("|  _  |/ _` \\ \\/ / _ \\  _| | | \\ \\/ / _ \\ |");
        Sys.println("| | | | (_| |>  <  __/ |   | | |>  <  __/ |");
        Sys.println("\\_| |_/\\__,_/_/\\_\\___\\_|   |_|_/_/\\_\\___|_|");
        Sys.println("Please visit www.haxeflixel.com for community support and resources.");
        Sys.println("");

        Sys.println(name + " Command-Line Tools (" + version + ")");

        if (showHint)
        {
            Sys.println("Use \"" + alias + " help\" for available commands");
        }

        Sys.println("");
    }

    private static function displayHelp():Void
    {
        Sys.println("");

        Sys.println(name + " Command-Line Tools (" + version + ")");

        Sys.println("");

        Sys.println(" List all the project templates you can create");
        Sys.println(" Usage : " + alias + " create project <name>");

        Sys.println("");

        Sys.println(" Create project and templates you can create");
        Sys.println(" Usage : " + alias + " create <name>");

        Sys.println("");

        Sys.println(" List all the samples you can create");
        Sys.println(" Usage : " + alias + " create list");

        Sys.println("");

        Sys.println(" Simple conversion tool for old HaxeFlixel projects");
        Sys.println(" Usage : " + alias + " convert <path> [options]");

        Sys.println("");

        Sys.println(" To compile your HaxeFlixel projects use the openfl commands");
        Sys.println(" Usage : openfl help");

        Sys.println("");
    }

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
            var destination = Sys.getCwd() + name;

            Sys.println(" - Creating " + name);
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

    public static function validateProject()
    {
    //todo
//        if( commandsSet.fromDir == null || commandsSet.toDir == null )
//        {
//            Sys.println(" Error did not get a from and to directory");
//            return;
//        }

//        var projectXML
    }

    public static function scanSamples(samplesPath:String = "", prefix:String = " - ", display:Bool = true):Map<String, String>
    {
        if (samplesPath == "")
            samplesPath = PathHelper.getHaxelib(new Haxelib ("flixel-samples"));

        var samples = new Map<String, String>();

        for (name in FileSystem.readDirectory(samplesPath))
        {
            if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(samplesPath + "/" + name))
            {
                if (name == "FlashOnly")
                {
                    if (display)
                    {
                        Sys.println(" - - (Flash Target Only)");
                    }
                    for (o in scanSamples(samplesPath + "/FlashOnly", " - - - ", display))
                    {
                        samples.set(name, o);
                    }
                }
                else if (name == "NonFlash")
                {
                    if (display)
                    {
                        Sys.println(" - - (Non Flash Targets Only)");
                    }

                    for (o in scanSamples(samplesPath + "/NonFlash", " - - - ", display))
                    {
                        samples.set(name, o);
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

    public static function createTemplate(?name:String):Void
    {
        if (name == null)
        {
            Sys.println(" Creating default template");
            name = "basic";
        }

        var templates = scanTemplates("", "", false);

        if (templates.get(name) != null)
        {
            var destination = Sys.getCwd() + name;

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

    public static function scanTemplates(templatesPath:String = "", prefix:String = " - ", display:Bool = true):Map<String, String>
    {
        var templatesPath = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates";
        var templates = new Map<String, String>();

        if (display)
        {
            Sys.println("");
            Sys.println(" HaxeFlixel Template Listing");
        }

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

    public static function convertProject()
    {
        var convertProjectPath = Sys.getCwd() + commandsSet.fromDir;

        Sys.println(" Converting :" + convertProjectPath);
        Sys.println(" *DONT PANIC! warning convert is only a simple find and replace script");
        Sys.println(" Please visit haxeflixel.com/wiki/convert for further documentation on converting old code.");

        initLegacyFlixelReplacements();


        //backup existing project by renaming it with _bup prefix
        var backupFolder = convertProjectPath + "_bup";
        if(!FileSystem.exists(backupFolder))
            FileHelper.recursiveCopy(convertProjectPath, backupFolder);

//        Sys.println(convertProjectPath);
//        Sys.println(bakupFolder);

        convertProjectFolder(convertProjectPath);
    }

    public static function convertProjectFolder(projectPath:String)
    {
        for (fileName in FileSystem.readDirectory(projectPath))
        {
//            Sys.println(fileName);

//
            if (FileSystem.isDirectory(projectPath + "/" + fileName))
            {
//                Sys.println("File dir: " + projectPath + "/" + fileName);


                if(fileName == "source")
                {
                    Sys.println("File dir: " + fileName);
//                    Sys.println("folder: " + projectPath + "/" + fileName);
                    convertProjectFolder(projectPath + "/" + fileName);
                }

            }
            else
            {
                if (StringTools.endsWith(fileName, ".hx"))
                {

                    var filePath = projectPath + "/" + fileName;
                    Sys.println(filePath);
                    var sourceText = sys.io.File.getContent(filePath);
                    var originalText = Reflect.copy(sourceText);


                    for (fromString in replacements.keys())
                    {
                        var toString = replacements.get(fromString);
                        sourceText = StringTools.replace(sourceText, fromString, toString);
                    }
//
                    if(originalText != sourceText)
                    {
                        Sys.println( "Updated " + fileName );
                        FileSystem.deleteFile(filePath);
                        var o = sys.io.File.write(filePath, true);
                        o.writeString(sourceText);
                        o.close();
//
                    }

                }
            }
        }
    }

    /**
    *   Copy the simple bash or bat scripts to your system depending on the OS
    *   It will enable the flixel command alias after you run setup
    **/

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
    }

    private static function processArguments():Commands
    {

        var arguments = Sys.args();

        //        Sys.println(arguments.toString());

        if (arguments.length > 0)
        {
            // When the command-line tools are called from Haxelib,
            // the last argument is the project directory and the
            // path to this Haxelib is the current working directory

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

            if (FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument))
            {
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
            commandsSet = processListArgs(arguments, commandsSet);
        }
        else if (arguments[index] == "setup")
        {
            commandsSet.setup = true;
        }
        else if (arguments[index] == "new")
        {
            commandsSet.template = true;
            commandsSet = processTemplateArgs(arguments, commandsSet);
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

        return commandsSet;
    }

    private static function processValidateArgs(args:Array<String>):Void
    {
        if( args[1]!=null)
            commandsSet.fromDir = args[1];

        if( args[2]!=null)
            commandsSet.toDir = args[2];
    }

    private static function processConvertArgs(args:Array<String>):Void
    {
        if( args[1]!=null)
        {
            commandsSet.fromDir = args[1];
            commandsSet.convert = true;
        } else {
            Sys.println("Warning, you have not set a project Path for convert");
        }
    }

    private static function processListArgs(args:Array<String>, result:Commands):Commands
    {
        var index = 0;
        var length = args.length;

        while (index < args.length)
        {
            if (args[index] == "samples")
            {
                index++;
                result.listSamples = true;
            }
            else if (args[index] == "templates")
            {
                index++;
                result.listTemplates = true;
            }
            index++;
        }

        return result;
    }

    private static function processTemplateArgs(args:Array<String>, result:Commands):Commands
    {
        var index = 0;
        var length = args.length;

        while (index < args.length)
        {
            if (args[index] == "-name" && index + 1 < length)
            {
                index++;
                result.projectName = args[index];
            }
            else if (args[index] == "-class" && index + 1 < length)
            {
                index++;
                result.projectClass = args[index];
            }
            else if (args[index] == "-screen" && index + 2 < length)
            {
                index++;
                result.projectWidth = cast(args[index]);
                index++;
                result.projectHeight = cast(args[index]);
            }
            else if (args[index] != null && args[index] != 'new')
            {
                result.createName = cast(args[index]);
            }
            index++;
        }

        return result;
    }

    private static function trimPath(path:String)
    {
        return new Path(path).dir;
    }

    public static function projectTemplateReplacements(source:String):String
    {
        source = StringTools.replace(source, "${PROJECT_NAME}", commandsSet.projectName);
        source = StringTools.replace(source, "${PROJECT_CLASS}", commandsSet.projectClass);
        source = StringTools.replace(source, "${WIDTH}", cast(commandsSet.projectWidth));
        source = StringTools.replace(source, "${HEIGHT}", cast(commandsSet.projectHeight));

        return source;
    }

    //todo
    public static function initLegacyFlixelReplacements():Void
    {
        replacements = new Map<String, String>();

        //org package
        replacements.set( "org.flixel.", "flixel." );

        //system
        replacements.set( "flixel.FlxAssets", "flixel.system.FlxAssets" );

        //FlxU
        replacements.set( "FlxG.camera.", "flixel." );

        //FrontEnds
        replacements.set( "FlxG.bgColor", "FlxG.state.bgColor" );

        //cameras
        replacements.set( "FlxG.resetCameras", "FlxG.cameras.reset" );

        //addons
        replacements.set( "flixel.addons.FlxCaveGenerator", "flixel.addons.tile.FlxCaveGenerator" );

        //tile
        replacements.set( "flixel.FlxTilemap", "flixel.tile.FlxTilemap" );
        replacements.set( "flixel.system.FlxTile", "flixel.tile.FlxTile" );

        //effects
        replacements.set( "flixel.FlxEmitter", "flixel.effects.particles.FlxEmitter" );

        //text
        replacements.set( "flixel.FlxText", "flixel.text.FlxText" );
        replacements.set( "flixel.FlxTextField", "flixel.text.FlxTextField" );
    }

    /**
    *   Use of findProjectFile from openfl-tools to find the project files of all samples
    **/

    public static function scanProjectXML(samplesPath:String = ""):Map<String, String>
    {
        var projects = new Map<String, String>();

        if (samplesPath == "")
            samplesPath = PathHelper.getHaxelib(new Haxelib ("flixel-samples"));

        //todo nonflash flash
        for (name in FileSystem.readDirectory(samplesPath))
        {
            if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(samplesPath + "/" + name))
            {

                if (FileSystem.exists(samplesPath + name))
                {
                    var projectFile = findProjectFile(samplesPath + name);
                    if (projectFile != "")
                    {
                        projects.set(name, projectFile);
                    }

                    Sys.println(projectFile);
                }
            }
        }
        return projects;
    }

    /**
    *   Scans a path for openfl/nme project files
    *   @from a private method in openfl-tools
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
}

/**
*   Object used to process the command arguments
**/
class Commands
{
    public var validate:Bool = false;

    public var convert:Bool = false;

    public var help:Bool = false;

    public var setup:Bool = false;

    public var create:Bool = false;
    public var createName:String;

    public var list:Bool = false;
    public var listSamples:Bool = false;
    public var listTemplates:Bool = false;

    public var template:Bool = false;

    public var projectName:String = "HaxeFlixel";
    public var projectClass:String = "HaxeFlixel";
    public var projectWidth:Int = 700;
    public var projectHeight:Int = 600;

    public var fromDir:String = "";
    public var toDir:String = "";

    public function new():Void
    {

    }
}