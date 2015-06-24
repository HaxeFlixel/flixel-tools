package utils;

import utils.CommandUtils;
import utils.ProjectUtils;
import utils.ProjectUtils.LimeProject;

class DemoUtils
{
	static public function askQuestionDemoStrings(Question:String, Header:String, Answers:Array<String>, cancel:Bool = true):String
	{
		while (true)
		{
			Sys.println("");
			Sys.println(Header);
			Sys.println("");

			for( i in 0...Answers.length )
			{
				Sys.println(" [" + i + "] " + Answers[i]);
			}

			if (cancel)
			{
				Sys.println("");
				Sys.println(" [c] Cancel");
				Sys.println("");
			}

			Sys.println("");
			Sys.println(Question);
			Sys.println("");

			var userResponse = CommandUtils.readLine();
			var validAnswer = "";

			for (i in 0...Answers.length)
			{
				if (Answers[i] == userResponse || Std.string(i) == userResponse)
				{
					validAnswer = userResponse;
				}
				else if (userResponse == "c" && cancel)
				{
					Sys.println(" Cancelled");
					return	null;
				}
			}

			if (validAnswer != "")
			{
				if (exists(userResponse) != null)
				{
					return userResponse;
				}
				else
				{
					return Answers[Std.parseInt(userResponse)];
				}
			}
		}

		return null;
	}

	/**
	 * Check if a Demo exists from an index of all demos
	 * @param  Name String the name of the demo to check
	 * @return	  LimeProject or null if it doesn't exist
	 */
	static public function getByIndex(Index:Int, DemoPath:String = ""):LimeProject
	{
		var demos = findDemos(DemoPath);

		if (demos == null)
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
	 * @return	  LimeProject or null if it doesn't exist
	 */
	static public function exists(Name:String):LimeProject
	{
		var demos = findDemos();

		if (demos == null)
			return null;

		for (demo in demos)
		{
			var demoProject:LimeProject = demo;

			if (demoProject.name == Name)
			{
				return demoProject;
			}
		}
		return null;
	}

	/**
	 * Scan a folder recursively for Lime project files
	 *
	 * @param   DemosPath	   An optional path to scan, default being flixel-demos Haxelib
	 */
	static public function findDemos(DemosPath:String = ""):Array<LimeProject>
	{
		if (DemosPath == "")
		{
			DemosPath = CommandUtils.getHaxelibPath("flixel-demos");

			if (DemosPath == "")
				return [];
		}

		return ProjectUtils.findLimeProjects(DemosPath);
	}
}