package views 
{
	import controllers.Controller;
	import data.DataObject;
	import models.Model;
	import components.Button;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author 
	 */
	public class FormView extends View
	{
		
		private var base:Sprite=null
		private var mysize:Boolean = false;
		private var myTextLoader:URLLoader = null;
		private var formXML:XML = null;
		private var tabsXML:XMLList = null;
		private var formName:String = null;
		private var itemWidth:Number=100;
        private var itemHeight:Number = 30;
        private var theY:Number = 70;
        private var activeTab:Number=0;
		private var myTabView:FormTabView=null;
		///////////////////////////////////////
		private var myTabs:Array = [];
		///////////////////////////////////////
		private var mySaveButton:Button = null;
		private var myCancelButton:Button = null;
		public function FormView(aModel:Model, aController:Controller) 
		{
			super(aModel, aController);
		
			base = new Sprite();
			base.graphics.beginFill(_stage.color, 1);
			base.graphics.drawRect(0, 0, _stage.stageWidth , _stage.stageHeight );
			base.graphics.endFill();
			addChild(base); 
			
		}
		public function buildForm(aSaveButton:Button, aCancelButton:Button, anXML:String):void
		{
			mySaveButton = aSaveButton;
			myCancelButton = aCancelButton;
			myTextLoader= new URLLoader();
			myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
			
			try {
				myTextLoader.load(new URLRequest("xml/" + anXML + ".xml"));
			}
			catch (e:Error) {
				myTextLoader.removeEventListener(Event.COMPLETE, onLoaded);
				trace ("Can't find the form: " + e);
			}
		}
		private function onLoaded(e:Event):void
        {
            myTextLoader.removeEventListener(Event.COMPLETE, onLoaded);
			formXML = new XML(e.target.data);
			//trace(formXML);
			//formName = formXML.FormName;
			var MytabsXML:XMLList = formXML.Tabs;
			tabsXML = MytabsXML.Tab;
			var theX:Number = 0;
			var myItemWidth:Number = _stage.stageWidth / tabsXML.length();
			for (var i:int = 0; i <tabsXML.length(); i++)
			{
				var aTab:XML = tabsXML[i];
				var myLabel:String = String(aTab.TabName);
				var _aButton:Button = new Button(myItemWidth,_stage.stageHeight/10, myLabel,new MovieClip(), null, i);
				addChild(_aButton);
				_aButton.x = myItemWidth * i;
				_aButton.y = (_stage.stageHeight / 8);// * (i + 1);
				theX += _aButton.width;
				myTabs.push(_aButton);
				if (tabsXML.length() == 1)
				{
					//_aButton.visible = false;
				}
			};
			tabClicked(0);
        }
		
		private function tabClicked(anID:Number):void
		{
			activeTab = anID;
			for (var i:int = 0; i <myTabs.length; i++)
			{
				var aButton:Button = myTabs[i] as Button;
				aButton.isSelected = false;
				aButton.doMouseout();
			}
				var aButton2:Button = myTabs[anID] as Button;
				aButton2.isSelected = true;
				aButton2.doMouseover();// = true;
				addTab(activeTab);
		}
		private function addTab(i:Number):void
		{
				removeTab();
				var aTab:XML = tabsXML[i];
				myTabView= new FormTabView(model, controller);
				//var aTabView:FormTabView = new FormTabView(model, controller);
				addChild(myTabView);
				myTabView.loadTab(aTab,500);
				myTabView.y = (_stage.stageHeight / 8) * 2;// (itemHeight + theY)2;
			//	myTabs.push([aButton,aTabView]);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function removeTab():void
		{
			if (myTabView != null)
			{
				removeChild(myTabView);
				myTabView.destroyView();
				myTabView = null;
			}
		}
		private function removeBase():void
		{
			if (base != null)
			{
				removeChild(base);
				base = null;
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		override public function destroyView():void
        {
			trace("FormView...............................destroyView");
			removeTab()
			removeBase();
		}
	}
}