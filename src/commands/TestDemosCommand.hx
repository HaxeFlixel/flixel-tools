package commands;

import commands.TestDemosCommand.Result;
import massive.sys.cmd.Command;
import sys.io.File;
import utils.CommandUtils;
import utils.DemoUtils;
import utils.ProjectUtils.OpenFLProject;

class TestDemosCommand extends Command
{
	override public function execute():Void
	{
		var target:String = console.getNextArg();
		if (target == null)
			target = "flash";
		else
			target = target.toLowerCase();
			
		var demoNames:Array<String> = console.args.slice(2);
		
		Sys.println('Scanning flixel-demos haxelib for projects...');
		var demos:Array<OpenFLProject> = DemoUtils.scanDemoProjects();
		if (demos.length == 0)
		{
			error("No demos were found.");
		}
		else
		{
			if (demoNames.length > 0)
				demos = filterDemos(demos, demoNames);
			
			if (demos.length > 0)
			{
				var specifier = (demoNames.length > 0) ? "specified" : "all";
				Sys.println('Building $specifier demos - $target \n');
				compileDemos(demos, target);
			}
		}
		
		exit();
	}
	
	private function filterDemos(demos:Array<OpenFLProject>, demoNames:Array<String>):Array<OpenFLProject>
	{
		var filteredDemos = [];
		for (demoName in demoNames)
		{
			var matching = demos.filter(function(p) return p.NAME == demoName);
			if (matching.length == 0)
				Sys.println('Could not find a demo named \'$demoName\'');
			else
				filteredDemos.push(matching[0]);
		}
		return filteredDemos;
	}

	private function compileDemos(demos:Array<OpenFLProject>, target:String):Void
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
		Sys.println('$passed/$total demos built successfully');

		exit(totalResult);
	}

	private function writeResultsToFile(FilePath:String, Results:Array<BuildResult>):Void
	{
		var file = File.write(FilePath, false);

		file.writeString("flixel-tools compile validate log");
		file.writeString("\n");

		for (result in Results)
		{
			file.writeString("\n");
			file.writeString("Project Name : " + result.project.NAME + "\n");
			file.writeString("Project Path : " + result.project.PATH + "\n");
			file.writeString("Targets      : " + result.project.TARGETS + "\n");
			file.writeString("Build Target : " + result.target + "\n");
			file.writeString("Build Result : " + result.result + "\n");
		}

		file.writeString("\n / End of Log.");
		file.close();
	}

	private function buildProject(Target:String, Project:OpenFLProject):BuildResult
	{
		if (Target == "native")
		{
			Target = CommandUtils.getCPP();
		}

		var buildCommand:String = "haxelib run openfl build " + "\"" + Project.PATH + "\"" + " " + Target;
		
		var result:Result = Sys.command(buildCommand);
		Sys.println(result + " - " + Project.NAME + ' ($Target)');

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
	var project:OpenFLProject;
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
}
