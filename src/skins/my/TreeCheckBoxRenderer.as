package skins.my
{  
	import flash.events.Event;  
	
	import mx.controls.CheckBox;  
	import mx.controls.treeClasses.TreeItemRenderer;  
	import mx.controls.treeClasses.TreeListData;  
	
	/** 
	 * 支持CheckBox的TreeItemRenderer 
	 * @author Montage 
	 */   
	public class TreeCheckBoxRenderer extends TreeItemRenderer  
	{  
		public function TreeCheckBoxRenderer()  
		{  
			super();  
		}  
		
		/** 
		 * 表示CheckBox控件从data中所取数据的字段 
		 */       
		private var _selectedField:String = "selected";  
		
		protected var checkBox:CheckBox;  
		
		/** 
		 * 构建CheckBox 
		 */       
		override protected function createChildren():void  
		{  
			super.createChildren();  
			checkBox = new CheckBox();  
			addChild( checkBox );  
			checkBox.addEventListener(Event.CHANGE, changeHandler);  
		}  
		
		/** 
		 * 点击checkbox时,更新dataProvider 
		 * @param event 
		 */       
		protected function changeHandler( event:Event ):void  
		{  
			if( data && data[_selectedField] != undefined )  
			{  
				data[_selectedField] = checkBox.selected;  
			}  
		}   
		
		/** 
		 * 初始化控件时, 给checkbox赋值 
		 */       
		override protected function commitProperties():void  
		{  
			super.commitProperties();  
			trace(data[_selectedField])  
			if( data && data[_selectedField] != undefined )  
			{  
				checkBox.selected = data[_selectedField];  
			}  
			else  
			{  
				checkBox.selected = false;  
			}  
		}  
		
		/** 
		 * 重置itemRenderer的宽度 
		 */       
		override protected function measure():void  
		{  
			super.measure();  
			measuredWidth += checkBox.getExplicitOrMeasuredWidth();  
		}  
		
		/** 
		 * 重新排列位置, 将label后移 
		 * @param unscaledWidth 
		 * @param unscaledHeight 
		 */       
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void  
		{  
			super.updateDisplayList(unscaledWidth, unscaledHeight);  
			var startx:Number = data ? TreeListData( listData ).indent : 0;  
			
			if (disclosureIcon)  
			{  
				disclosureIcon.x = startx;  
				
				startx = disclosureIcon.x + disclosureIcon.width;  
				
				disclosureIcon.setActualSize(disclosureIcon.width,  
					disclosureIcon.height);  
				
				disclosureIcon.visible = data ?  
					TreeListData( listData ).hasChildren :  
					false;  
			}  
			
			if (icon)  
			{  
				icon.x = startx;  
				startx = icon.x + icon.measuredWidth;  
				icon.setActualSize(icon.measuredWidth, icon.measuredHeight);  
			}  
			
			checkBox.move(startx, ( unscaledHeight - checkBox.height ) / 2 );  
			
			label.x = startx + checkBox.getExplicitOrMeasuredWidth();  
		}  
	}  
}  