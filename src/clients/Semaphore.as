package clients
{
	import flash.events.EventDispatcher;

	[Event(type="clients.SemaphoreEvent", name="available")]
	[Event(type = "clients.SemaphoreEvent", name = "unavailable")]
	
	public class Semaphore extends EventDispatcher
	{
		protected var myDescription:String;
		protected var myOwner:Object;
		
		public function get description():String {return myDescription;}
		public function get owner():Object {return myOwner;}

		public function Semaphore()
		{
			////trace("Semaphore..............constructor()");
			initialize();
		}
		public function setOwner(owner:Object = null, description:String = null):void
		{
			myOwner = owner;
			myDescription = description;
		}
		protected function initialize():void
		{
			throw new Error("Abstract Method");
		}
		public function get locks():int
		{
			throw new Error("Abstract Method");
			return 0;
		}
		public function get isLocked():Boolean
		{
			throw new Error("Abstract Method");
			return false;
		}
		override public function toString():String
		{
			return "[Semaphore " + owner+" --- "+ description + "]";
		}
	}
}