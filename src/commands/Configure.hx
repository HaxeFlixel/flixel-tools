package commands;

import FlxTools.IDE;
import haxe.Json;
import haxe.io.Path;
import massive.sys.cmd.Command;
import sys.FileSystem;
import sys.io.File;
import utils.FileSysUtils;
import utils.ProjectUtils;
import utils.TemplateUtils;

class Configure extends Command
{
	override public function execute()
	{
		TemplateUtils.verifyTemplatesLoaded();

		if (console.args.length != 2)
			error("Invalid number of arguments!");

		final directory = console.args[1];
		final ide = ProjectUtils.resolveIDEChoice(console);
		if (ide != IDE.VISUAL_STUDIO_CODE)
			// TOOD: support other IDEs (need template replacements)
			error('configure only supports ${IDE.VISUAL_STUDIO_CODE} at the moment');

		final projects = ProjectUtils.findLimeProjects(directory);
		if (projects.length == 0)
		{
			final fullPath = FileSystem.fullPath(directory);
			error('Could not find any Project.xml files in \'$fullPath\'');
		}

		for (project in projects)
		{
			final fullPath = FileSystem.fullPath(project.path);
			print('Adding $ide files to \'$fullPath\'...');

			final applicationName = try
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
		final workspace = {
			folders: []
		};

		final fullPath = FileSystem.fullPath(directory);

		for (project in projects)
		{
			workspace.folders.push({
				path: FileSysUtils.relativize(project.path, fullPath)
			});
		}

		final segments = Path.normalize(fullPath).split("/");
		final lastSegment = segments[segments.length - 1];
		final projectName = if (lastSegment == "git") segments[segments.length - 2] else lastSegment;
		final workspaceFile = '$projectName.code-workspace';

		Sys.println('Adding $workspaceFile to \'${fullPath}\'...');
		File.saveContent(Path.join([directory, workspaceFile]), Json.stringify(workspace, null, "\t"));
	}
}
