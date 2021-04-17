package utils;

// http://stackoverflow.com/a/28938235/2631715

@:enum
abstract Color(Int)
{
	final None = 0;
	final Black = 30;
	final Red = 31;
	final Green = 32;
	final Yellow = 33;
	final Blue = 34;
	final Purple = 35;
	final Cyan = 36;
	final White = 37;
}

@:enum
abstract Style(Int)
{
	final Normal = 0;
	final Bold = 1;
	final Underline = 4;
}

class ColorUtils
{
	public static function println(message:String, color:Color, style:Style = Style.Normal)
	{
		Sys.println(setColor(color, style) + message + setColor(Color.None));
	}

	public static function print(message:String, color:Color, style:Style = Style.Normal)
	{
		Sys.print(setColor(color, style) + message + setColor(Color.None));
	}

	public static function setColor(color:Color, style:Style = Style.Normal):String
	{
		if (Sys.systemName() == "Linux" || Sys.systemName() == "Mac")
		{
			final id = (color == Color.None) ? "" : ';$color';
			return "\033[" + style + id + "m";
		}
		return "";
	}
}
