////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.utils
{
	/**
	 * JXON is a lightweight class for parsing and using simple XML.
	 * It gives access to children in the XML tree as an array of `children`.
	 * Attributes are an object `attribute` with the attribute key/value pairs.
	 * Namespaces are completely ignored.
	 * If you need more functionality such as E4X and advanced filtering, use the XML and XMLList classes instead.
	 * To parse XML, use JXON.parse(xmlStr) where xmlStr is a string of your XML. 
     * 
     * @royalesuppresspublicvarwarning
	 */
	public class JXON
	{
		public function JXON()
		{
		}

		/**
		 * Static flag to ignore whitespace text nodes
		 */
		 public static var ignoreWhiteSpace:Boolean = true;

		/**
		 * The tag name of the element
		 */
		public var name:String;
		
		/**
		 * Children are iterable. Children can be either JXON objects or Strings.
		 */
		public var children:Array;
		/**
		 * Attributes are saved as an object so simple dot or bracket notation can be used to retrieve attribute values.
		 */
		public var attributes:Object;

		/**
		 * Returns an array of all children whose tag name matches the name.
		 */
		public function getChild(name:String):Array
		{
			var retVal:Array = [];
			for(var i:int=0;i<children.length;i++)
			{
				if(children[i].name == name)
					retVal.push(children[i]);
				
			}
			return retVal;
		}
		/**
		 * Returns a simplified string of the contents of the xml. The tag and all attributes are left out.
		 */
		public function toString():String
		{
			var retVal:String = "";
			for(var i:int=0;i<children.length;i++)
				retVal += children[i];
			
			return retVal;
		}
		/**
		 * Returns the object structure as a string including tags and attributes.
		 * Namespaces, comments and processing instructions are lost.
		 */
		public function toXMLString():String
		{
			var buffer:Array = [];
			buffer.push("<"+this.name+getAttributeString()+">");
			for(var i:int=0;i<children.length;i++)
			{
				if(children[i] is String)
					buffer.push(children[i]);
				else
					buffer.push(children[i].toXMLString());
				
			}
			buffer.push("</"+this.name+">");
			return buffer.join("");
		}
		private function getAttributeString():String{
			var buffer:Array = [];
			var x:String;
			for(x in attributes){
				buffer.push(' ' + x + '="' + attributes[x] + '"');
			}
			return buffer.join("");
		}
				/**
		 * Use `parse()` to convert an XML string into a JXON object.
		 */
		COMPILE::SWF
		public static function parse(xmlStr:String):JXON
		{
			var xml:XML = new XML(xmlStr);
			var retVal:JXON = new JXON();
			retVal.name = xml.name().localName;
			iterateElement(xml,retVal);
			return retVal;
		}

		COMPILE::SWF
		static private function iterateElement(node:XML,jxon:JXON):void
		{
			jxon.children = [];
			jxon.attributes = {};
			var i:int;
			// add attributes
			var attributes:XMLList = node.attributes();
			var len:int = attributes.length();
			for(i=0;i<len;i++)
			{
				jxon.attributes[attributes[i].name().localName] = attributes[i].getValue();
			}
			// loop through childNodes which will be one of:
			// text, cdata, processing instrution or comment and add them as children of the element
			for(i=0;i<node.childNodes.length;i++)
			{
				var child:Object = fromNode(node.childNodes[i]);
				if(child)
					jxon.children.push(child);
			}

		}
		COMPILE::SWF
		static private function fromNode(node:XML):Object
		{
			switch(node.nodeKind()){
				case "element":
					var jxon:JXON = new JXON();
					jxon.name = node.name().localName;
					iterateElement(node,jxon);
					return jxon;
					break;
				case "text":
					return node.getValue();
				default:
					return null;
			}
		}

		/**
		 * Use `parse()` to convert an XML string into a JXON object.
		 */
		COMPILE::JS
		public static function parse(xmlStr:String):JXON{
			if(!xmlStr){
				return null;
			}
			var retVal:JXON = new JXON();
			var parser:DOMParser = new DOMParser();
					// get error namespace. It's different in different browsers.
			var errorNS:String = parser.parseFromString('<', 'application/xml').getElementsByTagName("parsererror")[0].namespaceURI;
					
			var doc:Document = parser.parseFromString(xmlStr, "application/xml");
					
			//check for errors
			if(doc.getElementsByTagNameNS(errorNS, 'parsererror').length > 0)
				throw new Error('XML parse error');

			for(var i:int=0;i<doc.childNodes.length;i++){
				var node:Element = doc.childNodes[i];
				if(node.nodeType == 1){
					//_version = doc.xmlVersion;
							// _encoding = doc.xmlEncoding;
							// _name = new QName();
							// _name.prefix = node.prefix;
							// _name.uri = node.namespaceURI;
					retVal.name = node.localName;
					iterateElement(node,retVal);
				} else {
							// Do we record the nodes which are probably processing instructions?
							//						var child:XML = XML.fromNode(node);
							//						addChild(child);
				}
			}
		return retVal;
		}

		COMPILE::JS
		static private function iterateElement(node:Element,xml:JXON):void
		{
			xml.children = [];
			xml.attributes = {};
			var i:int;
			// add attributes
			for(i=0;i<node.attributes.length;i++)
			{
				xml.attributes[node.attributes[i].localName] = node.attributes[i].value;
			}
			// loop through childNodes which will be one of:
			// text, cdata, processing instrution or comment and add them as children of the element
			for(i=0;i<node.childNodes.length;i++)
			{
				var child:Object = fromNode(node.childNodes[i]);
				if(child)
					xml.children.push(child);
			}
		}
		/**
		* returns an XML object from an existing node without the need to parse the XML.
		* The new XML object is not normalized
		*/
		COMPILE::JS
		static private function fromNode(node:Element):Object
		{
			var xml:JXON = new JXON();
			xml.name = node.localName;
			var i:int;
			var data:* = node.nodeValue;
			switch(node.nodeType)
			{
				case 1:
					//ELEMENT_NODE
					iterateElement(node,xml);
					return xml;
				//case 2:break;// ATTRIBUTE_NODE (handled separately)
				case 3:
					//TEXT_NODE
					if(ignoreWhiteSpace)
						return data.replace(/(^\s*)|(\s*$)/g, "");
					else
						return data;
				case 4:
					//CDATA_SECTION_NODE
					break;
				//case 5:break;//ENTITY_REFERENCE_NODE
				//case 6:break;//ENTITY_NODE
				case 7:
					//PROCESSING_INSTRUCTION_NODE
					break;
				case 8:
					//COMMENT_NODE
					break;
				//case 9:break;//DOCUMENT_NODE
				//case 10:break;//DOCUMENT_TYPE_NODE
				//case 11:break;//DOCUMENT_FRAGMENT_NODE
				//case 12:break;//NOTATION_NODE
				default:
					throw new TypeError("Unknown XML node type!");
					break;
			}
			return null;
		}		
	}
}
