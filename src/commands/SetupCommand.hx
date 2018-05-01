package commands;

import massive.sys.cmd.Command;
import massive.sys.io.FileSys;
import utils.CommandUtils;
import utils.CommandUtils.FlxToolSettings;
import sys.FileSystem;
import sys.io.File;
import FlxTools.IDE;

class SetupCommand extends Command
{
	var autoContinue:Bool = false;
	var isAliasSetUp = false;

	override public function execute():Void
	{
		setupFlixel();

		if (console.args.length > 3)
			error("You have given too many arguments for the setup command.");

		if (console.getOption("-y") != null)
			autoContinue = true;

		setupCommandAlias();
		setupFlixelLibs();
		promptForSettings();

		Sys.println("");
		Sys.println("flixel-tools setup completed.");
		if (isAliasSetUp) Sys.println("Try the 'flixel' command to test it! :)");

		exit();
	}

	function setupFlixel():Void
	{
		var flixel = CommandUtils.getHaxelibPath("flixel");

		if (flixel == "" && !autoContinue)
		{
			var answer = CommandUtils.askYN("Would you now like this tool to install flixel for you?");

			if (answer == Answer.Yes)
			{
				Sys.command("haxelib", ["install", "flixel"]);
			}
		}
	}

	function setupFlixelLibs():Void
	{
		var templatesHaxelib = CommandUtils.getHaxelibPath("flixel-templates");
		var demosHaxelib = CommandUtils.getHaxelibPath("flixel-demos");

		if (templatesHaxelib == "" || demosHaxelib == "")
		{
			if (!autoContinue)
			{
				var download = CommandUtils.askYN("Would you now like this tool to download the flixel-demos and flixel-templates?");

				if (download == Answer.Yes)
					runDownloadCommand();
			}
			else
				runDownloadCommand();
		}
	}

	function runDownloadCommand():Void
	{
		Sys.command("haxelib", ["run", "flixel-tools", "download"]);
	}

	function setupCommandAlias():Void
	{
		var answer = Answer.No;

		var message = "Do you want to setup the flixel command alias?";

		var binPath = if (FileSys.isMac) "/usr/local/bin" else "/usr/bin";

		if (FileSys.isLinux || FileSys.isMac)
			message = "Do you want to set up the command alias 'flixel' to 'haxelib run flixel-tools'?" +
			          "\nA simple flixel script will be added to your " + binPath + "/";

		answer = CommandUtils.askYN(message);

		if (autoContinue || answer == Answer.Yes)
		{
			isAliasSetUp = true;
			
			if (FileSys.isWindows)
			{
				var haxePath:String = Sys.getEnv("HAXEPATH");
				if (haxePath == null || haxePath == "")
					haxePath = "C:\\HaxeToolkit\\haxe\\";

				var flixelAliasScript = haxePath + "\\flixel.bat";
				var scriptSourcePath = CommandUtils.getHaxelibPath("flixel-tools");
				var scriptFile = "flixel.bat";
				scriptSourcePath = CommandUtils.combine(scriptSourcePath, "bin");
				scriptSourcePath = CommandUtils.combine(scriptSourcePath, scriptFile);

				if (FileSystem.exists(scriptSourcePath))
				{
					File.copy(scriptSourcePath, flixelAliasScript);
				}
				else
				{
					error("Could not find the flixel-tools alias script. You can try 'haxelib selfupdate' and run setup again.");
				}
			}
			else
			{
				var flixelAliasScript = CommandUtils.getHaxelibPath("flixel-tools") + "bin/flixel.sh";

				if (FileSystem.exists(flixelAliasScript))
				{
					Sys.command("sudo", ["cp", flixelAliasScript, binPath + "/flixel"]);
					Sys.command("sudo", ["chmod", "+x", binPath + "/flixel"]);
				}
				else
				{
					error("Could not find the flixel-tools alias script. You can try 'haxelib selfupdate' and run setup again.");
				}
			}
		}
	}

	function promptForSettings():FlxToolSettings
	{
		var ides:Array<String> = [IDE.SUBLIME_TEXT, IDE.FLASH_DEVELOP, IDE.INTELLIJ_IDEA, IDE.VISUAL_STUDIO_CODE, IDE.NONE];
		var ide = IDE.NONE;
		var AuthorName = "";
		var IDEAutoOpen = false;
		var ideaFlexSDKName = "flex_4.6";
		var ideaFlixelEngine = "Flixel Engine";
		var ideaFlixelAddons = "Flixel Addons";
		var ideaPath = "/Applications/Cardea-IU-130.1619.app/Contents/MacOS/idea";

		ide = CommandUtils.askQuestionStrings("Choose your default IDE:", ides);
		if (ide == null)
		{
			Sys.println("Your IDE choice was not recognised, using default of " + IDE.NONE);
			ide = IDE.NONE;
		}

		if (ide == IDE.INTELLIJ_IDEA)
		{
			var answer = CommandUtils.askString("Enter the name of your default FlexSDK, just ENTER for default of " + ideaFlexSDKName);
			if (answer != "")
				ideaFlexSDKName = answer;

			var answer = CommandUtils.askString("Enter the name of your default flixel Library, just ENTER for default of " + ideaFlixelEngine);
			if (answer != "")
				ideaFlixelEngine = answer;

			var answer = CommandUtils.askString("Enter the name of your default flixel-addons Library, just ENTER for default of " + ideaFlixelAddons);
			if (answer != "")
				ideaFlixelAddons = answer;

			var answer = CommandUtils.askString("Enter the path to your IntelliJ IDEA installation, default is " + ideaPath);
			if (answer != "")
				ideaPath = answer;
		}

		if (ide != IDE.NONE)
		{
			var answer = CommandUtils.askYN("Do you want to automatically open the created templates and demos with " + ide + "?");
			if (answer == Answer.Yes)
				IDEAutoOpen = true;
		}

		if (ide == IDE.SUBLIME_TEXT && FileSys.isMac)
		{
			Sys.println("For Sublime Text to open automatically you have to make sure the 'subl' command is setup properly on your" +
				"system as in http://www.sublimetext.com/docs/2/osx_command_line.html.");

			var answer = Answer.No;
			var sublSetupArgs = ["-s", "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl", "~/bin/subl"];

			answer = CommandUtils.askYN("Do you want to run the symlink command automatically as per official instructions" +
				"http://www.sublimetext.com/docs/2/osx_command_line.html?\n\n The command that will be executed is as follows:\n '" +
				"ln " + sublSetupArgs.join(" ") + "'");

			if (answer == Answer.Yes)
				Sys.command("ln", sublSetupArgs);
		}

		var settingsFile:FlxToolSettings =
		{
			DefaultEditor: ide,
			AuthorName: AuthorName,
			IDEAutoOpen: IDEAutoOpen,
			IDEA_flexSdkName: ideaFlexSDKName,
			IDEA_Flixel_Engine_Library: ideaFlixelEngine,
			IDEA_Flixel_Addons_Library: ideaFlixelAddons,
			IDEA_Path: ideaPath,
		};

		CommandUtils.saveToolSettings(settingsFile);

		Sys.println("");
		Sys.println("Your current settings:");
		Sys.println("");

		Sys.println("Default Editor			: " + FlxTools.settings.DefaultEditor);

		if (ide == IDE.INTELLIJ_IDEA)
		{
			Sys.println("IDEA_flexSdkName		: " + FlxTools.settings.IDEA_flexSdkName);
			Sys.println("IDEA_Flixel_Addons_Library	: " + FlxTools.settings.IDEA_Flixel_Addons_Library);
			Sys.println("IDEA_Flixel_Engine_Library	: " + FlxTools.settings.IDEA_Flixel_Engine_Library);
			Sys.println("IDEA application path		: " + FlxTools.settings.IDEA_Path);
		}

		Sys.println("Auto open with IDE		: " + FlxTools.settings.IDEAutoOpen);

		return settingsFile;
	}
}
