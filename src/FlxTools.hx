package;

import commands.*;
import massive.haxe.util.TemplateUtil;
import massive.sys.cmd.CommandLineRunner;
import utils.ColorUtils;
import utils.CommandUtils;

class FlxTools extends CommandLineRunner
{
	public static inline final ALIAS = "flixel";
	public static inline final VERSION = "1.4.4";

	public static var settings:FlxToolSettings;

	public static var templateSourcePaths = new Map<IDE, String>();
	public static var templatesLoaded = false;

	public function new()
	{
		super();

		settings = CommandUtils.loadToolSettings();
		CommandUtils.loadIDESettings();

		mapCommand(Create, "create", ["c"], "create a copy of a demo project", TemplateUtil.getTemplate("create"));
		mapCommand(Setup, "setup", ["st"], "configure the tools and download the flixel libs");
		mapCommand(Download, "download", ["dw"], "download the flixel libs");
		mapCommand(Template, "template", ["tpl"], "create a project from a template", TemplateUtil.getTemplate("template"));
		mapCommand(Convert, "convert", ["cn"], "convert an old (2.x) project", TemplateUtil.getTemplate("convert"));
		mapCommand(BuildProjects, "buildprojects", ["bp"], "builds all demos for the specified target", TemplateUtil.getTemplate("buildprojects"));
		mapCommand(Configure, "configure", ["conf"], "adds IDE template files to one or multiple projects", TemplateUtil.getTemplate("configure"));

		run();
	}

	override public function printHeader()
	{
		if (console.args.length == 0 || console.args[0] == "help")
			displayInfo();
	}

	static function displayInfo()
	{
		displayLogo();
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

	static function displayLogo()
	{
		final y = ColorUtils.print.bind(_, Color.Yellow);
		final r = ColorUtils.print.bind(_, Color.Red);
		final g = ColorUtils.print.bind(_, Color.Green);
		final b = ColorUtils.print.bind(_, Color.Blue);
		final c = ColorUtils.print.bind(_, Color.Cyan);
		final nl = Sys.println.bind("");

		// @formatter:off
		y(" _   _ "); r("      "); g("      ");   b("  ");    c("______");  y(" _ "); r("_");   g("      ");   b("   ");   c(" _ "); nl();
		y("| | | |"); r("      "); g("      ");   b("  ");    c("|  ___|"); y(" ");   r("(_)"); g("      ");   b("  ");    c("| |"); nl();
		y("| |_| |"); r(" __ _");  g("__  __");   b("___");   c("| |__ ");  y("| |"); r( "_");  g("__  __");   b("___");   c("| |"); nl();
		y("|  _  |"); r("/ _` ");  g("\\ \\/ /"); b(" _ \\"); c(" ___|");   y("| |"); r( " ");  g("\\ \\/ /"); b(" _ \\"); c( " |"); nl();
		y("| | | |"); r(" (_| |"); g(">  <  ");   b( "__/");  c(" |   ");   y("| |"); r( " |"); g( ">  <  ");  b("__/");   c( " |"); nl();
		y("|_| |_|"); r("\\ __,"); g("/_/\\_\\"); b("___|");  c("_|   ");   y("|_|"); r( "_");  g("/_/\\_\\"); b("___|");  c( "_|"); nl();
		// @formatter:on
	}

	public static function getFlixelVersion():String
	{
		final flixelHaxelib:HaxelibJSON = CommandUtils.getHaxelibJsonData("flixel");
		if (flixelHaxelib != null)
			return flixelHaxelib.version;

		return null;
	}

	public static function main()
	{
		new FlxTools();
	}
}

enum abstract IDE(String) from String to String
{
	final SUBLIME_TEXT = "Sublime Text";
	final FLASH_DEVELOP = "FlashDevelop";
	final INTELLIJ_IDEA = "IntelliJ IDEA";
	final VISUAL_STUDIO_CODE = "Visual Studio Code";
	final NONE = "None";
}
