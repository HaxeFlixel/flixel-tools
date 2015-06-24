package commands;

import utils.CommandUtils;
import massive.sys.cmd.Command;

class DocsCommand extends Command
{
	override public function execute():Void
	{
		Sys.println("docs");
		var root = "targets";
		var runServer = "nekotools server";

		var path = CommandUtils.combine(CommandUtils.getHaxelibPath("flixel"), "docs");
		path = CommandUtils.combine(path, root);

		Sys.setCwd(path);
		Sys.command(runServer);
	}
}