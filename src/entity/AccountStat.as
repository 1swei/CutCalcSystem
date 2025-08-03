package entity
{
	import common.DateFormatHelper;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	/**对账表*/
	[Bindable]
	public class AccountStat
	{
		public function AccountStat()
		{
		}
		//目前默认客户销售单,应收款,供应商默认采购单,应付款
		public var id:int;
		public var accType:int;//0 客户  1 供应商
		public var accName:String="";//客户名/供应商名 
		public var amountType:int;//0应收 1应付
		public var code:String="";//单据号
		public var createTime:String="";
		public var amount:Number=0;//应(收/付)金额
		public var realAmount:Number=0;//实际(收/付)金额
		public var smallAmount:Number=0;//抹零
		public var source:int;//来源0:手动新建  1:数据流转自动生成
		public var memo:String="";//备注
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		/*public static function create():AccountStat{
			var account:AccountStat=new AccountStat;
			account.
		}*/
		/**销售单完成生成收款记录*/
		public static function createBySell(sell:Sell):void{
			var item:AccountStat = new AccountStat();
			item.accType = 0;
			item.accName = sell.custName;
			item.amountType = 0;
			item.code = sell.code;
			item.createTime = DateFormatHelper.Format10(new Date());
			item.amount = sell.amount;
			item.realAmount = 0;
			item.smallAmount = 0;
			item.source = 1;
			item.memo = "";
			insert(item);
		}
		/**采购单完成生成付款记录 
		 * 
		 * 采购暂时不需要,直接到对账里录入*/
		public static function createByPur(purchase:InfoMsg):void{
			
		}
		public static function findAll():ArrayCollection
		{
			statement.text = "SELECT * from AccountStat ";
			statement.itemClass=AccountStat;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function findByParam(param:Object):ArrayCollection{
			var sql:String="select * from AccountStat where 1=1 ";
			if(param.beginDate!=null){
				sql+=" and createTime>='"+DateFormatHelper.Format1(param.beginDate)+"' ";
			}
			if(param.endDate!=null){
				sql+=" and createTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,param.endDate as Date))+"' ";
			}
			if(param.state==0&&param.nameText != "客户"&&param.nameText!=null&&param.nameText!=""){
				sql+=" and accName = '"+param.nameText+"'";
			}
			if(param.context!=null&&param.context!=""){
				sql+=" and (memo like '%"+param.context+"%' or accName like '%"+param.context+"%')";
			}
			sql+=" and accType = "+param.state;
			statement.text = sql;
			statement.itemClass=AccountStat;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function insert(item:AccountStat):int{
			statement.text="insert into AccountStat(accType,accName,amountType,code,createTime,amount,realAmount,smallAmount,source,memo)"+
				" values ("+item.accType+",'"+item.accName+"',"+item.amountType+",'"+item.code+"','"+item.createTime+"',"+item.amount+","+item.realAmount+","+item.smallAmount+","+item.source+",'"+item.memo+"')";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function update(item:AccountStat):void{
			statement.text="update AccountStat set accType="+item.accType+",accName='"+item.accName+"',amountType="+item.amountType+" " +
				",code='"+item.code+"',createTime='"+item.createTime+"',amount="+item.amount+",realAmount="+item.realAmount+",smallAmount="+item.smallAmount+",source='"+item.source+"',memo='"+item.memo+"' where id="+item.id;
			statement.execute();
		}
	}
}