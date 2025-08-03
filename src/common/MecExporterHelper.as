package common
{
	import com.mechan.MecGrid.MecGrid;
	import com.mechan.MecGrid.mecGridClasses.MecGridEvent;
	import com.mechan.export.MecExporter;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.utils.Base64Encoder;
	
	import spark.components.Application;
	
	public class MecExporterHelper
	{
		/**
		 * 实例对象
		 */
		private static var instance:MecExporterHelper;
		
		/**
		 * MecGrid表格组件对象
		 */
		private var _mgrid:MecGrid = new MecGrid();
		
		/**
		 * 导出文件名
		 */
		private var _fileName:String;
		
		/**
		 * MecGrid表格组件放置容器
		 */
		private var _parent:Application = FlexGlobals.topLevelApplication as Application;
		
		public function MecExporterHelper()
		{
		}
		
		/**
		 * 单例模式
		 */
		public static function getInstance():MecExporterHelper{
			if(instance == null){
				instance = new MecExporterHelper();
			}
			return instance;
		}
		
		/**
		 * 开始导出
		 * @param dataProviderUpdatedHandler: MecGrid数据更新响应函数（比如在这设置统计行）
		 * @param debug:true表示调试模式，导出时界面上会显示MecGrid表格
		 */
		public function export(fileName:String, config:XML, data:Object,
							   dataProviderUpdatedHandler:Function = null, debug:Boolean = false):void{
			_fileName = fileName;
			
			if(debug){
				_mgrid.width = 600;
				_mgrid.height = 600;
			}
			
			if(dataProviderUpdatedHandler!=null){
				_mgrid.addEventListener(MecGridEvent.DATAPROVIDER_UPDATE_FINISHED, dataProviderUpdatedHandler);
			}
			
			_mgrid.ResourceXML = config;           
			_mgrid.dataProvider = data;            
			_parent.addElement(_mgrid);
			
			confirm();
		}
		
		/**
		 * 弹出下载确认框(不能直接下载，因为MecGrid表格还没初始化完毕)
		 */
		private function confirm():void{
			Alert.show("文件生成成功，请选择保存位置","提示",(Alert.YES|Alert.NO),null,function(event:CloseEvent):void{
				if(event.detail == Alert.YES){
					try
					{
						var exp:MecExporter=new MecExporter();
						
						// add MecGrid with sheetname
						exp.charset="zh_CN";
						exp.AddDataGrid(_mgrid, "Sheet1"); //页标题中文好像不行
						// exporting to binary data
						var ebt:ByteArray=exp.Export2BiffExcel();
						
						var b64encoder:Base64Encoder=new Base64Encoder();
						b64encoder.encodeBytes(ebt);
						var file:FileReference=new FileReference();
						file.save(ebt, _fileName);
						/* b64encoder.insertNewLines = false;
						b64encoder.encodeBytes(ebt);
						ExternalInterface.call("loadExcelFile", b64encoder.flush()); */
					}
					catch (e:Error)
					{
						Alert.show(e.message);
					}
				}
				
				_parent.removeElement(_mgrid);
			});
		}
	}
}