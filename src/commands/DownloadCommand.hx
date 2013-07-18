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
		var path:String = CommandUtils.getHaxelibPath("flixel-demos");
		
		if (path == "")
		{
			Sys.command("haxelib git flixel-demos " + FlxTools.FLIXEL_DEMOS_REPO);
			Sys.command("n");

			path = CommandUtils.getHaxelibPath("flixel-demos");

			if (path == "")
			{
				this.error(" There was a problem installing Flixel Demos");
			}
		}
		else
		{
			Sys.println( " You already have flixel-demos installed" );
			Sys.println(path);
		}
	}

	/**
	 * Download the HaxeFlixel Templates from github using haxelib
	 */
	private function downloadTemplates():Void
	{
		var path:String = CommandUtils.getHaxelibPath("flixel-templates");
		
		if (path == "")
		{
			Sys.command("haxelib git flixel-templates " + FlxTools.FLIXEL_TEMPLATE_REPO);

			path = CommandUtils.getHaxelibPath("flixel-templates");
			
			if (path == "")
			{
				error(" There was a problem installing Flixel Demos");
			}
		}
		else
		{
			Sys.println( " You already have flixel-templates installed" );
			Sys.println(path);
		}
	}
}