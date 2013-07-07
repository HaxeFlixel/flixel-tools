
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
     * Prompt user with a y/n/a
     * @param  question String with the prompt to display
     * @return          User choice in an Answer enum or null if an invalid answer given
     */
    public static function ask (question:String):Answer
    {    
        while (true)
        {
            Sys.println (question + " [y/n/a] ? ");    
            switch (readLine ())
            {
                case "n": return No;
                case "No": return No;
                case "y": return Yes;
                case "Yes": return Yes;
                case "a": return Always;
                case "Always": return Always;
            }
        }
        return null;
    }

    /**
     * Shortcut to the readline of the command line
     * @return String of the current line
     */
    public static inline function readLine()
    {
        return Sys.stdin ().readLine ();
    }

    /**
     * Load and parse the date from a Haxelib json file
     * @param  haxelibName String name of the Haxelib to load
     * @return             Haxelib typedef or null if no Haxelib was found
     */
    public static function getHaxelibJsonData(haxelibName:String):HaxelibJSON
    {
        var haxleibJsonPath = PathHelper.getHaxelib(new Haxelib(haxelibName));
        
        if ( haxleibJsonPath == "" )
        	return null;

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