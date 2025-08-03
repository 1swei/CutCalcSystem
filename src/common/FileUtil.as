package common
{
	import entity.OrderDetailBL;
	import entity.PicBL;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.TextInput;

	public class FileUtil
	{
		public function FileUtil()
		{
		}
		
		//桌面目录
		public static var desktopPath:String=File.desktopDirectory.nativePath;
		//二维码目录
		public static var qrCodePath:String=File.applicationDirectory.nativePath+"\\img\\";
		//二维码
		public static var qrCode:String=File.applicationDirectory.nativePath+"\\img\\qrcode.jpg";
		//本地临时窗型图目录
		public static var winTmpPath:String=File.documentsDirectory.nativePath+"\\windows\\";
		//窗型远程地址
		public static var winRemotePath:String;
		//数据库远程地址
		public static var dataBasePath:String;//File.documentsDirectory.nativePath+"\\CNSystem.db"
		//配置文件
		public static var dbConfig:String=File.documentsDirectory.nativePath+"\\CNConfig.xml";
		//备份目录
		public static var backUpPath:String="C:\\CNSBackup\\";
		//窗型图筛选
		public static var imageTypes:FileFilter=new FileFilter("Images (*.jpg, *.jpeg, *.png, *.gif)","*.jpg; *.jpeg; *.png; *.gif;") ;
		//宽
		public static var width_pic:int=745;
		//高
		public static var height_pic:int=522;
		//通过图片绑定的变量集合,自动图片上添加变量W,H(此方法为第一次开单选择窗型图) PicBl 
		public static function autoSetBLOnPic(_winPic:Image,_picName:String):ArrayCollection{
			var arrBL:ArrayCollection=PicBL.getBlbyParam(_picName);
			if(arrBL==null||arrBL.length==0){
				return new ArrayCollection();
			}
			for(var i:int=0;i<arrBL.length;i++){
				var blItem:PicBL = arrBL.getItemAt(i) as PicBL;
				createTextInputOnPic(_winPic,"text"+i,blItem.blX/blItem.picWidth*_winPic.width,blItem.blY/blItem.picHeight*_winPic.height,blItem.blName,blItem.blName);
			}
			return arrBL;
		}
		/**通过订单明细的blList,动态给图片加值 OrderDetailBL*/
		public static function autoSetBlValueOnPic(_winPic:Image,_blList:ArrayCollection,_picBL:ArrayCollection,_styleName:String="smallText"):void{
			if(_blList==null||_blList.length==0){
				return;
			}
			for(var i:int=0;i<_blList.length;i++){
				var ordermBl:OrderDetailBL = _blList.getItemAt(i) as OrderDetailBL;
				//通过订单存的变量名,找到变量在图片中的xy坐标.并赋值
				var picBl:PicBL = ArrayCollectionUtil.getItem(ordermBl.blName,_picBL,'blName') as PicBL;
				if(picBl==null){
					continue;
				}
				createTextInputOnPic(_winPic,"text"+i,picBl.blX/picBl.picWidth*_winPic.width,picBl.blY/picBl.picHeight*_winPic.height,picBl.blName,ordermBl.blValue+"",_styleName);
			}
			
		}
		/**根据图片创建对应变量,和变量内容*/
		public static function createTextInputOnPic(_winPic:Image,_textname:String,_x:Number,_y:Number,_textName:String,_textValue:String="",_styleName:String="smallText"):TextInput{
			_winPic.validateNow();
			var textIn:TextInput = new TextInput();
			textIn.height=20;
			textIn.width=40;
			textIn.maxChars=5;
			textIn.x = DataFormat.formatNumber2(_x);
			textIn.y = DataFormat.formatNumber2(_y);
			textIn.name=_textName;//这里控件的name用内容W,H,方便获取
			textIn.text=_textValue;
			textIn.restrict="^a-z.";//不能输入小写字母
			textIn.toolTip=_textValue==""?"请输入变量名":_textValue;
			textIn.styleName=_styleName;
			textIn.editable=false;
			_winPic.addChild(textIn);
			return textIn;
		}
		
		public static function removeAllChild(_winPic:Image):void{
			var childs:int=_winPic.numChildren;
			for(;childs>1;childs--){
				var _text:TextInput = _winPic.getChildAt(childs-1) as TextInput;
				if(_text&&_text.parent){
					_winPic.removeChild(_text);
				}
			}
		}
		//创建目录
		public static function createDirFile(dirFile:File, newDirName:String):void{  
			var sonDirFile:File = dirFile.resolvePath(newDirName);  
			sonDirFile.createDirectory();  
		}
		public static function createDirPath(dirFile:File):void{  
			var sonDirFile:File = dirFile.resolvePath(dirFile.nativePath);  
			sonDirFile.createDirectory();  
		}
		//copyDirFile(File.userDirectory, File.documentsDirectory);
		//把指定目录从一个指定目录复制到另外一个指定目录  
		public static function copyDirFile(fromDirFile:File, toDirFile:File):Boolean{
			var result:Boolean = true;
			try{  
				var copyDirFile:File = fromDirFile;  
				copyDirFile.copyTo(toDirFile, true);  
			}catch(error:Error){
				result=false;
				Alert.show(error.message,"提示");  
			}
			return result;
		}  
		
		
	}
}