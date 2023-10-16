package utils;

import FlxTools.IDE;
import haxe.Json;
import massive.sys.io.File as MassiveFile;
import massive.sys.io.FileSys;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

/**
 * Utilities for command line tools
 */
class CommandUtils
{
	/**
	 * Copy a directory and its contents recursively
	 * @param  source	  String the source directory to copy
	 * @param  destination String to destination to copy the directory to
	 * @param  overwrite  Overwrite the destination
	 * @return	Bool true if the new Destination exists after operation
	 */
	public static function copyRecursively(source:String, destination:String, overwrite:Bool = true, ?filter:EReg, exclude:Bool = false):Bool
	{
		// Windows can deal with forward slashes, but mlib thinks it can't be an absolute path
		// if there are no backslashes (see https://github.com/massiveinteractive/mlib/issues/13)
		if (Sys.systemName() == "Windows")
		{
			source = source.replace("/", "\\");
			destination = destination.replace("/", "\\");
		}

		final source = MassiveFile.create(source);
		final destination = MassiveFile.create(destination, true);

		source.copyTo(destination, overwrite, filter, exclude);

		return destination.exists;
	}

	public static function deleteRecursively(path:String)
	{
		if (FileSys.exists(path))
		{
			if (FileSys.isDirectory(path))
			{
				for (entry in FileSys.readDirectory(path))
				{
					deleteRecursively(path + "/" + entry);
				}
				FileSys.deleteDirectory(path);
			}
			else
			{
				FileSys.deleteFile(path);
			}
		}
	}

	/**
	 * Prompt user with a y/n/a
	 *
	 * @param   question	String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
	 */
	public static function askString(question:String):String
	{
		while (true)
		{
			Sys.println("");
			Sys.println(question);
			return readLine();
		}

		return null;
	}

	/**
	 * Prompt user with a y/n
	 *
	 * @param   question	String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
	 */
	public static function askYN(question:String):Answer
	{
		while (true)
		{
			Sys.println("");
			Sys.println(question + " [y/n]?");

			return switch (readLine())
			{
				case "n", "No": No;
				case "y", "Yes": Yes;
				case _: null;
			}
		}

		return null;
	}

	/**
	 * Prompt user with a y/n/a
	 *
	 * @param   question	String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
	 */
	public static function askYNA(question:String):Answer
	{
		while (true)
		{
			Sys.println("");
			Sys.println(question + " [y/n/a]?");

			return switch (readLine())
			{
				case "n", "No": Answer.No;
				case "y", "Yes": Answer.Yes;
				case "a", "Always": Answer.Always;
				case _: null;
			}
		}

		return null;
	}

	/**
	 * As the user a question with automatic numeric references to string answers,
	 * includes simple validation and cancel
	 * @param  answers 	array containing all the available answers
	 * @return			String the answer given or null if the choice was invalid
	 */
	public static function askQuestionStrings(header:String, answers:Array<String>):String
	{
		while (true)
		{
			Sys.println("");
			Sys.println(header);
			Sys.println("");

			for (i in 0...answers.length)
				Sys.println("  [" + i + "] " + answers[i]);
			Sys.println("");

			final userResponse = readLine();
			var validAnswer = "";

			for (i in 0...answers.length)
			{
				if (answers[i] == userResponse || Std.string(i) == userResponse)
				{
					validAnswer = userResponse;
				}
			}

			if (validAnswer != "")
			{
				if (Std.parseInt(validAnswer) != null)
				{
					return answers[Std.parseInt(userResponse)];
				}

				if (userResponse != "")
				{
					return userResponse;
				}
			}
		}

		return "";
	}

	/**
	 * Shortcut to the readline of the command line
	 *
	 * @return  String of the current line
	 */
	public static inline function readLine()
	{
		return Sys.stdin().readLine();
	}

	/**
	 * Load and parse the date from a Haxelib json file
	 *
	 * @param   haxelibName	 String name of the Haxelib to load
	 * @return  Haxelib typedef or null if no Haxelib was found
	 */
	public static function getHaxelibJsonData(haxelibName:String):HaxelibJSON
	{
		final haxleibJsonPath = getHaxelibPath(haxelibName);
		if (haxleibJsonPath == "")
			return null;

		final jsonContent = FileSysUtils.getContent(haxleibJsonPath + "haxelib.json");
		return Json.parse(jsonContent);
	}

	public static function strmatch(needle:String, haystack:String):Bool
	{
		final search = new EReg("\\b" + needle + "\\b", "");
		return search.match(haystack);
	}

	public static function getHaxePath():String
	{
		var haxePath = Sys.getEnv("HAXEPATH");

		if (haxePath == null || haxePath == "")
			haxePath = (FileSys.isMac ? "/usr/local/lib" : "/usr/lib") + "/haxe";

		return haxePath;
	}

	/**
	 * Get the path of a Haxelib on the current system
	 * @param  name String of the Haxelib to scan for
	 * @return	  String path of the Haxelib or "" if none found
	 */
	public static function getHaxelibPath(name:String):String
	{
		final proc = new Process("haxelib", ["path", name]);
		var result = "";

		try
		{
			var previous = "";
			while (true)
			{
				final line:String = proc.stdout.readLine();
				if (line.startsWith('-D $name'))
				{
					result = previous;
					break;
				}
				previous = line;
			}
		}
		catch (e:Dynamic) {}
		proc.close();

		return result;
	}

	/**
	 * Shortcut to join paths that is platform safe
	 */
	public static function combine(firstPath:String, secondPath:String):String
	{
		if (firstPath == null || firstPath == "")
		{
			return secondPath;
		}
		else if (secondPath != null && secondPath != "")
		{
			if (FileSys.isWindows)
			{
				if (secondPath.indexOf(":") == 1)
				{
					return secondPath;
				}
			}
			else if (secondPath.substr(0, 1) == "/")
			{
				return secondPath;
			}

			final firstSlash:Bool = (firstPath.substr(-1) == "/" || firstPath.substr(-1) == "\\");
			final secondSlash:Bool = (secondPath.substr(0, 1) == "/" || secondPath.substr(0, 1) == "\\");

			if (firstSlash && secondSlash)
			{
				return firstPath + secondPath.substr(1);
			}
			else if (!firstSlash && !secondSlash)
			{
				return firstPath + "/" + secondPath;
			}
			else
			{
				return firstPath + secondPath;
			}
		}

		return firstPath;
	}

	/**
	 * Shortcut to strip a relative path
	 */
	public static function stripPath(path:String):String
	{
		if (path.startsWith("./"))
			path = path.substring(2);

		if (path.endsWith("/"))
			path = path.substring(0, path.length - 1);

		return path;
	}

	public static function loadIDESettings()
	{
		var ideDataPath = getHaxelibPath("flixel-templates");
		if (ideDataPath == "")
			return;

		ideDataPath = combine(ideDataPath, "ide-data");

		FlxTools.templateSourcePaths = [
			IDE.FLASH_DEVELOP => combine(ideDataPath, "flash-develop"),
			IDE.INTELLIJ_IDEA => combine(ideDataPath, "intellij-idea"),
			IDE.SUBLIME_TEXT => combine(ideDataPath, "sublime-text"),
			IDE.VISUAL_STUDIO_CODE => combine(ideDataPath, "visual-studio-code")
		];
		FlxTools.templatesLoaded = true;
	}

	public static function loadToolSettings():FlxToolSettings
	{
		final toolPath = getHaxelibPath("flixel-tools");
		if (toolPath == "")
		{
			Sys.println("Error reading your settings, please run 'flixel setup'.");
			return null;
		}

		final settingsPath = toolPath + "settings.json";

		if (!FileSystem.exists(settingsPath))
		{
			Sys.println("It appears you have not run setup yet.");
			return null;
		}

		final jsonContent:String = FileSysUtils.getContent(toolPath + "settings.json");
		final settings:FlxToolSettings = Json.parse(jsonContent);

		// backwards compatibility with settings from versions <= 1.0.5
		if (settings.DefaultEditor == "Flash Develop")
			settings.DefaultEditor = IDE.FLASH_DEVELOP;
		else if (settings.DefaultEditor == "Intellij Idea")
			settings.DefaultEditor = IDE.INTELLIJ_IDEA;

		return settings;
	}

	public static function saveToolSettings(settings:FlxToolSettings)
	{
		final toolPath = getHaxelibPath("flixel-tools");
		if (toolPath == "")
		{
			Sys.println("Error detecting path of your haxelib flixel-tools.");
			return;
		}

		final settingsPath = toolPath + "settings.json";

		File.saveContent(settingsPath, Json.stringify(settings));

		FlxTools.settings = loadToolSettings();
	}

	public static function haxelibCommand(lib:String, autoContinue:Bool, ?message:String):Bool
	{
		final libStatus = getHaxelibPath(lib);
		if (libStatus == "")
		{
			if (message == null)
				message = "Do you want to install " + lib;

			if (!autoContinue)
			{
				final answer = askYN(message);
				if (answer == Answer.No)
					return false;
			}

			runCommand("haxelib", ["install", lib]);
			return true;
		}
		else
		{
			Sys.println("You appear to already have " + lib + " installed.");
			return false;
		}
	}

	/**
	 * Wrapper around `Sys.command()` that also prints the command.
	 */
	public static function runCommand(cmd:String, ?args:Array<String>)
	{
		if (args == null)
			Sys.println(cmd);
		else
			Sys.println(cmd + " " + args.join(" "));

		Sys.command(cmd, args);
	}
}

/**
 * Definition for the user Settings File of the tools
 */
typedef FlxToolSettings =
{
	DefaultEditor:String,
	AuthorName:String,
	IDEAutoOpen:Bool,
	IDEA_flexSdkName:String,
	IDEA_Flixel_Engine_Library:String,
	IDEA_Flixel_Addons_Library:String,
	IDEA_Path:String,
}

/**
 * Definition of a haxelib json file
 */
typedef HaxelibJSON =
{
	name:String,
	url:String,
	license:String,
	tags:Array<String>,
	description:String,
	version:String,
	releasenote:String,
	contributors:Array<String>,
	dependencies:Dynamic
}

/**
 * Type for command user prompts
 */
enum Answer
{
	Yes;
	No;
	Always;
}
