package common
{
	
	import entity.Set;
	
	import mx.collections.ArrayCollection;

	public class Common
	{
		public function Common()
		{
		}
		
		public static function setRowNo(dataArray:ArrayCollection):ArrayCollection {
			for (var i:int = 0; i < dataArray.length; i++) {
				var item:Object = dataArray.getItemAt(i);
				if(!item.hasOwnProperty("rowid")){
					break;
				}
				item.rowid = i + 1;
			}
			return dataArray;
		}
		
	}
}