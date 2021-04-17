package commands;

import massive.sys.cmd.Command;
import sys.io.File;
import utils.ColorUtils;
import utils.CommandUtils;
import utils.ProjectUtils;

class BuildProjects extends Command
{
	var directory:String;

	override public function execute()
	{
		var target:String = console.getNextArg();
		if (target == null)
			target = "flash";
		else
			target = target.toLowerCase();

		final projectNames:Array<String> = console.args.slice(2);

		directory = console.getOption("dir");
		if (directory == null)
			directory = CommandUtils.getHaxelibPath("flixel-demos");

		Sys.println('Scanning "$directory" for projects...');
		var projects:Array<LimeProject> = ProjectUtils.findLimeProjects(directory);
		if (projects.length == 0)
			error("No projects were found.");

		if (projectNames.length > 0)
			projects = filterProjects(projects, projectNames);

		if (projects.length > 0)
		{
			final specifier = (projectNames.length > 0) ? "specified" : "all";
			Sys.println('Building $specifier projects - $target \n');

			final log = console.getOption("log") == "true";
			final verbose = console.getOption("verbose") == "true";
			buildProjects(projects, target, log, verbose, getDefines(), getAdditionArguments());
		}
	}

	function getDefines():Array<String>
	{
		final defines = [];
		for (option in console.options.keys())
			if (option.startsWith("D"))
				defines.push("-" + option);
		return defines;
	}

	function getAdditionArguments():Array<String>
	{
		final additionalArguments = [];
		var doubleDash = false;
		final args = Sys.args();
		for (i in 0...args.length)
		{
			final arg = args[i];
			if (i == args.length - 1)
				continue;

			if (arg == "--")
				doubleDash = true;
			else if (doubleDash)
				additionalArguments.push(arg);
		}
		return additionalArguments;
	}

	function filterProjects(projects:Array<LimeProject>, projectNames:Array<String>):Array<LimeProject>
	{
		final filteredProjects = [];
		for (projectName in projectNames)
		{
			final matching = projects.filter(function(p) return p.name == projectName);
			if (matching.length == 0)
				Sys.println('Could not find a project named \'$projectName\'');
			else
				filteredProjects.push(matching[0]);
		}
		return filteredProjects;
	}

	function buildProjects(projects:Array<LimeProject>, target:String, log:Bool, verbose:Bool, defines:Array<String>, additionalArguments:Array<String>)
	{
		final results = new Array<BuildResult>();

		for (project in projects)
		{
			final targets = (target == "all") ? ["flash", "html5", "neko", "cpp"] : [target];
			for (target in targets)
				results.push(buildProject(project, target, verbose, defines, additionalArguments));
		}

		if (log)
			writeResultsToFile(Sys.getCwd() + "compile_results.log", results);

		var totalResult = Result.SUCCESS;

		var passed = 0;
		var total = results.length;

		for (result in results)
		{
			if (result.result == Result.FAILURE)
				totalResult = Result.FAILURE;
			else
				passed++;
		}

		Sys.println("");
		ColorUtils.println('$passed/$total projects built successfully\n', totalResult);

		exit(totalResult);
	}

	function buildProject(project:LimeProject, target:String, verbose:Bool, defines:Array<String>, additionalArguments:Array<String>):BuildResult
	{
		final buildArgs = ["run", "openfl", "build", project.path, target].concat(defines).concat(additionalArguments);
		if (verbose)
			Sys.println("haxelib " + buildArgs.join(" "));

		final result:Result = Sys.command("haxelib", buildArgs);

		ColorUtils.println(result + " - " + project.name + ' ($target)', result);

		return {
			result: result,
			target: target,
			project: project
		};
	}

	function writeResultsToFile(FilePath:String, Results:Array<BuildResult>)
	{
		final file = File.write(FilePath, false);

		file.writeString("flixel-tools buildprojects log\n");
		file.writeString('Directory: $directory \n');

		for (result in Results)
		{
			file.writeString("\n");
			file.writeString("Project Name : " + result.project.name + "\n");
			file.writeString("Project Path : " + result.project.path + "\n");
			file.writeString("Targets      : " + result.project.targets + "\n");
			file.writeString("Build Target : " + result.target + "\n");
			file.writeString("Build Result : " + result.result + "\n");
		}

		file.writeString("\n / End of Log.");
		file.close();
	}
}

typedef BuildResult =
{
	final target:String;
	final result:Result;
	final project:LimeProject;
}

enum abstract Result(String)
{
	final SUCCESS = "SUCCESS";
	final FAILURE = "FAILURE";

	@:from static function fromInt(i:Int):Result
	{
		return (i == 0) ? SUCCESS : FAILURE;
	}

	@:to function toInt():Int
	{
		return (this == "SUCCESS") ? 0 : 1;
	}

	@:to function toColor():Color
	{
		return (this == "SUCCESS") ? Color.Green : Color.Red;
	}
}
