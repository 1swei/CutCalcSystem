package entity
{
	import common.DateFormatHelper;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Orders
	{
		//主表基本信息
		public var rowid:int;
		public var id:int;
		public var khName:String="";
		public var khPhone:String="";
		public var khAddress:String="";
		public var xdTime:String;
		public var stateOut:String="N";//外框状态
		public var stateIn:String="N";//内扇状态
		public var zhaiyao:String="";//自动生成的摘要
		public var bz:String="";
		public var checked:Boolean=false;
		public var printTimes:int=0;//打印次数
		//不存数据库
		public var area:Number=0;//总面积 平方米
		public var list:ArrayCollection;
		public var delList:ArrayCollection;
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function updatePrintTimes(id:int):void{
			statement.text = "update Orders set printTimes=ifnull(printTimes,0)+1 where id="+id;			
			statement.execute();
		}
		
		
		public static function getOrders(begin:Date,end:Date):ArrayCollection{
			var sql:String = "SELECT * from Orders where 1=1 ";
			if(begin!=null){
				sql += " and xdTime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and xdTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			
			statement.text = sql;
			statement.itemClass=Orders;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		
		public static function getOrdersSum(begin:Date,end:Date):ArrayCollection{
			var sql:String = "SELECT count(id) as num,date(xdTime) as date from Orders where 1=1 ";
			if(begin!=null){
				sql += " and xdTime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and xdTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			sql+=" group by date(xdTime) order by xdTime"
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function getOrdersPfSum(begin:Date,end:Date):ArrayCollection{
			var sql:String = " SELECT ROUND(sum(d.num * ifnull( ( d.width * d.height * 0.0001 ), 0 )),2) num ,date(xdTime) as date from Orders o"+
															" left join "+
								" (select d.orderId, d.num,ifnull(d.width,0) width ,height from OrderDetails d"+
								" )d on o.id=d.orderid where 1=1 ";
			if(begin!=null){
				sql += " and xdTime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and xdTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			sql+=" group by date(xdTime) order by xdTime"
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function getOrdersAreaSum(begin:Date,end:Date):ArrayCollection{
			var sql:String = "SELECT count(id) as num,date(xdTime) as date from Orders where 1=1 ";
			if(begin!=null){
				sql += " and xdTime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and xdTime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			sql+=" group by date(xdTime) order by xdTime"
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		
		public static function getOrdersYearSum(year:String):ArrayCollection{
			var sql:String = "select count(id) as num,SUBSTR(xdTime,1,7)  as date from orders where xdTime like '"+year+"-%' group by SUBSTR(xdTime,1,7) order by xdTime";
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		public static function getOrdersPfYearSum(year:String):ArrayCollection{
			var sql:String = "SELECT ROUND(sum(d.num * ifnull( ( d.width * d.height * 0.0001 ), 0 )),2) num ,SUBSTR(xdTime,1,7) as date from Orders o" +
							" left join " +
							" (select d.orderId, d.num,ifnull(d.width,0) width ,height" +
							" 	from OrderDetails d " +
							" 	)d on o.id=d.orderid " +
							" where xdTime like '"+year+"-%' group by SUBSTR(xdTime,1,7) order by xdTime";
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
		
		public static function sumStaticArea(begin:Date,end:Date):ArrayCollection{
//			var sql:String = "select a.name,sum(num) winNum,ifnull(ROUND(sum(d.width*d.height*0.0001),1),0)+ifnull(ROUND(sum(allab.width*allab.height*0.0001),1),0) area "+
//							"	from Orders o left join OrderDetails d on o.id=d.orderid left join alupro a on a.id=d.ylType"+
//							"	left join ("+
//							"		SELECT detailid,sum(CASE WHEN blname='A' THEN blvalue ELSE 0 END) AS width,"+
//							"		sum(CASE WHEN blname='B' THEN blvalue ELSE 0 END) AS height "+
//							"		FROM OrderDetailBL group by detailid"+
//							"	) allab on allab.detailid = d.id "+
//							"	where 1=1 and name is not null  ";
			
			
			var sql:String = " select main.name name,  "+
				" ROUND(sum(main.num * ifnull( ( main.width * main.height * 0.0001 ), 0 )),2) area "+
				" from ( "+
				" select a.name , d.num,d.width,d.height "+
				
				" from Orders o left join OrderDetails d on o.id=d.orderid left join alupro a on a.id=d.ylType "+
				" where name is not null  ";
				
				
			if(begin!=null){
				sql += " and o.xdtime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and o.xdtime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			sql +=" )main  ";
			sql +=" group by main.name  ";
			
			
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		

		//明细表
		public static function orderDetailReport(begin:Date,end:Date, khName:String,color:String,ylType:String):ArrayCollection{
			var sql:String = " SELECT"+
							" main.id id,"+
							" main.khName khName,"+
						"	main.xdTime xdTime,"+
						"	main.yl yl,"+
						"	main.color color ,"+
						"	ROUND(main.num * ifnull( ( main.width * main.height * 0.0001 ), 0 ),4) pf "+
//						" 	(CASE WHEN main.width = 0 THEN main.width+'*'+main.height ELSE main.blwidth+'*'+main.blheight END) detail,"+
//						"	(main.num * ("+
//						"	CASE WHEN main.width = 0 THEN"+
//						"			ifnull( ROUND( ( main.blwidth * main.blheight * 0.0001 ), 4 ), 0 ) ELSE ifnull( ROUND( ( main.width * main.height * 0.0001 ), 4 ), 0 ) "+
//						"		END)) pf "+
						"	FROM"+
						"		("+
						"		SELECT"+
						"			o.id,"+
						"			khName,"+
						"			d.cxType,"+
						"			o.xdTime,"+
						"			d.color,"+
						"			d.num,"+
						"			ifnull(d.width,0) width,d.height,"+
						"			( SELECT yl.name FROM alupro yl WHERE d.ylType = yl.id ) yl "+
//						"			( SELECT bl.blValue FROM OrderDetailBL bl WHERE bl.detailId = d.id AND blname = 'A' ) blwidth,"+
//						"			( SELECT bl.blValue FROM OrderDetailBL bl WHERE bl.detailId = d.id AND blname = 'B' ) blheight "+
						"		FROM"+
						"			Orders o"+
						"			LEFT JOIN OrderDetails d ON o.id = d.orderId ";
						
			sql += " where 1=1 ";
			if(begin!=null){
				sql += " and o.xdtime>='"+DateFormatHelper.Format1(begin)+"'";
			}
			if(end!=null){
				sql +=" and o.xdtime<'"+DateFormatHelper.Format1(DateFormatHelper.getDateAfter(1,end))+"'";
			}
			if(null!=khName && khName.length>0){
				sql +=" and khName like '%"+khName+"%'";
			}
			if(null!=color && color.length>0){
				sql +=" and color ='"+color+"'";
			}
			if(null!=ylType && ylType.length>0){
				sql +=" and yl ='"+ylType+"'";
			}
			sql+="	) main";
			statement.text = sql;
			statement.itemClass = Object;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
	}
}