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
	 * Shortcut to create a lime project by recursively copying the folder according to a name
	 *
	 * @param   Name	The name of the demo to create
	 */
	static public function duplicateProject(Project:LimeProject, Destination:String = "", IDE:String = ""):Bool
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
	 * Recursively search a directory for Lime projects
	 */
	static public function findLimeProjects(TargetDirectory:String):Array<LimeProject>
	{
		var projects = [];

		if (!FileSys.exists(TargetDirectory))
			return [];
		
		for (name in FileSys.readDirectory(TargetDirectory))
		{
			var folderPath:String = CommandUtils.combine(TargetDirectory, name);	
			
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
	static private function findProjectXml(ProjectPath:String):String
	{
		var targetProjectFile = CommandUtils.combine(ProjectPath, "project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;

		targetProjectFile = CommandUtils.combine(ProjectPath, "Project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;
		
		return null;
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
		Sys.println(projectFile);
		if (FileSys.exists(projectFile))
		{
			Sys.println(projectFile);
			Sys.command("explorer " + projectFile);
			return true;
		}
		return false;
	}
	
	static public function openWithSublimeText(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, projectName + ".sublime-project");
		
		if (FileSys.exists(projectFile))
		{
			Sys.println(projectFile);
			if (FileSys.isMac || FileSys.isLinux)
			{
				Sys.command("subl " + projectFile);
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
				Sys.command(FlxTools.settings.IDEA_Path + " " + projectPath);
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