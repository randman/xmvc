package data 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class ConnectionData extends Data 
	{
		public static const ConnectionID:String = "ConnectionID";
		public static const ConnectionName:String = "ConnectionName";
		public static const ConnectionServer:String = "ConnectionServer";
		public static const ConnectionUser:String = "ConnectionUser";
		public static const ConnectionPassword:String = "ConnectionPassword";
		////////////////////////////////////////////////////////////////
		
		public function ConnectionData() 
		{
			DATA_TYPE = "data.ConnectionData";
			TABLE = "connections";
			PRIMARY = " PRIMARY KEY (ConnectionID))";
			MYKEY = "ConnectionID";
			MYLABEL = "ConnectionName";
			myData = [
				[ConnectionID, INDEX, null, TYPE_READ_ONLY], 
				[ConnectionName, VARCHAR128, null, TYPE_EDIT], 
				[ConnectionServer, VARCHAR128, null, TYPE_EDIT], 
				[ConnectionUser, VARCHAR64, null, TYPE_EDIT],
				[ConnectionPassword,VARCHAR64,null,TYPE_EDIT]
			];
		}
		override public function getSelectWhere():String
		{
			return "SELECT * connections WHERE ConnectionID = ";
		}
	}
}