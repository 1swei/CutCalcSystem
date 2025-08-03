package common
{
	import flash.utils.ByteArray;

	public class ChineseConvert
	{
		public function ChineseConvert()
		{
		}
		/**
		 * 获取一串中文的拼音字母
		 * @param        chinese        <string>Unicode格式的中文字符串
		 * @return                        <string>拼音声母字符串
		 * @example 
		 * var chinese:String = "中华人民共和国";
		 * var py:String = Convert.convertString(chinese);
		 * trace(py);        //zhrmghg
		 */
		public static function convertString(chinese:String):String 
		{
			var len:int = chinese.length;
			var ret:String = "";
			for (var i:int = 0; i < len; i++) 
			{
				ret += convertChar(chinese.charAt(i));
			}
			return ret;
		}
		/**
		 * 
		 * @param        char        <String>Unicode格式的一个中文字符
		 * @return                        <String>中文字符的声母
		 * @example
		 * var chineseChar:String = "我";
		 * var py:String = Convert.convertChar(chineseChar);
		 * trace(py);        //w
		 */
		public static function convertChar(chineseChar:String):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(chineseChar.charAt(0), "cn-gb");
			var n:int = bytes[0] << 8;
			n += bytes[1];
			if (isIn(0xB0A1, 0xB0C4, n)) return "a";
			if (isIn(0XB0C5, 0XB2C0, n)) return "b";
			if (isIn(0xB2C1, 0xB4ED, n)) return "c";
			if (isIn(0xB4EE, 0xB6E9, n)) return "d";
			if (isIn(0xB6EA, 0xB7A1, n)) return "e";
			if (isIn(0xB7A2, 0xB8c0, n)) return "f";
			if (isIn(0xB8C1, 0xB9FD, n)) return "g";
			if (isIn(0xB9FE, 0xBBF6, n)) return "h";
			if (isIn(0xBBF7, 0xBFA5, n)) return "j";
			if (isIn(0xBFA6, 0xC0AB, n)) return "k";
			if (isIn(0xC0AC, 0xC2E7, n)) return "l";
			if (isIn(0xC2E8, 0xC4C2, n)) return "m";
			if (isIn(0xC4C3, 0xC5B5, n)) return "n";
			if (isIn(0xC5B6, 0xC5BD, n)) return "o";
			if (isIn(0xC5BE, 0xC6D9, n)) return "p";
			if (isIn(0xC6DA, 0xC8BA, n)) return "q";
			if (isIn(0xC8BB, 0xC8F5, n)) return "r";
			if (isIn(0xC8F6, 0xCBF0, n)) return "s";
			if (isIn(0xCBFA, 0xCDD9, n)) return "t";
			if (isIn(0xCDDA, 0xCEF3, n)) return "w";
			if (isIn(0xCEF4, 0xD188, n)) return "x";
			if (isIn(0xD1B9, 0xD4D0, n)) return "y";
			if (isIn(0xD4D1, 0xD7F9, n)) return "z";
			return "\0";
		}
		
		private static function isIn(from:int, to:int, value:int):Boolean
		{  
			return ((value >= from) && (value <= to));
		}
		
		
		
		
		
		/**
		 * 
		 * @param        chineseChar        <String>Unicode格式的一个中文字符
		 * @return                                <Boolean>是中文返回true,不是返回flase
		 */
		public static function isChinese(chineseChar:String):Boolean 
		{
			if (convertChar(chineseChar) == "\0")
			{
				return false;
			}
			return true;
		}
	}
}