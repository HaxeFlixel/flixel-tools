package;

import commands.BuildProjectsCommand;
import commands.ConvertCommand;
import commands.CreateCommand;
import commands.DownloadCommand;
import commands.SetupCommand;
import commands.TemplateCommand;
import massive.haxe.util.TemplateUtil;
import massive.sys.cmd.CommandLineRunner;
import utils.ColorUtils;
import utils.CommandUtils;

class FlxTools extends CommandLineRunner
{
	public static inline var ALIAS = "flixel";
	public static inline var VERSION = "1.0.5";

	public static var settings:FlxToolSettings;
	public static var PWIDTH:Int = 640;
	public static var PHEIGHT:Int = 480;

	public static var flashDevelopFDZSource:String;
	public static var flashDevelopSource:String;
	public static var intellijSource:String;
	public static var sublimeSource:String;
	public static var templatesLoaded:Bool = false;

	public function new():Void
	{
		super();

		settings = CommandUtils.loadToolSettings();
		CommandUtils.loadIDESettings();

		mapCommand(
			CreateCommand,
			"create", ["c"],
			"create a copy of a demo project",
			TemplateUtil.getTemplate("create")
		);

		mapCommand(
			SetupCommand,
			"setup", ["st"],
			"configure the tools and download the demos and templates",
			TemplateUtil.getTemplate("setup")
		);
		
		mapCommand(
			DownloadCommand,
			"download", ["dw"],
			"download the templates and demos",
			TemplateUtil.getTemplate("download")
		);

		mapCommand(
			TemplateCommand,
			"template", ["tpl"],
			"create a project template",
			TemplateUtil.getTemplate("template")
		);

		mapCommand(
			ConvertCommand,
			"convert", ["cn"],
			"convert an old (2.x) project",
			TemplateUtil.getTemplate("convert")
		);

		mapCommand(
			BuildProjectsCommand,
			"buildprojects", ["bp"],
			"builds all demos for flash",
			TemplateUtil.getTemplate("buildprojects")
		);

		run();
	}

	override public function printHeader():Void
	{
		if (console.args.length == 0 || console.args[0] == "help")
			displayInfo();
	}

	static private function displayInfo():Void
	{
		printLogo();
		Sys.println("");
		
		Sys.println("Powered by the Haxe Toolkit and OpenFL");
		Sys.println("Visit www.haxeflixel.com for community support and resources!");
		Sys.println("");
		Sys.println("HaxeFlixel command-line tools (" + VERSION + ")");

		if (getFlixelVersion() == null)
		{
			Sys.println("Flixel is not currently installed. Please run 'haxelib install flixel'");
		}
		else
		{
			Sys.println("Installed flixel version: " + getFlixelVersion());
		}

		Sys.println("");
	}
	
	static private function printLogo():Void
	{
		var y = ColorUtils.print.bind(_, Color.Yellow);
		var r = ColorUtils.print.bind(_, Color.Red);
		var g = ColorUtils.print.bind(_, Color.Green);
		var b = ColorUtils.print.bind(_, Color.Blue);
		var c = ColorUtils.print.bind(_, Color.Cyan);
		var nl = Sys.println.bind("");

		y(" _   _ "); r("      "); g("      ");   b("  ");    c("______");  y(" _ "); r("_");   g("      ");   b("   ");   c(" _ "); nl();
		y("| | | |"); r("      "); g("      ");   b("  ");    c("|  ___|"); y(" ");   r("(_)"); g("      ");   b("  ");    c("| |"); nl();
		y("| |_| |"); r(" __ _");  g("__  __");   b("___");   c("| |__ ");  y("| |"); r( "_");  g("__  __");   b("___");   c("| |"); nl();
		y("|  _  |"); r("/ _` ");  g("\\ \\/ /"); b(" _ \\"); c(" ___|");   y("| |"); r( " ");  g("\\ \\/ /"); b(" _ \\"); c( " |"); nl();
		y("| | | |"); r(" (_| |"); g(">  <  ");   b( "__/");  c("  |  ");   y("| |"); r( " |"); g( ">  <  ");  b("__/");   c( " |"); nl();
		y("|_| |_|"); r("\\ __,"); g("/_/\\_\\"); b("___|");  c(" _|  ");   y("|_|"); r( "_");  g("/_/\\_\\"); b("___|");  c( "_|"); nl();
	}

	static public function getFlixelVersion():String
	{
		var flixelHaxelib:HaxelibJSON = CommandUtils.getHaxelibJsonData("flixel");
		if (flixelHaxelib != null)
			return flixelHaxelib.version;
		
		return null;
	}

	static public function main():FlxTools { return new FlxTools(); }
}

@:enum
abstract IDE(String) from String to String
{
	var SUBLIME_TEXT = "Sublime Text";
	var FLASH_DEVELOP = "FlashDevelop";
	var FLASH_DEVELOP_FDZ = "FlashDevelop FDZ";
	var INTELLIJ_IDEA = "IntelliJ IDEA";
	var NONE = "None";
}