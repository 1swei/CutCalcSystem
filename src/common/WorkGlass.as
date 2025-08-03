package common
{
	[Bindable]
	public class WorkGlass
	{
		public function WorkGlass()
		{
		}
		
		public var orderId:int;//订单id
		public var orderDetailId:int;//订单明细id
	
		public var length:Number=0;//长度
		public var width:Number=0;//宽度
		public var other:Number=0;//斜边
		public var num:Number=0;//数量
		
		public static function toWorkGlass(length:Number,width:Number,num:Number,other:Number=0):WorkGlass{
			var wm:WorkGlass = new WorkGlass();
			wm.length = DataFormat.formatNumber(length);
			wm.width = DataFormat.formatNumber(width);//DataFormat.formatNumber(length);
			wm.other = DataFormat.formatNumber(other);
			wm.num = num;
			return wm;
		}
	}
}