package components
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class TextDisplayField extends TextField
	{

		private var myFont:String;
		private var myFontSize:Number;
		private var myFontColor:uint=0x000000;
		
		public function TextDisplayField (labelText:String="", showborder:Boolean=false)
		{
			myFont = "Arial";
			myFontSize = 18;
			myFontColor= 0xFFFFFF;
			text = labelText;
			//text = TextFormatter.unescapeHTML(labelText);
			border = showborder;
			selectable = false;
			left();
		}
		public function error():void
		{
			myFontColor= 0xFF0000;
			left();
		}
		public function left():void
		{
			autoSize = TextFieldAutoSize.LEFT;
			var format2:TextFormat = new TextFormat();
			format2.bold = true;
			format2.font = myFont;
			format2.align = TextFormatAlign.LEFT;
			format2.size = myFontSize;
			format2.color = myFontColor;
			setTextFormat(format2);
		}
		public function center():void
		{
			autoSize = TextFieldAutoSize.CENTER;
			var format2:TextFormat = new TextFormat();
			format2.font = myFont;
			format2.align = TextFormatAlign.CENTER;
			format2.size = myFontSize;
			format2.color = myFontColor;
			setTextFormat(format2);
		}
		public function bold():void
		{
			var format2:TextFormat = new TextFormat();
			format2.font = myFont;
			format2.bold = true;
			format2.size = myFontSize + 1;
			format2.color = myFontColor;
			setTextFormat(format2);
		}
		public function underline(abool:Boolean):void
		{
			var format2:TextFormat = new TextFormat();
			format2.font = myFont;
			format2.underline = abool;
			format2.bold = true;
			format2.size = myFontSize + 1;
			format2.color = myFontColor;
			setTextFormat(format2);
		}
		public function setHTMLText(aString:String):void
		{
			htmlText = aString;
		}
		public function setText(aString:String):void
		{
			text = aString;
			//text = TextFormatter.unescapeHTML(aString);;
			left();
		}
		public function addText(aString:String):void
		{
			text += aString;
		}
		public function getText():String
		{
			return text;
		}
	}
}