package common
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filesystem.StorageVolume;
	import flash.filesystem.StorageVolumeInfo;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import mx.utils.StringUtil;
	
	public class NativeMessage extends Sprite
	{
		private var nativeProcess:NativeProcess;
		public static var CPUMSG:String;//CPU信息
		public static var MACMSG:String;//MAC地址
		
		public function NativeMessage() {
			super();
			this.init();
		}
		
		private function init():void {
			
			this.getDeskInfo();
			
			//网络信息
			if (NetworkInfo.isSupported) {
				var info:NetworkInfo=NetworkInfo.networkInfo;
				
				var infofaceVec:Vector.<NetworkInterface>=info.findInterfaces();
				this.getAddress(infofaceVec);
			}
			
			initProcess();
		}
		
		private function getAddress(it:Vector.<NetworkInterface>):void {
			var address:InterfaceAddress;
			var infoface:NetworkInterface;
			var subinfoface:NetworkInterface;
			for each (infoface in it) {
				trace(infoface.active);
				trace(infoface.displayName);
				trace(infoface.mtu);
				trace(infoface.hardwareAddress);
				
				if(infoface.hardwareAddress!=null&&infoface.hardwareAddress!=""){
					MACMSG=infoface.hardwareAddress;
				}
				trace("============================");
				for each (address in infoface.addresses) {
					trace("address", address.address)
					trace("broadcast", address.broadcast)
					trace("ipVersion", address.ipVersion)
					trace("prefixLength", address.prefixLength)
				}
				
				trace("============================");
				if (infoface.subInterfaces != null) {
					getAddress(infoface.subInterfaces);
				}
				
				if (infoface.parent != null)
					trace(infoface.parent.displayName)
				trace("---------------------------------------------");
			}
		}
		
		private function getDeskInfo():void {
			var svi:StorageVolumeInfo=StorageVolumeInfo.storageVolumeInfo;
			
			var svec:Vector.<StorageVolume>=svi.getStorageVolumes();
			var sv:StorageVolume;
			for each (sv in svec) {
				trace(sv.drive);
				trace(sv.fileSystemType);
				trace(sv.isRemovable);
				trace(sv.isWritable);
				trace(sv.name);
				trace("==============================");
			}
		}
		
		private function initProcess():void {
			
			var str:String='MsgValue = ""\n';
			str+='Set objWMIService = GetObject("winmgmts:\\\\.\\root\\cimv2")\n';
			//''获取硬盘序列号
			str+='Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMedia")\n';
			str+='For Each objItem In colItems\n';
			str+="    Wscript.Echo \"111\" & objItem.SerialNumber \n";
			str+="    exit for  ' do the first cpu only! \n";
			//str+='   MsgValue = MsgValue & vbCrLf & "硬盘 = " & objItem.SerialNumber\n';
			//str+='   MsgValue = objItem.SerialNumber\n';
			str+='Next\n';
			//str+='';
			//str+='Wscript.Echo MsgValue\n'; 
			
			var tmpfile:File=File.userDirectory;
			var f:File=tmpfile.resolvePath("e.vbs");
			
			var fs:FileStream=new FileStream();
			fs.openAsync(f, FileMode.WRITE);
			fs.writeMultiByte(str, "ansl");
			fs.close();
			
			var args:Vector.<String>=new Vector.<String>();
			args.push('/c cscript ' + f.nativePath);
			
			var nativstart:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			
			nativstart.executable=new File("C:/WINDOWS/system32/cmd.exe");
			nativstart.arguments=args;
			
			nativeProcess=new NativeProcess();
			nativeProcess.start(nativstart);
			
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStandardOutPut);
			nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onStandardError);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onStandardErrorIo);
			nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onStandardErrorIo);
		}
		
		private function onStandardOutPut(e:ProgressEvent):void {
			var by:IDataInput=IDataInput(e.target.standardOutput);
			var outStr:String=by.readMultiByte(by.bytesAvailable, "ansl");
			if (outStr.indexOf("111") > -1){
				CPUMSG=outStr.substring(outStr.indexOf("111"),outStr.length);	
				trace(outStr.replace("111","").replace(/ +/g,""));
			}
		}
		
		private function onStandardError(e:ProgressEvent):void {
			var by:IDataInput=IDataInput(e.target.standardOutput);
			trace(by.readMultiByte(by.bytesAvailable, "ansl"), "---");
			
		}
		
		private function onStandardErrorIo(e:IOErrorEvent):void {
			trace(e.target, ">>>")
		}
		
	}
}