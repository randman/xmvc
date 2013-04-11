package components
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * ...
	 * @author Rand Anderson
	 */
	public class TextInputField extends TextField
	{
		private var myFont:String;
		private var myFontSize:Number;
		private var myFontColor:uint = 0xFFFFFF;
		
		public function TextInputField
		(
			labelText:String = "",
			fontSize:int = 18,
			showborder:Boolean = true,
			maxWidth:Number=50
		) 
		{
			myFont = "Arial";
			myFontSize = 18;
			myFontColor= 0xFFFFFF;
			autoSize = TextFieldAutoSize.NONE;
			//autoSize = TextFieldAutoSize.LEFT;
			/*
			if (maxWidth > 0)
			{
				maxChars = maxWidth;
				width = maxWidth;
				background = true;
				backgroundColor = 0xFFFFFF;
			}
			*/
			background = true;
			backgroundColor = 0x666666;
			type = TextFieldType.INPUT;
			text = labelText;
			height = 30;
			width = 300;
			border = false;
			borderColor = 0xFFFFFF; 
			selectable = true;
		//	var format:TextFormat = new TextFormat();
			//format.size = skinManger.getSkin().getValue(SkinData.Skin_FontSize);
		//	format.size = 40;
		//	setTextFormat(format);
			left();
		}
		public function left():void
		{
			var format2:TextFormat = new TextFormat();
			format2.font = myFont;
			format2.align = TextFormatAlign.LEFT;
			format2.size = myFontSize;
			format2.color = myFontColor;
			setTextFormat(format2);
		}
		public function setColor(aColor:uint):void
		{
			textColor = aColor;
			//textColor = 0xFFFFFF;
		
		}
		public function setText(aString:String):void
		{
			text = aString;
			left();
			//htmlText = aString;
			
		}
		public function getText():String
		{
			return text;
		}
	}
}