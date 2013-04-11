package views 
{
	import controllers.CustomLookupController;
	import controllers.Controller;
	import data.ConnectionData;
	import data.DataObject;
	import components.Button;
	import components.BasicScrollbar;
	import components.TextDisplayField;
	import components.TextInputField;
	import flash.display.MovieClip;
	import models.MobileModel;
	import models.Model;
	import views.View;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	//import fl.controls.NumericStepper;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class FormTabView extends View 
	{
		private var aTab:XML = null;
		private var myScroll:BasicScrollbar = null;
		private var tabName:String = null;
		private var dsnName:String = null;
		private var elementsXML:XMLList = null;
		private var border:Number=10;
		private var itemWidth:Number=200;
        private var itemHeight:Number = 25;
		private var tabWidth:Number=580;
        private var tabHeight:Number = 550;
		private var myItems:Sprite;
		private	var myMask:Sprite = null;
		private	var myVars:Array = null;
		private	var saveButton:Button = null;
		private	var cancelButton:Button = null;
		private	var _isDirty:Boolean = false;
		//////////////////////////////////////////////////
		
		public function FormTabView(aModel:Model, aController:Controller) 
		{
			trace("FormTabView ----------------TabView");
			super(aModel, aController);
			tabHeight = _stage.stageHeight / 8 * 6;
			var myBG:Sprite = new Sprite();
			myBG.graphics.beginFill(_stage.color, 0);
			myBG.graphics.drawRect(0, 0, tabWidth, tabHeight);
			myBG.graphics.endFill();
			addChild(myBG); 
			myBG.x = border*2;
			myBG.y = border / 2;
			
			myItems = new Sprite();
			addChild(myItems); 
			myItems.x = border*2;
			myItems.y = border;
		}
		public function loadTab(someTab:XML, aWidth:Number = 400):void 
		{
			aTab = someTab;
			drawTab();
		}
		private function drawTab():void 
		{
			trace("load tab here");
			var theX:Number =0;
			var theY:Number = 0;
			tabName = aTab.TabName;
			var aDO:DataObject = MobileModel(model).formData;
			trace(aDO.infoToString());
			myVars = [];
			if (String(aTab.TabType)=="List")
			{
				trace("load tab list");
			}else {
				elementsXML = aTab[0].Element;
				for (var i:int = 0; i <elementsXML.length(); i++)
				{
					var anElement:XML = elementsXML[i];
					var type:String = anElement.Field;
					var value:String = anElement.FieldDefault;
					var name:String = anElement.FieldName;
					var lookup:String = anElement.FieldLookup;
					var min:Number = anElement.FieldRangeMin;
					var max:Number = anElement.FieldRangeMax;
					theX = anElement.FieldX;
					theY = anElement.FieldY;
					var myField:*;
					switch(type)
					{
						case "Label":
							var astr:String= String(value);
							myField = new TextDisplayField(astr);
							break;
						case "Display":
							value = String(aDO.getValue(name));
							myField= new TextDisplayField(value);
							break;	
						case "Input":
							value = String(aDO.getValue(name));
							myField = new TextInputField(value, 30, true, 100);
							myField.setText(value);
							TextInputField(myField).addEventListener(Event.CHANGE, doChange);
							break;
						case "ComboBox":
							value = String(aDO.getValue(name));
							myField = new ComboBox();
							myField.width = 100;
							var customLookupController:CustomLookupController = new CustomLookupController(lookup, myField, value, foo);
							ComboBox(myField).addEventListener(Event.CHANGE, doChange);
							break;
						case "CheckBox":
							myField = new CheckBox();
							CheckBox(myField).selected = Boolean(aDO.getValue(name))
							CheckBox(myField).label = "";
							CheckBox(myField).addEventListener(Event.CHANGE, doChange);
							break;	
					/*	case "NumericStepper":
							myField = new NumericStepper();
							NumericStepper(myField).value = Number(aDO.getValue(name))
							NumericStepper(myField).minimum = min;
							NumericStepper(myField).maximum = max;
							NumericStepper(myField).addEventListener(Event.CHANGE, doChange);
							//CheckBox(myField).label = "";
							break;	*/	
						case "Button":
							myField = new Button(100, 20, value, new MovieClip(), null, -1);// "", "", null, -1, null);
							break;	
						default:
							myField = new TextDisplayField(name);
							myField.error();
							break;
					} 
					myVars.push([type, name, myField]);
					myItems.addChild(myField);
					myField.x = theX;
					myField.y = theY;
				};
				createMask();
			}
		}
		private function foo():void
		{	
		}
		private function createMask():void 
		{
			removeMask();
			if (myMask != null)
			{
				removeChild(myMask);
			}
			myMask= new Sprite()
			myMask.graphics.beginFill(0xFFFFFF);
			myMask.graphics.drawRect(0, 0, tabWidth, tabHeight);
			myMask.graphics.endFill();
			addChild(myMask);
			myItems.mask = myMask; 
			if (myItems.height > tabHeight)
			{
				addScroll();
			}
			addButtons();
		}
		private function removeMask():void
		{
			if (myMask != null)
			{
				myItems.mask = null;
				removeChild(myMask);
				myMask = null;
			}
		}
		private function removeButtons():void
		{
			if (saveButton != null)
			{
				removeChild(saveButton);
				saveButton.destroyView();
				saveButton = null;
			}
			if (cancelButton != null)
			{
				removeChild(cancelButton);
				cancelButton.destroyView();
				cancelButton = null;
			}
		}
		private function addButtons():void
		{
			removeButtons();
			var aDO:DataObject = new ConnectionData();
			//var aNum:Number = Number(aDO.getValue("rms"));
			//if (aNum == 1)
			//{}else{
				saveButton = new Button(_stage.stageWidth/2, _stage.stageHeight/10, "Save", null, doSave, -1);// ("Save", "", "", null, -1, doSave);
				cancelButton = new Button(_stage.stageWidth/2, _stage.stageWidth/10, "Cancel", null, doCancel, -1);//ButtonDialog("Cancel", "", "", null, -1, doCancel);
				addChild(saveButton);
				addChild(cancelButton);
				saveButton.y = _stage.stageHeight/10*4;
				saveButton.x = _stage.stageWidth/2-saveButton.width/2;
				cancelButton.y =(_stage.stageHeight/10*5)+10;
				cancelButton.x = saveButton.x;
				if (_isDirty)
				{
					saveButton.alpha = 1;
					cancelButton.alpha = 1;
				}else{
					saveButton.alpha = .5;
					cancelButton.alpha = .5;
				}
			//}
		}
		private function doChange(e:Event):void
		{
			_isDirty = true;
			addButtons();
		}
		private function doSave():void
		{
			var aDO:DataObject = new ConnectionData();
			trace(aDO.infoToString());
			trace("========================================================================");
			for (var i:int = 0; i <myVars.length; i++)
			{
					var type:String =myVars[i][0];
					var name:String =myVars[i][1];
					var myField:* =myVars[i][2];
					var value:* = null;
					switch(type)
					{
						case "Input":
							value = TextInputField(myField).text;
							break;
						case "ComboBox":
							value = Number(ComboBox(myField).selectedIndex);
							break;
						case "CheckBox":
							value = Number(CheckBox(myField).selected);
							break;	
					//	case "NumericStepper":
					//		value = Number(NumericStepper(myField).value);
					//		break;		
					} 
					aDO.setKeyValue(name, value )
			}
			//trace(aDO.infoToString());
		//	ApplicationModel(model).setListDataObject(aDO);
			controller.postDataItem(aDO.getDataClassDB(), aDO.getPrimaryKeyVal(),aDO.toXML());
			doCancel();
		}
		private function doCancel():void
		{
			_isDirty = false;
			removeItems();
			drawTab();
		}
		private function removeScroll():void
		{
			if (myScroll != null)
			{
				myScroll.removeEventListener(Event.ADDED, scInit); 
				removeChild(myScroll);
				myScroll = null;
			}
		}
		private function addScroll():void
		{
				removeScroll();
				myScroll = new BasicScrollbar(myItems, myMask,  myMask, false, 4); 
				myScroll.addEventListener(Event.ADDED, scInit); 
				addChild(myScroll); 
				myScroll.x = myMask.width;// +10;
				myScroll.y = 0;
		}
		private function removeItems():void 
		{
			myVars = null;
			while (myItems.numChildren > 0)
			{
				var anItem:*= myItems.removeChildAt(0);
				anItem.removeEventListener(Event.CHANGE, doChange);
				anItem = null;
			}
		}
		private function scInit(e:Event):void {
			myScroll.init();
		}
		
		public function get isDirty():Boolean 
		{
			return _isDirty;
		}
		
		public function set isDirty(value:Boolean):void 
		{
			_isDirty = value;
		}
	}
}