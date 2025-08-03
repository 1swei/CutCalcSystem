package entity.enum
{
	import mx.collections.ArrayCollection;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class ModuleCode
	{
		public function ModuleCode()
		{
		}
		public static const ORDER:String = "ORDER";//订单
		public static const SELL:String = "SELL";//销售单
		public static const PURECHASE:String = "PURECHASE";//采购
		public static const DEFAULT_MODULES:ArrayCollection=
			new ArrayCollection([{code:"H",name:"订单",module:ORDER},{code:"S",name:"销售单",module:SELL},{code:"P",name:"采购单",module:PURECHASE}]);
		
		public static function formatModule(obj:Object,col:DataGridColumn=null):String{
			if(col!=null){
				return getNameByType(obj[col.dataField] as String);
			}else if(obj!=null){
				return getNameByType(obj as String);
			}else{
				return "";
			}
		}
		
		public static function getNameByType(type:String):String{
			if(type==ORDER){
				return "订单";
			}
			if(type==SELL){
				return "销售单";
			}
			if(type==PURECHASE){
				return "采购单";
			}
			return "未知";
		}
	}
}