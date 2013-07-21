package legacy;

/**
 * Listing for Find and Replacements for old HaxeFlixel Projects
 */
class FindAndReplace
{
    /**
     * Simple Map containing the strings to find and replace
     * Key being the String to search for
     * Value being the String to replace it with
     */
    static public var replacements:Array<FindAndReplaceObject>;

    /**
     * Init the replacements map
     * 
     * @return The constructed map
     */
    static public function init():Array<FindAndReplaceObject>
    {
        replacements = new Array<FindAndReplaceObject>();

        /**
         * Removal of the org package
         */

        add("org.flixel.",  "flixel.");

        /**
         * FlxU splitup
         */

        addFunction("FlxU.abs",                 "Math.abs");
        addFunction("FlxU.floor",               "Math.floor");
        addFunction("FlxU.ceil",                "Math.ceil");
        addFunction("FlxU.min",                 "Math.min");
        addFunction("FlxU.max",                 "Math.max");
        addFunction("FlxU.round",               "Std.int");
        addFunction("FlxU.getClass",            "Type.resolveClass");

        addFunction("FlxU.openURL",             "FlxMisc.openURL",                  "util.FlxMisc");
        addFunction("FlxU.getTicks",            "FlxMisc.getTicks",                 "util.FlxMisc");
        addFunction("FlxU.compareClassNames",   "FlxMisc.compareClassNames",        "util.FlxMisc");

        addFunction("FlxU.roundDecimal",        "FlxMath.roundDecimal",             "util.FlxMath");
        addFunction("FlxU.bound",               "FlxMath.bound",                    "util.FlxMath");
        addFunction("FlxU.computeVelocity",     "FlxMath.computeVelocity",          "util.FlxMath");
        addFunction("FlxU.getDistance",         "FlxMath.getDistance",              "util.FlxMath");

        addFunction("FlxU.srand",               "FlxRandom.srand",                  "util.FlxRandom");

        addFunction("FlxU.shuffle",             "FlxArrayUtil.shuffle",             "util.FlxArrayUtil");
        addFunction("FlxU.getRandom",           "FlxArrayUtil.getRandom",           "util.FlxArrayUtil");
        addFunction("FlxU.ArrayIndexOf",        "FlxArrayUtil.indexOf",             "util.FlxArrayUtil");
        addFunction("FlxU.SetArrayLength",      "FlxArrayUtil.setLength",           "util.FlxArrayUtil");

        addFunction("FlxU.formatTicks",         "FlxStringUtil.formatTicks",        "util.FlxStringUtil");
        addFunction("FlxU.formatTime",          "FlxStringUtil.formatTime",         "util.FlxStringUtil");
        addFunction("FlxU.formatArray",         "FlxStringUtil.formatArray",        "util.FlxStringUtil");
        addFunction("FlxU.formatMoney",         "FlxStringUtil.formatMoney",        "util.FlxStringUtil");
        addFunction("FlxU.getClassName",        "FlxStringUtil.getClassName",       "util.FlxStringUtil");

        addFunction("FlxU.makeColor",           "FlxColorUtil.makeFromRGBA",        "util.FlxColorUtil");
        addFunction("FlxU.makeColorFromHSB",    "FlxColorUtil.makeColorFromHSBA",   "util.FlxColorUtil");
        addFunction("FlxU.getRGBA",             "FlxColorUtil.getRGBA",             "util.FlxColorUtil");
        addFunction("FlxU.getHSB",              "FlxColorUtil.getHSBA",             "util.FlxColorUtil");

        addFunction("FlxU.rotatePoint",         "FlxAngle.rotatePoint",             "util.FlxAngle");
        addFunction("FlxU.getAngle",            "FlxAngle.getAngle",                "util.FlxAngle");
        addFunction("FlxU.degreesToRadians",    "FlxAngle.asRadians",               "util.FlxAngle");

        add(        "FlxU.MIN_VALUE",           "FlxMath.MIN_VALUE",                "util.FlxMath");
        add(        "FlxU.MAX_VALUE",           "FlxMath.MAX_VALUE",                "util.FlxMath");

        /**
         * FlxG refactor / frontEnds
         */

        add(        "FlxG.getLibraryName()",    "FlxG.libraryName");

        add(        "FlxG.DEBUGGER_STANDARD",   "FlxDebugger.STANDARD",             "system.FlxDebugger");
        add(        "FlxG.DEBUGGER_MICRO",      "FlxDebugger.MICRO",                "system.FlxDebugger");
        add(        "FlxG.DEBUGGER_BIG",        "FlxDebugger.BIG",                  "system.FlxDebugger");
        add(        "FlxG.DEBUGGER_TOP",        "FlxDebugger.TOP",                  "system.FlxDebugger");
        add(        "FlxG.DEBUGGER_LEFT",       "FlxDebugger.LEFT",                 "system.FlxDebugger");
        add(        "FlxG.DEBUGGER_RIGHT",      "FlxDebugger.RIGHT",                "system.FlxDebugger");

        addFunction("FlxG.random",              "FlxRandom.float",                  "util.FlxRandom");
        addFunction("FlxG.shuffle",             "FlxArrayUtil.shuffle",             "util.FlxRandom");
        addFunction("FlxG.getRandom",           "FlxArrayUtil.getRandom",           "util.FlxRandom");
        addFunction("FlxG.globalSeed",          "FlxRandom.globalSeed",             "util.FlxRandom");

        add(        "FlxG.RED",                 "FlxColor.RED",                     "util.FlxColor");
        add(        "FlxG.GREEN",               "FlxColor.GREEN",                   "util.FlxColor");
        add(        "FlxG.BLUE",                "FlxColor.BLUE",                    "util.FlxColor");
        add(        "FlxG.PINK",                "FlxColor.PINK",                    "util.FlxColor");
        add(        "FlxG.WHITE",               "FlxColor.WHITE",                   "util.FlxColor");
        add(        "FlxG.BLACK",               "FlxColor.BLACK",                   "util.FlxColor" );
        add(        "FlxG.TRANSPARENT",         "FlxColor.TRANSPARENT",             "util.FlxColor");

        add(        "FlxG.DEG",                 "FlxAngle.TO_DEG",                  "util.FlxAngle");
        add(        "FlxG.RAD",                 "FlxAngle.TO_RAD",                  "util.FlxAngle");

        add(        "FlxG.levels",              "Reg.levels");
        add(        "FlxG.level",               "Reg.level");
        add(        "FlxG.scores",              "Reg.scores");
        add(        "FlxG.score",               "Reg.score");
        add(        "FlxG.saves",               "Reg.saves");
        add(        "FlxG.save",                "Reg.save");

        // CameraFrontEnd
        addFunction("FlxG.addCamera",           "FlxG.cameras.add");
        addFunction("FlxG.useBufferLocking",    "FlxG.cameras.useBufferLocking");
        addFunction("FlxG.lockCameras",         "FlxG.cameras.lock");
        addFunction("FlxG.renderCameras",       "FlxG.cameras.render");
        addFunction("FlxG.unlockCameras",       "FlxG.cameras.unlock");
        addFunction("FlxG.addCamera",           "FlxG.cameras.add");
        addFunction("FlxG.removeCamera",        "FlxG.cameras.remove");
        addFunction("FlxG.resetCameras",        "FlxG.cameras.reset");
        addFunction("FlxG.fullscreen",          "FlxG.cameras.fullscreen");

        add(        "FlxG.bgColor",             "FlxG.cameras.bgColor");

        // add("FlxG.cameras", "FlxG.cameras.list");
        // Causes problems in other contexts like;
        // FlxG.cameras.list.add(camera);

        // CameraFXFrontEnd
        addFunction("FlxG.shake",               "FlxG.cameraFX.shake");
        addFunction("FlxG.flash",               "FlxG.cameraFX.flash");
        addFunction("FlxG.fade",                "FlxG.cameraFX.fade");

        // DebuggerFrontEnd
        addFunction("FlxG.setDebuggerLayout",   "FlxG.debugger.setLayout");
        addFunction("FlxG.resetDebuggerLayout", "FlxG.debugger.resetLayout");

        add(        "FlxG.visualDebug",         "FlxG.debugger.visualDebug");
        add(        "FlxG.toggleKeys",          "FlxG.debugger.toggleKeys");

        // LogFrontEnd
        addFunction("FlxG.log",                 "trace");

        addFunction("FlxG.warn",                "FlxG.log.warn");
        addFunction("FlxG.error",               "FlxG.log.error");
        addFunction("FlxG.notice",              "FlxG.log.notice");
        addFunction("FlxG.advancedLog",         "FlxG.log.advanced");
        addFunction("FlxG.clearLog",            "FlxG.log.clear");

        // WatchFrontEnd
        addFunction("FlxG.watch",               "FlxG.watch.add");
        addFunction("FlxG.unwatch",             "FlxG.watch.remove");

        // SoundFrontEnd
        addFunction("FlxG.play",                "FlxG.sound.play");
        addFunction("FlxG.playMusic",           "FlxG.sound.playMusic");
        addFunction("FlxG.loadSound",           "FlxG.sound.load");
        addFunction("FlxG.addSound",            "FlxG.sound.add");
        addFunction("FlxG.stream",              "FlxG.sound.stream");
        addFunction("FlxG.destroySounds",       "FlxG.sound.destroySounds");
        addFunction("FlxG.updateSounds",        "FlxG.sound.updateSounds");
        addFunction("FlxG.pauseSounds",         "FlxG.sound.pauseSounds");
        addFunction("FlxG.resumeSounds",        "FlxG.sound.resumeSounds");

        add(        "FlxG.music",               "FlxG.sound.music");
        add(        "FlxG.sounds",              "FlxG.sound.list");
        add(        "FlxG.mute",                "FlxG.sound.muted");
        add(        "FlxG.volume",              "FlxG.sound.volume");
        add(        "FlxG.volumeHandler",       "FlxG.sound.volumeHandler");
        add(        "FlxG.keyVolumeUp",         "FlxG.sound.keyVolumeUp");
        add(        "FlxG.keyVolumeDown",       "FlxG.sound.keyVolumeDown");
        add(        "FlxG.keyMute",             "FlxG.sound.keyMute");

        // PluginFrontEnd
        addFunction("FlxG.addPlugin",           "FlxG.plugins.add");
        addFunction("FlxG.getPlugin",           "FlxG.plugins.get");
        addFunction("FlxG.removePlugin",        "FlxG.plugins.remove");
        addFunction("FlxG.removePluginType",    "FlxG.plugins.removeType");
        addFunction("FlxG.updatePlugins",       "FlxG.plugins.update");
        addFunction("FlxG.drawPlugins",         "FlxG.plugins.draw");

        add(        "FlxG.plugins",             "FlxG.plugins.list");

        // VCRFrontEnd
        addFunction("FlxG.loadReplay",          "FlxG.vcr.loadReplay");
        addFunction("FlxG.reloadReplay",        "FlxG.vcr.reloadReplay");
        addFunction("FlxG.stopReplay",          "FlxG.vcr.stopReplay");
        addFunction("FlxG.recordReplay",        "FlxG.vcr.startRecording");
        addFunction("FlxG.stopRecording",       "FlxG.vcr.stopRecording");

        // BitmapFrontEnd
        addFunction("FlxG.checkBitmapCache",    "FlxG.bitmap.checkCache");
        addFunction("FlxG.createBitmap",        "FlxG.bitmap.create");
        addFunction("FlxG.addBitmap",           "FlxG.bitmap.add");
        addFunction("FlxG.getCacheKeyFor",      "FlxG.bitmap.getCacheKeyFor");
        addFunction("FlxG.getUniqueBitmapKey",  "FlxG.bitmap.getUniqueKey");
        addFunction("FlxG.removeBitmap",        "FlxG.bitmap.remove");
        addFunction("FlxG.clearBitmapCache",    "FlxG.bitmap.clearCache");
        addFunction("FlxG.clearAssetsCache",    "FlxG.bitmap.clearAssetsCache");

        /**
         * New packages / moved classes
         */

        // system
        addImport("FlxAssets",                                  "system.FlxAssets");
        addImport("FlxSound",                                   "system.FlxSound");

        // ui
        addImport("FlxButton",                                  "ui.FlxButton");

        addImport("plugin.pxText.PxButton",                     "ui.PxButton");
        addImport("plugin.photonstorm.FlxBar",                  "ui.FlxBar");

        // util
        addImport("FlxSave",                                    "util.FlxSave");
        addImport("FlxPath",                                    "util.FlxPath");

        addImport("util.FlxString",                             "util.FlxStringUtil");

        addImport("plugin.photonstorm.FlxColor",                "util.FlxColorUtil");
        addImport("plugin.photonstorm.FlxMath",                 "util.FlxMath");
        addImport("plugin.photonstorm.FlxVelocity",             "util.FlxVelocity");
        addImport("plugin.photonstorm.FlxCoreUtils",            "util.FlxMisc");
        addImport("plugin.photonstorm.FlxGradient",             "util.FlxGradient");
        addImport("plugin.photonstorm.FlxCollision",            "util.FlxCollision");
        addImport("plugin.photonstorm.FlxDisplay",              "util.FlxSpriteUtil");

        // tile
        addImport("FlxTilemap",                                 "tile.FlxTilemap");
        addImport("FlxTileblock",                               "tile.FlxTileblock");

        addImport("system.FlxTile",                             "tile.FlxTile");

        // effects
        addImport("FlxEmitter",                                 "effects.particles.FlxEmitter");
        addImport("FlxEmitter",                                 "effects.particles.FlxEmitter");
        addImport("FlxParticle",                                "effects.particles.FlxParticle");

        addImport("addons.FlxTrail",                            "effects.FlxTrail");
        addImport("addons.FlxEmitterExt",                       "effects.particles.FlxEmitterExt");

        addImport("plugin.photonstorm.FlxSpecialFX",            "effects.FlxSpecialFX");
        addImport("plugin.photonstorm.fx.BaseFX",               "effects.fx.BaseFX");
        addImport("plugin.photonstorm.fx.GlitchFX",             "effects.fx.GlitchFX");
        addImport("plugin.photonstorm.fx.StarfieldFX",          "effects.fx.StarfieldFX");

        // addons
        addImport("addons.FlxCaveGenerator",                    "addons.tile.FlxCaveGenerator");
        addImport("addons.FlxTilemapExt",                       "addons.tile.FlxTilemapExt");
        addImport("addons.FlxSkewedSprite",                     "addons.display.FlxSkewedSprite");
        addImport("addons.FlxBackdrop",                         "addons.display.FlxBackdrop");
        addImport("addons.FlxSpriteAniRot",                     "addons.display.FlxSpriteAniRot");
        addImport("addons.NestedSprite",                        "addons.display.FlxNestedSprite");
        addImport("addons.OgmoLevelLoader",                     "addons.editors.ogmo.FlxOgmoLoader");
        addImport("addons.ZoomCamera",                          "addons.display.FlxZoomCamera");

        addImport("addons.taskManager.AntTask",                 "addons.plugin.taskManger.AntTask");
        addImport("addons.taskManager.AntTaskManager",          "addons.plugin.taskManger.AntTaskManager");

        addImport("plugin.photonstorm.FlxExtendedSprite",       "addons.display.FlxExtendedSprite");
        addImport("plugin.photonstorm.baseTypes.MouseSpring",   "addons.display.FlxMouseSpring");
        addImport("plugin.photonstorm.FlxGridOverlay",          "addons.display.FlxGridOverlay");
        addImport("plugin.photonstorm.api.FlxKongregate",       "addons.api.FlxKongregate");
        addImport("plugin.photonstorm.FlxControl",              "addons.control.FlxControl");
        addImport("plugin.photonstorm.FlxControlHandler",       "addons.control.FlxControlHandler");
        addImport("plugin.photonstorm.FlxWeapon",               "addons.weapon.FlxWeapon");
        addImport("plugin.photonstorm.baseTypes.Bullet",        "addons.weapon.FlxBullet");
        addImport("plugin.photonstorm.FlxMouseControl",         "addons.plugin.FlxMouseControl");
        addImport("plugin.photonstorm.FlxButtonPlus",           "addons.ui.FlxButtonPlus");
        addImport("plugin.photonstorm.FlxDelay",                "addons.util.FlxDelay");
        addImport("plugin.photonstorm.FlxBitmapFont",           "addons.text.FlxBitmapFont");

        addImport("nape.FlxPhysSprite",                         "addons.nape.FlxPhysSprite");
        addImport("nape.FlxPhysState",                          "addons.nape.FlxPhysState");

        // text
        addImport("FlxText",                                    "text.FlxText");
        addImport("FlxTextField",                               "text.FlxTextField");

        addImport("plugin.pxText.PxBitmapFont",                 "text.pxText.PxBitmapFont");
        addImport("plugin.pxText.PxTextAlign",                  "text.pxText.PxTextAlign");
        addImport("plugin.pxText.FlxBitmapTextField",           "text.FlxBitmapTextField");

        // groups
        addImport("FlxGroup",                                   "group.FlxGroup");
        addImport("FlxTypedGroup",                              "group.FlxTypedGroup");

        addImport("addons.FlxSpriteGroup",                      "group.FlxSpriteGroup");

        /**
         * FlxColor renamings
         */

        addFunction("FlxColor.makeFromRGBA",                    "FlxColorUtil.makeFromRGBA");
        addFunction("FlxColor.makeFromHSBA",                    "FlxColorUtil.makeFromHSBA");
        addFunction("FlxColor.getRGBA",                         "FlxColorUtil.getRGBA");
        addFunction("FlxColor.getRGB",                          "FlxColorUtil.getRGBA");
        addFunction("FlxColor.getHSBA",                         "FlxColorUtil.getHSBA");
        addFunction("FlxColor.getAlpha",                        "FlxColorUtil.getAlpha");
        addFunction("FlxColor.getRed",                          "FlxColorUtil.getRed");
        addFunction("FlxColor.getGreen",                        "FlxColorUtil.getGreen");
        addFunction("FlxColor.getBlue",                         "FlxColorUtil.getBlue");
        addFunction("FlxColor.getRandomColor",                  "FlxColorUtil.getRandomColor");
        addFunction("FlxColor.getColor24",                      "FlxColorUtil.getColor24");
        addFunction("FlxColor.getHSVColorWheel",                "FlxColorUtil.getHSVColorWheel");
        addFunction("FlxColor.getComplementHarmony",            "FlxColorUtil.getComplementHarmony");
        addFunction("FlxColor.getAnalogousHarmony",             "FlxColorUtil.getAnalogousHarmony");
        addFunction("FlxColor.getSplitComplementHarmony",       "FlxColorUtil.getSplitComplementHarmony");
        addFunction("FlxColor.getTriadicHarmony",               "FlxColorUtil.getTriadicHarmony");
        addFunction("FlxColor.getColorInfo",                    "FlxColorUtil.getColorInfo");
        addFunction("FlxColor.RGBtoHexString",                  "FlxColorUtil.RGBAtoHexString");
        addFunction("FlxColor.RGBtoWebString",                  "FlxColorUtil.RGBAtoWebString");
        addFunction("FlxColor.HSVtoRGBA",                       "FlxColorUtil.HSVtoRGBA");
        addFunction("FlxColor.RGBtoHSV",                        "FlxColorUtil.RGBtoHSV");
        addFunction("FlxColor.interpolateColor",                "FlxColorUtil.interpolateColor");
        addFunction("FlxColor.interpolateColorWithRGB",         "FlxColorUtil.interpolateColorWithRGB");
        addFunction("FlxColor.interpolateRGB",                  "FlxColorUtil.interpolateRGB");

        /**
         * FlxGame underscore removal
         */

        add("FlxG._game",                       "FlxG.game");

        add("FlxG.game._state",                 "FlxG.game.state");
        add("FlxG.game._inputContainer",        "FlxG.game.inputContainer");
        add("FlxG.game._mark",                  "FlxG.game.mark");
        add("FlxG.game._elapsedMS",             "FlxG.game.elapsedMS");
        add("FlxG.game._step",                  "FlxG.game.stepMS");
        add("FlxG.game._stepSeconds",           "FlxG.game.stepSeconds");
        add("FlxG.game._flashFramerate",        "FlxG.game.flashFramerate");
        add("FlxG.game._maxAccumulation",       "FlxG.game.maxAccumulation");
        add("FlxG.game._requestedState",        "FlxG.game.requestedState");
        add("FlxG.game._requestedReset",        "FlxG.game.requestedReset");
        add("FlxG.game._debugger",              "FlxG.game.debugger");
        add("FlxG.game._debuggerUp",            "FlxG.game.debuggerUp");
        add("FlxG.game._replay",                "FlxG.game.replay");
        add("FlxG.game._recording",             "FlxG.game.recording");
        add("FlxG.game._replayCancelKeys",      "FlxG.game.replayCancelKeys");
        add("FlxG.game._replayTimer",           "FlxG.game.replayTimer");
        add("FlxG.game._replayCallback",        "FlxG.game.replayCallback");

        return replacements;
    }

    /**
     * Shortcut to add a replacement and import validation
     *
     * @param   Find            String to find
     * @param   Replacement     String to replace the string found with
     * @param   ImportValidate  Make sure this import exists
    */
    static public function add(Find:String, Replacement:String, ?ImportValidate:String):Void
    {
		if(ImportValidate!=null)
			ImportValidate = "import flixel." +  ImportValidate;

        var object:FindAndReplaceObject = {
            find: Find,
            replacement: Replacement,
            importValidate: ImportValidate,
        };

        replacements.push(object);
    }

    /**
    * Shortcut to add an import replacement and import validation
    *
    * @param    Find            String to find
    * @param    Replacement     String to replace the string found with
    * @param    ImportValidate  Make sure this import exists
    */
    inline static public function addImport(Find:String, Replacement:String, ?ImportValidate):Void
    {
        Find = "import flixel." + Find;
        Replacement = "import flixel." + Replacement;

        add(Find, Replacement, ImportValidate);
    }

    /**
    * Shortcut to add a function call and import validation
    *
    * @param    Find            String to find
    * @param    Replacement     String to replace the string found with
    * @param    ImportValidate  Make sure this import exists
    */
    inline static public function addFunction(Find:String, Replacement:String, ?ImportValidate):Void
    {
        //Find = Find + "(";
        //Replacement = Replacement + "(";

        add(Find, Replacement, ImportValidate);
    }
}

typedef FindAndReplaceObject = {
    var find:String;
    var replacement:String;
    var importValidate:String;
}