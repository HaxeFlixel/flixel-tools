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
		
		add("org.flixel.", "flixel.");
		
		/**
		 * FlxU splitup
		 */
		
		add("FlxU.openURL", "FlxMisc.openURL", "import flixel.util.FlxMisc");
		add("FlxU.getTicks", "FlxMisc.getTicks", "import flixel.util.FlxMisc");
		add("FlxU.compareClassNames", "FlxMisc.compareClassNames");
		add("FlxU.abs", "Math.abs");
		add("FlxU.floor", "Math.floor");
		add("FlxU.ceil", "Math.ceil");
		add("FlxU.min", "Math.min");
		add("FlxU.max", "Math.max");
		add("FlxU.round", "Std.int");
		add("FlxU.roundDecimal", "FlxMath.roundDecimal");
		add("FlxU.bound", "FlxMath.bound");
		add("FlxU.srand", "FlxRandom.srand", "import flixel.util.FlxRandom");
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
		add("FlxG.random", "FlxRandom.float", "import flixel.util.FlxRandom");
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
		add("FlxG.globalSeed", "FlxRandom.globalSeed", "import flixel.util.FlxRandom");
		
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
		add("FlxG.shake", "FlxG.cameraFX.shake");
		add("FlxG.flash", "FlxG.cameraFX.flash");
		add("FlxG.fade", "FlxG.cameraFX.fade");
		
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
		addImport("FlxAssets", "system.FlxAssets");
		addImport("FlxSound", "system.FlxSound");
		
		// ui
		addImport("FlxButton", "ui.FlxButton");
		
		addImport("plugin.pxText.PxButton", "ui.PxButton");
		addImport("plugin.photonstorm.FlxBar", "ui.FlxBar");
		
		// util
		addImport("FlxSave", "util.FlxSave");
		addImport("FlxPath", "util.FlxPath");
		
		addImport("util.FlxString", "util.FlxStringUtil");
		
		addImport("plugin.photonstorm.FlxColor", "util.FlxColorUtil");
		addImport("plugin.photonstorm.FlxMath", "util.FlxMath");
		addImport("plugin.photonstorm.FlxVelocity", "util.FlxVelocity");
		addImport("plugin.photonstorm.FlxCoreUtils", "util.FlxMisc");
		addImport("plugin.photonstorm.FlxGradient", "util.FlxGradient");
		addImport("plugin.photonstorm.FlxCollision", "util.FlxCollision");
		addImport("plugin.photonstorm.FlxDisplay", "util.FlxSpriteUtil");
		
		// tile
		addImport("FlxTilemap", "tile.FlxTilemap");
		addImport("FlxTileblock", "tile.FlxTileblock");
		
		addImport("system.FlxTile", "tile.FlxTile");
		
		// effects
		addImport("FlxEmitter", "effects.particles.FlxEmitter");
		addImport("FlxEmitter", "effects.particles.FlxEmitter");
		addImport("FlxParticle", "effects.particles.FlxParticle");
		
		addImport("addons.FlxTrail", "effects.FlxTrail");
		addImport("addons.FlxEmitterExt", "effects.particles.FlxEmitterExt");
		
		addImport("plugin.photonstorm.FlxSpecialFX", "effects.FlxSpecialFX");
		addImport("plugin.photonstorm.fx.BaseFX", "effects.fx.BaseFX");
		addImport("plugin.photonstorm.fx.GlitchFX", "effects.fx.GlitchFX");
		addImport("plugin.photonstorm.fx.StarfieldFX", "effects.fx.StarfieldFX");
		
		// addons
		addImport("addons.FlxCaveGenerator", "addons.tile.FlxCaveGenerator");
		addImport("addons.FlxTilemapExt", "addons.tile.FlxTilemapExt");
		addImport("addons.FlxSkewedSprite", "addons.display.FlxSkewedSprite");
		addImport("addons.FlxBackdrop", "addons.display.FlxBackdrop");
		addImport("addons.FlxSpriteAniRot", "addons.display.FlxSpriteAniRot");
		addImport("addons.NestedSprite", "addons.display.FlxNestedSprite");
		addImport("addons.OgmoLevelLoader", "addons.editors.ogmo.FlxOgmoLoader");
		addImport("addons.ZoomCamera", "addons.display.FlxZoomCamera");
		
		addImport("addons.taskManager.AntTask", "addons.plugin.taskManger.AntTask");
		addImport("addons.taskManager.AntTaskManager", "addons.plugin.taskManger.AntTaskManager");
		
		addImport("plugin.photonstorm.FlxExtendedSprite", "addons.display.FlxExtendedSprite");
		addImport("plugin.photonstorm.baseTypes.MouseSpring", "addons.display.FlxMouseSpring");
		addImport("plugin.photonstorm.FlxGridOverlay", "addons.display.FlxGridOverlay");
		addImport("plugin.photonstorm.api.FlxKongregate", "addons.api.FlxKongregate");
		addImport("plugin.photonstorm.FlxControl", "addons.control.FlxControl");
		addImport("plugin.photonstorm.FlxControlHandler", "addons.control.FlxControlHandler");
		addImport("plugin.photonstorm.FlxWeapon", "addons.weapon.FlxWeapon");
		addImport("plugin.photonstorm.baseTypes.Bullet", "addons.weapon.FlxBullet");
		addImport("plugin.photonstorm.FlxMouseControl", "addons.plugin.FlxMouseControl");
		addImport("plugin.photonstorm.FlxButtonPlus", "addons.ui.FlxButtonPlus");
		addImport("plugin.photonstorm.FlxDelay", "addons.util.FlxDelay");
		addImport("plugin.photonstorm.FlxBitmapFont", "addons.text.FlxBitmapFont");
		
		addImport("nape.FlxPhysSprite", "addons.nape.FlxPhysSprite");
		addImport("nape.FlxPhysState", "addons.nape.FlxPhysState");
		
		// text
		addImport("FlxText", "text.FlxText");
		addImport("FlxTextField", "text.FlxTextField");
		
		addImport("plugin.pxText.PxBitmapFont", "text.pxText.PxBitmapFont");
		addImport("plugin.pxText.PxTextAlign", "text.pxText.PxTextAlign");
		addImport("plugin.pxText.FlxBitmapTextField", "text.FlxBitmapTextField");
		
		// groups
		addImport("FlxGroup", "group.FlxGroup");
		addImport("FlxTypedGroup", "group.FlxTypedGroup");
		
		addImport("addons.FlxSpriteGroup", "group.FlxSpriteGroup");
		
		/**
		 * FlxColor renamings
		 */
		
		add("FlxColor.makeFromRGBA", "FlxColorUtil.makeFromRGBA");
		add("FlxColor.makeFromHSBA", "FlxColorUtil.makeFromHSBA");
		add("FlxColor.getRGBA", "FlxColorUtil.getRGBA");
		add("FlxColor.getRGB", "FlxColorUtil.getRGBA");
		add("FlxColor.getHSBA", "FlxColorUtil.getHSBA");
		add("FlxColor.getAlpha", "FlxColorUtil.getAlpha");
		add("FlxColor.getRed", "FlxColorUtil.getRed");
		add("FlxColor.getGreen", "FlxColorUtil.getGreen");
		add("FlxColor.getBlue", "FlxColorUtil.getBlue");
		add("FlxColor.getRandomColor", "FlxColorUtil.getRandomColor");
		add("FlxColor.getColor24", "FlxColorUtil.getColor24");
		add("FlxColor.getHSVColorWheel", "FlxColorUtil.getHSVColorWheel");
		add("FlxColor.getComplementHarmony", "FlxColorUtil.getComplementHarmony");
		add("FlxColor.getAnalogousHarmony", "FlxColorUtil.getAnalogousHarmony");
		add("FlxColor.getSplitComplementHarmony", "FlxColorUtil.getSplitComplementHarmony");
		add("FlxColor.getTriadicHarmony", "FlxColorUtil.getTriadicHarmony");
		add("FlxColor.getColorInfo", "FlxColorUtil.getColorInfo");
		add("FlxColor.RGBtoHexString", "FlxColorUtil.RGBAtoHexString");
		add("FlxColor.RGBtoWebString", "FlxColorUtil.RGBAtoWebString");
		add("FlxColor.HSVtoRGBA", "FlxColorUtil.HSVtoRGBA");
		add("FlxColor.RGBtoHSV", "FlxColorUtil.RGBtoHSV");
		add("FlxColor.interpolateColor", "FlxColorUtil.interpolateColor");
		add("FlxColor.interpolateColorWithRGB", "FlxColorUtil.interpolateColorWithRGB");
		add("FlxColor.interpolateRGB", "FlxColorUtil.interpolateRGB");
		
		/**
		 * FlxGame underscore removal
		 */
			
		add("FlxG._game", "FlxG.game"); 
		
		add("FlxG.game._state", "FlxG.game.state"); 
		add("FlxG.game._inputContainer", "FlxG.game.inputContainer"); 
		add("FlxG.game._mark", "FlxG.game.mark"); 
		add("FlxG.game._elapsedMS", "FlxG.game.elapsedMS"); 
		add("FlxG.game._step", "FlxG.game.stepMS"); 
		add("FlxG.game._stepSeconds", "FlxG.game.stepSeconds"); 
		add("FlxG.game._flashFramerate", "FlxG.game.flashFramerate"); 
		add("FlxG.game._maxAccumulation", "FlxG.game.maxAccumulation"); 
		add("FlxG.game._requestedState", "FlxG.game.requestedState"); 
		add("FlxG.game._requestedReset", "FlxG.game.requestedReset"); 
		add("FlxG.game._debugger", "FlxG.game.debugger"); 
		add("FlxG.game._debuggerUp", "FlxG.game.debuggerUp"); 
		add("FlxG.game._replay", "FlxG.game.replay"); 
		add("FlxG.game._recording", "FlxG.game.recording"); 
		add("FlxG.game._replayCancelKeys", "FlxG.game.replayCancelKeys"); 
		add("FlxG.game._replayTimer", "FlxG.game.replayTimer"); 
		add("FlxG.game._replayCallback", "FlxG.game.replayCallback"); 
	 
		/**
		 * Misc
		 */
		
		// FlxPoint.make() and FlxRect.make() renamed to set()
		add(".make(", ".set(");
		
		return replacements;
	}
	
	/**
	 * Shortcut to add a replacement and import validation
	 *
	 * @param 	Find			String to find
	 * @param 	Replacement		String to replace the string found with
	 * @param 	ImportValidate	[description]
	*/
	static public function add(Find:String, Replacement:String, ?ImportValidate:String):Void
	{
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
	* @param 	Find			String to find
	* @param 	Replacement		String to replace the string found with
	* @param 	ImportValidate	[description]
	*/
	static public function addImport(Find:String, Replacement:String, ?ImportValidate):Void
	{
		Find = "import flixel." + Find;
		Replacement = "import flixel." + Replacement;
		
		add(Find, Replacement, ImportValidate);
	}
}

typedef FindAndReplaceObject = {
    var find:String;
    var replacement:String;
    var importValidate:String;
}
