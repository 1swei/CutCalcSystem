package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class SellDetail
	{
		public function SellDetail()
		{
		}
		public var id:int;
		public var sellId:int;
		public var materialId:int;
		public var materialName:String="";
		public var number:Number=0;//数量
		public var loss:Number=0;//损耗
		public var amount:Number=0;//金额
		public var price:Number=0;//单价
		public var unit:String="";//单位
		public var numberMemo:String="";//数量说明:该说明一定是可计算的数学公式
		public var memo:String="";//备注
		
		public var _priceShow:String="";
		public function clear():void{
			//this.id=0;
			//this.sellId=0;
			this.materialId=0;
			this.materialName="";
			this.number=0;
			this.loss=0;
			this.amount=0;
			this.price=0;
			this.unit="";
			this.memo="";
			this.numberMemo="0";
		}
		public function createByMaterial(material:Material):void{
			materialId = material.id;
			materialName = material.brand+material.name+material.spec;
			unit = material.unit;
			price = material.price;
			loss = material.loss;
		}
		public function get priceShow():String
		{
			if(loss>1){
				return loss+"×"+price;
			}else{
				return price.toString();
			}	
		}
		
		public function set priceShow(value:String):void
		{
			_priceShow = value;
		}

		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function findBySellId(id:int):ArrayCollection
		{
			statement.text = "SELECT * from SellDetail where sellId="+id;
			statement.itemClass=SellDetail;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function insert(item:SellDetail):int{
			statement.text="insert into SellDetail(sellId,materialId,materialName,number,loss,amount,price,unit,memo,numberMemo)"+
				" values ("+item.sellId+","+item.materialId+",'"+item.materialName+"',"+item.number+","+item.loss+","+item.amount+","+item.price+",'"+item.unit+"','"+item.memo+"','"+item.numberMemo+"');";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function update(item:SellDetail):void{
			statement.text=updateSQL(item);
			statement.execute();
		}
		public static function deleteOne(id:int):void{
			statement.text = "delete from SellDetail where id="+id;
			statement.execute();
		}
		public static function deleteByFK(sellId:int):void{
			statement.text = "delete from SellDetail where sellId="+sellId;
			statement.execute();
		}
		
		public static function updateSQL(item:SellDetail):String{
			return "update SellDetail set sellId="+item.sellId+",materialId="+item.materialId+",materialName='"+item.materialName+"' " +
				",number="+item.number+",loss="+item.loss+",amount="+item.amount+",price="+item.price+",unit='"+item.unit+"',memo='"+item.memo+"',numberMemo='"+item.numberMemo+"' where id="+item.id+";";
			
		}
	}
	
}