package common
{  
	
	/**  
	 *  准确的计算浮点数 ，四舍五入方式是采用最后一位一直到保留小数位的判断。  
	 * */  
	public class BigDecimal  
	{  
		
		/**  
		 * 保留小数位  
		 * */  
		private var _maxDecimalLength:int = 2;  
		
		/**  
		 * 设置保留小数位 如doubleValue有值 设置之后会四舍五入  
		 * */  
		public function set maxDecimalLength(i:int):void{  
			_maxDecimalLength = i;  
			_doubleValue = round(_doubleValue.toString());  
		}  
		
		
		private var _validateStringThrow:Boolean = true;  
		
		/**  
		 * 设置验证字符串数据时如不是数字类型是否抛异常  
		 * 如果不抛异常默认值为0  
		 * */  
		public function set validateStringThrow(b:Boolean):void{  
			_validateStringThrow = b;  
		}  
		
		private var _doubleValue:Number = 0;  
		
		/**  
		 *  设值  
		 *  @param value 可以是String、Number、BigDecimal的任意类型  
		 *  @throws Error 传入的String类型不是数字  
		 *  @throws Error 传入的类型不是String、Number、BigDecimal其中的一个类型  
		 * */  
		public function set doubleValue(value:*):void{  
			_doubleValue = getNumber(value);  
		}  
		
		
		public function get doubleValue():Number{  
			return _doubleValue;  
		}  
		
		
		
		/**  
		 *  @param value 可以是String、Number、BigDecimal的任意类型  
		 *  @param arg1 保留小数位  
		 *  @param arg2 设置验证字符串数据时如不是数字类型是否抛异常,如果不抛异常默认值为0。  
		 *  @throws Error 传入的String类型不是数字  
		 *  @throws Error 传入的类型不是String、Number、BigDecimal其中的一个类型  
		 * */  
		public function BigDecimal(value:*,arg1:int = 2,arg2:Boolean = true)  
		{  
			_maxDecimalLength = arg1;  
			_validateStringThrow = arg2;  
			_doubleValue = getNumber(value);  
		}  
		
		
		/**  
		 *   获得String、Number、BigDecimal类型的值  
		 *  @param value 可以是String、Number、BigDecimal的任意类型  
		 *  @throws Error 传入的String类型不是数字  
		 *  @throws Error 传入的类型不是String、Number、BigDecimal其中的一个类型  
		 * */  
		private function getNumber(value:*):Number{  
			var _num:Number = 0;  
			if(value is String){  
				if(new Number(value).toString()=="NaN"){  
					if(_validateStringThrow){  
						throw(new Error("值:"+value+" 不是正确的数字类型！"));  
					}else{  
						_doubleValue = 0;  
					}  
				}else{  
					_num = round(value);  
				}  
			}else if(value is Number){  
				_num = round(value.toString());  
			}else if(value is BigDecimal){  
				_num = round(value.doubleValue.toString());  
			}else{  
				throw(new Error("BigDecimal不支持此类型的数据："+value));  
			}  
			return _num;  
		}  
		
		
		/**  
		 *  将移除的小数点加上  
		 *  @throws _str  可以是String、Number的类型  
		 *  @throws _mDL 相乘后应该恢复的是双倍长度的保留小数长度 相除应该是0  加减就是保留小数长度  
		 * */  
		private function getDecimalNumber(_str:*,_mDL:Number = NaN):Number{  
			var str:String = _str.toString();  
			if(_mDL.toString()=="NaN") _mDL = _maxDecimalLength;  
			var _retrunValue:String = "";  
			if(str.length>_mDL){  
				var _indexOf:Number = str.indexOf(".");  
				if(_indexOf==-1){  
					_retrunValue = str.substring(0,str.length-_mDL)+"."+str.substring(str.length-_mDL,str.length);  
				}else{  
					str = str.replace(".","");  
					_retrunValue = str.substring(0,_indexOf-_mDL)+"."+str.substring(_indexOf-_mDL,str.length);  
				}  
			}else{  
				_retrunValue = "0.";  
				for (var i:int = 0; i <_mDL-str.length; i++)   
				{  
					_retrunValue += "0";  
				}  
				_retrunValue += str;  
			}  
			return new Number(_retrunValue);  
		}  
		
		
		/**  
		 *   将多出的小数点去掉  
		 *     
		 * */  
		private function getIntegerNumber(str:*):Number{  
			var _arr:Array = str.toString().split(".");  
			var _retrunValue:String = _arr[0].toString();  
			if(_arr.length>1){  
				_retrunValue += _arr[1].toString();  
				for (var i:int = _arr[1].toString().length; i < _maxDecimalLength; i++)   
				{  
					_retrunValue += "0";  
				}  
			}else{  
				for (var j:int = 0; j < _maxDecimalLength; j++)   
				{  
					_retrunValue += "0";  
				}  
			}  
			return new Number(_retrunValue);  
		}  
		
		/**  
		 * 四舍五入  
		 * */  
		public function round(value:String):Number{  
			var _arr:Array = value.split(".");  
			if(_arr.length>1&&_arr[1].toString().length>_maxDecimalLength){  
				var _arr0:String = _arr[0].toString();  
				var _arr1:String = _arr[1].toString();  
				var _v1:String = _arr0+_arr1.substring(0,_maxDecimalLength);  
				var _v2:String = _arr1.substring(_maxDecimalLength,_arr1.length);  
				
				while(true){  
					if(_v2.length == 1){  
						if(Number(_v2)>4){  
							_v1 = (new Number(_v1)+1).toString();  
						}  
						break;  
					}  
					if(Number(_v2.charAt(_v2.length-1))>4){  
						_v2 = (new Number(_v2.substring(0,_v2.length - 1))+1).toString();  
					}else{  
						_v2 = (new Number(_v2.substring(0,_v2.length - 1))).toString();  
					}  
					
				}  
				return getDecimalNumber(_v1);  
			}  
			return new Number(value);  
		}  
		
		/**  
		 * 相加   
		 * @param value 可以是String、Number、BigDecimal的任意类型  
		 * */  
		public function sum(value:*):Number{  
			var n1:Number = getIntegerNumber(doubleValue);  
			var n2:Number = getIntegerNumber(getNumber(value));  
			_doubleValue = getDecimalNumber(n1 + n2);  
			return _doubleValue;  
		}  
		
		/**  
		 * 相减    
		 * @param value 可以是String、Number、BigDecimal的任意类型  
		 * */  
		public function sub(value:*):Number{  
			var n1:Number = getIntegerNumber(doubleValue);  
			var n2:Number = getIntegerNumber(getNumber(value));  
			_doubleValue = getDecimalNumber(n1 - n2);  
			return _doubleValue;  
		}  
		
		/**  
		 * 相乘   
		 * @param value 可以是String、Number、BigDecimal的任意类型  
		 * */  
		public function mul(value:*):Number{  
			var n1:Number = getIntegerNumber(doubleValue);  
			var n2:Number = getIntegerNumber(getNumber(value));  
			_doubleValue = round(getDecimalNumber((n1 * n2),_maxDecimalLength*2).toString());  
			return _doubleValue;  
		}  
		
		
		/**  
		 * 相除   
		 * @param value 可以是String、Number、BigDecimal的任意类型  
		 * */  
		public function div(value:*):Number{  
			var n1:Number = getIntegerNumber(doubleValue);  
			var n2:Number = getIntegerNumber(getNumber(value));  
			if(n2==0){  
				_doubleValue = 0;  
			}else{  
				_doubleValue = round(getDecimalNumber((n1 / n2),0).toString());  
			}  
			return _doubleValue;  
		}  
		
		
	}  
}  