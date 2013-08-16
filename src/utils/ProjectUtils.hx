package utils;

import utils.CommandUtils;
import massive.sys.io.File;
import massive.sys.util.ZipUtil;
import utils.TemplateUtils;
import utils.TemplateUtils.TemplateReplacement;
import massive.sys.io.FileSys;

class ProjectUtils
{
	/**
	 * Shortcut Create an OpenFL project by recursively copying the folder according to a name
	 * 
	 * @param   Name    The name of the demo to create
	 */
	static public function duplicateProject(Project:OpenFLProject, Destination:String = "", IDETemplate:String = ""):Bool
	{
		var result = CommandUtils.copyRecursively(Project.PATH, Destination);

		if(result)
		{
			CommandUtils.copyRecursively(Project.PATH, Destination);

			var replacements = copyIDETemplateFiles(Destination);
			replacements.push(TemplateUtils.addOption("${PROJECT_NAME}", "", Project.NAME));

			TemplateUtils.modifyTemplate(Destination, replacements);
		}
		return result;
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
	* Scans a path for OpenFL project.xml
	*
	*/
	static private function scanProjectXML(ProjectPath:String):String
	{
		var targetProjectFile = CommandUtils.combine(ProjectPath, "project.xml");

		if (FileSys.exists(targetProjectFile))
		{
			return targetProjectFile;
		}

		targetProjectFile = CommandUtils.combine(ProjectPath, "Project.xml");
		if (FileSys.exists(targetProjectFile))
		{
			return targetProjectFile;
		}
		return "";
	}

	static public function copyIDETemplateFiles(TargetPath:String, ?Replacements:Array<TemplateReplacement>, ideOption:String = ""):Array<TemplateReplacement>
	{
		if(Replacements == null)
			Replacements = new Array<TemplateReplacement>();

		if(ideOption == "")
			ideOption = FlxTools.settings.DefaultEditor;

		if (ideOption == FlxTools.SUBLIME_TEXT)
		{
			Replacements.push(TemplateUtils.addOption("${PROJECT_PATH}", "", TargetPath));
			Replacements.push(TemplateUtils.addOption("${HAXE_STD_PATH}", "", CommandUtils.combine(CommandUtils.getHaxePath(), "std")));
			Replacements.push(TemplateUtils.addOption("${FLIXEL_PATH}", "", CommandUtils.getHaxelibPath('flixel')));
			Replacements.push(TemplateUtils.addOption("${FLIXEL_ADDONS_PATH}", "", CommandUtils.getHaxelibPath('flixel-addons')));

			CommandUtils.copyRecursively(FlxTools.sublimeSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (ideOption == FlxTools.INTELLIJ_IDEA)
		{
			Replacements.push(TemplateUtils.addOption("${IDEA_flexSdkName}", "", FlxTools.settings.IDEA_flexSdkName));
			Replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Engine_Library}", "", FlxTools.settings.IDEA_Flixel_Engine_Library));
			Replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Addons_Library}", "", FlxTools.settings.IDEA_Flixel_Addons_Library));

			CommandUtils.copyRecursively(FlxTools.intellijSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (ideOption == FlxTools.FLASH_DEVELOP)
		{
            Replacements.push(TemplateUtils.addOption("${WIDTH}", "", FlxTools.PWIDTH));
            Replacements.push(TemplateUtils.addOption("${HEIGHT}", "", FlxTools.PHEIGHT));

            CommandUtils.copyRecursively(FlxTools.flashDevelopSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (ideOption == FlxTools.FLASH_DEVELOP_FDZ)
		{
			//todo
		}

		return Replacements;
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