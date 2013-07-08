package utils;

import project.Haxelib;
import project.NDLL;
import project.Platform;
import sys.io.Process;
import sys.FileSystem;
import helpers.FileHelper;
import helpers.LogHelper;
import helpers.PlatformHelper;

class PathHelper 
{
	static public function combine(FirstPath:String, SecondPath:String):String 
	{
		if (FirstPath == null || FirstPath == "") 
		{
			return SecondPath;
		} 
		else if (SecondPath != null && SecondPath != "") 
		{
			if (PlatformHelper.hostPlatform == Platform.WINDOWS) 
			{
				if (SecondPath.indexOf (":") == 1) 
				{
					return SecondPath;
				}
			} 
			else 
			{
				if (SecondPath.substr (0, 1) == "/") 
				{
					return SecondPath;
				}
			}
			
			var firstSlash:Bool = (FirstPath.substr (-1) == "/" || FirstPath.substr (-1) == "\\");
			var secondSlash:Bool = (SecondPath.substr (0, 1) == "/" || SecondPath.substr (0, 1) == "\\");
			
			if (firstSlash && secondSlash) 
			{
				return FirstPath + SecondPath.substr (1);
			} 
			else if (!firstSlash && !secondSlash) 
			{
				return FirstPath + "/" + SecondPath;
				
			} 
			else 
			{
				return FirstPath + SecondPath;
			}
		} 
		else 
		{
			return FirstPath;
		}
	}

	static public function escape(EscapePath:String):String 
	{
		if (PlatformHelper.hostPlatform != Platform.WINDOWS) 
		{
			EscapePath = StringTools.replace(EscapePath, " ", "\\ ");
			
			return expand(EscapePath);
		}
		
		return expand(EscapePath);
	}

	static public function expand(ExpandPath:String):String 
	{
		if (ExpandPath == null) 
		{
			ExpandPath = "";
		}
		
		if (PlatformHelper.hostPlatform != Platform.WINDOWS) 
		{
			if (StringTools.startsWith(ExpandPath, "~/")) 
			{
				ExpandPath = Sys.getEnv("HOME") + "/" + ExpandPath.substr(2);
			}
		}
		
		return ExpandPath;
	}

	static public function findTemplate(TemplatePaths:Array<String>, TemplatePath:String, WarnIfNotFound:Bool = true):String 
	{
		var matches:Array<String> = findTemplates(TemplatePaths, TemplatePath, WarnIfNotFound);
		
		if (matches.length > 0) 
		{
			return matches[matches.length - 1];
		}
		
		return null;
	}

	static public function findTemplates(TemplatePaths:Array<String>, TemplatePath:String, WarnIfNotFound:Bool = true):Array <String> 
	{
		var matches = [];
		
		for (templatePath in TemplatePaths) 
		{
			//Sys.println ("
			
			var targetPath:String = combine(templatePath, TemplatePath);
			
			if (FileSystem.exists(targetPath)) 
			{
				matches.push(targetPath);
			}
		}
		
		if (matches.length == 0 && WarnIfNotFound) 
		{
			LogHelper.warn ("Could not find template file: " + TemplatePath);
		}
		
		return matches;
	}
	

	static public function getHaxelib(Library:Haxelib, Validate:Bool = false):String 
	{
		var name:String = Library.name;
		
		if (Library.version != "") 
		{
			name += ":" + Library.version;
		}
		
		if (name == "nme") 
		{
			var nmePath:String = Sys.getEnv("NMEPATH");
			
			if (nmePath != null && nmePath != "") 
			{
				return nmePath;
			}
		}
		
		var proc:Process = new Process(combine(Sys.getEnv("HAXEPATH"), "haxelib"), ["path", name]);
		var result:String = "";
		
		try 
		{
			// hack seems to be needed because of latest haxelib?
			var previous:String = "";
			
			while (true) 
			{
				var line:String = proc.stdout.readLine();
				
				if (line == "-D " + name)
				{
					result = previous;
					break;
				}
				
				previous = line;
			}
			
		} 
		catch (e:Dynamic) { };
		
		proc.close();
		
		if (Validate) 
		{
			if (result == "")
			{
				LogHelper.error("Could not find haxelib \"" + Library.name + "\", does it need to be installed?");
			} 
			else if (result != null && result.indexOf ("is not installed") > -1) 
			{
				LogHelper.error(result);
			}
		}
		
		return result;
	}

	static public function getLibraryPath(Ndll:NDLL, DirectoryName:String, NamePrefix:String = "", NameSuffix:String = ".ndll", AllowDebug:Bool = false):String {
		
		var usingDebug:Bool = false;
		var path:String = "";
		
		if (AllowDebug) 
		{
			path = searchForLibrary(Ndll, DirectoryName, NamePrefix + Ndll.name + "-debug" + NameSuffix);
			usingDebug = FileSystem.exists(path);
		}
		
		if (!usingDebug) 
		{
			path = searchForLibrary(Ndll, DirectoryName, NamePrefix + Ndll.name + NameSuffix);
		}
		
		return path;
	}

	static public function getTemporaryFile(Extension:String = ""):String 
	{
		var path:String = "";
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) 
		{
			path = Sys.getEnv ("TEMP");	
		} 
		else 
		{
			path = Sys.getEnv ("TMPDIR");
		}
		
		path += "/temp_" + Math.round (0xFFFFFF * Math.random()) + Extension;
		
		if (FileSystem.exists(path)) 
		{
			return getTemporaryFile(Extension);
		}
		
		return path;
	}

	static public function isAbsolute(PathToCheck:String):Bool 
	{
		if (StringTools.startsWith(PathToCheck, "/") || StringTools.startsWith(PathToCheck, "\\")) 
		{
			return true;
		}
		
		return false;
	}

	static public function isRelative(PathToCheck:String):Bool 
	{
		return !isAbsolute(PathToCheck);
	}

	static public function mkdir(Directory:String):Void 
	{
		Directory = StringTools.replace(Directory, "\\", "/");
		var total:String = "";
		
		if (Directory.substr (0, 1) == "/") 
		{
			total = "/";
		}
		
		var parts:Array<String> = Directory.split("/");
		var oldPath:String = "";
		
		if (parts.length > 0 && parts[0].indexOf (":") > -1) 
		{
			oldPath = Sys.getCwd ();
			Sys.setCwd(parts[0] + "\\");
			parts.shift ();
		}
		
		for (part in parts) 
		{
			if (part != "." && part != "")
			{
				if (total != "") 
				{
					total += "/";
				}
				
				total += part;
				
				if (!FileSystem.exists(total)) 
				{
					LogHelper.info("", " - Creating directory: " + total);
					FileSystem.createDirectory(total);
				}
			}
		}
		
		if (oldPath != "") 
		{
			Sys.setCwd(oldPath);
		}
	}

	static public function relocatePath(PathToRelocate:String, TargetDirectory:String):String 
	{
		// this should be improved for target directories that are outside the current working path
		if (isAbsolute(PathToRelocate) || TargetDirectory == "") 
		{
			return PathToRelocate;	
		} 
		else if (isAbsolute(TargetDirectory)) 
		{
			return FileSystem.fullPath(PathToRelocate);	
		} 
		else 
		{
			TargetDirectory = StringTools.replace(TargetDirectory, "\\", "/");
			
			var splitTarget:Array<String> = TargetDirectory.split("/");
			var directories:Int = 0;
			
			while (splitTarget.length > 0) 
			{
				switch (splitTarget.shift ()) 
				{
					case ".":
						// ignore
					case "..":
						directories--;
					default:
						directories++;
				}
			}
			
			var adjust:String = "";
			
			for (i in 0...directories) 
			{
				adjust += "../";
			}
			
			return adjust + PathToRelocate;
		}
	}

	static public function relocatePaths(Paths:Array <String>, TargetDirectory:String):Array <String> 
	{
		var relocatedPaths:Array<String> = Paths.copy();
		
		for (i in 0...Paths.length) 
		{
			relocatedPaths[i] = relocatePath(Paths[i], TargetDirectory);
		}
		
		return relocatedPaths;
	}

	static public function removeDirectory(Directory:String):Void 
	{
		if (FileSystem.exists(Directory)) 
		{
			var files:Array<String>;
			
			try 
			{
				files = FileSystem.readDirectory(Directory);
			} 
			catch (e:Dynamic) 
			{
				return;
			}
			
			for (file in FileSystem.readDirectory(Directory)) 
			{
				var path:String = Directory + "/" + file;
				
				if (FileSystem.isDirectory(path)) 
				{
					removeDirectory(path);
				} 
				else 
				{
					try 
					{
						FileSystem.deleteFile(path);
					} 
					catch (e:Dynamic) {}
				}
			}
			
			LogHelper.info("", " - Removing directory: " + Directory);
			
			try 
			{
				FileSystem.deleteDirectory(Directory);
			} 
			catch (e:Dynamic) {}
		}
	}

	static public function safeFileName(Name:String):String 
	{
		var safeName = StringTools.replace(Name, " ", "");
		
		return safeName;
	}

	static private function searchForLibrary(Ndll:NDLL, DirectoryName:String, Filename:String):String 
	{
		if (Ndll.path != null && Ndll.path != "") 
		{
			return Ndll.path;
		} 
		else if (Ndll.haxelib == null) 
		{
			if (Ndll.extensionPath != null && Ndll.extensionPath != "") 
			{
				return combine(Ndll.extensionPath, "ndll/" + DirectoryName + "/" + Filename);
			} 
			else 
			{
				return Filename;
			}
		} 
		else if (Ndll.haxelib.name == "hxcpp") 
		{
			return combine(getHaxelib(Ndll.haxelib), "bin/" + DirectoryName + "/" + Filename);
		} 
		else if (Ndll.haxelib.name == "nme") 
		{
			var path:String = combine(getHaxelib(Ndll.haxelib), "ndll/" + DirectoryName + "/" + Filename);
			
			//if (!FileSystem.exists (path)) 
			//{
				//path = combine(getHaxelib(new Haxelib("nmedev")), "ndll/" + DirectoryName + "/" + Filename);
			//}
			
			return path;
		} 
		else 
		{
			return combine(getHaxelib(Ndll.haxelib), "ndll/" + DirectoryName + "/" + Filename);
		}
	}

	static public function tryFullPath(FullPath:String):String 
	{
		try 
		{
			return FileSystem.fullPath(FullPath);
		} 
		catch (e:Dynamic) 
		{
			return expand(FullPath);
		}
	}
}