package commands;

import utils.CommandUtils;
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
import massive.sys.cmd.Command;

class TemplateCommand extends Command
{

	override public function execute():Void
	{
		//var Name = "";
		//
		//if (Name == "")
		//{
		//	Sys.println(" Creating default template");
		//	Name = "basic";
		//}
		//
		//var TemplatesPath = CommandUtils.getHaxelibPath("flixel-templates");
		//
		//if(TemplatesPath == "")
		//{
		//	var installTemplates = CommandUtils.askYN("The flixel-templates haxelib was not found on your system,
		//	do you want this tool to download it for you?");
		//
		//	if(installTemplates == Answer.Yes)
		//	{
		//		Sys.command("haxelib git flixel-templates " + FlxTools.FLIXEL_TEMPLATE_REPO);
		//
		//		TemplatesPath = CommandUtils.getHaxelibPath("flixel-templates");
		//
		//		if (TemplatesPath == "")
		//		{
		//			error(" There was a problem installing Flixel Demos");
		//		}
		//	}
		//}


		//if (Name == "flashdevelop-basic")
		//{
		//	//if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		//	//{
		//	//	var fdTemplatePath:String = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates/flashdevelop-basic/";
		//	//	helpers.ProcessHelper.openFile(fdTemplatePath, "FlxTemplate.fdz");
		//	//}
		//	//else
		//	//{
		//	//	Sys.println("Sorry Flash Develop only supports WINDOWS");
		//	//}
		//}
		//else
		//{
		//	//var templates = scanTemplates("", "", false);
		//	//
		//	//if (templates.get(Name) != null)
		//	//{
		//	//	var destination:String = Sys.getCwd() + commandsSet.projectName;
		//	//
		//	//	Sys.println(" - Creating " + Name);
		//	//
		//	//	FileHelper.recursiveCopy(templates.get(Name), destination);
		//	//
		//	//	if (FileSystem.isDirectory(destination))
		//	//	{
		//	//		modifyTemplate(destination);
		//	//
		//	//		Sys.println(" - Created " + Name);
		//	//		Sys.println(destination);
		//	//	}
		//	//	else
		//	//	{
		//	//		Sys.println(" There was a problem creating " + destination);
		//	//	}
		//	//}
		//	//else
		//	//{
		//	//	Sys.println(" Error there is no demo with the name of " + Name);
		//	//}
		//}
	}

	/**
	 * Recursivley alter the template files
	 *
	 * @param   TemplatePath    Temaplte path to modify
	 */
	static private function modifyTemplate(TemplatePath:String):Void
	{
		//for (fileName in FileSystem.readDirectory(TemplatePath))
		//{
		//	if (FileSystem.isDirectory(TemplatePath + "/" + fileName))
		//	{
		//		Sys.println("File dir: " + TemplatePath + "/" + fileName);
		//		modifyTemplate(TemplatePath + "/" + fileName);
		//	}
		//	else
		//	{
		//		if (StringTools.endsWith(fileName, ".tpl"))
		//		{
		//			var text:String = sys.io.File.getContent(TemplatePath + "/" + fileName);
		//			text = projectTemplateReplacements(text);
		//
		//			var newFileName:String = projectTemplateReplacements(fileName.substr(0, -4));
		//
		//			var o:FileOutput = sys.io.File.write(TemplatePath + "/" + newFileName, true);
		//			o.writeString(text);
		//			o.close();
		//
		//			FileSystem.deleteFile(TemplatePath + "/" + fileName);
		//		}
		//	}
		//}

		//var projectName = "";
		//var projectWidth = "";
		//var projectHeight = "";
		//
		//var replacements:StringMap<String> = new StringMap<String>();
		//
		//replacements.set("${PROJECT_NAME}", projectName);
		//replacements.set("${WIDTH}", projectWidth);
		//replacements.set("${HEIGHT}", projectHeight);


		//{
		//	description:"The basic HaxeFlixel Project Template",
		//	replacements:"${PROJECT_NAME}",
		//
		//}

	}
	//
	//static public function projectTemplateReplacements(Source:String, replacements:Array<TemplateReplacement>):String
	//{
	//	for (replacement in replacements)
	//	{
	//		if ( replacement.replacement != null)
	//			Source = StringTools.replace(Source, replacement.pattern, replacement.replacement);
	//	}
	//
	//	return Source;
	//}
}

///**
// * Definition of template replacement
// */
//typedef TemplateReplacement = {
//	replacement:String,
//	pattern:String,
//	cmdOption:String,
//}
//
///**
// * Type for templates
// */
//enum TemplateType {
//	FlashDevelopFDZ;
//	Folder;
//}
