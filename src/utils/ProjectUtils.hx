package utils;

import haxe.io.Path;
import haxe.xml.Fast;
import sys.io.File;
import massive.sys.io.FileSys;
import utils.CommandUtils;
import utils.CommandUtils.runCommand;
import utils.TemplateUtils;
import massive.sys.cmd.Console;
import FlxTools.IDE;
using StringTools;

class ProjectUtils
{
	/**
	 * Shortcut to create a lime project by recursively copying the folder according to a name
	 */
	public static function duplicateProject(project:LimeProject, destination:String, ide:IDE):Bool
	{
		var result = CommandUtils.copyRecursively(project.path, destination, ~/export/, true);
		if (result)
		{
			var replacements = new Array<TemplateReplacement>();
			replacements.push(TemplateUtils.addOption("PROJECT_NAME", "", project.name));

			Sys.println('Adding project files for $ide (can be changed with "flixel setup")...\n');
			replacements = copyIDETemplateFiles(destination, replacements, ide);

			TemplateUtils.modifyTemplate(destination, replacements);
			TemplateUtils.initializeProject(destination, ide);
		}
		return result;
	}

	/**
	 * Recursively search a directory for Lime projects
	 */
	public static function findLimeProjects(directory:String):Array<LimeProject>
	{
		var projects = [];

		if (!FileSys.exists(directory))
			return projects;

		var projectPath = findProjectXml(directory);
		if (projectPath != null)
		{
			projects.push({
				name: new Path(directory).file,
				path: directory,
				projectXmlPath: projectPath,
				targets: ""
			});
		}
		
		for (name in FileSys.readDirectory(directory))
		{
			var folderPath:String = CommandUtils.combine(directory, name);
			if (FileSys.isDirectory(folderPath) && !name.startsWith("."))
				projects = projects.concat(findLimeProjects(folderPath));
		}

		return projects;
	}

	public static function getApplicationFile(projectXmlPath:String):String
	{
		var fast = new Fast(Xml.parse(File.getContent(projectXmlPath)));
		return fast.node.project.node.app.att.file;
	}

	/**
	 * Searches a path for a Lime project xml file
	 */
	public static function findProjectXml(projectPath:String):String
	{
		var targetProjectFile = CommandUtils.combine(projectPath, "project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;

		targetProjectFile = CommandUtils.combine(projectPath, "Project.xml");
		if (FileSys.exists(targetProjectFile))
			return targetProjectFile;

		return null;
	}

	public static function copyIDETemplateFiles(targetPath:String, replacements:Array<TemplateReplacement>, ide:IDE):Array<TemplateReplacement>
	{
		if (replacements == null)
			replacements = [];

		var templateSource:String = FlxTools.templateSourcePaths[ide];
		if (templateSource == null)
			return replacements;
		
		if (!FileSys.exists(templateSource))
		{
			Sys.println('$ide template path does not exist (expected \'$templateSource\').');
			Sys.println("\nIs flixel-templates up-to-date? Try running 'haxelib update flixel-templates'.");
			Sys.exit(1);
		}

		var settings = FlxTools.settings;
		function addOption(name:String, defaultValue:Dynamic)
			replacements.push(TemplateUtils.addOption(name, "", defaultValue));

		addOption("AUTHOR", settings.AuthorName);

		switch (ide)
		{
			case IDE.SUBLIME_TEXT:
				var escape = function(path:String) return path.replace('\\', '\\\\');
				addOption("PROJECT_PATH", escape(targetPath));
				addOption("HAXE_STD_PATH", escape(CommandUtils.combine(CommandUtils.getHaxePath(), "std")));
				addOption("FLIXEL_PATH", escape(CommandUtils.getHaxelibPath('flixel')));
				addOption("FLIXEL_ADDONS_PATH", escape(CommandUtils.getHaxelibPath('flixel-addons')));

			case IDE.INTELLIJ_IDEA:
				addOption("IDEA_flexSdkName", settings.IDEA_flexSdkName);
				addOption("IDEA_Flixel_Engine_Library", settings.IDEA_Flixel_Engine_Library);
				addOption("IDEA_Flixel_Addons_Library", settings.IDEA_Flixel_Addons_Library);

			case IDE.FLASH_DEVELOP:
				addOption("WIDTH", 640);
				addOption("HEIGHT", 480);

			case _: // TODO: IDE.FLASH_DEVELOP_FDZ
		}

		if (templateSource != null)
			CommandUtils.copyRecursively(templateSource, targetPath, TemplateUtils.templateFilter, true);

		return replacements;
	}

	public static function resolveIDEChoice(console:Console):IDE
	{
		var options = [
			"subl" => IDE.SUBLIME_TEXT,
			"fd" => IDE.FLASH_DEVELOP,
			"idea" => IDE.INTELLIJ_IDEA,
			"vscode" => IDE.VISUAL_STUDIO_CODE,
			"none" => IDE.NONE
		];

		var ide = IDE.NONE;
		if (FlxTools.settings != null)
			ide = FlxTools.settings.DefaultEditor;

		var ideOption = console.getOption("ide");
		if (ideOption != null)
			ide = options[ideOption];

		return ide;
	}

	public static function openWithIDE(projectPath:String, projectName:String, ide:IDE):Bool
	{
		var ideHandlers:Map<String, String->String->Bool> = [
			IDE.FLASH_DEVELOP => openWithFlashDevelop,
			IDE.SUBLIME_TEXT => openWithSublimeText,
			IDE.INTELLIJ_IDEA => openWithIntelliJIDEA,
			IDE.VISUAL_STUDIO_CODE => openWithVisualStudioCode
		];

		var result = false;
		var handler = ideHandlers[ide];
		if (handler != null)
		{
			Sys.println('Opening the project with $ide (can be changed with "flixel setup")...');
			result = handler(projectPath, projectName);
			if (!result)
				Sys.println('Could not open the project with $ide');
		}
		return result;
	}

	public static function openWithFlashDevelop(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, projectName + ".hxproj");
		projectFile = projectFile.replace("/", "\\");

		if (FileSys.exists(projectFile))
		{
			runCommand("explorer", [projectFile]);
			return true;
		}
		return false;
	}

	public static function openWithSublimeText(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, projectName + ".sublime-project");

		if (FileSys.exists(projectFile))
		{
			if (FileSys.isMac || FileSys.isLinux)
			{
				runCommand("subl", [projectFile]);
			}
			// TODO: windows
			return true;
		}
		return false;
	}

	public static function openWithIntelliJIDEA(projectPath:String, projectName:String):Bool
	{
		var projectFile = CommandUtils.combine(projectPath, ".idea");

		if (FileSys.exists(projectFile))
		{
			if (FileSys.isMac)
			{
				runCommand("open", ["-a", FlxTools.settings.IDEA_Path, projectPath]);
			}
			else if (FileSys.isLinux)
			{
				runCommand('"' + FlxTools.settings.IDEA_Path + '" "' + projectPath + '" &');
			}
			else if (FileSys.isWindows)
			{
				runCommand(FlxTools.settings.IDEA_Path, [projectPath]); //Not tested, but should work
			}

			return true;
		}
		return false;
	}

	public static function openWithVisualStudioCode(projectPath:String, projectName:String):Bool
	{
		runCommand("code", [projectPath]);
		return true;
	}
}

typedef LimeProject = {
	var name:String;
	var path:String;
	var projectXmlPath:String;
	var targets:String;
}
