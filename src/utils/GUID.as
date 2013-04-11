package utils
{
   /**
	* <code>GUID</code> class.
	* <p>Generates a unique UUID for user session management</p>
	* for future use
	* @author rand anderson
	* @copy dop
	*/
  public class GUID
  {
    public static function create(salt: String = ""): String
    {
      const id1: Number = new Date().getTime();
      const id2: Number = Math.random();
      const sha1str: String = SHA1.hex_sha1(id1 + id2 + salt);

     // return sha1ToGUID(sha1str).toUpperCase();
      return sha1ToGUID(sha1str).toLowerCase();
    }
    // The GUID has the form "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    // sha1 is 160 bit long - GUID is 128 bit only
    public static function sha1ToGUID(s: String): String
    {
      return [s.substr(0, 8), s.substr(8, 4), s.substr(12, 4), s.substr(16, 4), s.substr(20, 12)].join("-");
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
	
  }
}