package util
{
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	
	import skins.my.TreeCombox;

	public class TreeUtil
	{
		public function TreeUtil()
		{
		}
		public static function expandTree(_tree:Tree):void{
			_tree.validateNow();
			for each(var item:Object in _tree.dataProvider)  
			_tree.expandChildrenOf(item,true);  
		}
		/*public static function treeSelected(list:ArrayCollection,find:String,_tree:TreeCombox=null):void  
		{  
			for(var i:int=0;i<list.length;i++)  
			{  
				var child:Object=list.getItemAt(i);
				var guid:String = child.id;
				if(guid != null && guid == find)  
				{  
					_tree.selectedItem = child;    //tree上选中节点  
					return;  
				}else if(_tree.dataDescriptor.isBranch(child))//如果有子节点,则递归调用本方法  
				{  
					treeSelected(child.children as ArrayCollection,find,_tree);  
				}  
				
			}  
		}   */
		/*public static function treeLocateNe(xmlList:XMLList,find:String):void  
		{  
			for(var i:int=0;i<xmlList.length();i++)  
			{  
				var childXml:XML =xmlList[i];  
				var guid:String = childXml.@labels ;  
				if(guid != null && guid == find)  
				{  
					//展开所有节点  
					for each(var item:XML in sourcesTree.dataProvider)  
					sourcesTree.expandChildrenOf(item,true);  
					
					sourcesTree.selectedItem = childXml;    //tree上选中节点  
					return;  
				}else if(sourcesTree.dataDescriptor.isBranch(childXml))//如果有子节点,则递归调用本方法  
				{  
					treeLocateNe(childXml.children(),find);  
				}  
				
			}  
		}   */
	}
}