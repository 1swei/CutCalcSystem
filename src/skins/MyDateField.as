package skins
{
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	
	public class MyDateField extends DateField
	{
		public function MyDateField()
		{
			super();
			initStyle();
			this.formatString="YYYY-MM-DD";
			this.height=22;
			yearNavigationEnabled=true;
			monthNames=["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
			dayNames=["七","一","二","三","四","五","六"];
			initEvent();
		}
		private function initStyle():void{
			/*this.setStyle("color",0x000000);
			this.setStyle("focusColor",0xCCCCCC);
			this.setStyle("borderVisible",false);
			this.setStyle("contentBackgroundColor",0xFFFFFF);
			this.setStyle("focusAlpha",0);
			this.setStyle("headerColors",[0xCCCCCC,0x28313A]);*/
		}
		private function  initEvent():void{
			this.addEventListener(CalendarLayoutChangeEvent.CHANGE,my_CHANGE);
		}
		override protected function createChildren():void{
			super.createChildren();
			/*this.textInput.setStyle("color",0x000000);
			this.textInput.setStyle("focusColor",0xCCCCCC);
			this.textInput.setStyle("borderVisible",false);
			this.textInput.setStyle("contentBackgroundColor",0xFFFFFF);
			this.textInput.setStyle("focusAlpha",0);*/
		}
		public function set textInputColor(v:uint):void{
			/*if(this.textInput){
				this.textInput.setStyle("color",v);
			}*/
		}
		public function get textInputColor():uint{
			if(this.textInput){
				return this.textInput.getStyle("color");
			}else{
				return 0x000000;
			}
		}
		
		private var _dataField:String;
		private var _textChange:Boolean=false;
		[Bindable]
		public function get dataField():String{
			return _dataField;
		}
		public function set dataField(value:String):void{
			this._dataField=value;
		}
		private function my_CHANGE(e:CalendarLayoutChangeEvent):void{
			if(dataField!=null&&dataField.length>0&&data!=null){
				data[dataField]=this.selectedDate;
			}
		}
	}
}