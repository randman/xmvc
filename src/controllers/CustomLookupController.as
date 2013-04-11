package controllers
{
	import controllers.Controller;
	import data.*;
	import models.Model;
	import fl.controls.ComboBox;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class CustomLookupController 
	{
		private var myEnum:String;
		private var myArray:Array;
		private var comboBox:Object;
		private var selectedUUID:String;
		private var model:Model;
		private var controller:Controller;
		private var myCallback:Function;
		
		public function CustomLookupController(anArray:String,aComboBox:Object, aSelectedUUID:String, aCallback:Function):void 
		{
			trace("CustomLookupController ---------------- hello world");
			myEnum = anArray;
			myCallback = aCallback;
			comboBox = aComboBox;
			selectedUUID = aSelectedUUID;
			model = new Model();
			controller = new Controller(model);
			model.addEventListener(Model.GENERIC_DATALIST, gotData);
			controller.getDataList(myEnum);
		}
		public function update(aSelectedUUID:String):void
		{
			var tempArray:Array = myArray;
			for (var i:int = 0; i <tempArray.length; i++)
			{
				var aDataObject:DataObject = tempArray[i];
				if (aDataObject.getPrimaryKeyVal() == aSelectedUUID)
				{
					comboBox.selectedIndex = i;
				}
			}	
		}
		private function gotData(e:Event=null):void
		{
			trace("CustomLookupController - gotData");  
			model.removeEventListener(Model.GENERIC_DATALIST, gotData);
			var xml:XML = model.getGenericData();
			myArray= new BasicEnumData().doparseXMLList(xml, myEnum);
			var greatestLabelLength:int = 0;
			var greatestLabelIdx:int;
			var tempArray:Array = myArray;
			for (var i:int = 0; i <tempArray.length; i++)
			{
				var aDataObject:DataObject = tempArray[i];
				comboBox.addItem( { label: aDataObject.getLabel(), data: aDataObject.getPrimaryKeyVal() } );
				if (aDataObject.getPrimaryKeyVal() == selectedUUID)
				{
					comboBox.selectedIndex = i;
				}
				if (greatestLabelLength < aDataObject.getLabel().length)
				{
					greatestLabelLength = aDataObject.getLabel().length;
					greatestLabelIdx = i;
				}	
			}	
			if (tempArray.length == 1)
			{
				comboBox.selectedIndex = 0;
			}
			comboBox.validateNow();
		}
		private function localCallback():void
		{
			//myCallback(editButton.dataTag);
		}
	}	
}