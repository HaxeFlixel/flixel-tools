package commands;

import utils.CommandUtils;
import utils.ProjectUtils;
import utils.DemoUtils;
import massive.sys.cmd.Command;
import sys.io.File;

class TestDemosCommand extends Command
{
	override public function execute():Void
	{
		compileAllDemos(console.options.keys().next());
		exit();
	}

	/**
	 * Compile all the demos recursively
	 *
	 * @param Target Which target to compile apps for (flash, neko, windows, android,
	 */
	private function compileAllDemos(Target:String = ""):Void
	{
		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if (projects == null)
		{
			error("No Demos were found in haxelib flixel-demos");
			exit();
		}

		var results = new Array<BuildResult>();

		Sys.println("Building demos - " + (Target != "" ? Target : "flash"));
		Sys.println("");

		Lambda.foreach(projects, function(p) {
			if (p != null) {
				Sys.println(p.NAME);
				return true;
			}
			return false;
			});
		Sys.println("");

		for (project in projects)
		{
			var demoProject:OpenFLProject = project;

			if(Target.toLowerCase() == "all")
			{
				results.push(buildProject("flash", demoProject));
				results.push(buildProject("neko", demoProject));
				results.push(buildProject("native", demoProject));
				results.push(buildProject("html5", demoProject));
			}
			else if(Target == "")
			{
				results.push(buildProject("flash", demoProject));
			}
			else
			{
				results.push(buildProject(Target, demoProject));
			}
		}

		Sys.println ("");

		writeResultsToFile(Sys.getCwd() + "compile_results.log", results);

		var totalResult = true;

		var failed = 0;
		var passed = 0;
		var total = results.length;

		for (result in results)
		{
			if(result.failed)
			{
				failed++;
				totalResult = false;
			}
			else
			{
				passed++;
			}
		}

		Sys.println("Total Demos	   : " + total);
		Sys.println("Failed Builds	 : " + failed);
		Sys.println("Successful Builds : " + passed);

		totalResult ? exit() : exit(1);
	}

	private function writeResultsToFile(FilePath:String, Results:Array<BuildResult>):Void
	{
		var fileObject = File.write(FilePath, false);

		fileObject.writeString("flixel-tools compile validate log");
		fileObject.writeString("\n\n");

		for (result in Results)
		{
			fileObject.writeString("\n");
			fileObject.writeString("Project Name	:" + result.project.NAME + "\n");
			fileObject.writeString("Project Path	:" + result.project.PATH + "\n");
			fileObject.writeString("Targets		 :" + result.project.TARGETS + "\n");
			fileObject.writeString("Build Target	:" + result.target + "\n");
			fileObject.writeString("Build Result	:" + result.result + "\n");
			fileObject.writeString("\n");
		}

		fileObject.writeString("\n");
		fileObject.writeString(" / End of Log.");

		fileObject.close();
	}

	/**
	 * Build an openfl target
	 *
	 * @param   Target	  The openfl target to build
	 * @param   Project	 OpenFLProject The project object to build from
	 * @param   Display	 Echo progress on the command line
	 * @return  BuildResult the result of the compilation
	 */
	private function buildProject(Target:String, Project:OpenFLProject, Display:Bool = true):BuildResult
	{
		if(Target == "native")
			Target = CommandUtils.getCPP();

		var buildCommand:String = "haxelib run openfl build " + "\"" + Project.PATH + "\"" + " " + Target;

		if (Display)
		{
			Sys.println("");
			Sys.println("Building " + Project.NAME + ":");
			Sys.println(buildCommand);
		}

		var compile:Int = Sys.command(buildCommand);

		if (Display)
		{
			Sys.println(getResult(compile) + " - " + Project.NAME + " (" + Target + ")");
		}

		var project:BuildResult = {
			result : getResult(compile),
			target : Target,
			project : Project,
			failed : (compile != 0)
		};

		return project;
	}

	/**
	 * Return a friendly result string based on an Int value
	 *
	 * @param   Result
	 * @return  string PASSED or FAILED
	 */
	private function getResult(Result:Int):String
	{
		if (Result == 0)
		{
			return "SUCCESS";
		}
		else
		{
			return "FAIL";
		}
	}
}

/**
 * Object to pass the build result of a project
 */
typedef BuildResult = {
	var target:String;
	var result:String;
	var failed:Bool;
	var project:OpenFLProject;
}
