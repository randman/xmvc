package components
{
	import data.DataObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	
	public class TouchList extends Sprite
	{
		private var background:Sprite;
		private var base:Sprite;
		private	var myMask:Sprite = null;
		public	var myScroll:BasicScrollbar=null;
		////////////////////////
		public var myWidth:Number;
		public var myHeight:Number;
		////////////////////////////////////
		private var spaceY:Number = 2;
		private var scrollWidth:Number = 0;
		private var totalWidth:Number = 0;
		private var totalHeight:Number = 0;
		////////////////////////////////////
		private var myXSpace:Number;
		private var myYSpace:Number;
		private var parentCallback:Function=null;
		private var myID:String = null;
		private var selectedItem:Number=0;
		private var lastY:Number=0;
	
		public function TouchList(anArray:Array, aCallback:Function, aWidth:Number, aHeight:Number, anID:String) 
		{
			super();
			myID = anID;
			myWidth = aWidth;
			myHeight = aHeight;// -5;
			parentCallback = aCallback;
			background = new Sprite();
			background.graphics.beginFill(0xEFEFEF, .1);
			background.graphics.drawRect(0,0,myWidth,myHeight );
			background.graphics.endFill();
			base = new Sprite();
			addChild(base);
			var itemNum:Number = anArray.length;
			var myX:Number = 0;
			var myY:Number = 0;
			for (var i:int = 0; i < itemNum; i++)
			{
				var myTrans:DataObject = anArray[i];
				var myButton:Button = new Button(myWidth-scrollWidth,myHeight/10, myTrans.label,myTrans.icon,localCallback,i);
				base.addChild(myButton);
				myX = 0;
				myButton.x = myX;
				myButton.y = myY;
				myY += myButton.height+spaceY;
				totalHeight = (myButton.height+spaceY) * (i+1);
				totalWidth = myWidth;
			}
			if (itemNum > 0)
			{
				//localCallback(0);
			}
			createMask();
			addEventListener(TouchEvent.TOUCH_BEGIN, TOUCH_BEGIN);
			addEventListener(TouchEvent.TOUCH_END, TOUCH_END);
			addEventListener(TouchEvent.TOUCH_MOVE, TOUCH_MOVE);
		}
		private function TOUCH_BEGIN(e:TouchEvent):void
		{
			lastY = e.stageY;
		}
		private function TOUCH_END(e:TouchEvent):void
		{
		}
		private function TOUCH_MOVE(e:TouchEvent):void
		{
			var mydiff:Number = e.stageY - lastY;
				base.y -= mydiff;
				if (base.y > 0)
				{
					base.y = 0 
				}
				if (base.y< 0-base.height+myHeight)
				{
					base.y = 0-base.height+myHeight;
				}
				lastY = e.stageY;
		}
		private function createMask():void 
		{
			removeMask();
			myMask= new Sprite()
			myMask.graphics.beginFill(0x000000);
			myMask.graphics.drawRect(0, 0, myWidth-scrollWidth, myHeight);
			myMask.graphics.endFill();
			addChild(myMask);
			base.mask = myMask; 
			if (totalHeight > myHeight)
			{
				//addScroll();
			}
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
				myScroll = new BasicScrollbar(base, myMask,  myMask, false, 4); 
				myScroll.addEventListener(Event.ADDED, scInit); 
				addChild(myScroll); 
				myScroll.x = myMask.width;// +10;
				myScroll.y = 0;
		}
		private function scInit(e:Event):void {
			myScroll.init();
		}
		private function localCallback(anEvent:Number):void 
		{
			selectItem(anEvent);
			if (parentCallback != null)
			{
				parentCallback(anEvent);
			}	
		}
		public function selectItem(anEvent:Number):void 
		{
			var myButton:Button = base.getChildAt(selectedItem) as Button;
			selectedItem = anEvent;
			var myButton2:Button = base.getChildAt(selectedItem) as Button;
		}
		private function removeMask():void
		{
			if (myMask != null)
			{
				removeChild(myMask);
				myMask = null;
			}	
		}
		private function removeList():void
		{
			if (base)
			{
				while (base.numChildren > 0)
				{
					var myButton:Button = base.removeChildAt(0) as Button;
					if (myButton != null)
					{
					myButton.destroyView();
					myButton = null;
					}
				}
				removeChild(base);
				base = null;
			}
		}
		public function destroyView():void
        {
			removeEventListener(TouchEvent.TOUCH_BEGIN, TOUCH_BEGIN);
			removeEventListener(TouchEvent.TOUCH_END, TOUCH_END);
			removeEventListener(TouchEvent.TOUCH_MOVE, TOUCH_MOVE);
			removeMask();
			removeScroll();
			removeList();
		}
	}
}