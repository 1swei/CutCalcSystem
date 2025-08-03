package common
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.utils.ArrayUtil;
	import mx.utils.StringUtil;

	public class ArrayCollectionUtil
	{
		public function ArrayCollectionUtil()
		{
			//ArrayUtil
		}
		public static function getItemIndex(item:Object,source:ArrayCollection,fields:Array = null):int{
			if(fields == null || fields.length <= 0){
				return source.getItemIndex(item);//ArrayUtil.getItemIndex(item,source);
			}else{
				var n:int = source.length;
				var i:int;
				var j:int;
				var x:int;
				var field:String;
				var o:Object;
				for (i = 0; i < n; i++){
					o = source.getItemAt(i);
					x = 0;
					for(j=0;j<fields.length;j++){
						field = fields[j] as String;
						if(o.hasOwnProperty(field)
							&&item.hasOwnProperty(field)
							&&o[field]==item[field]){
							x++;
						}
					}
					if(x==fields.length){
						return i;
					}
					
				}
				return -1;
			}
			
		}
		
		public static function contains(item:Object,source:ArrayCollection,fields:Array = null):Boolean{
			return getItemIndex(item,source,fields) != -1;
		}
		
		public static function updateItem(item:Object,source:ArrayCollection,fields:Array = null):Object{
			var index:int = getItemIndex(item,source,fields);
			if(index != -1){
				return source.setItemAt(item,index);
			}else{
				return null;
			}
		}
		
		public static function removeItem(item:Object,source:ArrayCollection,fields:Array = null):Object{
			var index:int = getItemIndex(item,source,fields);
			if(index != -1){
				return source.removeItemAt(index);
			}else{
				return null;
			}
		}
		
		public static function addItem(item:Object,source:ArrayCollection,fields:Array = null):Boolean{
			var index:int = getItemIndex(item,source,fields);
			if(index != -1){
				return false
			}else{
				source.addItem(item);
				return true;
			}
		}
		
		public  static  function  returnLength(str:String):int
		{
			if(str==null||str=="")
			{
				return 0;
			}
			var array:Array = StringUtil.trim(str).split(",");
			if (array!=null)
			{
				return  array.length;		
			}
			return   0;	
		}	
		
		public static  function  findField(array:ArrayCollection,os:String,value:int,view:String):String     //查找字段
		{
			var n:int = array.length;    //获取长度
			var i:int;
			var  o:Object;
	
			for (i = 0; i < n; i++)      //循环
			{
				o=array.getItemAt(i);
				if (o[os]==value)    
				{
					trace(o[view].toString());
					return o[view].toString();
					break;
				}
			
			}
			return  " ";
			
		}
		
		public static  function  findField1(array:ArrayCollection,os:int,value:int,view:int):String     //查找字段
		{
			var n:int = array.length;    //获取长度
			var i:int;
			var  o:Object;
			var result:String="";
			for (i = 0; i < n; i++)      //循环
			{
				o=array.getItemAt(i);
				if (o[os]==value)    
				{
					trace(o[view].toString());
					result=Number(o[view]).toString();
					break;
				}
				
			}
			return  result;
			
		}
		
		
		
		public  static  function  findIndex(array:ArrayCollection,os:String,value:int):int
		{
		
			var n:int = array.length;    //获取长度
			var i:int;
			var  o:Object;
			if(value==0)
			{
				return  -1;
			}	
			for (i = 0; i < n; i++)      //循环
			{
				o=array.getItemAt(i);
				if (o[os]==value)    
				{
					return i;
					break;
				}	
			}
			return  -1;
		}
		
		
		public static function   calcTotol(array:ArrayCollection,s:String):String
		{
			var  num:Number=0.00;
			if(array!=null&&array.length>0)
			{
				for(var  i:int=0;i<array.length;i++)
				{
					var  o:Object=array.getItemAt(i)  as  Object;		  
					num=num+o[s] ; 
				}
			}
			return  num.toString();
			
			
		}
		
		
		/**
		 *	@param theValue khb001的值 
		 *	@param _array	Yskhb的集合  下拉框数据源
		 * 	@param _label	id所对应的字段名"khb001"
		 *  @param index 未找到则返回的下标值 默认0
		 * 	根据id从集合里获取该对象的下标
		 * 	用于下拉框默认选择某一对象
		 *  @param example
		 * 		id=khb001
		 * 		_array=khbList
		 * 		_label="khb001"
		 * 	
		 */
		public static function getIndex(theValue:*,_array:ArrayCollection,_label:String,_index:int=-1):int
		{
			/**
			 * 等价于（id != 0 || theValue != null） && _array != null && _array.length>0
			 */
			if(theValue && _array && _array.length>0)
			{
				//返回第一个满足条件的index
				_array.source.some
					(
						function(item:*, index:int, array:Array):Boolean
						{
							if(item && item[_label]==theValue)
							{
								_index=index;
								return true;
							}
							return false;
						}
					);
			}
			return _index;
		}
		/**
		 * @param theValue 唯一标识 如id,code
		 * @param theArray 对象的集合
		 * @param theLabel 对象的属性
		 * @param theItem 如果未找到要返回的值
		 * */
		public static function getItem(theValue:*,theArray:ArrayCollection,theLabel:String,theItem:Object=null):Object
		{
			if(theValue && theArray && theArray.length>0)
			{
				theArray.source.some
					(
						function index(item:*, index:int, array:Array):Boolean
						{
							if(item && item[theLabel]==theValue)
							{
								theItem = item;
								return true;
							}
							return false;
						}
					);
			}
			return theItem;
		}
	
	}
}