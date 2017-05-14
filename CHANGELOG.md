1.3.0
------------------------------
* Added support for flixel-templates' VSCode `launch.json`

1.2.1
------------------------------
* `setup` command:
	* fixed an installation issue on Linux (#68)

1.2.0
------------------------------
* Added a new `configure` command (allows adding VSCode config files to a project)
* Added `vscode` as an option for `-ide` flags
* Added support for auto-opening in IntelliJ IDEA on all platforms (#66)
* Changed the default IDE to Visual Studio code

1.1.3
------------------------------
* `buildprojects` command:
	* added a `-verbose` option
	* added support for `-Dvalue`
* `template` command:
	* fixed `-ide` option not working

1.1.2
------------------------------
* `setup` command:
	* fixed the installation path on OS X El Capitan

1.1.1
------------------------------
* `setup` command:
	* fixed the Sublime Text symlink command on Mac
* `template` command:
	* fixed some template variables not being replaced with IDE option "None" 

1.1.0
------------------------------
* `testdemos` command:
	* removed the `validate` alias 
	* renamed it to `buildprojects` (`bp`)
	* fixed an error when not specifying a target (defaults to flash)
	* more compact and more helpful output
	* `-<target>` is now `<target>`
	* added a `-dir` option to build projects other than the flixel-demos haxelib
	* made the output on linux colored based on the exit code of `haxelib run openfl`
	* `compile_results.log` is now only created with the `-log` option
	* fixed `openfl build` calls not working when the tools are built with Haxe 3.2+
* `create` command:
	* don't ask for confirmation for the auto-open in IDE option 
	* minor optimization 
	* improved the demo list output
	* added a `-dir` option to create projects other than the flixel-demos haxelib
	* don't copy `export` folders
* `template` command:
	* fixed the auto-open in IDE option only being respected with Sublime Text
	* fixed exception when trying to delete already exisitng dir when files in that dir are in use
* `setup` command:
	* don't ask for an author name anymore (wasn't being used) 
* Changed the syntax for the IDE override options of `create` and `template` from `-subl|-fd|-idea|-noide` to `-ide <subl|fd|idea|none>`
* The HaxeFlixel header is now only displayed with `flixel` or `flixel help`
* The logo in the header is now printed in color on Linux and Mac
* The missing templates error is no longer printed for commands that don't need them

1.0.5
------------------------------
* Fix the detection of installed haxelibs for Haxe 3.2.0

1.0.4
------------------------------
* Fix line endings in .sh files

1.0.3
------------------------------
* Include default settings
* Fix download in the setup when there's no flixel alias
* Fix the Sublime Text project file on Windows

1.0.2
------------------------------
* Fix Download command to use haxelib install for the new flixel HaxeLibs.
* Author will work in templates specified with ${AUTHOR}
* Restore the build script for linux/mac with .sh file.

1.0.1
------------------------------
* Convert command: Fix FlxG.keys. conversion
* Setup command: Bugfix for entering a name with special chars
* build.bat added
* Compatibilty with latest version of flixel-templates (with "pregenerated" folder)
* Disabled the download command with flixel-demos and flixel-templates being on haxelib

1.0.0
------------------------------
* Initial haxelib release
