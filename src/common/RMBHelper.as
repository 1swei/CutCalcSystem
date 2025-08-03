package common
{
	public class RMBHelper
	{
		public function RMBHelper(){}
		
//		private static const num:Array=["零","壹","贰","叁","肆",
//			"伍","陆","柒","捌","玖"];
//		
//		private static const unit:Array=[
//			["元","拾","佰","仟","万","拾","佰","仟",
//				"亿","拾","佰","仟","万","拾","佰","仟","亿"]
//			,["分","角"]
//		];
//	
//		public static function fn(value:Number):String{
//			var result:String="";
//			if(isNaN(value)){
//				return "";
//			}
//			if(value<0)
//			{
//				value=0-value;
//				result+="负";
//			}
//			var strs:Array=value.toFixed(2).split(".");
//			var array:Array;
//			var char:String;
//			var b1:Boolean=false;
//			for(var i:int=0;i<strs.length;i++){
//				array=unit[i];
//				for(var j:int=0;j<strs[i].length;j++){
//					char=strs[i].toString().charAt(j);
//					if(char=="0"){
//						b1=true;
//					}else if(b1){
//						result+=num[0];
//						b1=false;
//					}
//					if(j>array.length){
//						break;
//					}
//					if(!b1){
//						result+=(num[char]+array[strs[i].length-(j+1)]);
//					}else if(b1&&(array[strs[i].length-(j+1)]=="亿"
//						||array[strs[i].length-(j+1)]=="万"
//						||array[strs[i].length-(j+1)]=="元")){
//						result+=array[strs[i].length-(j+1)];
//					}
//				}
//			}
//			if(result.length>0){
//				if(result.indexOf("元")<0){
//					result += "元";
//				}
//				result+="整";
//			}
//			return result;
//		}
		/**
		 * @yin
		 * 数字转大写金额
		 * "1234".substr(0,3)="123";
		 * */
		public static function parseRMB(theNum:Number):String
		{
			if(isNaN(theNum))
			{
				return theNum+"";
			}
			var fuhao:String="";
			if(theNum<0)
			{
				theNum=0-theNum;
				fuhao="负";
			}
			theNum=Number(theNum.toFixed(2));
			var s1:String = "零壹贰叁肆伍陆柒捌玖";
			var s2:String = "亿仟佰拾万仟佰拾亿仟佰拾万仟佰拾元角分";
			var sin:String;
			var nAmount:String = (theNum*100).toFixed(0);
			var numLength:int=nAmount.length;
			var useStr:String= s2.substr(s2.length - numLength, numLength);
			var zeroCounter:int=0,flag:int=0;
			var resultStr:String="";
			do 
			{
				flag++;
				var cnNum:String;         
				
				cnNum = nAmount.substr(flag-1, 1);
				cnNum = s1.substr(Number(cnNum), 1);         
				sin = useStr.substr(flag-1, 1);         
				if (cnNum == "零")
				{
					cnNum = "";
					if (sin == "亿" || sin == "元")
					{
						
					}
					else if (sin == "万")
					{
						
						if (resultStr.substr(resultStr.length-1, 1) == "亿")
						{
							sin = "";                 
						}
					}
					else
					{
						sin="";
					}
					zeroCounter++;
				}
				else
				{
					if(zeroCounter>0)
					{
						cnNum = "零" + cnNum;
						zeroCounter=0;
					}
				}
				resultStr = resultStr + cnNum + sin;     
				
			}
			while(flag < nAmount.length)
			if (nAmount.substr(nAmount.length-1, 1) == "0")
			{
				return fuhao+resultStr + "整";
			}
			else
			{
				return fuhao+resultStr;
			}
		}
	}
}