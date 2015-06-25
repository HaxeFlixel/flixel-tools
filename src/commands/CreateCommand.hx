package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;
import utils.ProjectUtils;

class CreateCommand extends Command
{
	override public function execute():Void
	{
		if (console.args.length > 3)
			error("You have given too many arguments for the create command.");

		var projects:Array<LimeProject> = getProjects();
		var project = getProject(projects);
		
		Sys.println("Creating '" + project.name + "'...");

		var ide = ProjectUtils.resolveIDEChoice(console);
		var destination = CommandUtils.combine(Sys.getCwd(), project.name);
		var copied = ProjectUtils.duplicateProject(project, destination, ide);

		if (copied)
		{
			Sys.println("The demo '" + project.name + "' has been created at:");
			Sys.println(destination);

			if (FlxTools.settings.IDEAutoOpen)
				ProjectUtils.openWithIDE(destination, project.name, ide);

			exit();
		}
		else
		{
			Sys.println("");
			error("There was a problem creating " + project.name);
		}
	}
	
	private function getProjects():Array<LimeProject>
	{
		var demosPath = CommandUtils.getHaxelibPath("flixel-demos");
		var projects:Array<LimeProject> = ProjectUtils.findLimeProjects(demosPath);

		if (projects.length == 0)
		{
			Sys.println("No demos found.");
			Sys.println("Is the flixel-demos haxelib installed?");
			Sys.println("Try 'haxelib install flixel-demos'.");
			exit();
		}
		
		return projects;
	}
	
	private function getProject(projects:Array<LimeProject>):LimeProject
	{
		var project:LimeProject = null;
		if (console.args[1] != null)
		{
			project = resolveProject(projects, console.args[1]);
			if (project == null)
				error("This demo was not found, please try again.");
		}
		else
			project = promptProjectChoice(projects);

		if (project == null)
			error("This demo was not found, please try again.");
		
		return project;
	}

	private function promptProjectChoice(projects:Array<LimeProject>):LimeProject
	{
		Sys.println("Listing all available demos...\n");
		
		// sort alphabetically
		projects.sort(function(p1, p2) {
			if (p1.name < p2.name)
				return -1;
			if (p1.name > p2.name)
				return 1;
			return 0;
		});
		
		var lines = columnsFromList(projects, 3, function(project) {
			return project.name;
		});
		
		for (line in lines)
			Sys.println(line);
		
		return getProjectChoice(projects);
	}
	
	private function columnsFromList<T>(list:Array<T>, columns:Int, stringifier:T->String):Array<String>
	{
		var splitAmount = Math.ceil(list.length / columns);
		var lines = [for (i in 0...splitAmount) ""];
		var maxLineLength = 0;
		
		for (i in 0...list.length)
		{
			var number = Std.string(i + 1);
			if (number.length < 2)
				number = "0" + number;
			
			var output = '[$number] ${stringifier(list[i])}';
			
			if (i % splitAmount == 0)
			{
				for (line in lines)
					if (line.length > maxLineLength)
						maxLineLength = line.length;
			}
			
			var j = i % splitAmount;
			var numSpaces = (maxLineLength - lines[j].length) + 2;
			lines[j] += [for (i in 0...numSpaces) " "].join("");
			lines[j] += output;
		}
		
		return lines;
	}
	
	private function getProjectChoice(projects:Array<LimeProject>):LimeProject
	{
		Sys.println("\n  [c] Cancel\n");
		Sys.println("Please enter the number or name of the demo to create.\n");
		
		while (true)
		{
			var userResponse = CommandUtils.readLine();
			if (userResponse == "c")
			{
				Sys.println("Cancelled");
				break;
			}
			
			var project = resolveProject(projects, userResponse);
			if (project != null)
				return project;
			else
				Sys.println("Your choice was not a valid demo, please try again.");
		}

		return null;
	}
	
	private function resolveProject(projects:Array<LimeProject>, nameOrIndex:String):LimeProject
	{
		var index = Std.parseInt(nameOrIndex);
		if (index != null)
			return projects[index - 1];
		
		for (project in projects)
			if (project.name == nameOrIndex)
				return project;
		
		return null;
	}
}