package utils;

import utils.ProjectUtils;
import utils.ProjectUtils.OpenFLProject;
import utils.CommandUtils;

class DemoUtils
{
	/**
	 * Check if a Demo exists from an index of all demos
	 * @param  Name String the name of the demo to check
	 * @return      OpenFLProject or null if it doesn't exist
	 */
	static public function getDemoByIndex(Index:Int, DemoPath:String = ""):OpenFLProject
	{
		var demos = scanDemoProjects(DemoPath);

		if(demos == null)
		{
			return null;
		}
		else if (demos[Index] != null)
		{
			return demos[Index];
		}
		else
		{
			return null;
		}
	}

	/**
	 * Scan all available Demos to see if one exists by name.
	 * @param  Name String the name of the demo to check
	 * @return      OpenFLProject or null if it doesn't exist
	 */
	static public function demoExists(Name:String):OpenFLProject
	{
		var demos = scanDemoProjects();

		if(demos == null)
			return null;
		
		for (demo in demos)
		{
			var demoProject:OpenFLProject = demo;
			
			if (demoProject.NAME == Name)
			{
				return demoProject;
			}
		}
		return null;
	}

	/**
	 * Scan a folder recursively for OpenFL project files
	 *
	 * @param   DemosPath       An optional path to scan, default being flixel-demos Haxelib
	 * @param   Display         [description]
	 * @return                  Array<OpenFLProject> or null if no Demos were found 
	 */
	static public function scanDemoProjects(DemosPath:String = ""):Array<OpenFLProject>
	{
		if (DemosPath == "")
		{
			DemosPath = CommandUtils.getHaxelibPath("flixel-demos");
			Sys.println(DemosPath);
			if (DemosPath == "")
			{
				return null;
			}
		}

		var targets = ["flash-","non-flash-"];
		var projects:Array<OpenFLProject> = ProjectUtils.scanOpenFLProjects(DemosPath, true, targets);

		if (Lambda.count(projects) > 0)
		{
			return projects;
		}
		else
		{
			return null;
		}
	}
}