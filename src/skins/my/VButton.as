package skins.my
{
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Button;
	import mx.controls.ButtonLabelPlacement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	/**
	 * 	@类名:	VButton
	 * 	@作者:	Angine
	 * 	@日期:	2010-1-27
	 * 	@版本:	V1.0
	 * 	@描述:
	 * 		垂直按钮类实现按钮Label文本垂直显示功能
	 * 		功能实现通过获取到Button内部textField引用，
	 * 		并对textField中的设置作出更改。
	 * 		如果你需要调整文字与按钮的位置，需要考虑按钮的 Width,Height,fontSize
	 * 		及paddingBottom="0" paddingLeft="0" paddingRight="0" paddingTop="0" 等样式
	 */ 
	use namespace mx_internal;
	public class VButton extends Button
	{
		public function VButton()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			buttonMode=true;
			textField.wordWrap=true;
			this.labelPlacement=ButtonLabelPlacement.TOP;
			textField.autoSize=TextFieldAutoSize.CENTER;
			this.setStyle("paddingBottom",0);
			this.setStyle("paddingLeft",0);
			this.setStyle("paddingRight",0);
			this.setStyle("paddingTop",0);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,                 unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			textField.y=(height-textField.height)/2;
			textField.x=(width-textField.width)/2;
		}
	}
}