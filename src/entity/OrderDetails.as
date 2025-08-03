package entity
{
	import common.ArrayCollectionUtil;
	
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class OrderDetails
	{
		//子表信息
		public var id:int;
		public var orderId:int;//主表id
		public var xh:int=1;//序号
		public var color:String="";//颜色
		public var ylType:int=0;//用料类型
		public var boLi:int;//1单玻  2双玻
		public var jiShan:int=0;//2：2扇  /3：3扇   /4：4扇 
		public var width:Number=0;
		public var height:Number=0;
		public var gudingTop:int;//0 不带固定  1上固定
		public var gdTopHeight:Number=0;//上固定多少
		public var gudingDown:int;//0不带固定  1下固定
		public var gdDownHeight:Number=0;//下固定多少
		public var shouKou:int;//0 不带收口  1带收口
		public var zhuanJiao:int=0;//0不带转角
		public var isGDH:int=0;//0普通  1下滑是高低滑(只有平下才有高低滑)
		
		public var zzNumTop:int=0;//固定的中柱数量（上）
		public var zzNumDown:int=0;//固定的中柱数量（下）
		
		public var num:int=1;//同样的这种窗户多少个。
		public var cxType:int=0;//普通推拉：0 自定义窗型：1
		public var picName:String="";//选择的窗型图名
		public var bz:String="";
		
				
		
		/**以下为不存入数据库字段,就是计算出来的各种料长度.每次预览计算一次*/
		public var blList:ArrayCollection;//变量集合
		public var wkMsg:String="【外框料】\n";//外框料描述
		public var nsMsg:String="【内扇料】\n";//内扇料描述
		public var blMsg:String="【玻璃尺寸】\n";//玻璃描述
		[Bindable]public var wkList:ArrayCollection;
		[Bindable]public var nsList:ArrayCollection;
		[Bindable]public var glassList:ArrayCollection;
		
		public var area:Number=0;
		//外框
		public var bianFeng:Number=0;
		public var shangXiaHua:Number=0;
		public var zhongTingTop:Number=0;
		public var zhongTingDown:Number=0;
		public var zhongTingH:Number=0;//带固定的平开窗的时候,横在中间的中挺.
		public var zhongTingPK:Number=0;//2扇平开窗的时候,竖在中间的中挺.
		
		//内扇
		public var ggqMax:Number=0;
		public var ggqMin:Number=0;
		public var shangXiaFang:Number=0;
		public var shouKouNumber:Number=0;
		
		//固定压线,内扇压线.是一个集合.长度,几根.
		public var yx_gdArray:ArrayCollection;
		public var yx_nsArray:ArrayCollection;
		public var yx_gdStr:String="";
		public var yx_nsStr:String="";
		
		
		public var printPic:Boolean=true;//是否打印图纸
		
		public var aluPro:AluPro;//型材配置信息
		public var glass:GlassSizeSet;//玻璃配置信息
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;

		public function setAluPro(aluProArray:ArrayCollection):void{
			if(aluProArray==null){
				aluProArray = AluPro.getAluPros();
			}
			this.aluPro=ArrayCollectionUtil.getItem(this.ylType,aluProArray,"id",new AluPro()) as AluPro;
			if(aluPro!=null&&glass==null)
				this.glass=GlassSizeSet.getGlassSizeSetByAluProId(aluPro.id);
			
		}
		public function createNewObject():OrderDetails{
			var result:OrderDetails = new OrderDetails();
			result.orderId=orderId;
			result.color=color;
			result.ylType=ylType;
			result.boLi=boLi;
			result.aluPro=aluPro;
			result.glass = glass;
			return result;
		}
		
		public static function getOrderDetailsByAluProId(aluProId:int):ArrayCollection{
			statement.text = "SELECT * from OrderDetails where ylType="+aluProId+" ";
			statement.itemClass=OrderDetails;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		
	}
}