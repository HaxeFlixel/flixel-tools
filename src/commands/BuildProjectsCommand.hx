package commands;

import massive.sys.cmd.Command;
import sys.io.File;
import utils.CommandUtils;
import utils.ConsoleUtils;
import utils.ProjectUtils;

class BuildProjectsCommand extends Command
{
	private var directory:String;
	
	override public function execute():Void
	{
		var target:String = console.getNextArg();
		if (target == null)
			target = "flash";
		else
			target = target.toLowerCase();
		
		var demoNames:Array<String> = console.args.slice(2);
		
		directory = console.getOption("dir");
		if (directory == null)
			directory = CommandUtils.getHaxelibPath("flixel-demos");
		
		Sys.println('Scanning "$directory" for projects...');
		var demos:Array<LimeProject> = ProjectUtils.findLimeProjects(directory);
		if (demos.length == 0)
		{
			error("No projects were found.");
		}
		else
		{
			if (demoNames.length > 0)
				demos = filterDemos(demos, demoNames);
			
			if (demos.length > 0)
			{
				var specifier = (demoNames.length > 0) ? "specified" : "all";
				Sys.println('Building $specifier projects - $target \n');
				compileDemos(demos, target);
			}
		}
		
		exit();
	}
	
	private function filterDemos(demos:Array<LimeProject>, demoNames:Array<String>):Array<LimeProject>
	{
		var filteredDemos = [];
		for (demoName in demoNames)
		{
			var matching = demos.filter(function(p) return p.name == demoName);
			if (matching.length == 0)
				Sys.println('Could not find a project named \'$demoName\'');
			else
				filteredDemos.push(matching[0]);
		}
		return filteredDemos;
	}

	private function compileDemos(demos:Array<LimeProject>, target:String):Void
	{
		var results = new Array<BuildResult>();

		for (demo in demos)
		{
			if (target == "all")
			{
				results.push(buildProject("flash", demo));
				results.push(buildProject("neko", demo));
				results.push(buildProject("native", demo));
				results.push(buildProject("html5", demo));
			}
			else
			{
				results.push(buildProject(target, demo));
			}
		}

		if (console.getOption("log") == "true")
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
		ConsoleUtils.printWithColor('$passed/$total projects built successfully\n', totalResult);

		exit(totalResult);
	}

	private function writeResultsToFile(FilePath:String, Results:Array<BuildResult>):Void
	{
		var file = File.write(FilePath, false);

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

	private function buildProject(Target:String, Project:LimeProject):BuildResult
	{
		if (Target == "native")
			Target = CommandUtils.getCPP();

		var buildArgs = ["run", "openfl", "build", Project.path, Target];
		var result:Result = Sys.command("haxelib", buildArgs);
		
		ConsoleUtils.printWithColor(result + " - " + Project.name + ' ($Target)', result);

		return {
			result : result,
			target : Target,
			project : Project
		};
	}
}

typedef BuildResult = {
	var target:String;
	var result:Result;
	var project:LimeProject;
}

@:enum
abstract Result(String)
{
	var SUCCESS = "SUCCESS";
	var FAILURE = "FAILURE";
	
	@:from
	static function fromInt(i:Int):Result
	{
		return (i == 0) ? SUCCESS : FAILURE;
	}
	
	@:to
	function toInt():Int
	{
		return (this == "SUCCESS") ? 0 : 1;
	}
	
	@:to
	function toColor():Color
	{
		return (this == "SUCCESS") ? Color.Green : Color.Red; 
	}
}
