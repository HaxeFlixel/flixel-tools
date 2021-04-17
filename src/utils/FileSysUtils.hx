package utils;

import haxe.io.Path;
import sys.io.File;

/**
 * Utilities for FileSys Commands
 */
class FileSysUtils
{
	/**
	 * Return the content of a text based file or throws an error with the problem path
	 */
	public static function getContent(filePath:String):String
	{
		try
		{
			return File.getContent(filePath);
		}
		catch (e:Dynamic)
		{
			throw "Error loading file::" + filePath + " \n check you dont have it open and you have permissions to modify it.";
		}
	}

	/**
	 * Run some code in the specified directory, then move the cwd back where it was previously.
	 */
	public static function runInDirectory(directory:String, f:() -> Void)
	{
		final cwd = Sys.getCwd();
		Sys.setCwd(directory);

		f();

		Sys.setCwd(cwd);
	}

	public static function relativize(path:String, cwd:String)
	{
		path = Path.normalize(path);
		cwd = Path.normalize(cwd) + "/";

		final segments = path.split(cwd);
		segments.shift();
		return segments.join(cwd);
	}
}
