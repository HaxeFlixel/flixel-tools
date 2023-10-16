package commands;

import FlxTools.IDE;
import haxe.io.Path;
import massive.sys.cmd.Command;
import sys.FileSystem;
import utils.CommandUtils;
import utils.FileSysUtils;
import utils.ProjectUtils;
import utils.TemplateUtils;

class Template extends Command
{
	var autoContinue:Bool = false;
	var ideOption = IDE.NONE;

	override public function execute()
	{
		/*
			Ways to use `template` command
			NOTE: literaly no one on github used "flixel tpl ./<new_dir>

			- tpl 
						creates "FlxProject" from "default" tpl inside "%cwd/default" dir
			- tpl -n MyGame
						creates "MyGame" from "default" tpl inside "%cwd/MyGame" dir
			- tpl demo
						creates "FlxProject" from "demo" tpl inside "%cwd/demo" dir
			- tpl demo -n MyGame
						creates "MyGame" from "demo" tpl inside "%cwd/MyGame" dir
			- tpl ./my-game
						creates "FlxProject" from "default" tpl inside "%cwd/my-game" dir
			- tpl ./my-game -n MyGame
						creates "MyGame" from "default" tpl inside "%cwd/my-game" dir
			- tpl demo my-game
						creates "FlxProject" from "demo" tpl inside "%cwd/my-game" dir
			- tpl demo my-game -n MyGame
						creates "MyGame" from "demo" tpl inside "%cwd/MyGame" dir
			- tpl ./demo ./../my-game
						creates "FlxProject" from "./demo" tpl inside "%cwd/../my-game" dir
			- tpl ../demo ./../my-game -n MyGame
						creates "MyGame" from "./demo" tpl inside "%cwd/../my-game" dir
		 */

		TemplateUtils.verifyTemplatesLoaded();

		var targetPath = "";
		var templateName = "";

		if (console.args[1] != null)
			templateName = console.args[1];

		if (console.args[2] != null)
			targetPath = console.args[2];

		if (console.getOption("-y") != null)
			autoContinue = true;

		ideOption = ProjectUtils.resolveIDEChoice(console, autoContinue);

		// support a path as an arg without name for default
		// flixel tpl ./<new_directory> <options>
		if (FileSysUtils.isDirectoryPath(templateName) && targetPath == "")
		{
			targetPath = templateName;
			templateName = "";
		}

		processTemplate(templateName, targetPath);
	}

	public function processTemplate(templateName:String, targetPath:String)
	{
		var template:TemplateProject = TemplateUtils.get(templateName);

		// to fake existence of non-existed templates,
		// will be deleted before merge
		if (template == null)
		{
			trace('template was faked');
			template = {
				name: templateName,
				path: 'some/path/to/${templateName}',
				template: {
					replacements: [
						{
							replacement: "FlxProject",
							cmdOption: "-n",
							pattern: "${PROJECT_NAME}"
						}
					]
				}
			}
		}

		if (template == null)
		{
			error('Error getting the template with the name of "${templateName}"'
				+ "\nMake sure you have installed flixel-templates ('haxelib install flixel-templates')");
		}
		else
		{
			templateName = template.name;
		}

		// override the template defaults form the command arguments
		template = addOptionReplacement(template);

		// try to use project name as target path
		if (targetPath == "" && console.getOption('-n') != null)
			targetPath = console.getOption('-n');

		if (targetPath == "")
		{
			targetPath = Path.join([Sys.getCwd(), templateName]);
		}
		else if (!Path.isAbsolute(targetPath))
		{
			targetPath = Path.join([Sys.getCwd(), targetPath]);
		}

		// used for tests, will be deleted before merge
		Sys.print('\n---------
template name: ${template.name}
template path: ${template.path}
target path: $targetPath
project name: ${console.getOption("-n") != null ? console.getOption("-n") : "FlxProject"}
---------\n');

		if (FileSystem.exists(targetPath))
		{
			Sys.println("Warning::" + targetPath);

			var answer = Answer.Yes;

			if (!autoContinue)
			{
				answer = CommandUtils.askYN("Directory exists - do you want to delete it first? Type . to abort.");
			}

			if (answer == Answer.Yes)
			{
				try
				{
					CommandUtils.deleteRecursively(targetPath);
				}
				catch (e:Dynamic)
				{
					Sys.println("Error while trying to delete the directory. Is it in use?");
					exit();
				}
			}
			else if (answer == null)
			{
				Sys.println("Aborted by user");
				exit();
			}
		}

		Sys.println('Copying template files...');

		Sys.println('Adding project files for $ideOption (can be changed with "flixel setup")...\n');
		template.template.replacements = ProjectUtils.copyIDETemplateFiles(targetPath, template.template.replacements, ideOption);

		CommandUtils.copyRecursively(template.path, targetPath, TemplateUtils.templateFilter, true);

		final projectName = TemplateUtils.getReplacementValue(template.template.replacements, "${PROJECT_NAME}");
		template.template.replacements.push(TemplateUtils.addOption("APPLICATION_FILE", "", projectName));
		TemplateUtils.modifyTemplateProject(targetPath, template, ideOption);

		Sys.println("Successfully created template at:");
		Sys.println(targetPath);
		Sys.println("");

		if (FlxTools.settings.IDEAutoOpen)
			ProjectUtils.openWithIDE(targetPath, projectName, ideOption);

		exit();
	}

	function addOptionReplacement(template:TemplateProject):TemplateProject
	{
		final replacements = template.template.replacements;

		for (o in replacements)
		{
			final replace = addOptions(o.pattern, o.cmdOption, o.replacement);
			if (replace.replacement != o.replacement)
				o.replacement = replace.replacement;
		}

		return template;
	}

	function addOptions(pattern:String, cmdOption:String, defaultValue:Dynamic):TemplateReplacement
	{
		final option = console.getOption(cmdOption);

		if (option != null && option != 'true' && option != 'false')
			defaultValue = option;

		return {
			replacement: defaultValue,
			pattern: pattern,
			cmdOption: cmdOption
		};
	}
}
