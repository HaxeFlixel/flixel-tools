#!/bin/sh
# Build for Haxelib on OSX and linux with zip command

haxe build.hxml

zip -x *.git* -r flixel-tools.zip .