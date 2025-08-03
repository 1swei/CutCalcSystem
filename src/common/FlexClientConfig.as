package common
{
	
	public class FlexClientConfig
	{
		private static var _config:FlexClientConfig;
		
		
		public static function getInstance():FlexClientConfig{
			if(_config==null){
				_config=new FlexClientConfig();
			}
			return _config;
		}
		
		public function FlexClientConfig()
		{
			
		}
		private var _Theme:uint; 
		
		[Bindable]
		public function get Theme():uint{
			return _Theme;
		}
		public function set Theme(value:uint):void{
			this._Theme=value;
		}
	}
}
