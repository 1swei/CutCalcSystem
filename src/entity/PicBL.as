package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	/**图片变量*/
	public class PicBL
	{
		public var id:int;
		public var picName:String;//窗型图名称,带后缀
		public var blName:String;//变量名
		public var blX:Number;//变量在图中显示的X坐标
		public var blY:Number;
		public var picWidth:Number;//创建变量的时候实际的图片宽
		public var picHeight:Number;//创建变量的时候实际的图片高
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function getBlbyParam(picName:String):ArrayCollection{
			statement.text = "SELECT * from PicBL where picName='"+picName+"' order by blName desc";
			statement.itemClass=PicBL;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function delBlbyParam(picName:String):void{
			statement.text = "delete from PicBL where picName='"+picName+"' ";
			statement.execute();
		}
		
		public static function insert(item:PicBL):int
		{
			statement.text = "INSERT into PicBL(picName,blName,blX,blY,picWidth,picHeight)"+
				"values('"+item.picName+"','"+item.blName+"',"+item.blX+","+item.blY+","+item.picWidth+","+item.picHeight+")";
			statement.execute();
			var result:SQLResult=statement.getResult();
			var item_id:int=result.lastInsertRowID;
			return item_id;
		}
		
		
	}
}