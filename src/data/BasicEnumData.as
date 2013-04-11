package data
{
	import data.Data;
	
	import flash.display.MovieClip;

	public class BasicEnumData extends Data
	{
		////////////////////////////////////////////////////////////////
		// Keys
		////////////////////////////////////////////////////////////////
		public static const enumIndex:String = "enumIndex";
		public static const enumValue:String = "enumValue";
		public static const enumOperator:String = "enumOperator";
		
		public function BasicEnumData()
		{
			PRIMARY = enumIndex;
			MYLABEL =  enumValue;
			MYXML_NAMESPACE = MYXMLCLASS + " " + NLSSGateway_NAMESPACE;
			DATA_TYPE = "data.BasicEnumData";
			myData = [
				[enumIndex, ""],  
				[enumValue, ""],
				[enumOperator, ""]
			];
		}
		public function doparseXMLList(anXML:XML, aNode:String):Array
		{
			var myItems:Array = [];
			var new_xml:XML = Data.cleanXML(anXML); 	
			var myDataList:XMLList = new_xml[aNode];	
			var aNum:Number = myDataList.length();
			for (var i:int = 0; i < aNum; i++)
			{
				var xml2:XML = myDataList[i];
				trace(xml2);
				var myDataObject:BasicEnumData = new BasicEnumData();
				myDataObject.fromXML(xml2);
				myItems.push(myDataObject);
			}
			return myItems;
		}
	}
}
