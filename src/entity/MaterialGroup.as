package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class MaterialGroup
	{
		//该表无主键
		public function MaterialGroup()
		{
		}
		public var groupId:int;
		public var materialId:int;
		public var order:int;
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;

		public static function findMtlsByGroupId(groupId:int):ArrayCollection{
			var sql:String = "select mtl.* from Material mtl,MaterialGroup mtlGroup where mtl.id=mtlGroup.materialId" +
				" and groupId="+groupId+" order by [order]";
			statement.text = sql;
			statement.itemClass=Material;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function insert(mg:MaterialGroup):int{
			statement.text="insert into MaterialGroup(groupId,materialId,[order])"+
				" values ("+mg.groupId+","+mg.materialId+","+mg.order+")";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function delByGroupId(groupId:int):void{
			statement.text = "delete from MaterialGroup where groupId="+groupId;
			statement.execute();
		}
		
	}
}