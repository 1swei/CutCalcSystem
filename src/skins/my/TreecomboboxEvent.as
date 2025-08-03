package skins.my
{
	import flash.events.Event;
	
	public class TreecomboboxEvent extends Event
	{
		public static const NAME:String="treecomboboxevent";
		private var _data:Object;
		public function TreecomboboxEvent(data:Object=null)
		{
			super(NAME, false, false);
			this._data=data;
		}
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}