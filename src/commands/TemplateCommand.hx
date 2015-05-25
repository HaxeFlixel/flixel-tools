package commands;

import haxe.ds.StringMap;
import massive.sys.cmd.Command;
import sys.FileSystem;
import utils.CommandUtils;
import utils.ProjectUtils;
import utils.TemplateUtils;

class TemplateCommand extends Command
{
	private var autoContinue:Bool = false;
	private var ideOption:String = "";

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

		ideOption = selectIDE();

		if (console.getOption("-n") != null)
		{
			targetPath = console.getOption("-n");
		}

		//support a path as an arg without name for default
		//flixel t ./<new_directory> <options>
		if (StringTools.startsWith(templateName, "./"))
		{
			targetPath = templateName;
			templateName = "";
		}

		processTemplate(templateName, targetPath);
	}

	public function processTemplate(TemplateName:String = "", TargetPath:String = ""):Void
	{
		var template:TemplateProject = TemplateUtils.get(TemplateName);

		if (template == null)
		{
			error("Error getting the template with the name of " + TemplateName + " make sure you have installed flixel-templates ('haxelib install flixel-templates')");
		}
		else
		{
			TemplateName = template.Name;
		}

		//override the template defaults form the command arguments
		template = addOptionReplacement(template);

		if (TargetPath == "")
		{
			TargetPath = Sys.getCwd() + TemplateName;
		}
		else
		{
			if (!StringTools.startsWith(TargetPath, "/"))
			{
				TargetPath = CommandUtils.combine(Sys.getCwd(), CommandUtils.stripPath(TargetPath));
			}
		}

		if (FileSystem.exists(TargetPath))
		{
			Sys.println("Warning::" + TargetPath);

			var answer = Answer.Yes;

			if (!autoContinue)
			{
				answer = CommandUtils.askYN("Directory exists do you want to delete it first?");
			}

			if (answer == Answer.Yes)
			{
				CommandUtils.deleteRecursively(TargetPath);
			}
		}

		template.Template.replacements = ProjectUtils.copyIDETemplateFiles(TargetPath, template.Template.replacements, ideOption);

		CommandUtils.copyRecursively(template.Path, TargetPath, TemplateUtils.TemplateFilter, true);

		TemplateUtils.modifyTemplateProject(TargetPath, template);

		Sys.println(" Created Template at:");
		Sys.println(" " + TargetPath);
		Sys.println(" ");

		if (ideOption == FlxTools.SUBLIME_TEXT)
		{
			if (FlxTools.settings.IDEAutoOpen)
			{
				var answer = Answer.Yes;

				if (!autoContinue)
				{
					answer = CommandUtils.askYN("Do you want to open it with Sublime?");
				}

				if (answer == Answer.Yes)
				{
					var projectName = TemplateUtils.getReplacementValue(template.Template.replacements, "${PROJECT_NAME}");
					var projectFile = TargetPath + "/" + projectName + ".sublime-project";
					var sublimeOpen = "subl " + projectFile;

					Sys.command("subl");
					Sys.command(sublimeOpen);
				}
			}
		}

		exit();
	}

	private function selectIDE():String
	{
		var options = new StringMap<String>();

		options.set("-subl", FlxTools.SUBLIME_TEXT);
		options.set("-fd", FlxTools.FLASH_DEVELOP);
		options.set("-fdz", FlxTools.FLASH_DEVELOP_FDZ);
		options.set("-idea", FlxTools.INTELLIJ_IDEA);

		var choice = null;
		
		if (FlxTools.settings != null)
		{
			choice = FlxTools.settings.DefaultEditor;
		}

		for (o in options.keys())
		{
			var option = o;
			var IDE = options.get(o);

			var optionGet = console.getOption(option);

			if (optionGet != null)
				choice = IDE;
		}

		if (choice != null)
		{
			return choice;
		}
		else
		{
			return FlxTools.IDE_NONE;
		}
	}

	private function addOptionReplacement(Template:TemplateProject):TemplateProject
	{
		var replacements = Template.Template.replacements;

		for (o in replacements)
		{
			var replace = addOptions(o.pattern, o.cmdOption, o.replacement);
			if (replace.replacement != o.replacement)
				o.replacement = replace.replacement;
		}

		return Template;
	}

	private function addOptions(Pattern:String, CMDOption:String, DefaultValue:Dynamic):TemplateReplacement
	{
		var option = console.getOption(CMDOption);

		if (option != null && option != 'true' && option != 'false')
			DefaultValue = option;

		var replace:TemplateReplacement =
		{
		replacement : DefaultValue,
		pattern : Pattern,
		cmdOption : CMDOption
		};

		return replace;
	}
}