
package ;

class HaxeFlixelLegacy 
{
	public static var findAndReplaceMap(get, null):Map<String,String>;

	public static function get_findAndReplaceMap():Map<String,String>
	{
	    // unable todo
        // _btnStart.setOnOverCallback(onStartOver);
        // _btnStart.onOver = onStartOver;

        var replacements = new Map<String, String>();

        //org package
        replacements.set( "org.flixel.", "flixel." );

        //system
        replacements.set( "flixel.FlxAssets", "flixel.system.FlxAssets" );

        //ui
        replacements.set( "flixel.FlxButton", "flixel.ui.FlxButton" );

        //FlxU

        //FrontEnds

        //Debugger
        replacements.set( "FlxG.watch", "FlxG.watch.add" );

        //cameras
        replacements.set( "FlxG.resetCameras", "FlxG.cameras.reset" );
        replacements.set( "FlxG.shake", "FlxG.camera.shake" );
        replacements.set( "FlxG.flash", "FlxG.camera.flash" );
        replacements.set( "FlxG.fade", "FlxG.camera.fade" );

        //tile
        replacements.set( "flixel.FlxTilemap", "flixel.tile.FlxTilemap" );
        replacements.set( "flixel.system.FlxTile", "flixel.tile.FlxTile" );

        //effects
        replacements.set( "flixel.FlxEmitter", "flixel.effects.particles.FlxEmitter" );
        replacements.set( "flixel.FlxParticle", "flixel.effects.particles.FlxParticle" );
        
        //addons
        replacements.set( "flixel.addons.FlxCaveGenerator", "flixel.addons.tile.FlxCaveGenerator" );
        replacements.set( "flixel.addons.FlxEmitterExt", "flixel.effects.particles.FlxEmitterExt" );
        replacements.set( "flixel.addons.FlxTrail", "flixel.effects.FlxTrail" );

        //photonstorm powertools
        replacements.set( "flixel.plugin.photonstorm.FlxSpecialFX", "flixel.effects.FlxSpecialFX" );
        replacements.set( "flixel.plugin.photonstorm.fx.BaseFX", "flixel.effects.fx.BaseFX" );
        replacements.set( "flixel.plugin.photonstorm.fx.GlitchFX", "flixel.effects.fx.GlitchFX" );
        replacements.set( "flixel.plugin.photonstorm.fx.StarfieldFX", "flixel.effects.fx.StarfieldFX" );

        //text
        replacements.set( "flixel.FlxText", "flixel.text.FlxText" );
        replacements.set( "flixel.FlxTextField", "flixel.text.FlxTextField" );

        //FlxG
        replacements.set( "FlxG.getLibraryName()", "FlxG.libraryName" );
        replacements.set( "FlxG.play", "FlxG.sound.play" );
        replacements.set( "FlxG.playMusic", "FlxG.sound.playMusic" );
        replacements.set( "FlxG.random", "flixel.util.FlxRandom.int" );
        replacements.set( "FlxG.bgColor", "FlxG.state.bgColor" );
        
        //FlxGroups
        replacements.set( "flixel.FlxGroup", "flixel.group.FlxGroup" );
        replacements.set( "flixel.FlxSpriteGroup", "flixel.group.FlxSpriteGroup" );
        replacements.set( "flixel.FlxTypedGroup", "flixel.group.FlxTypedGroup" );

        return replacements;
	}
}