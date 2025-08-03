package entity
{
	import flash.data.SQLStatement;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class Material
	{
		public function Material()
		{
		}
		public var id:int;
		public var typeId:int;//物料类别id
		public var typeName:String;
		public var code:String="";//物料编码
		public var name:String="";//物料名称
		public var spec:String="";//物料规格
		public var isUsing:Boolean;//是否启用
		public var brand:String="";//品牌
		public var unit:String="";//单位
		public var price:Number=0;//单价
		public var loss:Number=0;//损耗 铝合金损耗
		
		public static var statement:SQLStatement=FlexGlobals.topLevelApplication.statement;
		
		public static function findOne(id:int):ArrayCollection{
			statement.text = "SELECT * from Material where id="+id;
			statement.itemClass=Material;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function findByParam(obj:Object):ArrayCollection{
			var sql:String ="SELECT * from Material where 1=1";
			if(obj.typeIds!=null){
				sql+=" and typeId in ( "+obj.typeIds+")";
			}
			if(obj.context!=null&&obj.context!=""){
				sql+=" and name like '%"+obj.context+"%'";
			}
			if(!obj.showNoUsing){
				sql+=" and isUsing="+true;
			}
			sql+=" order by brand,name,unit";
			statement.text = sql;
			statement.itemClass=Material;
			statement.execute();
			return new ArrayCollection(statement.getResult().data);
		}
		public static function update(mtl:Material):void{
			statement.text="update Material set typeId="+mtl.typeId+",typeName='"+mtl.typeName+"',code='"+mtl.code+"',name='"+mtl.name+"'," +
				"spec='"+mtl.spec+"',isUsing="+mtl.isUsing+",brand='"+mtl.brand+"',unit='"+mtl.unit+"',price="+mtl.price+",loss="+mtl.loss+" where id="+mtl.id;
			statement.execute();
		}
		public static function insert(mtl:Material):int{
			statement.text="insert into Material(typeId,typeName,code,name,spec,isUsing,brand,unit,price,loss) values" +
				"("+mtl.typeId+",'"+mtl.typeName+"','"+mtl.code+"','"+mtl.name+"','"+mtl.spec+"',"+mtl.isUsing+",'"+mtl.brand+"','"+mtl.unit+"',"+mtl.price+","+mtl.loss+")";
			statement.execute();
			return statement.getResult().lastInsertRowID;
		}
		public static function changeMtlUsing(typeIds:ArrayCollection,using:Boolean):void{
			statement.text="update Material set isUsing="+using+" where typeId in ("+typeIds+")";
			statement.execute();
		}
		/**类别改名后物料集体变*/
		public static function changeMtlType(type:MaterialType):void{
			statement.text="update Material set typeName='"+type.name+"' where typeId="+type.id;
			statement.execute();
		}
		public static function deleteByTypes(typeIds:ArrayCollection):void{
			statement.text="delete from Material where typeId in ("+typeIds+")";
			statement.execute();
		}
		public static function isRepeat(mtl:Material):Boolean{
			statement.text = "SELECT * from Material where name='"+mtl.name+"' and unit='"+mtl.unit+"' and brand='"+mtl.brand+"' and id<>"+mtl.id+" limit 1 ";
			statement.itemClass=Material;
			statement.execute();
			return statement.getResult().data!=null;
		}
	}
}