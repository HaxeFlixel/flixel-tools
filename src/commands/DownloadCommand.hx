package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;

class DownloadCommand extends Command
{
	override public function execute():Void
	{
		CommandUtils.gitHaxelib("flixel-addons", FlxTools.FLIXEL_ADDONS_REPO);
		CommandUtils.gitHaxelib("flixel-demos", FlxTools.FLIXEL_DEMOS_REPO);
		CommandUtils.gitHaxelib("flixel-templates", FlxTools.FLIXEL_TEMPLATE_REPO);

		exit();
	}
}