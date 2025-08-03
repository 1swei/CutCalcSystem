package skins
{
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	
	import mx.core.IFlexDisplayObject;
	import mx.effects.Blur;
	import mx.events.TweenEvent;
	import mx.managers.PopUpManager;
	
	import spark.effects.Fade;

	public class PopUpEffect extends PopUpManager
	{
		public function PopUpEffect()
		{
			super();
		}
		public static function Show(control:IFlexDisplayObject,parent:DisplayObject,modal:Boolean=true,center=true):void
		{
			PopUpManager.addPopUp(control,parent,modal);
			PopUpManager.centerPopUp(control);
			//淡入
			var fade:Fade=new Fade();
			fade.target=control;
			fade.alphaFrom=0;
			fade.duration=800;//持续时间
			fade.alphaTo=1;
			fade.play();
			PopUpModellocator.getInstance().push(control);
			//模糊
			/*var mShowEffect:Blur=new Blur();
			mShowEffect.blurXFrom=255;
			mShowEffect.blurYFrom=255;
			mShowEffect.blurXTo=0;
			mShowEffect.blurYTo=0;
			mShowEffect.target= control;
			mShowEffect.duration=300;
			PopUpManager.addPopUp(control,parent,modal);
			PopUpManager.centerPopUp(control);
			mShowEffect.play();*/
			
		}
		public static function Hide(control:IFlexDisplayObject):void
		{
			/*var fade:Fade=new Fade();
			fade.target=control;
			fade.alphaFrom=1;
			fade.duration=1000;
			fade.alphaTo=0;
			fade.addEventListener(TweenEvent.TWEEN_END,function(){
				PopUpManager.removePopUp(control);
			});
			fade.play();
			setTimeout(remove(control),1000);*/
			
		/*	var m:Move=new Move();
			m.target=o;
			m.duration=800;
			m.xTo=2000;
			m.yTo=-2000;
			m.play();
			setTimeout(fun,800);*/
			
			var mHideEffect:Blur=new Blur();
			mHideEffect.blurXFrom=0;
			mHideEffect.blurYFrom=0;
			mHideEffect.blurXTo=120;
			mHideEffect.blurYTo=120;
			mHideEffect.addEventListener(TweenEvent.TWEEN_END,function(){
				PopUpManager.removePopUp(control);
				PopUpModellocator.getInstance().pop(control);
			});
			mHideEffect.duration=300;
			mHideEffect.target=control;
			mHideEffect.play();
		}
	}
}