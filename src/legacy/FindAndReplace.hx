package legacy;

/**
 * Listing for Find and Replacements for old HaxeFlixel Projects
 */
class FindAndReplace 
{
    public function new():Void {}

    /**
     * Simple Map containing the strings to find and replace
     * Key being the String to search for
     * Value being the String to replace it with
     */
    static public var replacements:Map<String, FindAndReplaceObject>;

    /**
     * Init the replacements map
     * @return the constructed map
     */
    static public function init():Map<String, FindAndReplaceObject>
    {
        replacements = new Map<String, FindAndReplaceObject>();

        /**
         * Removal of the org package
         */
        
        add("org.flixel.", "flixel.");
        
        /**
         * FlxU splitup
         */

        add("FlxU.openURL", "FlxMisc.openURL", "import flixel.util.FlxMisc;");
        add("FlxU.getTicks", "FlxMisc.getTicks", "import flixel.util.FlxMisc;");
        add("FlxU.compareClassNames", "FlxMisc.compareClassNames");
        add("FlxU.abs", "Math.abs");
        add("FlxU.floor", "Math.floor");
        add("FlxU.ceil", "Math.ceil");
        add("FlxU.min", "Math.min");
        add("FlxU.max", "Math.max");
        add("FlxU.round", "Std.int");
        add("FlxU.roundDecimal", "FlxMath.roundDecimal");
        add("FlxU.bound", "FlxMath.bound");
        add("FlxU.srand", "FlxRandom.srand", "import flixel.util.FlxRandom;");
        add("FlxU.shuffle", "FlxArrayUtil.shuffle");
        add("FlxU.getRandom", "FlxArrayUtil.getRandom");
        add("FlxU.formatTicks", "FlxStringUtil.formatTicks");
        add("FlxU.makeColor", "FlxColorUtil.makeFromRGBA");
        add("FlxU.makeColorFromHSB", "FlxColorUtil.makeColorFromHSBA");
        add("FlxU.getRGBA", "FlxColorUtil.getRGBA");
        add("FlxU.getHSB", "FlxColorUtil.getHSBA");
        add("FlxU.formatTime", "FlxStringUtil.formatTime");
        add("FlxU.formatArray", "FlxStringUtil.formatArray");
        add("FlxU.formatMoney", "FlxStringUtil.formatMoney");
        add("FlxU.getClassName", "FlxStringUtil.getClassName");
        add("FlxU.getClass", "Type.resolveClass");
        add("FlxU.computeVelocity", "FlxMath.computeVelocity");
        add("FlxU.rotatePoint", "FlxAngle.rotatePoint");
        add("FlxU.getAngle", "FlxAngle.getAngle");
        add("FlxU.degreesToRadians", "FlxAngle.asRadians");
        add("FlxU.getDistance", "FlxMath.getDistance");
        add("FlxU.ArrayIndexOf", "FlxArrayUtil.indexOf");
        add("FlxU.SetArrayLength", "FlxArrayUtil.setLength");
        add("FlxU.MIN_VALUE", "FlxMath.MIN_VALUE");
        add("FlxU.MAX_VALUE", "FlxMath.MAX_VALUE");
        
        /**
         * FlxG refactor / frontEnds
         */
        
        add("FlxG.getLibraryName()", "FlxG.libraryName");
        add("FlxG.random", "FlxRandom.float", "import flixel.util.FlxRandom;");
        add("FlxG.DEBUGGER_STANDARD", "FlxDebugger.STANDARD");
        add("FlxG.DEBUGGER_MICRO", "FlxDebugger.MICRO");
        add("FlxG.DEBUGGER_BIG", "FlxDebugger.BIG");
        add("FlxG.DEBUGGER_TOP", "FlxDebugger.TOP");
        add("FlxG.DEBUGGER_LEFT", "FlxDebugger.LEFT");
        add("FlxG.DEBUGGER_RIGHT", "FlxDebugger.RIGHT");
        add("FlxG.RED", "FlxColor.RED");
        add("FlxG.GREEN", "FlxColor.GREEN");
        add("FlxG.BLUE", "FlxColor.BLUE");
        add("FlxG.PINK", "FlxColor.PINK");
        add("FlxG.WHITE", "FlxColor.WHITE");
        add("FlxG.BLACK", "FlxColor.BLACK");
        add("FlxG.TRANSPARENT", "FlxColor.TRANSPARENT");
        add("FlxG.DEG", "FlxAngle.TO_DEG");
        add("FlxG.RAD", "FlxAngle.TO_RAD");
        add("FlxG.levels", "Reg.levels");
        add("FlxG.level", "Reg.level");
        add("FlxG.scores", "Reg.scores");
        add("FlxG.score", "Reg.score");
        add("FlxG.saves", "Reg.saves");
        add("FlxG.save", "Reg.save");
        add("FlxG.shuffle", "FlxArrayUtil.shuffle");
        add("FlxG.getRandom", "FlxArrayUtil.getRandom");
        add("FlxG.globalSeed", "FlxRandom.globalSeed", "import flixel.util.FlxRandom;");
        
        // CameraFrontEnd
        add("FlxG.bgColor", "FlxG.state.bgColor");
        add("FlxG.addCamera", "FlxG.cameras.add");
        // add("FlxG.cameras", "FlxG.cameras.list");
        // Causes problems in other contexts like;
        // FlxG.cameras.list.add(camera);
        add("FlxG.useBufferLocking", "FlxG.cameras.useBufferLocking");
        add("FlxG.lockCameras", "FlxG.cameras.lock");
        add("FlxG.renderCameras", "FlxG.cameras.render");
        add("FlxG.unlockCameras", "FlxG.cameras.unlock");
        add("FlxG.addCamera", "FlxG.cameras.add");
        add("FlxG.removeCamera", "FlxG.cameras.remove");
        add("FlxG.resetCameras", "FlxG.cameras.reset");
        add("FlxG.fullscreen", "FlxG.cameras.fullscreen");
     
        // CameraFXFrontEnd
        add("FlxG.shake", "FlxG.camera.shake");
        add("FlxG.flash", "FlxG.camera.flash");
        add("FlxG.fade", "FlxG.camera.fade");
        add("FlxG.camera.flashFramerate", "FlxG.flashFramerate");
        
        // DebuggerFrontEnd
        add("FlxG.visualDebug", "FlxG.debugger.visualDebug");
        add("FlxG.toggleKeys", "FlxG.debugger.toggleKeys");
        add("FlxG.setDebuggerLayout", "FlxG.debugger.setLayout");
        add("FlxG.resetDebuggerLayout", "FlxG.debugger.resetLayout");
        
        // LogFrontEnd
        add("FlxG.log", "trace");
        add("FlxG.warn", "FlxG.log.warn");
        add("FlxG.error", "FlxG.log.error");
        add("FlxG.notice", "FlxG.log.notice");
        add("FlxG.advancedLog", "FlxG.log.advanced");
        add("FlxG.clearLog", "FlxG.log.clear");
        
        // WatchFrontEnd
        add("FlxG.watch", "FlxG.watch.add");
        add("FlxG.unwatch", "FlxG.watch.remove");
        
        // SoundFrontEnd
        add("FlxG.play", "FlxG.sound.play");
        add("FlxG.playMusic", "FlxG.sound.playMusic");
        add("FlxG.music", "FlxG.sound.music");
        add("FlxG.sounds", "FlxG.sound.list");
        add("FlxG.mute", "FlxG.sound.mute");
        add("FlxG.volumeHandler", "FlxG.sound.volumeHandler");
        add("FlxG.keyVolumeUp", "FlxG.sound.keyVolumeUp");
        add("FlxG.keyVolumeDown", "FlxG.sound.keyVolumeDown");
        add("FlxG.keyMute", "FlxG.sound.keyMute");
        add("FlxG.loadSound", "FlxG.sound.load");
        add("FlxG.addSound", "FlxG.sound.add");
        add("FlxG.stream", "FlxG.sound.stream");
        add("FlxG.volume", "FlxG.sound.volume");
        add("FlxG.destroySounds", "FlxG.sound.destroySounds");
        add("FlxG.updateSounds", "FlxG.sound.updateSounds");
        add("FlxG.pauseSounds", "FlxG.sound.pauseSounds");
        add("FlxG.resumeSounds", "FlxG.sound.resumeSounds");
        
        // PluginFrontEnd
        add("FlxG.plugins", "FlxG.plugins.list");
        add("FlxG.addPlugin", "FlxG.plugins.add");
        add("FlxG.getPlugin", "FlxG.plugins.get");
        add("FlxG.removePlugin", "FlxG.plugins.remove");
        add("FlxG.removePluginType", "FlxG.plugins.removeType");
        add("FlxG.updatePlugins", "FlxG.plugins.update");
        add("FlxG.drawPlugins", "FlxG.plugins.draw");
        
        // VCRFrontEnd
        add("FlxG.loadReplay", "FlxG.vcr.loadReplay");
        add("FlxG.reloadReplay", "FlxG.vcr.reloadReplay");
        add("FlxG.stopReplay", "FlxG.vcr.stopReplay");
        add("FlxG.recordReplay", "FlxG.vcr.startRecording");
        add("FlxG.stopRecording", "FlxG.vcr.stopRecording");
        
        // BitmapFrontEnd
        add("FlxG.checkBitmapCache", "FlxG.bitmap.checkCache");
        add("FlxG.createBitmap", "FlxG.bitmap.create");
        add("FlxG.addBitmap", "FlxG.bitmap.add");
        add("FlxG.getCacheKeyFor", "FlxG.bitmap.getCacheKeyFor");
        add("FlxG.getUniqueBitmapKey", "FlxG.bitmap.getUniqueKey");
        add("FlxG.removeBitmap", "FlxG.bitmap.remove");
        add("FlxG.clearBitmapCache", "FlxG.bitmap.clearCache");
        add("FlxG.clearAssetsCache", "FlxG.bitmap.clearAssetsCache");
        
        /**
         * New packages / moved classes
         */
        
        // system
        add("flixel.FlxAssets", "flixel.system.FlxAssets");
        
        // ui
        add("flixel.FlxButton", "flixel.ui.FlxButton");
        add("flixel.plugin.pxText.PxButton", "flixel.ui.PxButton");
        
        // util
        add("flixel.FlxSave", "flixel.util.FlxSave");
        add("flixel.FlxPath", "flixel.util.FlxPath");
        add("FlxColor.makeFromRGBA", "FlxColorUtil.makeFromRGBA")
        add("flixel.util.FlxString", "flixel.util.FlxStringUtil")
        add("FlxString.getClassName", "FlxStringUtil.getClassName")
        
        // tile
        add("flixel.FlxTilemap", "flixel.tile.FlxTilemap");
        add("flixel.system.FlxTile", "flixel.tile.FlxTile");
        add("flixel.FlxTileblock", "flixel.tile.FlxTileblock");
        
        // effects
        add("flixel.FlxEmitter", "flixel.effects.particles.FlxEmitter");
        add("flixel.FlxEmitter", "flixel.effects.particles.FlxEmitter");
        add("flixel.FlxParticle", "flixel.effects.particles.FlxParticle");
        add("flixel.addons.FlxEmitterExt", "flixel.effects.particles.FlxEmitterExt");
        add("flixel.addons.FlxTrail", "flixel.effects.FlxTrail");
        
        // addons
        add("flixel.addons.FlxCaveGenerator", "flixel.addons.tile.FlxCaveGenerator");
        add("flixel.addons.FlxSkewedSprite", "flixel.addons.display.FlxSkewedSprite");
        add("flixel.addons.FlxTilemapExt", "flixel.addons.tile.FlxTilemapExt");
        
        // photonstorm
        add("flixel.plugin.photonstorm.FlxSpecialFX", "flixel.effects.FlxSpecialFX");
        add("flixel.plugin.photonstorm.fx.BaseFX", "flixel.effects.fx.BaseFX");
        add("flixel.plugin.photonstorm.fx.GlitchFX", "flixel.effects.fx.GlitchFX");
        add("flixel.plugin.photonstorm.fx.StarfieldFX", "flixel.effects.fx.StarfieldFX");
        
        // text
        add("flixel.FlxText", "flixel.text.FlxText");
        add("flixel.FlxTextField", "flixel.text.FlxTextField");
        add("flixel.plugin.pxText.PxBitmapFont", "flixel.text.pxText.PxBitmapFont");
        add("flixel.plugin.pxText.PxTextAlign", "flixel.text.pxText.PxTextAlign");
        add("flixel.plugin.pxText.FlxBitmapTextField", "flixel.text.FlxBitmapTextField");
        
        // groups
        add("flixel.FlxGroup", "flixel.group.FlxGroup");
        add("flixel.FlxSpriteGroup", "flixel.group.FlxSpriteGroup");
        add("flixel.FlxTypedGroup", "flixel.group.FlxTypedGroup");
        
        // sounds
        add("flixel.FlxSound", "flixel.system.FlxSound")

        return replacements;
    }

    /**
     * Shortcut to add a replacement and import validation
     * @param Find            [description]
     * @param Replacement     [description]
     * @param ?ImportValidate [description]
     */
    static public function add(Find:String, Replacement:String, ?ImportValidate:String):Void
    {
        var object:FindAndReplaceObject = {
             find: Find,
             replacement: Replacement,
             importValidate: ImportValidate,
        };

        replacements.set (Find,object);
    }

}

typedef FindAndReplaceObject = {
    var find:String;
    var replacement:String;
    var importValidate:String;
}
