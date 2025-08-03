import common.DataFormat;
import common.DateFormatHelper;

import entity.OrderDetails;

import flash.data.SQLResult;

import mx.controls.Alert;

private function insert_z():void{
	statement.text = "INSERT into Orders(khName,khPhone,khAddress, xdTime, stateOut,stateIn,bz,zhaiyao)"+
		"values('"+item_z.khName+"','"+item_z.khPhone+"','"+item_z.khAddress+"','"+DateFormatHelper.Format10(new Date())+"','N','N','"+item_z.bz+"','"+zhaiyao()+"' )";
	statement.execute();
	var result:SQLResult=statement.getResult();
	var id:int=result.lastInsertRowID;
	insertOrUpdate_m(id);
}
/*更新主表*/
private function update_z():void{
	statement.text = "update Orders set khName='"+item_z.khName+"',khPhone='"+item_z.khPhone+"',khAddress='"+item_z.khAddress+"'" +
		",stateOut='"+item_z.stateOut+"',stateIn='"+item_z.stateIn+"',bz='"+item_z.bz+"',zhaiyao='"+zhaiyao()+"' where id="+item_z.id+"";
	statement.execute();
	insertOrUpdate_m(item_z.id);
	delDataForTheArray(item_z.delList);
	item_z.delList=null;
}
/*插入子表*/
private function insert_m(item:OrderDetails):int
{
	statement.text = "INSERT into OrderDetails(orderId,xh,bz,color,ylType,width,height,jiShan, boLi , gudingTop ,gudingDown ,gdTopHeight ,gdDownHeight ,shouKou,zhuanJiao,zzNumTop,zzNumDown,num,picName,cxType,isGDH) "+
		"values("+item.orderId+","+item.xh+",'"+item.bz+"','"+item.color+"',"+item.ylType+","+item.width+","+item.height+","+item.jiShan+","+item.boLi+","+item.gudingTop+","+item.gudingDown+","+item.gdTopHeight+","+item.gdDownHeight+","+item.shouKou+","+item.zhuanJiao+","+item.zzNumTop+","+item.zzNumDown+","+item.num+",'"+item.picName+"',"+item.cxType+","+item.isGDH+")";
	statement.execute();
	var result:SQLResult=statement.getResult();
	var item_id:int=result.lastInsertRowID;
	return item_id;
}
/*更新子表*/
private function update_m(_item_m:OrderDetails):void
{
	statement.text = "update OrderDetails set bz='"+_item_m.bz+"',xh="+_item_m.xh+",color='"+_item_m.color+"'" +
		",ylType="+_item_m.ylType+",width="+_item_m.width+",height="+_item_m.height+",jiShan="+_item_m.jiShan+", boLi="+_item_m.boLi+" , gudingTop="+_item_m.gudingTop+" ,gudingDown="+_item_m.gudingDown+" ,gdTopHeight="+_item_m.gdTopHeight+" ,gdDownHeight="+_item_m.gdDownHeight+" ,shouKou="+_item_m.shouKou+
		" ,zhuanJiao="+_item_m.zhuanJiao+" ,zzNumTop="+_item_m.zzNumTop+",zzNumDown="+_item_m.zzNumDown+" ,num="+_item_m.num+" ,picName='"+_item_m.picName+"',cxType="+_item_m.cxType+",isGDH="+_item_m.isGDH+
		" where id="+_item_m.id+" ";
	statement.execute();
}

/*删除子表*/
private function delete_m(id:int):void{
	statement.text = "delete from OrderDetails where id="+id+"";
	statement.execute();
}
