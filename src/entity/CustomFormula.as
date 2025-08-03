package entity
{
	import TitleWindows.CustomFormulaDoc;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class CustomFormula
	{
		public var id:int;
		public var aluProId:int;//型材id
		public var windowsPicName:String;//窗型图名称,带后缀
		public var materialName:String="";//小料名
		public var amount:int;//小料根数
		public var type:int;//0外框 1内扇 2玻璃
		public var formula:String;//公式
		public var orderNum:int;//排序
		public var tag:String="";//描述符  目前用来描述几种料各有多少跟。存 “各”字
		
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;

		public static function clone(theItem:CustomFormula):CustomFormula{
			var newItem:CustomFormula = new CustomFormula;
			newItem.aluProId=theItem.aluProId;
			newItem.windowsPicName=theItem.windowsPicName;
			newItem.materialName=theItem.materialName;
			newItem.amount=theItem.amount;
			newItem.type=theItem.type;
			newItem.formula=theItem.formula;
			newItem.orderNum=theItem.orderNum;
			newItem.tag=theItem.tag;
			return newItem;
		}
		public static function getCustomFormulasByParam(aluProId:int,windowsName:String):ArrayCollection{
			statement.text = "SELECT * from CustomFormula where aluProId="+aluProId+" and windowsPicName='"+windowsName+"' order by orderNum";
			statement.itemClass=CustomFormula;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function update(item:CustomFormula):void
		{
			statement.text = "update CustomFormula set aluProId='"+item.aluProId+"',windowsPicName='"+item.windowsPicName+"',materialName='"+item.materialName+"',amount="+item.amount+",type="+item.type+
				",formula='"+item.formula+"',orderNum="+item.orderNum+",tag='"+item.tag+"' where id="+item.id;
			statement.execute();
		}
		
		public static function insert(item:CustomFormula):int
		{
			statement.text = "INSERT into CustomFormula(aluProId,windowsPicName,materialName,amount,type, formula,orderNum,tag)"+
				"values("+item.aluProId+",'"+item.windowsPicName+"','"+item.materialName+"',"+item.amount+","+item.type+",'"+item.formula+"',"+item.orderNum+",'"+item.tag+"')" ;
			statement.execute();
			var result:SQLResult=statement.getResult();
			var item_id:int=result.lastInsertRowID;
			return item_id;
		}
		public static function deleted(item:CustomFormula):void
		{
			statement.text = "delete from CustomFormula where id="+item.id+" ";
			statement.execute();
		}
		public static function deletedByAluProId(aluproId:int):void
		{
			statement.text = "delete from CustomFormula where aluProId="+aluproId+" ";
			statement.execute();
		}
		
	}
}