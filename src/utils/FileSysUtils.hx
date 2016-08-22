package utils;

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
		var content = "";

		try
		{
			content = sys.io.File.getContent(filePath);
		}
		catch (e:Dynamic)
		{
			throw "Error loading file::" + filePath + " \n check you dont have it open and you have permissions to modify it.";
		}

		return content;
	}

	/**
	 * Run some code in the specified directory, then move the cwd back where it was previously.
	 */
	public static function runInDirectory(directory:String, f:Void->Void)
	{
		var cwd = Sys.getCwd();
		Sys.setCwd(directory);

		f();

		Sys.setCwd(cwd);
	}
}