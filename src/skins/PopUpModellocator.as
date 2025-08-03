package skins
{
	import com.adobe.utils.ArrayUtil;

	[Bindable]
	public class PopUpModellocator
	{
		public function PopUpModellocator()
		{
		}
		private static var instance:PopUpModellocator;  
		//保存pop出来的窗口  
		private var popupArray:Array ;  
		
		
	/*	public function DataGridModellocator()  
		{  
			if(instance==null){  
				instance = this;  
			}  
		}  */
		
		public static function getInstance():PopUpModellocator{  
			if(instance==null){  
				instance = new PopUpModellocator();  
			}  
			return instance;  
		}
		
		public function push(control:*):void{  
			if(!popupArray){  
				popupArray = new Array;  
			}  
			popupArray.push(control);  
		}
		
		public function pop(control:*):void{  
			if(popupArray){  
				ArrayUtil.removeValueFromArray(popupArray,control);  
			}  
		}  
		/**关闭所有弹出窗口*/
		public function popAll():void{  
			if(popupArray&&popupArray.length>0){  
				PopUpEffect.Hide(popupArray[popupArray.length-1]);  
				popAll();  
			}else{  
				return;  
			}  
		}
		/**获取所有弹出窗*/
		public function getPopAll():Array{
			return popupArray;
		}
	}
}