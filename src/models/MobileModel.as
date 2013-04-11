package models 
{
	import data.ConnectionData;
	import data.DataObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import views.View;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class MobileModel extends Model 
	{
		public static const VIEWSTACK:String = "VIEWSTACK";
		private var _viewStack:Array=[];
		private var _connection:ConnectionData=null;
		private var _formData:DataObject=null;
		public function MobileModel() 
		{
		}
		public function addView(anObject:Array):void 
		{
			_viewStack.push(anObject);
			dispatchEvent(new Event(VIEWSTACK));
		}
		public function getView():View 
		{
			return _viewStack[_viewStack.length-1][0];			
		}
		public function getViewName():String 
		{
			return _viewStack[_viewStack.length-1][1];			
		}
		public function getViewIcons():Array 
		{
			var tempArray:Array = [];
			for (var i:int = 0; i < _viewStack.length; i++)
			{
				var anArray:Array = _viewStack[i];
				if (anArray[2] != null)
				{
					tempArray.push(anArray[2]);
				}
			}
			return tempArray;			
		}
		public function popView():void 
		{
			var myData:Array = _viewStack.pop() as Array;
			var aview:View = myData[0] as View;
			aview.destroyView();
			aview = null;
			dispatchEvent(new Event(VIEWSTACK));		
		}
		
		public function get connection():ConnectionData 
		{
			return _connection;
		}
		
		public function set connection(value:ConnectionData):void 
		{
			_connection = value;
		}
		
		public function get formData():DataObject 
		{
			return _formData;
		}
		
		public function set formData(value:DataObject):void 
		{
			_formData = value;
		}
	}

}