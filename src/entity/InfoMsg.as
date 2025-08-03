package entity
{

	[Bindable]
	public class InfoMsg
	{
		public var id:int;
		public var bz:String="";
		public var kg:Number=0;
		public var money:Number=0;
		public var isPay:int=1;//0未知 1未付 2已付
		public var infoTime:String="";//进货时间
		public var unit:Number=0;//单价
	}
}