package common
{
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.crypto.hash.SHA256;
	import com.hurlant.util.Hex;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Encoder;

	public class MyEncrypt
	{
		private static var MD5_ADD:String="qwef12jp";
		private static var SHA256_ADD:String="45iuowrmf";
		public function MyEncrypt()
		{
		}
		public static function getMacArrress2():String{
			var netWorkVec:Vector.<NetworkInterface >  = NetworkInfo.networkInfo.findInterfaces();
			var macAdress:String="";
			for (var i:* in netWorkVec) {
				if(netWorkVec[i].hardwareAddress!=null&&netWorkVec[i].hardwareAddress.length>0){
					macAdress = netWorkVec[i].hardwareAddress;
				}
				//trace("网络连接名称："+netWorkVec[i].displayName);
				//trace("MAC网卡地址："+netWorkVec[i].hardwareAddress);
				/*var addressVec:Vector.<InterfaceAddress> = new Vector.<InterfaceAddress>();
				addressVec = netWorkVec[0].addresses;
				for (var j:* in addressVec) {
				trace("网络IP地址："+addressVec[j].address);
				} */
			}
			return macAdress;
		}
		
		public static function getNativeEncrypt():String{
			return NativeMessage.MACMSG;
			//return NativeMessage.CPUMSG;
		}
		
		//1层加密,本机码.
		public static function encode0to1():String{
			return SHA1Encrypt(getNativeEncrypt());
		}
		
		//把本机码(SHA1)加密成3层 **该方法为注册机使用
		public static function encode1to3(sha1Code:String):String{
			var result:String=SHA256Encrypt(MD5Encrypt(sha1Code+MD5_ADD)+SHA256_ADD);
			return result;
		}
		//mac直接转换成最终码
		public static function encode0to3(macAddress:String):String{
			var result:String = SHA256Encrypt(MD5Encrypt(SHA1Encrypt(getNativeEncrypt())+MD5_ADD)+SHA256_ADD);
			return result;
		}
		
		public static function SHA1Encrypt(src:String):String
		{
			var sha1:SHA1 = new SHA1();
			return Hex.fromArray(sha1.hash(Hex.toArray(src)));
		}
		
		public static function MD5Encrypt(src:String):String
		{
			var md5:MD5 = new MD5();
			return Hex.fromArray(md5.hash(Hex.toArray(src)));
		}
		
		public static function SHA256Encrypt(src:String):String {
			var sha256:SHA256 = new SHA256();
			return Hex.fromArray(sha256.hash(Hex.toArray(src)));
		}
		
	}
}