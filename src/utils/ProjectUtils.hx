package utils;

import massive.sys.io.FileSys;
import utils.CommandUtils;
import utils.TemplateUtils;
import utils.TemplateUtils.TemplateReplacement;
import massive.sys.cmd.Console;
import FlxTools.IDE;
using StringTools;

class ProjectUtils
{
	/**
	 * Shortcut Create an OpenFL project by recursively copying the folder according to a name
	 *
	 * @param   Name	The name of the demo to create
	 */
	static public function duplicateProject(Project:OpenFLProject, Destination:String = "", IDE:String = ""):Bool
	{
		var result = CommandUtils.copyRecursively(Project.path, Destination);

		if (result)
		{
			CommandUtils.copyRecursively(Project.path, Destination);

			var replacements = new Array<TemplateReplacement>();
			replacements.push(TemplateUtils.addOption("${PROJECT_NAME}", "", Project.name));
			replacements = copyIDETemplateFiles(Destination, replacements, IDE);

			TemplateUtils.modifyTemplate(Destination, replacements);
		}
		return result;
	}

	/**
	 * Scan a Directory recursively for OpenFL projects
	 * @return An Array containing projects with an XML specified
	 */
	static public function scanOpenFLProjects(TargetDirectory:String, recursive:Bool = true):Array<OpenFLProject>
	{
		var projects = new Array<OpenFLProject>();

		if (FileSys.exists(TargetDirectory))
		{
			for (name in FileSys.readDirectory(TargetDirectory))
			{
				var folderPath:String = CommandUtils.combine(TargetDirectory, name);

				if (FileSys.isDirectory(folderPath) && !StringTools.startsWith(name, "."))
				{
					var projectPath = scanProjectXML(folderPath);

					if (projectPath != "")
					{
						projects.push({
							name : name,
							path : folderPath,
							projectXmlPath : projectPath,
							targets : ""
						});
					}

					var subProjects = scanOpenFLProjects(folderPath);
					if (subProjects.length>0)
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

	static public function copyIDETemplateFiles(TargetPath:String, ?Replacements:Array<TemplateReplacement>, IDEOption:String = ""):Array<TemplateReplacement>
	{
		if (Replacements == null)
			Replacements = new Array<TemplateReplacement>();

		Replacements.push(TemplateUtils.addOption("${AUTHOR}", "", FlxTools.settings.AuthorName));

		if (IDEOption == "" && FlxTools.settings.IDEAutoOpen)
		{
			IDEOption = FlxTools.settings.DefaultEditor;
		}
		else if (IDEOption == "")
		{
			IDEOption = IDE.NONE;
		}

		if (IDEOption == IDE.SUBLIME_TEXT)
		{
			Replacements.push(TemplateUtils.addOption("${PROJECT_PATH}", "", TargetPath.replace('\\', '\\\\')));
			Replacements.push(TemplateUtils.addOption("${HAXE_STD_PATH}", "", CommandUtils.combine(CommandUtils.getHaxePath(), "std").replace('\\', '\\\\')));
			Replacements.push(TemplateUtils.addOption("${FLIXEL_PATH}", "", CommandUtils.getHaxelibPath('flixel').replace('\\', '\\\\')));
			Replacements.push(TemplateUtils.addOption("${FLIXEL_ADDONS_PATH}", "", CommandUtils.getHaxelibPath('flixel-addons').replace('\\', '\\\\')));

			CommandUtils.copyRecursively(FlxTools.sublimeSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (IDEOption == IDE.INTELLIJ_IDEA)
		{
			Replacements.push(TemplateUtils.addOption("${IDEA_flexSdkName}", "", FlxTools.settings.IDEA_flexSdkName));
			Replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Engine_Library}", "", FlxTools.settings.IDEA_Flixel_Engine_Library));
			Replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Addons_Library}", "", FlxTools.settings.IDEA_Flixel_Addons_Library));

			CommandUtils.copyRecursively(FlxTools.intellijSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (IDEOption == IDE.FLASH_DEVELOP)
		{
			Replacements.push(TemplateUtils.addOption("${WIDTH}", "", FlxTools.PWIDTH));
			Replacements.push(TemplateUtils.addOption("${HEIGHT}", "", FlxTools.PHEIGHT));

			CommandUtils.copyRecursively(FlxTools.flashDevelopSource, TargetPath, TemplateUtils.TemplateFilter, true);
		}
		else if (IDEOption == IDE.FLASH_DEVELOP_FDZ)
		{
			//todo
		}

		return Replacements;
	}

	static public function resolveIDEChoice(console:Console):String
	{
		var ide = "";
		var overrideIDE = "";

		var options = [
			"-subl" => IDE.SUBLIME_TEXT,
			"-fd" => IDE.FLASH_DEVELOP,
			"-idea" => IDE.INTELLIJ_IDEA,
			"-noide" => IDE.NONE,
		];

		for (option in options.keys())
		{
			var IDEName = options.get(option);

			if (console.getOption(option) != null)
			{
				overrideIDE = IDEName;
			}
		}

		if (FlxTools.settings.IDEAutoOpen || overrideIDE != "")
		{
			if (overrideIDE != "")
				ide = overrideIDE;
			else
				ide = FlxTools.settings.DefaultEditor;
		}

		return ide;
	}

	static public function IDEAutoOpen(ProjectPath:String, ProjectName:String, ide:String, AutoContinue:Bool = false):Bool
	{
		var answer = Answer.Yes;

		if (!AutoContinue)
		{
			answer = CommandUtils.askYN("Do you want to open it with " + ide + "?");
		}

		if (answer == Answer.Yes)
		{
			if (ide == IDE.FLASH_DEVELOP)
			{
				var projectFile = CommandUtils.combine(ProjectPath, ProjectName + ".hxproj");
				projectFile = StringTools.replace(projectFile, "/", "\\");

				if (FileSys.exists(projectFile))
				{
					Sys.println(projectFile);
					var sublimeOpen = "explorer " + projectFile;
					Sys.command(sublimeOpen);

					return true;
				}
			}
			else if (ide == IDE.SUBLIME_TEXT)
			{
				var projectFile = CommandUtils.combine(ProjectPath, ProjectName + ".sublime-project");

				if (FileSys.exists(projectFile))
				{
					Sys.println(projectFile);
					if (FileSys.isMac || FileSys.isLinux)
					{
						var sublimeOpen = "subl " + projectFile;
						Sys.command(sublimeOpen);
					}
					else if (FileSys.isWindows)
					{
						//todo
					}

					return true;
				}
			}
			else if (ide == IDE.INTELLIJ_IDEA)
			{
				var projectFile = CommandUtils.combine(ProjectPath, ".idea");

				if (FileSys.exists(projectFile))
				{
					if (FileSys.isMac)
					{
						var cmd = FlxTools.settings.IDEA_Path + " " + ProjectPath;
						Sys.command(cmd);
					}
					else if (FileSys.isWindows)
					{
						//C://
					}
					else if (FileSys.isLinux)
					{
						//todo untested
						var cmd = FlxTools.settings.IDEA_Path + " " + ProjectPath;
						Sys.command(cmd);
					}
					return true;
				}
			}
		}

		return false;
	}
}

typedef OpenFLProject = {
	var name:String;
	var path:String;
	var projectXmlPath:String;
	var targets:String;
}