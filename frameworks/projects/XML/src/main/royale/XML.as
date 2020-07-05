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
package
{
	COMPILE::JS
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class XML
	{
		import org.apache.royale.debugging.assert;
		import org.apache.royale.debugging.assertType;
		import org.apache.royale.language.toAttributeName;
		
		/**
		 * Memory optimization.
		 * Creating a new QName for each XML instance significantly adds memory usage.
		 * The XML QName can be a significant percentage of an XML object size.
		 * By retaining a lookup of QNames and reusing QName objects, we can save quite a bit of memory.
		 */
		static private var _nameMap:Object = {};
		
		static private function getQName(localName:String,prefix:*,uri:String,isAttribute:Boolean):QName{
			localName = localName || "";
			var prefixKey:String =  prefix == null ? '{$'+prefix+'$}' : prefix ; // handle nullish values differently to the potent 'null' or 'undefined' string values
			uri = uri || ''; //internally there is no concept of 'any' namespace which is what a null uri is in a QName.
			var key:String = localName + ":" + prefixKey + ":" + uri + ":" + isAttribute;
			var qname:QName = _nameMap[key];
			if(!qname){
				qname = new QName(uri, localName);
				if(prefix != null)
					qname.setPrefix(prefix);
				if (isAttribute) qname.setIsAttribute(true);
				_nameMap[key] = qname;
			}
			return qname;
		}
		
		/**
		 * Compiler-only method to support multiple 'use namespace' directives
		 * this method is not intended for use other than by the compiler
		 * If it is never generated in application code,  which only happens
		 * with  'use namespace "something"' directives in function execution scope
		 * it will be omitted from the js-release build via dead-code elimination
		 * (unless dead-code elimination is switched off - it is on by default).
		 *
		 * @private
		 * @royalesuppressexport
		 * @royalesuppressclosure
		 */
		public static function multiQName(namespaces:Array, name:*, isAtt:Boolean):QName{
			//create with empty prefix to start:
			var original:QName = name && typeof name == 'object' && name['className'] == 'QName' ? name : new QName(name);
			if (isAtt) original.setIsAttribute(true);
			//generate others
			var others:Array = [];
			while(namespaces.length) {
				var other:QName = new QName(namespaces.shift(), original.localName);
				if (isAtt) other.setIsAttribute(true);
				others.push(other);
			}
			var superCall:Function = original.matches;
			var matchesOverride:Function = function (qName:QName):Boolean
			{
				var match:Boolean = superCall.call(original, qName);
				if (!match)
				{
					match= multiMatch(others, qName);
				}
				return match;
			};
			
			Object.defineProperties(original, {
						//override to identify as *not* a regular QName, but identify by string to avoid checks
						//that create a hard dependency
						"className": {
							"get": function():String
							{
								return "MultiName";
							}
						},
						//override in this instance to perform multiple matching checks:
						"matches": {
							'value': matchesOverride
						}
					}
			);
			
			return original;
		}
		
		/**
		 * @private
		 * see multiQName above
		 */
		private static function multiMatch(qNames:Array, name:QName):Boolean{
			var l:uint = qNames.length;
			var match:Boolean;
			for (var i:uint = 0; i < l; i++)
			{
				var check:QName = qNames[i];
				match = check.matches(name);
				if (match) break;
			}
			return match;
		}
		
		/**
		 * Compiler-only method to support swf compatibility for queries,
		 * this method is not intended for use other than by the compiler.
		 * It may be off-spec, but matches swf implementation behavior.
		 * The 'correction' is only applied if the argument passed to the
		 * child, descendants, or attributes method of XML or XMLList is strongly typed
		 * as a QName.
		 * If it is never generated in application code by the compiler,
		 * the following code will be omitted from the js-release build via dead-code elimination
		 * (unless dead-code elimination is switched off - it is on by default).
		 *
		 * @private
		 * @royalesuppressexport
		 */
		public static function swfCompatibleQuery(original:QName, isAtt:Boolean):QName{
			if (!original || !(original.uri)) return original;
			//the query includes the possibility of 'no namespace' as well as the explicit one in
			//the defined original. Discussed in dev list.
			return multiQName([original.uri], original.localName, isAtt);
		}
		/**
		 * Compiler-only method to support specific namespaced attribute queries.
		 * If it is never generated in application code by the compiler,
		 * it will be omitted from the js-release build via dead-code elimination
		 * (unless dead-code elimination is switched off - it is on by default).
		 *
		 * @private
		 * @royalesuppressexport
		 */
		public static function createAttributeQName(qname:QName):QName{
			if (qname) qname.setIsAttribute(true);
			return qname;
		}
		
		
		/**
		 * Compiler-only method to support construction with specfied default namespace.
		 * This value is applied for each construction call within the applicable scope,
		 * because setting default namespace as part of XML class internal state could
		 * result in inconsistencies for any departure from the applicable scope
		 * (calls to other function scopes or error handling, for example)
		 *
		 * @private
		 * @royalesuppressexport
		 */
		public static function constructWithDefaultXmlNS(source:Object, ns:Object):XML{
			if (ns) {
				var uri:String;
				//always make sure we have a string value (the uri)
				if (typeof ns == 'object' && ns['className'] == 'Namespace') {
					uri = ns.uri;
				} else {
					//toString
					uri = ns + '';
				}
				var ret:XML;
				var err:Error;
				if (ns) {
					try{
						_defaultNS = uri;
						ret = new XML(source);
					} catch (e:Error)
					{
						err = e;
					}
				} else ret = new XML(source);
				_defaultNS = null;
				if (err) throw err;
				else return ret;
			} else return new XML(source);
		}
		
		
		private static const ELEMENT:String = "e";
		private static const ATTRIBUTE:String = "a";
		private static const PROCESSING_INSTRUCTION:String = "p";
		private static const TEXT:String = "t";
		private static const COMMENT:String = "c";
		
		/**
		 * regex to match the xml declaration
		 */
		private static const xmlDecl:RegExp = /^\s*<\?xml[^?]*\?>/im;
		
		/**
		 * Method to free up references to shared QName objects.
		 * Probably only worth doing if most or all XML instances can be garbage-collected.
		 * @langversion 3.0
		 * @productversion Royale 0.9
		 */
		static public function clearQNameCache():void
		{
			_nameMap = {};
		}
		
		/**
		 * [static] Determines whether XML comments are ignored when XML objects parse the source XML data.
		 *
		 */
		static public var ignoreComments:Boolean = true;
		
		/**
		 * [static] Determines whether XML processing instructions are ignored when XML objects parse the source XML data.
		 *
		 */
		static public var ignoreProcessingInstructions:Boolean = true;
		
		/**
		 * [static] Determines whether white space characters at the beginning and end of text nodes are ignored during parsing.
		 *
		 */
		static public var ignoreWhitespace:Boolean = true;
		
		static private var _prettyIndent:int = 2;
		/**
		 * [static] Determines the amount of indentation applied by the toString() and toXMLString() methods when the XML.prettyPrinting property is set to true.
		 *
		 */
		static public function set prettyIndent(value:int):void
		{
			_prettyIndent = value;
			_indentStr = "";
			for(var i:int = 0; i < value; i++)
			{
				_indentStr = _indentStr + INDENT_CHAR;
			}
		}
		
		static public function get prettyIndent():int
		{
			return _prettyIndent;
		}
		
		static private var _indentStr:String = "  ";
		static private var INDENT_CHAR:String = " ";
		
		/**
		 * [static] Determines whether the toString() and toXMLString() methods normalize white space characters between some tags.
		 *
		 */
		static public var prettyPrinting:Boolean = true;
		
		static private function escapeAttributeValue(value:String):String
		{
			var arr:Array = String(value).split("");
			var len:int = arr.length;
			for(var i:int=0;i<len;i++)
			{
				switch(arr[i])
				{
					case "<":
						arr[i] = "&lt;";
						break;
					case "&":
						if(arr[i+1] != "#")
							arr[i] = "&amp;";
						break;
					case '"':
						arr[i] = "&quot;";
						break;
					case "\u000A":
						arr[i] = "&#xA;";
						break;
					case "\u000D":
						arr[i] = "&#xD;";
						break;
					case "\u0009":
						arr[i] = "&#x9;";
						break;
					default:
						break;
				}
			}
			return arr.join("");
		}
		
		static private function escapeElementValue(value:String):String
		{
			var i:int;
			var arr:Array = value.split("");
			const len:uint = arr.length;
			for(i=0;i<len;i++)
			{
				switch(arr[i])
				{
					case "<":
						arr[i] = "&lt;";
						break;
					case ">":
						arr[i] = "&gt;";
						break;
					case "&":
						if(arr[i+1] != "#")
							arr[i] = "&amp;";
						break;
					default:
						break;
				}
			}
			return arr.join("");
		}
		
		static private function insertAttribute(att:Attr,parent:XML):XML
		{
			var xml:XML = new XML();
			xml._parent = parent;
			xml._name = getQName(att.localName, '', att.namespaceURI, true);
			xml._value = att.value;
			parent.addChildInternal(xml);
			return xml;
		}
		
		static private function iterateElement(node:Element,xml:XML):void
		{
			var i:int;
			// add attributes
			var attrs:* = node.attributes;
			var len:int = node.attributes.length;
			//set the name
			var localName:String = node.nodeName;
			var prefix:String = node.prefix;
			if(prefix && localName.indexOf(prefix + ":") == 0)
			{
				localName = localName.substr(prefix.length+1);
			}
			xml._name = getQName(localName, prefix, node.namespaceURI,false);

			var ns:Namespace;
			for(i=0;i<len;i++)
			{
				var att:Attr = attrs[i];
				if ((att.name == 'xmlns' || att.prefix == 'xmlns') && att.namespaceURI == 'http://www.w3.org/2000/xmlns/') {
					//from e4x spec: NOTE Although namespaces are declared using attribute syntax in XML, they are not represented in the [[Attributes]] property.
					if (att.prefix) {
						ns = new Namespace(att.localName, att.nodeValue);
					} else {
						ns = new Namespace('', att.nodeValue);
					}
					xml.addNamespace(ns);
				}
				else insertAttribute(att,xml);
			}
			// loop through childNodes which will be one of:
			// text, cdata, processing instrution or comment and add them as children of the element
			var childNodes:NodeList = node.childNodes;
			len = childNodes.length;
			for(i=0;i<len;i++)
			{
				var nativeNode:Node = childNodes[i];
				const nodeType:Number = nativeNode.nodeType;
				if ((nodeType == 7 && XML.ignoreProcessingInstructions) ||
						(nodeType == 8 && XML.ignoreComments)) {
					continue;
				}
				var child:XML = fromNode(nativeNode);
				if (child)
					xml.addChildInternal(child);
			}
		}
		/**
		 * returns an XML object from an existing node without the need to parse the XML.
		 * The new XML object is not normalized
		 *
		 * @royaleignorecoercion Element
		 */
		static private function fromNode(node:Node):XML
		{
			var xml:XML;
			var data:* = node.nodeValue;
			switch(node.nodeType)
			{
				case 1:
					//ELEMENT_NODE
					xml = new XML();
					//this is _internal... so don't set it, let it use the protoype value of ELEMENT
					//xml._nodeKind = "element";
					//xml.setName(getQName(localName, prefix, node.namespaceURI,false));
					
					iterateElement(node as Element,xml);
					break;
					//case 2:break;// ATTRIBUTE_NODE (handled separately)
				case 3:
					//TEXT_NODE
					if (XML.ignoreWhitespace) {
						data = data.trim();
						if (!data) return null;
					}
					xml = new XML();
					xml.setValue(data);
					break;
				case 4:
					//CDATA_SECTION_NODE
					xml = new XML();
					data = "<![CDATA[" + data + "]]>";
					xml.setValue(data);
					break;
					//case 5:break;//ENTITY_REFERENCE_NODE
					//case 6:break;//ENTITY_NODE
				case 7:
					//PROCESSING_INSTRUCTION_NODE
					xml = new XML();
					xml._nodeKind = PROCESSING_INSTRUCTION;
					//e4x: The [[Name]] for each XML object representing a processing-instruction will have its uri property set to the empty string.
					var localName:String = node.nodeName;
					//var prefix:String = node.prefix;
					if(node.prefix && localName.indexOf(node.prefix + ":") == 0)
					{
						localName = localName.substr(node.prefix.length+1);
					}
					
					xml._name = getQName(localName, null, '',false);
					xml.setValue(data);
					break;
				case 8:
					//COMMENT_NODE
					
					xml = new XML();
					xml._nodeKind = COMMENT;
					//e4X: the name must be null (comment node rules)
					xml.setValue(data);
					break;
					//case 9:break;//DOCUMENT_NODE
					//case 10:break;//DOCUMENT_TYPE_NODE
					//case 11:break;//DOCUMENT_FRAGMENT_NODE
					//case 12:break;//NOTATION_NODE
				default:
					throw new TypeError("Unknown XML node type!");
					break;
			}
			return xml;
		}
		
		static private function namespaceInArray(ns:Namespace,arr:Array):Boolean
		{
			var i:int;
			var l:uint = arr.length;
			for(i=0;i<l;i++)
			{
				if(ns.uri == arr[i].uri)
				{
					if(ns.prefix == arr[i].prefix)
						return true;
				}
			}
			return false;
		}
		
		static private function trimXMLWhitespace(value:String):String
		{
			return value.replace(/^\s+|\s+$/gm,'');
		}
		
		/**
		 * [static] Returns an object with the following properties set to the default values: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * @return
		 *
		 */
		static public function defaultSettings():Object
		{
			return {
				ignoreComments : true,
				ignoreProcessingInstructions : true,
				ignoreWhitespace : true,
				prettyIndent : 2,
				prettyPrinting : true
			}
		}
		
		/**
		 * [static] Sets values for the following XML properties: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * @param rest
		 *
		 */
		static public function setSettings(value:Object):void
		{
			if(!value)
				return;
			
			ignoreComments = value.ignoreComments === undefined ? ignoreComments : value.ignoreComments;
			ignoreProcessingInstructions = value.ignoreProcessingInstructions === undefined ? ignoreProcessingInstructions : value.ignoreProcessingInstructions;
			ignoreWhitespace = value.ignoreWhitespace === undefined ? ignoreWhitespace : value.ignoreWhitespace;
			prettyIndent = value.prettyIndent === undefined ? prettyIndent : value.prettyIndent;
			prettyPrinting = value.prettyPrinting === undefined ? prettyPrinting : value.prettyPrinting;
		}
		
		/**
		 * [static] Retrieves the following properties: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 *
		 * @return
		 *
		 */
		static public function settings():Object
		{
			return {
				ignoreComments : ignoreComments,
				ignoreProcessingInstructions : ignoreProcessingInstructions,
				ignoreWhitespace : ignoreWhitespace,
				prettyIndent : prettyIndent,
				prettyPrinting : prettyPrinting
			}
		}
		
		/**
		 *  mimics the top-level XML function
		 *  @royaleignorecoercion XMLList
		 *
		 *  @royalesuppressexport
		 */
		public static function conversion(xml:*, defaultNS:*):XML
		{
			if (xml == null)
			{
				//as3 docs say this is a TypeError, but it is actually not (in AVM), return an empty text node
				return new XML();
			}
			else if (xml.ROYALE_CLASS_INFO != null)
			{
				var className:String = xml.ROYALE_CLASS_INFO.names[0].name;
				switch(className){
					case "XML":
						return xml;
					case "XMLList":
						var xmlList:XMLList = xml as XMLList;
						if (xmlList.length() == 1)
							return xmlList[0];
						// throw TypeError
						return null;
				}

			}
			if (defaultNS !== undefined) {
				return constructWithDefaultXmlNS(xml, defaultNS);
			}
			else return new XML(xml);
		}
		
		private static var _defaultNS:String;
		private static var _internal:Boolean;
		/**
		 * @royaleignorecoercion XML
		 */
		public function XML(xml:* = null)
		{
			// _origStr = xml;
			// _children = [];
			if(xml != null)
			{
				var xmlStr:String = ignoreWhitespace ? trimXMLWhitespace("" + xml) : "" + xml;
				if(xmlStr.indexOf("<") == -1)
				{
					// _nodeKind = TEXT;
					_value = xmlStr;
				}
				else
				{
					parseXMLStr(xmlStr);
				}
			} else {
				if (!_internal) {
					// _nodeKind = TEXT;
					_value = '';
				}
			}
			initializeClass();
			if(!_class_initialized)
			{
				Object.defineProperty(XML.prototype,"0",
						{
							"get": function():*{return this},
							"set": function():void{},
							enumerable: true,
							configurable: true
						}
				);
				_class_initialized = true;
			}
		}
		private static function initializeClass():void
		{
			
		}

		private static var _class_initialized:Boolean = false;
		
		private static const xmlRegEx:RegExp = /&(?![\w]+;)/g;
		private static const isWhitespace:RegExp = /^\s+$/;
		private static var parser:DOMParser;
		private static var errorNS:String;
		/**
		 *
		 * @royaleignorecoercion Element
		 */
		private function parseXMLStr(xml:String):void
		{
			//escape ampersands
			xml = xml.replace(xmlRegEx,"&amp;");
			if(!parser)
				parser = new DOMParser();
			var doc:Document;
			if(errorNS == null)
			{
				// get error namespace. It's different in different browsers.
				try{
					errorNS = parser.parseFromString('<', 'application/xml').getElementsByTagName("parsererror")[0].namespaceURI;
				}
				catch(err:Error){
					// Some browsers (i.e. IE) just throw an error
					errorNS = "na";
				}
			}
			
			var decl:String = xmlDecl.exec(xml);
			if (decl) xml = xml.replace(decl,'');
			if (ignoreWhitespace) xml = trimXMLWhitespace( xml) ;
			//various node types not supported directly
			//when parsing, always wrap (e4x ref p34, 'Semantics' of e4x-Ecma-357.pdf)
			//custom: support alternate default xml namespace when parsing:
			if (_defaultNS) xml = '<parseRoot xmlns="'+_defaultNS+'">'+xml+'</parseRoot>';
			else xml = '<parseRoot>'+xml+'</parseRoot>';
			try
			{
				doc = parser.parseFromString(xml, "application/xml");
			}
			catch(err:Error)
			{
				throw err;
			}
			
			//check for errors
			var errorNodes:NodeList = doc.getElementsByTagNameNS(errorNS, 'parsererror');
			if(errorNodes.length > 0)
				throw new Error(errorNodes[0].innerHTML);
			
			//parseRoot wrapper
			doc = doc.childNodes[0];
			
			var childCount:uint = doc.childNodes.length;
			//var rootError:Boolean;
			var foundRoot:Boolean;
			var foundCount:uint = 0;
			for(var i:int=0;i<childCount;i++)
			{
				var node:Node = doc.childNodes[i];
				if(node.nodeType == 1)
				{
					if (foundRoot) {
						foundCount++;
						//we have at least 2 root tags... definite error
						break;
					}
					foundRoot = true;
					foundCount = 1; //top level root tag wins
					
					if (foundCount != 0) {
						//reset any earlier settings\
						resetNodeKind();
					}
					_name = getQName(node.localName,node.prefix,node.namespaceURI,false);
					_internal = true;
					iterateElement(node as Element,this);
					_internal = false;
				}
				else
				{
					if (foundRoot) continue; // if we already found a root, then everything else is ignored outside it, regardless of XML settings, so only continue to check for multiple root tags (an error)
					if (node.nodeType == 7) {
						if (XML.ignoreProcessingInstructions) {
							if (!foundCount) {
								// this._nodeKind = TEXT;
								//e4x: The value of the [[Name]] property is null if and only if the XML object represents an XML comment or text node
								delete this._name;
								this.setValue('');
							}
						} else {
							this._nodeKind = PROCESSING_INSTRUCTION;
							this.setName(node.nodeName);
							this.setValue(node.nodeValue);
							foundCount++;
						}
					} else if (node.nodeType == 4) {
						if (!foundCount) {
							// this._nodeKind = TEXT;
							//e4x: The value of the [[Name]] property is null if and only if the XML object represents an XML comment or text node
							delete this._name;
							this.setValue('<![CDATA[' + node.nodeValue + ']]>');
						}
						foundCount++;
					} else if (node.nodeType == 8) {
						//e4x: The value of the [[Name]] property is null if and only if the XML object represents an XML comment or text node
						delete this._name;
						if (XML.ignoreComments) {
							if (!foundCount) {
								// this._nodeKind = TEXT;
								this.setValue('');
							}
						} else {
							if (!foundCount) {
								this._nodeKind = COMMENT;
								this.setValue(node.nodeValue);
							}
							foundCount++;
						}
					}
					else if (node.nodeType == 3) {
						var whiteSpace:Boolean = isWhitespace.test(node.nodeValue);
						if (!whiteSpace || !XML.ignoreWhitespace) {
							if (!foundCount) {
								delete this._name;
								// this._nodeKind = TEXT;
								this.setValue(node.nodeValue);
							}
							foundCount++;
						} else {
							//do nothing
						}
					}
				}
			}
			
			if (foundCount > 1) throw new TypeError('Error #1088: The markup in the document following the root element must be well-formed.');

		}
		protected function resetNodeKind():void{
			delete this._nodeKind;
			delete this._value;
			delete this._name;
		}
		protected var _children:Array;
		protected var _attributes:Array;
		private var _parent:XML;
		protected var _value:String;
		
		/*
		 The value of the [[InScopeNamespaces]] property is a set of zero or more Namespace objects representing the namespace declarations in scope for this XML object.
		 All of the Namespace objects in the [[InScopeNamespaces]] property have a prefix property with a value that is not undefined.
		 When a new object is added to the [[InScopeNamespaces]] set, it replaces any existing object in the [[InScopeNamespaces]] set that has the same set identity.
		 The set identity of each Namespace object n OF [[InScopeNamespaces]] is defined to be n.prefix. Therefore, there exists no two objects x,y OF [[InScopeNamespaces]],
		 such that the result of the comparison x.prefix == y.prefix is true.
		 */
		protected var _namespaces:Array;
		private function getNamespaces():Array
		{
			if(!_namespaces)
				_namespaces = [];
			
			return _namespaces;
		}
		
		/**
		 * @private
		 *
		 * Similar to appendChild, but accepts all XML types (text, comment, processing-instruction, attribute, or element)
		 *
		 *
		 */
		public function addChild(child:XML):void
		{
			if(!child)
				return;
			
			addChildInternal(child);
			normalize();
		}
		protected function addChildInternal(child:XML):void
		{
			assertType(child,XML,"Type must be XML");
			child.setParent(this);
			if(child.getNodeRef() == ATTRIBUTE)
				getAttributes().push(child);
			else getChildren().push(child);
		}
		
		private function getChildren():Array
		{
			if(!_children)
				_children = [];
			
			return _children;
		}
		
		private function getAttributes():Array
		{
			if(!_attributes)
				_attributes = [];
			
			return _attributes;
		}
		
		/**
		 * Adds a namespace to the set of in-scope namespaces for the XML object.
		 *
		 * @param ns
		 * @return
		 *
		 *
		 * @royaleignorecoercion QName
		 */
		public function addNamespace(ns:Namespace):XML
		{
			//TODO cached QNames will not work very well here.
			/*
				When the [[AddInScopeNamespace]] method of an XML object x is called with a namespace N, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", “attribute”}, return
				2. If N.prefix != undefined
				  a. If N.prefix == "" and x.[[Name]].uri == "", return
				  b. Let match be null
				  c. For each ns in x.[[InScopeNamespaces]]
				    i. If N.prefix == ns.prefix, let match = ns
				  d. If match is not null and match.uri is not equal to N.uri
				    i. Remove match from x.[[InScopeNamespaces]]
				  e. Let x.[[InScopeNamespaces]] = x.[[InScopeNamespaces]] ∪ { N }
				  f. If x.[[Name]].[[Prefix]] == N.prefix
				    i. Let x.[[Name]].prefix = undefined
				  g. For each attr in x.[[Attributes]]
				    i. If attr.[[Name]].[[Prefix]] == N.prefix, let attr.[[Name]].prefix = undefined
				3. Return
			*/
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind == ATTRIBUTE)
				return this;
			if(ns.prefix === undefined)
				return this;
			if(ns.prefix == "" && name().uri == "")
				return this;
			var match:Namespace = null;
			var i:int;
			var nSpaces:Array = getNamespaces();
			var len:int = nSpaces.length;
			//reverse loop to search more recent additions first because of match rule below
			for(i=len-1;i>0;i--)
			{
				if(nSpaces[i].prefix == ns.prefix)
				{
					match = nSpaces[i];
					break;
				}
			}
			// If match is not null and match.uri is not equal to N.uri
			if(match && match.uri != ns.uri) {
				// Remove match from x.[[InScopeNamespaces]]
				nSpaces.splice(i,1);
				len--;
			}
			nSpaces[len]=ns;
			
			if(ns.prefix == name().prefix) {
				_name = getQName(_name.localName,undefined,_name.uri,false)
			}
			
			len = attributeLength();
			for(i=0;i<len;i++)
			{
				var att:XML = _attributes[i];
				if(att.name().prefix == ns.prefix)  {
					
					att._name = getQName(QName(att._name).localName,null,QName(att._name).uri,true);
				}
			}
			return this;
		}
		
		/**
		 * Appends the given child to the end of the XML object's properties.
		 *
		 * @param child
		 * @return
		 *
		 * @royaleignorecoercion XML
		 *
		 */
		public function appendChild(child:*):XML
		{
			/*
			1. Let children be the result of calling the [[Get]] method of x with argument "*"
			2. Call the [[Put]] method of children with arguments children.[[Length]] and child
			3. Return x
		
			*/
			var childType:String = typeof child;
			
			if(childType != "object") {
				const last:uint = childrenLength();
				const lastChild:XML = last ? _children[last-1] : null;
				if (lastChild && lastChild.getNodeRef() == ELEMENT) {
					
					const wrapper:XML = new XML();
					wrapper.resetNodeKind();
					child = new XML(child.toString());
					wrapper._name = lastChild._name;
					child.setParent(wrapper);
					wrapper.getChildren().push(child);
					child = wrapper;
				} else {
					child = xmlFromStringable(child);
				}
			}
			
			appendChildInternal(child);
			//normalize seems not correct here:
			//normalize();
			return this;
		}

		/**
		 *
		 * @royaleignorecoercion XML
		 */
		private function appendChildInternal(child:*):void
		{
			var kind:String;
			var alreadyPresent:int
			var children:Array = getChildren();
			if(child is XMLList)
			{
				var len:int = child.length();
				for(var i:int=0; i<len; i++)
				{
					//reproduce swf behavior... leaves a phantom child in the source
					var childItem:XML = child[i] as XML;
					kind = childItem.getNodeRef();
					if (kind == ATTRIBUTE) {
						var name:String = childItem.localName();
						var content:String = '<'+name+'>'+childItem.toString()+'</'+name+'>';
						childItem = new XML(content)
					} else {
						alreadyPresent = children.indexOf(childItem);
						if (alreadyPresent != -1) children.splice(alreadyPresent, 1);
					}
					childItem.setParent(this, true);
					children.push(childItem);
				}
			}
			else
			{
				assertType(child,XML,"Type must be XML");
				kind = child.getNodeRef();
				if (kind == ATTRIBUTE) {
					child = new XML(child.toString());
				} else {
					alreadyPresent = children.indexOf(child);
					if (alreadyPresent != -1) children.splice(alreadyPresent, 1);
				}
				(child as XML).setParent(this);
				children.push(child);
			}
		}
		
		/**
		 * Returns the XML value of the attribute that has the name matching the attributeName parameter.
		 *
		 * @param attributeName
		 * @return
		 *
		 */
		public function attribute(attributeName:*):XMLList
		{
			var i:int;
			if(attributeName == "*")
				return attributes();

			attributeName = toAttributeName(attributeName);
			var list:XMLList = new XMLList();
			var len:int = attributeLength();
			for(i=0;i<len;i++)
			{
				if(attributeName.matches(_attributes[i].name()))
					list.append(_attributes[i]);
			}
			list.targetObject = this;
			list.targetProperty = attributeName;
			return list;
		}
		
		/**
		 * Returns a list of attribute values for the given XML object.
		 *
		 * @return
		 *
		 */
		public function attributes():XMLList
		{
			var i:int;
			var list:XMLList = new XMLList();
			var len:int = attributeLength();
			for(i=0;i<len;i++)
				list.append(_attributes[i]);
			
			list.targetObject = this;
			return list;
		}
		
		/**
		 * Lists the children of an XML object.
		 *
		 * @param propertyName
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function child(propertyName:Object):XMLList
		{
			/*
			 *
			When the [[Get]] method of an XML object x is called with property name P, the following steps are taken:
			1. If ToString(ToUint32(P)) == P
			  a. Let list = ToXMLList(x)
			  b. Return the result of calling the [[Get]] method of list with argument P
			2. Let n = ToXMLName(P)
			3. Let list be a new XMLList with list.[[TargetObject]] = x and list.[[TargetProperty]] = n
			4. If Type(n) is AttributeName
			  a. For each a in x.[[Attributes]]
			    i. If ((n.[[Name]].localName == "*") or (n.[[Name]].localName == a.[[Name]].localName)) and ((n.[[Name]].uri == null) or (n.[[Name]].uri == a.[[Name]].uri))
			      1. Call the [[Append]] method of list with argument a
			  b. Return list
			5. For (k = 0 to x.[[Length]]-1)
			  a. If ((n.localName == "*") or ((x[k].[[Class]] == "element") and (x[k].[[Name]].localName == n.localName))) and ((n.uri == null) or ((x[k].[[Class]] == “element”) and (n.uri == x[k].[[Name]].uri)))
			    i. Call the [[Append]] method of list with argument x[k]
			6. Return list
			*/
			var i:int;
			var len:int;
			var list:XMLList = new XMLList();
			if(parseInt(propertyName,10).toString() == propertyName)
			{
				if(propertyName != "0")
					return null;
				list.append(this);
				list.targetObject = this;
				return list;
			}
			//support MultiQName for multiple use namespace directives:
			if (propertyName && propertyName['className'] != 'MultiName')
				propertyName = toXMLName(propertyName);
			if(propertyName.isAttribute)
			{
				len = attributeLength();
				for(i=0;i<len;i++)
				{
					if(propertyName.matches(_attributes[i].name()))
						list.append(_attributes[i]);
				}
			}
			else
			{
				len = childrenLength();
				//special case: '*'
				var all:Boolean = propertyName.localName == "*" && propertyName.uri === '';
				for(i=0;i<len;i++)
				{
					var child:XML = _children[i] as XML;
					if( all  || propertyName.matches(child.name()))
						list.append(child);
				}
			}
			list.targetObject = this;
			list.targetProperty = propertyName;
			return list;
		}
		
		/**
		 * Identifies the zero-indexed position of this XML object within the context of its parent.
		 *
		 * @return
		 *
		 */
		public function childIndex():int
		{
			if(!_parent)
				return -1;
			
			return _parent.getIndexOf(this);
		}
		
		/**
		 * Lists the children of the XML object in the sequence in which they appear.
		 *
		 * @return
		 *
		 */
		public function children():XMLList
		{
			var i:int;
			var list:XMLList = new XMLList();
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				list.append(_children[i]);
			}
			
			list.targetObject = this;
			return list;
		}
		
		/**
		 * Lists the properties of the XML object that contain XML comments.
		 *
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function comments():XMLList
		{
			var i:int;
			var list:XMLList = new XMLList();
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				if((_children[i] as XML).getNodeRef() == COMMENT)
					list.append(_children[i]);
			}
			list.targetObject = this;
			return list;
		}
		
		public function concat(list:*):XMLList
		{
			if(list is XML)
			{
				var newList:XMLList = new XMLList();
				newList.append(list);
				list = newList;
			}
			if(!(list is XMLList))
				throw new TypeError("invalid type");
			
			var retVal:XMLList = new XMLList();
			retVal.append(this);
			var item:XML;
			for each(item in list)
				retVal.append(item);
			
			return retVal;
		}
		
		/**
		 * Compares the XML object against the given value parameter.
		 *
		 * @param value
		 * @return
		 *
		 */
		public function contains(value:*):Boolean
		{
			if(value is XML || value is XMLList)
				return this.equals(value);
			return value == this;
		}
		
		/**
		 * Returns a copy of the given XML object.
		 *
		 * @return
		 *
		 */
		public function copy():XML
		{
			/*
				When the [[DeepCopy]] method of an XML object x is called, the following steps are taken:
				1. Let y be a new XML object with y.[[Prototype]] = x.[[Prototype]], y.[[Class]] = x.[[Class]], y.[[Value]] = x.[[Value]], y.[[Name]] = x.[[Name]], y.[[Length]] = x.[[Length]]
				2. For each ns in x.[[InScopeNamespaces]]
				  a. Let ns2 be a new Namespace created as if by calling the constructor new Namespace(ns)
				  b. Let y.[[InScopeNamespaces]] = y.[[InScopeNamespaces]] ∪ { ns2 }
				3. Let y.[[Parent]] = null
				4. For each a in x.[[Attributes]]
				  a. Let b be the result of calling the [[DeepCopy]] method of a
				  b. Let b.[[Parent]] = y
				  c. Let y.[[Attributes]] = y.[[Attributes]] ∪ { b }
				5. For i = 0 to x.[[Length]]-1
				  a. Let c be the result of calling the [[DeepCopy]] method of x[i]
				  b. Let y[i] = c
				  c. Let c.[[Parent]] = y
				6. Return y
			*/
			var i:int;
			var xml:XML = new XML();
			xml.resetNodeKind();
			xml.setNodeKind(getNodeKindInternal());
			xml._name = _name;
			if(_value){
				xml.setValue(_value);
			}
			var len:int;
			len = namespaceLength();
			for(i=0;i<len;i++)
			{
				xml.addNamespace(new Namespace(_namespaces[i]));
			}
			//parent should be null by default
			len = attributeLength();
			for(i=0;i<len;i++)
				xml.addChildInternal(_attributes[i].copy());
			len = childrenLength();
			for(i=0;i<len;i++)
				xml.addChildInternal(_children[i].copy());
			
			return xml;
		}
		
		/**
		 * @royaleignorecoercion XML
		 */
		private function deleteChildAt(idx:int):void
		{
			var child:XML = _children[idx] as XML;
			child._parent = null;
			_children.splice(idx,1);
		}
		
		/**
		 * Returns all descendants (children, grandchildren, great-grandchildren, and so on) of the XML object that have the given name parameter.
		 *
		 * @param name
		 * @return
		 *
		 * @royaleignorecoercion XML
		 *
		 */
		public function descendants(name:Object = "*"):XMLList
		{
			/*
				When the [[Descendants]] method of an XML object x is called with property name P, the following steps are taken:
				1. Let n = ToXMLName(P)
				2. Let list be a new XMLList with list.[[TargetObject]] = null
				3. If Type(n) is AttributeName
				  a. For each a in x.[[Attributes]]
				    i. If ((n.[[Name]].localName == "*") or (n.[[Name]].localName == a.[[Name]].localName)) and ((n.[[Name]].uri == null) or (n.[[Name]].uri == a.[[Name]].uri ))
				      1. Call the [[Append]] method of list with argument a
				4. For (k = 0 to x.[[Length]]-1)
				  a. If ((n.localName == "*") or ((x[k].[[Class]] == "element") and (x[k].[[Name]].localName == n.localName))) and ((n.uri == null) or ((x[k].[[Class]] == "element") and (n.uri == x[k].[[Name]].uri)))
				    i. Call the [[Append]] method of list with argument x[k]
				  b. Let dq be the resultsof calling the [[Descendants]] method of x[k] with argument P
				  c. If dq.[[Length]] > 0, call the [[Append]] method of list with argument dq
				5. Return list
			*/
			var i:int;
			var len:int;
			if(!name)
				name = "*";
			name = toXMLName(name);
			var list:XMLList = new XMLList();
			if(name.isAttribute)
			{
				len = attributeLength();
				for(i=0;i<len;i++)
				{
					if(name.matches(_attributes[i].name()))
						list.append(_attributes[i]);
				}
			}
			len = childrenLength();
			for(i=0;i<len;i++)
			{
				var child:XML = _children[i] as XML;
				if(name.matches(child.name()))
					list.append(child);
				if(child.getNodeRef() == ELEMENT)
				{
					list.concat(child.descendants(name));
				}
			}
			return list;
		}
		
		/**
		 * Lists the elements of an XML object. (handles E4X dot notation)
		 *
		 * @param name
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function elements(name:Object = "*"):XMLList
		{
			if(!name)
				name = "*";
            var all:Boolean = (name == "*");
                
			name = toXMLName(name);
			var i:int;
			var list:XMLList = new XMLList();
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				if(_children[i].getNodeRef() == ELEMENT && (all || name.matches(_children[i].name())))
					list.append(_children[i]);
			}
			
			list.targetObject = this;
			list.targetProperty = name;
			return list;
		}
		/**
		 * for each should work on XML too
		 * @private
		 */
		public function elementNames():Array
		{
			return [0];
		}
		public function equals(xml:*):Boolean
		{
			/*
				When the [[Equals]] method of an XML object x is called with value V, the following steps are taken:
				1. If Type(V) is not XML, return false
				2. If x.[[Class]] is not equal to V.[[Class]], return false
				3. If x.[[Name]] is not null
				  a. If V.[[Name]] is null, return false
				  b. If x.[[Name]].localName is not equal to V.[[Name]].localName, return false
				  c. If x.[[Name]].uri is not equal to V.[[Name]].uri, return false
				4. Else if V.[[Name]] is not null, return false
				5. If x.[[Attributes]] does not contain the same number of items as V.[[Attributes]], return false
				6. If x.[[Length]] is not equal to V.[[Length]], return false
				7. If x.[[Value]] is not equal to y[[Value]], return false
				8. For each a in x.[[Attributes]]
				  a. If V.[[Attributes]] does not contain an attribute b, such that b.[[Name]].localName == a.[[Name]].localName, b.[[Name]].uri == a.[[Name]].uri and b.[[Value]] == a.[[Value]], return false
				9. For i = 0 to x.[[Length]]-1
				  a. Let r be the result of calling the [[Equals]] method of x[i] with argument V[i]
				  b. If r == false, return false
				10. Return true
			*/
			var i:int;
			if (xml == this) return true;
			
			if(!(xml is XML))
				return false;
			
			if(xml.getNodeRef() != getNodeRef())
				return false;
			
			if(!name().equals(xml.name()))
				return false;
			var selfAttrs:Array = getAttributeArray();
			var xmlAttrs:Array = xml.getAttributeArray();
			if(selfAttrs.length != xmlAttrs.length)
				return false;
			//length comparison should not be necessary because xml always has a length of 1
			if(getValue() != xml.getValue())
				return false;
			
			for(i=0;i<selfAttrs.length;i++)
			{
				if(!xml.hasAttribute(selfAttrs[i]))
					return false;
			}
			var selfChldrn:Array = getChildrenArray();
			var xmlChildren:Array = xml.getChildrenArray();
			if(selfChldrn.length != xmlChildren.length)
				return false;
			
			for(i=0;i<selfChldrn.length;i++)
			{
				if(!selfChldrn[i].equals(xmlChildren[i]))
					return false;
			}
			return true;
		}
		
		public function hasAttribute(nameOrXML:*,value:String=null):Boolean
		{
			if(!_attributes)
				return false;
			var name:QName;
			if(nameOrXML is XML)
			{
				name = nameOrXML.name();
				value = nameOrXML.getValue();
			}
			else
			{
				name = new QName(nameOrXML);
				name.setIsAttribute(true);
			}
			var i:int;
			var len:int = attributeLength();
			for(i=0;i<len;i++)
			{
				if(name.matches(_attributes[i].name()))
				{
					if(!value)
						return true;
					return value == _attributes[i].getValue();
				}
			}
			return false;
		}
		
		private function getAncestorNamespaces(namespaces:Array):Array
		{
			//don't modify original
			namespaces = namespaces.slice();
			var nsIdx:int;
			var pIdx:int;
			if(_parent)
			{
				var parentNS:Array = _parent.inScopeNamespaces();
				var len:int = parentNS.length;
				for(pIdx=0;pIdx<len;pIdx++)
				{
					var curNS:Namespace = parentNS[pIdx];
					var doInsert:Boolean = true;
					for(nsIdx=0;nsIdx<namespaces.length;nsIdx++)
					{
						if(curNS.uri == namespaces[nsIdx].uri && curNS.prefix == namespaces[nsIdx].prefix)
						{
							doInsert = false;
							break;
						}
					}
					if(doInsert)
						namespaces.push(curNS);
					
				}
				namespaces = _parent.getAncestorNamespaces(namespaces);
			}
			return namespaces;
		}
		
		public function getAttributeArray():Array
		{
			return _attributes ? _attributes : [];
		}
		public function getChildrenArray():Array
		{
			return _children ? _children : [];
		}
		
		public function getIndexOf(elem:XML):int
		{
			return _children ? _children.indexOf(elem) : -1;
		}
		protected function childrenLength():int
		{
			return _children ? _children.length : 0;
		}
		protected function attributeLength():int
		{
			return _attributes ? _attributes.length : 0;
		}
		protected function namespaceLength():int
		{
			return _namespaces ? _namespaces.length : 0;
		}
		
		private function getURI(prefix:String):String
		{
			var i:int;
			var namespaces:Array = inScopeNamespaces();
			for(i=0;i<namespaces.length;i++)
			{
				if(namespaces[i].prefix == prefix)
					return namespaces[i].uri;
			}
			return "";
		}
		
		public function getValue():String
		{
			return _value;
		}
		
		public function hasAncestor(obj:*):Boolean
		{
			if(!obj)
				return false;
			
			var parent:XML = this.parent();
			while(parent)
			{
				if(obj == parent)
					return true;
				parent = parent.parent();
			}
			return false;
		}
		/**
		 * Checks to see whether the XML object contains complex content.
		 *
		 * @return true if this XML instance contains complex content
		 *
		 * @royaleignorecoercion XML
		 */
		public function hasComplexContent():Boolean
		{
			/*
				When the hasComplexContent method is called on an XML object x, the following steps are taken:
				1. If x.[[Class]] ∈ {"attribute", "comment", "processing-instruction", "text"}, return false
				2. For each property p in x
				a. If p.[[Class]] == "element", return true
				3. Return false
			*/
			var kind:String = getNodeRef();
			if(kind == ATTRIBUTE || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind == TEXT)
				return false;
			var i:int;
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				
				if((_children[i] as XML).getNodeRef() == ELEMENT)
					return true;
			}
			return false;
		}
		
		/**
		 *
		 * @royaleignorecoercion XML
		 */
		override public function hasOwnProperty(p:*):Boolean
		{
			/*
				When the [[HasProperty]] method of an XML object x is called with property name P, the following steps are taken:
				1. If ToString(ToUint32(P)) == P
				  a. Return (P == "0")
				2. Let n = ToXMLName(P)
				3. If Type(n) is AttributeName
				  a. For each a in x.[[Attributes]]
				    i. If ((n.[[Name]].localName == "*") or (n.[[Name]].localName == a.[[Name]].localName)) and ((n.[[Name]].uri == null) or (n.[[Name]].uri == a.[[Name]].uri))
				      1. Return true
				  b. Return false
				4. For (k = 0 to x.[[Length]]-1)
				  a. If ((n.localName == "*") or ((x[k].[[Class]] == "element") and (x[k].[[Name]].localName == n.localName))) and ((n.uri == null) or (x[k].[[Class]] == "element") and (n.uri == x[k].[[Name]].uri)))
				    i. Return true
				5. Return false
			*/
			if(parseInt(p,10).toString() == p)
				return p == "0";
			var name:QName = toXMLName(p);
			var i:int;
			var len:int;
			if(name.isAttribute)
			{
				len = attributeLength();
				for(i=0;i<len;i++)
				{
					if(name.matches((_attributes[i] as XML).name()))
						return true;
				}
			}
			else
			{
				len = childrenLength();
				for(i=0;i<len;i++)
				{
					if((_children[i] as XML).getNodeRef() != ELEMENT)
						continue;
					if((_children[i] as XML).name().matches(name))
						return true;
				}
			}
			return false;
		}
		
		/**
		 * Checks to see whether the XML object contains simple content.
		 *
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function hasSimpleContent():Boolean
		{
			/*
				When the hasSimpleContent method is called on an XML object x, the following steps are taken:
				1. If x.[[Class]] ∈ {"comment", "processing-instruction"}, return false
				2. For each property p in x
				a. If p.[[Class]] == "element", return false
				3. Return true
			*/
			var kind:String = getNodeRef();
			if(kind == COMMENT || kind == PROCESSING_INSTRUCTION)
				return false;
			var i:int;
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				if((_children[i] as XML).getNodeRef() == ELEMENT)
					return false;
			}
			return true;
		}
		
		/**
		 * Lists the namespaces for the XML object, based on the object's parent.
		 *
		 * @return
		 *
		 */
		public function inScopeNamespaces():Array
		{
			/*
			 The inScopeNamespaces method returns an Array of Namespace objects representing the namespaces in scope for this XML object in the context of its parent. If the parent of this XML object is modified, the associated namespace declarations may change. The set of namespaces returned by this method may be a super set of the namespaces used by this value.
			 Semantics
			 When the inScopeNamespaces method is called on an XML object x, the following steps are taken:
			 1. Let y = x
			 2. Let inScopeNS = { }
			 3. While (y is not null)
			 a. For each ns in y.[[InScopeNamespaces]]
			 i. If there exists no n ∈ inScopeNS, such that n.prefix == ns.prefix
			 1. Let inScopeNS = inScopeNS ∪ { ns }
			 b. Let y = y.[[Parent]]
			 4. Let a be a new Array created as if by calling the constructor, new Array()
			 5. Let i = 0
			 6. For each ns in inScopeNS
			 a. Call the [[Put]] method of a with arguments ToString(i) and ns
			 b. Let i = i + 1
			 7. Return a
			 */
			var y:XML = this;
			var inScopeNS:Array = [];
			var i:int = 0;
			var prefixCheck:Object = {};
			while (y != null) {
				var searchNS:Array = y._namespaces;
				if (searchNS) {
					for each(var ns:Namespace in searchNS) {
						if (!prefixCheck[ns.prefix]) {
							inScopeNS[i++] = ns;
							prefixCheck[ns.prefix] = true;
						}
					}
				}
				y = y.parent();
			}
			//return _namespaces ? _namespaces.slice() : [];
			
			return inScopeNS;
		}
		
		private function insertChildAt(child:XML,idx:int):void{
			/*
				When the [[Insert]] method of an XML object x is called with property name P and value V, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return
				2. Let i = ToUint32(P)
				3. If (ToString(i) is not equal to P), throw a TypeError exception
				4. If Type(V) is XML and (V is x or an ancestor of x) throw an Error exception
				5. Let n = 1
				6. If Type(V) is XMLList, let n = V.[[Length]]
				7. If n == 0, Return
				8. For j = x.[[Length]]-1 downto i, rename property ToString(j) of x to ToString(j + n)
				9. Let x.[[Length]] = x.[[Length]] + n
				10. If Type(V) is XMLList
				  a. For j = 0 to V.[[Length-1]]
				    i. V[j].[[Parent]] = x
				    ii. x[i + j] = V[j]
				11. Else
				  a. Call the [[Replace]] method of x with arguments i and V
				12. Return
			*/
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind == ATTRIBUTE)
				return;
			if(!child)
				return;
			var parent:XML = child.parent();
			if(parent)
				parent.removeChild(child);
			child.setParent(this);
			
			getChildren().splice(idx,0,child);
		}
		/**
		 * Inserts the given child2 parameter after the child1 parameter in this XML object and returns the resulting object.
		 *
		 * @param child1
		 * @param child2
		 * @return
		 *
		 */
		public function insertChildAfter(child1:XML, child2:XML):XML
		{
			/*
				When the insertChildAfter method is called on an XML object x with parameters child1 and child2, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return
				2. If (child1 == null)
				a. Call the [[Insert]] method of x with arguments "0" and child2
				b. Return x
				3. Else if Type(child1) is XML
				a. For i = 0 to x.[[Length]]-1
				i. If x[i] is the same object as child1
				1. Call the [[Insert]] method of x with a
			*/
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind == ATTRIBUTE)
				return null;
			if(!child1)
			{
				insertChildAt(child2,0);
				return child2;
			}
			var idx:int = getIndexOf(child1);
			if(idx >= 0)
			{
				insertChildAt(child2,idx+1);
			}
			return child2;
		}
		
		/**
		 * Inserts the given child2 parameter before the child1 parameter in this XML object and returns the resulting object.
		 *
		 * @param child1
		 * @param child2
		 * @return
		 *
		 */
		public function insertChildBefore(child1:XML, child2:XML):XML
		{
			/*
				When the insertChildBefore method is called on an XML object x with parameters child1 and child2, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return
				2. If (child1 == null)
				a. Call the [[Insert]] method of x with arguments ToString(x.[[Length]]) and child2
				b. Return x
				3. Else if Type(child1) is XML
				a. For i = 0 to x.[[Length]]-1
				i. If x[i] is the same object as child1
				1. Call the [[Insert]] method of x with arguments ToString(i) and child2
				2. Return x
				4. Return
			*/
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind == ATTRIBUTE)
				return null;
			if(!child1)
			{
				var len:int = childrenLength();
				insertChildAt(child2,len);
				return child2;
			}
			var idx:int = getIndexOf(child1);
			if(idx >= 0)
			{
				insertChildAt(child2,idx);
			}
			return child2;
		}
		
		/**
		 * For XML objects, this method always returns the integer 1.
		 *
		 * @return
		 *
		 */
		public function length():int
		{
			return 1;
		}
		
		/**
		 * Gives the local name portion of the qualified name of the XML object.
		 *
		 * @return
		 *
		 */
		public function localName():String
		{
			return _name? _name.localName : null;
		}
		
		protected var _name:QName;
		
		/**
		 * Gives the qualified name for the XML object.
		 *
		 * @return
		 *
		 */
		public function name():QName
		{
			/*if(!_name)
				_name = getQName("","","",false);*/
			return _name;
		}
		
		/**
		 * If no parameter is provided, gives the namespace associated with the qualified name of this XML object.
		 *
		 * @param prefix
		 * @return
		 *
		 */
		public function namespace(prefix:String = null):*
		{
			/*
				When the namespace method is called on an XML object x with zero arguments or one argument prefix, the following steps are taken:
				1. Let y = x
				2. Let inScopeNS = { }
				3. While (y is not null)
				  a. For each ns in y.[[InScopeNamespaces]]
				    i. If there exists no n ∈ inScopeNS, such that n.prefix == ns.prefix
				      1. Let inScopeNS = inScopeNS ∪ { ns }
				  b. Let y = y.[[Parent]]
				4. If prefix was not specified
				  a. If x.[[Class]] ∈ {"text", "comment", "processing-instruction"}, return null
				  b. Return the result of calling the [[GetNamespace]] method of x.[[Name]] with argument inScopeNS
				5. Else
				  a. Let prefix = ToString(prefix)
				  b. Find a Namespace ns ∈ inScopeNS, such that ns.prefix = prefix. If no such ns exists, let ns = undefined.
				  c. Return ns
			*/
			
			//4.a exit early before performing steps 2,3:
			var kind:String = getNodeRef();
			if(kind == TEXT || kind ==  COMMENT || kind ==  PROCESSING_INSTRUCTION)
				return null;
			
			//step 2, 3:
			var inScopeNS:Array = inScopeNamespaces();
			//step 4.b
			//no prefix. get the namespace of our object
			if (prefix == null) return name().getNamespace(inScopeNS);
			
			//step 5:
			var len:int = inScopeNS.length;
			for(var i:int=0;i<len;i++)
			{
				if(inScopeNS[i].prefix == prefix)
					return inScopeNS[i];
			}
			return null;
		}
		
		/**
		 * Lists namespace declarations associated with the XML object in the context of its parent.
		 *
		 * @return
		 *
		 */
		public function namespaceDeclarations():Array
		{
			/*
				When the namespaceDeclarations method is called on an XML object x, the following steps are taken:
				1. Let a be a new Array created as if by calling the constructor, new Array()
				2. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return a
				3. Let y = x.[[Parent]]
				4. Let ancestorNS = { }
				5. While (y is not null)
				  a. For each ns in y.[[InScopeNamespaces]]
				    i. If there exists no n ∈ ancestorNS, such that n.prefix == ns.prefix
				      1. Let ancestorNS = ancestorNS ∪ { ns }
				  b. Let y = y.[[Parent]]
				6. Let declaredNS = { }
				7. For each ns in x.[[InScopeNamespaces]]
				  a. If there exists no n ∈ ancestorNS, such that n.prefix == ns.prefix and n.uri == ns.uri
				    i. Let declaredNS = declaredNS ∪ { ns }
				8. Let i = 0
				9. For each ns in declaredNS
				  a. Call the [[Put]] method of a with arguments ToString(i) and ns
				  b. Let i = i + 1
				10. Return a
			*/
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION || kind ==  ATTRIBUTE)
				return [];
			
			//early check - no need to look in the ancestors if there is nothing local to check:
			//[[InScopeNamespaces]] is nspaces here:
			var nspaces:Array = _namespaces;
			if (!nspaces || !nspaces.length) return [];
			
			//step 4 & 5:
			var ancestors:Array = _parent ? _parent.inScopeNamespaces() : [];
			//early check -quick exit
			if (!ancestors.length) {
				return nspaces.slice();
			}
			var declaredNS:Array = [];
			var match:Boolean;
			//steps 7,8,9
			for each(var ns:Namespace in nspaces) {
				match = false;
				for each(var ns2:Namespace in ancestors) {
					if (ns.prefix == ns.prefix && ns.uri == ns2.uri) {
						match = true;
						break;
					}
				}
				if (!match) {
					declaredNS.push(ns);
				}
			}
			//10
			return declaredNS;
		}
		
		private var _nodeKind:String;
		protected function getNodeKindInternal():String{
			return kindNameLookup[getNodeRef()];
		}

		protected function getNodeRef():String{
			if(_nodeKind)
				return _nodeKind;
			if(!_name)
				return TEXT;
			if(_name.isAttribute){
				return ATTRIBUTE;
			}
			return ELEMENT;
		}

		private static const kindNameLookup:Object = {
			"e" : "element",
			"a" : "attribute",
			"p" : "processing-instruction",
			"t" : "text",
			"c" : "comment"
		};

		private static const kindRefLookup:Object = {
			"element"                : "e",
			"attribute"              : "a",
			"processing-instruction" : "p",
			"text"                   : "t",
			"comment"                : "c"
		};

		/**
		 * Specifies the type of node: text, comment, processing-instruction, attribute, or element.
		 * @return
		 *
		 */
		public function nodeKind():String
		{
			return getNodeKindInternal(); // append '' here to convert the String Object to a primitive
		}
		
		/**
		 * For the XML object and all descendant XML objects, merges adjacent text nodes and eliminates empty text nodes.
		 *
		 * @return
		 *
		 */
		public function normalize():XML
		{
			var len:int = childrenLength() - 1;
			var lastChild:XML;
			for(var i:int=len;i>=0;i--)
			{
				var child:XML = _children[i];
				// can we have a null child?
				
				if(child.getNodeRef() == ELEMENT)
				{
					child.normalize();
				}
				else if(child.getNodeRef() == TEXT)
				{
					if(lastChild && lastChild.getNodeRef() == TEXT)
					{
						child.setValue(child.s() + lastChild.s());
						deleteChildAt(i+1);
					}
					if(!child.s())
					{
						deleteChildAt(i);
						continue; //don't set last child if we removed it
					}
				}
				lastChild = child;
			}
			return this;
		}
		
		/**
		 * Returns the parent of the XML object.
		 *
		 * @return
		 *
		 */
		public function parent():*
		{
			return _parent;
		}
		
		public function plus(rightHand:*):*
		{
			var list:XMLList = new XMLList();
			list.append(this);
			return list.plus(rightHand);
		}
		
		private function xmlFromStringable(value:*):XML
		{
			var str:String = value.toString();
			var xml:XML = new XML();
			xml.setValue(str);
			return xml;
		}
		/**
		 * Inserts the provided child object into the XML element before any existing XML properties for that element.
		 * @param value
		 * @return
		 *
		 */
		public function prependChild(child:XML):XML
		{
			var childType:String = typeof child;
			if(childType != "object")
				child = xmlFromStringable(child);
			
			prependChildInternal(child);
			normalize();
			return this;
		}
		
		private function prependChildInternal(child:*):void
		{
			if(child is XMLList)
			{
				var len:int = child.length();
				for(var i:int=0; i<len; i++)
				{
					prependChildInternal(child[0]);
				}
			}
			else
			{
				assertType(child,XML,"Type must be XML");
				child.setParent(this);
				getChildren().unshift(child);
			}
		}
		
		/**
		 * If a name parameter is provided, lists all the children of the XML object that contain processing instructions with that name.
		 *
		 * @param name
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function processingInstructions(name:String = "*"):XMLList
		{
			var i:int;
			var list:XMLList = new XMLList();
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				if((_children[i] as XML).getNodeRef() == PROCESSING_INSTRUCTION)
					list.append(_children[i]);
			}
			list.targetObject = this;
			return list;
		}
		
		/**
		 * Removes the given child for this object and returns the removed child.
		 *
		 * @param child
		 * @return
		 *
		 */
		public function removeChild(child:XML):Boolean
		{
			/*
				When the [[Delete]] method of an XML object x is called with property name P, the following steps are taken:
				1. If ToString(ToUint32(P)) == P, throw a TypeError exception
				NOTE this operation is reserved for future versions of E4X.
				2. Let n = ToXMLName(P)
				3. If Type(n) is AttributeName
				  a. For each a in x.[[Attributes]]
				    i. If ((n.[[Name]].localName == "*") or (n.[[Name]].localName == a.[[Name]].localName)) and ((n.[[Name]].uri == null) or (n.[[Name]].uri == a.[[Name]].uri))
				      1. Let a.[[Parent]] = null
				      2. Remove the attribute a from x.[[Attributes]]
				  b. Return true
				4. Let dp = 0
				5. For q = 0 to x.[[Length]]-1
				  a. If ((n.localName == "*") or (x[q].[[Class]] == "element" and x[q].[[Name]].localName == n.localName)) and ((n.uri == null) or (x[q].[[Class]] == “element” and n.uri == x[q].[[Name]].uri ))
				    i. Let x[q].[[Parent]] = null
				    ii. Remove the property with the name ToString(q) from x
				    iii. Let dp = dp + 1
				  b. Else
				    i. If dp > 0, rename property ToString(q) of x to ToString(q – dp)
				6. Let x.[[Length]] = x.[[Length]] - dp
				7. Return true.
			*/
			var i:int;
			var len:int;
			var removed:XML;
			if(!child)
				return false;
			if(child is XMLList){
				var val:Boolean = false;
				len = child.length();
				for(i=len-1;i>=0;i--){
					if(removeChild(child[i])){
						val = true;
					}
				}
				return val;
			}
			if(!(child is XML))
				return removeChildByName(child);
			
			if(child.getNodeRef() == ATTRIBUTE)
			{
				len = attributeLength();
				for(i=0;i<len;i++)
				{
					if(child.equals(_attributes[i]))
					{
						removed = _attributes[i];
						removed._parent = null;
						_attributes.splice(i,1);
						return true;
					}
				}
				return false;
			}
			var idx:int = getIndexOf(child);
			if(idx < 0)
				return false;
			removed = _children.splice(idx,1);
			child._parent = null;
			return true;
		}
		
		/**
		 *
		 * @royaleignorecoercion XML
		 */
		private function removeChildByName(name:*):Boolean
		{
			var i:int;
			var len:int;
			name = toXMLName(name);
			var child:XML;
			var removedItem:Boolean = false;
			if(name.isAttribute)
			{
				len = attributeLength() -1;
				for(i=len;i>=0;i--)
				{
					child = _attributes[i] as XML;
					if(name.matches(child.name()))
					{
						child = _attributes[i];
						child._parent = null;
						_attributes.splice(i,1);
						removedItem = true;
					}
				}
				return removedItem;
			}
			//QUESTION am I handling non-elements correctly?
			len = childrenLength() - 1;
			for(i=len;i>=0;i--)
			{
				child = _children[i] as XML;
				if(child.getNodeRef() != ELEMENT){
					continue;
				}
				
				if(name.matches(child.name()))
				{
					child = _children[i];
					child._parent = null;
					_children.splice(i,1);
					removedItem = true;
				}
			}
			normalize(); // <-- check this is correct
			return removedItem;
		}
		public function removeChildAt(index:int):Boolean
		{
			/*
				When the [[DeleteByIndex]] method of an XML object x is called with property name P, the following steps are taken:
				1. Let i = ToUint32(P)
				2. If ToString(i) == P
				  a. If i is less than x.[[Length]]
				    i. If x has a property with name P
				      1. Let x[P].[[Parent]] = null
				      2. Remove the property with the name P from x
				    ii. For q = i+1 to x.[[Length]]-1
				      1. Rename property ToString(q) of x to ToString(q – 1)
				    iii. Let x.[[Length]] = x.[[Length]] – 1
				  b. Return true
				3. Else throw a TypeError exception
			*/
			//Do nothing for XML objects?
			if (index < childrenLength()) {
				var removed:XML = _children[index];
				if (removed) {
					removed.setParent(null);
					index =_children.indexOf(removed);
					if (index != -1){
						_children.splice(index,1);
					}
				}
				return true;
			}

			throw new TypeError("Cannot call delete on XML at index "+index);
		}
		
		/**
		 * Removes the given namespace for this object and all descendants.
		 *
		 * @param ns
		 * @return
		 *
		 * @royaleignorecoercion XML
		 */
		public function removeNamespace(ns:*):XML
		{
			/*
				Overview
				The removeNamespace method removes the given namespace from the in scope namespaces of this object and all its descendents,
				then returns a copy of this XML object. The removeNamespaces method will not remove a namespace from an object where it is referenced
				by that object’s QName or the QNames of that object’s attributes.
				Semantics
				When the removeNamespace method is called on an XML object x with parameter namespace, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return x
				2. Let ns be a Namespace object created as if by calling the function Namespace( namespace )
				3. Let thisNS be the result of calling [[GetNamespace]] on x.[[Name]] with argument x.[[InScopeNamespaces]]
				4. If (thisNS == ns), return x
				5. For each a in x.[[Attributes]]
				  a. Let aNS be the result of calling [[GetNamespace]] on a.[[Name]] with argument x.[[InScopeNamespaces]]
				  b. If (aNS == ns), return x
				6. If ns.prefix == undefined
				  a. If there exists a namespace n ∈ x.[[InScopeNamespaces]], such that n.uri == ns.uri, remove the namespace n from x.[[InScopeNamespaces]]
				7. Else
				  a. If there exists a namespace n ∈ x.[[InScopeNamespaces]], such that n.uri == ns.uri and n.prefix == ns.prefix, remove the namespace n from x.[[InScopeNamespaces]]
				8. For each property p of x
				  a. If p.[[Class]] = "element", call the removeNamespace method of p with argument ns
				9. Return x
			*/
			var i:int;
			var len:int;
			var ref:String = getNodeRef();
			if(ref == TEXT || ref == COMMENT || ref == PROCESSING_INSTRUCTION || ref == ATTRIBUTE)
				return this;
			if(!(ns is Namespace))
				ns = new Namespace(ns);
			if(ns == name().getNamespace(_namespaces))
				return this;
			len = attributeLength();
			for(i=0;i<len;i++)
			{
				if(ns == _attributes[i].name().getNamespace(_namespaces))
					return this;
			}
			
			//
			
			len = namespaceLength();
			for(i=len-1;i>=0;i--)
			{
				if(_namespaces[i].uri == ns.uri && _namespaces[i].prefix == ns.prefix)
					_namespaces.splice(i,1);
				else if(ns.prefix == null && _namespaces[i].uri == ns.uri)
					_namespaces.splice(i,1);
			}
			len = childrenLength();
			for(i=0;i<len;i++)
			{
				if((_children[i] as XML).getNodeRef() == ELEMENT)
					(_children[i] as XML).removeNamespace(ns);
			}
			return this;
		}
		
		/**
		 * Replaces the properties specified by the propertyName parameter with the given value parameter.
		 *
		 * @param propertyName
		 * @param value
		 * @return
		 *
		 */
		public function replace(propertyName:Object, value:*):*
		{
			//@todo this is not finished - needs work, review and testing. Reference to [[Replace]] below should call 'replaceChildAt'
			/*
				Semantics (x refers to 'this')
				When the replace method is called on an XML object x with parameters propertyName and value, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return x
				2. If Type(value) ∉ {XML, XMLList}, let c = ToString(value)
				3. Else let c be the result of calling the [[DeepCopy]] method of value
				4. If ToString(ToUint32(P)) == P
				  a. Call the [[Replace]] method of x with arguments P and c and return x
				5. Let n be a QName object created as if by calling the function QName(P)
				6. Let i = undefined
				7. For k = x.[[Length]]-1 downto 0
				  a. If ((n.localName == "*") or ((x[k].[[Class]] == "element") and (x[k].[[Name]].localName==n.localName))) and ((n.uri == null) or ((x[k].[[Class]] == "element") and (n.uri == x[k].[[Name]].uri )))
				    i. If (i is not undefined), call the [[DeleteByIndex]] method of x with argument ToString(i)
				    ii. Let i = k
				8. If i == undefined, return x
				9. Call the [[Replace]] method of x with arguments ToString(i) and c
				10. Return x
			*/
			var ref:String = getNodeRef();
			if(ref == TEXT || ref == COMMENT || ref == PROCESSING_INSTRUCTION || ref ==  ATTRIBUTE)
			{
				// Changing this to pretend we're a string
				return s().replace(propertyName,value);
				//return this;
			}
			if(value === null || value === undefined)
				return this;
			if((value is XML) || (value is XMLList))
				value = value.copy();
			else
				value = value.toString();
			
			return null;
		}
		
		/**
		 *
		 * @royaleignorecoercion XML
		 * @royaleignorecoercion XMLList
		 */
		public function replaceChildAt(idx:int,v:*):void
		{
			/*
				**this is the [[Replace]] method in the spec**
				When the [[Replace]] method of an XML object x is called with property name P and value V, the following steps are taken:
				1. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return
				2. Let i = ToUint32(P)
				3. If (ToString(i) is not equal to P), throw a TypeError exception
				4. If i is greater than or equal to x.[[Length]],
				  a. Let P = ToString(x.[[Length]])
				  b. Let x.[[Length]] = x.[[Length]] + 1
				5. If Type(V) is XML and V.[[Class]] ∈ {"element", "comment", "processing-instruction", "text"}
				  a. If V.[[Class]] is “element” and (V is x or an ancestor of x) throw an Error exception
				  b. Let V.[[Parent]] = x
				  c. If x has a property with name P
				  i. Let x[P].[[Parent]] = null
				  d. Let x[P] = V
				6. Else if Type(V) is XMLList
				  a. Call the [[DeleteByIndex]] method of x with argument P
				  b. Call the [[Insert]] method of x with arguments P and V
				7. Else
				  a. Let s = ToString(V)
				  b. Create a new XML object t with t.[[Class]] = "text", t.[[Parent]] = x and t.[[Value]] = s
				  c. If x has a property with name P
				    i. Let x[P].[[Parent]] = null
				  d. Let the value of property P of x be t
				8. Return
			*/
			var len:int;
			var ref:String = getNodeRef();
			if(ref == TEXT || ref == COMMENT || ref == PROCESSING_INSTRUCTION || ref ==  ATTRIBUTE)
				return;
			len = childrenLength();
			if(idx > len)
				idx = len;
			// make sure _children exist
			getChildren();
			if(v is XML && (v as XML).getNodeRef() != ATTRIBUTE)
			{
				if((v as XML).getNodeRef() == ELEMENT && (v==this || isAncestor(v)) )
					throw new TypeError("cannot assign parent xml as child");
				v.setParent(this);
				if(_children[idx])
					removeChild(_children[idx]);
				insertChildAt(v,idx);
			}
			else if(v is XMLList)
			{
				len = (v as XMLList).length();
				//6.
				if(_children[idx])
					_children[idx]._parent = null;
				if (len)  {
					v[0].setParent(this);
					_children[idx] = v[0];
					var listIdx:int = 1;
					var chld:XML = v[0];
					while(listIdx < len)
					{
						chld = v[listIdx];
						insertChildAt(chld,idx+listIdx);
						listIdx++;
					}
				} else {
					_children.splice(idx,1);
				}
			}
			else
			{
				//7. this is a text node
				chld = new XML();
				chld.setValue(v + '');//7.a, 7.b
				chld.setParent(this);
				if (_children[idx] != null) (_children[idx] as XML).setParent(null);
				_children[idx] = chld;
			}
		}
		
		private function isAncestor(xml:XML):Boolean
		{
			var p:XML = _parent;
			while(p)
			{
				if(p == xml)
					return true;
				p = p._parent;
			}
			return false;
		}
		
		/**
		 *
		 * @royaleignorecoercion XML
		 */
		public function setAttribute(attr:*,value:String):String
		{
			var i:int;
			//make sure _attributes is not null
			getAttributes();
			
			if(attr is XML)
			{
				if((attr as XML).getNodeRef() == ATTRIBUTE)
				{
					var len:int = attributeLength();
					for(i=0;i<len;i++)
					{
						if(_attributes[i].name().equals(attr.name()))
						{
							_attributes[i].setValue(value);
							return value;
						}
					}
					if(value)
						attr.setValue(value);
					addChild(attr);
				}
				return value;
				
			}
			if(typeof attr == 'string' && attr.indexOf("xmlns") == 0)
			{
				//it's a namespace declaration
				var ns:Namespace;
				var prfIdx:int = attr.indexOf(":");
				if (prfIdx != -1){
					ns = new Namespace(attr.substring(prfIdx + 1), value.toString());
				} else ns = new Namespace(value.toString());
				this.addNamespace(ns);
			}
			else
			{
				//it's a regular attribute string
				var attrXML:XML = new XML();
				var nameRef:QName = toAttributeName(attr);
				attrXML._name = getQName(nameRef.localName,nameRef.prefix,nameRef.uri,true);
				attrXML.setValue(value);
				len = attributeLength();
				for(i=0;i<len;i++)
				{
					if(_attributes[i].name().equals(attrXML.name()))
					{
						_attributes[i].setValue(value);
						return value;
					}
				}
				addChild(attrXML);
			}
			return value;
		}
		/**
		 * Replaces the child properties of the XML object with the specified name with the specified XML or XMLList.
		 * This is primarily used to support dot notation assignment of XML.
		 *
		 * @param value
		 * @return
		 *
		 * @royaleignorecoercion QName
		 * @royaleignorecoercion XML
		 */
		public function setChild(elementName:*, elements:Object):Object
		{
			
			/*
			 *  [[Put]]
			1. If ToString(ToUint32(P)) == P, throw a TypeError exception NOTE this operation is reserved for future versions of E4X.
			2. If x.[[Class]] ∈ {"text", "comment", "processing-instruction", "attribute"}, return
			3. If (Type(V) ∉ {XML, XMLList}) or (V.[[Class]] ∈ {"text", "attribute"})
			  a. Let c = ToString(V)
			4. Else
			  a. Let c be the result of calling the [[DeepCopy]] method of V
			5. Let n = ToXMLName(P)
			6. If Type(n) is AttributeName
			  a. Call the function isXMLName (section 13.1.2.1) with argument n.[[Name]] and if the result is false, return
			  b. If Type(c) is XMLList
			    i. If c.[[Length]] == 0, let c be the empty string
			    ii. Else
			      1. Let s = ToString(c[0])
			      2. For i = 1 to c.[[Length]]-1
			        a. Let s be the result of concatenating s, the string " " (space) and ToString(c[i])
			      3. Let c = s
			  c. Else
			    i. Let c = ToString(c)
			  d. Let a = null
			  e. For each j in x.[[Attributes]]
			    i. If (n.[[Name]].localName == j.[[Name]].localName) and ((n.[[Name]].uri == null) or (n.[[Name]].uri == j.[[Name]].uri))
			      1. If (a == null), a = j
			      2. Else call the [[Delete]] method of x with argument j.[[Name]]
			  f. If a == null
			    i. If n.[[Name]].uri == null
			      1. Let nons be a new Namespace created as if by calling the constructor new Namespace()
			      2. Let name be a new QName created as if by calling the constructor new QName(nons, n.[[Name]])
			    ii. Else
			      1. Let name be a new QName created as if by calling the constructor new QName(n.[[Name]])
			    iii. Create a new XML object a with a.[[Name]] = name, a.[[Class]] == "attribute" and a.[[Parent]] = x
			    iv. Let x.[[Attributes]] = x.[[Attributes]] ∪ { a }
			    v. Let ns be the result of calling the [[GetNamespace]] method of name with no arguments
			    vi. Call the [[AddInScopeNamespace]] method of x with argument ns
			  g. Let a.[[Value]] = c
			  h. Return
			7. Let isValidName be the result of calling the function isXMLName (section 13.1.2.1) with argument n
			8. If isValidName is false and n.localName is not equal to the string "*", return
			9. Let i = undefined
			10. Let primitiveAssign = (Type(c) ∉ {XML, XMLList}) and (n.localName is not equal to the string "*")
			11. For (k = x.[[Length]]-1 downto 0)
			  a. If ((n.localName == "*") or ((x[k].[[Class]] == "element") and (x[k].[[Name]].localName==n.localName))) and ((n.uri == null) or ((x[k].[[Class]] == “element”) and (n.uri == x[k].[[Name]].uri )))
			    i. If (i is not undefined), call the [[DeleteByIndex]] property of x with argument ToString(i)
			    ii. Let i = k
			12. If i == undefined
			  a. Let i = x.[[Length]]
			  b. If (primitiveAssign == true)
			    i. If (n.uri == null)
			      1. Let name be a new QName created as if by calling the constructor new QName(GetDefaultNamespace(), n)
			    ii. Else
			      1. Let name be a new QName created as if by calling the constructor new QName(n)
			    iii. Create a new XML object y with y.[[Name]] = name, y.[[Class]] = "element" and y.[[Parent]] = x
			    iv. Let ns be the result of calling [[GetNamespace]] on name with no arguments
			    v. Call the [[Replace]] method of x with arguments ToString(i) and y
			    vi. Call [[AddInScopeNamespace]] on y with argument ns
			13. If (primitiveAssign == true)
			  a. Delete all the properties of the XML object x[i]
			  b. Let s = ToString(c)
			  c. If s is not the empty string, call the [[Replace]] method of x[i] with arguments "0" and s
			14. Else
			  a. Call the [[Replace]] method of x with arguments ToString(i) and c
			15. Return
			*/
			var i:int;
		/*	var len:int;
			var chld:XML;
			var retVal:Object = elements;
			var chldrn:XMLList;
			var childIdx:int;*/
			if (uint(elementName).toString() == elementName) throw new TypeError('not permitted');
			var ref:String = getNodeRef();
			if(ref == TEXT || ref == COMMENT || ref == PROCESSING_INSTRUCTION || ref == ATTRIBUTE)
				return this;
			var n:QName = toXMLName(elementName); //5.

			if (n.isAttribute) {
				//@todo
				return setAttribute(n, elements+'');
			}

			//7.0
			//8.0



		   //	elements = elements + ''; //13.b
			i = -1;// undefined;
			var wild:Boolean = n.localName == '*';
			var primitiveAssign:Boolean = !wild && !(elements is XML || elements is XMLList);//primitiveAssign step 10.
			var k:int = childrenLength() - 1; //11

			while (k > -1) { //11
				if (
						( wild  || ((_children[k] as XML).getNodeRef() == ELEMENT &&  (_children[k] as XML).localName() == n.localName) )
						&& (n.uri == null /* maybe: !n.uri ? */ || ((_children[k] as XML).getNodeRef() == ELEMENT &&  QName((_children[k] as XML)._name).uri == n.uri)))
				{
					if (i !== -1) {
						removeChildAt(i); //11.a.i
					}
					i = k; //11.a.ii
				}
				k--;
			}
			if (i == -1) { //12.
				i = childrenLength(); //12.a
				if (primitiveAssign) { //12.b
					//skipping 12.b.i and 12.b.ii for now...@todo review
					/*if (n.uri == null) {

                    } else {

                    }*/
					_internal = true;
					var y:XML = new XML();
					_internal = false;
					y._name = getQName(n.localName,n.prefix,n.uri,false);
					y.setParent(this); //end of 12.n.iii
					var ns:Namespace = new Namespace('', n);
					replaceChildAt(i,y);
					y.setNamespace(ns);//@todo check this for 12.b.iv and 12.b.vi
				}
			}

			if (primitiveAssign) { //13 @todo review guess at conditional
				//13.a. Delete all the properties of the XML object x[i]
				y = _children[i];
				k = y.childrenLength() - 1;
				while(k>-1) {
					y.removeChildAt(k); //13.a
					k--;
				}
				elements = elements + ''; //13.b
				if (elements) {
					y.replaceChildAt(0, elements); //13.c
				}
			} else {
				//elements = (elements as XML).copy(); //@todo check... might need attention here
				replaceChildAt(i, elements); //14.a
			}

			return elements;
		}
		
		/**
		 * Replaces the child properties of the XML object with the specified set of XML properties, provided in the value parameter.
		 *
		 * @param value
		 * @return
		 *
		 */
		public function setChildren(value:Object):XML
		{
			var i:int;
			var len:int;
			var chld:XML;
			
			if(value is XML)
			{
				var list:XMLList = new XMLList();
				list[0] = value;
				value = list;
			}
			if(value is XMLList)
			{
				// remove all existing elements
				var chldrn:XMLList = children();
				var childIdx:int = chldrn.length() -1;
				if(chldrn.length())
					childIdx = chldrn[0].childIndex();
				
				len = chldrn.length() -1;
				for (i= len; i >= 0;  i--)
				{
					removeChild(chldrn[i]);
					// remove the nodes
					// remove the children
					// adjust the childIndexes
				}
				var curChild:XML = getChildren()[childIdx];
				// Now add them in.
				len = value.length();
				for(i=0;i<len;i++)
				{
					chld = value[i];
					if(!curChild)
					{
						curChild = chld;
						appendChild(chld);
					}
					else {
						insertChildAfter(curChild, chld);
						curChild = chld;
					}
				}
			}
			
			return this;
		}
		
		/**
		 * Changes the local name of the XML object to the given name parameter.
		 *
		 * @param name
		 *
		 */
		public function setLocalName(name:String):void
		{
			if(!_name)
				_name = new QName();
			
			_name = getQName(name,_name.prefix,_name.uri,_name.isAttribute)
			// _name.localName = name;
		}
		
		/**
		 * Sets the name of the XML object to the given qualified name or attribute name.
		 *
		 * @param name
		 *
		 */
		public function setName(name:*):void
		{
			//@todo add tests to review against the following:
			/*1. If x.[[Class]] ∈ {"text", "comment"}, return
			2. If (Type(name) is Object) and (name.[[Class]] == "QName") and (name.uri == null)
			a. Let name = name.localName
			3. Let n be a new QName created if by calling the constructor new QName(name)
			4. If x.[[Class]] == "processing-instruction", let n.uri be the empty string
			5. Let x.[[Name]] = n
			6. Let ns be a new Namespace created as if by calling the constructor new Namespace(n.prefix, n.uri)
			7. If x.[[Class]] == "attribute"
			a. If x.[[Parent]] == null, return
			b. Call x.[[Parent]].[[AddInScopeNamespace]](ns)
			8. If x.[[Class]] == "element"
			a. Call x.[[AddInScopeNamespace]](ns)*/
			var ref:String = getNodeRef();
			if (ref == TEXT || ref == COMMENT) return; //e4x, see 1 above
			var nameRef:QName;
			if(name is QName)
				nameRef = name;
			else
				nameRef = new QName(name);
			var asAtttribute:Boolean = nameRef.isAttribute;
			_name = getQName(nameRef.localName,nameRef.prefix,nameRef.uri,asAtttribute);
			if (asAtttribute) {
				//optimization, the name alone is sufficient to get the nodeKind() externally (see : getNodeRef())
				delete this._nodeKind;
			}
		}
		
		/**
		 * Sets the namespace associated with the XML object.
		 *
		 * @param ns
		 *
		 */
		public function setNamespace(ns:Object):void
		{
			var kind:String = getNodeRef();
			if(kind == TEXT || kind == COMMENT || kind == PROCESSING_INSTRUCTION)
				return;
			var ns2:Namespace = new Namespace(ns);
			var nameRef:QName = new QName(ns2,name());
			
			if(kind == ATTRIBUTE)
			{
				if(_parent == null)
					return;
				nameRef.setIsAttribute(true);
				_parent.addNamespace(ns2);
			}
			
			_name = getQName(nameRef.localName,nameRef.prefix,nameRef.uri,nameRef.isAttribute);
			
			if(kind == ELEMENT)
				addNamespace(ns2);
		}
		
		/**
		 * @private
		 *
		 */
		public function setNodeKind(value:String):void
		{
			// memory optimization. The default on the prototype is "element" and using the prototype saves memory
			if(getNodeKindInternal() != value) {
				var kind:String = kindRefLookup[value];
				if(kind){
					_nodeKind = kind;
				}
			}
			
		}

		/**
		 * @private
		 * @royalesuppressexport
		 */
		public function setParent(parent:XML, keep:Boolean=false):void
		{
			if(parent == _parent)
				return;
			var oldParent:XML = _parent;
			if(oldParent && !keep)
				oldParent.removeChild(this);
			_parent = parent;
		}
		
		public function setValue(value:String):void
		{
			_value = value;
		}
		
		/**
		 * @private
		 *
		 * Allows XMLList to get the targetObject of its targetObject and not error when it gets the XML
		 */
		public function get targetObject():*
		{
			return null;
		}
		
		/**
		 * Returns an XMLList object of all XML properties of the XML object that represent XML text nodes.
		 *
		 * @return
		 *
		 */
		public function text():XMLList
		{
			var list:XMLList = new XMLList();
			var i:int;
			var len:int = childrenLength();
			for(i=0;i<len;i++)
			{
				var child:XML = _children[i];
				if(child.getNodeRef() == TEXT)
					list.append(child);
			}
			list.targetObject = this;
			return list;
		}
		
		/**
		 * Provides an overridable method for customizing the JSON encoding of values in an XML object.
		 *
		 * @param k
		 * @return
		 *
		 */
		/*
       override public function toJSON(k:String):String
       {
           return this.name();
       }
       */
		
		/**
		 * Returns a string representation of the XML object.
		 *
		 * @return
		 *
		 */
		public function toString():String
		{
			var i:int;
			// text, comment, processing-instruction, attribute, or element
			var kind:String = getNodeRef();
			if( kind == ATTRIBUTE)
				return _value;
			if(kind == TEXT)
				return _value && _value.indexOf('<![CDATA[') == 0 ? _value.substring(9, _value.length-3): _value;
			if(kind == COMMENT)
				return "";
			if(kind == PROCESSING_INSTRUCTION)
				return "";
			if(this.hasSimpleContent())
			{
				var s:String = "";
				var len:int = childrenLength();
				for(i=0;i<len;i++)
				{
					var child:XML = _children[i];
					var childKind:String = child.getNodeRef();
					if(child.childKind == COMMENT || child.childKind == PROCESSING_INSTRUCTION)
						continue;
					s = s + child.toString();
				}
				return s;
			}
			return toXMLString();
		}
		
		/**
		 *
		 * @royaleignorecoercion QName
		 */
		/*private function toAttributeName(name:*):QName
		{
			const typeName:String = typeof name;
			if (name == null || typeName == 'number'|| typeName == 'boolean') {
				throw new TypeError('invalid xml name');
			}
			
			var qname:QName;
			//@todo: typeName == 'object' && ... etc here (avoid Language.is)
			if (name is QName) {
				if (QName(name).isAttribute) qname = name as QName;
				else {
					qname = new QName(name);
					qname.setIsAttribute(true);
				}
			} else {
				var str:String = name.toString();
				//normalize
				var idx:int = str.indexOf('@');
				if (idx != -1) str = str.slice(idx+1);
				qname = new QName(str);
				qname.setIsAttribute(true);
			}
			return qname;
		}*/
		
		private function toXMLName(name:*):QName
		{
			/*
				Given a string s, the ToXMLName conversion function returns a QName object or AttributeName. If the first character of s is "@", ToXMLName creates an AttributeName using the ToAttributeName operator. Otherwise, it creates a QName object using the QName constructor.
				Semantics
				Given a String value s, ToXMLName operator converts it to a QName object or AttributeName using the following steps:
				1. If ToString(ToUint32(s)) == ToString(s), throw a TypeError exception
				2. If the first character of s is "@"
					a. Let name = s.substring(1, s.length)
					b. Return ToAttributeName(name)
				3. Else
					a. Return a QName object created as if by calling the constructor new QName(s)
			*/
			const typeName:String = typeof name;
			if (name == null || typeName=='number'|| typeName=='boolean') {
				throw new TypeError('invalid xml name');
			}
			//@todo: typeName == 'object' && ... etc here (avoid Language.is)
			if (name is QName) {
				return name;
			}
			
			var str:String = name.toString();
			if(parseInt(str,10).toString() == name)
				throw new TypeError("invalid element name");
			
			if(str.indexOf("@") == 0)
				return toAttributeName(name);

			return new QName(str);
		}
		
		/**
		 * Returns a string representation of the XML object.
		 *
		 * @return
		 *
		 */
		public function toXMLString():String{
			return _toXMLString();
		}
		
		/**
		 *
		 * @royaleignorecoercion XML
		 */
		private function _toXMLString(indentLevel:int=0,ancestors:Array=null):String
		{
			/*
				Given an XML object x and an optional argument AncestorNamespaces and an optional argument IndentLevel, ToXMLString converts it to an XML encoded string s by taking the following steps:
				1. Let s be the empty string
				2. If IndentLevel was not provided, Let IndentLevel = 0
				3. If (XML.prettyPrinting == true)
				  a. For i = 0 to IndentLevel-1, let s be the result of concatenating s and the space <SP> character
				4. If x.[[Class]] == "text",
				  a. If (XML.prettyPrinting == true)
				    i. Let v be the result of removing all the leading and trailing XMLWhitespace characters from x.[[Value]]
				    ii. Return the result of concatenating s and EscapeElementValue(v)
				  b. Else
				    i. Return EscapeElementValue(x.[[Value]])
				5. If x.[[Class]] == "attribute", return the result of concatenating s and EscapeAttributeValue(x.[[Value]])
				6. If x.[[Class]] == "comment", return the result of concatenating s, the string "<!--", x.[[Value]] and the string "-->"
				7. If x.[[Class]] == "processing-instruction", return the result of concatenating s, the string "<?", x.[[Name]].localName, the space <SP> character, x.[[Value]] and the string "?>"
				8. If AncestorNamespaces was not provided, let AncestorNamespaces = { }
				9. Let namespaceDeclarations = { }
				10. For each ns in x.[[InScopeNamespaces]]
				  a. If there is no ans ∈ AncestorNamespaces, such that ans.uri == ns.uri and ans.prefix == ns.prefix
				    i. Let ns1 be a copy of ns
				    ii. Let namespaceDeclarations = namespaceDeclarations ∪ { ns1 } NOTE implementations may also exclude unused namespace declarations from namespaceDeclarations
				11. For each name in the set of names consisting of x.[[Name]] and the name of each attribute in x.[[Attributes]]
				  a. Let namespace be a copy of the result of calling [[GetNamespace]] on name with argument (AncestorNamespaces ∪ namespaceDeclarations)
				  b. If (namespace.prefix == undefined),
				    i. Let namespace.prefix be an arbitrary implementation defined namespace prefix, such that there is no ns2 ∈ (AncestorNamespaces ∪ namespaceDeclarations) with namespace.prefix == ns2.prefix
				    ii. Note: implementations should prefer the empty string as the implementation defined prefix if it is not already used in the set (AncestorNamespaces ∪ namespaceDeclarations)
				    iii. Let namespaceDeclarations = namespaceDeclarations ∪ { namespace }
				12. Let s be the result of concatenating s and the string "<"
				13. If namespace.prefix is not the empty string,
				  a. Let s be the result of concatenating s, namespace.prefix and the string ":"
				14. Let s be the result of concatenating s and x.[[Name]].localName
				15. Let attrAndNamespaces = x.[[Attributes]] ∪ namespaceDeclarations
				16. For each an in attrAndNamespaces
				  a. Let s be the result of concatenating s and the space <SP> character
				  b. If Type(an) is XML and an.[[Class]] == "attribute"
				    i. Let ans be a copy of the result of calling [[GetNamespace]] on a.[[Name]] with argument AncestorNamespaces
				    ii. If (ans.prefix == undefined),
				      1. Let ans.prefix be an arbitrary implementation defined namespace prefix, such that there is no ns2 ∈ (AncestorNamespaces ∪ namespaceDeclarations) with ans.prefix == ns2.prefix
				      2. If there is no ns2 ∈ (AncestorNamespaces ∪ namespaceDeclarations), such that ns2.uri == ans.uri and ns2.prefix == ans.prefix
				        a. Let namespaceDeclarations = namespaceDeclarations ∪ { ans }
				    iii. If ans.prefix is not the empty string
				      1. Let s be the result of concatenating s, namespace.prefix and the string ":"
				    iv. Let s be the result of concatenating s and a.[[Name]].localName
				  c. Else
				    i. Let s be the result of concatenating s and the string "xmlns"
				    ii. If (an.prefix == undefined),
				      1. Let an.prefix be an arbitrary implementation defined namespace prefix, such that there is no ns2 ∈ (AncestorNamespaces ∪ namespaceDeclarations) with an.prefix == ns2.prefix
				    iii. If an.prefix is not the empty string
				      1. Let s be the result of concatenating s, the string ":" and an.prefix
				  d. Let s be the result of concatenating s, the string "=" and a double-quote character (i.e. Unicode codepoint \u0022)
				  e. If an.[[Class]] == "attribute"
				    i. Let s be the result of concatenating s and EscapeAttributeValue(an.[[Value]])
				  f. Else
				    i. Let s be the result of concatenating s and EscapeAttributeValue(an.uri)
				  g. Let s be the result of concatenating s and a double-quote character (i.e. Unicode codepoint \u0022)
				17. If x.[[Length]] == 0
				  a. Let s be the result of concatenating s and "/>"
				  b. Return s
				18. Let s be the result of concatenating s and the string ">"
				19. Let indentChildren = ((x.[[Length]] > 1) or (x.[[Length]] == 1 and x[0].[[Class]] is not equal to "text"))
				20. If (XML.prettyPrinting == true and indentChildren == true)
				  a. Let nextIndentLevel = IndentLevel + XML.PrettyIndent.
				21. Else
				  a. Let nextIndentLevel = 0
				22. For i = 0 to x.[[Length]]-1
				  a. If (XML.prettyPrinting == true and indentChildren == true)
				    i. Let s be the result of concatenating s and a LineTerminator
				  b. Let child = ToXMLString (x[i], (AncestorNamespaces ∪ namespaceDeclarations), nextIndentLevel)
				  c. Let s be the result of concatenating s and child
				23. If (XML.prettyPrinting == true and indentChildren == true),
				  a. Let s be the result of concatenating s and a LineTerminator
				  b. For i = 0 to IndentLevel, let s be the result of concatenating s and a space <SP> character
				24. Let s be the result of concatenating s and the string "</"
				25. If namespace.prefix is not the empty string
				  a. Let s be the result of concatenating s, namespace.prefix and the string ":"
				26. Let s be the result of concatenating s, x.[[Name]].localName and the string ">"
				27. Return s
				NOTE Implementations may also preserve insignificant whitespace (e.g., inside and between element tags) and attribute quoting conventions in ToXMLString().
			*/
			var i:int;
			var len:int;
			var ns:Namespace;
			var strArr:Array = [];
			indentLevel = isNaN(indentLevel) ? 0 : indentLevel;
			var indentArr:Array = [];
			for(i=0;i<indentLevel;i++)
				indentArr.push(_indentStr);
			
			var indent:String = indentArr.join("");
			const nodeType:String = getNodeRef();
			if(nodeType == TEXT) //4.
			{
				if(prettyPrinting)
				{
					var v:String = trimXMLWhitespace(_value);
					if (v.indexOf('<![CDATA[') == 0) {
						return indent + v;
					}
					return indent + escapeElementValue(v);
				}
				if (_value.indexOf('<![CDATA[') == 0)
					return _value;
				return escapeElementValue(_value);
			}
			if(nodeType == ATTRIBUTE)
				return indent + escapeAttributeValue(_value);
			
			if(nodeType == COMMENT)
				return indent + "<!--" +  _value + "-->";
			
			if(nodeType == PROCESSING_INSTRUCTION)
				return indent + "<?" + name().localName + " " + _value + "?>";
			
			// We excluded the other types, so it's a normal element
			// step 8.
			
			var inScopeNS:Array;
			//ancestors
			if(!ancestors) {
				ancestors = [];
				//this has thee effect of matching AVM behavior which is slightly off spec, see here:
				// https://github.com/adobe/avmplus/blob/master/core/XMLObject.cpp#L1207
				inScopeNS = inScopeNamespaces();
			} else inScopeNS = _namespaces? _namespaces : [];
			
			var myQName:QName = _name;
			var declarations:Array;
			
			if (ancestors.length == 0) {
				declarations = inScopeNS;
			} else {
				declarations = [];
				len = inScopeNS.length;//namespaceLength();
				for(i=0;i<len;i++)
				{
					if(!namespaceInArray(inScopeNS[i],ancestors))
						declarations.push(new Namespace(inScopeNS[i]));
				}
			}
			
			//11
			len = attributeLength();
			for(i=0;i<len;i++)
			{
				ns = new Namespace(_attributes[i].name().getNamespace(declarations.concat(ancestors)));
				if(ns.prefix === null)
				{
					//@todo Note step 11.b.i and 11.b.ii empty string is preferred *only* if it is not already used in the set
					ns.setPrefix("");
					declarations.push(ns);
				}
			}
			//favour the default namespace prefix as '' if it is defined with a prefix elsewhere there twice.
			ns = new Namespace(myQName.getNamespace(declarations.concat(ancestors)));
			if(ns.prefix === null)
			{
				//@todo Note step 11.b.i and 11.b.ii empty string is preferred *only* if it is not already used in the set
				ns.setPrefix("");
				declarations.push(ns);
			}
			if(XML.prettyPrinting && indentLevel > 0)
			{
				strArr.push(new Array(indentLevel + 1).join(_indentStr));
			}
			strArr.push("<");
			if(ns.prefix)
				strArr.push(ns.prefix+":");
			strArr.push(myQName.localName);
			
			//attributes and namespace declarations... (15-16)
			len = attributeLength();
			for(i=0;i<len;i++)
			{
				strArr.push(" ");
				var aName:QName = _attributes[i].name();
				var ans:Namespace = aName.getNamespace(declarations.concat(ancestors));
				if(ans.prefix)
				{
					strArr.push(ans.prefix);
					strArr.push(":");
				}
				strArr.push(aName.localName);
				strArr.push('="');
				strArr.push(escapeAttributeValue(_attributes[i].getValue()));
				strArr.push('"');
			}
			// see 15. namespace declarations is after
			for(i=0;i<declarations.length;i++)
			{
				var decVal:String = escapeAttributeValue(declarations[i].uri);
				if(decVal)
				{
					strArr.push(" xmlns");
					if(declarations[i].prefix)
					{
						strArr.push(":");
						strArr.push(declarations[i].prefix);
					}
					strArr.push('="');
					strArr.push(decVal);
					strArr.push('"');
				}
			}
			
			// now write elements or close the tag if none exist
			len = childrenLength();
			if(len == 0)
			{
				strArr.push("/>");
				return strArr.join("");
			}
			strArr.push(">");
			var indentChildren:Boolean = len > 1 || (len == 1 && (_children[0] as XML).getNodeRef() != TEXT);
			var nextIndentLevel:int;
			if(XML.prettyPrinting && indentChildren)
				nextIndentLevel = indentLevel + 1;
			else
				nextIndentLevel = 0;
			for(i=0;i<len;i++)
			{
				//
				if(XML.prettyPrinting && indentChildren)
					strArr.push("\n");
				strArr.push(XML(_children[i])._toXMLString(nextIndentLevel,declarations.concat(ancestors)));
			}
			if(XML.prettyPrinting && indentChildren)
			{
				strArr.push("\n");
				if (indentLevel > 0)
					strArr.push(new Array(indentLevel + 1).join(_indentStr));
			}
			strArr.push("</");
			if(ns.prefix)
			{
				strArr.push(ns.prefix);
				strArr.push(":");
			}
			strArr.push(myQName.localName);
			strArr.push(">");
			
			return strArr.join("");
		}
		
		/**
		 * Returns the XML object.
		 *
		 * @return
		 *
		 */
		override public function valueOf():*
		{
			var str:String = this.toString();
			if(str == "")
				return str;
			var num:Number = Number(str);
			if("" + num == str){
				return  num;
			}
			return str;
		}
		
		////////////////////////////////////////////////////////////////
		///
		///
		/// METHODS to allow XML to behave as if it's a string or number
		///
		///
		////////////////////////////////////////////////////////////////
		
		public function charAt(index:Number):String
		{
			return s().charAt(index);
		}
		public function charCodeAt(index:Number):Number
		{
			return s().charCodeAt(index);
		}
		public function codePointAt(pos:Number):Number
		{
			return s().codePointAt(pos);
		}
/*
		public function concat(... args):Array
		{
			return s().concat(args);
		}
*/

		public function indexOf(searchValue:String,fromIndex:Number=0):Number
		{
			return s().indexOf(searchValue,fromIndex);
		}
		public function lastIndexOf(searchValue:String,fromIndex:Number=0):Number
		{
			return s().lastIndexOf(searchValue,fromIndex);
		}
		public function localeCompare(compareString:String,locales:*=undefined, options:*=undefined):Number
		{
			return s().localeCompare(compareString,locales,options);
		}
		public function match(regexp:*):Array
		{
			return s().match(regexp);
		}
		/*
        Moved this logic (partially) into the other replace method
        
                public function replace(regexp:*,withStr:*):String
                {
                    return s().replace(regexp,withStr);
                }
        */
		public function search(regexp:*):Number
		{
			return s().search(regexp);
		}
		public function slice(beginSlice:Number, endSlice:*=undefined):String
		{
			return s()["slice"](beginSlice,endSlice);
		}
		public function split(separator:*=undefined,limit:*=undefined):Array
		{
			return s()["split"](separator,limit);
		}
		public function substr(start:Number, length:*=undefined):String
		{
			return s()["substr"](start,length);
		}
		public function substring(indexStart:Number, indexEnd:*=undefined):String
		{
			return s()["substring"](indexStart,indexEnd);
		}
		public function toLocaleLowerCase():String
		{
			return s().toLocaleLowerCase();
		}
		public function toLocaleUpperCase():String
		{
			return s().toLocaleUpperCase();
		}
		public function toLowerCase():String
		{
			return s().toLowerCase();
		}
		public function toUpperCase():String
		{
			return s().toUpperCase();
		}
		public function trim():String
		{
			return s().trim();
		}
		
		// Number methods
		
		/**
		 * @royaleignorecoercion Number
		 */
		public function toExponential(fractionDigits:*=undefined):Number
		{
			return v()["toExponential"](fractionDigits) as Number;
		}
		/**
		 * @royaleignorecoercion Number
		 */
		public function toFixed(digits:int=0):Number
		{
			return v().toFixed(digits) as Number;
		}
		/**
		 * @royaleignorecoercion Number
		 */
		public function toPrecision(precision:*=undefined):Number
		{
			return v()["toPrecision"](precision) as Number;
		}
		private function s():String
		{
			return this.toString();
		}
		private function v():Number
		{
			return Number(s());
		}
	}
}
