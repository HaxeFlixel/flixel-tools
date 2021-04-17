package commands;

import massive.sys.cmd.Command;
import utils.CommandUtils;
import utils.ProjectUtils;

class Create extends Command
{
	override public function execute()
	{
		if (console.args.length > 3)
			error("You have given too many arguments for the create command.");

		final projects:Array<LimeProject> = getProjects();
		final project = getProject(projects);

		Sys.println("Copying demo '" + project.name + "'...");

		final ide = ProjectUtils.resolveIDEChoice(console);
		final destination = CommandUtils.combine(Sys.getCwd(), project.name);
		final copied = ProjectUtils.duplicateProject(project, destination, ide);

		if (copied)
		{
			Sys.println("Successfully created the demo '" + project.name + "' at:");
			Sys.println(destination);
			Sys.println("");

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

	function getProjects():Array<LimeProject>
	{
		var directory = console.getOption("dir");
		if (directory == null)
			directory = CommandUtils.getHaxelibPath("flixel-demos");

		final projects:Array<LimeProject> = ProjectUtils.findLimeProjects(directory);

		if (projects.length == 0)
		{
			Sys.println("No demos found.");
			Sys.println("Is the flixel-demos haxelib installed?");
			Sys.println("Try 'haxelib install flixel-demos'.");
			exit();
		}

		// sort alphabetically
		projects.sort(function(p1, p2)
		{
			if (p1.name < p2.name)
				return -1;
			if (p1.name > p2.name)
				return 1;
			return 0;
		});

		return projects;
	}

	function getProject(projects:Array<LimeProject>):LimeProject
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

	function promptProjectChoice(projects:Array<LimeProject>):LimeProject
	{
		Sys.println("Listing all available demos...\n");

		final lines = columnsFromList(projects, 3, function(project)
		{
			if (project.name.length <= 20)
				return project.name;
			else
				return project.name.substring(0, 17) + "...";
		});

		for (line in lines)
			Sys.println(line);

		return getProjectChoice(projects);
	}

	function columnsFromList<T>(list:Array<T>, columns:Int, stringifier:T->String):Array<String>
	{
		final splitAmount = Math.ceil(list.length / columns);
		final lines = [for (_ in 0...splitAmount) ""];
		var maxLineLength = 0;

		for (i in 0...list.length)
		{
			var number = Std.string(i + 1);
			if (number.length < 2)
				number = "0" + number;

			final output = '[$number] ${stringifier(list[i])}';

			if (i % splitAmount == 0)
			{
				for (line in lines)
					if (line.length > maxLineLength)
						maxLineLength = line.length;
			}

			final j = i % splitAmount;
			final numSpaces = (maxLineLength - lines[j].length) + 2;
			lines[j] += [for (i in 0...numSpaces) " "].join("");
			lines[j] += output;
		}

		return lines;
	}

	function getProjectChoice(projects:Array<LimeProject>):LimeProject
	{
		Sys.println("\n  [c] Cancel\n");
		Sys.println("Please enter the number or name of the demo to create.\n");

		while (true)
		{
			final userResponse = CommandUtils.readLine();
			if (userResponse == "c")
			{
				Sys.println("Cancelled");
				exit();
			}

			final project = resolveProject(projects, userResponse);
			if (project != null)
				return project;
			else
				Sys.println("Your choice was not a valid demo, please try again.");
		}

		return null;
	}

	function resolveProject(projects:Array<LimeProject>, nameOrIndex:String):LimeProject
	{
		final index = Std.parseInt(nameOrIndex);
		if (index != null)
			return projects[index - 1];

		for (project in projects)
			if (project.name == nameOrIndex)
				return project;

		return null;
	}
}
