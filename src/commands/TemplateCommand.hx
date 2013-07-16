package commands;

import massive.sys.cmd.Command;

class TemplateCommand extends Command
{

	override public function execute():Void
	{




	}



	public function test(Name:String):Void 
	{
		if (Name == null)
		{
			Sys.println(" Creating default template");
			Name = "basic";
		}
		
		// if (Name == "flashdevelop-basic") 
		// {
		// 	if (PlatformHelper.hostPlatform == Platform.WINDOWS)
		// 	{
		// 		var fdTemplatePath:String = PathHelper.getHaxelib(new Haxelib ("flixel-tools")) + "templates/flashdevelop-basic/";
		// 		helpers.ProcessHelper.openFile(fdTemplatePath, "FlxTemplate.fdz");
		// 	} 
		// 	else
		// 	{
		// 		Sys.println("Sorry Flash Develop only supports WINDOWS");
		// 	}
		// }
		else
		{
			var templates = scanTemplates("", "", false);
			
			if (templates.get(Name) != null)
			{
				var destination:String = Sys.getCwd() + commandsSet.projectName;
				
				Sys.println(" - Creating " + Name);
				
				FileHelper.recursiveCopy(templates.get(Name), destination);
				
				if (FileSystem.isDirectory(destination))
				{
					modifyTemplate(destination);
					
					Sys.println(" - Created " + Name);
					Sys.println(destination);
				}
				else
				{
					Sys.println(" There was a problem creating " + destination);
				}
			}
			else
			{
				Sys.println(" Error there is no demo with the name of " + Name);
			}
		}
	}
}