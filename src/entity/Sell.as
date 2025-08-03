package entity
{
	import common.Common;
	import common.DateFormatHelper;
	
	import entity.enum.DataState;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Sell
	{
		public function Sell()
		{
		}
		public var id:int;
		public var code:String="";
		public var custId:int;//客户id
		public var custName:String="";
		public var custPhone:String="";
		public var custAddress:String="";
		public var memo:String="";
		public var state:String=DataState.SAVED;
		public var amount:Number=0;//总金额
		public var createTime:String="";
		public var isSaved:Boolean=false;//从订单过来后是否保存过
		
		public var rowid:int=0;
		public var check:Boolean=false;
		public var details:ArrayCollection=new ArrayCollection();
		public var delDetails:ArrayCollection;
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function findAll():ArrayCollection
		{
			statement.text = "SELECT * from Sell ";
			statement.itemClass=Sell;
			statement.execute();
			return Common.setRowNo(new ArrayCollection(statement.getResult().data));
		}
		public static function findByParam(param:Object):ArrayCollection
		{
			var sql:String="select * from sell s where 1=1";
			if(param.customer!=null&&param.customer!=""){
				sql+=" and custName like '%"+param.customer+"%'";
			}
			if(param.beginDate!=null){
				sql+=" and createTime>='"+DateFormatHelper.Format1(param.beginDate)+"' ";
			}
			if(param.endDate!=null){
				sql+=" and createTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,param.endDate as Date))+"' ";
			}
			sql+=" and state in (''";
			if(param[DataState.SAVED]){
				sql+=",'"+DataState.SAVED+"'";
			}
			if(param[DataState.FINISHED]){
				sql+=",'"+DataState.FINISHED+"'";
			}
			if(param[DataState.DELETED]){
				sql+=",'"+DataState.DELETED+"'";
			}
			sql+=" )";
			if(param.context!=null&&param.context!=""){
				sql+=" and (exists(select 1 from SellDetail where sellid=s.id and (materialName like '%"+param.context+"%' or memo like '%"+param.context+"%'))";
				sql+=" or memo like '%"+param.context+"%')";
			}
			statement.text = sql;
			statement.itemClass=Sell;
			statement.execute();
			return Common.setRowNo(new ArrayCollection(statement.getResult().data));
		}
		public static function insert(item:Sell):int{
			statement.text="insert into Sell(code,custId,custName,custPhone,custAddress,memo,state,amount,createTime)"+
				" values ('"+item.code+"',"+item.custId+",'"+item.custName+"','"+item.custPhone+"','"+item.custAddress+"','"+item.memo+"','"+item.state+"',"+item.amount+",'"+item.createTime+"')";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function update(item:Sell):void{
			statement.text="update Sell set code='"+item.code+"',custId="+item.custId+",custName='"+item.custName+"' " +
				",custPhone='"+item.custPhone+"',custAddress='"+item.custAddress+"',memo='"+item.memo+"',state='"+item.state+"',amount="+item.amount+" where id="+item.id;
			statement.execute();
		}
		public static function changeState(id:int,state:String):void{
			statement.text = "update Sell set state='"+state+"' where id="+id;
			statement.execute();
			//SellDetail.deleteByFK(id);
		}
		public static function changeStateAll(ids:Array,state:String):void{
			statement.text = "update Sell set state='"+state+"' where id in ("+ids+")";
			statement.execute();
		}
		public static function getSell(id:int):Sell{
			statement.text = "SELECT * from Sell where id="+id;
			statement.itemClass=Sell;
			statement.execute();
			var arr:ArrayCollection=new ArrayCollection(statement.getResult().data);
			if(arr==null||arr.length==0){
				return new Sell();
			}
			var sell:Sell=arr.getItemAt(0) as Sell;
			sell.details=SellDetail.findBySellId(id);
			return sell;
		}
	}
}