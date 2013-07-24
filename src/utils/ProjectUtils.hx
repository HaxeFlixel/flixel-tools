package utils;

import massive.sys.io.FileSys;
import haxe.io.Path;

class ProjectUtils
{
	/**
	 * Shortcut Create an OpenFL project by recursively copying the folder according to a name
	 * 
	 * @param   Name    The name of the demo to create
	 */
	static public function duplicateProject(project:OpenFLProject, destination:String = ""):Bool
	{
		return CommandUtils.copyRecursively(project.PATH, destination);
	}

	/**
	 * Scan a Directory recursively for OpenFL projects
	 * @return Array<OpenFLProject> containing projects with an XML specified
	 */
	static public function scanOpenFLProjects(TargetDirectory:String, recursive:Bool = true, TargetFolders:Array<String> = null):Array<OpenFLProject>
	{
		var projects = new Array<OpenFLProject>();

		if (FileSys.exists(TargetDirectory))
		{
			for (name in FileSys.readDirectory(TargetDirectory))
			{
				var folderPath:String = CommandUtils.combine(TargetDirectory, name);

				if(FileSys.isDirectory(folderPath) && !StringTools.startsWith(name, "."))
				{
					var projectPath = scanProjectXML(folderPath);

					if(projectPath != "")
					{
						var project:OpenFLProject =
						{
							NAME : name,
							PATH : folderPath,
							PROJECTXMLPATH : projectPath,
							TARGETS : ""
						};
						projects.push(project);
					}

					var subProjects = scanOpenFLProjects(folderPath);
					if(subProjects.length>0)
					{
						for (o in subProjects)
						{
							projects.push(o);
						}
					}
				}
			}
		}

		return projects;
	}

	/**
	* Scans a path for OpenFL project xml
	* 
	* @author   Joshua Granick from a method in openfl-tools
	* @return   The path of the project file found
	*/
	static private function scanProjectXML(ProjectPath:String):String
	{
		if (FileSys.exists(CommandUtils.combine(ProjectPath, "project.xml")))
		{
			var file = CommandUtils.combine(ProjectPath, "project.xml");
			return file;
		}
		else if( FileSys.exists(ProjectPath))
		{
			if( FileSys.isDirectory(ProjectPath))
			{
				var files = FileSys.readDirectory(ProjectPath);
				var matches = new Map <String, Array <String>>();
				matches.set("xml", []);

				for (file in files)
				{
					var path = CommandUtils.combine(ProjectPath, file);

					if (FileSys.exists(path) && !FileSys.isDirectory(path))
					{
						var extension:String = Path.extension(file);

						if ((extension == "xml" && file != "include.xml"))
						{
							matches.get(extension).push(path);
						}
					}
				}

				if (matches.get("xml").length > 0)
				{
					return matches.get("xml")[0];
				}
			}
		}
		return "";
	}
}

/**
 * Object to pass the data of a project
 */
typedef OpenFLProject = {
	var NAME:String;
	var PATH:String;
	var PROJECTXMLPATH:String;
	var TARGETS:String;
}