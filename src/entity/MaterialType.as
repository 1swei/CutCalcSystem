package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	[Bindable]
	public class MaterialType
	{
		public function MaterialType()
		{
		}
		public var id:int;
		public var name:String;
		public var code:String="";
		public var isUsing:Boolean;//是否在使用
		public var parentId:int;//上级类别id
		
		public var children:ArrayCollection;
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function findAll(showNoUsing:Boolean):ArrayCollection{
			var sql:String = "SELECT * from MaterialType ";
			if(!showNoUsing){
				sql+=" where isUsing=1";
			}
			statement.text = sql;
			statement.itemClass=MaterialType;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function update(type:MaterialType):void{
			statement.text="update MaterialType set name='"+type.name+"',code='"+type.code+"',isUsing="+type.isUsing+"" +
				",parentId="+type.parentId+" where id="+type.id;
			statement.execute();
		}
		public static function changeUsing(typeIds:ArrayCollection,using:Boolean):void{
			statement.text="update MaterialType set isUsing="+using+" where id in ("+typeIds+")";
			statement.execute();
		}
		public static function insert(type:MaterialType):int{
			statement.text="insert into MaterialType(name,code,isUsing,parentId)"+
						   " values ('"+type.name+"','"+type.code+"',"+type.isUsing+","+type.parentId+")";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function isRepeat(type:MaterialType):Boolean{
			statement.text = "SELECT * from MaterialType where name='"+type.name+"' and id<>"+type.id+" limit 1 ";
			statement.itemClass=MaterialType;
			statement.execute();
			return statement.getResult().data!=null;
		}
		public static function del(typeIds:ArrayCollection):void{
			statement.text="delete from MaterialType where id in ("+typeIds+") ";
			statement.execute();
		}
		public static function buildTree(list:ArrayCollection, parentId:int):ArrayCollection{
			var _materialTypes:ArrayCollection = new ArrayCollection();
			for (var i:int=0;i<list.length;i++) {
				var id:int = (list[i] as MaterialType).id;
				var upperId:int = (list[i] as MaterialType).parentId;
				if (parentId == upperId) {
					var types:ArrayCollection = buildTree(list, id);
					
					(list[i] as MaterialType).children=types;
					_materialTypes.addItem(list[i] as MaterialType);
				}
			}
			return _materialTypes;
		}
		
	}
}