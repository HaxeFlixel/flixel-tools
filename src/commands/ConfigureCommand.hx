package commands;

import massive.sys.cmd.Command;
import utils.ProjectUtils;
import utils.TemplateUtils;
import utils.FileSysUtils;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import haxe.Json;
import FlxTools.IDE;

class ConfigureCommand extends Command
{
	override public function execute():Void
	{
		TemplateUtils.verifyTemplatesLoaded();

		if (console.args.length != 2)
			error("Invalid number of arguments!");

		var directory = console.args[1];
		var ide = ProjectUtils.resolveIDEChoice(console);
		if (ide != IDE.VISUAL_STUDIO_CODE)
			// TOOD: support other IDEs (need template replacements)
			error('configure only supports ${IDE.VISUAL_STUDIO_CODE} at the moment');

		var projects = ProjectUtils.findLimeProjects(directory);
		if (projects.length == 0)
		{
			var fullPath = FileSystem.fullPath(directory);
			error('Could not find any Project.xml files in \'$fullPath\'');
		}

		for (project in projects)
		{
			var fullPath = FileSystem.fullPath(project.path);
			print('Adding $ide files to \'$fullPath\'...');

			var applicationName = try
			{
				ProjectUtils.getApplicationFile(FileSystem.fullPath(project.projectXmlPath));
			}
			catch (_:Dynamic)
			{
				project.name;
			}

			var replacements = [TemplateUtils.addOption("APPLICATION_FILE", "", applicationName)];
			replacements = ProjectUtils.copyIDETemplateFiles(fullPath, replacements, ide);
			TemplateUtils.modifyTemplate(fullPath, replacements);
		}

		if (projects.length > 1 && ide == IDE.VISUAL_STUDIO_CODE)
			generateVSCodeWorkspace(directory, projects);
	}

	function generateVSCodeWorkspace(directory:String, projects:Array<LimeProject>)
	{
		var workspace = {
			folders: []
		};

		var fullPath = FileSystem.fullPath(directory);

		for (project in projects)
		{
			workspace.folders.push({
				path: FileSysUtils.relativize(project.path, fullPath)
			});
		}

		var segments = Path.normalize(fullPath).split("/");
		var lastSegment = segments[segments.length - 1];
		var projectName = if (lastSegment == "git") segments[segments.length - 2] else lastSegment;
		var workspaceFile = '$projectName.code-workspace';

		Sys.println('Adding $workspaceFile to \'${fullPath}\'...');
		File.saveContent(Path.join([directory, workspaceFile]), Json.stringify(workspace, null, "\t"));
	}
}
