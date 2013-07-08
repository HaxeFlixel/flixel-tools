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
		
		/**
		 * FlxG refactor / frontEnds
		 */
		
        replacements.set("FlxG.getLibraryName()", "FlxG.libraryName");
        replacements.set("FlxG.random", "flixel.util.FlxRandom.float");
		
		// CameraFrontEnd
		replacements.set("FlxG.bgColor", "FlxG.cameras.bgColor");
	 
		// CameraFXFrontEnd
        replacements.set("FlxG.resetCameras", "FlxG.cameras.reset");
        replacements.set("FlxG.shake", "FlxG.camera.shake");
        replacements.set("FlxG.flash", "FlxG.camera.flash");
        replacements.set("FlxG.fade", "FlxG.camera.fade");
		
		// DebuggerFrontEnd
        replacements.set("FlxG.watch", "FlxG.watch.add");
		
		// SoundFrontEnd
		replacements.set("FlxG.play", "FlxG.sound.play");
        replacements.set("FlxG.playMusic", "FlxG.sound.playMusic");
		
		/**
		 * New packages / moved classes
		 */
		
        // system
        replacements.set("flixel.FlxAssets", "flixel.system.FlxAssets");
		
        // ui
        replacements.set("flixel.FlxButton", "flixel.ui.FlxButton");
		replacements.set("flixel.plugin.pxText.PxButton", "flixel.ui.PxButton");
		
		// util
        replacements.set("flixel.FlxSave", "flixel.util.FlxSave");
		
        // tile
        replacements.set("flixel.FlxTilemap", "flixel.tile.FlxTilemap");
        replacements.set("flixel.system.FlxTile", "flixel.tile.FlxTile");
		
        // effects
        replacements.set("flixel.FlxEmitter", "flixel.effects.particles.FlxEmitter");
        replacements.set("flixel.FlxParticle", "flixel.effects.particles.FlxParticle");
		replacements.set("flixel.addons.FlxEmitterExt", "flixel.effects.particles.FlxEmitterExt");
        replacements.set("flixel.addons.FlxTrail", "flixel.effects.FlxTrail");
        
        // addons
        replacements.set("flixel.addons.FlxCaveGenerator", "flixel.addons.tile.FlxCaveGenerator");
		
        // photonstorm
        replacements.set("flixel.plugin.photonstorm.FlxSpecialFX", "flixel.effects.FlxSpecialFX");
        replacements.set("flixel.plugin.photonstorm.fx.BaseFX", "flixel.effects.fx.BaseFX");
        replacements.set("flixel.plugin.photonstorm.fx.GlitchFX", "flixel.effects.fx.GlitchFX");
        replacements.set("flixel.plugin.photonstorm.fx.StarfieldFX", "flixel.effects.fx.StarfieldFX");
		
        // text
        replacements.set("flixel.FlxText", "flixel.text.FlxText");
        replacements.set("flixel.FlxTextField", "flixel.text.FlxTextField");
        replacements.set("flixel.plugin.pxText.PxBitmapFont", "flixel.text.pxText.PxBitmapFont");
        replacements.set("flixel.plugin.pxText.PxTextAlign", "flixel.text.pxText.PxTextAlign");
        
        // groups
        replacements.set("flixel.FlxGroup", "flixel.group.FlxGroup");
        replacements.set("flixel.FlxSpriteGroup", "flixel.group.FlxSpriteGroup");
        replacements.set("flixel.FlxTypedGroup", "flixel.group.FlxTypedGroup");
		
        return replacements;
	}
}