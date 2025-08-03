package common
{

	public class DataFormat
	{
		public function DataFormat()
		{
		}
		public static function formatNumber(num:Number):Number{
			return Number(num.toFixed(2));
			//保留1位小数，不四舍五入。材料可偏小点。
			//return Math.floor(num*10)/10;
		}
		//保留2位小数四舍五入
		public static function formatNumber2(num:Object):Number{
			//return Number(num.toFixed(2));
			return Number(Number(num).toFixed(2));
		}
		//保留1位小数四舍五入
		public static function formatNumber1(num:Object):Number{
			//return Number(num.toFixed(2));
			return Number(Number(num).toFixed(1));
		}
		
		public static function isEven(number:int):Boolean {
			return number % 2 == 0; // 如果余数为0，则为偶数
		}
		
	}
}