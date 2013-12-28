package utils;

import sys.FileSystem;
import sys.io.FileOutput;
import massive.sys.io.File;
import massive.sys.io.FileSys;
import haxe.Json;

class TemplateUtils
{
	static public var TemplateFilter:EReg = new EReg("\\btemplate.json\\b", "");

	static public function get(TemplateName:String = ""):TemplateProject
	{
		if(TemplateName == "")
			TemplateName = 'default';

		var templates = scanTemplateProjects();
		var target:TemplateProject = null;

		if(templates == null)
			return null;

		for (template in templates)
		{
			if (template.Name == TemplateName)
				target = template;
		}
		return target;
	}

	/**
	 * Scan a folder recursively for openfl project files
	 *
	 * @param   DemosPath	   An optional path to scan, default being flixel-demos Haxelib
	 * @param   Display		 [description]
	 * @return				  Array<OpenFLProject> or null if no Demos were found
	 */
	static public function scanTemplateProjects(TemplatesPath:String = "", Recursive:Bool = true):Array<TemplateProject>
	{
		if (TemplatesPath == "")
		{
			TemplatesPath = CommandUtils.getHaxelibPath("flixel-templates");

			if (TemplatesPath == "")
			{
				return null;
			}
		}

		if(!FileSys.exists(TemplatesPath))
			return null;

		var templates = new Array<TemplateProject>();
		var ideDataPath = "";

		for (name in FileSys.readDirectory(TemplatesPath))
		{
			var folderPath = CommandUtils.combine(TemplatesPath, name);
			
			if (FileSys.exists(folderPath) && FileSys.isDirectory(folderPath) && name != '.git')
			{
				var filePath = CommandUtils.combine(TemplatesPath, name);
				filePath = CommandUtils.combine(filePath, "template.json");
				
				// Make sure we don't get a crash if the file doesn't exist
				if (FileSystem.exists(filePath))
				{
					var file = FileSysUtils.getContent(filePath);
					
					var FileData:TemplateFile = Json.parse(file);
					
					var project:TemplateProject =
					{
						Name : name,
						Path : TemplatesPath + name,
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

	public static function getReplacementValue(Replacements:Array<TemplateReplacement>, Pattern:String):String
	{
		for (o in Replacements)
		{
			return o.replacement;
		}
		return null;
	}

	public static function addOption(Pattern:String, CMDOption:String, DefaultValue:Dynamic):TemplateReplacement
	{
		var replace:TemplateReplacement =
		{
		replacement : DefaultValue,
		pattern : Pattern,
		cmdOption : CMDOption
		};

		return replace;
	}

	static public function modifyTemplateProject(TemplatePath:String, Template:TemplateProject):Void
	{
		modifyTemplate(TemplatePath, Template.Template.replacements);
	}

	/**
	 * Recursivley alter the template files
	 *
	 * @param   TemplatePath	Temaplte path to modify
	 */
	static public function modifyTemplate(TemplatePath:String, TemplateData:Array<TemplateReplacement>):Void
	{
		for (fileName in FileSys.readDirectory(TemplatePath))
		{
			if (FileSys.isDirectory(TemplatePath + "/" + fileName))
			{
				modifyTemplate(TemplatePath + "/" + fileName, TemplateData);
			}
			else
			{
				if (StringTools.endsWith(fileName, ".tpl"))
				{
					var text:String = FileSysUtils.getContent(TemplatePath + "/" + fileName);
					text = projectTemplateReplacements(text, TemplateData);

					var newFileName:String = projectTemplateReplacements(fileName.substr(0, -4), TemplateData);

					var o:FileOutput = sys.io.File.write(TemplatePath + "/" + newFileName, true);
					o.writeString(text);
					o.close();

					FileSys.deleteFile(TemplatePath + "/" + fileName);
				}
			}
		}
	}

	static public function projectTemplateReplacements(Source:String, Replacements:Array<TemplateReplacement>):String
	{
		for (replacement in Replacements)
		{
			if (replacement.replacement != null)
				Source = StringTools.replace(Source, replacement.pattern, replacement.replacement);
		}

		return Source;
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