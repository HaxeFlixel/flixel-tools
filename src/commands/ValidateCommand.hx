package commands;

import sys.io.File;
import utils.CommandUtils;
import utils.DemoUtils;
import massive.sys.io.FileSys;
import utils.ProjectUtils.OpenFLProject;
import massive.sys.cmd.Command;

class ValidateCommand extends Command
{
	inline static public var PASSED:String = "PASSED";
	inline static public var FAILED:String = "FAILED";

	override public function execute():Void
	{
		compileAllDemos();
	}

	/**
	 * Validate all the demos recursively
	 *
	 * @param   Location    Location of the demos directory to scan and validate
	 */
	private function compileAllDemos(Location:String = ""):Void
	{
		if (Location == "")
		{
			Sys.println(" Copying all demos into the current working directory.");

			var demosPath:String = CommandUtils.getHaxelibPath("flixel-demos");

			Location = Sys.getCwd() + "flixel-demos-validation/";

			CommandUtils.copyRecursively(demosPath, Location);
		}

		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if(projects == null)
			error("No Demos were found in haxelib flixel-demos");

		var results = new Array<BuildResult>();

		Sys.println(" " + Lambda.count(projects) + " demos available to compile.");
		Sys.println("");

		for (project in projects)
		{
			var demoProject:OpenFLProject = project;

			if(demoProject.TARGETS == "flash-")
			{
				results.push(buildProject("flash", demoProject));
			}
			else if (demoProject.TARGETS == "non-flash")
			{
				results.push(buildProject("neko", demoProject));
				//results.push(buildProject("native", demoProject));
			}
			else
			{
				results.push(buildProject("flash", demoProject));
				//results.push(buildProject("neko", demoProject));
				//results.push(buildProject("native", demoProject));
				//results.push(buildProject("html5", demoProject));
			}
		}

		Sys.println ("");

		writeResultsToFile(Sys.getCwd() + "validate.log", results);

		var totalResult = true;

		var failed = 0;
		var passed = 0;
		var total = results.length;

		for (result in results)
		{
			if(result.result == FAILED)
			{
				failed++;
				totalResult = false;
			}
			else
			{
				passed++;
			}
		}

		Sys.println("Demos Total   : " + total);
		Sys.println("Builds Failed : " + failed);
		Sys.println("Builds Passed : " + passed);
		Sys.println(passed);

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
			fileObject.writeString("Project Name    :" + result.project.NAME + "\n");
			fileObject.writeString("Project Path    :" + result.project.PATH + "\n");
			fileObject.writeString("Targets         :" + result.project.TARGETS + "\n");
			fileObject.writeString("Build Target    :" + result.target + "\n");
			fileObject.writeString("Build Result    :" + result.result + "\n");
			fileObject.writeString("\n");
		}

		fileObject.writeString("\n");
		fileObject.writeString(" / End of Log.");

		fileObject.close();
	}

	/**
	 * Build an openfl target
	 *
	 * @param   Target      The openfl target to build
	 * @param   Project     OpenFLProject The project object to build from
	 * @param   Display     Echo progress on the command line
	 * @return  BuildResult the result of the compilation
	 */
	private function buildProject(Target:String, Project:OpenFLProject, Display:Bool = true):BuildResult
	{
		if (Target == "native")
		{
			if (FileSys.isWindows)
			{
				Target = "windows";
			}
			else if (FileSys.isMac)
			{
				Target = "mac";
			}
			else if (FileSys.isLinux)
			{
				Target = "linux";
			}
		}

		var buildCommand:String = "haxelib run openfl build " + "'" + Project.PATH + "'" + " " + Target;

		if (Display)
		{
			Sys.println("");
			Sys.println(" Compile " + Target + ":: " + buildCommand);
		}

		var compile:Int = Sys.command(buildCommand);

		if (Display)
		{
			Sys.println("");
			Sys.println(" " + Target + "::" + getResult(compile));
		}

		var project:BuildResult = {
			result : getResult(compile),
			target : Target,
			project : Project
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
			return PASSED;
		}
		else
		{
			return FAILED;
		}
	}
}

/**
 * Object to pass the build result of a project
 */
typedef BuildResult = {
	var target:String;
	var result:String;
	var project:OpenFLProject;
}
