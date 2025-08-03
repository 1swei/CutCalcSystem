package common.db
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class DBUtil
	{
		public function DBUtil()
		{
		}
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function isFieldExist(tableName:String,fieldName:String):Boolean {
			var queryStr:String = "select sql from sqlite_master where type = 'table' and name = '"+tableName+"'";
			statement.text=queryStr;
			statement.execute();
			var result:ArrayCollection=new ArrayCollection(statement.getResult().data);
			
			return false;
		}
		public static function exeMore(sql:String):void{
			var parts:Array = sql.split( ';' ); 
			for( var i:int; i<parts.length; i++ ) {
				if ( '' != parts[i] ) { 
					statement.text = parts[i] + ';'; 
					statement.execute();   
				}
			}
		}
		
	}
}