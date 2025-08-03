package skins.colorPicker.colorPicker{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	
	import skins.colorPicker.math.MyMath;
	
	public class controlBtn extends MovieClip {
		private var Angle:Point=new Point();
		private var movePoint:Point=new Point();
		private var maxAngle:Number;
		private var minAngle:Number;
		private var starAngle:Number;
		private var maxLength:int;
		private var Angle360:Number;
		
		private var getPiont:Number;
		private var _mColorTransform:ColorTransform=new ColorTransform();
		public function controlBtn(max:Number,min:Number,ml:Number,sa:Number,c:uint=0xcccccc) {
			this.mouseChildren=false;
			maxAngle=max;
			minAngle=min;
			maxLength=ml;
			point=sa;
			_mColorTransform.color=c;
			getChildAt(1).transform.colorTransform = _mColorTransform;
		}
		public function sDrag() {
			movePoint.x=parent.mouseX;
			movePoint.y=parent.mouseY;
			movePoint.normalize(maxLength);
			Angle=MyMath.cartesianToPolar(movePoint.x,movePoint.y);

			if (Angle.y<maxAngle+5 && Angle.y>minAngle-5) {
				if (Angle.y>maxAngle) {
					Angle.y=maxAngle;
				}
				if (Angle.y<minAngle) {
					Angle.y=minAngle;
				}
				movePoint=Point.polar(Angle.x,Angle.y*Math.PI/180);
				this.x=movePoint.x;
				this.y=movePoint.y;
				getPiont=(Angle.y-minAngle)/(maxAngle-minAngle);
			}
		}
		public function get point():Number {
			return getPiont;
		}
		public function set point(p:Number):void {
			var ap=(maxAngle-minAngle)*p+minAngle;
			movePoint=Point.polar(maxLength,ap*Math.PI/180);
			this.x=movePoint.x;
			this.y=movePoint.y;
		}
	}
}