package models
{
	
	import data.DataObject;
	import flash.events.Event;
	
	public class FormModel extends Model
	{
		//////////////////////////////////////////////////////////////
		public static const DATA_ENUM:String = "DATA_ENUM";
		public static const DATA_ITEM:String = "DATA_ITEM";
		public static const DATA_LIST:String = "DATA_LIST";
		//////////////////////////////////////////////////////////////
		public static const TIMEOUT_EVENT:String = "TIMEOUT_EVENT";
		public static const ADD_ITEM:String = "ADD_ITEM";
		public static const DELETE_ITEM:String = "DELETE_ITEM";
		public static const TRANSFER_ITEM:String = "TRANSFER_ITEM";
		public static const SELECTED_ITEM:String = "SELECTED_ITEM";
		//////////////////////////////////////////////////////////////
		public static const SORT_ASC:String = "SORT_ASC";
		public static const SORT_DESC:String = "SORT_DESC";
		public static const SORT:String = "SORT";
		public static const ORDER:String = "ORDER";
		public static const SEARCH:String = "SEARCH";
		public static const PRINT:String = "PRINT";
		public static const REFRESH:String = "REFRESH";
		public static const COLUMNS:String = "COLUMNS";
		public static const FILTER:String = "FILTER";
		//////////////////////////////////////////////////////////////
		private var	myDataObject:DataObject=null;
		private var myDataList:Array=[];
		private var dataColumns:Array=[];
		private var dataEnums:Array=[];
		private var selectedColumn:Number = 0;
		private var selectedGridItem:String=null;
		/////////////////////////////////////////////////////////////
		private var currentOrder:String=SORT_ASC;
		private var currentSort:String="";
		private var currentSearch:String="";
		//////////////////////////////////////////////////////////////
		public function FormModel()
		{
			super();
		}
		//////////////////////////////////////////////////////////////
		public function flushDataEnums():void
		{
			dataEnums = [];
		}
		public function setDataEnums(someData:Array):void
		{
			dataEnums.push(someData);	
		}	
		public function enumEvent():void
		{
			dispatchEvent(new Event(DATA_ENUM));		
		}	
		public function doEnumLookup(aCol:String,aVal:String):String
		{
			for (var j:int = 0; j <dataEnums.length; j++)
			{
				var myEnum:Array = dataEnums[j];
				var myLabel:String = myEnum[0];
				if (myLabel == aCol)
				{
					var myEnum2:Array = myEnum[3];
					for (var k:int = 0; k <myEnum2.length; k++)
					{
						var myEnumDO:DataObject = myEnum2[k];
						if (myEnumDO.getPrimaryKeyVal() == aVal)
						{
							aVal = String(myEnumDO.getValue("enumValue"));
						}
					}
				}
			}
			return aVal;
		}
		//////////////////////////////////////////////////////////////
		public function doDateLookup(aCol:String,aVal:String):String
		{
			var myDates:Array = myDataObject.getDateData();
			var myTimes:Array = myDataObject.getTimeData();
			if (myDates != null)
			{
				for (var j:int = 0; j <myDates.length; j++)
				{
					var myLabel:String = myDates[j];
					if (myLabel == aCol)
					{
						var myDate:Date = new Date(Number(aVal) / 1000);
						aVal = myDate.toDateString();
					}
				}
			}
			if (myTimes != null)
			{
				for (var i:int = 0; i <myTimes.length;i++)
				{
					var myLabel2:String = myTimes[i];
					if (myLabel2 == aCol)
					{
						var myDate2:Date = new Date(Number(aVal)*1000);
						aVal = myDate2.toTimeString();
					}
				}
			}
			return aVal;
		}
		public function doDaysLookup(aCol:String,aVal:String):String
		{
			var myDays:Array = myDataObject.getDaysData();
			var daysOfWeek:Array = new Array("Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat");
			if (myDays != null)
			{
				for (var j:int = 0; j <myDays.length; j++)
				{
					var myLabel:String = myDays[j];
					if (myLabel == aCol)
					{
						var myAr:Array = aVal.split(",")
						aVal = "";
						for (var g:int = 0; g <myAr.length; g++)
						{
							var aD:Date = new Date();
							
							aVal += daysOfWeek[myAr[g]] + " ";
						}	
					}
				}
			}
			if (aVal == ""  || aVal == null)
			{
				aVal = "none";
			}
			return aVal;
		}	
		//////////////////////////////////////////////////////////////
		public function getListDataObject():DataObject
		{
			return myDataObject;
		}
		public function setListDataObject(someData:DataObject):void
		{
			myDataObject = someData;
			dispatchEvent(new Event(DATA_ITEM));		
		}	
		//////////////////////////////////////////////////////////////
		public function getData():Array
		{
			return myDataList;
		}
		public function setData(someData:Array):void
		{
			myDataList = someData;
			dispatchEvent(new Event(DATA_LIST));		
		}	
		public function doDataLookup(aCol:String):DataObject
		{
			var aDo:DataObject = null;
			for (var j:int = 0; j <myDataList.length; j++)
				{
					var aDo2:DataObject = myDataList[j]
					if (aDo2.getPrimaryKeyVal() == aCol)
					{
						aDo = aDo2;
						break;
					}
				}
				return aDo;
		}
		//////////////////////////////////////////////////////////////
		public function getCurrentSearch():String
		{
			return currentSearch;
		}
		public function setCurrentSearch(astr:String):void
		{
			currentSearch = astr;
			dispatchEvent(new Event(SEARCH));	
		}
		//////////////////////////////////////////////////////////////
		public function getCurrentSort():String
		{
			return currentSort;
		}
		public function setCurrentSort(astr:String):void
		{
			currentSort = astr;
			dispatchEvent(new Event(SORT));	
		}
		//////////////////////////////////////////////////////////////
		public function getCurrentOrder():String
		{
			return currentOrder;
		}
		public function setCurrentOrder(astr:String):void
		{
			currentOrder = astr;
			dispatchEvent(new Event(ORDER));	
		}
		//////////////////////////////////////////////////////////////
		public function setSelectedGridItem(aNum:String):void
		{
			selectedGridItem = aNum;
			dispatchEvent(new Event(SELECTED_ITEM));	
		}
		public function getSelectedGridItem():String
		{
			return selectedGridItem;
		}
		//////////////////////////////////////////////////////////////
		public function setSelectedColumn(aNum:Number):void
		{
			selectedColumn = aNum;
			dispatchEvent(new Event(FILTER));	
		}
		public function getSelectedColumn():Number
		{
			return selectedColumn;
		}
		//////////////////////////////////////////////////////////////
		public function getColumns():Array
		{
			return myDataObject.getDataGridColums();
		}
		public function getColumnTitle(n:Number):String
		{
			return myDataObject.getTitle(myDataObject.getDataGridColums()[n]);
		}
	}
}