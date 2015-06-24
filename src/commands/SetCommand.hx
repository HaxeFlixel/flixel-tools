package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;

class SetCommand extends Command
{
	private var autoContinue:Bool = false;

	override public function execute():Void
	{
		if (console.getOption("-y") != null)
			autoContinue = true;

		var option = console.args[1];

		if (option == null)
		{
			error("Please specify the HaxeFlixel version.");
		}
		else
		{
			if (option == "dev")
			{
				var path:String = CommandUtils.getHaxelibPath('flixel');
				var install = false;

				if (StringTools.endsWith(path, "git/"))
				{
					Sys.println("your using git");
				}
				else
				{
					Sys.println("your not using git");

					var message = "Do you want to install HaxeFlixel Git version?";
					install = CommandUtils.haxelibGitCommand("flixel", FlxTools.FLIXEL_REPO, autoContinue,message, "dev");

					if (!install)
						error("There was a problem installing flixel dev branch with haxelib.");
				}
			}
			else if (option == "stable")
			{
				var message = "Do you want to install the latest HaxeFlixel from Haxelib?";
				CommandUtils.haxelibCommand("flixel", autoContinue, message);
			}
		}

		exit();
	}
}