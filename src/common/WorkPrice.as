package common
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class WorkPrice
	{
		public function WorkPrice()
		{
		}
		
		
		public var name:String;
		public var size:String;
		public var area:Number=0;
		public var weight:Number=0;
		
		public var loss:Number=0;
		
		public var price:Number=0;
		
		public var amount:Number=0;
		
		public var unitPrice:Number=0;//平方单价
		//报价明细
		public var detail:ArrayCollection;
		
	}
}