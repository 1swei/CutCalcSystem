package skins
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;
	public class BindTextInput extends mx.controls.TextInput
	{
		public function BindTextInput()
		{
			super();
			initEvent();
			this.height=22;
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
		
		private function initEvent():void{
			this.addEventListener(FocusEvent.FOCUS_IN,myFocus_IN);
			this.addEventListener(FocusEvent.FOCUS_OUT,myFocus_OUT);
			this.addEventListener(Event.CHANGE,my_CHANGE);
		}
		private function myFocus_IN(e:FocusEvent):void{
			if(this.text.length>0){
				this.setSelection(0,this.text.length);
			}
			_textChange=false;
		}
		private function myFocus_OUT(e:FocusEvent):void{
			/*if(dataField!=null&&dataField.length>0&&data!=null&&_textChange){
				data[dataField]=this.text;
				_textChange=false;
			}*/
		}
		private function my_CHANGE(e:Event):void{
			if(dataField!=null&&dataField.length>0&&data!=null){
				data[dataField]=this.text;
			}
			_textChange=true;
		}
	}
}