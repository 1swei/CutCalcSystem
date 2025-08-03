package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	//boli配置
	/**这里的固定/中挺等缩尺,和订单界面计算材料的缩尺不是一个概念,这个理解为:每根料占宽多少*/
	[Bindable]
	public class GlassSizeSet
	{
		public var id:int;
		public var AluProId:int;//型材id
		//内扇玻璃
		public var heigth_in:Number=0;//高度减多少
		public var width_in:Number=0;//宽度减多少
		//固定玻璃 
		public var heigth_stc_xs:Number=0;//高度缩尺
		public var width_stc_xs:Number=0;// 宽度缩尺
		public var glass_zt:Number=0;// 每根 中挺 减多少
		public var glass_bf:Number=0;// 每根 边封 减多少
		public var glass_gd:Number=0;//固定小面
		
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		public static function getGlassSizeSet():ArrayCollection
		{
			statement.text = "SELECT * from GlassSizeSet ";
			statement.itemClass=GlassSizeSet;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function getGlassSizeSetByAluProId(Aluid:int):GlassSizeSet
		{
			statement.text = "SELECT * from GlassSizeSet where AluProId="+Aluid;
			statement.itemClass=GlassSizeSet;
			statement.execute();
			var arr:ArrayCollection = new ArrayCollection(statement.getResult().data);
			if(arr==null||arr.length==0){
				return null;
			}else{
				return arr.getItemAt(0) as GlassSizeSet;
			}
		}
		public static function insert(AluProId:int,item_glass:GlassSizeSet):void{
			statement.text = "INSERT into GlassSizeSet(AluProId,heigth_in,width_in,heigth_stc_xs, width_stc_xs, glass_zt,glass_bf,glass_gd)"+
				"values('"+AluProId+"','"+item_glass.heigth_in+"','"+item_glass.width_in+"','"+item_glass.heigth_stc_xs+"','"+item_glass.width_stc_xs+"','"+item_glass.glass_zt+"','"+item_glass.glass_bf+"','"+item_glass.glass_gd+"')" ;
			statement.execute();
		}
		public static function update(AluProId:int,item_glass:GlassSizeSet):void{
			//更新玻璃尺寸表
			statement.text = "update GlassSizeSet set heigth_in="+item_glass.heigth_in+",width_in="+item_glass.width_in+",heigth_stc_xs="+item_glass.heigth_stc_xs+
				",glass_zt="+item_glass.glass_zt+",glass_bf="+item_glass.glass_bf+",width_stc_xs="+item_glass.width_stc_xs+",glass_gd="+item_glass.glass_gd+" " +
				" where AluProId="+AluProId;
			statement.execute();
		}
		
	}
}