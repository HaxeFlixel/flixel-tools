package;

import utils.PathHelper;
import utils.CommandLine;
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
import legacy.Warnings;
import legacy.FindAndReplace;

/**
 * Flixel-Tools
 * Command line utility to create flixel demos, project templates and more.
 * Ability to batch compile the demos for validation
 * Basic find and replace tool for old HaxeFlixel code
 *
 * @author Chris Decoster aka impaler
 * @author Joshua Granick for methods used from openfl-tools
 * @thanks to HaxeFlixel contributors & Gama11 for cleanups :)
 */
class FlxTools
{
	inline static public var NAME = "HaxeFlixel";
	inline static public var ALIAS = "flixel";
	inline static public var VERSION = "0.0.1";

	static public var flixelVersion:String;

	// Parsed commands to execute
	static public var commandsSet:Commands;

	// Build Results
	inline static public var PASSED:String = "PASSED";
	inline static public var FAILED:String = "FAILED";

	/**
	 * Echo some information about HaxeFlixel to the command line
	 */
	static private function displayInfo():Void
	{
		// Get the current flixel version
		if (flixelVersion == null) 
		{
			var flixelHaxelib:HaxelibJSON = CommandLine.getHaxelibJsonData("flixel");
			flixelVersion = flixelHaxelib.version;
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
		Sys.println("     Please visit www.haxeflixel.com for community support and resources!");
		Sys.println("");
		Sys.println("                    " + NAME + " Command-Line Tools (" + VERSION + ")");
		
		if (flixelVersion == "0.0.1")   
		{
			Sys.println("                     flixel is currently not installed!");
		}
		else 
		{
			Sys.println("                   Installed flixel version: " + flixelVersion);
		}
		
		Sys.println("                   Use \"" + ALIAS + " help\" for available commands");
		Sys.println("");
	}

	static public function main():Void
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
			createDemo(commandsSet.createName);
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
			if (!commandsSet.listDemos && !commandsSet.listTemplates)
			{
				scanTemplates();
				Sys.println("");
				listAllDemos("",true);
			}
			else if (commandsSet.listDemos)
			{
				listAllDemos("",true);
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
			downloadDemos();
		}
		else
		{
			displayInfo();
		}
	}

	/**
	 * Display a listing of available commands
	 */
	static private function displayHelp():Void
	{
		Sys.println("");
		
		Sys.println(NAME + " Command-Line Tools (" + VERSION + ")");
		
		Sys.println("");
		
		Sys.println(" Setup the tools to use the " + ALIAS + " alias");
		Sys.println(" Usage : haxelib run " + ALIAS + "-tools setup");
		
		Sys.println("");
		
		Sys.println(" Create a demo by name");
		Sys.println(" Usage : " + ALIAS + " create <name>");
		
		Sys.println("");
		
		Sys.println(" Create a project template");
		Sys.println(" Usage : " + ALIAS + " template -name <project_name> -screen <width_value> <height_value>");
		
		Sys.println("");
		
		Sys.println(" List available demos and templates");
		Sys.println(" Usage : " + ALIAS + " list");
		
		Sys.println("");
		
		Sys.println(" Download all the HaxeFlixel demos");
		Sys.println(" Usage : " + ALIAS + " download demos");
		
		Sys.println("");
		
		Sys.println(" List available demos");
		Sys.println(" Usage : " + ALIAS + " list demos");
		
		Sys.println("");
		
		Sys.println(" List available templates");
		Sys.println(" Usage : " + ALIAS + " list templates");
		
		Sys.println("");
		
		Sys.println(" To compile your HaxeFlixel projects use the openfl");
		Sys.println(" Usage : openfl help");
		
		Sys.println("");
	}

	/**
	 * Create a template by name
	 * 
	 * @param   Name    The name to create the template
	 */
		static public function createTemplate(?Name:String):Void
	{
		if (Name == null)
		{
			Sys.println(" Creating default template");
			Name = "basic";
		}
		
		if (Name == "flashdevelop-basic") 
		{
			if (PlatformHelper.hostPlatform == Platform.WINDOWS)
			{
				var fdTemplatePath:String = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates/flashdevelop-basic/";
				helpers.ProcessHelper.openFile(fdTemplatePath, "FlxTemplate.fdz");
			} 
			else
			{
				Sys.println("Sorry Flash Develop only supports WINDOWS");
			}
		}
		else
		{
			var templates = scanTemplates("", "", false);
			
			if (templates.get(Name) != null)
			{
				var destination:String = Sys.getCwd() + commandsSet.projectName;
				
				Sys.println(" - Creating " + Name);
				
				FileHelper.recursiveCopy(templates.get(Name), destination);
				
				if (FileSystem.isDirectory(destination))
				{
					modifyTemplate(destination);
					
					Sys.println(" - Created " + Name);
					Sys.println(destination);
				}
				else
				{
					Sys.println(" There was a problem creating " + destination);
				}
			}
			else
			{
				Sys.println(" Error there is no demo with the name of " + Name);
			}
		}
	}

	/**
	 * Recursivley alter the template files
	 * 
	 * @param   TemplatePath    Temaplte path to modify
	 */
	static private function modifyTemplate(TemplatePath:String):Void
	{
		for (fileName in FileSystem.readDirectory(TemplatePath))
		{
			if (FileSystem.isDirectory(TemplatePath + "/" + fileName))
			{
				Sys.println("File dir: " + TemplatePath + "/" + fileName);
				modifyTemplate(TemplatePath + "/" + fileName);
			}
			else
			{
				if (StringTools.endsWith(fileName, ".tpl"))
				{
					var text:String = sys.io.File.getContent(TemplatePath + "/" + fileName);
					text = projectTemplateReplacements(text);
					var newFileName:String = projectTemplateReplacements(fileName.substr(0, -4));
					
					var o:FileOutput = sys.io.File.write(TemplatePath + "/" + newFileName, true);
					o.writeString(text);
					o.close();
					
					FileSystem.deleteFile(TemplatePath + "/" + fileName);
				}
			}
		}
	}

	/**
	* Process the template based on preset find and replacements from commandsSet
	* 
	* @param    Source  Text from template file
	* @return   The altered text for the template file
	*/
	inline static public function projectTemplateReplacements(Source:String):String
	{
		Source = StringTools.replace(Source, "${PROJECT_NAME}", commandsSet.projectName);
		Source = StringTools.replace(Source, "${WIDTH}", cast(commandsSet.projectWidth));
		Source = StringTools.replace(Source, "${HEIGHT}", cast(commandsSet.projectHeight));
		
		return Source;
	}

	/**
	 * Scan the templates Directory for listing them in the command line
	 * 
	 * @param   TemplatePath    The path to scan
	 * @param   Prefix          The prefix to use while listing each template
	 * @param   Display         Whether to echo each template
	 * @return  A Map containing the name of the template as the key and the template path as the value
	 */
	static public function scanTemplates(TemplatePath:String = "", Prefix:String = " - ", Display:Bool = true):Map<String, String>
	{
		TemplatePath = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates";
		var templates = new Map<String, String>();
		
		if (Display)
		{
			Sys.println("");
			Sys.println(" Listing templates from:" );
			Sys.println(" " + TemplatePath );
		}
		
		for (name in FileSystem.readDirectory(TemplatePath))
		{
			if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(TemplatePath + "/" + name))
			{
				if (Display)
				{
					Sys.println(Prefix + name);
				}
				
				templates.set(name, TemplatePath + "/" + name);
			}
		}
		
		return templates;
	}

	/**
	 * Download the HaxeFlixel Demos from github using haxelib
	 */
	static public function downloadDemos():Void
	{
		var path:String = PathHelper.getHaxelib(new Haxelib("flixel-demos"));
		
		if (path == "")
		{
			Sys.command("haxelib git flixel-demos https://github.com/HaxeFlixel/flixel-demos.git");
			Sys.command("flixel list demos");
			Sys.println("");
			Sys.println(" Create a demo by name");
			Sys.println(" Usage : " + ALIAS + " create <name>");
		}
		else
		{
			Sys.println( " You already have flixel-demos installed" );
			Sys.println(path);
		}
	}

	/**
	 * Convert an old HaxeFlixel project
	 */
	static public function convertProject():Void
	{
		if (StringTools.startsWith(commandsSet.fromDir,"./"))
		{
			commandsSet.fromDir = commandsSet.fromDir.substring(2);
		}
		
		if (StringTools.endsWith( commandsSet.fromDir,"/" ))
		{
			commandsSet.fromDir = commandsSet.fromDir.substring(0,commandsSet.fromDir.length-1);
		}
		
		var convertProjectPath = Sys.getCwd() + commandsSet.fromDir;
		
		if (FileSystem.exists(convertProjectPath))
		{            
			Sys.println(" Converting :" + convertProjectPath);
			
			// Backup existing project by renaming it with _backup suffix
			if (!commandsSet.noBackup)
			{
				var backupFolder = convertProjectPath + "_backup";
	
				if(!FileSystem.exists(backupFolder))
				{
					FileHelper.recursiveCopy(convertProjectPath, backupFolder);
				}
			}
			
			if(FileSystem.exists(convertProjectPath))
			{
				var warnings = convertProjectFolder(convertProjectPath, true);

				Sys.println("");
				Sys.println(warnings.length + " Warnings");

				for ( warning in warnings )
				{
					Sys.println("");
					Sys.println(" File Path    :" + warning.filePath);
					Sys.println(" Line Number  :" + warning.lineNumber);
					Sys.println(" Issue        :" + warning.oldCode);
					Sys.println(" Solution     :" + warning.newCode);
				}
				
				Sys.println("");
				Sys.println(" Warning although this command updates a lot, its not perfect.");
				//todo wiki page
				Sys.println(" Please visit haxeflixel.com/wiki/convert for further documentation on converting old code.");
				Sys.println("");

				if(warnings.length > 0)
				{
					var logFileName = "convert.log";
					var filePath = convertProjectPath + "/" + logFileName;
					writeWarningsToFile(filePath, warnings, convertProjectPath);
				}
			}
			else 
			{
				Sys.println(" ");
				Sys.println(" Warning there was a problem with the path to convert.");
				Sys.println(" " + convertProjectPath);
				Sys.println(" ");
			}
		} 
		else 
		{
			Sys.println("Warning cannot find " + convertProjectPath);
		}
	}

	/**
	 * Write a warning log to a file
	 * @param  FilePath                 String to as the destination for the log file
	 * @param  Warnings<WarningResult>  Array containing all the WarningResults
	 * @param  ConvertProjectPath       The path that the convert command was performed on
	 */
	static public function writeWarningsToFile(FilePath:String, Warnings:Array<WarningResult>, ConvertProjectPath:String):Void
	{
		var fileObject = File.write(FilePath, false);

		fileObject.writeString("flixel-tools convert warning log" + "\n");
		fileObject.writeString("Converted Path " + ConvertProjectPath + "\n\n");

		for ( warning in Warnings )
		{
			fileObject.writeString("\n");
			fileObject.writeString("File Path    :" + warning.filePath + "\n");
			fileObject.writeString("Line Number  :" + warning.lineNumber + "\n");
			fileObject.writeString("Issue        :" + warning.oldCode + "\n");
			fileObject.writeString("Solution     :" + warning.newCode + "\n");
		}

		fileObject.close();
	}

	/**
	 * Recursively use find and replace on *.hx files inside a project directory
	 * 
	 * @param   ProjectPath     Path to scan recursivley 
	 */
	static public function convertProjectFolder(ProjectPath:String, Display:Bool=false):Array<WarningResult>
	{
		var warnings:Array<WarningResult> = new Array<WarningResult>();

		for (fileName in FileSystem.readDirectory(ProjectPath))
		{
			if (FileSystem.isDirectory(ProjectPath + "/" + fileName))
			{
				var recursiveWarnings:Array<WarningResult> = convertProjectFolder(ProjectPath + "/" + fileName, false);

				if(recursiveWarnings != null)
				{               
					for ( warning in recursiveWarnings )
					{
						warnings.push(warning);
					}
				}
			}
			else
			{
				if (StringTools.endsWith(fileName, ".hx"))
				{
					var filePath:String = ProjectPath + "/" + fileName;
					var sourceText:String = sys.io.File.getContent(filePath);
					var originalText:String = Reflect.copy(sourceText);
					var replacements:Array<FindAndReplaceObject> = FindAndReplace.init();

					for ( replacement in replacements )
					{
						var obj:FindAndReplaceObject = replacement;
						sourceText = StringTools.replace(sourceText, obj.find, obj.replacement);
						
						if (originalText != sourceText)
						{   
							if(obj.importValidate != null && CommandLine.strmatch(obj.find, originalText))
							{
								var newText = CommandLine.addImportToFileString(sourceText,obj.importValidate);

								if(newText!=null)
								{
									sourceText = newText;
								}
							}

							FileSystem.deleteFile(filePath);
							var o:FileOutput = sys.io.File.write(filePath, true);
							o.writeString(sourceText);
							o.close();
						}
					}

					var warningsCurrent = scanFileForWarnings (filePath);

					if(warningsCurrent != null)
					{               
						for ( warning in warningsCurrent )
						{
							warnings.push(warning);
						}
					}

				}
			}
		}

		return warnings;
	}

	/**
	 * Validate an openfl project by compiling it and checking the result
	 */
	static public function validateProject():Void
	{
		if (commandsSet.recursive)
		{
			compileAllDemos();
		}
		else 
		{
			if (StringTools.startsWith(commandsSet.fromDir,"./"))
			{
				commandsSet.fromDir = commandsSet.fromDir.substring(2);
			}
			
			if (StringTools.endsWith(commandsSet.fromDir,"/" ))
			{
				commandsSet.fromDir = commandsSet.fromDir.substring(0, commandsSet.fromDir.length - 1);
			}
			
			//todo
			// var validateProjectPath = Sys.getCwd() + commandsSet.fromDir;
			// Sys.println("Validate " + validateProjectPath);
			
			// buildProject();
		}
	}

	/**
	 * Build an openfl target
	 * 
	 * @param   Target      The openfl target to build
	 * @param   Project     The project object to build from
	 * @param   Display     Echo progress on the command line
	 * @return  BuildResult the result of the compilation
	 */
	static public function buildProject(Target:String, Project:DemoProject, Display:Bool = false):BuildResult
	{
		if (Target == "native")
		{
			if (PlatformHelper.hostPlatform == Platform.WINDOWS)
			{
				Target = "windows";
			}
			else if (PlatformHelper.hostPlatform == Platform.MAC)
			{
				Target = "mac";
			} 
			else if (PlatformHelper.hostPlatform == Platform.LINUX)
			{
				Target = "linux";
			}
		}
		
		var buildCommand:String = "haxelib run openfl build " + Project.PROJECTXMLPATH + " " + Target;
		
		if (Display)
		{
			Sys.println("");
			Sys.println(" Compile " + Target + ":: " + buildCommand);
		}
		
		var compile:Int = Sys.command(buildCommand);
		
		if (Display)
		{
			Sys.println("");
			Sys.println(" " + Target + "::" + getResult(compile));
		}
		
		var project:BuildResult = { result : getResult(compile), project : Project };
		
		return project;
	}

	/**
	 * Return a friendly result string based on an Int value
	 * 
	 * @param   Result
	 * @return  string PASSED or FAILED
	 */
	inline static public function getResult(Result:Int):String
	{  
		if (Result == 0)
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
	 */
	static public function setupTools():Void
	{
		var haxePath:String = Sys.getEnv("HAXEPATH");
		
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
	 *
	 * @return  A Commands Class with the value of the commands to execute
	 */
	static private function processArguments():Commands
	{
		var arguments:Array<String> = Sys.args();
		// Sys.println(arguments.toString());
		
		if (arguments.length > 0)
		{
			// Last argument is the current haxelib path
			var lastArgument:String = "";
			
			for (i in 0...arguments.length)
			{
				lastArgument = arguments.pop();
				
				if (lastArgument.length > 0) 
				{
					break;
				}
			}
			
			lastArgument = new Path(lastArgument).toString();
			
			if (((StringTools.endsWith(lastArgument, "/") && lastArgument != "/") || StringTools.endsWith(lastArgument, "\\")) && !StringTools.endsWith(lastArgument, ":\\"))
			{
				lastArgument = lastArgument.substr(0, lastArgument.length - 1);
			}
			
			// Set the current directory to the haxelib
			if (FileSystem.exists(lastArgument) && FileSystem.isDirectory(lastArgument))
			{
				// toolsPath = lastArgument;
				Sys.setCwd(lastArgument);
			}
		}
		
		commandsSet = new Commands();
		
		var length:Int = arguments.length;
		var index:Int = 0;
		
		if (arguments[index] == "help")
		{
			commandsSet.help = true;
		}
		else if (arguments[index] == "create")
		{
			commandsSet.create = true;
			
			if (arguments[index++] != null)
			{
				commandsSet.createName = arguments[index++];
			}
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

	inline static private function processValidateArgs(Arguments:Array<String>):Void
	{
		if (Arguments[1] != null)
		{
			commandsSet.fromDir = Arguments[1];
		} 
		else
		{
			Sys.println("Warning, you have not set a project Path for validate");
		}
	}

	inline static private function processConvertArgs(Arguments:Array<String>):Void
	{
		if (Arguments[1] != null)
		{
			commandsSet.fromDir = Arguments[1];
			commandsSet.convert = true;
		}
		else
		{
			Sys.println("Warning, you have not set a project Path for convert");
		}
	}

	inline static private function processListArgs(Arguments:Array<String>):Void
	{
		var index:Int = 0;
		var length:Int = Arguments.length;
		
		while (index < Arguments.length)
		{
			if (Arguments[index] == "demos")
			{
				index++;
				commandsSet.listDemos = true;
			}
			else if (Arguments[index] == "templates")
			{
				index++;
				commandsSet.listTemplates = true;
			}
			
			index++;
		}
	}

	inline static private function processTemplateArgs(Arguments:Array<String>):Void
	{
		var index:Int = 0;
		var length:Int = Arguments.length;
	
		while (index < Arguments.length)
		{
			if (Arguments[index] == "-name" && index + 1 < length)
			{
				index++;
				commandsSet.projectName = Arguments[index];
			}
			else if (Arguments[index] == "-screen" && index + 2 < length)
			{
				index++;
				commandsSet.projectWidth = cast(Arguments[index]);
				index++;
				commandsSet.projectHeight = cast(Arguments[index]);
			}
			else if (Arguments[index] != null && Arguments[index] != 'template')
			{
				commandsSet.createName = cast(Arguments[index]);
			}
			
			index++;
		}
	}

	inline static private function processAdditionalArgs(Arguments:Array<String>):Void
	{
		var index:Int = 0;
		var length:Int = Arguments.length;
		
		while (index < Arguments.length)
		{
			if (Arguments[index] == "-R")
			{
				index++;
				commandsSet.recursive = true;
			}
			else if (Arguments[index] == "-B")
			{
				index++;
				commandsSet.noBackup = true;
			}
			
			index++;
		}
	}

	/**
	 * Validate all the demos recursivley
	 *
	 * @param   Location    Location of the demos directory to scan and validate
	 */
	static public function compileAllDemos(Location:String = ""):Void
	{
		if (Location == "")
		{
			Sys.println(" Copying all demos into the current working directory.");
			
			var demosPath:String = PathHelper.getHaxelib(new Haxelib ("flixel-demos"));
			Location = Sys.getCwd() + "flixel-demos-validation/";
			FileHelper.recursiveCopy(demosPath, Location);
		}
		
		var projects:Map<String, DemoProject> = listAllDemos(Location, false);
		
		var results = new Array<BuildResult>();
		
		var flashOnly = new Array<DemoProject>();
		var nonFlash = new Array<DemoProject>();
		var allTargets = new Array<DemoProject>();
		
		Sys.println(" " + Lambda.count(projects) + " demos available to compile.");
		
		for (project in projects.keys())
		{
			var demoProject:DemoProject = projects.get(project);
			
			if (demoProject.TARGETS != null)
			{
				if (demoProject.TARGETS == "FlashOnly")
				{
					flashOnly.push(demoProject);
				}
				else if (demoProject.TARGETS == "NonFlash")
				{
					nonFlash.push(demoProject);
				}
				else if (demoProject.TARGETS == "All") 
				{
					allTargets.push(demoProject); 
				}
			}
			else  
			{
				Sys.println(" Error no valid demos were found.");
				return;
			}
		}
		
		Sys.println("");
		Sys.println(" - Demos for all targets");
		
		for (demo in allTargets)
		{
			var demoProject:DemoProject = demo;
			Sys.println(" Building::" + demoProject.NAME);
		
			results.push(buildProject("flash", demoProject));
			// results.push(buildProject("neko", demoProject));
			// results.push(buildProject("native", demoProject));
			// results.push(buildProject("html5", demoProject));
		}
		
		Sys.println("");
		Sys.println(" - Demos Flash target only");
		
		for (demo in flashOnly)
		{
			var demoProject:DemoProject = demo;
			Sys.println(" Building::" + demoProject.NAME);
			
			results.push(buildProject("flash", demoProject));
			
		}
		
		Sys.println("");
		Sys.println(" - Demos for CPP target only");
		
		for (demo in nonFlash)
		{
			var demoProject:DemoProject = demo;
			Sys.println(" Building::" + demoProject.NAME);
			
			results.push(buildProject("neko", demoProject));
			// results.push(buildProject("native", demoproject));
		}
		
		Sys.println ("");
		
		for (result in results)
		{
			var demoProjectResult:BuildResult = result;
			
			Sys.println ("-------------------------------------------------");
			Sys.println (demoProjectResult.project.NAME);
			Sys.println (demoProjectResult.result);
			Sys.println (demoProjectResult.project.TARGETS);
			Sys.println (demoProjectResult.project.PROJECTXMLPATH);
			Sys.println ("-------------------------------------------------");
		}
	}

	/**
	 * Scan a folder recursivley for openfl project files
	 *
	 * @param   DemosPath       [description]
	 * @param   Display         [description]
	 * @return                  [description]
	 */
	static public function scanProjectXML(DemosPath:String = "", Display:Bool = false):Map<String, DemoProject>
	{
		if (DemosPath == "")
		{
			DemosPath = PathHelper.getHaxelib(new Haxelib ("flixel-demos"));
		}
		
		if (Display)
		{
			Sys.println(" Scan for demos in::" + DemosPath);
		}
		
		var demos = new Map<String, DemoProject>();
		
		for (name in FileSystem.readDirectory(DemosPath))
		{
			var folderPath:String = DemosPath + "/" + name;
			
			if (Display)
			{
				Sys.println(" ScanningFolder::" + DemosPath);
			}
			
			if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(folderPath))
			{
				var projectXMLPath:String = findProjectFile(folderPath);
				
				if (Display)
				{
					Sys.println(" ProjectXMLResult::" + projectXMLPath);
				}
				
				if (projectXMLPath == "")
				{
					if (name == "FlashOnly" || name == "NonFlash")
					{
						var subpath:String = folderPath;
						var moreDemos:Map<String, DemoProject> = scanProjectXML(subpath, Display);
						
						for (demo in moreDemos.keys())
						{
							var project:DemoProject = moreDemos.get(demo);
							project.TARGETS = name;
							
							if (FileSystem.exists(project.PATH))
							{
								demos.set(project.NAME, project);
							}
						}
					}
				}
				else
				{
					var project:DemoProject = 
					{ 
						NAME : name,
						PATH : folderPath,
						PROJECTXMLPATH : projectXMLPath,
						TARGETS : "All",
					};
					
					if (FileSystem.exists(project.PATH))
					{
						demos.set(project.NAME, project);
						
						if (Display)
						{
							Sys.println(" Project::" + project);
						}
					}
				}
			}
		}
		
		return demos;
	}
	
	/**
	* Scans a path for openfl/nme project files
	* 
	* @author   Joshua Granick a private method in openfl-tools
	* @return   The path of the project file found
	*/
	static private function findProjectFile(ProjectPath:String):String
	{
		if (FileSystem.exists(PathHelper.combine(ProjectPath, "Project.hx")))
		{
			return PathHelper.combine(ProjectPath, "Project.hx");
		}
		else if (FileSystem.exists(PathHelper.combine(ProjectPath, "project.nmml")))
		{
			return PathHelper.combine(ProjectPath, "project.nmml");
		}
		else if (FileSystem.exists(PathHelper.combine(ProjectPath, "project.xml")))
		{
			return PathHelper.combine(ProjectPath, "project.xml");
		}
		else
		{
			var files = FileSystem.readDirectory(ProjectPath);
			var matches = new Map <String, Array <String>>();
			matches.set("nmml", []);
			matches.set("xml", []);
			matches.set("hx", []);
			
			for (file in files)
			{
				var path = PathHelper.combine(ProjectPath, file);
				
				if (FileSystem.exists(path) && !FileSystem.isDirectory(path))
				{
					var extension:String = Path.extension(file);
					
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
	 * Create a demo by recursivly copying the folder according to a name
	 * 
	 * @param   Name    The name of the demo to create
	 */
	static public function createDemo(?Name:String):Void
	{
		if (Name == null)
		{
			var DemosFilePath = PathHelper.getHaxelib(new Haxelib ("flixel-demos"));

			if(DemosFilePath == "")
			{
				Sys.println(" No Demos were found");
				Sys.println(' Have you run the "flixel download demos" command yet?');
			} 
			else
			{
				createDemoList(DemosFilePath);
			}

			return;
		}
		
		var demo:DemoProject = demoExists(Name);
		
		if (demo != null)
		{
			Sys.println(" - Creating " + Name);
			
			var destination = Sys.getCwd() + Name;
			FileHelper.recursiveCopy(demo.PATH, destination);
			
			if (FileSystem.isDirectory(destination))
			{
				Sys.println(" - Created " + Name);
				Sys.println(destination);
				return;
			}
			else
			{
				Sys.println(" There was an unknown problem creating " + destination);
				return;
			}
		}
		else
		{
			Sys.println(" Error there is no demo installed with the name of " + Name);
			Sys.println(' Have you run the "flixel download demos" command yet?');
			Sys.println("");
			return;
		}
	}

	static public function createDemoList(DemosFilePath:String):Void
	{
		if(DemosFilePath == "")
		{
			Sys.println(" No demos found, have you installed the haxelib flixel-demos yet?");
			Sys.println(' Please run the "flixel download demos" command.');
			Sys.println("");
			return;
		}

		Sys.println(" Listing Demos from the current flixel-demos haxelib installed.");
		Sys.println(" " + DemosFilePath);
		
		var projects:Map<String, DemoProject> = scanProjectXML(DemosFilePath, false);
		var demoProjects = new Array<DemoProject>();
		
		Sys.println(" " + Lambda.count(projects) + " demos available.");
		
		for (project in projects.keys())
		{
			var demoProject:DemoProject = projects.get(project);
			
			if (demoProject.TARGETS != null)
			{
				demoProjects.push(demoProject);
			}
			else  
			{
				Sys.println(" Error no valid demos were found in:");
				Sys.println(" " + DemosFilePath);
				
				return;
			}
		}

		var answers = new Array<String>();
		var header = " Listing all the demos you can create.";
		var question = " Please enter a number or name of the demo to create.";

		for (demo in demoProjects)
		{
			answers.push(demo.NAME);
		}

		var answer = CommandLine.askQustionStrings(question, header, answers);

		if(answer == null)
		{
			Sys.println(" Your choice was not a valid demo.");
			Sys.println("");
			return;
		}

		if(demoExists(answer) != null)
		{
			createDemo(answer);
		}
		else
		{
			Sys.println(" There was an error creating " + answer );
		}
	}

	/**
	 * Check if a Demo exists in a path recursivley
	 * 
	 * @param   Name            Name of the demo
	 * @param   ProjectPath     The path to scan, default scan flixel-demos haxelib
	 * @return  DemoProject object or null if none found
	 */
	static public function demoExists(Name:String, ProjectPath:String = ""):DemoProject 
	{
		var demos = listAllDemos("", false);

		if(demos == null)
			return null;
		
		for (demo in demos.keys())
		{
			var demoProject:DemoProject = demos.get(demo);
			
			if (demoProject.NAME == Name)
			{
				return demoProject;
			}
		}
		
		return null;
	}

	/**
	 * List all the demos in a folder, default the flixel demos haxelib installed
	 * 
	 * @param   DemoPath    The folder to recursivley scan for demos
	 * @param   Display     Print output to the command line
	 * @return  DemoProject typedef of each demo found
	 */
	static public function listAllDemos(DemoPath:String = "", Display:Bool = false):Map<String, DemoProject> 
	{
		if (DemoPath == "")
		{
			DemoPath = PathHelper.getHaxelib(new Haxelib ("flixel-demos"));
			
			if(DemoPath == "")
			{
				if (Display)
				{
					Sys.println("");
					Sys.println(" No demos found, have you installed the haxelib flixel-demos yet?");
					Sys.println(' Please run the "flixel download demos" command to check.');
					Sys.println("");
				}
				return null;
			}

			if (Display)
			{
				Sys.println(" Listing Demos from the current flixel-demos haxelib installed.");
				Sys.println(" " + DemoPath);
			}
		}
		
		var projects:Map<String, DemoProject> = scanProjectXML(DemoPath, false);
		
		var flashOnly = new Array<DemoProject>();
		var nonFlash = new Array<DemoProject>();
		var allTargets = new Array<DemoProject>();
		
		if (Display)
		{
			Sys.println(" " + Lambda.count(projects) + " demos available.");
		}
		
		for (project in projects.keys())
		{
			var demoProject:DemoProject = projects.get(project);
			
			if (demoProject.TARGETS != null)
			{
				if (demoProject.TARGETS == "FlashOnly")
				{
					flashOnly.push(demoProject);
				}
				else if (demoProject.TARGETS == "NonFlash")
				{
					nonFlash.push(demoProject);
				}
				else if (demoProject.TARGETS == "All") 
				{
					allTargets.push(demoProject); 
				}
			}
			else  
			{
				if (Display)
				{
					Sys.println(" Error no valid demos were found.");
				}
				
				return projects;
			}
		}
		
		if (Display)
		{
			Sys.println("");
			Sys.println(" - Demos for all targets");
		}
		
		for (demo in allTargets)
		{
			var demoProject:DemoProject = demo;
			
			if (Display)
			{
				Sys.println(" " + demoProject.NAME);
			}
		}
		
		if (Display)
		{ 
			Sys.println("");
			Sys.println(" - Demos Flash target only");
		}
		
		for (demo in flashOnly)
		{
			var demoProject:DemoProject = demo;
			
			if (Display)
			{
				Sys.println(" " + demoProject.NAME);
			}
		}
	
		if (Display)
		{
			Sys.println("");
			Sys.println(" - Demos for CPP target only");
		}
		
		for (demo in nonFlash)
		{
			var demoProject:DemoProject = demo;
			
			if (Display)
			{
				Sys.println(" " + demoProject.NAME);
			}
		}

		if(Display)
		{
			Sys.println("");
			Sys.println(' Use the "flixel create" command to create a demo numerically.');
			Sys.println("");
		}
		
		return projects;
	}

	/**
	 * Scans a file for a string to warn about
	 * @param  FilePath the path of the file to scan
	 * @return          WarningResult with data for what the warning was and info
	 */
	static public function scanFileForWarnings(FilePath:String):Array<WarningResult> 
	{
		var results = new Array<WarningResult>();

		// open and read file line by line
		var fin = File.read(FilePath, false);

		try
		{
			var lineNum = 0;
			while (true)
			{
				var str = fin.readLine();
				lineNum++;
				// Sys.println("line " + (++lineNum) + ": " + str);
				var warnings = Warnings.warningList;
				
				for ( warning in warnings.keys() )
				{
					var fix = warnings.get(warning);
					var search = new EReg("\\b" + warning + "\\b", "");
					var match = search.match(str);
					
					if(match)
					{
						var result:WarningResult = 
						{ 
							oldCode : warning,
							newCode : fix,
							lineNumber : Std.string(lineNum),
							filePath : FilePath,
						};

						results.push(result);
					}
				}
			}
		}
		catch( ex:haxe.io.Eof ){}

		fin.close();

		return results;
	}
}

/**
 * Object used to process the command arguments
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
	public var listDemos:Bool = false;
	public var listTemplates:Bool = false;
	
	public var template:Bool = false;
	
	public var projectName:String = "HaxeFlixelTemplate";
	public var projectWidth:Int = 640;
	public var projectHeight:Int = 480;
	
	public var fromDir:String = "";
	public var toDir:String = "";
	
	public function new():Void {}
}

/**
 * Object to pass the build result of a project
 */
typedef BuildResult = {
	var result:String;
	var project:DemoProject;
}

/**
 * Warning Result for warning about old code that cannot be updated manually
 */
typedef WarningResult = {
	var oldCode:String;
	var newCode:String;
	var lineNumber:String;
	var filePath:String;
}

/**
 * Object to pass the data of a project
 */
typedef DemoProject = {
	var NAME:String;
	var PATH:String;
	var PROJECTXMLPATH:String;   
	var TARGETS:String;   
}

/**
 * Definition of a haxelib json file
 */
typedef HaxelibJSON = {
	var name:String;
	var url:String;
	var license:String;
	var tags:Array<String>;
	var description:String;
	var version:String;
	var releasenote:String;
	var contributors:Array<String>;
	var dependencies:Dynamic;
}