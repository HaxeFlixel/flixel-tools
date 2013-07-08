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
	static public var warningList(get, never):Map<String,String>;

	static public function get_warningList():Map<String,String>
	{
        var warningList = new Map<String, String>();
		
        //Eg;
        // _btnStart.setOnOverCallback(onStartOver);
        // _btnStart.onOver = onStartOver;
		
        warningList.set(".onOver", ".setOnOverCallback(foo);");
        
        return warningList;
    }
}