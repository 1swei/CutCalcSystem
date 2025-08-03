/**
 * 所有的计算公式:
 * 
 * 点开图纸预览调用此方法calc
 * 
 * 根据订单明细里填写的基本信息(长/宽/固定等信息)
 * 
 * 计算具体的用料尺寸,并给本身OrderDetails里的各个参数赋值(此值不存入数据库,每次打开图纸重新计算)
 * 
 * */
import common.DataFormat;
import common.DateFormatHelper;
import common.StringHelper;
import common.WorkGlass;
import common.WorkMaterial;

import entity.AluPro;
import entity.CustomFormula;
import entity.GlassSizeSet;
import entity.OrderDetailBL;
import entity.OrderDetails;

import flash.system.System;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;

import r1.deval.D;

/**自定义公式*/
private function calcCust(item_m:OrderDetails):void{
	//获取该型材,窗型下的公式集合
	var cstList:ArrayCollection = CustomFormula.getCustomFormulasByParam(item_m.aluPro.id,item_m.picName);
	if(cstList==null||cstList.length==0){
		Alert.show("公式获取失败","提示");
		return;
	}
	if(item_m.blList==null||item_m.blList.length==0){
		Alert.show("参数获取失败","提示");
		return;
	}
	//循环订单上保存的变量,把这些变量的值替换 公式里的变量
	
	var cstItem:CustomFormula;
	var ordermBl:OrderDetailBL;
	var calcResult:Number;
	var calcResultOth:Number;
	var calcResultOth2:Number;
	var matName:String="";//料名
	var matValue:String="";//规格数量单位等
	var wkList:ArrayCollection = new ArrayCollection();
	var nsList:ArrayCollection = new ArrayCollection();
	var glassList:ArrayCollection = new ArrayCollection();
	for(var i:int=0;i<cstList.length;i++){
		cstItem=cstList.getItemAt(i) as CustomFormula;
		for(var j:int=0;j<item_m.blList.length;j++){
			ordermBl=item_m.blList.getItemAt(j) as OrderDetailBL;
			//宽高先默认A和B,用来计算默认面积
			if(ordermBl.blName=="A"){
				item_m.height=ordermBl.blValue;
			}
			if(ordermBl.blName=="B"){
				item_m.width=ordermBl.blValue;
			}
			//把公式里的H,W等都替换成订单保存的内容
			cstItem.formula = StringHelper.replaceAll(cstItem.formula,ordermBl.blName,ordermBl.blValue+"");
		}
		//计算
		//玻璃在下面分解后计算
		if(cstItem.type!=2){
			//trace("计算："+cstItem.formula);
			calcResult=DataFormat.formatNumber2((D.eval(cstItem.formula)));
			//trace("值："+calcResult);
			//料名，不足8位自动补齐（为了对齐）
			//matName=StringHelper.addSomeThing(cstItem.materialName+"：",8," ",1);
			//料规，数量等
			//matValue=calcResult+"cm×"+cstItem.tag+cstItem.amount*item_m.num+"\n";
			
			if(cstItem.type==0){
				wkList.addItem(WorkMaterial.toWorkMaterial_wk(cstItem.materialName,calcResult,cstItem.amount*item_m.num,(cstItem.tag!=null&&cstItem.tag.length>0)));
				//item_m.wkMsg+=matName+matValue;
			}else if(cstItem.type==1){
				nsList.addItem(WorkMaterial.toWorkMaterial_ns(cstItem.materialName,calcResult,cstItem.amount*item_m.num,(cstItem.tag!=null&&cstItem.tag.length>0)));
				//item_m.nsMsg+=matName+matValue;
			}else if(cstItem.type==3){
				item_m.area = calcResult;
			}
		}else{
			if(cstItem.formula.indexOf("#")>-1){
				var blArray:Array = cstItem.formula.split("#");
				calcResult=DataFormat.formatNumber2(D.eval(blArray[0]));
				calcResultOth=DataFormat.formatNumber2(D.eval(blArray[1]));
				if(blArray.length==3){//说明是斜边玻璃
					calcResultOth2=DataFormat.formatNumber2(D.eval(blArray[2]));
					glassList.addItem(WorkGlass.toWorkGlass(calcResult,calcResultOth,cstItem.amount*item_m.num,calcResultOth2));
				}else{
					glassList.addItem(WorkGlass.toWorkGlass(calcResult,calcResultOth,cstItem.amount*item_m.num));
				}
			}
		}
	}
	item_m.wkList = wkList;
	item_m.nsList = nsList;
	item_m.glassList = glassList;
}

private function calc(item_m:OrderDetails):void{
	if(item_m.cxType==0&&(item_m.height==0||item_m.width==0||item_m.aluPro==null||item_m.glass==null)){
		Alert.show("配置信息获取异常");
		return;
	}
	trace("开始计算:"+new Date().seconds+'-'+new Date().milliseconds);
	if(item_m.aluPro.type==0){//普通计算
		calcNormal(item_m);
	}else if(item_m.aluPro.type==1){//平开计算
		calcPingKai(item_m);
	}else{
		calcPingKaiMen(item_m);
	}
	
	item_m.wkList = getPrintMsg_wk_v2(item_m);
	item_m.nsList = getPrintMsg_ns_v2(item_m);
	item_m.glassList = getPrintMsg_bl_v2(item_m);
	
	//trace("结束计算:"+new Date().seconds+"-"+new Date().milliseconds);
}

/**普通料算法*/
private function calcNormal(item_m:OrderDetails):void{
	/**外框料,这里都是不组角的外框,组角的外框是不用计算的.直接根据实际尺寸*/
	//边封
	item_m.bianFeng = item_m.height;
	//中挺
	if(item_m.gudingTop==1&&item_m.gdTopHeight>0){//固上
		item_m.zhongTingTop=DataFormat.formatNumber(item_m.gdTopHeight-item_m.aluPro.zhongTingXS);
	}else{
		item_m.zhongTingTop=0;
	}
	if(item_m.gudingDown==1&&item_m.gdDownHeight>0){//固下
		item_m.zhongTingDown = DataFormat.formatNumber(item_m.gdDownHeight-item_m.aluPro.zhongTingXS);
	}else{
		item_m.zhongTingDown=0;
	}
	//上下滑
	if(item_m.jiShan==5){//纯固定
		item_m.shangXiaHua=DataFormat.formatNumber(item_m.width-item_m.aluPro.hengLiaoXS);//横料
		//纯固定。（组角，中挺和外框横料不一样长）（不组角，中挺和外框横料一样长）
		if(item_m.aluPro.isZJ==1){
			item_m.zhongTingH = DataFormat.formatNumber(item_m.width-item_m.aluPro.zhongTingXS);//横 中挺
		}else{
			item_m.zhongTingH = item_m.shangXiaHua;//横 中挺
		}
		
	}else{
		item_m.shangXiaHua=DataFormat.formatNumber(item_m.width-item_m.aluPro.shangXiaHuaXS);//上下滑
	}
	
	/**内扇料*/
	//如果外框组角,不管上/下带不带气窗,内扇高度只有一种算法.
	if(item_m.aluPro.isZJ==1){
		item_m.ggqMax = DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.ggqMaxXS);
	}else{
		//光勾企 高度
		if(item_m.gudingTop==1&&item_m.gudingDown==1){//固上+固下
			item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.ggqMaxQGXS);
			item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.ggqMinQGXS);
			
		}else if(item_m.gudingTop==1&&item_m.gudingDown==0){//固上
			
			if(item_m.isGDH==0){
				item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.aluPro.ggqMaxGSXS);
				item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.aluPro.ggqMinGSXS);
			}else{
				item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.aluPro.ggqMaxGSPXGD);
				item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.aluPro.ggqMinGSPXGD);
			}
			
			
		}else if(item_m.gudingTop==0&&item_m.gudingDown==1){//固下
			item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdDownHeight-item_m.aluPro.ggqMaxGXXS);
			item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.gdDownHeight-item_m.aluPro.ggqMinGXXS);
			
		}else{//平上平下
			
			if(item_m.isGDH==0){
				item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.aluPro.ggqMaxXS);
				item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.aluPro.ggqMinXS);
			}else{
				item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.aluPro.ggqMaxPSPXGD);
				item_m.ggqMin=DataFormat.formatNumber(item_m.height-item_m.aluPro.ggqMinPSPXGD);
			}
			
		}
	}
	
	//上下方 宽度
	if(item_m.jiShan==2){
		item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaFang2XS)/2);
	}else if(item_m.jiShan==3){
		if(item_m.shouKou==1){//带收口
			item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaFang3XS_SK)/3);
		}else{//不带收口
			item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaFang3XS)/3);
		}
	}else if(item_m.jiShan==4){
		item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaFang4XS)/4);
	}else if(item_m.jiShan==6){
		item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaFang6XS)/6);
	}else{
		item_m.shangXiaFang=0;
	}
	//收口
	item_m.shouKouNumber = item_m.ggqMax;
	
	//固定压条
	if(item_m.aluPro.yaTiaoH){
		if(item_m.yx_gdArray==null){
			item_m.yx_gdArray = new ArrayCollection();
		}
		var ytObj:Object = new Object();
		
		//有气窗上
		if(item_m.gudingTop==1){
			/* 中挺数跟压条高的数量关系
			0 2  
			1 4  
			2 6  
			3 8  
			4 10  
			*/
			if(item_m.jiShan==5){
				//纯固定的压条高度
				
				//高= 上固定高度 - 固定外框 - 压条宽*2 
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber(item_m.gdTopHeight-item_m.glass.glass_gd-item_m.aluPro.yaTiao*2);
				ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
				
				//宽=(总宽-中挺宽*根数-2根固定)/(中挺数+1)
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumTop-item_m.glass.glass_gd*2)/(item_m.zzNumTop+1));
				ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
			}else{
				
				//带窗户的固定压条高度
				//高=外包-系数(9.4,如果带窗,就用带窗系数)
				//yaTiaoH_C 这个其实是各种材料总和。因为带窗户都是这么做的。而纯固定 上固，下固动态的。所以用各种材料分开减
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber(item_m.gdTopHeight-item_m.aluPro.yaTiaoH_C);
				ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
				//宽=(总宽-中挺宽*根数-2根边封)/(中挺数+1)
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumTop-item_m.glass.glass_bf*2)/(item_m.zzNumTop+1));
				ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
			}
			
			
			
		}
		//有气窗下
		if(item_m.gudingDown==1){
			
			if(item_m.jiShan==5){
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber(item_m.gdDownHeight-item_m.glass.glass_gd-item_m.aluPro.yaTiao*2);
				ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumDown-item_m.glass.glass_gd*2)/(item_m.zzNumDown+1));
				ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
			}else{
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber(item_m.gdDownHeight-item_m.aluPro.yaTiaoH_C);
				ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
				
				ytObj=new Object();
				ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumDown-item_m.glass.glass_bf*2)/(item_m.zzNumDown+1));
				ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
				item_m.yx_gdArray.addItem(ytObj);
			}
			
			
			
		}
		
		var gds:int=0;//要扣减的固定外框数
		var zts:int=0;//要扣减的中挺数
		//纯固定 ，计算中间的压线
		if(item_m.jiShan==5){
			if(item_m.gudingTop==1){
				zts++;
			}
			if(item_m.gudingDown==1){
				zts++;
			}
			//固上 或固下
			if((item_m.gudingTop==1&&item_m.gudingDown==0)||(item_m.gudingTop==0&&item_m.gudingDown==1)){
				gds=1;
			}else if(item_m.gudingTop==0&&item_m.gudingDown==0){//都不固
				gds=2;
			}
			
			//中间的固定压条
			//高度 = 中间的高度 - 中挺数*中挺厚度 - 固定数*固定外框厚度 - 压条厚度*2
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.glass.glass_zt*zts-item_m.glass.glass_gd*gds-item_m.aluPro.yaTiao*2);
			ytObj.num=item_m.num*2;
			item_m.yx_gdArray.addItem(ytObj);
			
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber(item_m.width-item_m.glass.glass_gd*2);
			ytObj.num=item_m.num*2;
			item_m.yx_gdArray.addItem(ytObj);
			
		}
		if(item_m.yx_gdArray!=null&&item_m.yx_gdArray.length>0){
			item_m.yx_gdArray = groupByNew(item_m.yx_gdArray);//去重
			var obj:Object;
			for(var i:int=0;i<item_m.yx_gdArray.length;i++){
				obj = item_m.yx_gdArray.getItemAt(i);
				item_m.yx_gdStr+="压条：    "+obj.chang+"cm×"+obj.num+"\n";
			}
			
		}
	}

	
	
}
/**平开料算法*/
private function calcPingKai(item_m:OrderDetails):void{
	item_m.bianFeng = item_m.height;
	//外框
	if(item_m.aluPro.isZJ==1){
		item_m.shangXiaHua=DataFormat.formatNumber(item_m.width);//外框，这个不用算因为组角的
	}else{//普通
		item_m.shangXiaHua=DataFormat.formatNumber(item_m.width-item_m.aluPro.shangXiaHuaXS);//外框
	}
	
	//内扇高度 不管组角否,统一算法
	//高-上固-下固 - 外框厚度*2 + 1.4(内空)
	item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.shangXiaHuaXS*2+item_m.aluPro.neikongXS);

	/*if(item_m.aluPro.isZJ==1){//55坚美平开窗/组角
		var ztNum:Number=0;//中挺数
		if(item_m.gudingTop==1&&item_m.gudingDown==1){
			ztNum = 2;
		}else if(item_m.gudingTop==1||item_m.gudingDown==1){
			ztNum = 1;
		}
		//高-上固-下固 - 55外框厚度*2 + 1.4(内空)
		item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.shangXiaHuaXS*2+item_m.aluPro.neikongXS);
	}else{//50平开
		item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.ggqMaxGSXS);
	}*/
	//内扇宽度
	if(item_m.jiShan==2){
		//(宽 - 外框厚度*2 - 中挺厚度 ) ÷ 2  + 1.4(内空系数)
		item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.aluPro.shangXiaHuaXS*2-item_m.glass.glass_zt)/2+item_m.aluPro.neikongXS);
	}else{
		//宽 - 外框厚度*2 + 1.4(内空)
		item_m.shangXiaFang=DataFormat.formatNumber(item_m.width-item_m.aluPro.shangXiaHuaXS*2+item_m.aluPro.neikongXS);
	}
	//中挺算法(固定中挺和推拉有点不一样)
	if(item_m.aluPro.isZJ==1){//组角55平开断桥
		if(item_m.gudingTop==1){
			item_m.zhongTingH=DataFormat.formatNumber(item_m.width-item_m.aluPro.zhongTingXS);
			//固定高度-固中挺系数
			item_m.zhongTingTop=DataFormat.formatNumber(item_m.gdTopHeight-item_m.aluPro.zhongTingXS_G);
		}
		if(item_m.gudingDown==1){
			item_m.zhongTingH=DataFormat.formatNumber(item_m.width-item_m.aluPro.zhongTingXS);
			item_m.zhongTingDown=DataFormat.formatNumber(item_m.gdDownHeight-item_m.aluPro.zhongTingXS_G);
		}
		//2扇中间竖的中挺
		if(item_m.jiShan==2){
			item_m.zhongTingPK = DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.zhongTingXS);
		}
	}else{
		if(item_m.gudingTop==1){
			item_m.zhongTingH=item_m.shangXiaHua;//横的中挺和外框一样长
			item_m.zhongTingTop=DataFormat.formatNumber(item_m.gdTopHeight-item_m.aluPro.zhongTingXS_G);
		}
		if(item_m.gudingDown==1){
			item_m.zhongTingH=item_m.shangXiaHua;
			item_m.zhongTingDown=DataFormat.formatNumber(item_m.gdDownHeight-item_m.aluPro.zhongTingXS_G);
		}
		//2扇中间竖的中挺
		if(item_m.jiShan==2){
			item_m.zhongTingPK = DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.zhongTingXS);
		}
	}
	
	//平开窗固定压线
	if(item_m.aluPro.yaTiaoH>0){
		if(item_m.yx_gdArray==null){
			item_m.yx_gdArray = new ArrayCollection();
		}
		var ytObj:Object = new Object();
		//有气窗上
		if(item_m.gudingTop==1){
			//高=外包-系数(10)
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber(item_m.gdTopHeight-item_m.aluPro.yaTiaoH);
			ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
			item_m.yx_gdArray.addItem(ytObj);
			//宽=(总宽-中挺宽*根数-外包系数)/(中挺数+1)
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumTop-item_m.aluPro.yaTiaoW)/(item_m.zzNumTop+1));
			ytObj.num=(item_m.zzNumTop*2+2)*item_m.num;
			item_m.yx_gdArray.addItem(ytObj);
			
		}
		//有气窗下
		if(item_m.gudingDown==1){
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber(item_m.gdDownHeight-item_m.aluPro.yaTiaoH);
			ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
			item_m.yx_gdArray.addItem(ytObj);
			
			ytObj=new Object();
			ytObj.chang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_zt*item_m.zzNumDown-item_m.aluPro.yaTiaoW)/(item_m.zzNumDown+1));
			ytObj.num=(item_m.zzNumDown*2+2)*item_m.num;
			item_m.yx_gdArray.addItem(ytObj);
		}
		
	}
	//平开窗内扇压条
	if(item_m.aluPro.yaTiaoH_N>0){
		if(item_m.yx_nsArray==null){
			item_m.yx_nsArray = new ArrayCollection();
		}			
		var ytObj:Object;
		//高
		ytObj=new Object();
		ytObj.chang=DataFormat.formatNumber(item_m.ggqMax-item_m.aluPro.yaTiaoH_N);
		ytObj.num=item_m.jiShan==2?4*item_m.num:2*item_m.num;
		item_m.yx_nsArray.addItem(ytObj);
		//宽
		ytObj=new Object();
		ytObj.chang=DataFormat.formatNumber(item_m.shangXiaFang-item_m.aluPro.yaTiaoW_N);
		ytObj.num=item_m.jiShan==2?4*item_m.num:2*item_m.num;
		item_m.yx_nsArray.addItem(ytObj);
		
	}
	//压线合并
	if(item_m.yx_gdArray!=null&&item_m.yx_gdArray.length>0){
		item_m.yx_gdArray = groupByNew(item_m.yx_gdArray);//去重
		var obj:Object;
		for(var i:int=0;i<item_m.yx_gdArray.length;i++){
			obj = item_m.yx_gdArray.getItemAt(i);
			item_m.yx_gdStr+="压条：    "+obj.chang+"cm×"+obj.num+"\n";
		}
	}
	if(item_m.yx_nsArray!=null&&item_m.yx_nsArray.length>0){
		item_m.yx_nsArray = groupByNew(item_m.yx_nsArray);//去重
		var obj:Object;
		for(var i:int=0;i<item_m.yx_nsArray.length;i++){
			obj = item_m.yx_nsArray.getItemAt(i);
			item_m.yx_nsStr+="压条：    "+obj.chang+"cm×"+obj.num+"\n";
		}
	}
}
/**平开门算法*/
private function calcPingKaiMen(item_m:OrderDetails):void{
	item_m.shangXiaHua=item_m.width;
	//内扇
	item_m.ggqMax=DataFormat.formatNumber(item_m.height-item_m.gdTopHeight-item_m.gdDownHeight-item_m.aluPro.ggqMaxGSXS);
	if(item_m.jiShan==2){
		item_m.shangXiaFang=DataFormat.formatNumber((item_m.width-item_m.glass.glass_bf*2)/2+item_m.aluPro.neikongXS);
	}else{
		item_m.shangXiaFang=DataFormat.formatNumber(item_m.width-item_m.glass.glass_bf*2+item_m.aluPro.neikongXS);
	}
}
public function groupByNew(arr:ArrayCollection):ArrayCollection{
	var tempOld:Object;
	var tempNew:Object;
	var arrNew:ArrayCollection=new ArrayCollection();
	for (var i:int = 0; i <arr.length; i++) {
		tempOld=arr.getItemAt(i);
		var find:Boolean=false;
		if(i==0){
			arrNew.addItem(tempOld);
		}else{
			for(var j:int = 0; j <arrNew.length; j++){
				tempNew = arrNew.getItemAt(j);
				if(tempNew.chang==tempOld.chang){
					find=true;
					tempNew.num+=tempOld.num;
					break;
				}
			}
			if(!find){
				arrNew.addItem(tempOld);
			}
		}
	}
	return arrNew; 
}
//去重思路2:if(!array.some(function(item,index,array){if(condition){item.sum+=...}return condition;})){array.push()}

/**获取外框材料明细*/
[Bindable]
public function getPrintMsg_wk_v2(orderm:OrderDetails):ArrayCollection{
	var materialList:ArrayCollection = new ArrayCollection();
	var num:int=1;
	if(orderm.num>0){
		num=orderm.num;
	}
	var tempGdNums:int=0;//带固数
	if(orderm.gudingTop==1){
		tempGdNums++;
	}
	if(orderm.gudingDown==1){
		tempGdNums++;
	}
	
	if(orderm.aluPro.isZJ==1){
		//外框组角
		if(orderm.jiShan==5){//纯固定。这里组角的竖料 也是一根料到底。
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("高度",orderm.bianFeng,2*num));
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("宽度",orderm.shangXiaHua,2*num));
			if(tempGdNums>0){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("中挺",orderm.zhongTingH,tempGdNums*num));
			}
		}else{
			//高度
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("扇外框",DataFormat.formatNumber(orderm.height-orderm.gdTopHeight-orderm.gdDownHeight),2*num));
			//宽度
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("扇外框",orderm.width,2*num));
			if(orderm.gudingTop==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固外框",orderm.gdTopHeight,2*num));
			}
			if(orderm.gudingDown==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固外框",orderm.gdDownHeight,2*num));
			}
			//固定外框
			if(tempGdNums>0){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固外框",orderm.width,tempGdNums*2*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("拼板",orderm.width,tempGdNums*num));
			}
		}
	}else{
		//不组角
		materialList.addItem(WorkMaterial.toWorkMaterial_wk(orderm.jiShan==5?"高度":"边封",orderm.bianFeng,2*num));
		if(orderm.jiShan==5){//固定
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("宽度",orderm.shangXiaHua,2*num));
			
			if(orderm.gudingTop==1&&orderm.gudingDown==1){//固上+固下
				
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("中挺",orderm.shangXiaHua,2*num));
				
			}else if(orderm.gudingTop==1||orderm.gudingDown==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("中挺",orderm.shangXiaHua,num));
			}
		}else{//不是纯固定
			if(orderm.gudingTop==1&&orderm.gudingDown==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固定",orderm.shangXiaHua,2*num));
			}else if(orderm.gudingTop==1||orderm.gudingDown==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固定",orderm.shangXiaHua,num));
			}
			if(orderm.gudingTop==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固上滑",orderm.shangXiaHua,num));
			}else{
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("平上滑",orderm.shangXiaHua,num));
			}
			if(orderm.gudingDown==1){
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("固下滑",orderm.shangXiaHua,num));
			}else{
				materialList.addItem(WorkMaterial.toWorkMaterial_wk("平下滑",orderm.shangXiaHua,num));
			}
		}
	}
	
	
	if(orderm.gudingTop==1&&orderm.gdTopHeight>0){
		if(orderm.zzNumTop>0){//中挺数>0
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("中挺(上)",orderm.zhongTingTop,orderm.zzNumTop*num));
		}
		if(orderm.jiShan!=5&&orderm.aluPro.isZJ==0){
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("盖板(上)",orderm.zhongTingTop,2*num));
		}
	}
	if(orderm.gudingDown==1&&orderm.gdDownHeight>0){
		if(orderm.zzNumDown>0){
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("中挺(下)",orderm.zhongTingDown,orderm.zzNumDown*num));
		}
		if(orderm.jiShan!=5&&orderm.aluPro.isZJ==0){
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("盖板(下)",orderm.zhongTingDown,2*num));
		}
	}
	if(orderm.zhuanJiao>0){
		materialList.addItem(WorkMaterial.toWorkMaterial_wk("转角",orderm.height,1));
	}
	if(orderm.aluPro.yaTiaoH>0&&orderm.yx_gdArray!=null&&orderm.yx_gdArray.length>0){
		for(var i:int =0;i<orderm.yx_gdArray.length;i++){
			var ytObj:Object = orderm.yx_gdArray.getItemAt(i);
			materialList.addItem(WorkMaterial.toWorkMaterial_wk("压条",ytObj.chang as Number,ytObj.num as int));
		}
		//result+=orderm.yx_gdStr;
	}
	return materialList;
}

[Bindable]
public function getPrintMsg_ns_v2(orderm:OrderDetails):ArrayCollection{
	
	var materialList:ArrayCollection = new ArrayCollection();
	
	var num:int=1;
	if(orderm.num>0){
		num=orderm.num;
	}
	if(orderm.jiShan==5){
		return materialList;
	}
	if(orderm.aluPro.isZJ==1){//组角断桥,内扇就是一种料
		
		materialList.addItem(WorkMaterial.toWorkMaterial_ns("扇高",orderm.ggqMax,orderm.jiShan*2*num));
		
		materialList.addItem(WorkMaterial.toWorkMaterial_ns("扇宽",orderm.shangXiaFang,orderm.jiShan*2*num));
	}else{
		if(orderm.jiShan==2){
			
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(长)",orderm.ggqMax,num,true));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(短)",orderm.ggqMin,num,true));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("上方",orderm.shangXiaFang,2*num));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("大小下方",orderm.shangXiaFang,num,true));
			
			
		}else if(orderm.jiShan==3){
			if(orderm.shouKou==0){//3扇不带收口
				
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("勾企(长)",orderm.ggqMax,2*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(短)",orderm.ggqMin,2*num,true));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("上方",orderm.shangXiaFang,3*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("大下方",orderm.shangXiaFang,num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("小下方",orderm.shangXiaFang,2*num));
			}else{//带收口
				
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("光企(长)",orderm.ggqMax,3*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("勾企(长)",orderm.ggqMax,num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(短)",orderm.ggqMin,num,true));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("上方",orderm.shangXiaFang,3*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("大下方",orderm.shangXiaFang,2*num));
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("小下方",orderm.shangXiaFang,num));
				
			}
		}else if(orderm.jiShan==4){
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(长)",orderm.ggqMax,2*num,true));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("光勾企(短)",orderm.ggqMin,2*num,true));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("上方",orderm.shangXiaFang,4*num));
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("大小下方",orderm.shangXiaFang,2*num,true));
		}
		
	}
	
	if(orderm.shouKou==1){
		materialList.addItem(WorkMaterial.toWorkMaterial_ns("收口",orderm.shouKouNumber,num));
	}
	if(orderm.aluPro.yaTiao>0&&orderm.aluPro.type==0){//推拉窗断桥
		if(orderm.jiShan>0&&orderm.jiShan!=5){
			//光勾企 长断一样，封盖尺寸一样
			if(orderm.ggqMin==0 && orderm.ggqMax != orderm.ggqMin){
				materialList.addItem(WorkMaterial.toWorkMaterial_ns("封盖",orderm.ggqMax,orderm.jiShan*num));
			}else{
				if(DataFormat.isEven(orderm.jiShan)){
					materialList.addItem(WorkMaterial.toWorkMaterial_ns("封盖",orderm.ggqMax,orderm.jiShan/2*num));
					materialList.addItem(WorkMaterial.toWorkMaterial_ns("封盖",orderm.ggqMin,orderm.jiShan/2*num));
				}else{
					//奇数扇
					var min:int = (orderm.jiShan - 1)/2;
					var max:int = orderm.jiShan - min;
					materialList.addItem(WorkMaterial.toWorkMaterial_ns("封盖",orderm.ggqMax,min*num));
					materialList.addItem(WorkMaterial.toWorkMaterial_ns("封盖",orderm.ggqMin,max*num));
				}
				
			}
		}
	}
	if(orderm.yx_nsArray!=null&&orderm.yx_nsArray.length>0){
		for(var i:int =0;i<orderm.yx_nsArray.length;i++){
			var ytObj:Object = orderm.yx_nsArray.getItemAt(i);
			materialList.addItem(WorkMaterial.toWorkMaterial_ns("压条",ytObj.chang as Number,ytObj.num as int));
		}
	}
	return materialList;
}
[Bindable]
public function getPrintMsg_bl_v2(orderm:OrderDetails):ArrayCollection{
	var num:int=1;
	if(orderm.num>0){
		num=orderm.num;
	}
	var aluPro:AluPro = orderm.aluPro;
	var glassList:ArrayCollection = new ArrayCollection();
	//通过型材配置id 获取一下 玻璃的计算配置
	var glass:GlassSizeSet =orderm.glass;
	if(glass==null){
		glass = GlassSizeSet.getGlassSizeSetByAluProId(aluPro.id);
	}
	if(glass!=null){
		
		//窗户的玻璃
		if(orderm.jiShan!=0&&orderm.jiShan!=5){
			
			glassList.addItem(WorkGlass.toWorkGlass(orderm.ggqMax-glass.heigth_in,orderm.shangXiaFang-glass.width_in,orderm.jiShan*num));
			//外框组角.上下固定和窗扇外框用拼版拼起来的,没有边封
			if(orderm.aluPro.isZJ==1){
				//有气窗上
				if(orderm.gudingTop==1){
					// 固定高度-固定厚度*2-0.8 × (总宽度 - 中挺厚*中挺数-固定厚度*2/几块玻璃-0.8)
					glassList.addItem(WorkGlass.toWorkGlass(orderm.gdTopHeight-glass.glass_gd*2-glass.heigth_stc_xs,
						(orderm.width-glass.glass_zt*orderm.zzNumTop-glass.glass_gd*2)/(orderm.zzNumTop+1)-glass.width_stc_xs,
						(orderm.zzNumTop+1)*num));
				}
				//有气窗下 同理
				if(orderm.gudingDown==1){
					
					glassList.addItem(WorkGlass.toWorkGlass(orderm.gdDownHeight-glass.glass_gd*2-glass.heigth_stc_xs,
						(orderm.width-glass.glass_zt*orderm.zzNumDown-glass.glass_gd*2)/(orderm.zzNumDown+1)-glass.width_stc_xs,
						(orderm.zzNumDown+1)*num));
					
					
				}
			}else{
				//有气窗上
				if(orderm.gudingTop==1){
					// 固定高度-底下的固定厚度-0.8 × (总宽度 - 中挺厚*中挺数-边封厚度*2/几块玻璃-0.8)
					
					glassList.addItem(WorkGlass.toWorkGlass(orderm.gdTopHeight-glass.glass_gd-glass.heigth_stc_xs,
						(orderm.width-glass.glass_zt*orderm.zzNumTop-glass.glass_bf*2)/(orderm.zzNumTop+1)-glass.width_stc_xs,
						(orderm.zzNumTop+1)*num));
					
					
				}
				//有气窗下 同理
				if(orderm.gudingDown==1){
					
					glassList.addItem(WorkGlass.toWorkGlass(orderm.gdDownHeight-glass.glass_gd-glass.heigth_stc_xs,
						(orderm.width-glass.glass_zt*orderm.zzNumDown-glass.glass_bf*2)/(orderm.zzNumDown+1)-glass.width_stc_xs,
						(orderm.zzNumDown+1)*num));
						
				}
			}
			
		}
		
		//纯固定 这里的宽度 是减固定 ,不是减边封了
		if(orderm.jiShan==5){
			var numZt:Number=0;//中挺数，这个中挺的扣减数，要在最后的固定玻璃上扣减。确保客户要固定多少，玻璃就实际有多少
			var numGd:Number=2;//固定数，如果上面固定或者下面固定，那么中间的固定玻璃只需要减1次或者0次固定的位置
			//有固上
			if(orderm.gudingTop==1){
				
				glassList.addItem(WorkGlass.toWorkGlass(orderm.gdTopHeight-glass.glass_gd-glass.heigth_stc_xs,
					(orderm.width-glass.glass_zt*orderm.zzNumTop-glass.glass_gd*2)/(orderm.zzNumTop+1)-glass.width_stc_xs,
					(orderm.zzNumTop+1)*num));
					
					
				numZt = glass.glass_zt;
				numGd -- ;
				
			}
			//有固下 
			if(orderm.gudingDown==1){
				
				glassList.addItem(WorkGlass.toWorkGlass(orderm.gdDownHeight-glass.glass_gd-glass.heigth_stc_xs,
					(orderm.width-glass.glass_zt*orderm.zzNumDown-glass.glass_gd*2)/(orderm.zzNumDown+1)-glass.width_stc_xs,
					(orderm.zzNumDown+1)*num));
					
					
				numZt += glass.glass_zt;
				numGd -- ;
			}
			
			glassList.addItem(WorkGlass.toWorkGlass(orderm.height-orderm.gdTopHeight-orderm.gdDownHeight-numZt-glass.glass_gd*numGd-glass.heigth_stc_xs,
				orderm.width-glass.glass_gd*2-glass.width_stc_xs,
				num));
		}
	} 
	
	return glassList;
}