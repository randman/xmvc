package utils
{
  /**
  * A JavaScript implementation of the Secure Hash Algorithm, SHA-1, as defined
  * in FIPS PUB 180-1
  * Distributed under the BSD License
  * See http://pajhome.org.uk/crypt/md5 for details.
  */
  public final class SHA1
  {
    ///////////////////////////////////////////////////////////////////////////
    public static function hex_sha1(s: String): String
    {
      return binb2hex(core_sha1(str2binb(s), s.length * chrsz));
      // test:
      // if (sha1.hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d") //trace("sha-1 OK"); else //trace("sha-1 FAIL");
    }
    // Calculate the SHA-1 of an array of big-endian words, and a bit length
    private static function core_sha1(x: Array, len: uint): Array
    {
      // Add integers, wrapping at 2^32. This uses 16-bit operations internally
      // to work around bugs in some JS interpreters.
      function safe_add(x: int, y: int): int
      {
        return x + y;
      }
      // Perform the appropriate triplet combination function for the current iteration
      function sha1_ft(t: int, b: int, c: int, d: int): int
      {
        if (t < 20)
          return (b & c) | ((~b) & d);
        if (t < 40)
          return b ^ c ^ d;
        if (t < 60)
          return (b & c) | (b & d) | (c & d);

        return b ^ c ^ d;
      }

      // Determine the appropriate additive constant for the current iteration
      function sha1_kt(t: int): int
      {
        return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 : (t < 60) ? -1894007588 : -899497514;
      }

      // Bitwise rotate a 32-bit number to the left
      function rol(num: int, cnt: int): int
      {
        return (num << cnt) | (num >>> (32 - cnt));
      }

      // append padding
      x[uint(len >> 5)] |= 0x80 << (24 - len % 32);
      x[uint(((len + 64 >> 9) << 4) + 15)] = len;

      var w: Array = new Array(80);
      var a: int = 1732584193;
      var b: int = -271733879;
      var c: int = -1732584194;
      var d: int = 271733878;
      var e: int = -1009589776;

      for (var i: uint = 0, length: uint = x.length; i < length; i += 16)
      {
        var olda: int = a;
        var oldb: int = b;
        var oldc: int = c;
        var oldd: int = d;
        var olde: int = e;

        for (var j: uint = 0; j < 80; j++)
        {
          if (j < 16)
            w[j] = x[uint(i + j)];
          else
            w[j] = rol(w[uint(j - 3)] ^ w[uint(j - 8)] ^ w[uint(j - 14)] ^ w[uint(j - 16)], 1);

          var t: int = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
          e = d;
          d = c;
          c = rol(b, 30);
          b = a;
          a = t;
        }

        a += olda;
        b += oldb;
        c += oldc;
        d += oldd;
        e += olde;
      }

      return new Array(a, b, c, d, e);
    }
    // Convert an 8-bit or 16-bit string to an array of big-endian words
    // In 8-bit function, characters >255 have their hi-byte silently ignored
    private static function str2binb(str: String): Array
    {
      const bin: Array = new Array();
      const mask: int = (1 << chrsz) - 1;

      for (var i: uint = 0, len: uint = str.length * chrsz; i < len; i += chrsz)
        bin[uint(i >> 5)] |= (str.charCodeAt(i / chrsz) & mask) << (32 - chrsz - i % 32);

      return bin;
    }
    // Convert an array of big-endian words to a hex string
    private static function binb2hex(binarray: Array): String
    {
      var str: String = "";
      const tab: String = "0123456789abcdef";

      for (var i: uint = 0, len: uint = binarray.length * 4; i < len; i++)
        str += tab.charAt((binarray[uint(i >> 2)] >> ((3 - i % 4) * 8 + 4)) & 0xF) +
          tab.charAt((binarray[uint(i >> 2)] >> ((3 - i % 4) * 8)) & 0xF);

      return str;
    }
    // bits per input character. 8 - ASCII; 16 - Unicode
    private static const chrsz: uint = 8;
  }
}