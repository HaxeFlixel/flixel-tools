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
	public static function addImportToFileString(FileString:String, ImportString:String):String 
	{
		var str:String = FileString;
		var match = strmatch(ImportString, str);

		if(!match)
		{
			var newLine = "\n";
			var r = ~/import+/;
			var newString = Reflect.copy(str);
			r.match(str);

			try
			{
				var matchPos = r.matchedPos();
				var beggining = str.substr(0,matchPos.pos);
				var end = str.substr(matchPos.pos, str.length);
				newString = beggining + ImportString + ";" + newLine + end;
			}
			catch (e:Dynamic){}

			if(newString != str)
			{
				return newString;
			}
			else
			{
				return null;
			}

		}

		return null;
	}

	/**
	 * Prompt user with a y/n/a
	 * 
	 * @param   Question    String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
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
	 * As the user a question with automatic numeric references to string answers,
	 * includes simple validation and cancel
	 * @param  Question        String to display as the question
	 * @param  Answers<String> Array<String> containing all the available answers
	 * @return                 String the answer given or null if the choice was invalid
	 */
	static public function askQustionStrings(Question:String, Header:String, Answers:Array<String>):String
	{
		while (true)
		{
			Sys.println("");
			Sys.println(Header);    
			Sys.println("");

			for( i in 0...Answers.length )
			{
				Sys.println( " [" + i + "] " + Answers[i]);
			}

			Sys.println( "");
			Sys.println( " [c] Cancel");
			Sys.println( "");

			Sys.println("");
			Sys.println(Question);    
			Sys.println("");

			var userResponse = readLine();
			var validAnswer = "";

			for( i in 0...Answers.length )
			{
				if( Answers[i] == userResponse || Std.string(i) == userResponse )
				{
					validAnswer = userResponse;
				}
				else if(userResponse == "c")
				{
					Sys.println(" Cancelled");
					return 	null;
				}
			}

			if (validAnswer != "")
			{
				return Answers[Std.parseInt(userResponse)];
			}
			else
			{
				return null;
			}
		}
		
		return null;
	}

	/**
	 * Shortcut to the readline of the command line
	 * 
	 * @return  String of the current line
	 */
	inline static public function readLine()
	{
		return Sys.stdin().readLine();
	}

	/**
	 * Load and parse the date from a Haxelib json file
	 * 
	 * @param   HaxelibName     String name of the Haxelib to load
	 * @return  Haxelib typedef or null if no Haxelib was found
	 */
	static public function getHaxelibJsonData(HaxelibName:String):HaxelibJSON
	{
		var haxleibJsonPath = PathHelper.getHaxelib(new Haxelib(HaxelibName));
		
		if (haxleibJsonPath == "")
		{
			return null;
		}
		
		var jsonContent:String = File.getContent(haxleibJsonPath + "haxelib.json");
		var jsonData:HaxelibJSON = Json.parse(jsonContent);
		
		return jsonData;
	}


	static public function strmatch(Needle:String, Haystack:String):Bool
	{
		var search = new EReg("\\b" + Needle + "\\b", "");
		return search.match(Haystack);
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