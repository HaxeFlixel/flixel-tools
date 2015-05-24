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
		var target:String = null;
		if (console.options.keys().hasNext())
			target = console.options.keys().next();
		compileAllDemos(target);
		exit();
	}

	/**
	 * Compile all the demos recursively
	 *
	 * @param Target Which target to compile apps for (flash, neko, windows, android, ...)
	 */
	private function compileAllDemos(?Target:String):Void
	{
		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if (projects == null)
		{
			error("No Demos were found in haxelib flixel-demos");
			exit();
		}
		
		if (Target == null)
			Target = "flash";

		var results = new Array<BuildResult>();

		Sys.println("Building demos - " + Target);
		Sys.println("");

		for (project in projects)
		{
			var demoProject:OpenFLProject = project;

			if (Target.toLowerCase() == "all")
			{
				results.push(buildProject("flash", demoProject));
				results.push(buildProject("neko", demoProject));
				results.push(buildProject("native", demoProject));
				results.push(buildProject("html5", demoProject));
			}
			else
			{
				results.push(buildProject(Target, demoProject));
			}
		}

		writeResultsToFile(Sys.getCwd() + "compile_results.log", results);

		var totalResult = Result.SUCCESS;

		var failed = 0;
		var passed = 0;
		var total = results.length;

		for (result in results)
		{
			if (result.result == Result.FAILURE)
			{
				failed++;
				totalResult = Result.FAILURE;
			}
			else
			{
				passed++;
			}
		}

		Sys.println("Total Demos       : " + total);
		Sys.println("Failed Builds     : " + failed);
		Sys.println("Successful Builds : " + passed);

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

	/**
	 * Build an openfl target
	 *
	 * @param   Target	  The openfl target to build
	 * @param   Project	 OpenFLProject The project object to build from
	 * @return  BuildResult the result of the compilation
	 */
	private function buildProject(Target:String, Project:OpenFLProject):BuildResult
	{
		if (Target == "native")
		{
			Target = CommandUtils.getCPP();
		}

		var buildCommand:String = "haxelib run openfl build " + "\"" + Project.PATH + "\"" + " " + Target;
		
		var result:Result = Sys.command(buildCommand);
		Sys.println(result + " - " + Project.NAME);

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
