package utils;

import sys.FileSystem;

class TemplateUtils
{
	/**
	 * Scan a folder recursively for openfl project files
	 *
	 * @param   DemosPath       An optional path to scan, default being flixel-demos Haxelib
	 * @param   Display         [description]
	 * @return                  Array<OpenFLProject> or null if no Demos were found
	 */
	static public function scanTemplateProjects(TemplatesPath:String = "", recursive:Bool = true):Array<TemplateProject>
	{
		if (TemplatesPath == "")
		{
			TemplatesPath = CommandUtils.getHaxelibPath("flixel-templates");

			if (TemplatesPath == "")
			{
				return null;
			}
		}

		var templates = new Array<TemplateProject>();

		for (name in FileSystem.readDirectory(TemplatesPath))
		{
			var folderPath:String = TemplatesPath + "/" + name;

			//.fdz

			if (!StringTools.startsWith(name, ".") && FileSystem.isDirectory(folderPath))
			{
				//var projectXMLPath:String = scanProjectFile(folderPath);

				//if (projectXMLPath == "" && recursive)
				//{
					//for ( targetFolder in TargetFolders )
					//{
					//	if (name == targetFolder)
					//	{
					//		var subpath:String = folderPath;
					//		var childProjects:Array<TemplateProject> = scanOpenFLProjects(subpath);
					//
					//		for (childProject in childProjects)
					//		{
					//			var template:TemplateProject = childProject;
					//			template.TARGETS = name;
					//
					//			if (FileSystem.exists(template.PATH))
					//			{
					//				templates.push(template);
					//			}
					//		}
					//	}
					//}
				}
				else
				{
					//var project:TemplateProject =
					//{
					//	NAME : name,
					//	PATH : folderPath,
					//	OPTIONS : options
					//};
					//
					//if (FileSystem.exists(project.PATH))
					//{
					//	templates.push(project);
					//}
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

/**
 * Object to pass the data of a template project
 */
typedef TemplateProject = {
	var NAME:String;
	var PATH:String;
	var OPTIONS:Array<String>;
}