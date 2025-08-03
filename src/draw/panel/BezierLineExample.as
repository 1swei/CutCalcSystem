package 
{
	import draw.bezierLine.BezierLine;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.Button;
	import mx.controls.ColorPicker;
	import mx.controls.NumericStepper;
	import mx.events.ColorPickerEvent;
	
	/**
	 * www.litefeel.com
	 * @author lite3
	 */
	public class BezierLineExample extends Sprite 
	{
		private var lockX:Number;
		private var lockY:Number;
		private var currLine:BezierLine;
		
		private var glowFilter:GlowFilter;
		
		private var lineCp:ColorPicker;
		private var sizeNS:NumericStepper;
		private var clearBtn:Button;
		private var canvas:Sprite;
		
		public function BezierLineExample():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
		/*	Logo.show(stage);
			StageUtil.setNoScaleAndTopLeft(stage);
			contextMenu = MyContextMenu.getMyContextNenu();*/
			
			// 选中线条的发光滤镜
			glowFilter = new GlowFilter();
			
			// 初始化UI
			canvas = this.getChildByName("_canvas") as Sprite;
			canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			canvas = new Sprite();
			canvas.mouseEnabled = false;
			addChild(canvas);
			canvas.addEventListener(MouseEvent.MOUSE_DOWN, selectLineHandler);
			
			lineCp = getChildByName("_lineCp") as ColorPicker;
			sizeNS = getChildByName("_sizeNS") as NumericStepper;
			clearBtn = getChildByName("_clearBtn") as Button;
			lineCp.addEventListener(ColorPickerEvent.CHANGE, changeColorHandler);
			sizeNS.addEventListener(Event.CHANGE, changeSizeHandler)
			clearBtn.addEventListener(MouseEvent.CLICK, clearBtnClickHandler);
		}
		// --------------------- 划线相关 ----------------------------------------------
		private function mouseDownHandler(e:MouseEvent):void 
		{
			// 它的对象是底下的鼠标点击层，不是现实的canvas
			lockX = e.localX;
			lockY = e.localY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHadnler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHadnler(e:MouseEvent):void 
		{
			canvas.graphics.clear();
			canvas.graphics.moveTo(lockX, lockY);
			canvas.graphics.lineStyle(sizeNS.value, lineCp.selectedColor);
			canvas.graphics.lineTo(canvas.mouseX, canvas.mouseY);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHadnler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			canvas.graphics.clear();
			
			var line:BezierLine = new BezierLine(lockX, lockY, canvas.mouseX, canvas.mouseY);
			line.setStyle(sizeNS.value, lineCp.selectedColor);
			canvas.addChild(line);
			selectLine(line);
		}
		
		// 选中一条线
		private function selectLine(line:BezierLine):void
		{
			if (currLine) currLine.filters = null;
			
			currLine = line;
			if (line) line.filters = [glowFilter];
		}
		
		// 选择线
		private function selectLineHandler(e:MouseEvent):void 
		{
			selectLine(e.target as BezierLine);
		}
		
		// 改变线条颜色
		private function changeColorHandler(e:ColorPickerEvent):void 
		{
			if (currLine) currLine.color = e.color;
		}
		
		// 改变线条粗细
		private function changeSizeHandler(e:Event):void 
		{
			if (currLine) currLine.thickness = sizeNS.value;
		}
		
		// 清除所有线
		private function clearBtnClickHandler(e:MouseEvent):void 
		{
			currLine = null;
			var index:int = canvas.numChildren - 1;
			while (index >= 0)
			{
				canvas.removeChildAt(index--);
			}
		}
		
	}
	
}