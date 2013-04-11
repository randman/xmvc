package 
{
	import controllers.MobileController;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.setInterval;
	import models.MobileModel;
	import views.BreadcrumbView;
	import views.MobileView;
	import views.TitleBarView;
	import views.View;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class Main extends Sprite 
	{
		private var model:MobileModel;
		private var view:View=null;
		private var title:TitleBarView=null;
		private var breadcrumb:BreadcrumbView=null;
		private var controller:MobileController;
		private var base:Sprite=null;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging ); 
			stage.addEventListener( StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange ); 
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit); 
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			// entry point
			base = new Sprite();
			addChild(base);
			
			model = new MobileModel();
			model.stage = stage;
			controller = new MobileController(model);
			setInterval(save, 30 * 1000);
			model.addEventListener(MobileModel.VIEWSTACK, addView);
			var mobileView:MobileView = new MobileView(model, controller);
			title = new TitleBarView(model, controller);
			addChild(title);
			breadcrumb = new BreadcrumbView(model, controller);
			addChild(breadcrumb);
			model.addView([mobileView, "MobileView", null]);
		}
		private function _onKeyDown(event:KeyboardEvent):void
        {
            if(event.keyCode == Keyboard.BACK)
            {
                event.preventDefault();
				model.popView();
                trace("\nBack Pressed");
            } else if(event.keyCode == Keyboard.MENU)
            {
                event.preventDefault();
                trace("\nMenu Pressed");
            } else if(event.keyCode == Keyboard.SEARCH)
            {
                event.preventDefault();
                trace("\nSearch Pressed");
            }
        }
		private function onOrientationChanging( event:StageOrientationEvent ):void 
		{ 
			trace("The current orientation is " + event.beforeOrientation + " and is about to change to " + event.afterOrientation ); 
		} 
		private function onOrientationChange( event:StageOrientationEvent ):void 
		{ 
			trace("The orientation was " + event.beforeOrientation + " and is now " + event.afterOrientation ); 
			refresh()
		}
		private function removeView():void 
		{
			if (view != null)
			{
				base.removeChild(view);
			}
		}
		private function refresh():void 
		{
			view.refreshView();
			breadcrumb.refreshView();
			title.refreshView();
		}
		private function addView(e:Event):void 
		{
			removeView();
			view = model.getView();
			base.addChild(view);
			refresh();
		}
		private function deactivate(e:Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		private function save():void 
		{ 
			trace("Save here."); 
		//	modelsave();
		}
		private function onExit(e:Event):void 
		{ 
			save(); 
			removeView();
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGING, onOrientationChanging ); 
			stage.removeEventListener( StageOrientationEvent.ORIENTATION_CHANGE, onOrientationChange ); 
			NativeApplication.nativeApplication.removeEventListener(Event.EXITING, onExit); 
		}
	}
	
}