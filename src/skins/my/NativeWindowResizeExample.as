package skins.my
{
	import flash.display.Sprite; 
	import flash.events.MouseEvent; 
	import flash.display.NativeWindowResize; 
	public class NativeWindowResizeExample extends Sprite
	{
		public function NativeWindowResizeExample()
		{
			// Fills a background area. 
			this.graphics.beginFill(0xFFFFFF); 
			this.graphics.drawRect(0, 0, 400, 300); 
			this.graphics.endFill(); 
			
			// Creates a square area where a mouse down will start the resize. 
			var resizeHandle:Sprite =  
				createSprite(0xCCCCCC, 20, this.width - 20, this.height - 20); 
			resizeHandle.addEventListener(MouseEvent.MOUSE_DOWN, onStartResize); 
			
			// Creates a square area where a mouse down will start the move. 
			var moveHandle:Sprite = createSprite(0xCCCCCC, 20, this.width - 20, 0); 
			moveHandle.addEventListener(MouseEvent.MOUSE_DOWN, onStartMove); 
		}
		public function createSprite(color:int, size:int, x:int, y:int):Sprite 
		{ 
			var s:Sprite = new Sprite(); 
			s.graphics.beginFill(color); 
			s.graphics.drawRect(0, 0, size, size); 
			s.graphics.endFill(); 
			s.x = x; 
			s.y = y; 
			this.addChild(s);     
			return s;         
		} 
		
		public function onStartResize(event:MouseEvent):void 
		{ 
			this.stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT); 
		} 
		
		public function onStartMove(event:MouseEvent):void 
		{ 
			this.stage.nativeWindow.startMove(); 
		} 
	}
	
}