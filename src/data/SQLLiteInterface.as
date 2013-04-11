package  data{
	
	import flash.data.*;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class SQLLiteInterface 
	{
		
		private var dbconn:SQLConnection;
		/////////////////////////////////////
		private var _databaseFileName:String;	
		private var _databaseFile:File;
		private var _statement:SQLStatement;
		private var _sql:String;
		private var _parameters:Array;
		private var _data:Array;
		private var _supercallback:Function;
		private var _callback:Function;
		private var _myDO:DataObject;
		/////////////////////////////////////
		private var tables:Array = [];
	
		public function SQLLiteInterface()
		{
		}	
		public function init(aCallback:Function):void
		{
			_supercallback = aCallback;
			dbconn = new SQLConnection();
			dbconn.addEventListener( SQLErrorEvent.ERROR, onSQLError );
			var dbFile:File = File.applicationStorageDirectory.resolvePath( "MyDatabase.db" );
			if ( dbFile.exists )
			{
				dbconn.addEventListener( SQLEvent.OPEN, onSQLOpen );
			} else {
				dbconn.addEventListener( SQLEvent.OPEN, onSQLCreate );	
			}
			dbconn.openAsync( dbFile );	
		}
		private function onSQLError(e:SQLErrorEvent):void
		{
			//trace("onSQLError");
		}
		private function onSQLOpen(e:SQLEvent):void
		{
			_supercallback();
			//buildTables();
		}
		private function onSQLCreate(e:SQLEvent):void
		{
			buildTables();
		}
		////////////////////////////////////////////////////////////////////
		private function buildTables():void
		{
			tables = [];
			var aConnectionData:ConnectionData = new ConnectionData();
			tables.push(aConnectionData);
			runTables();
		}
		private function runTables(aData:Array=null):void
		{
			if (tables.length > 0)
			{
				dropTable();
			}else {
				_supercallback();
			}
		}
		private function dropTable(aData:Array=null):void
		{
			_myDO = tables.pop();
			sql = _myDO.getDrop();
			execute(createTable);
		}
		private function createTable(aData:Array=null):void
		{
			sql = _myDO.getCreate();
			execute(runTables);
		}
		//////////////////////////////////////////////////////////////////////////
		public function deleteRecord(aCallback:Function):void
		{
			_callback = aCallback;
			sql = _myDO.getDelete();
			//trace(sql);
			execute(_callback);
		}
		public function insertRecord(aCallback:Function):void
		{
			_callback = aCallback;
			sql = _myDO.getInsert();
			//trace(sql);
			execute(_callback);
		}
		public function updateRecord(aCallback:Function):void
		{
			_callback = aCallback;
			sql = _myDO.getUpdate();
			//trace(sql);
			execute(_callback);
		}
		//////////////////////////////////////////////////////////////////////////
		public function getRecords(aCallback:Function):void
		{
			_supercallback = aCallback;
			sql = _myDO.getSelect();
			execute(gotRecords);
		}
		public function gotRecords(aData:Array=null):void
		{
			var newData:Array = [];
			if (aData!=null)
			{
				newData=_myDO.parseData(aData, _myDO);
			}
			_supercallback(newData);
		}
		private function traceRecords(newData:Array=null):void
		{
			if (newData.length > 0)
			{
				for (var j:int = 0; j < newData.length ; j++)
				{
					var aObject:DataObject = newData[j];
					//trace(aObject.infoToString());
				}
			}
		}
		////////////////////////////////////////////////////////////////////
		public function close():void
		{
			dbconn.close();
		}
		////////////////////////////////////////////////////////////////////
		public function get sql():String
		{
			return _sql;
		}
		public function set sql(value:String):void
		{
			_sql = value;
		}
		public function get myDO():DataObject
		{
			return _myDO;
		}
		public function set myDO(value:DataObject):void
		{
			_myDO = value;
		}
		public function get parameters():Array
		{
			return _parameters;
		}
		public function set parameters(params:Array):void
		{
			_parameters = params;
		}		
		public function get data():Array
		{
			return _data;
		}
		public function set data(result:Array):void
		{
			_data = result;
		}				
		public function execute(aCallback:Function):void
		{
			_callback = aCallback;
			_statement = new SQLStatement();
			_statement.sqlConnection = dbconn;
			_statement.text = _sql;
			if(_parameters) {
				for(var i:uint=0; i<_parameters.length; i++)
				{
					_statement.parameters[i] = _parameters[i];
				}
			}
			_statement.addEventListener(SQLEvent.RESULT, onQueryResult);
			_statement.addEventListener(SQLErrorEvent.ERROR, onQueryError);
			_statement.execute();
		}
		private function onQueryResult(evt:SQLEvent):void
		{
			_data = _statement.getResult().data;
			_callback(_data);
		}
		private function onQueryError(evt:SQLErrorEvent):void
		{
			//trace("onQueryError" + evt.toString());
			_callback(null);
		}
	}	
}