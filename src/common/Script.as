package common
{
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.Evaluator;
	
	import flash.utils.ByteArray;

	public class Script
	{
		public function Script()
		{
		}
		public function eval(src:String) : void {
			var evaluator:Evaluator = new Evaluator
			var bytes:ByteArray = evaluator.eval(src);
			ByteLoader.loadBytes(bytes);
		}
	}
}