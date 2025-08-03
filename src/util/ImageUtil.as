package util
{
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.codec.PNGEncoder;
	
	public class ImageUtil { 
		
		public static var Instance:ImageUtil=new ImageUtil();
		
		public function ImageUtil()
		{
		}
		
		/**
		 * 取得屏幕显示对象转换的ByteArray数据
		 * */
		public static function getUIComponentByteArray(target:UIComponent):ByteArray
		{
			var imgByteArray:BitmapData = getUIComponentBitmapData(target); 
			var encoder:PNGEncoder = new PNGEncoder();  
			var data:ByteArray = encoder.encode(imgByteArray);
			
			return data;
		}
		
		/**
		 * 取得屏幕显示对象的BitmapData
		 * */
		public static function getUIComponentBitmapData(target:UIComponent):BitmapData 
		{  
			var bd:BitmapData = new BitmapData(target.width,target.height,true,0xffffff);
			bd.draw(target);  
			return bd;  
		} 
		
		/**
		 * 保存屏幕显示对象到图片(png)
		 * */  
		public static function saveScreen(target:UIComponent, fileName:String):void 
		{  
			var imgByteArray:BitmapData = getUIComponentBitmapData(target);
			var fr:Object = new FileReference();  
			if(fr.hasOwnProperty("save"))
			{  
				var encoder:PNGEncoder = new PNGEncoder();
				var data:ByteArray = encoder.encode(imgByteArray);  
				fr.save(data,fileName);
			}
			else
			{  
				Alert.show("当前flash player版本不支持此功能,请安装10.0.0以上版本！","提示");  
			}  
		}
	}  
}