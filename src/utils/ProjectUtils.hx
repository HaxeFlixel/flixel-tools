package utils;

import massive.sys.io.FileSys;
import utils.CommandUtils;
import utils.TemplateUtils;
import massive.sys.cmd.Console;
import FlxTools.IDE;
using StringTools;

class ProjectUtils
{
	/**
	 * Shortcut to create a lime project by recursively copying the folder according to a name
	 */
	static public function duplicateProject(project:LimeProject, destination:String, ide:IDE):Bool
	{
		var result = CommandUtils.copyRecursively(project.path, destination);
		if (result)
		{
			CommandUtils.copyRecursively(project.path, destination);

			var replacements = new Array<TemplateReplacement>();
			replacements.push(TemplateUtils.addOption("${PROJECT_NAME}", "", project.name));
			replacements = copyIDETemplateFiles(destination, replacements, ide);

			TemplateUtils.modifyTemplate(destination, replacements);
		}
		return result;
	}

	/**
	 * Recursively search a directory for Lime projects
	 */
	static public function findLimeProjects(targetDirectory:String):Array<LimeProject>
	{
		var projects = [];

		if (!FileSys.exists(targetDirectory))
			return [];
		
		for (name in FileSys.readDirectory(targetDirectory))
		{
			var folderPath:String = CommandUtils.combine(targetDirectory, name);	
			
			if (FileSys.isDirectory(folderPath) && !name.startsWith("."))	
			{	
				var projectPath = findProjectXml(folderPath);	
				if (projectPath != null)
				{	
					projects.push({	
						name : name,	
						path : folderPath,	
						projectXmlPath : projectPath,	
						targets : ""	
					});	
				}	
			
				projects = projects.concat(findLimeProjects(folderPath));	
			}	
		}	
		
		return projects;
	}

	/**
	 * Searches a path for a Lime project xml file
	 */
	static private function findProjectXml(projectPath:String):String
	{
		var targetProjectFile = CommandUtils.combine(projectPath, "project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;

		targetProjectFile = CommandUtils.combine(projectPath, "Project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;
		
		return null;
	}

	static public function copyIDETemplateFiles(targetPath:String, replacements:Array<TemplateReplacement>, ide:IDE):Array<TemplateReplacement>
	{
		if (replacements == null)
			replacements = new Array<TemplateReplacement>();

		replacements.push(TemplateUtils.addOption("${AUTHOR}", "", FlxTools.settings.AuthorName));

		if (ide == IDE.SUBLIME_TEXT)
		{
			replacements.push(TemplateUtils.addOption("${PROJECT_PATH}", "", targetPath.replace('\\', '\\\\')));
			replacements.push(TemplateUtils.addOption("${HAXE_STD_PATH}", "", CommandUtils.combine(CommandUtils.getHaxePath(), "std").replace('\\', '\\\\')));
			replacements.push(TemplateUtils.addOption("${FLIXEL_PATH}", "", CommandUtils.getHaxelibPath('flixel').replace('\\', '\\\\')));
			replacements.push(TemplateUtils.addOption("${FLIXEL_ADDONS_PATH}", "", CommandUtils.getHaxelibPath('flixel-addons').replace('\\', '\\\\')));

			CommandUtils.copyRecursively(FlxTools.sublimeSource, targetPath, TemplateUtils.templateFilter, true);
		}
		else if (ide == IDE.INTELLIJ_IDEA)
		{
			replacements.push(TemplateUtils.addOption("${IDEA_flexSdkName}", "", FlxTools.settings.IDEA_flexSdkName));
			replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Engine_Library}", "", FlxTools.settings.IDEA_Flixel_Engine_Library));
			replacements.push(TemplateUtils.addOption("${IDEA_Flixel_Addons_Library}", "", FlxTools.settings.IDEA_Flixel_Addons_Library));

			CommandUtils.copyRecursively(FlxTools.intellijSource, targetPath, TemplateUtils.templateFilter, true);
		}
		else if (ide == IDE.FLASH_DEVELOP)
		{
			replacements.push(TemplateUtils.addOption("${WIDTH}", "", FlxTools.PWIDTH));
			replacements.push(TemplateUtils.addOption("${HEIGHT}", "", FlxTools.PHEIGHT));

			CommandUtils.copyRecursively(FlxTools.flashDevelopSource, targetPath, TemplateUtils.templateFilter, true);
		}
		else if (ide == IDE.FLASH_DEVELOP_FDZ)
		{
			//todo
		}

		return replacements;
	}

	static public function resolveIDEChoice(console:Console):IDE
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

	static public function openWithIDE(projectPath:String, projectName:String, ide:IDE):Bool
	{
		var ideHandlers:Map<String, String->String->Bool> = [
			IDE.FLASH_DEVELOP => openWithFlashDevelop,
			IDE.SUBLIME_TEXT => openWithSublimeText,
			IDE.INTELLIJ_IDEA => openWithIntelliJIDEA
		];

		var result = false;
		var handler = ideHandlers[ide];
		if (handler != null)
		{
			result = handler(projectPath, projectName);
			if (!result)
				Sys.println('Could not open the project with $ide');
		}
		return result;
	}
	
	static public function openWithFlashDevelop(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, projectName + ".hxproj");
		projectFile = projectFile.replace("/", "\\");
		
		if (FileSys.exists(projectFile))
		{
			Sys.command("explorer", [projectFile]);
			return true;
		}
		return false;
	}
	
	static public function openWithSublimeText(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, projectName + ".sublime-project");
		
		if (FileSys.exists(projectFile))
		{
			if (FileSys.isMac || FileSys.isLinux)
			{
				Sys.command("subl", [projectFile]);
			}
			// TODO: windows
			return true;
		}
		return false;
	}
	
	static public function openWithIntelliJIDEA(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, ".idea");
		
		if (FileSys.exists(projectFile))
		{
			if (FileSys.isMac || FileSys.isLinux) // TODO: test on linux
			{
				Sys.command(FlxTools.settings.IDEA_Path, [projectPath]);
			}
			// TODO: windows
			return true;
		}
		return false;
	}
}

typedef LimeProject = {
	var name:String;
	var path:String;
	var projectXmlPath:String;
	var targets:String;
}