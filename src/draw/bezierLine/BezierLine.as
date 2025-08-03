package draw.bezierLine
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 二次贝塞尔曲线
	 */
	public class BezierLine extends Sprite
	{
		// 终点坐标
		private var endX:Number;
		private var endY:Number;
		
		private var centerX:Number;
		private var centerY:Number;
		
		// 控制点坐标
		private var _controlX:Number;
		private var _controlY:Number;
		
		// 线条样式属性
		private var _thickness:Number;
		private var _color:uint;
		private var _pixelHinting:Boolean;
		private var _scaleMode:String;
		private var _caps:String;
		private var _joints:String;
		private var _miterLimit:Number;
		
		
		public function BezierLine(beginX:Number, beginY:Number, endX:Number, endY:Number) 
		{
			this.endX = endX - beginX;
			this.endY = endY - beginY;
			setStyle(3);
			graphics.lineTo(this.endX, this.endY);
			x = beginX;
			y = beginY;
			centerX = this.endX / 2;
			centerY = this.endY / 2;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		/**
		 * 设置线条样式
		 * @param	thickness
		 * @param	color
		 * @param	alpha
		 * @param	pixelHinting
		 * @param	scaleMode
		 * @param	caps
		 * @param	joints
		 * @param	miterLimit
		 */
		public function setStyle(thickness:Number, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void
		{
			_thickness = thickness;
			_color = color;
			this.alpha = alpha;
			_pixelHinting = pixelHinting;
			_scaleMode = scaleMode;
			_caps = caps;
			_joints = joints;
			_miterLimit = miterLimit;
			drawLineByControlPoint(controlX, controlY);
		}
		
		/**
		 * 划线 贝塞尔曲线
		 * @param	controlX
		 * @param	controlY
		 */
		public function drawLineByControlPoint(controlX:Number, controlY:Number):void
		{
			_controlX = controlX;
			_controlY = controlY;
			
			graphics.clear();
			graphics.moveTo(0, 0);
			graphics.lineStyle(_thickness, _color, 1, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
			graphics.curveTo(controlX, controlY, endX, endY);
			
		}
		/** 控制点X */
		public function get controlX():Number { return _controlX; }
		
		/** 控制点Y */
		public function get controlY():Number { return _controlY; }
		
		public function get thickness():Number { return _thickness; }
		public function set thickness(value:Number):void 
		{
			if (_thickness != value)
			{
				_thickness = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void 
		{
			if (_color != value)
			{
				_color = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get pixelHinting():Boolean { return _pixelHinting; }
		public function set pixelHinting(value:Boolean):void 
		{
			if (_pixelHinting != value)
			{
				_pixelHinting = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value:String):void 
		{
			if (_scaleMode != value)
			{
				_scaleMode = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get caps():String { return _caps; }
		public function set caps(value:String):void 
		{
			if (_caps != value)
			{
				_caps = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get joints():String { return _joints; }
		public function set joints(value:String):void 
		{
			if (_joints != value)
			{
				_joints = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		public function get miterLimit():Number { return _miterLimit; }
		public function set miterLimit(value:Number):void 
		{
			if (_miterLimit != value)
			{
				_miterLimit = value;
				drawLineByControlPoint(_controlX, _controlY);
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			drawLineByControlPoint((mouseX - centerX) * 2 + centerX, (mouseY - centerY) * 2 + centerY);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
	}

}