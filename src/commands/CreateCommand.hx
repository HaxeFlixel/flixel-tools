package commands;

import utils.CommandUtils.Answer;
import utils.CommandUtils;
import massive.sys.cmd.Command;
import utils.ProjectUtils;
import utils.ProjectUtils.OpenFLProject;
import utils.DemoUtils;

class CreateCommand extends Command
{
	private var autoContinue:Bool = false;

	override public function execute():Void
	{
		if (console.getOption("-y") != null)
			autoContinue = true;

		if(console.args.length > 3)
		{
			this.error("You have given too many arguments for the create command.");
		}

		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if(projects == null)
		{
			Sys.println("");
			Sys.println("There were no Demos found.");
			Sys.println("Is your flixel-demos haxelib installed?");
			Sys.println("Try the 'flixel download' command.");
			Sys.println("");
			exit();
		}

		var demo:OpenFLProject = null;

		if(console.args[1] != null)
		{
			demo = DemoUtils.exists(console.args[1]);

			if (demo == null)
			{
				if(Std.parseInt(console.args[1]) != null)
				{
					demo = DemoUtils.getByIndex(Std.parseInt(console.args[1]));

					if(demo == null)
					{
						error("This Demo was not found, please try again.");
					}
				}
			}
		}
		else
		{
			demo = promptDemoChoice(projects);
		}

		if(demo == null)
		{
			error("This Demo was not found, please try again.");
		}

		Sys.println(" Creating " + demo.NAME);

		var IDEChoice = ProjectUtils.resolveIDEChoice(console);
		var	destination = CommandUtils.combine(Sys.getCwd(), demo.NAME);
		var copied = utils.ProjectUtils.duplicateProject(demo, destination, IDEChoice);

		if(copied)
		{
			Sys.println("");
			Sys.println(" The Demo " + demo.NAME + " has been created at:");
			Sys.println(" " + destination);
			Sys.println("");

			if (FlxTools.settings.IDEAutoOpen)
			{
				var opened = ProjectUtils.IDEAutoOpen(destination, demo.NAME, IDEChoice, autoContinue);
				if(!opened)
					error("There was a problem opening with " + IDEChoice);
			}

			exit();
		}
		else
		{
			Sys.println("");
			error(" There was an problem creating " + demo.NAME);
		}
	}

	private function promptDemoChoice(projects:Array<OpenFLProject>):OpenFLProject
	{
		for ( project in projects )
		{
			Sys.println(project.NAME);
		}
		var answers = new Array<String>();
		var header = " Listing all the demos you can create.";
		var question = " Please enter a number or name of the demo to create.";

		for (demo in projects)
		{
			answers.push(demo.NAME);
		}

		var answer = DemoUtils.askQuestionDemoStrings(question, header, answers);

		if(answer == null)
		{
			Sys.println(" Your choice was not a valid demo.");
			Sys.println("");
			return null;
		}

		var demo = DemoUtils.exists(answer);
		if(demo != null)
		{
			return demo;
		}
		return null;
	}

}