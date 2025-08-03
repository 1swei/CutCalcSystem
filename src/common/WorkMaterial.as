package common
{
	[Bindable]
	public class WorkMaterial
	{
		public function WorkMaterial()
		{
		}
		
		public var orderId:int;//订单id
		public var orderDetailId:int;//订单明细id
		public var ylType:int;//型材id  AluPro表id
		public var name:String;//物料名称
		public var type:int=0;//物料类型0 外框 1内扇 
		public var length:Number=0;//物料长度
		public var num:Number=0;//材料根数
		public var isNameMulti:Boolean = false;//若名称为多个称谓，那么isGe=true 。如：光勾企 代表2种料
		
	
		
		//料铭，长度，根数
		public static function toWorkMaterial_wk(name:String,length:Number,num:Number=0,isNameMulti:Boolean =false ):WorkMaterial{
			var wm:WorkMaterial = new WorkMaterial();
			wm.name = name;
			wm.length = length;//DataFormat.formatNumber(length);
			wm.num = num;
			wm.isNameMulti = isNameMulti;
			wm.type = 0;
			return wm;
		}
		
		public static function toWorkMaterial_ns(name:String,length:Number,num:Number=0,isNameMulti:Boolean =false ):WorkMaterial{
			var wm:WorkMaterial = new WorkMaterial();
			wm.name = name;
			wm.length = length;//DataFormat.formatNumber(length);
			wm.num = num;
			wm.isNameMulti = isNameMulti;
			wm.type = 1;
			return wm;
		}
	}
}