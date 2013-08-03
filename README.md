![](http://www.haxeflixel.com/sites/haxeflixel.com/files/flixel-tools.png)
============
###Related:    [flixel](https://github.com/HaxeFlixel/flixel) | [flixel-addons](https://github.com/HaxeFlixel/flixel-addons) | [flixel-demos](https://github.com/HaxeFlixel/flixel-demos) | [flixel-ui](https://github.com/HaxeFlixel/flixel-ui)
______________________________________________________
Command line tools for [HaxeFlixel](https://github.com/HaxeFlixel/flixel) to create samples, templates and more.

###Warning: This tool is still in active development, feedback and ideas are welcome. Commands are subject to change
until a stable version is released.

###Installation

Note: To be able to use the haxelib git command, [git](http://git-scm.com/download/) must be installed.
Run the following set of commands to install the tools:

To clone this repo to your haxelib directory:

```batch
haxelib git flixel-tools https://github.com/HaxeFlixel/flixel-tools.git
```

To set the tools up initially / to be able to use the `flixel` alias in your console:

```batch
haxelib run flixel-tools setup
```

To clone the [flixel-demos](https://github.com/HaxeFlixel/flixel-demos) repo (for demo creation):

```batch
flixel download
```

###Commands

Create a new demo (in the current directory):

```batch
flixel create <name_or_number>
```

If no name or number is given it will list all demos and prompt you for a choice, by number or name.

To create a new default game template use the following, with -n option being the name you want:

```batch
flixel template -n <name>
```

Currently this template is only compatible with the latest dev branch of flixel.
