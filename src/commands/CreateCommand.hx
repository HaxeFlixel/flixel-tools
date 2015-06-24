package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;
import utils.DemoUtils;
import utils.ProjectUtils;
import utils.ProjectUtils.OpenFLProject;

class CreateCommand extends Command
{
	override public function execute():Void
	{
		if (console.args.length > 3)
			error("You have given too many arguments for the create command.");

		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if (projects == null)
		{
			Sys.println("");
			Sys.println("There were no Demos found.");
			Sys.println("Is your flixel-demos haxelib installed?");
			Sys.println("Try 'haxelib install flixel-demos'.");
			Sys.println("");
			exit();
		}

		var demo:OpenFLProject = null;

		if (console.args[1] != null)
		{
			demo = DemoUtils.exists(console.args[1]);

			if (demo == null)
			{
				if (Std.parseInt(console.args[1]) != null)
				{
					demo = DemoUtils.getByIndex(Std.parseInt(console.args[1]));

					if (demo == null)
					{
						error("This demo was not found, please try again.");
					}
				}
			}
		}
		else
		{
			demo = promptDemoChoice(projects);
		}

		if (demo == null)
			error("This demo was not found, please try again.");
		
		Sys.println(" Creating " + demo.name);

		var ide = ProjectUtils.resolveIDEChoice(console);
		var destination = CommandUtils.combine(Sys.getCwd(), demo.name);
		var copied = ProjectUtils.duplicateProject(demo, destination, ide);

		if (copied)
		{
			Sys.println("");
			Sys.println(" The Demo " + demo.name + " has been created at:");
			Sys.println(" " + destination);

			if (FlxTools.settings.IDEAutoOpen)
				ProjectUtils.openWithIDE(destination, demo.name, ide);

			exit();
		}
		else
		{
			Sys.println("");
			error(" There was an problem creating " + demo.name);
		}
	}

	private function promptDemoChoice(projects:Array<OpenFLProject>):OpenFLProject
	{
		for (project in projects)
		{
			Sys.println(project.name);
		}
		var answers = [];
		var header = " Listing all the demos you can create.";
		var question = " Please enter a number or name of the demo to create.";

		for (demo in projects)
		{
			answers.push(demo.name);
		}

		var answer = DemoUtils.askQuestionDemoStrings(question, header, answers);

		if (answer == null)
		{
			Sys.println(" Your choice was not a valid demo.");
			Sys.println("");
			return null;
		}

		return DemoUtils.exists(answer);
	}
}