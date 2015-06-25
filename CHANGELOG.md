?.?.?
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
* `create` command:
	* don't ask for confirmation for the auto-open in IDE option 
	* minor optimization 
	* demo list now starts 
	* 1, not 0
* The HaxeFlixel header is now only displayed with `flixel` or `flixel help`
* Don't print an error about missing templates for commands that don't need them

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
