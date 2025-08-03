package common
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class WorkPriceDetail
	{
		public function WorkPriceDetail()
		{
		}
		
		
		public var name:String;
		public var length:Number=0;
		public var number:Number=0;
		public var weight:Number=0;
		
		public var unitWeight:Number=0;//kg/m
		
		public var amount:Number=0;
		
	}
}