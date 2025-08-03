package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Customer
	{
		public function Customer()
		{
		}
		public var id:int;
		public var name:String="";//客户名字
		public var code:String="";//编码 
		public var typeId:int=0;//客户类型id 
		public var state:String="Y";//是否启用
		public var type:int=0;//0 客户  1供应商
		public var address:String="";
		public var phone:String="";
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getCustomers():ArrayCollection
		{
			statement.text = "SELECT * from Customer where state='Y' and type=0 order by name";
			statement.itemClass=Customer;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		//statement.getResult().data是个数组
		public static function getCustomerByName(name:String):ArrayCollection{
			statement.text = "SELECT * from Customer where state='Y' and type=0 and name ='"+name+"' limit 1 ";
			statement.itemClass=Customer;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function insert(item:Customer):void{
			statement.text = "insert into Customer(name,state,type,address,phone,code,typeId)"+
				"values('"+item.name+"','"+item.state+"','"+0+"','"+item.address+"','"+item.phone+"','"+item.code+"','"+0+"')";
			statement.execute();
			var result:SQLResult=statement.getResult();
			var id:int=result.lastInsertRowID;
			item.id=id;
		}
		public static function update(item:Customer):void{
			statement.text = "update Customer set name='"+item.name+"',state='"+item.state+"',address='"+item.address+
				"',phone='"+item.phone+"',code='"+item.code+"' where id="+item.id;
			statement.execute();
		}
		
	}
}