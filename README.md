flixel-tools
============

Command Line tools for [HaxeFlixel](https://github.com/HaxeFlixel/flixel), create samples, templates and more.

###Warning: This tool still in active development

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
To clone the [flixel-samples](https://github.com/HaxeFlixel/flixel-samples) repo (for sample creation):

```batch
flixel download
```

####Commands

Create a new sample (in the current directory):

```batch
flixel create <name>
```

Create a new project from the template (in the current directory):

```batch
flixel new -name <project_name> -class <class_name> -screen <width_value> <height_value>
```

Install the project template for FlashDevelop:


```batch
flixel new flashdevelop-basic
```

List all available projects and samples:

```batch
flixel list
```

List all available samples:

```batch
flixel list samples
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