package data 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public interface DataObject 
	{
		function getKeys() :Array;
		function setKeyValue(aKey:String, aVal:Object) :void;
		function getKey() :String;
		function getValue(aKey:String) :Object;
		function getEditType(aKey:String) :Object;
		function getTable() :String;
		function getDataType() :String;
		function getCreate() :String;
		function getInsert() :String;
		function getUpdate() :String;
		function getDelete() :String;
		function getSelect() :String;
		function getSelectWhere() :String;
		function getSelectLookup(anID:String) :String;
		function getDrop() :String;
		function infoToString() :String;
		function getLabel() :String;
		function getIcon() :MovieClip;
		function getTooltip() :String;
		////////////////////////////////////////////////
		function getDataClassDB() :String;
		function getPrimaryKey() :String;
		function getPrimaryKeyVal() :String;
		////////////////////////////////////////////////
		function parseData(aData:Array, aDo:DataObject):Array;
		function get icon() :MovieClip;
		function set icon(aClip:MovieClip) :void;
		function get label() :String;
		function set label(aClip:String) :void;
		function get label2() :String;
		function set label2(aClip:String) :void;
		function toXML():XML;
		function fromXML(xml:XML):void;
		function toObject():Object;
		function fromObject(xml:Object):void;
	}
	
}