package common
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.rpc.xml.SimpleXMLEncoder;
	
	
	/**
	 *Xml Manager 
	 * */
	public class XmlUtil extends EventDispatcher
	{
		
		private static const XMLHEAD:String = '<?xml version="1.0" encoding="utf-8"?>';
		
		public function XmlUtil()
		{
			throw new Error("Don't init static class");
		}
		
		/**
		 * update xml data
		 * @param data
		 * @param path
		 * */
		public static function updateXmlItem(data:ArrayCollection,path:String):void
		{
			var xml:XML = objectToXML(Util.sortItemIndex(data).source);
			writeXmlFile(xml,path);
			if(xml)
				System.disposeXML(xml);
			if(data)
				data = null;
		}
		
		/**
		 * remove xml data
		 * @param data
		 * @param path
		 * */
		public static function removeXmlItem(data:ArrayCollection,path:String):void
		{
			for(var i:int = data.length -1 ; i >= 0 ; i--)
			{
				if(data.getItemAt(i).selected)
				{
					data.removeItemAt(i);
				}
			}
			var xml:XML = objectToXML(Util.sortItemIndex(data).source);
			writeXmlFile(xml,path);
			if(xml)
				System.disposeXML(xml);
			if(data)
				data = null;
		}
		
		/**
		 * Object to Xml
		 * @param obj
		 * 
		 * @return XML
		 * */
		public static function objectToXML(obj:Object):XML                 
		{                         
			var xmlDocument:XMLDocument = new XMLDocument();   
			var xmlNode:XMLNode = (new SimpleXMLEncoder(xmlDocument)).encodeValue(obj, new QName("root"), xmlDocument);          
			var xml:XML = new XML(xmlDocument.toString());                         
			return xml;                
		} 
		
		/**
		 * Xml to Object
		 * @param xml
		 * 
		 * @return Object
		 * */
		public static function XMLToObject(xml:XML):Object
		{
			var xmlDocument:XMLDocument = new XMLDocument(xml);
			var resultObj:Object = (new SimpleXMLDecoder()).decodeXML(xmlDocument);
			return resultObj;
		}
		
		/**
		 * read Local xml file
		 * @param path
		 * 
		 * @return XML
		 * */
		public static function readXmlFile(path:String):XML
		{
			var file:File = File.applicationDirectory.resolvePath(path); 
			//            trace("read : " + file.nativePath);
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.READ); 
			var xml:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			return xml;
		}
		
		/**
		 * write Local  xml file
		 * @param xml XML file
		 * @param path
		 * */
		public static function writeXmlFile(xml:XML,path:String):void
		{
			var file:File = new File(File.applicationDirectory.resolvePath(path).nativePath);
			//            trace("write : " + file.nativePath);
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.WRITE); 
			var outputString:String = XMLHEAD; 
			outputString += xml.toXMLString(); 
			fileStream.writeUTFBytes(outputString); 
			fileStream.close();
		}
		
	}
}