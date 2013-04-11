package components 
{
	import flash.display.Sprite;
	import flash.events.GestureEvent;
	import flash.events.PressAndTapGestureEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	/*			
		gesturePan 	TransformGestureEvent.GESTURE_PAN 	Moving a point of contact
		gesturePressAndTap 	PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP 	Creating a point of contact and tapping
		gestureRotate 	TransformGestureEvent.GESTURE_ROTATE 	Rotation gesture at a point of contact
		gestureSwipe 	TransformGestureEvent.GESTURE_SWIPE 	Swipe gesture at a point of contact
		gestureTwoFingerTap 	GestureEvent.GESTURE_TWO_FINGER_TAP 	Pressing two points of contact
		gestureZoom 	TransformGestureEvent.GESTURE_ZOOM 	Zoom gesture at a point of contact
		touchBegin 	TouchEvent.TOUCH_BEGIN 	Making first contact with a device
		touchEnd 	TouchEvent.TOUCH_END 	Removing contact with a device
		touchMove 	TouchEvent.TOUCH_MOVE 	Moving the point of contact with a device
		touchOut 	TouchEvent.TOUCH_OUT 	Moving the point of contact away from an instance
		touchOver 	TouchEvent.TOUCH_OVER 	Moving the point of contact over an instance
		touchRollOut 	TouchEvent.TOUCH_ROLL_OUT 	Moving the point of contact away from an instance
		touchRollOver 	TouchEvent.TOUCH_ROLL_OVER 	Moving the point of contact over an instance
		touchTap 	TouchEvent.TOUCH_TAP 	Lifting the point of contact over the same instance
	*/
	public class InputMapper extends Sprite 
	{
		private var aTextField:TextField;
		public function InputMapper() 
		{
			var base:Sprite = new Sprite()
			addChild(base);
			base.graphics.beginFill(0xCCCCCC, 1);
			//base.graphics.drawRect(0,0, _stage.stageWidth/5, _stage.stageHeight / 10);
			base.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			base.graphics.endFill();
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			aTextField = new TextField();
			addChild(aTextField);
			
			
			addEventListener(TransformGestureEvent.GESTURE_PAN, GESTURE_PAN);
			addEventListener(TransformGestureEvent.GESTURE_ROTATE, GESTURE_ROTATE);
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, GESTURE_SWIPE);
			addEventListener(TransformGestureEvent.GESTURE_ZOOM, GESTURE_ZOOM);
			/////
			addEventListener(PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP, GESTURE_PRESS_AND_TAP);
			/////
			addEventListener(GestureEvent.GESTURE_TWO_FINGER_TAP, GESTURE_TWO_FINGER_TAP);
			/////
			addEventListener(TouchEvent.TOUCH_BEGIN, TOUCH_BEGIN);
			addEventListener(TouchEvent.TOUCH_END, TOUCH_END);
			addEventListener(TouchEvent.TOUCH_MOVE, TOUCH_MOVE);
			addEventListener(TouchEvent.TOUCH_OUT, TOUCH_OUT);
			addEventListener(TouchEvent.TOUCH_OVER, TOUCH_OVER);
			addEventListener(TouchEvent.TOUCH_ROLL_OUT, TOUCH_ROLL_OUT);
			addEventListener(TouchEvent.TOUCH_ROLL_OVER, TOUCH_ROLL_OVER);
			addEventListener(TouchEvent.TOUCH_TAP, TOUCH_TAP);
		}
		private function runTrace(aSTr:String):void
		{
			aTextField.text = aSTr;
		}
		private function GESTURE_PAN(e:TransformGestureEvent):void
		{
			runTrace("GESTURE_PAN");
			runTrace(e.toString());
		}
		private function GESTURE_ROTATE(e:TransformGestureEvent):void
		{
			runTrace("GESTURE_ROTATE");
			runTrace(e.toString());
		}
		private function GESTURE_SWIPE(e:TransformGestureEvent):void
		{
			runTrace("GESTURE_SWIPE");
			runTrace(e.toString());
		}
		private function GESTURE_ZOOM(e:TransformGestureEvent):void
		{
			runTrace("GESTURE_ZOOM");
			runTrace(e.toString());
		}
		////
		private function GESTURE_PRESS_AND_TAP(e:PressAndTapGestureEvent):void
		{
			runTrace("GESTURE_PRESS_AND_TAP");
			runTrace(e.toString());
		}
		////
		private function GESTURE_TWO_FINGER_TAP(e:GestureEvent):void
		{
			runTrace("GESTURE_TWO_FINGER_TAP");
			runTrace(e.toString());
		}
		/////////
		private function TOUCH_BEGIN(e:TouchEvent):void
		{
			runTrace("TOUCH_BEGIN");
			runTrace(e.toString());
		}
		private function TOUCH_END(e:TouchEvent):void
		{
			runTrace("TOUCH_END");
			runTrace(e.toString());
		}
		private function TOUCH_MOVE(e:TouchEvent):void
		{
			runTrace("TOUCH_MOVE");
			runTrace(e.toString());
		}
		private function TOUCH_OUT(e:TouchEvent):void
		{
			runTrace("TOUCH_OUT");
			runTrace(e.toString());
		}
		private function TOUCH_OVER(e:TouchEvent):void
		{
			runTrace("TOUCH_OVER");
			runTrace(e.toString());
		}
		private function TOUCH_ROLL_OUT(e:TouchEvent):void
		{
			runTrace("TOUCH_ROLL_OUT");
			runTrace(e.toString());
		}
		private function TOUCH_ROLL_OVER(e:TouchEvent):void
		{
			runTrace("TOUCH_ROLL_OVER");
			runTrace(e.toString());
		}
		private function TOUCH_TAP(e:TouchEvent):void
		{
			runTrace("TOUCH_TAP");
			runTrace(e.toString());
		}
	}

}