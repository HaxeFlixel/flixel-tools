package commands;

import utils.CommandUtils;
import massive.sys.cmd.Command;

class OpenFLTestCommand extends Command
{
	override public function execute():Void
	{
		var path = console.args[1];
		var target = console.args[2];

		var optionSettings = new Array<String>();

		if (console.getOption("-v") == "true")
			optionSettings.push("-v");

		if (console.getOption("-debug") == "true")
			optionSettings.push("-debug");

		if (console.getOption("-clean") == "true")
			optionSettings.push("-clean");

		if (target == null)
		{
			var targets = ['flash', 'neko', CommandUtils.getCPP(), 'html5', 'blackberry', 'ios', 'android'];
			var answer = CommandUtils.askQuestionStrings("Please choose a target.","", targets);

			target = answer;
		}

		var option = "";
		for (o in optionSettings)
		{
			option += " " + o;
		}

		var command = 'haxelib run openfl test ' + path + " " + target + option;
		Sys.println(command);
		Sys.command( command );

		exit();
	}
}