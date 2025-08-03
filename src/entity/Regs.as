package entity
{
	import flash.data.SQLStatement;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import common.MyEncrypt;
	
	[Bindable]
	public class Regs
	{
		public var id:int;
		public var value:String="";
		public var state:String="Y";
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getRegs():ArrayCollection
		{
			statement.text = "SELECT * from Regs where state='Y' ";
			statement.itemClass=Regs;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function delRegs():void
		{
			statement.text = "delete from Regs ";
			statement.execute();
		}
		public static function insertRegs(code:String):void
		{
			statement.text = "INSERT into Regs(value,state) values('"+code+"','Y')" ;
			statement.execute();
		}
		/**校验是否注册*/
		public static function checkSys():Boolean{
			var result:Boolean = false;
			var regsArray:ArrayCollection=Regs.getRegs();
			if(regsArray!=null&&regsArray.length>0){
				var reg:Regs=regsArray.getItemAt(0) as Regs;
				if(reg!=null&&(MyEncrypt.encode0to3(MyEncrypt.getNativeEncrypt())==reg.value)){
					result=true;
				}
			}
			//取消注册机制 全部返回true
			return true;
		}
	}
}