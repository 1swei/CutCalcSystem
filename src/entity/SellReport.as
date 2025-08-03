package entity{
	import common.DateFormatHelper;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class SellReport	{
		
		
		public function SellReport(){}
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		/*↓初始化销售报表的主界面.一条销售明细为一条报表,所以一个单号有可能有多条记录 ↓ */
		public static function findByParam(param:Object):ArrayCollection{
			var sql:String="select s.*,sd.* from Sell s,SellDetail sd where s.id=sd.sellId ";
			if(param.beginDate!=null){
				sql+=" and s.createTime>='"+DateFormatHelper.Format1(param.beginDate)+"' ";
			}
			if(param.endDate!=null){
				sql+=" and s.createTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,param.endDate as Date))+"' ";
			}
			if(param.cust != "所有客户"){
				sql+=" and s.custName = '"+param.cust+"'";
			}
			if(param.context!=null && param.context!=""){
				sql+=" and (materialName like '%"+param.context+"%' or code like '%"+param.context+"%' or sd.memo like '%"+param.context+"%')";
			}
			statement.text = sql;
			statement.itemClass=Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}	
}