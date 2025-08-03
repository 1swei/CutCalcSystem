package common{  
	import flash.events.Event;  
	import flash.net.URLLoader;  
	import flash.net.URLRequest;  
	import flash.net.URLVariables;  
	
	public class TxtLoader {  
		private var setTxt:Function = null;  
		
		public function TxtLoader() {  
		}  
		
		public function loadTxt(fileName:String, setTxt:Function):void {  
			this.setTxt = setTxt;  
			var urlRequest:URLRequest = new URLRequest(fileName);  
			var urlLoader:URLLoader = new URLLoader();  
			urlLoader.addEventListener(Event.COMPLETE, complete);  
			urlLoader.load(urlRequest);  
		}  
		
		private function complete(event:Event):void {  
			var urlLoader:URLLoader = event.currentTarget as URLLoader;  
			setTxt.call(null, urlLoader.data);  
		}  
	}  
}  