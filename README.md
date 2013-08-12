![](http://www.haxeflixel.com/sites/haxeflixel.com/files/flixel-tools.png)
============
###Related:    [flixel](https://github.com/HaxeFlixel/flixel) | [flixel-addons](https://github.com/HaxeFlixel/flixel-addons) | [flixel-demos](https://github.com/HaxeFlixel/flixel-demos) | [flixel-ui](https://github.com/HaxeFlixel/flixel-ui)
______________________________________________________
Command line tools for [HaxeFlixel](https://github.com/HaxeFlixel/flixel) to create samples, templates and more.

###Warning: This tool is still in active development. 
Feedback and ideas are welcome. Commands are subject to change until a stable version is released.

###Installation:

- You need to make sure you have git installed, [git](http://git-scm.com/download/).

- Please make sure you are also running the latest version of haxelib you can make sure with the command:
```haxelib selfupdate```

####Run the following set of commands to install the tools:

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
- Currently the templates created are only compatible with the latest dev branch of flixel. For flixel 2.x use the command: ```haxelib run flixel new -name <name>```
