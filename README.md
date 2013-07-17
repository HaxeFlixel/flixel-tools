![](http://www.haxeflixel.com/sites/haxeflixel.com/files/flixel-tools.png)
============
###Related repos: [flixel](https://github.com/HaxeFlixel/flixel) | [flixel-addons](https://github.com/HaxeFlixel/flixel-addons) | [flixel-demos](https://github.com/HaxeFlixel/flixel-demos) | [flixel-ui](https://github.com/HaxeFlixel/flixel-ui)
______________________________________________________
Command line tools for [HaxeFlixel](https://github.com/HaxeFlixel/flixel) to create samples, templates and more.

###Warning: This tool is still in active development

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
flixel create <name>
```

Create a new project from the template (in the current directory):

```batch
flixel template -name <project_name> -class <class_name> -screen <width_value> <height_value>
```

Install the [project template for FlashDevelop](https://github.com/HaxeFlixel/FlashDevelop-Template):


```batch
flixel template flashdevelop-basic
```

List all available projects and demos:

```batch
flixel list
```

List all available demos:

```batch
flixel list demos
```

List all available templates:

```batch
flixel list templates
```

**WIP**

Update old HaxeFlixel projects (version 1.x) to the latest version:

```batch
flixel convert <project directory>
```

Automatically creates a backup.
