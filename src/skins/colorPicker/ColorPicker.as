package skins.colorPicker{
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import skins.colorPicker.color.ColorProperty;
	import skins.colorPicker.color.HslRgb;
	import skins.colorPicker.colorPicker.Colors;

	public class ColorPicker extends Sprite {
		private var picker:Sprite=new Sprite();
		private var _color:Bitmap=new Bitmap();
		private var t:Sprite;
		private var _colors:Colors;
		private var colorsMask:Shape=new Shape();
		private var colorsMove:Tween;
		private var bg:MovieClip;
		private var H:MovieClip;
		private var L:MovieClip;
		private var S:MovieClip;
		private var R:MovieClip;
		private var G:MovieClip;
		private var B:MovieClip;
		private var Hnum:Number=0;
		private var Lnum:Number=.5;
		private var Snum:Number=1;
		private var Rnum:int=255;
		private var Gnum:int=0;
		private var Bnum:int=0;
		private var colorNum:uint;
		private var pickerColor:skins.colorPicker.color.ColorProperty;
		
		public function ColorPicker() {
			initView();
			picker.x=picker.y=200;
			_color.x=_color.y=-60;
			picker.mouseEnabled=false;
			picker.addChild(bg);
			picker.addChild(_color);
			picker.addChild(H);
			picker.addChild(L);
			picker.addChild(S);
			picker.addChild(R);
			picker.addChild(G);
			picker.addChild(B);
			addChild(picker);
			
			pickerColor=new ColorProperty(_color);//色盘
			picker.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,OnMouseUp);
			
			colorTxt();
			makeColors();
		}
		public function get color(){
			return colorNum;
		}
		private function makeColors() {
			colorsMask.graphics.beginFill(0x000000);
			colorsMask.graphics.drawRect(-72,-70,204,160);
			colorsMask.graphics.endFill();
			picker.addChild(colorsMask);
			_colors=new Colors();
			_colors.x=120;
			_colors.y=-50;
			picker.addChild(_colors);
			_colors.mask=colorsMask;
			_colors.addChild(t)
			t.x=-18;
			t.y=50;
			_colors.addEventListener(MouseEvent.CLICK,colorsOpen);
		}
		
		private function colorsOpen(e:MouseEvent){
			if (!_colors.opened) {
				colorsMove=new Tween(_colors,"x", Strong.easeOut, 120, -50, .5, true);
				_colors.opened=true
				_colors.colors.addEventListener(MouseEvent.MOUSE_OVER,colorsOver);
				t.scaleX=-1;
			}else{
				colorsMove.continueTo(120,.5);
				_colors.opened=false;
				_colors.colors.removeEventListener(MouseEvent.MOUSE_OVER,colorsOver);
				t.scaleX=1;
			}
		}
		private function colorsOver(e:MouseEvent) {
			Rnum=HslRgb.hexToRgb(e.target.c).r
			Gnum=HslRgb.hexToRgb(e.target.c).g
			Bnum=HslRgb.hexToRgb(e.target.c).b
			_colors.openColor.x=e.target.x
			_colors.openColor.y=e.target.y
			setRGB()
		}
		private function OnMouseDown(e:MouseEvent) {
			switch (e.target) {
				case H :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,HFunc);
					break;
				case L :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,LFunc);
					break;
				case S :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,SFunc);
					break;
				case R :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,RFunc);
					break;
				case G :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,GFunc);
					break;
				case B :
					stage.addEventListener(MouseEvent.MOUSE_MOVE,BFunc);
					break;
				default :
			}
		}
		private function OnMouseUp(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,HFunc);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,LFunc);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,SFunc);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,RFunc);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,GFunc);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,BFunc);
		}
		private function HFunc(e:MouseEvent) {
			H.sDrag();
			Hnum=H.point;
			setHSL();
		}
		private function SFunc(e:MouseEvent) {
			S.sDrag();
			pickerColor.saturation=Snum=S.point;
			setHSL();
		}
		private function LFunc(e:MouseEvent) {
			L.sDrag();
			pickerColor.brightness=Lnum=1-L.point;
			setHSL();
		}
		private function RFunc(e:MouseEvent) {
			R.sDrag();
			Rnum=R.point*255;
			setRGB();
		}
		private function GFunc(e:MouseEvent) {
			G.sDrag();
			Gnum=G.point*255;
			setRGB();
		}
		private function BFunc(e:MouseEvent) {
			B.sDrag();
			Bnum=B.point*255;
			setRGB();
		}
		private function setHSL() {
			Rnum=HslRgb.hslToRgb(Hnum,Snum,Lnum).r;
			Gnum=HslRgb.hslToRgb(Hnum,Snum,Lnum).g;
			Bnum=HslRgb.hslToRgb(Hnum,Snum,Lnum).b;
			colorNum=HslRgb.rgbToRGB(Rnum,Gnum,Bnum);
			setColor();
		}
		private function setRGB() {
			Hnum=HslRgb.rgbToHsl(Rnum,Gnum,Bnum).h;
			Snum=HslRgb.rgbToHsl(Rnum,Gnum,Bnum).s;
			Lnum=HslRgb.rgbToHsl(Rnum,Gnum,Bnum).l;
			colorNum=HslRgb.rgbToRGB(Rnum,Gnum,Bnum);
			pickerColor.brightness=Lnum;
			pickerColor.saturation=Snum;
			setColor();
		}
		private function setColor() {
			R.point=Rnum/255;
			G.point=Gnum/255;
			B.point=Bnum/255;
			H.point=Hnum;
			L.point=1-Lnum;
			S.point=Snum;
			H.setColor(colorNum);
			colorTxt();
		}
		private function colorTxt() {
			bg.color.text=HslRgb.toHex(colorNum);
			bg.H.text="H: "+int(Hnum)+"°";
			bg.S.text="S: "+int(Snum*100)+"%";
			bg.L.text="L: "+int((Lnum-.5)*200)+"%";
			bg.R.text="R: "+Rnum;
			bg.G.text="G: "+Gnum;
			bg.B.text="B: "+Bnum;
		}
		private function initView() {
			var __color:BitmapData=new (getDefinitionByName("colorBitmap") as Class)(120,120);
			_color=new Bitmap(__color);
			bg=new (getDefinitionByName("bg") as Class);
			t=new (getDefinitionByName("t") as Class);
			H=new skins.colorPicker.colorPicker.ColorBtn();
			S=new skins.colorPicker.colorPicker.controlBtn(-10,-80,80,1);
			L=new skins.colorPicker.colorPicker.controlBtn(80,10,80,.5);
			R=new skins.colorPicker.colorPicker.controlBtn(40,-50,30,1,0xf389ae);
			G=new skins.colorPicker.colorPicker.controlBtn(160,70,30,0,0xcbe497);
			B=new skins.colorPicker.colorPicker.controlBtn(-80,-170,30,0,0xa8c9e6);
		}
	}
}