package skins.my
{
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.net.dns.AAAARecord;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import spark.components.ComboBox;
	import spark.events.TextOperationEvent;
	
	public class ComboBoxFilter extends ComboBox
	{
		public function ComboBoxFilter()
		{
			super();
			this.addEventListener(KeyboardEvent.KEY_UP,key_up);
			this.addEventListener(FocusEvent.FOCUS_OUT,focus_out,false,1);
		}
		
		private var _dataSource:ArrayCollection;
		
		[Bindable]
		public function get dataSource():ArrayCollection{
			return _dataSource;
		}
		public function set dataSource(value:ArrayCollection):void{
			
			this._dataSource=value;
			if(_dataSource!=null&&_dataSource.length>0&&(this.dataProvider==null||this.dataProvider.length==0||changeClearDP)){
				this.dataProvider = new ArrayCollection(_dataSource.toArray());
			}
		}
		
		private var _changeClearDP:Boolean = false;
		public function set changeClearDP(value:Boolean):void{
			this._changeClearDP = value;
		}
		public function get changeClearDP():Boolean{
			return this._changeClearDP;
		}
		
		private var _filterLabelFields:Array = new Array();
		
		/**
		 * 	filterLabelFields = "{['field1','field2']}"
		 * */
		public function set filterLabelFields(value:Array):void{
			this._filterLabelFields = value;
		}
		public function get filterLabelFields():Array{
			if(this._filterLabelFields == null){
				_filterLabelFields = new Array();
			}
			return _filterLabelFields;
		}
		
		private var filterArray:Array;
		
		
		override protected function textInput_changeHandler(event:TextOperationEvent):void{
			//trace("ComboBoxFilter textInput_changeHandler");
			/*if(_dataSource!=null&&_dataSource.length>0){
				var str:String = this.textInput.text;
				var array:ArrayCollection = new ArrayCollection(dataSource.toArray());
				array.filterFunction = dataSourceFilterFunction;
				array.refresh();
				this.dataProvider = new ArrayCollection(array.toArray());
				
				if(this.dataProvider!=null&&this.dataProvider.length>0){
					super.textInput_changeHandler(event);
				}
				this.selectedItem = null;
				this.textInput.text = str;
			}*/
		}
		
		private function focus_out(e:FocusEvent):void{
			if(StringUtil.trim(this.textInput.text).length==0){
				this.selectedItem = null;
			}
		}
		
		private function key_up(e:KeyboardEvent):void{
			if(e.keyCode == 40 || e.keyCode == 38 || e.keyCode == 9 ){
				return ;
			}
			if(_dataSource!=null&&_dataSource.length>0){
				var str:String = "";
				if((str=StringUtil.trim(this.textInput.text)).length>0){
					filterArray = str.split(" ");
				}else{
					filterArray = new Array();
				}
				var array:ArrayCollection = new ArrayCollection(dataSource.toArray());
				array.filterFunction = dataSourceFilterFunction;
				array.refresh();
				this.dataProvider = new ArrayCollection(array.toArray());
				openDropDown();
			}
		}
		
		private function dataSourceFilterFunction(obj:Object):Boolean{
			var result:Boolean = false;
			var str:String="";
			var j:int = -1;
			if(StringUtil.trim(this.textInput.text).length==0){
				result= true;
			}else if(filterLabelFields.length<=0){
				if(labelField!=null){
					str=(obj[labelField]!=null?obj[labelField].toString():"");
				}else{
					str=obj.toString();
				}
				if(str.indexOf(StringUtil.trim(this.textInput.text))>-1){
					result = true;
				}
			}else {
				j = filterArray.length;
				for each(var s:String in filterArray){ 
					if(s==null||(s=StringUtil.trim(s)).length<=0){
						j--;
						continue;
					}
					for(var i:int=0;i<filterLabelFields.length;i++){
						if(!obj.hasOwnProperty(filterLabelFields[i])){
							continue;
						}
						str = obj[filterLabelFields[i]] as String;
						if(str == null){
							continue;
						}
						if(str.indexOf(StringUtil.trim(s))>-1){
							j--;
							break;
						}
					}
				}
				result=(j==0?true:false);
				
				
				/*for(var i:int=0;i<filterLabelFields.length;i++){
					if(!obj.hasOwnProperty(filterLabelFields[i])){
						continue;
					}
					str = obj[filterLabelFields[i]] as String;
					if(str.indexOf(StringUtil.trim(this.textInput.text))>-1){
						result = true;
						break;
					}
				}*/
			}
			
			
			return result;
		}
		
	}
}