package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	/**存储订单上填写的变量,值*/
	[Bindable]
	public class OrderDetailBL
	{
		public var id:int;
		public var detailId:int;//订单明细id
		public var blName:String;//变量名
		public var blValue:Number;//值
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function getbyParam(detailid:int):ArrayCollection{
			statement.text = "SELECT * from OrderDetailBL where detailId="+detailid+" order by blName desc";
			statement.itemClass=OrderDetailBL;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function delBlbyParam(detailId:int):void{
			statement.text = "delete from OrderDetailBL where detailId="+detailId+" ";
			statement.execute();
		}
		
		public static function insert(item:OrderDetailBL):int
		{
			statement.text = "INSERT into OrderDetailBL(detailId,blName,blValue)"+
				"values("+item.detailId+",'"+item.blName+"',"+item.blValue+")";
			statement.execute();
			var result:SQLResult=statement.getResult();
			var item_id:int=result.lastInsertRowID;
			return item_id;
		}
		
		public static function update(item:OrderDetailBL):void
		{
			statement.text = "update OrderDetailBL set detailId="+item.detailId+",blName='"+item.blName+"',blValue="+item.blValue+" where id="+item.id;
			statement.execute();
		}
	}
}