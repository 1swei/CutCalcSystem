package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Colors
	{
		public var id:int;
		public var color:String="";
		public var state:String="Y";
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getColors():ArrayCollection
		{
			statement.text = "SELECT * from Colors where state='Y' ";
			statement.itemClass=Colors;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
	}
}