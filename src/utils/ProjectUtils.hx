package utils;

import sys.FileSystem;
import haxe.io.Path;

class ProjectUtils
{
	/**
	 * Compile an openfl project to different targets and return the results
	 * @param  project         [description]
	 * @param  targets<string> [description]
	 * @return                 [description]
	 */
	static public function compileProject(project:OpenFLProject, targets:Array<String>):Void
	{
		
	}

	static public function compileTo(project:OpenFLProject, target:String):Void
	{
		
	}

	/**
	 * Shortcut Create an OpenFL project by recursivly copying the folder according to a name
	 * 
	 * @param   Name    The name of the demo to create
	 */
	static public function duplicateProject(project:OpenFLProject, destination:String=""):Bool
	{
		return CommandUtils.copyRecursivley(project.PATH,destination);
	}

	/**
	 * Scan a Directory recursivley for OpenFL projects
	 * @return Array<OpenFLProject> containing projects with an XML specified
	 */
	static public function scanOpenFLProjects(TargetDirectory:String, recursive:Bool = false, TargetFolders:Array<String> = null):Array<OpenFLProject>
	{
		var projects = new Array<OpenFLProject>();
		
		for (name in FileSystem.readDirectory(TargetDirectory))
		{
			var folderPath:String = TargetDirectory + "/" + name;
			
			if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(folderPath))
			{
				var projectXMLPath:String = scanProjectFile(folderPath);
				
				if (projectXMLPath == "" && recursive)
				{
					for ( targetFolder in TargetFolders )
					{
						if (name == targetFolder)
						{
							var subpath:String = folderPath;
							var childProjects:Array<OpenFLProject> = scanOpenFLProjects(subpath);
							
							for (childProject in childProjects)
							{
								var project:OpenFLProject = childProject;
								project.TARGETS = name;
								
								if (FileSystem.exists(project.PATH))
								{
									projects.push(project);
								}
							}
						}
					}
				}
				else
				{
					var project:OpenFLProject = 
					{ 
						NAME : name,
						PATH : folderPath,
						PROJECTXMLPATH : projectXMLPath,
						TARGETS : "All",
					};
					
					if (FileSystem.exists(project.PATH))
					{
						projects.push(project);
					}
				}
			}
		}
		return projects;
	}

	/**
	* Scans a path for openfl/nme project files
	* 
	* @author   Joshua Granick from a method in openfl-tools
	* @return   The path of the project file found
	*/
	static private function scanProjectFile(ProjectPath:String):String
	{
		if (FileSystem.exists(CommandUtils.combine(ProjectPath, "Project.hx")))
		{
			return CommandUtils.combine(ProjectPath, "Project.hx");
		}
		else if (FileSystem.exists(CommandUtils.combine(ProjectPath, "project.xml")))
		{
			return CommandUtils.combine(ProjectPath, "project.xml");
		}
		else
		{
			var files = FileSystem.readDirectory(ProjectPath);
			var matches = new Map <String, Array <String>>();
			matches.set("xml", []);
			matches.set("hx", []);
			
			for (file in files)
			{
				var path = CommandUtils.combine(ProjectPath, file);
				
				if (FileSystem.exists(path) && !FileSystem.isDirectory(path))
				{
					var extension:String = Path.extension(file);
					
					if ((extension == "xml" && file != "include.xml") || extension == "hx")
					{
						matches.get(extension).push(path);
					}
				}
			}
			
			if (matches.get("xml").length > 0)
			{
				return matches.get("xml")[0];
			}
			
			if (matches.get("hx").length > 0)
			{
				return matches.get("hx")[0];
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