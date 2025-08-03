package skins.my
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	import mx.core.Application;
	import mx.managers.CursorManager;
	
	
	public class MyTitleWindow extends TitleWindow
	{
		public function MyTitleWindow()
		{
			super();
			this.showCloseButton=true;
		}
		
		protected var maxSizeButton:Button; //最大化按钮
		[Embed("img/mouseAdd.png")]private var IconMaxSize:Class;//载入最大化图标
		[Embed("img/mouseAdd.png")]private var mouseOnIconMaxSize:Class;//载入最大化图标
		[Embed("img/mouseAdd.png")]private var mouseupIconMaxSize:Class;//载入最大化图标
		protected var minSizeButton:Button; //最小化按钮
		[Embed("img/mouseAdd.png")]private var IconMinSize:Class;//载入最小化图标
		[Embed("img/mouseAdd.png")]private var mouseOnIconMinSize:Class;//载入最小化图标
		[Embed("img/mouseAdd.png")]private var mouseupIconMinSize:Class;//载入最小化图标
		[Embed("img/mouseAdd.png")]private var Iconhuany:Class;//载入还原图标
		
		//调整TitleWindow大小
		private var mouseMargin:Number=4;//响应范围
		//设置光标的位置值 右上：3  右下：6 左下：11  左上8
		private var theSide:Number=0;
		private var SIDE_OTHER:Number=0;
		private var SIDE_TOP:Number=1;
		private var SIDE_RIGHT:Number=2;
		private var SIDE_LEFT:Number=7;
		private var SIDE_BOTTOM:Number=4;
		private var isReSize:Boolean;//是否允许缩放
		private var theOldPoint:Point;//改变大小前窗口的x，y坐标
		private var theMinWidth:Number=200;//窗口最小宽度
		private var theMinHeight:Number=200;//窗口最大高度
		private var theOldWidth:Number;//最大最小化时的宽
		private var theOldHeight:Number;//最大最小化时的高
		private var theStatus:int=0;//窗口状态，0正常 1最大化 2最小化；
		private var titleNormal:String;//正常状态下的标题
		private var titleMin:String;//最小化时的标题
		
		//当前鼠标光标类
		public var currentType:Class=null;
		
		//鼠标光标图标
		[Embed("img/mouseAdd.png")]
		private var CursorH:Class;
		[Embed("img/mouseAdd.png")]
		private var CursorR:Class;
		[Embed("img/mouseAdd.png")]
		private var CursorL:Class;
		[Embed("img/mouseAdd.png")]
		private var CursorV:Class;
		private var CursorNull:Class=null;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			//创建最大化按钮
			this.maxSizeButton=new LinkButton();
			this.maxSizeButton.width=this.maxSizeButton.height=16;
			this.maxSizeButton.y=6;
			this.maxSizeButton.setStyle("upIcon", IconMaxSize);
			this.maxSizeButton.setStyle("overIcon", mouseOnIconMaxSize);
			this.maxSizeButton.setStyle("downIcon", mouseupIconMaxSize);
			//添加最大化事件
			this.maxSizeButton.addEventListener(MouseEvent.CLICK,OnMaxSize);
			this.titleBar.addChild(this.maxSizeButton);
			
			//创建最小化按钮
			this.minSizeButton=new LinkButton();
			this.minSizeButton.width=this.minSizeButton.height=16;
			this.minSizeButton.y=6;
			this.minSizeButton.setStyle("upIcon", IconMinSize);
			this.minSizeButton.setStyle("overIcon", mouseOnIconMinSize);
			this.minSizeButton.setStyle("downIcon", mouseupIconMinSize);
			//添加最小化事件
			this.minSizeButton.addEventListener(MouseEvent.CLICK,OnMinSize);
			this.titleBar.addChild(this.minSizeButton);
			
			//侦听拖拽相关的事件
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			titleNormal = this.title;
			titleMin = this.title.substring(0, 8) + "...";
		}
		protected function OnMaxSize(e:MouseEvent):void
		{
			if(theStatus == 0)
			{
				onSaveRestore();
				winMaxSize();
			}
			else if(theStatus == 2){
				winMaxSize();
			}
			else if(theStatus == 1)
			{
				onGetRestore();
			}
		}
		protected function OnMinSize(e:MouseEvent):void
		{
			if(theStatus != 2){
				if(theStatus == 0){
					onSaveRestore();
				}
				winMinSize();
			}
			else{
				onGetRestore();
			}
		}
		
		override protected function startDragging(event:MouseEvent):void{
			//设置TitleWindow的拖动的矩形区域
			var rt:Rectangle = new Rectangle(0, 0, this.parent.width-this.width, this.parent.height-this.height);
			this.startDrag(false, rt);//设置可以拖动的矩形区域
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpEvent);
		}
		
		protected function mouseUpEvent(event:MouseEvent):void{
			this.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpEvent);
		}
		
		override protected function layoutChrome(unscaledWidth:Number,
												 unscaledHeight:Number):void
		{
			super.layoutChrome(unscaledWidth,unscaledHeight);
			//设置两个新添的按钮的位置
			this.maxSizeButton.x=this.titleBar.width-43;
			this.minSizeButton.x=this.titleBar.width-60;
			
			//调整状态文本的位置，左移一段位置
			this.statusTextField.x-=32;
		}
		
		
		//调整大小
		private function onMouseUp(event:MouseEvent):void
		{
			if(isReSize)
			{
				Application.application.parent.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				Application.application.parent.removeEventListener(MouseEvent.MOUSE_MOVE,onResize);
				isReSize=false;
				//				dispatchEvent(new Event(TITLEWINDOW_RESIZE));
			}
			onChangeCursor(CursorNull);
		}
		private function onMouseDown(event:MouseEvent):void
		{
			if(theSide!=0 && theSide != 5)
			{
				isReSize=true;
				Application.application.parent.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE,onResize);
				var point:Point=new Point();
				point=this.localToContent(point);
				theOldPoint=point;
			}
		}
		private function onResize(event:MouseEvent):void
		{
			if(isReSize)
			{
				var xPlus:Number=Application.application.parent.mouseX-this.x;
				var yPlus:Number=Application.application.parent.mouseY-this.y;
				switch(theSide)
				{
					case SIDE_RIGHT+SIDE_BOTTOM:
						this.width=xPlus>theMinWidth?xPlus:theMinWidth;
						this.height=yPlus>theMinHeight?yPlus:theMinHeight;
						break;
					case SIDE_LEFT+SIDE_TOP:
						this.width=this.width-xPlus>theMinWidth?this.width-xPlus:theMinWidth;
						this.height=this.height-yPlus>theMinHeight?this.height-yPlus:theMinHeight;
						this.x=this.width>theMinWidth?Application.application.parent.mouseX:this.x;
						this.y=this.height>theMinHeight?Application.application.parent.mouseY:this.y;
						break;
					case SIDE_LEFT+SIDE_BOTTOM:
						this.width=this.width-xPlus>theMinWidth?this.width-xPlus:theMinWidth;
						this.height=yPlus>theMinHeight?yPlus:theMinHeight;
						this.x=this.width>theMinWidth?Application.application.parent.mouseX:this.x;
						break;
					case SIDE_RIGHT+SIDE_TOP:
						this.width=xPlus>theMinWidth?xPlus:theMinWidth;
						this.height=this.height-yPlus>theMinHeight?this.height-yPlus:theMinHeight;
						this.y=this.height>theMinHeight?Application.application.parent.mouseY:this.y;
						break;
					case SIDE_RIGHT:
						this.width=xPlus>theMinWidth?xPlus:theMinWidth;
						break;
					case SIDE_LEFT:
						this.width=this.width-xPlus>theMinWidth?this.width-xPlus:theMinWidth;
						this.x=this.width>theMinWidth?Application.application.parent.mouseX:this.x;
						break;
					case SIDE_BOTTOM:
						this.height=yPlus>theMinHeight?yPlus:theMinHeight;
						break;
					case SIDE_TOP:
						this.height=this.height-yPlus>theMinHeight?this.height-yPlus:theMinHeight;
						this.y=this.height>theMinHeight?Application.application.parent.mouseY:this.y;
						break;
				}
			}
			
		}
		private function onMouseOut(event:MouseEvent):void
		{
			if(!isReSize&&this.theStatus==0)
			{
				theSide=0;
				onChangeCursor(CursorNull);
				this.isPopUp=true;
			}
		}
		private function onMouseMove(event:MouseEvent):void
		{
			if(!theStatus)
			{
				var point:Point=new Point();
				point=this.localToGlobal(point);
				var xPosition:Number=Application.application.parent.mouseX;
				var yPosition:Number=Application.application.parent.mouseY;
				if(xPosition>=(point.x+this.width-mouseMargin)&&yPosition>=(point.y+this.height-mouseMargin))
				{//右下
					onChangeCursor(CursorR,-9,-9);
					theSide=SIDE_RIGHT+SIDE_BOTTOM;
					this.isPopUp=false;
				}else if(xPosition<=(point.x+mouseMargin)&&yPosition<=(point.y+mouseMargin))
				{//左上
					onChangeCursor(CursorR,-9,-9);
					theSide=SIDE_LEFT+SIDE_TOP;
					this.isPopUp=false;
				}else if(xPosition<=(point.x+mouseMargin)&&yPosition>=(point.y+this.height-mouseMargin))
				{//左下
					onChangeCursor(CursorL,-9,-9);
					theSide=SIDE_BOTTOM+SIDE_LEFT;
					this.isPopUp=false;
				}else if(xPosition>=(point.x+this.width-mouseMargin)&&yPosition<=(point.y+mouseMargin))
				{//右上
					onChangeCursor(CursorL,-9,-9);
					theSide=SIDE_RIGHT+SIDE_TOP;
					this.isPopUp=false;
				}else if(xPosition>(point.x+this.width-mouseMargin))
				{//右
					onChangeCursor(CursorH,-9,-9);
					theSide=SIDE_RIGHT;
					this.isPopUp=false;
				}else if(xPosition<(point.x+mouseMargin))
				{//左
					onChangeCursor(CursorH,-9,-9);
					theSide=SIDE_LEFT;
					this.isPopUp=false;
				}else if(yPosition<(point.y+mouseMargin))
				{//上
					onChangeCursor(CursorV,-9,-9);
					theSide=SIDE_TOP;
					this.isPopUp=false;
				}
				else if(yPosition>(point.y+this.height-mouseMargin))
				{//下
					onChangeCursor(CursorV,-9,-9);
					theSide=SIDE_BOTTOM;
					this.isPopUp=false;
				}
				else
				{
					onChangeCursor(CursorNull);
					if(!isReSize&&theStatus==0)
					{
						theSide=0;
						this.isPopUp=true;
					}
				}
				event.updateAfterEvent();
			}
		}
		private function onChangeCursor(type:Class,xOffset:Number=0,yOffset:Number=0):void
		{
			if(currentType!=type)
			{
				currentType=type;
				CursorManager.removeCursor(CursorManager.currentCursorID);
				if(type!=null)
				{
					CursorManager.setCursor(type,2,xOffset,yOffset);
				}
			}
		}
		private function onSaveRestore():void
		{
			var point:Point=new Point();
			theOldPoint=this.localToGlobal(point);
			theOldWidth=this.width;
			theOldHeight=this.height;
		}
		private function onGetRestore():void
		{
			this.x=theOldPoint.x;
			this.y=theOldPoint.y
			this.width=theOldWidth;
			this.height=theOldHeight;			
			this.theStatus = 0;
			setWinIcon(theStatus);
			this.title = titleNormal;
		}
		
		private function winMaxSize():void{
			//设置为最大化状态
			this.x=0;
			this.y=0;
			this.height = this.parent.height;
			this.width = this.parent.width;
			this.theStatus = 1;
			setWinIcon(theStatus);
			this.title = titleNormal;
		}
		
		private function winMinSize():void{
			this.width = 200;
			this.height = 30;
			this.x  = 0;
			this.y = this.parent.height - 30;	
			this.theStatus = 2;
			setWinIcon(theStatus);
			this.title = titleMin;
		}
		
		private function setWinIcon(status:int):void{
			switch(status){
				case 0:
					this.minSizeButton.setStyle("upIcon", IconMinSize);
					this.minSizeButton.setStyle("overIcon", mouseOnIconMinSize);
					this.minSizeButton.setStyle("downIcon", mouseupIconMinSize);
					
					this.maxSizeButton.setStyle("upIcon", IconMaxSize);
					this.maxSizeButton.setStyle("overIcon", mouseOnIconMaxSize);
					this.maxSizeButton.setStyle("downIcon", mouseupIconMaxSize);
					break;
				case 1:
					this.maxSizeButton.setStyle("upIcon", Iconhuany);
					this.maxSizeButton.setStyle("overIcon", Iconhuany);
					this.maxSizeButton.setStyle("downIcon", Iconhuany);
					
					this.minSizeButton.setStyle("upIcon", IconMinSize);
					this.minSizeButton.setStyle("overIcon", mouseOnIconMinSize);
					this.minSizeButton.setStyle("downIcon", mouseupIconMinSize);
					break;
				case 2:
					this.minSizeButton.setStyle("upIcon", Iconhuany);
					this.minSizeButton.setStyle("overIcon", Iconhuany);
					this.minSizeButton.setStyle("downIcon", Iconhuany);
					
					this.maxSizeButton.setStyle("upIcon", IconMaxSize);
					this.maxSizeButton.setStyle("overIcon", mouseOnIconMaxSize);
					this.maxSizeButton.setStyle("downIcon", mouseupIconMaxSize);
					break;
			}
		}
	}
}