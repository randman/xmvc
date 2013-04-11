package models 
{
	import data.DataObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		public static const PERMISSIONS:String = "PERMISSIONS";
		public static const UNLOAD_SITE:String = "UNLOAD_SITE";
		public static const LOGOFF:String = "LOGOFF";
		public static const EVENT_SELECTED:String = "EVENT_SELECTED";
		public static const SERVER_FALLBACK:String = "SERVER_FALLBACK";
		public static const SERVER_ZONE:String = "SERVER_ZONE";
		public static const SERVER_TIME:String = "SERVER_TIME";
		public static const SERVER_PATH:String = "SERVER_PATH";
		public static const READY:String = "READY";
		public static const APPLICATION:String = "APPLICATION";
		public static const GENERIC_DATALIST:String = "GENERIC_DATALIST";
		public static const GENERIC_DATAITEM:String = "GENERIC_DATAITEM";
		public static const ITEM_DELETED:String = "ITEM_DELETED";
		public static const LIST_DELETED:String = "LIST_DELETED";
		public static const ITEM_DELETE_REQUEST:String = "ITEM_DELETE_REQUEST";
		public static const ITEM_ADDED:String = "ITEM_ADDED";
		public static const LIST_ADDED:String = "LIST_ADDED";
		public static const ITEM_ADD_REQUEST:String = "ITEM_ADD_REQUEST";
		public static const ITEM_UPDATED:String = "ITEM_UPDATED";
		public static const LIST_UPDATED:String = "LIST_UPDATED";
		public static const COMMAND_ITEM:String = "COMMAND_ITEM";
		public static const COMMAND_LIST:String = "COMMAND_LIST";
		public static const DATA_ITEM:String = "DATA_ITEM";
		public static const DATA_LIST:String = "DATA_LIST";
		public static const DATA_COUNT:String = "DATA_COUNT"; 
		public static const CONCRETE_DATA_ITEM:String = "CONCRETE_DATA_ITEM";
		public static const RMS_TOKEN_EVENT:String = "RMS_TOKEN_EVENT";
		/////////////////////////////////////////////////////////////////////
		private var _widgetSiteID:String;
		private var _widgetDataID:String;
		private var selectedDataObject:DataObject;
		protected var dataObject:DataObject=null;
		private var dataObjectList:Array= new Array();
		private var myServerPath:String;	
		private var myServerTime:Number;	
		private var myServerZone:Number;	
		private var myServerFallback:Number;	
		private var systemDate:Date;	
		private var myXML:XML;
		private var myXMLItem:XML;
		private var _stage:Stage;
		public static const myRatio:Number=.80;
		//////////////////////////////////////////////////////////////
		public function Model()
		{
			setTimestamp();
		}
		public function setTimestamp():void
		{
			systemDate = new Date();
		}
		public function logoffEvent(e:Event=null):void
		{
			trace("Model.logoffEvent");
			dispatchEvent(new Event(LOGOFF));
		}
		public function unloadEvent():void
		{
			dispatchEvent(new Event(UNLOAD_SITE));
		}
		public function selectEvent():void
		{
			dispatchEvent(new Event(EVENT_SELECTED));
		}
		public function permissions():void
		{
			dispatchEvent(new Event(PERMISSIONS));
		}
		//////////////////////////////////////////////////////////////
		public function readyEvent():void
		{
			dispatchEvent(new Event(READY));
		}
		//////////////////////////////////////////////////////////////
		public function setServerFallback(aNumber:Number):void
		{
			myServerFallback = aNumber;
			dispatchEvent(new Event(SERVER_FALLBACK));
		}
		public function getServerFallback():Number
		{
			return myServerFallback;
		}
		//////////////////////////////////////////////////////////////
		public function setServerZone(aNumber:Number):void
		{
			myServerZone = aNumber;
			dispatchEvent(new Event(SERVER_ZONE));
		}
		public function getServerZone():Number
		{
			return myServerZone;
		}
		//////////////////////////////////////////////////////////////
		public function setServerTime(aNumber:Number):void
		{
			myServerTime = aNumber;
			dispatchEvent(new Event(SERVER_TIME));
		}
		public function getServerTime():Number
		{
			return myServerTime;
		}
		//////////////////////////////////////////////////////////////
		public function setServerPath(aString:String):void
		{
			myServerPath = aString;
			dispatchEvent(new Event(SERVER_PATH));
		}
		public function getServerPath():String
		{
			return myServerPath;
		}
		//////////////////////////////////////////////////////////////
		public function setGenericData(someData:XML):void
		{
			myXML = someData;
			dispatchEvent(new Event(GENERIC_DATALIST));
		}
		public function getGenericData():XML
		{
			return myXML;
			myXML = null;
		}
		//////////////////////////////////////////////////////////////
		public function setDataCount(someData:XML):void
		{
			myXML = someData;
			dispatchEvent(new Event(DATA_COUNT));
		}
		public function getDataCount():XML
		{
			return myXML;
			myXML = null;
		}
		////////////////////////////////////////////////////////////
		public function getDataObject():DataObject
		{
			return dataObject;
		}
		public function setDataObject(someData:DataObject):void
		{
			dataObject = someData;
			dispatchEvent(new Event(DATA_ITEM));
			/*if (someData != null)
			{
				dispatchEvent(new Event(someData.getAS3Class()));	
			}	*/
		}
		public function getDataObjectList():Array
		{
			return dataObjectList;
		}
		public function setDataObjectList(someData:Array):void
		{
			dataObjectList = someData;
			dispatchEvent(new Event(DATA_LIST));
		}
		public function setGenericDataItem(someData:XML):void
		{
			myXMLItem = someData;
			dispatchEvent(new Event(GENERIC_DATAITEM));
		}
		public function getGenericDataItem():XML
		{
			return myXMLItem;
		}
		//////////////////////////////////////////////////////////////
		public function commandItemEvent():void
		{
			dispatchEvent(new Event(COMMAND_ITEM));
		}	
		public function commandListEvent():void
		{
			dispatchEvent(new Event(COMMAND_LIST));
		}	
		//////////////////////////////////////////////////////////////
		public function itemDeletedEvent():void
		{
			dispatchEvent(new Event(ITEM_DELETED));
		}	
		public function itemAddedEvent():void
		{
			dispatchEvent(new Event(ITEM_ADDED));
		}
		public function itemUpdatedEvent():void
		{
			dispatchEvent(new Event(ITEM_UPDATED));
		}
		//////////////////////////////////////////////////////////////
		public function listUpdatedEvent():void
		{
			dispatchEvent(new Event(LIST_UPDATED));
		}
		public function listAddedEvent():void
		{
			dispatchEvent(new Event(LIST_ADDED));
		}
		public function listDeletedEvent():void
		{
			dispatchEvent(new Event(LIST_DELETED));
		}
		public function rmsTokenEvent():void
		{
			dispatchEvent(new Event(RMS_TOKEN_EVENT));
		}
		//////////////////////////////////////////////////////////////
		public function getConcreteDataObject():DataObject
		{
			return selectedDataObject;
		}
		public function setConcreteDataObject(someData:DataObject):void
		{
			selectedDataObject = someData;
			dispatchEvent(new Event(CONCRETE_DATA_ITEM));
		}
		
		public function get widgetDataID():String 
		{
			return _widgetDataID;
		}
		
		public function set widgetDataID(value:String):void 
		{
			_widgetDataID = value;
		}
		
		public function get widgetSiteID():String 
		{
			return _widgetSiteID;
		}
		
		public function set widgetSiteID(value:String):void 
		{
			_widgetSiteID = value;
		}
		
		public function get stage():Stage 
		{
			return _stage;
		}
		
		public function set stage(value:Stage):void 
		{
			_stage = value;
		}
	}
}