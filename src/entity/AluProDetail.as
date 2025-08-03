package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class AluProDetail
	{
		
		public function AluProDetail()
		{
		}
		public var id:int;
		public var aluProId:int;
		public var name:String="";//材料名
		public var unitWeight:Number=0;//公斤/M 单玻
		public var unitWeightDouble:Number=0;//公斤/M 单玻
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getAluProsById(_aluId:int):ArrayCollection
		{
			statement.text = "SELECT * from AluProDetail where aluProId="+_aluId;
			statement.itemClass=AluProDetail;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		/**以nameStart开始的名字*/
		public static function getAluProByIdAndName(_aluId:int,nameStart:String):ArrayCollection
		{
			statement.text = "SELECT * from AluProDetail where aluProId="+_aluId+" and name like '%"+nameStart+"%' ";
			statement.itemClass=AluProDetail;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function getAluProByIdAndNameStart(_aluId:int,nameStart:String):AluProDetail
		{
			//根据型材id，获取所有型材下的料名
			var aluList:ArrayCollection  = getAluProsById(_aluId);
			if(aluList==null||aluList.length==0){
				return null;
			}
			for(var i:int = 0;i<aluList.length;i++){
				var item :AluProDetail = aluList.getItemAt(i) as AluProDetail;
				if(item.name!=null&&nameStart.indexOf(item.name)==0){
					return item;
				}
			}
			return null;
		}
		
		
		
		public static function update(item:AluProDetail):void
		{
			statement.text = "update AluProDetail set name='"+item.name+"',unitWeight="+item.unitWeight+",unitWeightDouble="+item.unitWeightDouble+" where id="+item.id;
			statement.execute();
		}
		public static function detele(id:int):void
		{
			statement.text = "delete from AluProDetail where id="+id+"";
			statement.execute();
		}
		
		public static function deteleByAluId(_aluId:int):void
		{
			statement.text = "delete from AluProDetail where aluProId="+_aluId+"";
			statement.execute();
		}
		public static function insert(item:AluProDetail):int
		{
			statement.text = "INSERT into AluProDetail(aluProId,name,unitWeight,unitWeightDouble) values("+item.aluProId+",'"+item.name+"',"+item.unitWeight+","+item.unitWeightDouble+")";
			statement.execute();
			var result:SQLResult=statement.getResult();
			var theId:int=result.lastInsertRowID;
			return theId;
		}
		
	}
}