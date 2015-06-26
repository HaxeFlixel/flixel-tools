package commands;

import haxe.ds.StringMap;
import massive.sys.cmd.Command;
import sys.FileSystem;
import utils.CommandUtils;
import utils.ProjectUtils;
import utils.TemplateUtils;
import FlxTools.IDE;
using StringTools;

class TemplateCommand extends Command
{
	private var autoContinue:Bool = false;
	private var ideOption:IDE = IDE.NONE;

	override public function execute():Void
	{
		if (!FlxTools.templatesLoaded)
		{
			Sys.println("Error loading templates, please run 'flixel download'.");
			return;
		}
		
		var targetPath = "";
		var templateName = "";

		if (console.args[1] != null)
			templateName = console.args[1];

		if (console.args[2] != null)
			targetPath = console.args[2];

		if (console.getOption("-y") != null)
			autoContinue = true;

		ideOption = ProjectUtils.resolveIDEChoice(console);

		if (console.getOption("-n") != null)
		{
			targetPath = console.getOption("-n");
		}

		//support a path as an arg without name for default
		//flixel t ./<new_directory> <options>
		if (templateName.startsWith("./"))
		{
			targetPath = templateName;
			templateName = "";
		}

		processTemplate(templateName, targetPath);
	}

	public function processTemplate(templateName:String = "", targetPath:String = ""):Void
	{
		var template:TemplateProject = TemplateUtils.get(templateName);

		if (template == null)
		{
			error("Error getting the template with the name of " + templateName +
				" make sure you have installed flixel-templates ('haxelib install flixel-templates')");
		}
		else
		{
			templateName = template.Name;
		}

		//override the template defaults form the command arguments
		template = addOptionReplacement(template);

		if (targetPath == "")
		{
			targetPath = Sys.getCwd() + templateName;
		}
		else if (!targetPath.startsWith("/"))
		{
			targetPath = CommandUtils.combine(Sys.getCwd(), CommandUtils.stripPath(targetPath));
		}

		if (FileSystem.exists(targetPath))
		{
			Sys.println("Warning::" + targetPath);

			var answer = Answer.Yes;

			if (!autoContinue)
			{
				answer = CommandUtils.askYN("Directory exists - do you want to delete it first?");
			}

			if (answer == Answer.Yes)
			{
				CommandUtils.deleteRecursively(targetPath);
			}
		}

		template.Template.replacements = ProjectUtils.copyIDETemplateFiles(targetPath, template.Template.replacements, ideOption);

		CommandUtils.copyRecursively(template.Path, targetPath, TemplateUtils.templateFilter, true);

		TemplateUtils.modifyTemplateProject(targetPath, template);

		Sys.println("Created template at:");
		Sys.println(targetPath);
		Sys.println(" ");

		if (FlxTools.settings.IDEAutoOpen)
		{
			var projectName = TemplateUtils.getReplacementValue(template.Template.replacements, "${PROJECT_NAME}");
			ProjectUtils.openWithIDE(targetPath, projectName, ideOption);
		}

		exit();
	}	

	private function addOptionReplacement(template:TemplateProject):TemplateProject
	{
		var replacements = template.Template.replacements;

		for (o in replacements)
		{
			var replace = addOptions(o.pattern, o.cmdOption, o.replacement);
			if (replace.replacement != o.replacement)
				o.replacement = replace.replacement;
		}

		return template;
	}

	private function addOptions(pattern:String, cmdOption:String, defaultValue:Dynamic):TemplateReplacement
	{
		var option = console.getOption(cmdOption);

		if (option != null && option != 'true' && option != 'false')
			defaultValue = option;

		return
		{
			replacement : defaultValue,
			pattern : pattern,
			cmdOption : cmdOption
		};
	}
}