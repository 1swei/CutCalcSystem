package skins.colorPicker.colorPicker{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import skins.colorPicker.math.MyMath;

	public class ColorBtn extends MovieClip {
		//private var colorNum:Sprite;
		
		private var Angle:Point=new Point();
		private var movePoint:Point=new Point();
		private var _mColorTransform:ColorTransform=new ColorTransform();
		
		public function ColorBtn() {
			this.mouseChildren=false;
			point=0;
		}
		public function sDrag() {
			movePoint.x=parent.mouseX;
			movePoint.y=parent.mouseY;
			movePoint.normalize(55);
			Angle=MyMath.cartesianToPolar(movePoint.x,movePoint.y);
			this.x=movePoint.x;
			this.y=movePoint.y;
			
		}
		public function setColor(c:uint) {
			_mColorTransform.color=c
			getChildAt(1).transform.colorTransform =_mColorTransform;
		}
		public function get point():Number {
			return Angle.y;
		}
		public function set point(p:Number):void {
			movePoint=Point.polar(55,p*Math.PI/180);
			this.x=movePoint.x;
			this.y=movePoint.y;
		}
	}
}