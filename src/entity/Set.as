package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.core.FlexGlobals;

	[Bindable]
	public class Set
	{
		public function Set()
		{
		}
		//字体
		public static const FONTSIZE:String = "systemFontSize";
		//颜色
		public static const COLOR:String = "systemColor";
		public var id:int;
		public var key:String;
		public var value:String;
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function findByKey(key:String):Set{
			var sql:String="select * from [Set] where key='"+key+"' limit 1";
			statement.itemClass=Set;
			statement.text = sql;
			statement.execute();
			var array:Array = statement.getResult().data;
			if(array!=null&&array.length>0){
				return array[0] as Set;
			}
			return null;
		}
		public static function insert(_item:Set):int{
			statement.text = "insert into [Set](key,value) values('"+_item.key+"','"+_item.value+"')";
			statement.execute();
			var result:SQLResult=statement.getResult();
			_item.id=result.lastInsertRowID;
			return _item.id;
		}
		public static function insertOrUpdate(key:String,value:String):Set{
			var local:Set = Set.findByKey(key);
			if(local==null){
				local = new Set();
			}
			local.key=key;
			local.value=value;
			
			if(local.id==0){
				insert(local);
			}else{
				update(local);
			}
			return local;
		}
		public static function update(_item:Set):void{
			statement.text = "update [Set] set value='"+_item.value+"' where key='"+_item.key+"'";
			statement.execute();
		}
		
		public static function deleteByKey(key:String):void{
			statement.text = "delete from [Set] where key = '"+key+"' ";
			statement.execute();
		}
	}
}