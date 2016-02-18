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
COMPILE::JS
{
package
{
	public class XML
	{
		/*
		 * Dealing with namespaces:
		 * If the name is qualified, it has a prefix. Otherwise, the prefix is null.
		 * Additionally, it has a namespaceURI. Otherwise the namespaceURI is null.
		 * the prefix together with the namespaceURI form a QName
		*/

		static private var defaultNamespace:Namespace;

		static public function setDefaultNamespace(ns:*):void
		{
			if(!ns)
				defaultNamespace = null;
			else
				ns = new Namespace(ns);
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
			var outArr:Array = [];
			var arr:Array = value.split("");
			var len:int = arr.length;
			for(var i:int=0;i<len;i++)
			{
				switch(arr[i])
				{
					case "<":
						outArr[i] = "&lt;";
						break;
					case "&":
						outArr[i] = "&amp;";
						break;
					case "\u000A":
						outArr[i] = "&#xA;";
						break;
					case "\u000D":
						outArr[i] = "&#xD;";
						break;
					case "\u0009":
						outArr[i] = "&#x9;";
						break;
					default:
						outArr[i] = arr[i];
						break;
				}
			}
			return outArr.join("");
		}

		static private function escapeElementValue(value:String):String
		{
			var i:int;
			var outArr:Array = [];
			var arr:Array = value.split("");
			for(i=0;i<arr.length;i++)
			{
				switch(arr[i])
				{
					case "<":
						outArr[i] = "&lt;";
						break;
					case ">":
						outArr[i] = "&gt;";
						break;
					case "&":
						outArr[i] = "&amp;";
						break;
					default:
						outArr[i] = arr[i];
						break;
				}
			}
			return outArr.join("");
		}

		static private function insertAttribute(att:Attr,parent:XML):XML
		{
			var xml:XML = new XML();
			xml.setParent(parent);
			xml.setNodeKind("attribute");
			xml.setName(att.name);
			xml.setValue(att.value);
			parent.addChild(xml);
			return xml;
		}
		static private function iterateElement(node:Element,xml:XML):void
		{
			var i:int;
			// add attributes
			for(i=0;i<node.attributes.length;i++)
			{
				insertAttribute(node.attributes[i],xml);
			}
			// loop through childNodes which will be one of:
			// text, cdata, processing instrution or comment and add them as children of the element
			for(i=0;i<node.childNodes.length;i++)
			{
				var child:XML = fromNode(node.childNodes[i]);
				xml.addChild(child);
			}
		}
		/**
		* returns an XML object from an existing node without the need to parse the XML.
		* The new XML object is not normalized
		*/
		static private function fromNode(node:Element):XML
		{
			var xml:XML;
			var i:int;
			var data:* = node.nodeValue;
			switch(node.nodeType)
			{
				case 1:
					//ELEMENT_NODE
					xml = new XML();
					xml.setNodeKind("element");
					iterateElement(node,xml);
					break;
				//case 2:break;// ATTRIBUTE_NODE (handled separately)
				case 3:
					//TEXT_NODE
					xml = new XML();
					xml.setNodeKind("text");
					xml.setValue(data);
					break;
				case 4:
					//CDATA_SECTION_NODE
					xml = new XML();
					xml.setNodeKind("text");
					data = "<![CDATA[" + data + "]]>";
					xml.setValue(data);
					break;
				//case 5:break;//ENTITY_REFERENCE_NODE
				//case 6:break;//ENTITY_NODE
				case 7:
					//PROCESSING_INSTRUCTION_NODE
					xml = new XML();
					xml.setNodeKind("processing-instruction");
					xml.setName(node.nodeName);
					xml.setValue(data);
					break;
				case 8:
					//COMMENT_NODE
					xml = new XML();
					xml.setNodeKind("comment");
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

		static private function namespaceInArray(ns:Namespace,arr:Array,considerPrefix:Boolean=true):Boolean
		{
			if(!arr)
				return false;
			var i:int;
			for(i=0;i<arr.length;i++)
			{
				if(ns.uri == arr[i].uri)
				{
					if(!considerPrefix)
						return true;
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


		public function XML(xml:String = null)
		{
			if(xml)
			{
				var parser:DOMParser = new DOMParser();
				// get error namespace. It's different in different browsers.
				var errorNS:String = parser.parseFromString('<', 'application/xml').getElementsByTagName("parsererror")[0].namespaceURI;

				var doc:Document = parser.parseFromString(xml, "application/xml");

				//check for errors
				if(doc.getElementsByTagNameNS(errorNS, 'parsererror').length > 0)
        			throw new Error('XML parse error');
    			
				var node:Element = doc.childNodes[0];
				_version = doc.xmlVersion;
				_encoding = doc.xmlEncoding;
				iterateElement(node,this);
				normalize();
			}
			//need to deal with errors https://bugzilla.mozilla.org/show_bug.cgi?id=45566
			
			// get rid of nodes we do not want 

			//loop through the child nodes and build XML obejcts for each.
			
			Object.defineProperty(this,"0",
				{
					"get": function():* { return this; },
					"set": function(newValue:*):void {
					},
					enumerable: true,
					configurable: true
				}
			);
			
		}
		
		private var _children:Array;
		private var _attributes:Array = [];
		private var _processingInstructions:Array;
		private var _parent:XML;
		private var _value:String;
		private var _version:String;
		private var _encoding:String;
		private var _appliedNamespace:Namespace;
		private var _namespaces:Array = [];


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
			
			child.setParent(this);
			if(child.nodeKind() =="attribute")
			{
				if(!_attributes)
					_attributes = [];

				_attributes.push(child);

			}
			else
				_children.push(child);
			normalize();
		}


		/**
		 * Adds a namespace to the set of in-scope namespaces for the XML object.
		 *
		 * @param ns
		 * @return 
		 * 	
		 */
		public function addNamespace(ns:Namespace):XML
		{
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "attribute")
				return this;
			if(ns.prefix === null)
				return this;
			if(ns.prefix == "" && name().uri == "")
				return this;
			var match:Namespace = null;
			var i:int;
			for(i=0;i<_namespaces.length;i++)
			{
				if(_namespaces[i].prefix == ns.prefix)
				{
					match = _namespaces[i];
					break;
				}
			}
			if(match)
				_namespaces[i] = ns;
			else
				_namespaces.push(ns);

			if(ns.prefix == name().prefix)
				name().prefix = null;

			for(i=0;i<_attributes.length;i++)
			{
				if(_attributes[i].name().prefix == ns.prefix)
					_attributes[i].name().prefix = null;
			}
			return this;
		}
		
		/**
		 * Appends the given child to the end of the XML object's properties.
		 *
		 * @param child
		 * @return 
		 * 
		 */
		public function appendChild(child:XML):XML
		{
			/*
				[[Insert]] (P, V)
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
			child.setParent(this);
			
			_children.push(child);
			normalize();
			return child;
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
			for(i=0;i<_attributes.length;i++)
			{
				if(_attributes[i].name().matches(attributeName))
					list.appendChild(_attributes[i]);
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
			for(i=0;i<_attributes.length;i++)
				list.appendChild(_attributes[i]);

			list.targetObject = this;
			return list;
		}
		
		/**
		 * Lists the children of an XML object.
		 *
		 * @param propertyName
		 * @return 
		 * 
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
			var list:XMLList = new XMLList();
			if(parseInt(name,10).toString() == propertyName)
			{
				if(propertyName != "0")
					return null;
				list.appendChild(this);
				list.targetObject = this;
				return list;
			}
			propertyName = toXMLName(propertyName);
			if(propertyName.isAttribute)
			{
				for(i=0;i<_attributes.length;i++)
				{
					if(propertyName.matches(_attributes[i].name()))
						list.appendChild(_attributes[i]);
				}
			}
			else
			{
				for(i=0;i<_children.length;i++)
				{
					if(propertyName.matches(_children[i].name()))
						list.appendChild(_children[i]);
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
			for(i=0;i<_children.length;i++)
				list.appendChild(_children[i]);

			list.targetObject = this;
			return list;
		}
		
		/**
		 * Lists the properties of the XML object that contain XML comments.
		 *
		 * @return 
		 * 
		 */
		public function comments():XMLList
		{
			var i:int;
			var list:XMLList = new XMLList();
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "comment")
					list.appendChild(_children[i]);
			}
			list.targetObject = this;
			return list;
		}
		
		public function concat(list:*):XMLList
		{
			if(list is XML)
			{
				var newList:XMLList = new XMLList();
				newList.appendChild(list);
				list = newList;
			}
			if(!(list is XMLList))
				throw new TypeError("invalid type");

			var retVal:XMLList = new XMLList();
			retVal.appendChild(this);
			var item:XML;
			for each(item in list)
				retVal.appendChild(item);
				
			return retVal;
		}

		/**
		 * Compares the XML object against the given value parameter.
		 *
		 * @param value
		 * @return 
		 * 
		 */
		public function contains(value:XML):Boolean
		{
			return this.equals(value);
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
			xml.setNodeKind(_nodeKind);
			xml.setName(name());
			xml.setValue(_value);
			for(i-0;i<_namespaces.length;i++)
			{
				xml.addNamespace(new Namespace(_namespaces[i]));
			}
			//parent should be null by default
			for(i=0;i<_attributes.length;i++)
				xml.addChild(_attributes[i].copy());

			for(i=0;i<_children.length;i++)
				xml.addChild(_children[i].copy());
			
			return xml;
		}

		private function deleteChildAt(idx:int):void
		{
			if(idx < 0)
				return;
			if(idx >= _children.length)
				return;
			var child:XML = _children[idx];
			child.setParent(null);
			_children.splice(idx,1);
				_
		}
		
		/**
		 * Returns all descendants (children, grandchildren, great-grandchildren, and so on) of the XML object that have the given name parameter.
		 * 
		 * @param name
		 * @return 
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
			name = toXMLName(name);
			var list:XMLList = new XMLList();
			if(name.isAttribute)
			{
				for(i=0;i<_attributes.length;i++)
				{
					if(name.matches(_attributes[i].name()))
						list.appendChild(_attributes[i]);
				}
				for(i=0;i<_children.length;i++)
				{
					if(_children[i].nodeKind() == "element")
					{
						if(name.matches(_children[i].name()))
							list.appendChild(_children[i]);

						list.concat(_children[i].descendants());
					} 
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
		 */
		public function elements(name:Object = "*"):XMLList
		{
			name = toXMLName(name);
			var i:int;
			var list:XMLList = new XMLList();
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "element" && name.matches(_children[i].name()))
					list.appendChild(_children[i]);
			}

			list.targetObject = this;
			list.targetProperty = name;
			return list;

			return null;
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
			if(!(xml is XML))
				return false;

			if(xml.nodeKind() != _nodeKind)
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
			}
			var i:int;
			for(i=0;i<_attributes.length;i++)
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
			return _attributes ? _attributes.slice() : [];
		}
		public function getChildrenArray():Array
		{
			return _children ? _children.slice() : [];
		}

		public function getIndexOf(elem:XML):int
		{
			return _children.indexOf(elem);
		}
		
		private function getURI(prefix:String):String
		{
			var i:int;
			var namespaces:Array = getAncestorNamespaces(_namespaces);
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
		/**
		 * Checks to see whether the XML object contains complex content.
		 * 
		 * @return 
		 * 
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
			if(_nodeKind == "attribute" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "text")
				return false;
			var i:int;
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "element")
					return true;
			}
			return false;
		}

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
			for(i=0;i<_attributes.length;i++)
			{
				if(_attributes[i].name().matches(name))
					return true;
			}
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() != "element")
					continue;
				if(_children[i].name().matches(name))
					return true;
			}
			return false;
		}
				
		/**
		 * Checks to see whether the XML object contains simple content.
		 * 
		 * @return 
		 * 
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
			if(_nodeKind == "comment" || _nodeKind == "processing-instruction")
				return false;
			var i:int;
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "element")
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
			return _namespaces.slice();
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "attribute")
				return;
			if(!child)
				return;
			var parent:XML = child.parent();
			if(parent)
				parent.removeChild(child);
			child.setParent(this);
			_children.splice(idx,0,child);
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "attribute")
				return null;
			if(!child1)
			{
				insertChildAt(child2,0);
				return child2;
			}
			var idx:int = _children.indexOf(child1);
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "attribute")
				return null;
			if(!child1)
			{
				insertChildAt(child2,_children.length);
				return child2;
			}
			var idx:int = _children.indexOf(child1);
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
		public function localName():Object
		{
			return name().localName;
		}

		private var _name:QName;
		
		/**
		 * Gives the qualified name for the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function name():Object
		{
			if(!_name)
				_name = new QName();
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
			var i:int;
			if(prefix)
			{
				for(i=0;i<_namespaces.length;i++)
				{
					if(_namespaces[i].prefix == prefix)
						return _namespaces[i];
				}
				if(_parent)
					return _parent.namespace(prefix);
				return null;
			}
			//no prefix. get the namespace of our object
			if(_nodeKind == "text" || _nodeKind ==  "comment" || _nodeKind ==  "processing-instruction")
				return null;
			return name().getNamespace(namespaceDeclarations());
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
			var i:int;
			var retVal:Array = [];
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind ==  "attribute")
				return retVal;
			var declaredNS:Array = _namespaces.slice();
			var parent:XML = _parent;
			while(parent)
			{
				var parentNS:Array = parent.inScopeNamespaces();
				var idx:int;
				var pIdx:int;
				for(pIdx=0;i<parentNS.length;pIdx++)
				{
					var uri:String = parentNS[pIdx].uri;
					var prefix:String = parentNS[pIdx].prefix;
					for(idx=0;i<declaredNS.length;idx++)
					{
						if(declaredNS[idx].uri == uri && declaredNS[idx].prefix == prefix)
						{
							declaredNS.push(parentNS[pIdx]);
							break;
						}
					}
				}
				parent = parent.parent();
			}

			return declaredNS;
		}
		
		private var _nodeKind:String = "element";
		/**
		 * Specifies the type of node: text, comment, processing-instruction, attribute, or element.
		 * @return 
		 * 
		 */
		public function nodeKind():String
		{
			return _nodeKind;
		}
		
		/**
		 * For the XML object and all descendant XML objects, merges adjacent text nodes and eliminates empty text nodes.
		 * 
		 * @return 
		 * 
		 */
		public function normalize():XML
		{
			var len:int = _children.length-1;
			var lastChild:XML;
			for(var i:int=len;i>=0;i--)
			{
				var child:XML = _children[i];
				// can we have a null child?

				if(child.nodeKind() == "element")
				{
					child.normalize();
				}
				else if(child.nodeKind() == "text")
				{
					if(lastChild && lastChild.nodeKind() == "text")
					{
						child.setValue(child.text() + lastChild.text());
						deleteChildAt(i+1);
					}
					if(!child.text())
						deleteChildAt(i);
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
		
		/**
		 * Inserts the provided child object into the XML element before any existing XML properties for that element.
		 * @param value
		 * @return 
		 * 
		 */
		public function prependChild(child:XML):XML
		{
			child.setParent(this);
			
			_children.unshift(child);

			return child;
		}
		
		/**
		 * If a name parameter is provided, lists all the children of the XML object that contain processing instructions with that name.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function processingInstructions(name:String = "*"):XMLList
		{
			return null;
		}
		
		/**
		 * Removes the given chid for this object and returns the removed child.
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
			var removed:XML;
			if(!child)
				return false;
			if(!_attributes)
				return false;

			if(!(child is XML))
				return removeChildByName(child);
			
			if(child.nodeKind() == "attribute")
			{
				for(i=0;i<_attributes.length;i++)
				{
					if(child.equals(_attributes[i]))
					{
						removed = _attributes[i];
						removed.setParent(null);
						_attributes.splice(i,1);
						return true;
					}
				}
			}
			var idx:int = _children.indexOf(child);
			if(idx < 0)
				return false;
			removed = _children.splice(idx,1);
			child.setParent(null);
			return removed;
		}
		private function removeChildByName(name:*):Boolean
		{
			var i:int;
			name = toXMLName(name);
			var child:XML = null;
			var removedItem:Boolean = false;
			if(name.isAttribute)
			{
				if(!_attributes)
					return false;

				for(i=_attributes.length-1;i>=0;i--)
				{
					if(_attributes[i].name().matches(name))
					{
						child = _attributes[i];
						child.setParent(null);
						_attributes.splice(i,1);
						removedItem = true;
					}
				}
				return removedItem;
			}
			//QUESTION am I handling non-elements correctly?
			if(!_children)
				return false;
			for(i=_children.length-1;i>=0;i--)
			{
				if(_children[i].name().matches(name))
				{
					child = _children[i];
					child.setParent(null);
					_children.splice(i,1);
					removedItem = true;
				}
			}
			return removedItem;
		}
		public function removeChildAt(index:int):void
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
			throw new Error("Cannot call delete on XML");
		}

		/**
		 * Removes the given namespace for this object and all descendants.
		 * 
		 * @param ns
		 * @return 
		 * 
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind == "attribute")
				return this;
			if(!(ns is Namespace))
				ns = new Namespace(ns);
			if(ns == name().getNamespace(_namespaces))
				return this;
			for(i=0;i<_attributes.length;i++)
			{
				if(ns == _attributes[i].name().getNamespace(_namespaces))
					return this;
			}
			
			//
			for(i=_namespaces.length-1;i>=0;i--)
			{
				if(_namespaces[i].uri == ns.uri && _namespaces[i].prefix == ns.prefix)
					_namespaces.splice(i,1);
				else if(ns.prefix == null && _namespaces[i].uri == ns.uri)
					_namespaces.splice(i,1);
			}
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "element")
					_children[i].removeNamespace(ns);
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
		public function replace(propertyName:Object, value:*):XML
		{
			/*
				Semantics
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind ==  "attribute")
				return this;
			if(value === null || value === undefined)
				return this;
			if((value is XML) || (value is XMLList))
				value = value.copy();
			else
				value = value.toString();

			return null;
		}

		private function replaceChild(idx:int,v:*):void
		{
			/*
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
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction" || _nodeKind ==  "attribute")
				return;
			if(idx > _children.length)
				idx = _children.length;
			if(v is XML && v.nodeKind() != "attribute")
			{
				if(v.nodeKind() == "element" && (v==this || isAncestor(v)) )
					throw new TypeError("cannot assign parent xml as child");
				v.setParent(this);
				if(_children[idx])
					_children[idx].setParent(null);
				_children[idx] = v;
			}
			else if(v is XMLList)
			{
				//6.
				if(_children[idx])
					_children[idx].setParent(null);

			}
			else
			{
				//7. attribute?
			}
		}

		private function isAncestor(xml:XML):Boolean
		{
			var p:XML = parent();
			while(p)
			{
				if(p == xml)
					return true;
				p = p.parent();
			}
			return false;
		}

		public function setAttribute(attr:*,value:String):void
		{
			var i:int;
			if(!_attributes)
				_attributes = [];

			if(attr is XML)
			{
				if(attr.nodeKind() == "attribute")
				{
					for(i=0;i<_attributes.length;i++)
					{
						if(_attributes[i].name().equals(attr.name()))
						{
							_attributes[i].setValue(value);
							return;
						}
						//addChild(_att)
					}
					if(value)
						attr.setValue(value);
					addChild(attr);
				}
				return;

			}
			if(attr.indexOf("xmlns") == 0)
			{
				//it's a namespace declaration
				//TODO This does not seem right.
				var ns:Namespace = new Namespace(value.toString());
				if(attr.indexOf("xmlns:") == 0)// it has a prefix
					ns.prefix = attr.split(":")[1];
				this.addNamespace(ns);
			}
			else
			{
				//it's a regular attribute string
				//TODO use toXMLName or toAttributeName to convert attr and assing it

			}

		}
		/**
		 * Replaces the child properties of the XML object with the specified name with the specified XML or XMLList.
		 * This is primarily used to support dot notation assignment of XML.
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function setChild(elementName:*, elements:Object):void
		{
			
			/*
			 * 
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
			var len:int;
			var chld:XML;
			
			if(elements is XML)
			{
				var list:XMLList = new XMLList();
				list[0] = elements;
				elements = list;
			}
			if(elements is XMLList)
			{
				var chldrn:XMLList = this.child(elementName);
				var childIdx:int = children().length() -1;
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
				var curChild:XML = _children[childIdx];
				// Now add them in.
				len = elements.length();
				for(i=0;i<len;i++)
				{
					chld = elements[i];
					if(!curChild)
					{
						curChild = appendChild(chld);
					}
					else {
						curChild = insertChildAfter(curChild, chld);
					}
				}
			}
			//what to do if it's not XML or XMLList? Throw an error? Ignore?
			
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
				var curChild:XML = _children[childIdx];
				// Now add them in.
				len = value.length();
				for(i=0;i<len;i++)
				{
					chld = value[i];
					if(!curChild)
					{
						curChild = appendChild(chld);
					}
					else {
						curChild = insertChildAfter(curChild, chld);
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

			_name.localName = name;
		}
		
		/**
		 * Sets the name of the XML object to the given qualified name or attribute name.
		 * 
		 * @param name
		 * 
		 */
		public function setName(name:*):void
		{
			if(name is QName)
				_name = name;
			else
				_name = new QName(name);
		}
		
		/**
		 * Sets the namespace associated with the XML object.
		 * 
		 * @param ns
		 * 
		 */
		public function setNamespace(ns:Object):void
		{
			if(_nodeKind == "text" || _nodeKind == "comment" || _nodeKind == "processing-instruction")
				return;
			var ns2:Namespace = new Namespace(ns);
			_name = new QName(ns2,name());

			if(_nodeKind == "attribute")
			{
				_name.isAttribute = true;
				if(_parent == null)
					return;
				_parent.addNamespace(ns2);
			}
			if(_nodeKind == "element")
				addNamespace(ns2);
		}

		/**
		 * @private
		 * 
		 */
		public function setNodeKind(value:String):void
		{
			_nodeKind = value;
		}
		
		public function setParent(parent:XML):void
		{
			var oldParent:XML = _parent;
			_parent = parent;
			//assign first to prevent the possiblity of a recursive loop
			if(oldParent)
				_parent.removeChild(this);
		}

		public function setValue(value:String):void
		{
			_value = value;
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
			for(i=0;i<_children.length;i++)
			{
				if(_children[i].nodeKind() == "text")
					list.appendChild(_attributes[i]);
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
			// text, comment, processing-instruction, attribute, or element
			if(_nodeKind == "text" || _nodeKind == "attribute")
				return _value;
			if(_nodeKind == "comment")
				return "";
			if(_nodeKind == "processing-instruction")
				return "";
			return toXMLString();
		}

		private function toAttributeName(name:*):QName
		{
			var qname:QName;
			if(!name is QName)
			{
				name = name.toString();
				if(name.indexOf("@") > -1)
					name = name.substring(name.indexOf("@"));
			}
			qname = toXMLName(name);
			qname.isAttribute = true;
			return qname;
		}
		private function toXMLName(name:*):QName
		{
			var qname:QName;
			if(name.toString().indexOf("@") > -1)
				return toAttributeName(name);

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
			if(parseInt(name,10).toString() == name)
				throw new TypeError("invalid element name");

			if(!name is QName)
			{
				name = name.toString();
				if(name.indexOf(":") >= 0)
				{
					// Get the QName for prefix
					qname = new QName();
					qname.prefix = name.substring(0,name.indexOf(":"));
					qname.localName = name.substring(name.lastIndexOf(":")+1);
					//get the qname uri
					qname.uri = getURI(qname.prefix);
				}
				else
				{
					qname = new QName(name());
					if(!qname.uri && defaultNamespace)
					{
						qname = new QName(defaultNamespace);
					}
					qname.localName = name;
				}
			}
			else
			{
				qname  = new QName(name);
			}
			return qname;
		}
		
		/**
		 * Returns a string representation of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function toXMLString(indentLevel:int=0,ancestors:Array=null):String
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
			var ns:Namespace;
			var strArr:Array = [];

			var indentArr:Array = [];
			for(i=0;i<indentLevel;i++)
				indentArr.push(_indentStr);

			var indent:String = indentArr.join("");
			if(this.nodeKind() == "text")
			{
				if(prettyPrinting)
				{
					var v:String = trimXMLWhitespace(_value);
					return indent + escapeElementValue(v);
				}
				return escapeElementValue(_value);
			}
			if(this.nodeKind() == "attribute")
				return indent + escapeAttributeValue(_value);

			if(this.nodeKind() == "comment")
				return indent + "<!--" +  _value + "-->";

			if(this.nodeKind() == "processing-instruction")
				return indent + "<?" + name().localName + " " + _value + "?>";

			// We excluded the other types, so it's a normal element
			// step 8.
			//ancestors
			if(!ancestors)
				ancestors = [];

			var declarations:Array = [];
			for(i=0;i<_namespaces.length;i++)
			{
				if(!namespaceInArray(_namespaces[i],ancestors))
					declarations.push(new Namespace(_namespaces[i]));
			}
			//11
			for(i=0;i<_attributes.length;i++)
			{
				ns = new Namespace(_attributes[i].name().getNamespace(ancestors.concat(declarations)));
				if(ns.prefix === null)
				{
					ns.prefix = "";
					declarations.push(ns);
				}
			}
			ns = new Namespace(name().getNamespace(ancestors.concat(declarations)));
			if(ns.prefix === null)
			{
				ns.prefix = "";
				declarations.push(ns);
			}
			strArr.push("<");
			if(ns.prefix)
				strArr.push(ns.prefix+":");
			strArr.push(name().localName);

			//attributes and namespace declarations... (15-16)
			for(i=0;i<declarations.length;i++)
			{
				strArr.push(" xmlns");
				if(declarations[i].prefix)
				{
					strArr.push(":");
					strArr.push(declarations[i].prefix);
				}
				strArr.push('="');
				strArr.push(escapeAttributeValue(declarations[i].uri));
				strArr.push('"');

			}
			for(i=0;i<_attributes.length;i++)
			{
				strArr.push(" ");
				// the following seems to be the spec, but it does not make sense to me.
				//var ans:Namespace = _attributes[i].name().getNamespace(ancestors);
				var aName:QName = _attributes[i].name();
				var ans:Namespace = aName.getNamespace(ancestors.concat(declarations));
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
			// now write elements or close the tag if none exist
			if(_children.length == 0)
			{
				strArr.push("/>");
				return strArr.join("");
			}
			strArr.push(">");
			var indentChildren:Boolean = _children.length > 1 || (_children.length == 1 && _children[0].nodeKind() != "text");
			var nextIndentLevel:int;
			if(XML.prettyPrinting && indentChildren)
				nextIndentLevel = indentLevel + prettyIndent;
			else
				nextIndentLevel = 0;
			for(i=0;i<_children.length;i++)
			{
				//
				if(XML.prettyPrinting && indentChildren)
					strArr.push("\n");
				strArr.push(_children[i].toXMLString(nextIndentLevel,ancestors.concat(declarations)));
			}
			if(XML.prettyPrinting && indentChildren)
			{
				strArr.push("\n");
				strArr.push(new Array(indentLevel + 1).join(' '));
			}
			strArr.push("</");
			if(ns.prefix)
			{
				strArr.push(ns.prefix);
				strArr.push(":");
			}
			strArr.push(name().localName);
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
			return this;
		}
		
	}
}
}
