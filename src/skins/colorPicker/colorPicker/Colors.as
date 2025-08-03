package skins.colorPicker.colorPicker{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import skins.colorPicker.color.HslRgb;

	public class Colors extends Sprite {
		public var colors:Sprite=new Sprite();//所有颜色的容器
		public var openColor:Shape=new Shape();//白边。
		private var colorBg:Shape=new Shape();//调色版面的背景
		public var opened:Boolean=false;

		public function Colors() {
			//this.mouseEnabled=false;
			for (var i:uint=0; i < 7; i++) {
				//添加黑白色
				var cb=HslRgb.hslToRgb(0,0,1-i/7);
				var _colorBlack=HslRgb.rgbToRGB(cb.r,cb.g,cb.b);
				var blackColor:baseCircle=new baseCircle(_colorBlack);
				blackColor.y=i*17;
				colors.addChild(blackColor);
				for (var j:uint=0; j < 9; j++) {

					//添加彩色
					var cc=HslRgb.hslToRgb(36*j,.7,.9-i*.1);
					var _color=HslRgb.rgbToRGB(cc.r,cc.g,cc.b);
					var baseColor:baseCircle=new baseCircle(_color);
					baseColor.y=i * 17;
					baseColor.x=j * 17+23;
					colors.addChild(baseColor);
				}
			}

			//设置被选中的颜色按钮的边框
			openColor.graphics.lineStyle(4,0xffffff);
			openColor.graphics.drawCircle(0,0,8);

			//设置调色板的背景
			colorBg.graphics.beginFill(0xeeeeee);
			colorBg.graphics.drawRoundRect(0,0,colors.width+25,colors.height+20,30);
			colorBg.graphics.endFill();
			colorBg.x=-23;
			colorBg.y=-20;

			addChild(colorBg);
			addChild(colors);
			addChild(openColor);
		}
	}
}

import flash.display.Sprite;
class baseCircle extends Sprite {
	public var c:uint;
	public function baseCircle(color:uint=0x000000) {
		graphics.beginFill(color);
		graphics.drawCircle(0,0,8);
		graphics.endFill();
		c=color;
	}
}