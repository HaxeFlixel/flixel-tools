package utils;

import project.Haxelib;
import project.Platform;
import helpers.FileHelper;
import helpers.PlatformHelper;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;

/**
 * Utilities for command line tools
 */
class CommandLine
{
	/**
	* Basic Ereg match to add an import above the first in a file if none exists
	* @param FilePath     Path to the file to add to
	* @param ImportString The complete import string to seach for and add
	*/
    public static function addImportToFile(FilePath:String, ImportString:String):Bool 
    {
        var str:String = File.getContent(FilePath);
        
        if(str.indexOf(ImportString) != -1)
            return false;

        var newLine = "\n";
        var r = ~/import+/;
        var newString = Reflect.copy(str);
        r.match(str);

        try
        {
            var matchPos = r.matchedPos();
            var beggining = str.substr(0,matchPos.pos);
            var end = str.substr(matchPos.pos, str.length);
            newString = beggining + ImportString + newLine + end;
        }
        catch (e:Dynamic){}

        if(newString != str)
        {
            File.saveContent(FilePath,newString);
            return true;
        }
        else
        {
            return false;
        }
    }

	/**
	 * Prompt user with a y/n/a
	 * 
	 * @param	Question	String with the prompt to display
	 * @return	User choice in an Answer enum or null if an invalid answer given
	 */
	static public function ask(Question:String):Answer
	{
		while (true)
		{
			Sys.println(Question + " [y/n/a] ? ");    
			
			switch (readLine())
			{
				case "n", "No": 
					return No;
				case "y", "Yes": 
					return Yes;
				case "a", "Always": 
					return Always;
			}
		}
		
		return null;
	}

	/**
	 * Shortcut to the readline of the command line
	 * 
	 * @return	String of the current line
	 */
	inline static public function readLine()
	{
		return Sys.stdin().readLine();
	}

	/**
	 * Load and parse the date from a Haxelib json file
	 * 
	 * @param	HaxelibName		String name of the Haxelib to load
	 * @return	Haxelib typedef or null if no Haxelib was found
	 */
	static public function getHaxelibJsonData(haxelibName:String):HaxelibJSON
	{
		var haxleibJsonPath = PathHelper.getHaxelib(new Haxelib(haxelibName));
		
		if (haxleibJsonPath == "")
		{
			return null;
		}
		
		var jsonContent:String = File.getContent(haxleibJsonPath + "haxelib.json");
		var jsonData:HaxelibJSON = Json.parse(jsonContent);
		
		return jsonData;
	}
}

/**
 * Definition of a haxelib json file
 */
typedef HaxelibJSON = {
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
enum Answer {
	Yes;
	No;
	Always;
}