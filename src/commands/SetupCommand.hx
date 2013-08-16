package commands;

import sys.FileSystem;
import utils.CommandUtils.FlxToolSettings;
import utils.CommandUtils;
import sys.io.File;
import massive.sys.io.FileSys;
import massive.sys.cmd.Command;

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

		if(console.getOption("-y") != null)
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

		if(flixel == "")
		{
			if(!autoContinue)
			{
				var answer = CommandUtils.askYN ("Would you now like this tool to install flixel for you?");

				if(answer == Answer.Yes)
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

		if(templatesHaxelib == "" || demosHaxelib == "")
		{
			if(!autoContinue)
			{
				var download = CommandUtils.askYN ("Would you now like this tool to download the flixel-demos and flixel-templates?");

				if(download == Answer.Yes)
				{
					Sys.command ("flixel download");
				}
			}
			else
			{
				Sys.command ("flixel download");
			}
		}
	}

	private function setupCommandAlias():Void
	{
		var answer = Answer.No;

		var message = "Do you want to setup the flixel command Alias?";

		if(FileSys.isLinux||FileSys.isLinux)
			message = "Do you want to set up the command alias 'flixel' to 'haxelib run flixel-tools' with a script in your /usr/bin/ ?";

		answer = CommandUtils.askYN(message);

		if(autoContinue || answer == Answer.Yes)
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

				if(FileSystem.exists (flixelAliasScript))
				{
					File.copy(CommandUtils.getHaxelibPath("flixel-tools") + "\\\\bin\\flixel.bat", flixelAliasScript);
				}
				else
				{
					error("Could not find the flixel-tools alias script");
				}
			}
			else
			{
				if (haxePath == null || haxePath == "")
				{
					haxePath = "/usr/lib/haxe";
				}

				flixelAliasScript = CommandUtils.getHaxelibPath("flixel-tools") + "bin/flixel.sh";

				if(FileSystem.exists (flixelAliasScript))
				{
					Sys.command("sudo", [ "cp", flixelAliasScript, haxePath + "/flixel" ]);
					Sys.command("sudo chmod 755 " + haxePath + "/flixel");
					Sys.command("sudo ln -s " + haxePath + "/flixel /usr/bin/flixel");
				}
				else
				{
					error("Could not find the flixel-tools alias script");
				}
			}
		}
		else
		{
			return;
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

		AuthorName = CommandUtils.askString("Enter the author name to use when generating templates.\n\nJust hit enter to not use an author name.");

		IDE = CommandUtils.askQuestionStrings("Choose your default IDE.", "" , IDES, false);
		if(IDE == null)
		{
			Sys.println(" Your IDE choice was not recognised, using default of " + FlxTools.IDE_NONE);
			IDE = FlxTools.IDE_NONE;
		}

		if(IDE == FlxTools.SUBLIME_TEXT)
		{
			Sys.println("This tools supports Sublime's command line tool you can install from http://www.sublimetext.com/docs/2/osx_command_line.html");
			var name = CommandUtils.askYN("Do you want to open demos/templates automatically with this subl command tool?");

			if(name == Answer.Yes)
				IDEAutoOpen = true;
		}
		else if ( IDE == FlxTools.INTELLIJ_IDEA)
		{
			var answer = CommandUtils.askString("Enter the name of your default FlexSDK");
			if(answer != "")
				ideaFlexSDKName = answer;

			var answer = CommandUtils.askString("Enter the name of your default Flixel Library, just ENTER for default " + ideaFlixelEngine);
			if(answer != "")
				ideaFlixelEngine = answer;

			var answer = CommandUtils.askString("Enter the name of your default Flixel Addons Library, just ENTER for default " + ideaFlixelAddons);
			if(answer != "")
				ideaFlixelAddons = answer;
		}
		else if (IDE == FlxTools.FLASH_DEVELOP)
		{
			//todo execute template zip?
            var answer = CommandUtils.askYN("Do you want to automatically open FlashDevelop?");

            if(answer == Answer.Yes)
                IDEAutoOpen = true;
		}

		var settingsFile:FlxToolSettings =
		{
			DefaultEditor:IDE,
			AuthorName:AuthorName,
            IDEAutoOpen:IDEAutoOpen,
			IDEA_flexSdkName:ideaFlexSDKName,
			IDEA_Flixel_Engine_Library:ideaFlixelEngine,
			IDEA_Flixel_Addons_Library:ideaFlixelAddons,
		};

		CommandUtils.saveToolSettings(settingsFile);

		Sys.println("");
		Sys.println(" Your current settings:");
		Sys.println("");

		Sys.println(" Default Editor			:" + FlxTools.settings.DefaultEditor);
		Sys.println(" Author Name			:" + FlxTools.settings.AuthorName);

		if(IDE == FlxTools.SUBLIME_TEXT)
		{
			Sys.println(" Sublime CMD Option		:" + FlxTools.settings.IDEAutoOpen);
		}
		else if ( IDE == FlxTools.INTELLIJ_IDEA)
		{
			Sys.println(" IDEA_flexSdkName		:" + FlxTools.settings.IDEA_flexSdkName);
			Sys.println(" IDEA_Flixel_Addons_Library	:" + FlxTools.settings.IDEA_Flixel_Addons_Library);
			Sys.println(" IDEA_Flixel_Engine_Library	:" + FlxTools.settings.IDEA_Flixel_Engine_Library);
		}

		Sys.println("");

		return settingsFile;
	}
}