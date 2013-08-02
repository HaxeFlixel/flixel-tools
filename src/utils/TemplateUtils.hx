package utils;

import massive.sys.io.File;
import massive.sys.io.FileSys;
import haxe.Json;

class TemplateUtils
{
	static public var TemplateSettings:EReg = new EReg("\\btemplate.json\\b", "");

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
	 * @param   DemosPath       An optional path to scan, default being flixel-demos Haxelib
	 * @param   Display         [description]
	 * @return                  Array<OpenFLProject> or null if no Demos were found
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

		var flashDevelopSource = "flash-develop";
		var intellijSource = "intellij-idea";
		var sublimeSource = "sublime-text";
		var ideData = "ide-data";
		var ideDataPath = "";

		for (name in FileSys.readDirectory(TemplatesPath))
		{
			var folderPath = CommandUtils.combine(TemplatesPath, name);

			if(FileSys.exists(folderPath))
			{
				if(FileSys.isDirectory(folderPath) && name != '.git')
				{
					if(name == ideData)
					{
						ideDataPath = TemplatesPath + name;
						FlxTools.flashDevelopSource = CommandUtils.combine(ideDataPath, flashDevelopSource);
						FlxTools.intellijSource = CommandUtils.combine(ideDataPath, intellijSource);
						FlxTools.sublimeSource = CommandUtils.combine(ideDataPath, sublimeSource);
					}
					else
					{
						var filePath = CommandUtils.combine(TemplatesPath, name);
						var file = sys.io.File.getContent(CommandUtils.combine( filePath, "template.json"));
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

}

typedef TemplateFile = {

	var replacements:Array<TemplateReplacement>;

}

/**
 * Object to pass the data of a template project
 */
typedef TemplateProject = {
	var Name:String;
	var Path:String;
	var Template:TemplateFile;
}

/**
* Definition of template replacement
*/
typedef TemplateReplacement = {
	replacement:String,
	pattern:String,
	cmdOption:String,
}