package  utils
{
	/**
	 * ...
	 * @author Rand Anderson
	 */
	public final class StringUtils
	{
		public static function generateRandomString(newLength:uint = 1, userAlphabet:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):String{
			  var alphabet:Array = userAlphabet.split("");
			  var alphabetLength:int = alphabet.length;
			  var randomLetters:String = "";
			  for (var i:uint = 0; i < newLength; i++)
			  {
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
			  }
			  return randomLetters;
		}
		public static function randomNumber(low:Number=NaN, high:Number=NaN):Number
		{
			  var low:Number = low;
			  var high:Number = high;
			  if(isNaN(low))
			  {
				throw new Error("low must be defined");
			  }
			  if(isNaN(high))
			  {
				throw new Error("high must be defined");
			  }
			  return Math.round(Math.random() * (high - low)) + low;
		}
		public static function removeNamspaces(...rest):String
		{
			rest[0] = rest[0].replace(/xmlns[^"]+\"[^"]+\"/g, "");
			var attrs:Array = rest[0].match(/\"[^"]*\"/g);
			rest[0] = rest[0].replace(/\"[^"]*\"/g, "%attribute value%");
			rest[0] = rest[0].replace(/(<\/?|\s)\w+\:/g, "$1");
			while (rest[0].indexOf("%attribute value%") > 0)
			{
				rest[0] = rest[0].replace("%attribute value%", attrs.shift());
			}
			return rest[0];
		}
	}
}