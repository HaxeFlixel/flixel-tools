package utils;

import FlxTools.IDE;
import haxe.Json;
import haxe.io.Path;
import massive.sys.io.FileSys;
import sys.FileSystem;
import sys.io.FileOutput;

class TemplateUtils
{
	public static final templateFilter = ~/\btemplate.json\b/;

	public static function verifyTemplatesLoaded()
	{
		if (!FlxTools.templatesLoaded)
		{
			Sys.println("Error loading templates, please run 'flixel download'.");
			Sys.exit(1);
		}
	}

	public static function get(templateName:String = ""):TemplateProject
	{
		if (templateName == "")
			templateName = 'default';

		if (FileSysUtils.isDirectoryPath(templateName))
			return findTemplate(templateName);

		for (template in findTemplates())
		{
			if (template.name == templateName)
				return template;
		}
		return null;
	}

	public static function findTemplate(path:String):TemplateProject
	{
		if (!FileSys.exists(path))
			return null;

		// NOTE: isDirectory() throws an error if path does not exist
		if (!FileSys.isDirectory(path))
			return null;

		path = FileSystem.fullPath(Path.normalize(path));
		var dirName = Path.withoutDirectory(Path.removeTrailingSlashes(path));
		var template = readTemplateJson(path, dirName);

		return template;
	}

	public static function findTemplates(?templatesPath:String):Array<TemplateProject>
	{
		if (templatesPath == null)
		{
			templatesPath = CommandUtils.getHaxelibPath("flixel-templates");
			if (templatesPath == "")
				return [];
		}

		if (!FileSys.exists(templatesPath))
			return [];

		final templates = [];

		for (name in FileSys.readDirectory(templatesPath))
		{
			final folderPath = CommandUtils.combine(templatesPath, name);

			if (FileSys.exists(folderPath) && FileSys.isDirectory(folderPath) && name != '.git')
			{
				var templatePath = CommandUtils.combine(templatesPath, name);
				var templateJsonPath = CommandUtils.combine(templatePath, "template.json");

				// Make sure we don't get a crash if the file doesn't exist
				if (FileSystem.exists(templateJsonPath))
				{
					templates.push(readTemplateJson(templatePath, name, templateJsonPath));
				}
			}
		}

		return templates;
	}

	static function readTemplateJson(templatePath:String, teamplateName:String, ?templateJsonPath:String):TemplateProject
	{
		if (templateJsonPath == null)
			templateJsonPath = Path.join([templatePath, "template.json"]);

		final fileContent = FileSysUtils.getContent(templateJsonPath);

		return {
			name: teamplateName,
			path: templatePath,
			template: Json.parse(fileContent)
		};
	}

	public static function getReplacementValue(replacements:Array<TemplateReplacement>, pattern:String):String
	{
		for (o in replacements)
			return o.replacement;

		return null;
	}

	public static function addOption(pattern:String, cmdOption:String, defaultValue:Dynamic):TemplateReplacement
	{
		return {
			replacement: defaultValue,
			pattern: "${" + pattern + "}",
			cmdOption: cmdOption
		};
	}

	public static function modifyTemplateProject(templatePath:String, template:TemplateProject, ide:IDE)
	{
		modifyTemplate(templatePath, template.template.replacements);
	}

	/**
	 * Recursivley alter the template files
	 *
	 * @param   TemplatePath	Template path to modify
	 */
	public static function modifyTemplate(templatePath:String, templates:Array<TemplateReplacement>)
	{
		for (fileName in FileSys.readDirectory(templatePath))
		{
			if (FileSys.isDirectory(templatePath + "/" + fileName))
			{
				modifyTemplate(templatePath + "/" + fileName, templates);
			}
			else if (fileName.endsWith(".tpl"))
			{
				var text:String = FileSysUtils.getContent(templatePath + "/" + fileName);
				text = projectTemplateReplacements(text, templates);

				final newFileName:String = projectTemplateReplacements(fileName.substr(0, -4), templates);

				final o:FileOutput = sys.io.File.write(templatePath + "/" + newFileName, true);
				o.writeString(text);
				o.close();

				FileSys.deleteFile(templatePath + "/" + fileName);
			}
		}
	}

	public static function projectTemplateReplacements(source:String, replacements:Array<TemplateReplacement>):String
	{
		for (replacement in replacements)
		{
			if (replacement.replacement != null)
				source = StringTools.replace(source, replacement.pattern, replacement.replacement);
		}

		return source;
	}
}

typedef TemplateFile =
{
	replacements:Array<TemplateReplacement>
}

typedef TemplateProject =
{
	name:String,
	path:String,
	template:TemplateFile
}

typedef TemplateReplacement =
{
	replacement:String,
	pattern:String,
	cmdOption:String
}
