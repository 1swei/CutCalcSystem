package entity.enum
{
	import mx.controls.dataGridClasses.DataGridColumn;

	public final class DataState
	{
		public static const SAVED:String = "SAVED"; 
		public static const VERIFIED:String = "VERIFIED";
		public static const COMMITTED:String = "COMMITTED"; 
		public static const FINISHED:String = "FINISHED";
		public static const DELETED:String = "DELETED";
		
		public static function DataStateLabelFun(obj:Object,col:DataGridColumn=null):String{
			return getValueByState(obj[col.dataField]);
		}
		public static function getValueByState(state:String):String{
			if(state==SAVED){
				return "已保存";
			}
			if(state==VERIFIED){
				return "已审核";
			}
			if(state==COMMITTED){
				return "已提交";
			}
			if(state==FINISHED){
				return "已完成";
			}
			if(state==DELETED){
				return "已作废";
			}
			return "未知";
		}
	}
}