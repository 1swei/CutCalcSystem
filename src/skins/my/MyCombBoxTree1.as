package skins.my
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.events.ScrollEvent;
	
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.ComboBox;
	import spark.events.DropDownEvent;
	
	public class MyCombBoxTree1 extends ComboBox
	{
		private var _tree:Tree; 
		private var __dataProvider:IList; 
		private var _dropDownWidth:int; 
		public var _dropDownHeight:int;
		public var xzqhbm:String;
		public var xzqhbmField:String;
		override protected function createChildren():void { 
			addEventListener(DropDownEvent.OPEN, dropDownControllerOpenHandler); 
			addEventListener(DropDownEvent.CLOSE, dropDownControllerCloseHandler);
			super.createChildren(); 
		} 
		override public function set dataProvider(value:IList):void { 
			__dataProvider = value; 
		} 
		private function dropDownControllerOpenHandler(event:DropDownEvent):void { 
			if (!_tree) { 
				_tree = new Tree();
			} 
			_tree.dataProvider = __dataProvider; 
			_tree.labelField = this.labelField; 
			_tree.width = _dropDownWidth ? _dropDownWidth : this.width; 
			_tree.height = _dropDownHeight ? _dropDownHeight : 150;
			popUpTree(); 
			StopLisentEventHandle();
		} 
		
		public function dropDownControllerCloseHandler(event:Event=null):void { 
			if (this._tree) { 
				PopUpManager.removePopUp(this._tree); 
				this.textInput.text = this._tree.selectedItem ? this._tree.selectedItem[this._tree.labelField] : '';
				xzqhbm = this._tree.selectedItem ? this._tree.selectedItem[xzqhbmField] : '';
				var treeboxevent:TreecomboboxEvent = new TreecomboboxEvent(xzqhbm);
				this.dispatchEvent(treeboxevent);
				
			} 
		} 
		
		override protected function dropDownController_closeHandler(event:DropDownEvent):void
		{
			if(_tree.selectedItem){
				StartLisentEventHandle();
				super.dropDownController_closeHandler(event);
			}
		}
		
		/** 
		 * 定位弹出窗口 
		 * 
		 */
		private function popUpTree():void { 
			this._tree.x = this.dropDownController.dropDown.x; 
			this._tree.y = this.dropDownController.dropDown.y; 
			PopUpManager.addPopUp(this._tree, this); 
		}
		/**
		 * 停止对事件流中当前节点中和所有后续节点中的事件侦听器进行处理。
		 * */
		private function  StopLisentEventHandle():void { 
			this.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			}); 
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
			this.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
			_tree.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
		} 
		/**
		 * 恢复对事件流中当前节点中和所有后续节点中的事件侦听器进行处理。
		 * */
		private function  StartLisentEventHandle():void {
			this.removeEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
			this.removeEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void { 
				e.stopImmediatePropagation(); 
			});
			_tree.removeEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):void {
				e.stopImmediatePropagation(); 
			});
		} 
		private function set dropDownHeight(value:int):void { 
			this._dropDownHeight = value; 
		}
		
		public function MyCombBoxTree1()
		{
			super();
		}
	}
}