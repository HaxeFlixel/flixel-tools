package utils;

import haxe.Json;
import massive.sys.io.FileSys;
import sys.FileSystem;
import sys.io.FileOutput;
import FlxTools.IDE;
using StringTools;

class TemplateUtils
{
	public static var templateFilter:EReg = new EReg("\\btemplate.json\\b", "");

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

		var templates = findTemplates();
		var target:TemplateProject = null;

		if (templates == null)
			return null;

		for (template in templates)
		{
			if (template.Name == templateName)
				target = template;
		}
		return target;
	}

	public static function findTemplates(?templatesPath:String):Array<TemplateProject>
	{
		if (templatesPath == null)
		{
			templatesPath = CommandUtils.getHaxelibPath("flixel-templates");
			if (templatesPath == "")
				return null;
		}

		if (!FileSys.exists(templatesPath))
			return null;

		var templates = new Array<TemplateProject>();

		for (name in FileSys.readDirectory(templatesPath))
		{
			var folderPath = CommandUtils.combine(templatesPath, name);
			
			if (FileSys.exists(folderPath) && FileSys.isDirectory(folderPath) && name != '.git')
			{
				var filePath = CommandUtils.combine(templatesPath, name);
				filePath = CommandUtils.combine(filePath, "template.json");
				
				// Make sure we don't get a crash if the file doesn't exist
				if (FileSystem.exists(filePath))
				{
					var file = FileSysUtils.getContent(filePath);
					
					var FileData:TemplateFile = Json.parse(file);
					
					var project:TemplateProject =
					{
						Name : name,
						Path : templatesPath + name,
						Template : FileData
					};
					templates.push(project);
				}
			}
		}

		if (Lambda.count(templates) > 0)
		{
			return templates;
		}
		else
		{
			return null;
		}
	}

	public static function getReplacementValue(replacements:Array<TemplateReplacement>, pattern:String):String
	{
		for (o in replacements)
		{
			return o.replacement;
		}
		return null;
	}

	public static function addOption(pattern:String, cmdOption:String, defaultValue:Dynamic):TemplateReplacement
	{
		return
		{
			replacement : defaultValue,
			pattern : "${" + pattern + "}",
			cmdOption : cmdOption
		};
	}

	public static function modifyTemplateProject(templatePath:String, template:TemplateProject, ide:IDE):Void
	{
		modifyTemplate(templatePath, template.Template.replacements);
		compileIfNeeded(templatePath, ide);
	}

	public static function compileIfNeeded(templatePath:String, ide:IDE)
	{
		if (ide != IDE.VISUAL_STUDIO_CODE)
			return;
		
		// HACK: let's compile once to get the default completion hxml
		FileSysUtils.runInDirectory(templatePath, function()
		{
			Sys.println("Compiling the project once...");
			Sys.command("haxelib", ["run", "lime", "build", "flash", "-Ddebug"]);
		});
	}

	/**
	 * Recursivley alter the template files
	 *
	 * @param   TemplatePath	Template path to modify
	 */
	public static function modifyTemplate(templatePath:String, templates:Array<TemplateReplacement>):Void
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

				var newFileName:String = projectTemplateReplacements(fileName.substr(0, -4), templates);

				var o:FileOutput = sys.io.File.write(templatePath + "/" + newFileName, true);
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

typedef TemplateFile = {
	replacements:Array<TemplateReplacement>
}

/**
 * Object to pass the data of a template project
 */
typedef TemplateProject = {
	Name:String,
	Path:String,
	Template:TemplateFile
}

/**
* Definition of template replacement
*/
typedef TemplateReplacement = {
	replacement:String,
	pattern:String,
	cmdOption:String
}