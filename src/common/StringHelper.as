package common
{
	import flash.utils.ByteArray;
	
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.utils.StringUtil;

	public class StringHelper
	{
		public function StringHelper()
		{
		}
		
		public static function getChars(value:String,charLength:int):int{
			var result:int=charLength;
			var ba:ByteArray = new ByteArray();  
			ba.writeMultiByte(value,"GBK");
			result=value.length+int((charLength-ba.length)/2);
			return result;
		}
		
		
		public static function sgdCodeLabelFunction(obj:Object,col:DataGridColumn):String{
			var result:String = "";
			if(obj.hasOwnProperty(col.dataField)){
				result += obj[col.dataField];
			}
			//yssgd.sgd063=='BD'
			if(StringUtil.trim(result).length>0&&obj.hasOwnProperty("sgd063")&&obj["sgd063"]=="BD"){
				result += "(补)";
			}
			
			return result;
		}
		/**以delim拼接集合array里的joinLabel字段*/
		public static function joins(array:Array,joinLabel:String,delim:String=","):String
		{
			var result:String = "";
			if(array)
			{
				for (var i:int = 0; i < array.length; i++) 
				{
					var item:Object = array[i];
					result += item[joinLabel];
					if(i<array.length-1)
					{
						result += ",";
					}
				}
			}
			return result;
		}
		/**字符串不足几位 自动补充字符,默认补充*号,  
		 * p: 0：前面补  1：后面补
		 * */
		public static function addSomeThing(str:String,num:int,addStr:String="*",p:int=0):String{
			if(str==null){
				str="";
			}
			while(str.length<num){
				if(p==0){
					str = addStr+str;
				}else{
					str += addStr;
				}
			}
			return str;
		}
		/**    
		 * replaceAll    
		 * @param source:String 源数据    
		 * @param find:String 替换对象    
		 * @param replacement:Sring 替换内容    
		 * @return String    
		 * **/    
		public static function replaceAll(source:String, find:String, replacement:String ):String{      
			return source.split(find).join(replacement);      
		} 
		public static function utf16to8(char:String):String{    
			var out:Array = new Array();    
			var len:uint = char.length;    
			for(var i:uint=0;i<len;i++){    
				var c:int = char.charCodeAt(i);    
				if(c >= 0x0001 && c <= 0x007F){    
					out[i] = char.charAt(i);    
				} else if (c > 0x07FF) {    
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),    
						0x80 | ((c >>  6) & 0x3F),    
						0x80 | ((c >>  0) & 0x3F));    
				} else {    
					out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),    
						0x80 | ((c >>  0) & 0x3F));    
				}    
			}    
			return out.join('');    
		}
		//utf8转utf16编码;    
		public static function utf8to16(char:String):String{    
			var out:Array = new Array();    
			var len:uint = char.length;    
			var i:uint = 0;    
			while(i<len){    
				var c:int = char.charCodeAt(i++);    
				switch(c >> 4){    
					case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:    
						// 0xxxxxxx    
						out[out.length] = char.charAt(i-1);    
						break;    
					case 12: case 13:    
						// 110x xxxx   10xx xxxx    
						var char2:int = char.charCodeAt(i++);    
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));    
						break;    
					case 14:    
						// 1110 xxxx  10xx xxxx  10xx xxxx    
						var char2:int = char.charCodeAt(i++);    
						var char3:int = char.charCodeAt(i++);    
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |    
							((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));    
						break;    
				}    
			}    
			return out.join('');    
		}
		/**
		 * 10进制转换成2进制
		 * @param str:String 10进制数
		 * @param num:int 转换成多少位二进制
		 * @return:String
		 * 
		 */
		public static function Binary_System(str:String,num:int):String{
			var snapNum:int=int(str);
			var strs:String=""+(snapNum&1);
			var numArr:Array=new Array();
			for(var a:int=1;a<num;a++){
				strs+=""+(snapNum>>a&1);
			}
			for(var b:int=0;b<strs.length;b++){
				numArr.push(strs.charAt(b));
			}
			numArr.reverse();
			strs="";
			for(var c:int=0;c<numArr.length;c++){
				strs+=numArr[c];
			}
			return strs;
		}
		//String to ByteArray
		public static function convertStringToByteArray(string:String):ByteArray
		{
			var bytes:ByteArray;
			if ( string) {
				bytes = new ByteArray();
				bytes.writeUTFBytes(string);// writeUTFBytes(value:String) 将 UTF-8 字符串写入字节流;
			}
			return bytes;
		}
		
		//将 ByteArray 转换成 String：
		
		public static function convertByteArrayToString(bytes:ByteArray):String
		{
			var str:String;
			if ( bytes ) {
				bytes.position = 0; // 在将 ByteArray 转换成 String中应注意将 bytes 的 position 设置为 0，切记；
				str = bytes.readUTFBytes(bytes.length); // readUTFBytes(length:uint):从字节流中读取一个由 length 参数指定的 UTF-8 字节序列，并返回一个字符串;
			}
			return str;
		}
	}
}