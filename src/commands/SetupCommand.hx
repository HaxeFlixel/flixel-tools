package commands;

import haxe.Utf8;
import massive.sys.cmd.Command;
import massive.sys.io.FileSys;
import utils.CommandUtils;
import utils.CommandUtils.FlxToolSettings;
import sys.FileSystem;
import sys.io.File;

class SetupCommand extends Command
{
	private var autoContinue:Bool = false;

	override public function execute():Void
	{
		setupFlixel();

		if (console.args.length > 3)
		{
			this.error("You have given too many arguments for the create command.");
		}

		if (console.getOption("-y") != null)
			autoContinue = true;

		setupCommandAlias();

		setupFlixelLibs();

		promptForSettings();

		Sys.println("");
		Sys.println("");
		Sys.println(" You have now setup HaxeFlixel Tools");
		Sys.println("");
		Sys.println(" Try the 'flixel' command to test it :)");
		Sys.println("");

		exit();
	}

	private function setupFlixel():Void
	{
		var flixel = CommandUtils.getHaxelibPath("flixel");

		if (flixel == "")
		{
			if (!autoContinue)
			{
				var answer = CommandUtils.askYN ("Would you now like this tool to install flixel for you?");

				if (answer == Answer.Yes)
				{
					Sys.command ("haxelib install flixel");
				}
			}
		}
	}

	private function setupFlixelLibs():Void
	{
		var templatesHaxelib = CommandUtils.getHaxelibPath("flixel-templates");
		var demosHaxelib = CommandUtils.getHaxelibPath("flixel-demos");

		if (templatesHaxelib == "" || demosHaxelib == "")
		{
			if (!autoContinue)
			{
				var download = CommandUtils.askYN ("Would you now like this tool to download the flixel-demos and flixel-templates?");

				if (download == Answer.Yes)
					Sys.command("haxelib run flixel-tools download");
			}
			else
				Sys.command("haxelib run flixel-tools download");
		}
	}

	private function setupCommandAlias():Void
	{
		var answer = Answer.No;

		var message = "Do you want to setup the flixel command Alias?";

		if (FileSys.isLinux||FileSys.isMac)
			message = "Do you want to set up the command alias 'flixel' to 'haxelib run flixel-tools'?" +
			          "\nA simple flixel script will be added to your /usr/bin/";

		answer = CommandUtils.askYN(message);

		if (autoContinue || answer == Answer.Yes)
		{
			var haxePath:String = Sys.getEnv("HAXEPATH");
			var flixelAliasScript = "";

			if (FileSys.isWindows)
			{
				if (haxePath == null || haxePath == "")
				{
					haxePath = "C:\\HaxeToolkit\\haxe\\";
				}

				flixelAliasScript = haxePath + "\\flixel.bat";

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
				if (haxePath == null || haxePath == "")
				{
					haxePath = "/usr/lib/haxe";
				}

				flixelAliasScript = CommandUtils.getHaxelibPath("flixel-tools") + "bin/flixel.sh";

				if (FileSystem.exists(flixelAliasScript))
				{
					Sys.command("sudo", [ "cp", flixelAliasScript, haxePath + "/flixel" ]);
					Sys.command("sudo chmod 755 " + haxePath + "/flixel");
					Sys.command("sudo ln -s " + haxePath + "/flixel /usr/bin/flixel");
				}
				else
				{
					error("Could not find the flixel-tools alias script. You can try 'haxelib selfupdate' and run setup again.");
				}
			}
		}
	}

	private function promptForSettings():FlxToolSettings
	{
		var IDES:Array<String> = [FlxTools.SUBLIME_TEXT, FlxTools.FLASH_DEVELOP, FlxTools.INTELLIJ_IDEA, FlxTools.IDE_NONE];
		var IDE = FlxTools.IDE_NONE;
		var AuthorName = "";
		var IDEAutoOpen = false;
		var ideaFlexSDKName = "flex_4.6";
		var ideaFlixelEngine = "Flixel Engine";
		var ideaFlixelAddons = "Flixel Addons";
		var ideaPath = "/Applications/Cardea-IU-130.1619.app/Contents/MacOS/idea";

		AuthorName = CommandUtils.askString("Enter the author name to use when generating templates.\n\nJust hit enter to not use an author name.");
		AuthorName = Utf8.encode(AuthorName);

		IDE = CommandUtils.askQuestionStrings("Choose your default IDE.", "" , IDES, false);
		if (IDE == null)
		{
			Sys.println(" Your IDE choice was not recognised, using default of " + FlxTools.IDE_NONE);
			IDE = FlxTools.IDE_NONE;
		}

		if ( IDE == FlxTools.INTELLIJ_IDEA)
		{
			var answer = CommandUtils.askString("Enter the name of your default FlexSDK, just ENTER for default of " + ideaFlexSDKName);
			if (answer != "")
				ideaFlexSDKName = answer;

			var answer = CommandUtils.askString("Enter the name of your default Flixel Library, just ENTER for default of " + ideaFlixelEngine);
			if (answer != "")
				ideaFlixelEngine = answer;

			var answer = CommandUtils.askString("Enter the name of your default Flixel Addons Library, just ENTER for default of " + ideaFlixelAddons);
			if (answer != "")
				ideaFlixelAddons = answer;

			var answer = CommandUtils.askString("Enter the path of where you have installed Intellij Idea, default is " + ideaPath);
			if (answer != "")
				ideaPath = answer;
		}
		//else if (IDE == FlxTools.FLASH_DEVELOP)
		//{
			//todo execute template zip?
		//}

		if (IDE != FlxTools.IDE_NONE)
		{
			var answer = CommandUtils.askYN("Do you want to automatically open the created templates and demos with " + IDE + "?");

			if (answer == Answer.Yes)
			{
				IDEAutoOpen = true;
			}
		}

		if (IDE == FlxTools.SUBLIME_TEXT)
		{
			if (FileSys.isMac)
			{
				Sys.println("For Sublime Text to open automatically you have to make sure the 'subl' command is setup properly on your system as in http://www.sublimetext.com/docs/2/osx_command_line.html.");

				var answer = Answer.No;

				var sublSetupCommand = 'ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl';

				answer = CommandUtils.askYN("Do you want to run the symlink command automatically as per official instructions http://www.sublimetext.com/docs/2/osx_command_line.html?\n\n The command that will be executed is as follows:\n '"+sublSetupCommand+"'");

				if (answer == Answer.Yes)
					Sys.command(sublSetupCommand);
			}
		}

		var settingsFile:FlxToolSettings =
		{
			DefaultEditor:IDE,
			AuthorName:AuthorName,
			IDEAutoOpen:IDEAutoOpen,
			IDEA_flexSdkName:ideaFlexSDKName,
			IDEA_Flixel_Engine_Library:ideaFlixelEngine,
			IDEA_Flixel_Addons_Library:ideaFlixelAddons,
			IDEA_Path:ideaPath,
		};

		CommandUtils.saveToolSettings(settingsFile);

		Sys.println("");
		Sys.println(" Your current settings:");
		Sys.println("");

		Sys.println(" Default Editor			:" + FlxTools.settings.DefaultEditor);
		Sys.println(" Author Name			:" + Utf8.decode(FlxTools.settings.AuthorName));

		if (IDE == FlxTools.INTELLIJ_IDEA)
		{
			Sys.println(" IDEA_flexSdkName		:" + FlxTools.settings.IDEA_flexSdkName);
			Sys.println(" IDEA_Flixel_Addons_Library	:" + FlxTools.settings.IDEA_Flixel_Addons_Library);
			Sys.println(" IDEA_Flixel_Engine_Library	:" + FlxTools.settings.IDEA_Flixel_Engine_Library);
			Sys.println(" Idea application path		:" + FlxTools.settings.IDEA_Path);
		}

		Sys.println(" Auto open with IDE		:" + FlxTools.settings.IDEAutoOpen);
		Sys.println("");

		return settingsFile;
	}
}
