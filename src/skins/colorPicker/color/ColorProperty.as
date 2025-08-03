/*
颜色、亮度、对比度、色相、饱和度调整模块
*/
package skins.colorPicker.color{
	import flash.filters.ColorMatrixFilter;
	import flash.display.DisplayObject;

	public class ColorProperty {
		//色彩
		private var _red:Number = 1;
		private var _green:Number = 1;
		private var _blue:Number = 1;
		
		//亮度Brightness
		private var _brightness:Number = 0;
		private var _constant:Number = 0;

		
		//饱和度Saturation
		private var _saturation:Number = 1.5;
		
		//目标MC
		private var _child:DisplayObject;

		//变换矩阵
		private var Saturation_Matrix:Array;
		private var Brightness_Matrix:Array;

		//构造函数
		public function ColorProperty(child:DisplayObject) {
			_child=child;
		}
		
		//亮度
		public function set brightness(val:Number) {
			val>.5?_brightness=1-(val-.5)*2:_brightness=val*2
			val>.5?_constant=(val-.5)*2:_constant=0
			Brightness_Matrix =[_brightness, 0, 0, 0, _constant*255,
							 0, _brightness, 0, 0, _constant*255, 
							 0, 0, _brightness, 0, _constant*255,
							 0, 0, 0, 1, 0];
			onColorChange();
		}
		//饱和度
		public function set saturation(val:Number) {
		Saturation_Matrix = [val, 0, 0, 0, (1-val)*128,
							 0, val, 0, 0, (1-val)*128, 
							 0, 0, val, 0, (1-val)*128,
							 0, 0, 0, 1, 0];
			onColorChange();
		}
		private function onColorChange() {
			var ColorMatrix_filter1 = new ColorMatrixFilter(Saturation_Matrix);//饱和度
			var ColorMatrix_filter2 = new ColorMatrixFilter(Brightness_Matrix);//亮度
			_child.filters = [ColorMatrix_filter1,ColorMatrix_filter2];
		}

	}
}