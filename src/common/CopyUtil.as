package common
{
	import flash.utils.ByteArray;

	public class CopyUtil
	{
		public function CopyUtil()
		{
		}
		public static function clone(object:Object):Object{
			/*var qClassName:String = getQualifiedClassName(object);
			var objectType:Class = getDefinitionByName(qClassName) as Class;
			registerClassAlias(qClassName, objectType);*/
			var copier : ByteArray = new ByteArray();
			copier.writeObject(object);
			copier.position = 0;
			return copier.readObject();
		}
	}
}