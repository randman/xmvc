package data 
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import utils.StringUtils;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class Data implements DataObject
	{
		/////////////////////////EDIT/CREATE FORM DATA TYPES////////////////////////////////
		public static const TYPE_READ_ONLY:String = "TYPE_READ_ONLY";
		public static const TYPE_EDIT:String = "TYPE_EDIT";
		public static const TYPE_TEXT_EDIT:String = "TYPE_TEXT_EDIT";
		public static const TYPE_IGNORE:String = "TYPE_IGNORE";	
		//////////////////////////MYSQL NATIVE DATA TYPES///////////////////////////////////////////////////
		protected static const INDEX2:String = "INT PRIMARY KEY AUTOINCREMENT";// "int(11) NOT NULL auto_increment";//INT PRIMARY KEY AUTOINCREMENT
		protected static const INDEX:String = "VARCHAR(36)";// "int(11) NOT NULL auto_increment";//INT PRIMARY KEY AUTOINCREMENT
		protected static const VARCHAR32:String = "VARCHAR(32)";
		protected static const VARCHAR64:String = "VARCHAR(64)";
		protected static const VARCHAR128:String = "VARCHAR(128)";
		protected static const TEXT:String = "TEXT";
		protected static const DATE:String = "DATE";
		protected static const KEY:String = "INT(11)";
		protected static const HEX:String = "VARCHAR(8)";
		protected static const TIMESTAMP:String = "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP";
		public static const NLSSGateway_NAMESPACE:String = 'xmlns="http://www.nlss.com/Gateway"';
		//////////////////////////MYSQL OPERATIONS///////////////////////////////////////////////////
		protected static const CREATE:String = "CREATE TABLE IF NOT EXISTS ";
		protected static const DROP:String = "DROP TABLE ";
		protected static const INSERT:String = "INSERT INTO ";
		protected static const UPDATE:String = "UPDATE ";
		protected static const DELETE:String = "DELETE FROM ";
		protected static const SELECT:String = "SELECT * FROM ";
		protected static const ORDER:String = " ORDER BY ";
		protected static const ENGINE:String = "ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_german2_ci AUTO_INCREMENT=13";
		///////////////////////////STORAGE//////////////////////////////////////////////////
		protected var DATA_TYPE:String;
		protected var TABLE:String;
		protected var PRIMARY:String;
		protected var MYKEY:String;
		protected var MYLABEL:String;
		protected var MYTOOLTIP:String;
		protected var MYXMLCLASS:String;
		protected var MYXML_NAMESPACE:String;
		protected var MYICON:String;
		protected var myData:Array;
		protected var _icon:MovieClip;
		protected var _label:String;
		protected var _label2:String;
		
		public function Data() 
		{	
		}
		public static function cleanXML(myXML:XML) :XML
		{
			////trace("cleanXML" + myXML);
			if (myXML != null)
			{
				var xmlSource:String = myXML.toXMLString(); 
				xmlSource = xmlSource.replace(/<[^!?]?[^>]+?>/g, StringUtils.removeNamspaces);
				var new_xml:XML = XML(xmlSource); 
				return new_xml;
			}else {
				return  XML("<error>no reccords</error>");
			}
		}
		public function getKeys() :Array
		{
			var myKeys:Array = [];
			for (var i:int = 0; i < myData.length; i++)
			{
				var tempStr:String = myData[i][0];
				myKeys.push(tempStr);
			}
			return myKeys;
		}
		public function setKeyValue(aKey:String, aVal:Object) :void
		{
			for (var i:int = 0; i < myData.length; i++)
			{
				var tempStr:String = myData[i][0];
				if (tempStr == aKey) 
				{
					myData[i][2] = aVal;
					break;
				}
			}
		}
		public function getValue(aKey:String) :Object
		{
			var keyIndex:Number = 0;
			for (var i:int = 0; i < myData.length; i++)
			{
				var tempStr:String = myData[i][0];
				if (tempStr == aKey) 
				{
					keyIndex = i;
					break;
				}
			}
			return myData[keyIndex][2];
		}
		public function getEditType(aKey:String) :Object
		{
			var keyIndex:Number = 0;
			for (var i:int = 0; i < myData.length; i++)
			{
				var tempStr:String = myData[i][0];
				if (tempStr == aKey) 
				{
					keyIndex = i;
					break;
				}
			}
			return myData[keyIndex][3];
		}
		public function getDataType() :String
		{
			return DATA_TYPE;
		}
		public function getCreate() :String
		{
			var bigString:String = CREATE + "  " +TABLE+" (\n" ;
			for (var i:int = 0; i < myData.length; i++)
			{
				bigString += "" +myData[i][0] + " " + myData[i][1]+", \n";
			}
			bigString += PRIMARY ;
			return bigString;
		}
		public function getKey() :String
		{
			return MYKEY;
		}
		public function getSelect() :String
		{
			return SELECT + TABLE + ORDER + MYLABEL;
		}
		public function getSelectWhere() :String
		{
			return SELECT + TABLE + " WHERE " + MYKEY + " = "+ ORDER + MYLABEL;
		}
		public function getSelectLookup(anStr:String) :String
		{
			return SELECT + TABLE + " WHERE " + anStr + " = "+ ORDER + MYLABEL;
		}
		public function getDrop() :String
		{
			return DROP + TABLE;
		}
		public function parseData(aData:Array, aDo:DataObject):Array
		{
			var myArray:Array = [];
			if (aData.length > 0)
			{
				for (var j:int = 0; j < aData.length ; j++)
				{
					var myDT:String = aDo.getDataType();
					//trace(myDT);
					var KlassDef:Class = getDefinitionByName(myDT) as Class;
					var bDataObject:DataObject = new KlassDef() as DataObject;
					var bObject:Object = aData[j];
					for (var z:String in bObject) 
					{
						bDataObject.setKeyValue(z, bObject[z]);
						//trace(z+ bObject[z]);// + " = " +anObject[z]);
					}
					bDataObject.label = bDataObject.getLabel();
					bDataObject.icon = bDataObject.getIcon();
					myArray.push(bDataObject);
				}
			}
			return myArray;
		}
		public function getInsert() :String
		{
			var bigString:String = INSERT + TABLE + " ( ";
			for (var h:int = 0; h < myData.length; h++)
			{
				bigString += myData[h][0] + ", ";
			}
			bigString = bigString.substr(0, bigString.length-2)+") VALUES (";
			for (var i:int = 0; i < myData.length; i++)
			{
				if ( myData[i][1] == KEY)// || myData[i][1] == INDEX)
				{
					bigString += myData[i][2]+", ";
				}else {
					bigString += "'" +myData[i][2] + "', ";
				}
			}
			bigString = bigString.substr(0, bigString.length - 2) + ")";
			return bigString;
		}
		public function getDelete() :String
		{
			var bigString:String = DELETE + TABLE + " WHERE " + MYKEY + " = '" + getValue(MYKEY)+"'";
			return bigString;
		}
		public function getUpdate() :String
		{
			var bigString:String = UPDATE + TABLE + " SET  " ;
			var aKeyNum:Number = Number(getValue(MYKEY));
			for (var i:int = 1; i < myData.length; i++)
			{
				bigString +=myData[i][0]+"="
				if ( myData[i][1]== KEY || myData[i][1] == INDEX)
				{
					bigString += myData[i][2]+", ";
				}else {
					bigString += "'" +myData[i][2] + "', ";
				}
			}
			bigString = bigString.slice(0, bigString.length-2);
			bigString += " WHERE "+ MYKEY+" = " + aKeyNum;
			return bigString;
		}
		public function getTable() :String
		{
			return TABLE;
		}
		public function infoToString() :String
		{
			var bigString:String = "";
			for (var i:int = 0; i < myData.length; i++)
			{
				bigString += myData[i][0] + " = " +myData[i][2] +"\n";
			}		
			return bigString;
		}
		public function getLabel() :String
		{
			return String(getValue(MYLABEL));
		}
		public function getIcon() :MovieClip
		{
			return _icon;// new MovieClip();
		}
		public function get icon() :MovieClip
		{
			return _icon;
		}
		public function set icon(aClip:MovieClip) :void
		{
			_icon=aClip;
		}
		public function get label() :String
		{
			return _label;
		}
		public function set label(aClip:String) :void
		{
			_label=aClip;
		}
		public function get label2() :String
		{
			return _label2;
		}
		public function set label2(aClip:String) :void
		{
			_label2=aClip;
		}
		public function getTooltip() :String
		{
			return String(getValue(MYTOOLTIP));
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function getDataClassDB() :String
		{
			return MYXMLCLASS;
		}
		public function getPrimaryKey() :String
		{
			return MYKEY;
		}
		public function getPrimaryKeyVal() :String
		{
			return String(getValue(MYKEY));
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function toXML():XML
		{
			var xmlList:XMLList = null;
		//	var xml:XML = XML("<" + TABLE + "/>");
			var xml:XML = XML("<"+MYXML_NAMESPACE+"/>");
			for (var i:int = 0; i < myData.length; i++)
			{		
					var nodeName:String =  myData[i][0];
					var nodeValue:String = String(myData[i][2]);
					switch(nodeValue)
					{
						case null:
						case "null":
							break;
							//////////////////DONT SEND THE NODE
						default:	
							//////////////////SEND THE NODE
							xmlList = XMLList("<" + nodeName + ">" + nodeValue + "</" + nodeName + ">");
							xml.appendChild(xmlList);
							break;
					}
			}
			return xml;
		}
		public function fromXML(xml:XML):void
		{
			if (xml != null&&xml!="")
			{
				var xmlSource:String = xml.toXMLString();   
				xmlSource = xmlSource.replace(/<[^!?]?[^>]+?>/g,  StringUtils.removeNamspaces); // will invoke the function detailed below
				var new_xml:XML = XML(xmlSource); 
				for (var j:int = 0; j < xml.namespaceDeclarations().length; j++)
				{
					xml.removeNamespace(xml.namespaceDeclarations()[j])
				}
				for (var i:int = 0; i < myData.length; i++)
				{
					setKeyValue(myData[i][0], new_xml[myData[i][0]].text());
				}
			}
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function toObject():Object
		{
			var xml:Object = new Object();
			for (var i:int = 0; i < myData.length; i++)
			{		
					var nodeName:String =  myData[i][0];
					var nodeValue:String = String(myData[i][2]);
					switch(nodeValue)
					{
						case null:
						case "null":
							break;
							//////////////////DONT SEND THE NODE
						default:	
							//////////////////SEND THE NODE
							xml[nodeName]= nodeValue;
							break;
					}
			}
			return xml;
		}
		public function fromObject(xml:Object):void
		{
			if (xml != null&&xml!="")
			{
				for (var z:String in xml) 
					{
						setKeyValue(z, xml[z]);
					}
			}
		}
	}
}