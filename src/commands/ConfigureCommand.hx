package commands;

import massive.sys.cmd.Command;
import utils.ProjectUtils;
import utils.TemplateUtils;
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
		
		var projects = [];
		var isProjectFolder = ProjectUtils.findProjectXml(directory) != null;
		if (isProjectFolder)
			projects.push(directory);
		else
		{
			projects = ProjectUtils.findLimeProjects(directory).map(
				function(p) return p.path
			);
		}
		
		for (project in projects)
		{
			print('Adding $ide files to $project...');
			ProjectUtils.copyIDETemplateFiles(project, null, ide);
		}
	}
}