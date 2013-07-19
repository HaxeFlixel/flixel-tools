package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;

class DownloadCommand extends Command
{
	override public function execute():Void
	{
		downloadDemos();

		//downloadTemplates();

		exit();
	}

	/**
	 * Download the HaxeFlixel Demos from github using haxelib
	 */
	private function downloadDemos():Void
	{
		var path = CommandUtils.getHaxelibPath("flixel-demos");

		if(path != "")
		{
			Sys.println("");
			Sys.println("It appears you already have flixel-demos haxelib installed.");
			Sys.println(path);
			Sys.println("");
			return;
		}
		else if (path == "")
		{
			Sys.command("haxelib git flixel-demos " + FlxTools.FLIXEL_DEMOS_REPO);

			path = CommandUtils.getHaxelibPath("flixel-demos");

			if (path == "")
			{
				this.error(" There was a problem installing Flixel Demos");
			}
		}
	}

	/**
	 * Download the HaxeFlixel Templates from github using haxelib
	 */
	private function downloadTemplates():Void
	{
		var path = CommandUtils.getHaxelibPath("flixel-templates");

		if(path != "")
		{
			Sys.println("");
			Sys.println("It appears you already have flixel-templates haxelib installed.");
			Sys.println(path);
			Sys.println("");
			return;
		}
		else if (path == "")
		{
			Sys.command("haxelib git flixel-templates " + FlxTools.FLIXEL_TEMPLATE_REPO);

			path = CommandUtils.getHaxelibPath("flixel-templates");
			
			if (path == "")
			{
				error(" There was a problem installing Flixel Demos");
			}
		}
	}
}