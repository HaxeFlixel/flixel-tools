package;

import commands.BenchmarkCommand;
import commands.ConvertCommand;
import commands.CreateCommand;
import commands.DocsCommand;
import commands.DownloadCommand;
import commands.OpenFLTestCommand;
import commands.SetCommand;
import commands.SetupCommand;
import commands.TemplateCommand;
import commands.TestDemosCommand;

import utils.CommandUtils;
import utils.CommandUtils.HaxelibJSON;
import massive.haxe.util.TemplateUtil;
import massive.sys.cmd.CommandLineRunner;

class FlxTools extends CommandLineRunner
{
	inline static public var NAME = "HaxeFlixel";
	inline static public var ALIAS = "flixel";
	inline static public var VERSION = "0.0.3";

	inline static public var SUBLIME_TEXT:String = "Sublime Text";
	inline static public var FLASH_DEVELOP:String = "Flash Develop";
	inline static public var FLASH_DEVELOP_FDZ:String = "Flash Develop FDZ";
	inline static public var INTELLIJ_IDEA:String = "Intellij Idea";
	inline static public var INTELLIJ_IDEA_PATH:String = "";
	inline static public var IDE_NONE:String = "None";

	inline static public var FLIXEL_ADDONS_REPO = "https://github.com/HaxeFlixel/flixel-addons";
	inline static public var FLIXEL_UI_REPO = "https://github.com/HaxeFlixel/flixel-ui";
	inline static public var FLIXEL_TEMPLATE_REPO = "https://github.com/HaxeFlixel/flixel-templates";
	inline static public var FLIXEL_DEMOS_REPO = "https://github.com/HaxeFlixel/flixel-demos";
	inline static public var FLIXEL_REPO = "https://github.com/HaxeFlixel/flixel";

	static public var settings:FlxToolSettings;
    static public var PWIDTH:Int = 640;
    static public var PHEIGHT:Int = 480;


	static public var flashDevelopFDZSource:String;
	static public var flashDevelopSource:String;
	static public var intellijSource:String;
	static public var sublimeSource:String;

	public function new():Void
	{
		super();

		settings = CommandUtils.loadToolSettings();
		CommandUtils.loadIDESettings();

		mapCommand(
			CreateCommand,
			"create", ["c"],
			"Creates a copy of a Demo project.",
			TemplateUtil.getTemplate("create")
		);

		mapCommand(
			SetupCommand,
			"setup", ["st"],
			"Setup the tools, download the Demos and Templates haxelib.",
			TemplateUtil.getTemplate("setup")
		);

		mapCommand(
			DownloadCommand,
			"download", ["dw","download"],
			"Download the Templates and Demos.",
			TemplateUtil.getTemplate("download")
		);

		mapCommand(
			TemplateCommand,
			"template", ["tpl","template"],
			"Creates a project template.",
			TemplateUtil.getTemplate("template")
		);

		mapCommand(
			ConvertCommand,
			"convert", ["cn","convert"],
			"Converts an old HaxeFlixel Project.",
			TemplateUtil.getTemplate("convert")
		);

		mapCommand(
			TestDemosCommand,
			"testdemos", ["td", "validate"],
			"Builds all the demos for flash target (use -target to specify a target, or -all to build for all targets).",
			""
			// TemplateUtil.getTemplate("validate")
		);

		// -- NOT WORKING --
		//mapCommand(
		//	DocsCommand,
		//	"docs", ["d"],
		//	"Run the docs webserver.",
		//	""
		//	// TemplateUtil.getTemplate("convert")
		//);

		//mapCommand(
		//	OpenFLTestCommand,
		//	"test", ["t"],
		//	"Alias for the openfl test command.",
		//	""
		//	//TemplateUtil.getTemplate("template")
		//);

		//mapCommand(
		//	SetCommand,
		//	"set", ["s"],
		//	"Set the current version of HaxeFlixel",
		//	""
		//	//TemplateUtil.getTemplate("set")
		//);

		run();
	}

	override public function printHeader():Void
	{
		displayInfo();
	}

	/**
	 * Display the main information about HaxeFlixel
	 */
	static private function displayInfo():Void
	{
		Sys.println("");
		Sys.println(" _   _               ______ _  _          _");
		Sys.println("| | | |              |  ___| ||_|        | |");
		Sys.println("| |_| | __ ___  _____| |_  | |____  _____| |");
		Sys.println("|  _  |/ _` \\ \\/ / _ \\  _| | || \\ \\/ / _ \\ |");
		Sys.println("| | | | (_| |>  <  __/ |   | || |>  <  __/ |");
		Sys.println("|_| |_|\\__,_/_/\\_\\___\\_|   |_||_/_/\\_\\___|_|");
		Sys.println("");
		Sys.println("Powered by the Haxe Toolkit and OpenFL");
		Sys.println("Please visit www.haxeflixel.com for community support and resources!");
		Sys.println("");
		Sys.println("" + NAME + " Command-Line Tools (" + VERSION + ")");

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

	static public function getFlixelVersion():String
	{
		var flixelHaxelib:HaxelibJSON = CommandUtils.getHaxelibJsonData("flixel");

		if(flixelHaxelib != null)
		{
			return flixelHaxelib.version;
		}
		else
		{
			return null;
		}
	}

	static public function main():FlxTools { return new FlxTools(); }
}