package entity
{
	import common.DateFormatHelper;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	[Bindable]
	public class Invocie
	{
		public function Invocie()
		{
		}
		public var id:int;
		public var fpdw:String;//开票单位(老章/玉乾)
		public var khName:String;//客户
		public var ttName:String;//发票抬头
		public var money:Number;//开票金额
		public var fpCode:String;//发票号
		public var sl:Number;//税率
		public var isKP:Boolean=false;//是否开票
		public var isDZ:Boolean=false;//是否到账
		public var createTime:Date;//开票时间
		public var memo:String;//备注
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getInvocies():ArrayCollection
		{
			statement.text = "SELECT * from Invocie ";
			statement.itemClass=Invocie;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function findByParam(param:Object):ArrayCollection{
			var sql:String="select * from Invocie where 1=1 ";
			if(param.beginDate!=null){
				sql+=" and createTime>='"+DateFormatHelper.Format1(param.beginDate)+"' ";
			}
			if(param.endDate!=null){
				sql+=" and createTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,param.endDate as Date))+"' ";
			}
			if(param.khName != "客户"&&param.khName!=null&&param.khName!=""){
				sql+=" and khName like '%"+param.khName+"%'";
			}
			if(param.context!=null&&param.context!=""){
				sql+=" and (memo like '%"+param.context+"%' or ttName like '%"+param.context+"%' or fpCode like '%"+param.context+"%')";
			}
			sql+=" and isKP = "+param.isKP;
			sql+=" and isDZ = "+param.isDZ;
			statement.text = sql;
			statement.itemClass=AccountStat;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
	}
}