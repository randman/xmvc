package controllers
{
	import clients.REST;
	import clients.SemaphoreEvent;
	import data.DataObject;
	import flash.events.Event;
	import models.Model;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class Controller//
	{
		public static const SPROC:String = "SPROC";
		public static const OPERATOR:String = "OPERATOR";
		public static const OP_NOTEQUALS:String = "NOTEQUALS";
		public static const OP_EQUALS:String = "EQUALS";
		public static const OP_CONTAINS:String = "CONTAINS";
		public static const OP_LIKE:String = "LIKE";
		public static const OP_LT:String = "LT";
		public static const OP_LTE:String = "LTE";
		public static const OP_GT:String = "GT";
		public static const OP_GTE:String = "GTE";
		public static const SORT_ASC:String = "ASC";
		public static const SORT_DESC:String = "DESC";
		public static const KEYWORD:String = "KEYWORD";
		public static const DISTINCT:String = "DISTINCT";
		public static const FIELD:String = "FIELD";
		public static const COUNT:String = "COUNT";
		public static var PostXML :XML = new XML();
		///////////////////Search//////////////
		protected var applicationModel:*;
		protected var restClient:REST; 
		protected var myDataObject:DataObject;
		protected var myDataClass:String;
		protected var myField:String;
		protected var myUUID:String;
		protected var myXML:XML;
		protected var tempPutArray:Array;
		protected var tempPostArray:Array;
		protected var tempDeleteArray:Array;
		protected var myArgs:Array;
		protected var myOrder:String;
		protected var mySort:String;
		protected var myStart:Number;
		protected var myLimit:Number;
		private var myTime:Number=0;
		private var myZone:Number=0;
		

		public function Controller(aModel:Model):void 
		{
			applicationModel = aModel;
			restClient =   new REST();// REST.getInstance();
		}
		public function initialize():void
		{	
			applicationModel.readyEvent();
		}
		/////////////////////////////////////////////////////////////////////
		public function getServerTime():void
		{
			myXML = new XML();
			myDataClass = "DeviceCommands";
			myField = "serverTime";
			sendServerTime();
		}
		private function sendServerTime(event:SemaphoreEvent = null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, sendServerTime);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(sentServerTime);
				restClient.postDataItem(myDataClass, myField, myXML);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, sendServerTime);
			}	
		}
		private function sentServerTime(xml:XML):void
		{
			myTime = Number(xml) * 1000;
			restClient.unlock();
			applicationModel.setServerTime(myTime);
		}
		/////////////////////////////////////////////////////////////////////
		public function getServerZone():void
		{
			myXML = new XML();
			myDataClass = "DeviceCommands";
			myField = "serverTimeZone";
			sendServerZone();
		}
		private function sendServerZone(event:SemaphoreEvent = null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, sendServerZone);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(sentServerZone);
				restClient.postDataItem(myDataClass, myField, myXML);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, sendServerZone);
			}	
		}
		private function sentServerZone(xml:XML):void
		{	
			myZone = Number(xml);
			restClient.unlock();
			applicationModel.setServerZone(myZone);
		}
		/////////////////////////////////////////////////////////////////////
		public function sendMessage(xml:XML):void
		{
			myXML = xml;
			myDataClass = "DeviceCommands";
			myField = "outboundMessage";
			sendGenericMessage();
		}
		private function sendGenericMessage(event:SemaphoreEvent = null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, sendGenericMessage);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(sentGenericMessage);
				restClient.postDataItem(myDataClass, myField, myXML);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, sendGenericMessage);
			}	
		}
		private function sentGenericMessage(xml:XML):void
		{
			restClient.unlock();
			applicationModel.dispatchEvent(new Event("SENT_MESSAGE"));
		}
		/////////////////////////////////////////////////////////////////////
		public function postCommandList(anArray:Array):void
		{
			tempPostArray = [];
			tempPostArray = anArray;
			postCommand();
		}
		private function postCommand():void
		{
			if (tempPostArray.length > 0)
			{
				var aDataObject:XML = tempPostArray.shift();
				applicationModel.addEventListener(Model.COMMAND_ITEM, postedCommand);
				sendCommand(aDataObject);
			}else {	
				tempPostArray = [];
				applicationModel.commandListEvent();
			}
		}
		private function postedCommand(e:Event):void
		{
			applicationModel.removeEventListener(Model.COMMAND_ITEM, postedCommand);
			postCommand();
		}
		public function sendCommand(xml:XML):void
		{
			trace("Controller sendCommand");
			myXML = xml;
			myDataClass = "DeviceCommands";
			myField = "outboundCommand";
			sendGenericCommand();
		}
		private function sendGenericCommand(event:SemaphoreEvent = null):void
		{
			trace("Controller sendGenericCommand");
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, sendGenericCommand);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(sentGenericCommand);
				restClient.sendCommand(myDataClass, myField, myXML);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, sendGenericCommand);
			}	
		}
		private function sentGenericCommand(xml:XML):void
		{
			trace("Controller sentGenericCommand");
			restClient.unlock();
			applicationModel.commandItemEvent();
		}
		/////////////////////////////////////////////////////////////////////
		public function getDataItem(aDataClass:String,anArg:String, aUUID:String):void
		{
			myDataClass = aDataClass;
			myField = anArg;
			myUUID = aUUID;
			getGenericDataItem();
		}
		private function getGenericDataItem(event:SemaphoreEvent = null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, getGenericDataItem);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(gotGenericDataItem);
				restClient.getDataItem(myDataClass, myField, myUUID);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, getGenericDataItem);
			}	
		}
		private function gotGenericDataItem(xml:XML):void
		{
			restClient.unlock();
			applicationModel.setGenericDataItem(xml);
		}
		/////////////////////////////////////////////////////////////////////
		public function getDataList(aDataClass:String):void
		{
			myDataClass = aDataClass;
			getGenericDataList();
		}
		private function getGenericDataList(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, getGenericDataList);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(gotGenericDataList);
				restClient.getDataList(myDataClass);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, getGenericDataList);
			}	
		}
		private function gotGenericDataList(xml:XML):void
		{
			restClient.unlock();
			applicationModel.setGenericData(xml);
		}
		/////////////////////////////////////////////////////////////////////
		public function getDataListSearch(aDataClass:String, anArg:Array, aOrder:String=null, aSort:String=null, aStart:Number=0, aRowNum:Number=0):void
		{
			myDataClass = aDataClass;
			myArgs = anArg;
			myOrder=aOrder;
			mySort=aSort;
			myStart=aStart;
			myLimit=aRowNum;
			getGenericDataListSearch();
		}
		private function getGenericDataListSearch(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, getGenericDataListSearch);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(gotGenericDataListSearch);
				restClient.searchDataList(myDataClass, myArgs, myOrder, mySort, myStart, myLimit)
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, getGenericDataListSearch);
			}	
		}
		private function gotGenericDataListSearch(xml:XML):void
		{
			restClient.unlock();
			applicationModel.setGenericData(xml);
		}
		/////////////////////////////////////////////////////////////////////
		public function getDataListWhere(aDataClass:String, anArg:String, aUUID:String):void
		{
			myDataClass = aDataClass;
			myField = anArg;
			myUUID = aUUID;
			getGenericDataListWhere();
		}
		private function getGenericDataListWhere(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, getGenericDataListWhere);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(gotGenericDataListWhere);
				restClient.getDataListWhere(myDataClass, myField, myUUID);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, getGenericDataListWhere);
			}	
		}
		private function gotGenericDataListWhere(xml:XML):void
		{
			restClient.unlock();
			applicationModel.setGenericData(xml);
		}
		/////////////////////////////////////////////////////////////////////
		public function postDataItem(aDataClass:String, aUUID:String, aXML:XML):void
		{
			myDataClass = aDataClass;
			myUUID = aUUID;
			myXML = aXML;
			postGenericDataItem();
		}
		private function postGenericDataItem(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, postGenericDataItem);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(postedGenericDataItem);
				restClient.postDataItem(myDataClass, myUUID, myXML);
			}
			else 
			{
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, postGenericDataItem);
			}	
		}
		private function postedGenericDataItem(xml:XML):void
		{
			restClient.unlock();
			PostXML = xml;
			applicationModel.itemUpdatedEvent();	
		}
		/////////////////////////////////////////////////////////////////////
		public function putDataItem(aDataClass:String, aUUID:String, aXML:XML):void
		{
			
			myDataClass = aDataClass;
			myUUID = aUUID;
			myXML = aXML;
			putGenericDataItem();
		}
		private function putGenericDataItem(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, putGenericDataItem);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(addedGenericDataItem);
				restClient.putDataItem(myDataClass, myUUID, myXML);
			}
			else 
			{
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, putGenericDataItem);
			}	
		}
		private function addedGenericDataItem(xml:XML):void
		{
			restClient.unlock();
			applicationModel.itemAddedEvent();
		}
		/////////////////////////////////////////////////////////////////////
		
		public function deleteDataItem(aDataClass:String, aUUID:String):void
		{
			myDataClass = aDataClass;
			myUUID = aUUID;
			deleteGenericDataItem();
		}
		private function deleteGenericDataItem(event:SemaphoreEvent=null):void
		{
			if (!restClient.isLocked)
			{
				restClient.removeEventListener(SemaphoreEvent.AVAILABLE, deleteGenericDataItem);
				restClient.setOwner(this, "ApplicationController");
				restClient.lock();
				restClient.setCallback(deletedGenericDataItem);
				restClient.deleteDataItem(myDataClass, myUUID);
			}else {
				restClient.addEventListener(SemaphoreEvent.AVAILABLE, deleteGenericDataItem);
			}	
		}
		private function deletedGenericDataItem(xml:XML):void
		{
			restClient.unlock();
			applicationModel.itemDeletedEvent();
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function putDataList(anArray:Array):void
		{
			tempPutArray = [];
			tempPutArray = anArray;
			putArray();
		}
		private function putArray():void
		{
			if (tempPutArray.length > 0)
			{
				var aDataObject:DataObject = tempPutArray.shift();
				Model(applicationModel).addEventListener(Model.ITEM_ADDED, wrotePutArrayItem);
				putDataItem(aDataObject.getDataClassDB(), String(aDataObject.getValue(aDataObject.getPrimaryKey())), aDataObject.toXML());
			}else {	
				tempPutArray = [];
				Model(applicationModel).listAddedEvent();
			}	
		}
		private function wrotePutArrayItem(e:Event):void
		{
			Model(applicationModel).removeEventListener(Model.ITEM_ADDED, wrotePutArrayItem);
			putArray();
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function postDataList(anArray:Array):void
		{
			tempPostArray = [];
			tempPostArray = anArray;
			postArray();
		}
		private function postArray():void
		{
			if (tempPostArray.length > 0)
			{
				var aDataObject:DataObject = tempPostArray.shift();
				applicationModel.addEventListener(Model.ITEM_UPDATED, wrotePostArrayItem);
				postDataItem(aDataObject.getDataClassDB(), String(aDataObject.getValue(aDataObject.getPrimaryKey())), aDataObject.toXML());
			}else {	
				tempPostArray = [];
				applicationModel.listUpdatedEvent();
			}
		}
		private function wrotePostArrayItem(e:Event):void
		{
			applicationModel.removeEventListener(Model.ITEM_UPDATED, wrotePostArrayItem);
			postArray();
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function deleteDataList(anArray:Array):void
		{
			tempDeleteArray = [];
			tempDeleteArray = anArray;
			deleteArray();
		}
		private function deleteArray():void
		{
			if (tempDeleteArray.length > 0)
			{
				var aDataObject:DataObject = tempDeleteArray.shift();
				applicationModel.addEventListener(Model.ITEM_DELETED, wroteDeleteArrayItem);
				deleteDataItem(aDataObject.getDataClassDB(), String(aDataObject.getValue(aDataObject.getPrimaryKey())));
			}else 
			{	
				tempDeleteArray = [];
				applicationModel.listDeletedEvent();
			}
		}
		private function wroteDeleteArrayItem(e:Event):void
		{
			applicationModel.removeEventListener(Model.ITEM_DELETED, wroteDeleteArrayItem);
			deleteArray();
		}
	}
}