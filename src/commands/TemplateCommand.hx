package commands;

import sys.io.FileOutput;
import sys.io.File;
import sys.FileSystem;
import haxe.ds.StringMap;
import utils.TemplateUtils;
import utils.CommandUtils;
import massive.sys.cmd.Command;

class TemplateCommand extends Command
{
	private var autoContinue:Bool = false;
	private var ideOption:String = "";

	override public function execute():Void
	{
		var targetPath = "";
		var templateName = "";

		if (console.args[1] != null)
			templateName = console.args[1];

		if (console.args[2] != null)
			targetPath = console.args[2];

		if (console.getOption("-y") != null)
			autoContinue = true;

		ideOption = selectIDE();

		//support a path as an arg without name for default
		//flixel t ./<new_directory> <options>
		if (StringTools.startsWith(templateName, "./"))
		{
			targetPath = templateName;
			templateName = "";
		}

		processTemplate(templateName, targetPath);
	}

	private function getReplacementValue(Replacements:Array<TemplateReplacement>, Pattern:String):String
	{
		for (o in Replacements)
		{
			return o.replacement;
		}
		return null;
	}

	public function processTemplate(TemplateName:String = "", TargetPath:String = ""):Void
	{
		var template:TemplateProject = TemplateUtils.get(TemplateName);

		if (template == null)
		{
			error("Error getting the template with the name of " + TemplateName);
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
				TargetPath = Sys.getCwd() + CommandUtils.stripPath(TargetPath);
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

		var templateFileReg = new EReg("\\btemplate.json\\b", "");

		if (ideOption == FlxTools.SUBLIME_TEXT)
		{
			template.Template.replacements.push(addOption("${PROJECT_PATH}", "", TargetPath));
			template.Template.replacements.push(addOption("${HAXE_STD_PATH}", "", CommandUtils.getHaxePath() + "/std"));
			template.Template.replacements.push(addOption("${FLIXEL_PATH}", "", CommandUtils.getHaxelibPath('flixel')));
			template.Template.replacements.push(addOption("${FLIXEL_ADDONS_PATH}", "", CommandUtils.getHaxelibPath('flixel-addons')));

			CommandUtils.copyRecursively(FlxTools.sublimeSource, TargetPath, templateFileReg, true);
		}
		else if (ideOption == FlxTools.INTELLIJ_IDEA)
		{
			template.Template.replacements.push(addOption("${IDEA_flexSdkName}", "", FlxTools.settings.IDEA_flexSdkName));
			template.Template.replacements.push(addOption("${IDEA_Flixel_Engine_Library}", "", FlxTools.settings.IDEA_Flixel_Engine_Library));
			template.Template.replacements.push(addOption("${IDEA_Flixel_Addons_Library}", "", FlxTools.settings.IDEA_Flixel_Addons_Library));

			CommandUtils.copyRecursively(FlxTools.intellijSource, TargetPath, templateFileReg, true);
		}
		else if (ideOption == FlxTools.FLASH_DEVELOP)
		{
			CommandUtils.copyRecursively(FlxTools.flashDevelopSource, TargetPath, templateFileReg, true);
		}

		CommandUtils.copyRecursively(template.Path, TargetPath, templateFileReg, true);

		modifyTemplate(TargetPath, template);

		Sys.println(" Created Template at:");
		Sys.println(" " + TargetPath);
		Sys.println(" ");

		if (ideOption == FlxTools.SUBLIME_TEXT)
		{
			if (FlxTools.settings.SublimeCMDOpen)
			{
				var answer = Answer.Yes;

				if (!autoContinue)
				{
					answer = CommandUtils.askYN("Do you want to open it with Sublime?");
				}

				if (answer == Answer.Yes)
				{
					var projectName = getReplacementValue(template.Template.replacements, "${PROJECT_NAME}");
					var projectFile = TargetPath + "/" + projectName + ".sublime-project";
					var sublimeOpen = "subl " + projectFile;
					
					Sys.command("subl");
					Sys.command(sublimeOpen);
				}
			}
		}

		exit();
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

	private function addOption(Pattern:String, CMDOption:String, DefaultValue:Dynamic):TemplateReplacement
	{
		var replace:TemplateReplacement =
		{
			replacement : DefaultValue,
			pattern : Pattern,
			cmdOption : CMDOption
		};

		return replace;
	}

	/**
	 * Recursivley alter the template files
	 *
	 * @param   TemplatePath    Temaplte path to modify
	 */
	static private function modifyTemplate(TemplatePath:String, TemplateData:TemplateProject):Void
	{
		for (fileName in FileSystem.readDirectory(TemplatePath))
		{
			if (FileSystem.isDirectory(TemplatePath + "/" + fileName))
			{
				modifyTemplate(TemplatePath + "/" + fileName, TemplateData);
			}
			else
			{
				if (StringTools.endsWith(fileName, ".tpl"))
				{
					var text:String = sys.io.File.getContent(TemplatePath + "/" + fileName);
					text = projectTemplateReplacements(text, TemplateData.Template.replacements);

					var newFileName:String = projectTemplateReplacements(fileName.substr(0, -4), TemplateData.Template.replacements);

					var o:FileOutput = sys.io.File.write(TemplatePath + "/" + newFileName, true);
					o.writeString(text);
					o.close();

					FileSystem.deleteFile(TemplatePath + "/" + fileName);
				}
			}
		}
	}

	static private function projectTemplateReplacements(Source:String, Replacements:Array<TemplateReplacement>):String
	{
		for (replacement in Replacements)
		{
			if (replacement.replacement != null)
				Source = StringTools.replace(Source, replacement.pattern, replacement.replacement);
		}

		return Source;
	}

	private function selectIDE():String
	{
		var options = new StringMap<String>();

		options.set("-subl", FlxTools.SUBLIME_TEXT);
		options.set("-fd", FlxTools.FLASH_DEVELOP);
		options.set("-idea", FlxTools.INTELLIJ_IDEA);

		var choice = FlxTools.settings.DefaultEditor;

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
}