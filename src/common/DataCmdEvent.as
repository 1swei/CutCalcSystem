package common
{
	import flash.events.Event;
	
	public class DataCmdEvent extends Event
	{
		/**
		 * 命令：保存
		 * */
		public static const COMMAND_SAVE:String="DataCmdEvent_Save";
		/**
		 * 命令：创建
		 * */
		public static const COMMAND_CREATE:String="DataCmdEvent_Create";
		/**
		 * 命令：修改
		 * */
		public static const COMMAND_EDIT:String="DataCmdEvent_Edit";
		/**
		 * 命令：删除
		 * */
		public static const COMMAND_DEL:String="DataCmdEvent_Del";
		/**
		 * 命令：重置
		 * */
		public static const COMMADN_RESET:String="DataCmdEvent_Reset";
		/**
		 * 命令：提交
		 * */
		public static const COMMAND_SUBMIT:String="DataCmdEvent_Submit";
		
		public static const COMMAND_SHOW:String="DataCmdEvent_Show";
		
		public static const COMMAND_SELECT:String="DataCmdEvent_Select";
		
		public function DataCmdEvent(type:String,data:Object,cmd:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data=data;
			this._command=cmd;
		}
		
		private var _data:Object;
		
		private var _command:Object;
		
		public function get data():Object{
			return _data;
		}
		public function get command():Object{
			return _command;
		}
	}
}