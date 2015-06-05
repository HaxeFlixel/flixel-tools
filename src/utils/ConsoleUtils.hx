package utils;

@:enum
abstract Color(Int)
{
	var None = 0;
	var Red = 31;
	var Green = 32;
}

class ConsoleUtils
{
	public static function printWithColor(message:String, color:Color):Void
	{
		setColor(color);
		Sys.println(message);
		setColor(Color.None);
	}
	
	public static function setColor(color:Color):Void
	{
		if (Sys.systemName() == "Linux")
		{
			var id = (color == Color.None) ? "" : ';$color';
			Sys.stderr().writeString("\033[0" + id + "m");
		}
	}
}