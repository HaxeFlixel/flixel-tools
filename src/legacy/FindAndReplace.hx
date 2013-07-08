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
	static public var findAndReplaceMap(get, never):Map<String,String>;

	static public function get_findAndReplaceMap():Map<String,String>
	{
		var replacements = new Map<String, String>();
		
		/**
		 * Removal of the org package
		 */
		
		replacements.set("org.flixel.", "flixel.");
		
		/**
		 * FlxU splitup
		 */
		
		replacements.set("FlxU.openURL", "FlxMisc.openURL");
		replacements.set("FlxU.abs", "Math.abs");
		replacements.set("FlxU.floor", "Math.floor");
		replacements.set("FlxU.ceil", "Math.ceil");
		replacements.set("FlxU.round", "Std.int");
		replacements.set("FlxU.roundDecimal", "FlxMath.roundDecimal");
		replacements.set("FlxU.min", "Math.min");
		replacements.set("FlxU.max", "Math.max");
		replacements.set("FlxU.bound", "FlxMath.bound");
		replacements.set("FlxU.srand", "FlxRandom.srand");
		replacements.set("FlxU.shuffle", "FlxArray.shuffle");
		replacements.set("FlxU.getRandom", "FlxArray.getRandom");
		replacements.set("FlxU.getTicks", "FlxMisc.getTicks");
		replacements.set("FlxU.formatTicks", "FlxStringUtil.formatTicks");
		replacements.set("FlxU.makeColor", "FlxColor.makeFromRGBA");
		replacements.set("FlxU.makeColorFromHSB", "FlxColor.makeColorFromHSBA");
		replacements.set("FlxU.getRGBA", "FlxColor.getRGBA");
		replacements.set("FlxU.getHSB", "FlxColor.getHSBA");
		replacements.set("FlxU.formatTime", "FlxStringUtil.formatTime");
		replacements.set("FlxU.formatArray", "FlxStringUtil.formatArray");
		replacements.set("FlxU.formatMoney", "FlxStringUtil.formatMoney");
		replacements.set("FlxU.getClassName", "FlxStringUtil.getClassName");
		replacements.set("FlxU.compareClassNames", "FlxMisc.compareClassNames");
		replacements.set("FlxU.getClass", "Type.resolveClass");
		replacements.set("FlxU.computeVelocity", "FlxMath.computeVelocity");
		replacements.set("FlxU.rotatePoint", "FlxAngle.rotatePoint");
		replacements.set("FlxU.getAngle", "FlxAngle.getAngle");
		replacements.set("FlxU.degreesToRadians", "FlxAngle.asRadians");
		replacements.set("FlxU.getDistance", "FlxMath.getDistance");
		replacements.set("FlxU.ArrayIndexOf", "FlxArray.indexOf");
		replacements.set("FlxU.SetArrayLength", "FlxArray.setLength");
		replacements.set("FlxU.MIN_VALUE", "FlxMath.MIN_VALUE");
		replacements.set("FlxU.MAX_VALUE", "FlxMath.MAX_VALUE");
		
		/**
		 * FlxG refactor / frontEnds
		 */
		
		replacements.set("FlxG.getLibraryName()", "FlxG.libraryName");
		replacements.set("FlxG.random", "FlxRandom.float");
		replacements.set("FlxG.DEBUGGER_STANDARD", "FlxDebugger.STANDARD");
		replacements.set("FlxG.DEBUGGER_MICRO", "FlxDebugger.MICRO");
		replacements.set("FlxG.DEBUGGER_BIG", "FlxDebugger.BIG");
		replacements.set("FlxG.DEBUGGER_TOP", "FlxDebugger.TOP");
		replacements.set("FlxG.DEBUGGER_LEFT", "FlxDebugger.LEFT");
		replacements.set("FlxG.DEBUGGER_RIGHT", "FlxDebugger.RIGHT");
		replacements.set("FlxG.RED", "FlxColor.RED");
		replacements.set("FlxG.GREEN", "FlxColor.GREEN");
		replacements.set("FlxG.BLUE", "FlxColor.BLUE");
		replacements.set("FlxG.PINK", "FlxColor.PINK");
		replacements.set("FlxG.WHITE", "FlxColor.WHITE");
		replacements.set("FlxG.BLACK", "FlxColor.BLACK");
		replacements.set("FlxG.TRANSPARENT", "FlxColor.TRANSPARENT");
		replacements.set("FlxG.DEG", "FlxAngle.TO_DEG");
		replacements.set("FlxG.RAD", "FlxAngle.TO_RAD");
		replacements.set("FlxG.levels", "Reg.levels");
		replacements.set("FlxG.level", "Reg.level");
		replacements.set("FlxG.scores", "Reg.scores");
		replacements.set("FlxG.score", "Reg.score");
		replacements.set("FlxG.saves", "Reg.saves");
		replacements.set("FlxG.save", "Reg.save");
		replacements.set("FlxG.shuffle", "FlxArray.shuffle");
		replacements.set("FlxG.getRandom", "FlxArray.getRandom");
		replacements.set("FlxG.globalSeed", "FlxRandom.globalSeed");
		
		// CameraFrontEnd
		replacements.set("FlxG.bgColor", "FlxG.cameras.bgColor");
		replacements.set("FlxG.cameras", "FlxG.cameras.list");
		replacements.set("FlxG.useBufferLocking", "FlxG.cameras.useBufferLocking");
		replacements.set("FlxG.lockCameras", "FlxG.cameras.lock");
		replacements.set("FlxG.renderCameras", "FlxG.cameras.render");
		replacements.set("FlxG.unlockCameras", "FlxG.cameras.unlock");
		replacements.set("FlxG.addCamera", "FlxG.cameras.add");
		replacements.set("FlxG.removeCamera", "FlxG.cameras.remove");
		replacements.set("FlxG.resetCameras", "FlxG.cameras.reset");
		replacements.set("FlxG.fullscreen", "FlxG.cameras.fullscreen");
		
		// CameraFXFrontEnd
		replacements.set("FlxG.shake", "FlxG.camera.shake");
		replacements.set("FlxG.flash", "FlxG.camera.flash");
		replacements.set("FlxG.fade", "FlxG.camera.fade");
		
		// DebuggerFrontEnd
		replacements.set("FlxG.visualDebug", "FlxG.debugger.visualDebug");
		replacements.set("FlxG.toggleKeys", "FlxG.debugger.toggleKeys");
		replacements.set("FlxG.setDebuggerLayout", "FlxG.debugger.setLayout");
		replacements.set("FlxG.resetDebuggerLayout", "FlxG.debugger.resetLayout");
		
		// LogFrontEnd
		replacements.set("FlxG.log", "trace");
		replacements.set("FlxG.warn", "FlxG.log.warn");
		replacements.set("FlxG.error", "FlxG.log.error");
		replacements.set("FlxG.notice", "FlxG.log.notice");
		replacements.set("FlxG.advancedLog", "FlxG.log.advanced");
		replacements.set("FlxG.clearLog", "FlxG.log.clear");
		
		// WatchFrontEnd
		replacements.set("FlxG.watch", "FlxG.watch.add");
		replacements.set("FlxG.unwatch", "FlxG.watch.remove");
		
		// SoundFrontEnd
		replacements.set("FlxG.play", "FlxG.sound.play");
		replacements.set("FlxG.playMusic", "FlxG.sound.playMusic");
		replacements.set("FlxG.music", "FlxG.sound.music");
		replacements.set("FlxG.sounds", "FlxG.sound.list");
		replacements.set("FlxG.mute", "FlxG.sound.mute");
		replacements.set("FlxG.volumeHandler", "FlxG.sound.volumeHandler");
		replacements.set("FlxG.keyVolumeUp", "FlxG.sound.keyVolumeUp");
		replacements.set("FlxG.keyVolumeDown", "FlxG.sound.keyVolumeDown");
		replacements.set("FlxG.keyMute", "FlxG.sound.keyMute");
		replacements.set("FlxG.loadSound", "FlxG.sound.load");
		replacements.set("FlxG.addSound", "FlxG.sound.add");
		replacements.set("FlxG.stream", "FlxG.sound.stream");
		replacements.set("FlxG.volume", "FlxG.sound.volume");
		replacements.set("FlxG.destroySounds", "FlxG.sound.destroySounds");
		replacements.set("FlxG.updateSounds", "FlxG.sound.updateSounds");
		replacements.set("FlxG.pauseSounds", "FlxG.sound.pauseSounds");
		replacements.set("FlxG.resumeSounds", "FlxG.sound.resumeSounds");
		
		// PluginFrontEnd
		replacements.set("FlxG.plugins", "FlxG.plugins.list");
		replacements.set("FlxG.addPlugin", "FlxG.plugins.add");
		replacements.set("FlxG.getPlugin", "FlxG.plugins.get");
		replacements.set("FlxG.removePlugin", "FlxG.plugins.remove");
		replacements.set("FlxG.removePluginType", "FlxG.plugins.removeType");
		replacements.set("FlxG.updatePlugins", "FlxG.plugins.update");
		replacements.set("FlxG.drawPlugins", "FlxG.plugins.draw");
		
		// VCRFrontEnd
		replacements.set("FlxG.loadReplay", "FlxG.vcr.loadReplay");
		replacements.set("FlxG.reloadReplay", "FlxG.vcr.reloadReplay");
		replacements.set("FlxG.stopReplay", "FlxG.vcr.stopReplay");
		replacements.set("FlxG.recordReplay", "FlxG.vcr.startRecording");
		replacements.set("FlxG.stopRecording", "FlxG.vcr.stopRecording");
		
		// BitmapFrontEnd
		replacements.set("FlxG.checkBitmapCache", "FlxG.bitmap.checkCache");
		replacements.set("FlxG.createBitmap", "FlxG.bitmap.create");
		replacements.set("FlxG.addBitmap", "FlxG.bitmap.add");
		replacements.set("FlxG.getCacheKeyFor", "FlxG.bitmap.getCacheKeyFor");
		replacements.set("FlxG.getUniqueBitmapKey", "FlxG.bitmap.getUniqueKey");
		replacements.set("FlxG.removeBitmap", "FlxG.bitmap.remove");
		replacements.set("FlxG.clearBitmapCache", "FlxG.bitmap.clearCache");
		replacements.set("FlxG.clearAssetsCache", "FlxG.bitmap.clearAssetsCache");
		
		/**
		 * New packages / moved classes
		 */
		 
		// effects
		replacements.set("import flixel.FlxEmitter", "import flixel.effects.particles.FlxEmitter");
		replacements.set("import flixel.FlxTypedEmitter", "import flixel.effects.particles.FlxTypedEmitter");
		replacements.set("import flixel.FlxParticle", "import flixel.effects.particles.FlxParticle");
		replacements.set("import flixel.addons.FlxEmitterExt", "import flixel.effects.particles.FlxEmitterExt");
		replacements.set("import flixel.addons.FlxTypedEmitterExt", "import flixel.effects.particles.FlxTypedEmitterExt");
		replacements.set("import flixel.addons.FlxTrail", "import flixel.effects.FlxTrail");
		replacements.set("import flixel.plugin.photonstorm.FlxSpecialFX", "import flixel.effects.FlxSpecialFX");
		replacements.set("import flixel.plugin.photonstorm.fx.BaseFX", "import flixel.effects.fx.BaseFX");
		replacements.set("import flixel.plugin.photonstorm.fx.GlitchFX", "import flixel.effects.fx.GlitchFX");
		replacements.set("import flixel.plugin.photonstorm.fx.StarfieldFX", "import flixel.effects.fx.StarfieldFX");
		
		// groups
		replacements.set("import flixel.FlxGroup", "import flixel.group.FlxGroup");
		replacements.set("import flixel.addons.FlxSpriteGroup", "import flixel.group.FlxSpriteGroup");
		replacements.set("import flixel.FlxTypedGroup", "import flixel.group.FlxTypedGroup");
		
		// system
		replacements.set("import flixel.FlxAssets", "import flixel.system.FlxAssets");
		replacements.set("import flixel.FlxSound", "import flixel.system.FlxSound");
		
		// text
		replacements.set("import flixel.FlxText", "import flixel.text.FlxText");
		replacements.set("import flixel.FlxTextField", "import flixel.text.FlxTextField");
		replacements.set("import flixel.plugin.pxText.PxBitmapFont", "import flixel.text.pxText.PxBitmapFont");
		replacements.set("import flixel.plugin.pxText.PxDefaultFontGenerator", "import flixel.text.pxText.PxDefaultFontGenerator");
		replacements.set("import flixel.plugin.pxText.PxFontSymbol", "import flixel.text.pxText.PxFontSymbol");
		replacements.set("import flixel.plugin.pxText.PxTextAlign", "import flixel.text.pxText.PxTextAlign");
		
		// tile
		replacements.set("flixel.system.FlxTile", "flixel.tile.FlxTile");
		replacements.set("flixel.FlxTileblock", "flixel.tile.FlxTileblock");
		replacements.set("flixel.FlxTilemap", "flixel.tile.FlxTilemap");
		replacements.set("flixel.system.FlxTilemapBuffer", "flixel.tile.FlxTilemapBuffer");
		
		// ui
		replacements.set("import flixel.FlxButton", "import flixel.ui.FlxButton");
		replacements.set("import flixel.FlxTypedButton", "import flixel.ui.FlxTypedButton");
		replacements.set("import flixel.plugin.pxText.PxButton", "import flixel.ui.PxButton");
		replacements.set("import flixel.addons.FlxSlider", "import flixel.ui.FlxSlider");
		replacements.set("import flixel.plugin.photonstorm.FlxBar", "import flixel.ui.FlxBar");
		
		// util
		replacements.set("import flixel.FlxSave", "import flixel.util.FlxSave");
		replacements.set("import flixel.FlxPoint", "import flixel.util.FlxPoint");
		replacements.set("import flixel.FlxRect", "import flixel.util.FlxRect");
		replacements.set("import flixel.FlxTimer", "import flixel.util.FlxTimer");
		replacements.set("import flixel.plugin.photonstorm.FlxGradient", "import flixel.util.FlxGradient");
		replacements.set("import flixel.plugin.photonstorm.FlxVelocity", "import flixel.util.FlxVelocity");
		replacements.set("import flixel.plugin.photonstorm.FlxCollision", "import flixel.util.FlxCollision");
		replacements.set("import flixel.plugin.photonstorm.FlxColor", "import flixel.util.FlxColor");
		replacements.set("import flixel.plugin.photonstorm.FlxMath", "import flixel.util.FlxMath");
		
		// addons
		replacements.set("import flixel.addons.FlxCaveGenerator", "import flixel.addons.tile.FlxCaveGenerator");
		replacements.set("import flixel.plugin.photonstorm.api.FlxKongregate", "import flixel.addons.api.FlxKongregate");
		replacements.set("import flixel.plugin.photonstorm.FlxControl", "import flixel.addons.control.FlxControl");
		replacements.set("import flixel.plugin.photonstorm.FlxControlHandler", "import flixel.addons.control.FlxControlHandler");
		replacements.set("import flixel.addons.FlxBackdrop", "import flixel.addons.display.FlxBackdrop");
		replacements.set("import flixel.plugin.photonstorm.FlxExtendedSprite", "import flixel.addons.display.FlxExtendedSprite");
		replacements.set("import flixel.plugin.photonstorm.FlxGridOverlay", "import flixel.addons.display.FlxGridOverlay");
		replacements.set("import flixel.plugin.photonstorm.baseTypes.MouseSpring", "import flixel.addons.display.FlxMouseSpring");
		replacements.set("import flixel.addons.NestedSprite", "import flixel.addons.display.FlxNestedSprite");
		replacements.set("import flixel.addons.FlxSkewedSprite", "import flixel.addons.display.FlxSkewedSprite");
		replacements.set("import flixel.addons.FlxSpriteAniRot", "import flixel.addons.display.FlxSpriteAniRot");
		replacements.set("import flixel.addons.BTNTilemap", "import flixel.addons.tile.FlxRayCastTilemap");
		replacements.set("import flixel.addons.FlxTilemapExt", "import flixel.addons.tile.FlxTilemapExt");
		replacements.set("import flixel.plugin.photonstorm.FlxButtonPlus", "import flixel.addons.ui.FlxButtonPlus");
		replacements.set("import flixel.plugin.photonstorm.FlxDelay", "import flixel.addons.util.FlxDelay");
		replacements.set("import flixel.plugin.photonstorm.FlxWeapon", "import flixel.addons.weapon.FlxWeapon");
		replacements.set("import flixel.plugin.photonstorm.baseTypes.Bullet", "import flixel.addons.weapon.FlxBullet");
		replacements.set("import flixel.plugin.photonstorm.FlxBitmapFont", "import flixel.addons.text.FlxBitmapFont");
		replacements.set("import flixel.addons.ZoomCamera", "import flixel.addons.display.FlxZoomCamera");
		replacements.set("import flixel.addons.OgmoLevelLoader", "import flixel.addons.editors.ogmo.FlxOgmoLoader");
		replacements.set("import flixel.plugin.photonstorm.FlxMouseControl", "import flixel.addons.plugin.FlxMouseControl");
		replacements.set("import flixel.addons.taskManager.AntTask", "import flixel.addons.plugin.taskManager.AntTask");
		replacements.set("import flixel.addons.taskManager.AntTaskManager", "import flixel.addons.plugin.taskManager.AntTaskManager");
		
		/**
		 * FlxSpriteUtil
		 */
		
		replacements.set("FlxDisplay.alphaMask", "FlxSpriteUtil.alphaMask");
		replacements.set("FlxDisplay.alphaMaskFlxSprite", "FlxSpriteUtil.alphaMaskFlxSprite");
		replacements.set("FlxDisplay.screenWrap", "FlxSpriteUtil.screenWrap");
		replacements.set("FlxDisplay.space", "FlxSpriteUtil.space");
		replacements.set("FlxDisplay.screenCenter", "FlxSpriteUtil.screenCenter");
		
		/**
		 * FlxMath (powertools)
		 */
		
		replacements.set("FlxMath.atan2", "Math.atan2");
		replacements.set("FlxMath.sinCosGenerator", "FlxAngle.sinCosGenerator");
		replacements.set("FlxMath.getSinTable()", "FlxAngle.sinTable");
		replacements.set("FlxMath.getCosTable()", "FlxAngle.cosTable");
		replacements.set("FlxMath.sqrt", "Math.sqrt");
		replacements.set("FlxMath.miniRand", "FlxRandom.int");
		replacements.set("FlxMath.rand", "FlxRandom.intRanged");
		replacements.set("FlxMath.randFloat", "FlxRandom.floatRanged");
		replacements.set("FlxMath.chanceRoll", "FlxRandom.chanceRoll");
		replacements.set("FlxMath.randomSign", "FlxRandom.sign");
		replacements.set("FlxMath.angleLimit", "FlxAngle.angleLimit");
		replacements.set("FlxMath.asDegrees", "FlxAngle.asDegrees");
		replacements.set("FlxMath.asRadians", "FlxAngle.asRadians");
		
		return replacements;
	}
}