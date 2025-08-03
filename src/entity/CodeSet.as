package entity
{
	import common.DateFormatHelper;
	
	import entity.CodeSet;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	[Bindable]
	public class CodeSet
	{
		public function CodeSet()
		{
		}
		public var id:int;
		public var name:String;//编号的单据名
		public var code:String;//编码开头字母
		public var body:int;//年月日
		public var format:String;//yyMMdd
		public var repeat:int;//结帐日(哪天开始重复计算,只有yyMM的时候才需要)
		public var max:int;//当前编码最大值
		public var digit:int;//编码计数位数
		public var module:String;//模块
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function findAll():ArrayCollection
		{
			statement.text = "SELECT * from CodeSet";
			statement.itemClass=CodeSet;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function getCodeByModule(module:String):CodeSet{
			statement.text = "SELECT * from CodeSet where module='"+module+"' ";
			statement.itemClass=CodeSet;
			statement.execute();
			var result:ArrayCollection=new ArrayCollection(statement.getResult().data);
			if(result!=null&&result.length>0){
				return result.getItemAt(0) as CodeSet;
			}
			return null;
		}
		public static function insert(code:CodeSet):int
		{
			statement.text = "insert into CodeSet(name,code,body,format,repeat,max,digit,module) values " +
				"('"+code.name+"','"+code.code+"',"+code.body+",'"+code.format+"',"+code.repeat+","+code.max+","+code.digit+",'"+code.module+"')";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function update(code:CodeSet):void{
			statement.text = "update CodeSet set name='"+code.name+"',code='"+code.code+"',body="+code.body+",format='"+code.format+"',repeat="+code.repeat+
				",max="+code.max+",digit="+code.digit+",module='"+code.module+"' where id="+code.id;
			statement.execute();
		}
		/**通过模块,日期编号 (一般日期都是系统当前时间)*/
		public static function getCode(module:String,date:Date=null):String{
			var theCode:CodeSet=getCodeByModule(module);
			if(theCode==null){
				return "";
			}
			if(!theCode.code){
				return "";
			}
			if(date==null){
				date=new Date();
			}
			var newCode:String;
			//头部(字母段)
			newCode=theCode.code;
			//中间段(时间段)
			var bodyCode:int = getBodyCode(theCode,date);
			newCode+=bodyCode;
			//尾部(计数段)不足位数补0
			var lastStr:String="1";
			if(bodyCode==theCode.body){
				lastStr = (theCode.max+1).toString();
			}
			for (var i:int = lastStr.length; i < theCode.digit; i++) {
				newCode+="0";
			}
			newCode+=lastStr;
			//更新计数
			updateCode(theCode,bodyCode);
			return newCode;
		}
		/**自动编码(时间段)*/
		private static function getBodyCode(code:CodeSet,date:Date):int{
			var result:int = int(DateFormatHelper.FormatCust(date,code.format));
			//年月的时候,考虑立账日(>0),到了某个月的这天,自动月份+1重新编码
			if("YYMM"==code.format&&code.repeat>0){
				var day:int = int(DateFormatHelper.FormatCust(date,"DD"));
				if(code.repeat<day){
					result = int(DateFormatHelper.FormatCust(DateFormatHelper.addMonth(date,1),code.format));
				}
			}
			return result;
		}
		private static function updateCode(code:CodeSet,  body:int):void{
			//若当前body编码和数据库的不匹配(新的 日/月份/年份),则覆盖并清空计数
			if(body!=code.body){
				code.body=body;
				code.max=0;
			}
			code.max=code.max+1;
			update(code);
		}
		
	}
}