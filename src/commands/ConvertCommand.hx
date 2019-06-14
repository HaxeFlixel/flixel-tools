package commands;

import legacy.FindAndReplace;
import legacy.Warnings;
import massive.sys.cmd.Command;
import massive.sys.io.FileSys;
import sys.io.File;
import sys.io.FileOutput;
import utils.CommandUtils;
import utils.FileSysUtils;

using StringTools;

class ConvertCommand extends Command
{
	var autoContinue:Bool = false;

	override public function execute():Void
	{
		if (console.args.length > 2)
			this.error("You have not provided the correct arguments.");

		var convertPath = "";

		if (console.args[1] != null)
			convertPath = console.args[1];

		if (console.getOption("-y") != null)
			autoContinue = true;

		var makeBackup = true;
		if (console.getOption("-nb") != null)
			makeBackup = false;

		convertProject(convertPath, makeBackup);
	}

	/**
	 * Convert an old HaxeFlixel project
	 */
	function convertProject(convertPath:String = "", makeBackup:Bool = true):Void
	{
		if (convertPath == "")
		{
			convertPath = Sys.getCwd();
		}
		else if (!convertPath.startsWith("/"))
		{
			convertPath = Sys.getCwd() + CommandUtils.stripPath(convertPath);
		}

		if (!autoContinue)
		{
			var continueConvert = CommandUtils.askYN("Do you want to convert " + convertPath);

			if (continueConvert == Answer.Yes)
			{
				Sys.println("");
				convert(convertPath, makeBackup);
			}
			else
			{
				Sys.println("Cancelling Convert.");
				exit();
			}
		}
		else
		{
			Sys.println("");
			convert(convertPath, makeBackup);
		}
	}

	function convert(convertPath:String, makeBackup:Bool):Void
	{
		if (FileSys.exists(convertPath))
		{
			Sys.println(" Converting :" + convertPath);
			Sys.println("");

			if (makeBackup)
			{
				var backupFolder = convertPath + "_backup";

				if (!FileSys.exists(backupFolder))
				{
					var backup = CommandUtils.copyRecursively(convertPath, backupFolder);
					if (backup)
					{
						Sys.println("Backup copied to " + backupFolder);
					}
					else
					{
						error("A problem occured when making a backup at " + backupFolder);
					}
				}
				else
				{
					if (!autoContinue)
					{
						var overwrite = CommandUtils.askYN("There is already a backup at " + backupFolder + ", do you want to overwrite it?");

						if (overwrite == Answer.Yes)
						{
							createBackup(convertPath, backupFolder);
						}
						else
						{
							Sys.println("Cancelled");
							exit();
						}
					}
					else
					{
						createBackup(convertPath, backupFolder);
					}
				}
			}

			if (FileSys.exists(convertPath))
			{
				var warnings:Array<WarningResult> = convertProjectFolder(convertPath, true);

				if (warnings.length > 0)
				{
					var logFileName = "convert.log";
					var filePath = CommandUtils.combine(convertPath, logFileName);

					writeWarningsToFile(filePath, warnings, convertPath);

					Sys.println("");
					Sys.println(" " + warnings.length + " warnings were written to " + filePath);
					Sys.println("");
				}

				var oldAssets = CommandUtils.combine(convertPath, "assets");
				oldAssets = CommandUtils.combine(oldAssets, "data");

				if (FileSys.exists(oldAssets))
				{
					var answer = null;

					if (!autoContinue)
					{
						var question = "The old HaxeFlixel data assets was detected, do you want to delete it and its contents?";
						var warning = "\nPlease make sure you are not storing your own assets in:" + oldAssets;
						answer = CommandUtils.askYN(question + warning);
					}

					if (answer == Answer.Yes || autoContinue)
					{
						Sys.println("Deleting old core assets:" + oldAssets);
						CommandUtils.deleteRecursively(oldAssets);
					}
					else
					{
						Sys.println("Cancelling convert based on answer of deleting the old data directory.");
						exit();
					}
				}
			}
			else
			{
				Sys.println(" ");
				Sys.println(" Warning there was a problem with the path to convert.");
				Sys.println(" " + convertPath);
				Sys.println(" ");
			}
		}
		else
		{
			Sys.println("Warning cannot find " + convertPath);
			Sys.println("");
		}

		exit();
	}

	inline function displayWarnings(warnings:Array<WarningResult>):Void
	{
		Sys.println("");
		Sys.println(warnings.length + " Warnings");

		for (warning in warnings)
		{
			Sys.println("");
			Sys.println(" File Path	:" + warning.filePath);
			Sys.println(" Line Number  :" + warning.lineNumber);
			Sys.println(" Issue		:" + warning.oldCode);
			Sys.println(" Solution	 :" + warning.newCode);
		}

		Sys.println("");
		Sys.println(" Warning although this command updates a lot, its not perfect.");
		// todo wiki page
		Sys.println(" Please visit haxeflixel.com/wiki/convert for further documentation on converting old code.");
		Sys.println("");
	}

	inline function createBackup(convertPath:String, backupFolder:String):Void
	{
		var backup = CommandUtils.copyRecursively(convertPath, backupFolder);
		if (backup)
		{
			Sys.println("Backup copied to " + backupFolder);
		}
		else
		{
			error("A problem occured when making a backup at " + backupFolder);
		}
	}

	/**
	 * Recursively use find and replace on *.hx files inside a project directory
	 *
	 * @param   projectPath	 Path to scan recursivley
	 */
	inline function convertProjectFolder(projectPath:String, display:Bool = false):Array<WarningResult>
	{
		var warnings:Array<WarningResult> = new Array<WarningResult>();

		if (FileSys.exists(projectPath))
		{
			for (fileName in FileSys.readDirectory(projectPath))
			{
				if (FileSys.isDirectory(CommandUtils.combine(projectPath, fileName)) && fileName != "_backup")
				{
					var recursiveWarnings:Array<WarningResult> = convertProjectFolder(CommandUtils.combine(projectPath, fileName), false);

					if (recursiveWarnings != null)
					{
						for (warning in recursiveWarnings)
						{
							warnings.push(warning);
						}
					}
				}
				else if (fileName.endsWith(".hx"))
				{
					var filePath:String = CommandUtils.combine(projectPath, fileName);
					var sourceText:String = FileSysUtils.getContent(filePath);
					var originalText:String = Reflect.copy(sourceText);
					var replacements:Array<FindAndReplaceObject> = FindAndReplace.init();

					for (replacement in replacements)
					{
						var obj:FindAndReplaceObject = replacement;
						sourceText = sourceText.replace(obj.find, obj.replacement);

						if (obj.importValidate != null && CommandUtils.strmatch(obj.find, originalText))
						{
							var newText = addImportToFileString(sourceText, obj.importValidate);
							if (newText != null)
							{
								sourceText = newText;
							}
						}

						if (originalText != sourceText)
						{
							FileSys.deleteFile(filePath);
							var o:FileOutput = sys.io.File.write(filePath, true);
							o.writeString(sourceText);
							o.close();
						}
					}

					var warningsCurrent = scanFileForWarnings(filePath);

					if (warningsCurrent != null)
					{
						for (warning in warningsCurrent)
						{
							warnings.push(warning);
						}
					}
				}
			}
		}

		return warnings;
	}

	/**
	 * Write a warning log to a file
	 * @param  FilePath				 String to as the destination for the log file
	 * @param  Warnings<WarningResult>  Array containing all the WarningResults
	 * @param  ConvertProjectPath	   The path that the convert command was performed on
	 */
	public static function writeWarningsToFile(filePath:String, warnings:Array<WarningResult>, convertProjectPath:String):Void
	{
		var fileObject = File.write(filePath, false);

		fileObject.writeString("flixel-tools convert warning log" + "\n");
		fileObject.writeString("Converted Path " + convertProjectPath + "\n");
		fileObject.writeString("Please visit haxeflixel.com/wiki/convert for further documentation on converting old code.");
		fileObject.writeString("\n\n");

		for (warning in warnings)
		{
			fileObject.writeString("\n");
			fileObject.writeString("File Path	:" + warning.filePath + "\n");
			fileObject.writeString("Line Number  :" + warning.lineNumber + "\n");
			fileObject.writeString("Issue		:" + warning.oldCode + "\n");
			fileObject.writeString("Solution	 :" + warning.newCode + "\n");
		}

		fileObject.writeString("\n");
		fileObject.writeString(" / End of Log.");

		fileObject.close();
	}

	/**
	 * Scans a file for a string to warn about
	 * @param  FilePath the path of the file to scan
	 * @return		  WarningResult with data for what the warning was and info
	 */
	public static function scanFileForWarnings(filePath:String):Array<WarningResult>
	{
		var results = new Array<WarningResult>();

		// open and read file line by line
		var fin = File.read(filePath, false);

		try
		{
			var lineNum = 0;
			while (true)
			{
				var str = fin.readLine();
				lineNum++;
				var warnings = Warnings.warningList;

				for (warning in warnings.keys())
				{
					var fix = warnings.get(warning);
					var search = new EReg("\\b" + warning + "\\b", "");
					var match = search.match(str);

					if (match)
					{
						var result:WarningResult = {
							oldCode: warning,
							newCode: fix,
							lineNumber: Std.string(lineNum),
							filePath: filePath
						};

						results.push(result);
					}
				}
			}
		}
		catch (ex:haxe.io.Eof) {}

		fin.close();

		return results;
	}

	/**
	 * Basic Ereg match to add an import above the first in a file if none exists
	 * @param fileString	 Path to the file to add to
	 * @param importString The complete import string to seach for and add
	 */
	public static function addImportToFileString(fileString:String, importString:String):String
	{
		var str:String = fileString;
		var match = CommandUtils.strmatch(importString, str);

		if (!match)
		{
			var newLine = "\n";
			var r = ~/import+/;
			var newString = Reflect.copy(str);
			r.match(str);

			try
			{
				var matchPos = r.matchedPos();
				var beggining = str.substr(0, matchPos.pos);
				var end = str.substr(matchPos.pos, str.length);
				newString = beggining + importString + ";" + newLine + end;
			}
			catch (e:Dynamic) {}

			if (newString != str)
				return newString;
		}

		return null;
	}
}

/**
 * Warning Result for warning about old code that cannot be updated manually
 */
typedef WarningResult =
{
	var oldCode:String;
	var newCode:String;
	var lineNumber:String;
	var filePath:String;
}
