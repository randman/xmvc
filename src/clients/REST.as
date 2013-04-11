package  clients
{
	/**
	 * ...
	 * @author Rand Anderson
	 */
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.xml.*;

	public class REST extends Semaphore
	{
		public static const REST_CONNECTED:String = "REST_CONNECTED";
		public static const MODE_HTTP:String = "MODE_HTTP";
		private var currentMODE:String = MODE_HTTP;
		private var myserver:String = "";
		////////////////////////////////////////////////////
		public static const GET:String = "GET";
		public static const POST:String = "POST";
		public static const PUT:String = "PUT";
		public static const DELETE:String = "DELETE";
		////////////////////////////////////////////////////////////
		public static const ORDER:String = "ORDER";
		public static const SORT:String = "SORT";
		public static const START:String = "START";
		public static const LIMIT:String = "LIMIT";
		////////////////////////////////////////////////////////////
		private static var _instance:REST;
		private var urlLoader:URLLoader;
		private var gateway:String = "";
		private var contentType:String = "application/x-www-form-urlencoded";
		private var xmlHeader:String = '<?xml version="1.0" encoding="UTF-8"?>';
		private var callback:Function;
		private var cookieString:String = "";
		private var hashString:String = "/";
		protected var _locks:int = 0;
		////////////////////////////////////////////////////////////////////////////////
		public function REST() 
		{
			trace("Instantiating REST");
		}
		public static function getInstance():REST
		{
			trace("getInstance REST");
			if (_instance == null)
			{
			_instance = new REST();
			}
			return _instance;
		}
		public function setGateway(aStr:String):void 
		{
			gateway = aStr;
		}	
		public function setCallback(aCallback:Function):void
		{
			callback = aCallback;
		}
		//////////////////////////////////////////////////////////////////////////////
		public function sendCommand(aString:String, aUUID:String, anXML:XML):void 
		{		
			var requestString:String = gateway;
			var request:URLRequest = new URLRequest(requestString);			
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = POST;
			requestVars.service = aString;
			requestVars.uuid = aUUID;
			requestVars.requestXML = anXML;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		//////////////////////////////////////////////////////////////////////////////
		public function searchDataList(aString:String, anArgArray:Array, aOrder:String=null, aSort:String=null, aStart:Number=0, aRowNum:Number=0):void 
		{		
			var tempString:String = "";
			for (var i:int = 0; i < anArgArray.length; i++)
			{
				var myArgs:Array = anArgArray[i];
				tempString += myArgs[0] + hashString+myArgs[1]+hashString;
			}
			if (aOrder != null)
			{
				tempString += ORDER + hashString + aOrder+hashString;
			}
			if (aSort != null)
			{
				tempString += SORT + hashString + aSort+hashString;
			}
			if (aStart != 0)
			{
				tempString += START + hashString + aStart+hashString;
			}
			if (aRowNum != 0)
			{
				tempString += LIMIT + hashString + aRowNum+hashString;
			}
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);		
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = GET;
			requestVars.service = aString;
			requestVars.argList = tempString;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function getDataList(aString:String):void 
		{		
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);		
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = GET;
			requestVars.service = aString;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function getDataListWhere(aString:String, anArg:String, aUUID:String):void 
		{		
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);		
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = GET;
			requestVars.service = aString;
			requestVars.key = anArg;
			requestVars.uuid = aUUID;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function getDataItem(aString:String, anArg:String, aUUID:String):void 
		{	
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);			
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = GET;
			requestVars.service = aString;
			requestVars.key = anArg;
			requestVars.uuid = aUUID;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function putDataItem(aString:String, aUUID:String, anXML:XML):void 
		{		
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);					
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = PUT;
			requestVars.service = aString;
			requestVars.uuid = aUUID;
			requestVars.requestXML = anXML;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function postDataItem(aString:String, aUUID:String, anXML:XML, param:String=null):void 
		{		
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);			
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = POST;
			requestVars.service = aString;
			if(param == null){
				requestVars.uuid = aUUID;
			}else{
				requestVars.uuid = String(aUUID+"/"+param);
			}
			requestVars.requestXML = anXML;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		public function deleteDataItem(aString:String, aUUID:String):void 
		{	
			var requestString:String = gateway;// + "?time=" + new Date().toUTCString();
			var request:URLRequest = new URLRequest(requestString);					
			var requestVars:URLVariables = new URLVariables();
			requestVars.method = DELETE;
			requestVars.service = aString;
			requestVars.uuid = aUUID;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			request.contentType = contentType;
			urlLoader = new URLLoader();
			runRequest(requestVars.toString(), request);
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function runRequest(aString2:String, request:URLRequest):void 
		{
			switch(currentMODE)
			{
				case MODE_HTTP:
					addListeners();
					urlLoader.load(request)
					break;
			}
		}
		private function loaderCompleteHandler(e:Event):void 
		{
			var myXML:XML;
			var aste:String = urlLoader.data;
			if (aste.search('function.fsockopen') > 0)
			{
				myXML = XML("<error>OUTBOUND EVENTS SOCKET NOT AVAILABLE</error>");
				callback(myXML);
			}else {
				myXML = XML(urlLoader.data);
				callback(myXML);
			}	
		}
		private function httpStatusHandler( e:HTTPStatusEvent ):void 
		{
			trace("httpStatusHandler:" + e);
		}
		private function securityErrorHandler( e:SecurityErrorEvent ):void 
		{
			trace("securityErrorHandler:" + e);
			removeListeners();
		}
		private function ioErrorHandler( e:IOErrorEvent ):void 
		{
			trace("ioErrorHandler:" + e);		
			removeListeners();
			var myXML:XML;
			myXML = XML("<error>notfound</error>");
			callback(myXML);
		}
		private function addListeners():void 
		{
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function removeListeners():void 
		{
			urlLoader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		//////////////////////////////////////
		///SEMAPHORE Functions
		override protected function initialize():void
		{
			_locks = 0;
		}
		override public function get locks():int
		{
			return _locks;
		}
		override public function get isLocked():Boolean
		{
			return (_locks > 0);
		}
		public function lock():void
		{
			if (_locks++ == 0)
			{
				dispatchEvent(new SemaphoreEvent(SemaphoreEvent.UNAVAILABLE));
			}
		}
		public function unlock():void
		{
			_locks--;
			if (locks < 0)
			{
				throw new Error("REST - Semaphore Asymmetrically Unlocked!");
				locks = 0;
			} else if (locks == 0) {
				dispatchEvent(new SemaphoreEvent(SemaphoreEvent.AVAILABLE));
			}
		}
	}
}