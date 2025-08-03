package entity
{
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	//型材配置
	[Bindable]
	public class AluPro
	{
		public var id:int;
		public var name:String="";//型材名字
		public var state:String="Y";//启用
		public var type:int=0;//0 普通推拉窗料  1平开窗  2平开门
		//外框
		public var zhongTingXS:Number=0;
		//平开：固上/固下的中挺，属于中挺栽中挺。减法和推拉窗中挺不一样。平开没有固定，只有外框，中挺，这里就用zhongTingXS_G
		public var zhongTingXS_G:Number=0;
		public var shangXiaHuaXS:Number=0;
		public var hengLiaoXS:Number=0;//横料系数
		public var isZJ:int=0;// 0外框不组角 1外框组角
		
		//内扇竖料
		public var ggqMaxXS:Number=0;//平上平下的光勾企
		public var ggqMaxGSXS:Number=0;//固上平下
		public var ggqMaxGXXS:Number=0;//平上固下
		public var ggqMaxQGXS:Number=0;//固上固下
		
		public var ggqMaxPSPXGD:Number=0;//平上平下 高低滑
		public var ggqMaxGSPXGD:Number=0;//固上平下高低滑
		
		public var ggqMinXS:Number=0;//没有固定的光勾企
		public var ggqMinGSXS:Number=0;
		public var ggqMinGXXS:Number=0;
		public var ggqMinQGXS:Number=0;
		
		public var ggqMinPSPXGD:Number=0;//平上平下 高低滑
		public var ggqMinGSPXGD:Number=0;//固上平下高低滑
		//内扇横料
		public var shangXiaFang2XS:Number=0;
		public var shangXiaFang3XS:Number=0;
		public var shangXiaFang3XS_SK:Number=0;//带收口
		public var shangXiaFang4XS:Number=0;
		public var shangXiaFang6XS:Number=0;//默认 收口 2根
		//固定压条
		public var yaTiaoH:Number=0;//压条每根竖(用外包)减多少
		public var yaTiaoH_C:Number=0;//带窗扇的固定压条竖的减多少
		public var yaTiaoW:Number=0;//压条每根横(用外包)减多少
		//内扇压条
		public var yaTiaoH_N:Number=0;//外包减
		public var yaTiaoW_N:Number=0;//外包减
		public var yaTiao:Number=0;//压线宽度
		
		/**2017-3-26 增加断桥铝的平开窗算法*/
		public var neikongXS:Number=0;//内空系数
		public var tempNum:Number=0;//不同型材类型，动态用。目前用于 平开压条长度=内扇长度-tempNum-this.yatiao，因为不是很理解这个9的算法，暂时这么算tempNum=9
		public var bz:String="";
		
		public var loss:Number=0;//损耗
		public var price:Number=0;//单价
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getAluPros():ArrayCollection
		{
			statement.text = "SELECT * from AluPro where state='Y' ";
			statement.itemClass=AluPro;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function getAluProById(id:int):AluPro
		{
			statement.text = "SELECT * from AluPro where id="+id;
			statement.itemClass=AluPro;
			statement.execute();
			var arr:ArrayCollection = new ArrayCollection(statement.getResult().data);
			if(arr==null||arr.length==0){
				return null;
			}else{
				return arr.getItemAt(0) as AluPro;
			}
		}
		
		public static function detele(id:int):void
		{
			statement.text = "delete from AluPro where id="+id+"";
			statement.execute();
		}
		public static function update_name(item:AluPro):void
		{
			statement.text = "update AluPro set name='"+item.name+"',loss="+item.loss+",price="+item.price+" where id="+item.id;
			statement.execute();
		}
		public static function update(item:AluPro,theGlass:GlassSizeSet):void
		{
			statement.text = "update AluPro set name='"+item.name+"',state='"+item.state+"',type='"+item.type+"',zhongTingXS='"+item.zhongTingXS+"',zhongTingXS_G='"+item.zhongTingXS_G+
				"',shangXiaHuaXS='"+item.shangXiaHuaXS+"',hengLiaoXS='"+item.hengLiaoXS+"',isZJ='"+item.isZJ+"',ggqMaxQGXS='"+item.ggqMaxQGXS+"',ggqMaxGXXS='"+item.ggqMaxGXXS+"',ggqMaxGSXS='"+item.ggqMaxGSXS+"',ggqMaxXS='"+item.ggqMaxXS+"',ggqMaxPSPXGD="+item.ggqMaxPSPXGD+",ggqMaxGSPXGD="+item.ggqMaxGSPXGD+
				",ggqMinQGXS='"+item.ggqMinQGXS+"',ggqMinGXXS='"+item.ggqMinGXXS+"',ggqMinGSXS='"+item.ggqMinGSXS+"',ggqMinXS='"+item.ggqMinXS+"',ggqMinPSPXGD="+item.ggqMinPSPXGD+",ggqMinGSPXGD="+item.ggqMinGSPXGD+
				",shangXiaFang2XS='"+item.shangXiaFang2XS+"',shangXiaFang3XS='"+item.shangXiaFang3XS+
				"',shangXiaFang3XS_SK='"+item.shangXiaFang3XS_SK+"',shangXiaFang4XS='"+item.shangXiaFang4XS+"',shangXiaFang6XS='"+item.shangXiaFang6XS+"',yaTiaoH="+item.yaTiaoH+",yaTiaoH_C="+item.yaTiaoH_C+",yaTiaoW="+item.yaTiaoW+",yaTiaoH_N="+item.yaTiaoH_N+",yaTiaoW_N="+item.yaTiaoW_N+",yaTiao="+item.yaTiao+",neikongXS="+item.neikongXS+",tempNum="+item.tempNum+",bz='"+item.bz+"' where id="+item.id;
			statement.execute();
			
			//先去查一遍有没有GlassSizeSet，没有就insert。有就update。因为这个表是后加的，可能存在update表AluPro的时候没有表GlassSizeSet。
			var glass:GlassSizeSet=GlassSizeSet.getGlassSizeSetByAluProId(item.id);
			if(glass==null){
				GlassSizeSet.insert(item.id,new GlassSizeSet());
			}else{
				GlassSizeSet.update(item.id,theGlass);
			}
		}
		
		
		public static function insert(item:AluPro):int
		{
			statement.text = "INSERT into AluPro(name,state,type,zhongTingXS,zhongTingXS_G, shangXiaHuaXS, hengLiaoXS,isZJ,ggqMaxQGXS,ggqMaxGXXS,ggqMaxGSXS,ggqMaxXS,ggqMinQGXS,ggqMinGXXS,ggqMinGSXS," +
				"ggqMinXS,shangXiaFang2XS,shangXiaFang3XS,shangXiaFang3XS_SK,shangXiaFang4XS,yaTiaoH,yaTiaoH_C,yaTiaoW,yaTiaoH_N,yaTiaoW_N,yaTiao,neikongXS,tempNum,bz,ggqMaxPSPXGD,ggqMaxGSPXGD,ggqMinPSPXGD,ggqMinGSPXGD)"+
				"values('"+item.name+"','"+item.state+"',"+item.type+","+item.zhongTingXS+","+item.zhongTingXS_G+","+item.shangXiaHuaXS+","+item.hengLiaoXS+","+item.isZJ+","+item.ggqMaxQGXS+","+item.ggqMaxGXXS+","+item.ggqMaxGSXS+","+item.ggqMaxXS+","+item.ggqMinQGXS+","+item.ggqMinGXXS+","+item.ggqMinGSXS+","
				+item.ggqMinXS+","+item.shangXiaFang2XS+","+item.shangXiaFang3XS+","+item.shangXiaFang3XS_SK+","+item.shangXiaFang4XS+","+item.yaTiaoH+","+item.yaTiaoH_C+","+item.yaTiaoW+","+item.yaTiaoH_N+","+item.yaTiaoW_N+","+item.yaTiao+","+item.neikongXS+","+item.tempNum+", '"+item.bz+"',"+item.ggqMaxPSPXGD+","+item.ggqMaxGSPXGD+","+item.ggqMinPSPXGD+","+item.ggqMinGSPXGD+" )" ;
			statement.execute();
			//插入玻璃尺寸表
			var result:SQLResult=statement.getResult();
			var item_id:int=result.lastInsertRowID;
			GlassSizeSet.insert(item_id,new GlassSizeSet());
			return item_id;
		}
		
		
	}
}