package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Group
	{
		public function Group()
		{
		}
		public var id:int;
		public var name:String="";
		public var type:String="MTL";//目前只有物料组功能 type="MTL"
		public var isUsing:Boolean=true;//状态
		
		public var materials:ArrayCollection;
		public var materialsMsg:String="";
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function findAll(showNoUsing:Boolean,hasChildren:Boolean=false):ArrayCollection{
			var sql:String = "SELECT * from [Group]  ";
			if(!showNoUsing){
				sql+=" where isUsing=1";
			}
			statement.text = sql;
			statement.itemClass=Group;
			statement.execute();
			var result:ArrayCollection = new ArrayCollection(statement.getResult().data);
			if(hasChildren&&result&&result.length>0){
				for each(var item:Group in result){
					item.materials = MaterialGroup.findMtlsByGroupId(item.id);
					if(item.materials&&item.materials.length>0){
						for each(var mtl:Material in item.materials){
							item.materialsMsg+=mtl.brand+mtl.name+mtl.spec+"\n";
						}
					}
				}
			}
			return result;
		}
		
		public static function update(group:Group):void{
			statement.text="update [Group] set name='"+group.name+"',type='"+group.type+"',isUsing="+group.isUsing+" " +
				" where id="+group.id;
			statement.execute();
		}
		public static function insert(group:Group):int{
			statement.text="insert into [Group](name,type,isUsing)"+
				" values ('"+group.name+"','"+group.type+"',"+group.isUsing+")";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function del(id:int):void{
			statement.text = "delete from [Group] where id="+id;
			statement.execute();
			MaterialGroup.delByGroupId(id);
		}
	}
}