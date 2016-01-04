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
		
		/**
		 * [static] Determines the amount of indentation applied by the toString() and toXMLString() methods when the XML.prettyPrinting property is set to true.
		 * 
		 */
		static public var prettyIndent:int = 2;
		
		/**
		 * [static] Determines whether the toString() and toXMLString() methods normalize white space characters between some tags.
		 * 
		 */
		static public var prettyPrinting:Boolean = true;
		
		static private function fromNode(node:Element):XML
		{
			// returns an XML object from an existing node without the need to parse the XML.
			
		}

		public function XML(xml:String)
		{
			var parser:DOMParser = new DOMParser();
			_parentDocument = parser.parseFromString(xml, "application/xml");
			_node = _parentDocument.childNodes[0];
			//need to deal with errors https://bugzilla.mozilla.org/show_bug.cgi?id=45566
			
			// get rid of nodes we do not want 

			//loop through the child nodes and build XML obejcts for each.

		}
		
		private var _doc:Document;
		private var _children:Array;
		private var _attributes:Array;
		private var _processingInstructions:Array;
		private var _collection:HTMLCollection;
		private var _nodeList:NodeList;
		private var _parentDocument:Document;
		private var _node:Element;
		private var _parentXML:XML;
		private var _name:*;
		private var _value:String;


		public function getNode():Element
		{
			return _node;
		}
		
		public function getDocument():Document
		{
			return _parentDocument;
		}

		public function setDocument(doc:Document)
		{
			if(_parentDocument != doc)
			{
				if(_node.parentElement)
					_node.parentElement.removeChild(_node);
				//I think just using importNode on the top level node with deep set to true if enough.
				if(doc)
					_node = doc.importNode(_node,true);
				_parentDocument = doc;
			}
		}
		/**
		 * Adds a namespace to the set of in-scope namespaces for the XML object.
		 *
		 * @param ns
		 * @return 
		 * 	
		 */
		public function addNamespace(ns:Object):XML
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
			return null;
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
			child.setDocument(_parentDocument);
			child.setParent(this);
			
			_children.push(child);
			_node.appendChild(child.getNode());

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
			return null;
		}
		
		/**
		 * Returns a list of attribute values for the given XML object.
		 *
		 * @return 
		 * 
		 */
		public function attributes():XMLList
		{
			return null;
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
			return null;
		}
		
		/**
		 * Identifies the zero-indexed position of this XML object within the context of its parent.
		 *
		 * @return 
		 * 
		 */
		public function childIndex():int
		{
			return -1;
		}
		
		/**
		 * Lists the children of the XML object in the sequence in which they appear.
		 *
		 * @return 
		 * 
		 */
		public function children():XMLList
		{
			return null;
		}
		
		/**
		 * Lists the properties of the XML object that contain XML comments.
		 *
		 * @return 
		 * 
		 */
		public function comments():XMLList
		{
			return null;
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
			return null;
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
			return null;
		}
		
		/**
		 * [static] Returns an object with the following properties set to the default values: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * @return 
		 * 
		 */
		static public function defaultSettings():Object
		{
			return null;
		}
		
		/**
		 * Returns all descendants (children, grandchildren, great-grandchildren, and so on) of the XML object that have the given name parameter.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function descendants(name:Object = *):XMLList
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
			return null;
		}
		
		/**
		 * Lists the elements of an XML object.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function elements(name:Object = *):XMLList
		{
			return null;
		}

		public function equals(xml:XML):Boolean
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
		}
		
		/**
		 * Checks to see whether the XML object contains complex content.
		 * 
		 * @return 
		 * 
		 */
		public function hasComplexContent():Boolean
		{
			return false
		}

		public function hasOwnProperty():Boolean
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
		}
				
		/**
		 * Checks to see whether the XML object contains simple content.
		 * 
		 * @return 
		 * 
		 */
		public function hasSimpleContent():Boolean
		{
			return false;
		}
		
		/**
		 * Lists the namespaces for the XML object, based on the object's parent.
		 * 
		 * @return 
		 * 
		 */
		public function inScopeNamespaces():Array
		{
			return null;
		}
		
		/**
		 * Inserts the given child2 parameter after the child1 parameter in this XML object and returns the resulting object.
		 * 
		 * @param child1
		 * @param child2
		 * @return 
		 * 
		 */
		public function insertChildAfter(child1:Object, child2:Object):*
		{
			return null;
		}
		
		/**
		 * Inserts the given child2 parameter before the child1 parameter in this XML object and returns the resulting object.
		 * 
		 * @param child1
		 * @param child2
		 * @return 
		 * 
		 */
		public function insertChildBefore(child1:Object, child2:Object):*
		{
			return null;
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
			return null;
		}
		
		/**
		 * Gives the qualified name for the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function name():Object
		{
			return null;
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
			return null;
		}
		
		private var _nodeKind:String;
		/**
		 * Specifies the type of node: text, comment, processing-instruction, attribute, or element.
		 * @return 
		 * 
		 */
		public function nodeKind():String
		{
			return null;
		}
		
		/**
		 * For the XML object and all descendant XML objects, merges adjacent text nodes and eliminates empty text nodes.
		 * 
		 * @return 
		 * 
		 */
		public function normalize():XML
		{
			return null;
		}
		
		/**
		 * Returns the parent of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function parent():*
		{
			return null;
		}
		
		/**
		 * Inserts the provided child object into the XML element before any existing XML properties for that element.
		 * @param value
		 * @return 
		 * 
		 */
		public function prependChild(child:XML):XML
		{
			child.setDocument(_parentDocument);
			child.setParent(this);
			
			_children.unshift(child);
			if(_node.childNodes.length)
				_node.insertBefore(child.getNode(), _node.childNodes[0]);
			else
				_node.appendChild(child.getNode());
			
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
			child.setParent(null);
			
			var removed:XML;
			var idx:int = child.childIndex;
			removed = _children.splice(idx,1);
			var n:Element = removed.getNode();
			n.parentElement.removeChild(n);
			return removed;
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
		}

		/**
		 * Removes the given namespace for this object and all descendants.
		 * 
		 * @param ns
		 * @return 
		 * 
		 */
		public function removeNamespace(ns:Namespace):XML
		{
			return null;
		}
		
		/**
		 * Replaces the properties specified by the propertyName parameter with the given value parameter.
		 * 
		 * @param propertyName
		 * @param value
		 * @return 
		 * 
		 */
		public function replace(propertyName:Object, value:XML):XML
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
			return null;
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
					// remove the nodes
					// remove the children
					// adjust the childIndexes
				}
				var curChild = _children[childIdx];
				// Now add them in.
				for each(chld in elements)
				{
				
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
			if(value is XML)
			{
				var list:XMLList = new XMLList();
				list[0] = value;
				value = list;
			}
			if(elements is XMLList)
			{
				// remove all existing elements
				var chldrn:XMLList = this.child(elementName);
				var childIdx:int = children().length() -1;
				if(chldrn.length())
					childIdx = chldrn[0].childIndex();
				
				len = chldrn.length() -1;
				for (i= len; i >= 0;  i--)
				{
					// remove the nodes
					// remove the children
					// adjust the childIndexes
				}
				var curChild = _children[childIdx];
				// Now add them in.
				for each(chld in elements)
				{
					
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
			
		}
		
		/**
		 * Sets the name of the XML object to the given qualified name or attribute name.
		 * 
		 * @param name
		 * 
		 */
		public function setName(name:String):void
		{
			
		}
		
		/**
		 * Sets the namespace associated with the XML object.
		 * 
		 * @param ns
		 * 
		 */
		public function setNamespace(ns:Namespace):void
		{
			
		}
		
		public function setParent(parent:XML):void
		{
			_parentXML = parent;
		}
		
		/**
		 * [static] Sets values for the following XML properties: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * @param rest
		 * 
		 */
		static public function setSettings(... rest):void
		{

		}
		
		/**
		 * [static] Retrieves the following properties: ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * 
		 * @return 
		 * 
		 */
		static public function settings():Object
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
			return null;
		}
		
		/**
		 * Provides an overridable method for customizing the JSON encoding of values in an XML object.
		 * 
		 * @param k
		 * @return 
		 * 
		 */
		public function toJSON(k:String):*
		{
			return this.name();
		}
		
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
		
		/**
		 * Returns a string representation of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function toXMLString():String
		{
			return null;
		}
		
		/**
		 * Returns the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function valueOf():XML
		{
			return this;
		}
		
		private function removeAllNodeChildren():void
		{
			var lastChild = _node.lastChild;
			while(lastChild)
			{
				_node.removeChild(lastChild);
				lastChild = _node.lastChild;
			}
		}
	}
}
}
