package controllers
{
	import data.Data;
	import data.DataObject;
	import flash.events.Event;
	import models.FormModel;
	import models.Model;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class FormController extends Controller//
	{
		private var enums:Array;
		private var myEnumDB:Array
		private var myEnumDO:DataObject = null;

		public function FormController(aModel:Model):void 
		{
			super(aModel);
			model = FormModel(model);
			eventManager = EventManager.getInstance();
		}
		public function getData():void 
		{
			var myArray:Array = [];
			var myDo:DataObject = FormModel(model).getListDataObject();
			var currentSort:String = FormModel(model).getCurrentSort();
			var currentSearch:String = FormModel(model).getCurrentSearch();
			var currentSearchKey:String = FormModel(model).getColumns()[FormModel(model).getSelectedColumn()];
			var currentDirection:String = FormModel(model).getCurrentOrder();
			var myTable:String = myDo.getDataClass();
			var currentPage:Number = 0;//FormModel(model).getCurrentPage();
			var recsQuery:Number = 1000;// FormModel(model).getRecsQuery();
			var offsetRecord:Number = currentPage * recsQuery;
			if (currentSearch != null && currentSearch != "")
			{
				myArray.push([currentSearchKey, currentSearch]);
				myArray.push([Controller.OPERATOR, Controller.OP_LIKE]);
			}	
			model.addEventListener(Model.GENERIC_DATALIST, gotData);
			getDataListSearch(myTable, myArray, currentSort, currentDirection, offsetRecord, recsQuery );
		}
		private function gotData(e:Event):void 
		{
			model.removeEventListener(Model.GENERIC_DATALIST, gotData);
			var xml:XML = model.getGenericData();
			var myDo:DataObject = FormModel(model).getListDataObject();
			var myItems:Array = myDo.parseXMLList(xml);
			FormModel(model).setData(myItems);
		}
		public function getEnums():void 
		{
			FormModel(model).flushDataEnums();
			enums = FormModel(model).getListDataObject().getEnumsDB();
			doEnums();
		}
		private function doEnums():void
		{
			if (enums != null)
			{
			if (enums.length == 0)
				{
					FormModel(model).enumEvent();
				}else {
					myEnumDB = enums.shift();
					if (myEnumDB[1] == Data.ENUM_ARRAY)
					{
						FormModel(model).setDataEnums([myEnumDB[0], myEnumDB[1],  myEnumDB[2],   myEnumDB[3]]);
						doEnums();
					}else {
						model.addEventListener(Model.GENERIC_DATALIST, gotEnumData);
						myEnumDO = myEnumDB[2] as DataObject;
						getDataList(myEnumDO.getDataClass());
					}	
				}
			}else {
				FormModel(model).enumEvent();
			}
		}
		private function gotEnumData(e:Event):void 
		{
			model.removeEventListener(Model.GENERIC_DATALIST, gotEnumData);
			var xml:XML = model.getGenericData();
			var myItems:Array = myEnumDO.parseXMLList(xml);
			FormModel(model).setDataEnums([myEnumDB[0], myEnumDB[1], myEnumDB[2],myItems]);
			doEnums();
		}
	}
}