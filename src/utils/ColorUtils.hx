package utils;

// http://stackoverflow.com/a/5947802/2631715http://stackoverflow.com/a/5947802/2631715
@:enum
abstract Color(Int)
{
	var None = 0;
	var Bold = 1;
	var Black = 30;
	var Red = 31;
	var Green = 32;
	var Yellow = 33;
	var Blue = 34;
	var Purple = 35;
	var Cyan = 36;
	var LightGray = 37;
}

class ColorUtils
{
	public static function println(message:String, color:Color):Void
	{
		setColor(color);
		Sys.println(message);
		setColor(Color.None);
	}
	
	public static function print(message:String, color:Color):Void
	{
		setColor(color);
		Sys.print(message);
		setColor(Color.None);
	}
	
	public static function setColor(color:Color):Void
	{
		if (Sys.systemName() == "Linux")
		{
			var id = (color == Color.None) ? "" : ';$color';
			Sys.print("\033[0" + id + "m");
		}
	}
}