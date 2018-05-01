package legacy;

/**
 * Listing for warnings for code to be updated manually for old HaxeFlixel Projects
 */
class Warnings
{
	/**
	 * Simple Map containing the strings to find and warn about
	 * Key being the String to search for
	 * Value being the String info about the solution
	 */
	public static var warningList(get, never):Map<String,String>;

	static function get_warningList():Map<String,String>
	{
		var warningList = new Map<String, String>();

		// Eg;
		// _btnStart.setOnOverCallback(onStartOver);
		// _btnStart.onOver = onStartOver;

		warningList.set(".onOver", ".setOnOverCallback(foo);");
		warningList.set("FlxG.debug", "FlxG.debug has been removed");
		warningList.set("FlxG.mobile", "FlxG.mobile has been removed");

		// FlxSpriteUtil
		warningList.set("drawLine", "FlxSprite.drawLine() has been moved to FlxSpriteUtil.drawLine()");
		warningList.set("drawCircle", "FlxSprite.drawCircle() has been moved to FlxSpriteUtil.drawCircle()");
		warningList.set("fill", "FlxSprite.fill() has been moved to FlxSpriteUtil.fill()");

		warningList.set("FlxGridSprite", "FlxGridSprite has been removed");

		//Find and Replace conflicts with other code such as with FlxPoint.set etc
		warningList.set(".make\\(", "FlxPoint.make() and FlxRect.make() renamed to set()");

		// <haxedef name="FLX_RECORD"/>
		warningList.set("FlxG.vcr", 'Add the FLX_RECORD compiler Variable to your project xml <haxedef name="FLX_RECORD"/>');

		// FlxTimer refactor
		warningList.set("new FlxTimer", "FlxTimer has been refactored and now uses internal pooling. Use FlxTimer.start() to get and start a new FlxTimer");

		warningList.set("flicker\\(", "The flickering logic has been moved from FlxObject to FlxSpriteUtil.flicker()");

		warningList.set("GlitchFX", "GlitchFX has been removed for now");

		warningList.set("FlxG.fullscreen", "FlxG.fullscreen() is now a property. Use FlxG.fullscreen = true; to enable fullscreen mode.");

		return warningList;
	}
}