package common
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.utils.StringUtil;
	import mx.validators.NumberValidator;

	public class ExcelHelper
	{
		public function ExcelHelper(_columns:Array,_labelField:String,_keyField:String,_visible:String=null)
		{
			this.columns=_columns;
			this.labelField=_labelField;
			this.keyField=_keyField;
			this.visible=_visible;
		}
		
		private var columns:Array;
		
		private var labelField:String;
		
		private var footer:Array;
		
		private var keyField:String;
		private var headtxt:String;
		private var visible:String;
		
		public function setHead(_header:String):void{
		  this.headtxt = _header;
		}
		
		
		
		/**
		 * 获取空个数Excel
		 * */
		public function toExcelFormate():ByteArray{
			var excelFile:ExcelFile = new ExcelFile();
			var sheet:Sheet = new Sheet();
			sheet.resize(4,columns.length);
			for(var i:int=0;i<columns.length;i++){
				sheet.setCell(0,i,getLabel(columns[i]));
			}
			if(footer!=null){
				for(var k:int=0;k<footer.length;k++){
					sheet.resize(3+k,columns.length);
					sheet.setCell(3+k,0,footer[k]);
				}
			}
			excelFile.sheets.addItem(sheet);
			
			return excelFile.saveToByteArray();
		}
		
		public function setFooter(footerCon:Array):void{
		     this.footer = footerCon;
		}
		
		
		/**
		 * 获取 Excel
		 * */
		public function toExcelFile(array:ArrayCollection):ByteArray{
			var excelFile:ExcelFile = new ExcelFile();
			var sheet:Sheet = new Sheet();
			var i:int=0;
			var j:int=0;
			var o:Object;
			var k:String;
			if(this.headtxt!=null){
				sheet.resize(2,columns.length);
				sheet.setCell(0,0,this.headtxt);
			}
			if(array!=null&&array.length>0){
				sheet.resize(array.length+1,columns.length);
				var col:int=0
				var col_j:int=0;
				var col_d:int=0;
				for(i=0;i<columns.length;i++){
					if(getVisible(columns[i]))
					{
						sheet.setCell(1,col,getLabel(columns[i]));//Excel头部
						col+=1;
					}
				}
				var flag:Boolean=false;
				for(i=0;i<array.length;i++){
					o=array.getItemAt(i);
					if(o==null){
						continue;
					}
					for(j=0;j<columns.length;j++){
						if(getVisible(columns[j]))
						{
							if(columns[j].hasOwnProperty('labelFunction')
								&&columns[j].labelFunction!=null){
								sheet.setCell(i+2,col_j,columns[j].labelFunction(o,columns[j]));
							}else if(hasKey(columns[j])){
								k = getKey(columns[j]);
								if(o.hasOwnProperty(k)&&o[k]!=null){
									sheet.setCell(i+2,col_j,o[k]);
								}else{
									sheet.setCell(i+2,col_j,"");
								}
							}	
							col_j+=1;
						}
						
					}
					col_j=0;
				}
			}
			if(footer!=null){
				for(j=0;j<footer.length;j++){
					sheet.resize(i+j+3,columns.length);
					sheet.setCell(i+j+3,0,footer[j]);
				}
			}
			excelFile.sheets.addItem(sheet);
			return excelFile.saveToByteArray();
		}
		
		
		
		/**
		 * Excel 中 获取对象
		 * */
		public function getExcelDataArray(xls:ByteArray,className:String=""):ArrayCollection{
			var excelFile:ExcelFile = new ExcelFile();
			excelFile.loadFromByteArray(xls);
			var sheet:Sheet;
			var o:Object;
			var result:ArrayCollection=new ArrayCollection();
			var j:int=-1;
			if(excelFile.sheets!=null&&excelFile.sheets.length>0){
				sheet=excelFile.sheets.getItemAt(0) as Sheet;
				sheet.resize(sheet.rows,sheet.cols);
				if(sheet!=null){
					var rowcount:int = sheet.rows;
					for(var i:int=1;i<=rowcount;i++){
						o=createObject(className);
						if(sheet.getCell(i,1).value!=null&&sheet.getCell(i,1).value!=""&&String(sheet.getCell(i,2).value).indexOf("备注：")<0){
							for(j=0;j<columns.length;j++){
								o[getKey(columns[j])]=sheet.getCell(i,j).value;
//								trace(getKey(columns[j])+"~~"+sheet.getCell(i,j).value);
							}
							result.addItem(o);
						}else{
						   break;
						}
					
					}
				}
			}
			return result;
		}
		/**
		 * 格式验证
		 * */
		private function formatValidator(sheet:Sheet):Boolean{
			var result:Boolean=true;
			var s1:String;
			if(sheet!=null&&columns!=null&&columns.length>0){
				for(var i:int=0;i<columns.length;i++){
					if((s1=sheet.getCell(0,i).value)==null||StringUtil.trim(s1)!=getLabel(columns[i])){
						result=false;
						break;
					}
				}
			}
			return result;
		}
		private function getLabel(obj:Object):String{
			if(labelField==null){
				return obj as String;
			}else{
				return obj[labelField] as String;
			}
		}
		private function getKey(obj:Object):String{
			if(keyField==null){
				return obj as String;
			}else{
				return obj[keyField] as String;
			}
		}
		
		private function getVisible(obj:Object):Boolean{
			if(obj==null)
				return false;
			else
			{
				if(visible==null)
					return true;
				else
					return obj[visible] as Boolean;
			}
		}
		
		private function hasKey(obj:Object):Boolean{
			if(keyField!=null&&obj.hasOwnProperty(keyField)){
				return true;
			}else{
				return false;
			}
		}
		
		private function createObject(className:String):Object{
			var result:Object;
			var c:Class;
			if(className==null||className==""){
				result=new Object();
			}else{
				c=getDefinitionByName(className) as Class;
				if(c!=null){
					result=new c();
				}else{
					result=new Object();
				}
			}
			return result;
		}
		
		
	}
}