package skins.colorPicker.math{
	import flash.geom.Point;
	public class MyMath {
		public function MyMath() {
		}
		public static function sinD(angle:Number):Number {
			return Math.sin(angle * Math.PI / 180);
		}

		public static function cosD(angle:Number):Number {
			return Math.cos(angle * Math.PI / 180);
		}

		public static function tanD(angle:Number):Number {
			return Math.tan(angle * Math.PI / 180);
		}

		public static function asinD(ratio:Number):Number {
			return Math.asin(ratio) * 180 / Math.PI;
		}

		public static function acosD(ratio:Number):Number {
			return Math.acos(ratio) * 180 / Math.PI;
		}

		public static function atanD(ratio:Number):Number {
			return Math.atan(ratio) * 180 / Math.PI;
		}

		public static function atan2D(y:Number,x:Number):Number {
			return Math.atan2(y,x) * 180 / Math.PI;
		}
		/*求两点间距离*/
		public static function distance(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			var dx:Number=x2 - x1;
			var dy:Number=y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		/*计算两点间连线的倾斜角*/
		public static function angleOfLine(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			return atan2D(y2 - y1,x2 - x1);
		}
		/*度转换为弧度*/
		public static function degreesToRadians(angle:Number):Number {
			return angle * Math.PI / 180;
		}
		/*弧度转换为度*/
		public static function radiansToDegrees(angle:Number):Number {
			return angle * 180 / Math.PI;
		}
		/*将一个角度转化为在0~360度之间*/
		public static function fixAngle(angle:Number):Number {
			angle%= 360;
			return angle < 0?angle + 360:angle;
		}
		/*将笛卡尔坐标系转化为极坐标系,p为点对象*/
		public static function cartesianToPolar(px,py):Point {
			var rt:Point=new Point();
			var radius:Number=Math.sqrt(px * px + py * py);//半径
			var theta:Number=atan2D(py,px);//角度
			rt.x=radius;
			rt.y=theta;
			return rt;
		}
		/*将极坐标系转化为笛卡尔坐标系*/
		public static function polarToCartesian(pr,pt):Point {
			var rt:Point=new Point();
			var x:Number=pr * cosD(pt);
			var y:Number=pr * sinD(pt);
			rt.x=x;
			rt.y=y;
			return rt;
		}
	}
}