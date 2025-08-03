package common
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberFormatter;
	
	import spark.components.TextInput;

	public class DateFormatHelper
	{
		public function DateFormatHelper()
		{
		}
		private static var format:DateFormatter;
		private static var format1:DateFormatter;
		private static var format2:DateFormatter;
		private static var format3:DateFormatter;
		private static var format4:DateFormatter;
		
		private static var format5:DateFormatter;
		private static var format6:DateFormatter;
		private static var format7:DateFormatter;
		private static var format8:DateFormatter;
		private static var format9:DateFormatter;
		private static var format10:DateFormatter;
		private static var format11:DateFormatter;
		private static var format12:DateFormatter;
		private static var format13:DateFormatter;
		/**
		 * YYYY-MM-DD
		 * */
		public static function Format1(obj:Object,col:DataGridColumn=null):String{
			if(format1==null){
				format1=new DateFormatter();
				format1.formatString="YYYY-MM-DD";
			}
			if(col!=null){
				return format1.format(obj[col.dataField]);
			}else if(obj!=null){
				return format1.format(obj);
			}else{
				return "";
			}
		}
		public static function FormatCust(date:Date,formatStr:String="YYMMDD"):String{
			if(format==null){
				format=new DateFormatter();
			}
			format.formatString=formatStr;
			return format.format(date);
		}
		/**
		 * YYYY-MM-DD
		 * */
		public static function Format1_1(obj:Object,col:DataGridColumn=null):String{
			if(format10==null){
				format10=new DateFormatter();
				format10.formatString="MM月DD日";
			}
			if(col!=null){
				return format10.format(obj[col.dataField]);
			}else if(obj!=null){
				return format10.format(obj);
			}else{
				return "";
			}
		}
		
		/**
		 * YYYY-MM-DD JJ:NN
		 * */
		public static function Format2(obj:Object,col:DataGridColumn=null):String{
			if(format2==null){
				format2=new DateFormatter();
				format2.formatString="YYYY/MM/DD JJ:NN";
			}
			if(col!=null){
				return format2.format(obj[col.dataField]);
			}else if(obj!=null){
				return format2.format(obj);
			}else{
				return "无";
			}
			
		}
		/**
		 * MM-DD JJ:NN
		 * */
		public static function Format3(obj:Object,col:DataGridColumn=null):String{
			if(format3==null){
				format3=new DateFormatter();
				format3.formatString="MM-DD JJ:NN";
			}
			if(col!=null){
				return format3.format(obj[col.dataField]);
			}else if(obj!=null){
				return format3.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * MM-DD JJ:NN
		 * */
		public static function Format6(obj:Object,col:DataGridColumn=null):String{
			if(format6==null){
				format6=new DateFormatter();
				format6.formatString="MM-DD JJ";
			}
			if(col!=null){
				return format6.format(obj[col.dataField]);
			}else if(obj!=null){
				return format6.format(obj);
			}else{
				return "无";
			}
		}
		/**
		 * YYMMDD
		 * */
		public static function Format4(obj:Object,col:DataGridColumn=null):String{
			if(format4==null){
				format4=new DateFormatter();
				format4.formatString="YYMMDD";
			}
			if(col!=null){
				return format4.format(obj[col.dataField]);
			}else if(obj!=null){
				return format4.format(obj);
			}else{
				return "无";
			}
		}
		
		public static function Format5(obj:Object,col:DataGridColumn=null):String{
			if(format5==null){
				format5=new DateFormatter();
				format5.formatString="MM-DD";
			}
			
			if(col!=null){
				return format5.format(obj[col.dataField]);
			}else if(obj!=null){
				return format5.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * YYYY-MM-DD JJ:NN:SS
		 * */
		public static function Format7(obj:Object,col:DataGridColumn=null):String{
			if(format7==null){
				format7=new DateFormatter();
				format7.formatString="YYYY-MM-DD JJ:NN:SS";
			}
			if(col!=null){
				return format7.format(obj[col.dataField]);
			}else if(obj!=null){
				return format7.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * MM
		 * */
		public static function Format8(obj:Object,col:DataGridColumn=null):String{
			if(format8==null){
				format8=new DateFormatter();
				format8.formatString="MM";
			}
			if(col!=null){
				return format8.format(obj[col.dataField]);
			}else if(obj!=null){
				return format8.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * DD
		 * */
		public static function Format11(obj:Object,col:DataGridColumn=null):String{
			if(format11==null){
				format11=new DateFormatter();
				format11.formatString="DD";
			}
			if(col!=null){
				return format11.format(obj[col.dataField]);
			}else if(obj!=null){
				return format11.format(obj);
			}else{
				return "无";
			}
		}
		/**
		 * YYYY
		 * */
		public static function Format9(obj:Object,col:DataGridColumn=null):String{
			if(format9==null){
				format9=new DateFormatter();
				format9.formatString="YYYY";
			}
			if(col!=null){
				return format9.format(obj[col.dataField]);
			}else if(obj!=null){
				return format9.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * YYYY-MM-DD JJ:NN
		 * */
		public static function Format10(obj:Object,col:DataGridColumn=null):String{
			if(format2==null){
				format2=new DateFormatter();
				format2.formatString="YYYY-MM-DD JJ:NN";
			}
			if(col!=null){
				return format2.format(obj[col.dataField]);
			}else if(obj!=null){
				return format2.format(obj);
			}else{
				return "无";
			}
			
		}
		
		/**
		 * YYYY-MM-DD JJ:NN
		 * */
		public static function parse10(str:String):Date{
			return DateFormatter.parseDateString(str);
		}
		
		
		/**
		 * */
		public static function Format13(obj:Object,col:DataGridColumn=null):String{
			if(format13==null){
				format13=new DateFormatter();
				format13.formatString="YYYYMMDDJJNNSS";
			}
			if(col!=null){
				return format13.format(obj[col.dataField]);
			}else if(obj!=null){
				return format13.format(obj);
			}else{
				return "无";
			}
			
		}
		
		/**
		 * NN
		 * */
		public static function Format12(obj:Object,col:DataGridColumn=null):String{
			if(format12==null){
				format12=new DateFormatter();
				format12.formatString="NN";
			}
			if(col!=null){
				return format12.format(obj[col.dataField]);
			}else if(obj!=null){
				return format12.format(obj);
			}else{
				return "无";
			}
		}
		/**
		 * YYYY-MM-DD
		 * */
		public static function AdvancedFormat1(obj:Object,col:AdvancedDataGridColumn=null):String{
			if(format1==null){
				format1=new DateFormatter();
				format1.formatString="YYYY-MM-DD";
			}
			if(col!=null){
				return format1.format(obj[col.dataField]);
			}else if(obj!=null){
				return format1.format(obj);
			}else{
				return "";
			}
			
		}
		
		/**
		 * YYYY-MM-DD JJ:NN
		 * */
		public static function AdvancedFormat2(obj:Object,col:AdvancedDataGridColumn=null):String{
			if(format2==null){
				format2=new DateFormatter();
				format2.formatString="YYYY/MM/DD JJ:NN";
			}
			if(col!=null){
				return format2.format(obj[col.dataField]);
			}else if(obj!=null){
				return format2.format(obj);
			}else{
				return "无";
			}
		}
		
		/**
		 * YYYY-MM-DD
		 * */
		public static function AdvancedFormat3(obj:Object,col:AdvancedDataGridColumn=null):String{
			if(format1==null){
				format1=new DateFormatter();
				format1.formatString="YYYY-MM-DD JJ:NN";
			}
			if(col!=null){
				return format1.format(obj[col.dataField]);
			}else if(obj!=null){
				return format1.format(obj);
			}else{
				return "";
			}
			
		}
		public static function getDate_JJ(date:Date):Number{
			return date.getHours();
		}
		public static function getDate_NN(date:Date):Number{
			return date.getMinutes();
		}
		/**
		 * 多少天之前
		 * day
		 * */
		public static function getDateBefore(day:int):Date
		{
			var d: Date = new Date();
			return new Date( d.getFullYear(), d.getMonth(), Number( d.getDate() - day));
		}
		/**
		 * 多少天之后
		 * day
		 * */
		public static function getDateAfter(day:int,d:Date=null):Date
		{
			if(d==null){
				 d = new Date();
			}
			return new Date( d.getFullYear(), d.getMonth(), Number( d.getDate() + day));
		}
		public static function addMonth(d:Date,month:int):Date
		{
			return new Date( d.getFullYear(), d.getMonth()+month, Number( d.getDate() ));
		}
		public static function focus(e:Event):void{
			var t1:mx.controls.TextInput;
			var t2:spark.components.TextInput;
			if(e.currentTarget is spark.components.TextInput){
				t2=e.currentTarget as spark.components.TextInput;
				if(t2.text.length>0){
					t2.selectAll();
				}
			}else if(e.currentTarget is mx.controls.TextInput){
				t1=e.currentTarget as mx.controls.TextInput;
				if(t1.text.length>0){
					t1.setSelection(0,t1.text.length);
				}
				
			}
		}
		//获取日期间隔
		public static function getDays(begin:Date,end:Date):ArrayCollection{
			var result:ArrayCollection = new ArrayCollection();
			var diff:int = diff(begin,end);
			if(diff>0){
				for(var i=0;i<diff;i++){
					result.addItem(begin);
					begin = getDateAfter(1,begin);
				}
			}
			return result;
		}
		public static const CHINESE_DATE_FORMAT:String="YYYY-MM-DD";
		public static function stringToDate(dateString:String, formatString:String=CHINESE_DATE_FORMAT):Date   
		{   
			return DateField.stringToDate(dateString,formatString);   
		}  
		public static function diff(begin:Date,end:Date):int{
			
			var num1:Number =begin.valueOf();
			
			var num2:Number =end.valueOf();
			
			var different:Number = num2-num1;
			var diffDay:int = int(different/24/60/60/1000);
			return diffDay;
		}
		
	}
}