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
	public class XMLList
	{
		public function XMLList()
		{
			addIndex(0);
		}
		private var _xmlArray:Array = [];
		/*
			9.2.1.2 [[Put]] (P, V)
			Overview
			The XMLList type overrides the internal [[Put]] method defined by the Object type. The XMLList [[Put]] method is used to modify or replace an XML object within the XMLList and the context of its parent. In addition, when the XMLList contains a single property with an XML object, the [[Put]] method is used to modify, replace, and insert properties or XML attributes of that value by name. The input argument P identifies which portion of the XMLList and associated XML objects will be affected and may be a numeric property name, an unqualified name for an XML attribute (distinguished from XML valued property names by a leading “@” symbol) or set of XML elements, a QName for a set of XML elements, an AttributeName for a set of XML attributes or the properties wildcard “*”. When the input argument P is an unqualified XML element name, it identifies XML elements in the default namespace. When the input argument P is an unqualified XML attribute name, it identifies XML attributes in no namespace. The input argument V may be a value of type XML, XMLList or any value that can be converted to a String with ToString().
			NOTE Unlike the internal Object [[Put]] method, the internal XMLList [[Put]] method is never used for modifying the set of methods associated with XMLList objects.
			Semantics
			When the [[Put]] method of an XMLList object x is called with property name P and value V, the following steps are taken:
			1. Let i = ToUint32(P)
			2. If ToString(i) == P
			  a. If x.[[TargetObject]] is not null
			    i. Let r be the result of calling the [[ResolveValue]] method of x.[[TargetObject]]
			    ii. If r == null, return
			  b. Else let r = null
			  c. If i is greater than or equal to x.[[Length]]
			    i. If Type(r) is XMLList
			      1. If r.[[Length]] is not equal to 1, return
			      2. Else let r = r[0]
			    ii. If r.[[Class]] is not equal to "element", return
			    iii. Create a new XML object y with y.[[Parent]] = r, y.[[Name]] = x.[[TargetProperty]], y.[[Attributes]] = {}, y.[[Length]] = 0
			    iv. If Type(x.[[TargetProperty]]) is AttributeName
			      1. Let attributeExists be the result of calling the [[Get]] method of r with argument y.[[Name]]
			      2. If (attributeExists.[[Length]] > 0), return
			      3. Let y.[[Class]] = "attribute"
			    v. Else if x.[[TargetProperty]] == null or x.[[TargetProperty]].localName == "*"
			      1. Let y.[[Name]] = null
			      2. Let y.[[Class]] = "text"
			    vi. Else let y.[[Class]] = "element"
			    vii. Let i = x.[[Length]]
			    viii. If (y.[[Class]] is not equal to "attribute")
			      1. If r is not null
			        a. If (i > 0)
			          i. Let j = 0
			          ii. While (j < r.[[Length]]-1) and (r[j] is not the same object as x[i-1])
			            1. Let j = j + 1
			        b. Else
			          i. Let j = r.[[Length]]-1
			        c. Call the [[Insert]] method of r with arguments ToString(j+1) and y
			      2. If Type(V) is XML, let y.[[Name]] = V.[[Name]]
			      3. Else if Type(V) is XMLList, let y.[[Name]] = V.[[TargetProperty]]
			    ix. Call the [[Append]] method of x with argument y
			  d. If (Type(V) ∉ {XML, XMLList}) or (V.[[Class]] ∈ {"text", "attribute"}), let V = ToString(V)
			  e. If x[i].[[Class]] == "attribute"
			    i. Let z = ToAttributeName(x[i].[[Name]])
			    ii. Call the [[Put]] method of x[i].[[Parent]] with arguments z and V
			    iii. Let attr be the result of calling [[Get]] on x[i].[[Parent]] with argument z
			    iv. Let x[i] = attr[0]
			  f. Else if Type(V) is XMLList
			    i. Create a shallow copy c of V
			    ii. Let parent = x[i].[[Parent]]
			    iii. If parent is not null
			      1. Let q be the property of parent, such that parent[q] is the same object as x[i]
			      2. Call the [[Replace]] method of parent with arguments q and c
			      3. For j = 0 to c.[[Length]]-1
			        a. Let c[j] = parent[ToUint32(q)+j]
			    iv. If c.[[Length]] == 0
			      1. For j = i + 1 to x.[[Length]] – 1, rename property j of x to ToString(j-1)
			    v. Else
			      1. For j = x.[[Length]]-1 downto i + 1, rename property j of x to ToString(j + c.[[Length]] - 1)
			    vi. For j = 0 to c.[[Length]]-1, let x[i + j] = c[j]
			    vii. Let x.[[Length]] = x.[[Length]] + c.[[Length]] - 1
			  g. Else if (Type(V) is XML) or (x[i].[[Class]] ∈ {"text", "comment", "processing-instruction"})
			    i. Let parent = x[i].[[Parent]]
			    ii. If parent is not null
			      1. Let q be the property of parent, such that parent[q] is the same object as x[i]
			      2. Call the [[Replace]] method of parent with arguments q and V
			      3. Let V = parent[q]
			    iii. If Type(V) is String
			      1. Create a new XML object t with t.[[Class]] = "text", t.[[Parent]] = x and t.[[Value]] = V
			      2. Let x[i] = t
			    iv. Else
			      1. Let x[i] = V
			  h. Else
			    i. Call the [[Put]] method of x[i] with arguments "*" and V
			3. Else if x.[[Length]] is less than or equal to 1
			  a. If x.[[Length]] == 0
			    i. Let r be the result of calling the [[ResolveValue]] method of x
			    ii. If (r == null) or (r.[[Length]] is not equal to 1), return
			    iii. Call the [[Append]] method of x with argument r
			  b. Call the [[Put]] method of x[0] with arguments P and V
			4. Return
		*/
		private function addIndex(idx:int):void
		{
			var idxStr:String = "" + idx;
			Object.defineProperty(this,idxStr,
				{
					"get": function():* { return _xmlArray[idx]; },
					"set": function(newValue:*):void {
						var i:int;
						if(newValue is XML)
						{
							_xmlArray[idx] = newValue;
						}
						else if(newValue is XMLList)
						{
							var len:int = newValue.length();
							for(i=0;i<len;i++)
							{
								// replace the first one and add each additonal one.
								if(i==0)
									_xmlArray[idx] = newValue[i];
								else
									_xmlArray.splice(idx+i,0,newValue[i]);
							}
						}
						// add indexes as necessary
						while(idx++ < _xmlArray.length)
						{
							if(!this.hasOwnProperty(idx))
								addIndex(idx);
						}
					},
					enumerable: true,
					configurable: true
				}
			);
		}
		
		public function appendChild(child:XML):void
		{
			addIndex(_xmlArray.length);
			_xmlArray[_xmlArray.length] = child;
		}
		
		/**
		 * Calls the attribute() method of each XML object and returns an XMLList object of the results.
		 * 
		 * @param attributeName
		 * @return 
		 * 
		 */
		public function attribute(attributeName:*):XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].attribute(attributeName);
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}
		/**
		 * Calls the attributes() method of each XML object and returns an XMLList object of attributes for each XML object.
		 * 
		 * @return 
		 * 
		 */
		public function attributes():XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].attributes();
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}
		/**
		 * Calls the child() method of each XML object and returns an XMLList object that contains the results in order.
		 * 
		 * @param propertyName
		 * @return 
		 * 
		 */
		public function child(propertyName:Object):XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].child(propertyName);
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}
		/**
		 * Calls the children() method of each XML object and returns an XMLList object that contains the results.
		 * 
		 * @return 
		 * 
		 */
		public function children():XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].children();
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}
		
		/**
		 * Calls the comments() method of each XML object and returns an XMLList of comments.
		 * @return 
		 * 
		 */
		public function comments():XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].comments();
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
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

			var item:XML;
			for each(item in list)
				appendChild(item);
				
			return this;
		}
		
		/**
		 * Checks whether the XMLList object contains an XML object that is equal to the given value parameter.
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function contains(value:XML):Boolean
		{
			
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				if(_xmlArray[i].contains(value))
					return true;
			}
			return false;
		}
		
		/**
		 * Returns a copy of the given XMLList object.
		 * 
		 * @return 
		 * 
		 */
		public function copy():XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
				retVal.appendChild(_xmlArray[i].copy());
			
			return retVal;
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
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].descendants(name);
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}
		
		/**
		 * Calls the elements() method of each XML object.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function elements(name:Object = "*"):XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].elements(name);
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}

		public function equals(list:*):Boolean
		{
			/*
				Overview
				The XMLList type adds the internal [[Equals]] method to the internal properties defined by the Object type.
				The XMLList [[Equals]] method is used to compare this XMLList object for content equality 
				with another XMLList object V or determine whether this XMLList object contains a single XML object that compares equal to V. 
				The [[Equals]] operator returns true if this XMLList object is considered equal to V 
				or contains only one XML object that is considered equal to V. Otherwise, it returns false. 
				Empty XMLList objects are considered equal to undefined. 
				The input argument V may be a value of type XMLList, XML, undefined or any value that can be converted to a String with ToString().
				
				Semantics
				When the [[Equals]] method of an XML object x is called with value V, the following steps are taken:
				1. If V == undefined and x.[[Length]] == 0, return true
				2. If Type(V) is XMLList
				  a. If x.[[Length]] is not equal to V.[[Length]], return false
				  b. For i = 0 to x.[[Length]]
				    i. If the result of the comparison x[i] == V[i] is false, return false
				  c. Return true
				3. Else if x.[[Length]] == 1
				  a. Return the result of the comparison x[0] == V
				4. Return false
			*/
			return false;
		}
		
		public function hasComplexContent():Boolean
		{
			//what to do with multiple nodes? If anything is complex, we return true.
			if(_xmlArray.length == 0)
				return false;
			var len:int = _xmlArray.length;
			for (var i:int=1;i<len;i++)
			{
				if(_xmlArray[i].hasComplexContent())
					return true;
			}
			return false;
		}

		override public function hasOwnProperty(propertyName:*):Boolean
		{
			/*
				Overview
				The XMLList type overrides the internal [[HasProperty]] method defined by the Object type. The XMLList [[HasProperty]] method is used to determine whether this XMLList object contains an XML element or attribute by its ordinal position or whether any of the objects contained in this XMLList object contains an XML element or attribute by its name. The input argument P may be a numeric property name, an unqualified name for an XML attribute (distinguished from the name of XML elements by a leading “@” symbol) or a set of XML elements, a QName for a set of XML elements, an AttributeName for a set of XML attributes, the properties wildcard “*” or the attributes wildcard “@*”. When the input argument P is an unqualified XML element name, it identifies XML elements in the default namespace. When the input argument P is an unqualified XML attribute name, it identifies XML attributes in no namespace.
				Semantics
				When the [[HasProperty]] method of an XMLList object x is called with property name P, the following steps are taken:
				1. If ToString(ToUint32(P)) == P
				a. Return (ToUint32(P) < x.[[Length]])
				2. For i = 0 to x.[[Length]]-1
				a. If x[i].[[Class]] == "element" and the result of calling the [[HasProperty]] method of x[i] with argument P == true, return true
				3. Return false			
			*/
			if(parseInt(propertyName,10).toString() == propertyName)
			{
				return parseInt(propertyName,10) < _xmlArray.length;
			}
			var len:int = _xmlArray.length;
			for (var i:int=1;i<len;i++)
			{
				if(_xmlArray[i].hasOwnProperty(propertyName))
					return true;
			}
			return false;
		}
		
		/**
		 * Checks whether the XMLList object contains simple content.
		 * 
		 * @return 
		 * 
		 */
		public function hasSimpleContent():Boolean
		{
			//what to do with multiple nodes? If anything is complex, we return false.
			if(_xmlArray.length == 0)
				return true;
			var len:int = _xmlArray.length;
			for (var i:int=1;i<len;i++)
			{
				if(_xmlArray[i].hasComplexContent())
					return false;
			}
			return true;
		}
		
		/**
		 * Returns the number of items in the XMLList.
		 * 
		 * @return 
		 * 
		 */
		public function length():int
		{
			return _xmlArray.length;
		}
		
		/**
		 * Merges adjacent text nodes and eliminates empty text nodes for each of the following:
		 * all text nodes in the XMLList, all the XML objects contained in the XMLList, and the descendants of all the XML objects in the XMLList.
		 * 
		 * @return 
		 * 
		 */
		public function normalize():XMLList
		{
			/*
			When the normalize method is called on an XMLList object list, the following steps are taken:
			1. Let i = 0
			2. While i < list.[[Length]]
			  a. If list[i].[[Class]] == "element"
			    i. Call the normalize method of list[i]
			    ii. Let i = i + 1
			  b. Else if list[i].[[Class]] == "text"
			    i. While ((i+1) < list.[[Length]]) and (list[i + 1].[[Class]] == "text")
			      1. Let list[i].[[Value]] be the result of concatenating list[i].[[Value]] and list[i + 1].[[Value]]
			      2. Call the [[Delete]] method of list with argument ToString(i + 1)
			    ii. If list[i].[[Value]].length == 0
			      1. Call the [[Delete]] method of list with argument ToString(i)
			    iii. Else
			      1. Let i = i + 1
			  c. Else
			    i. Let i = i + 1
			3. Return list
			*/
			return this;
		}
		
		/**
		 * Returns the parent of the XMLList object if all items in the XMLList object have the same parent.
		 * 
		 * @return 
		 * 
		 */
		public function parent():Object
		{
			if(_xmlArray.length == 0)
				return undefined;
			var retVal:XML = _xmlArray[0].parent();
			var len:int = _xmlArray.length;
			for (var i:int=1;i<len;i++)
			{
				if(_xmlArray[i].parent() != retVal)
					return undefined;
			}
			return retVal;
		}
		
		/**
		 * If a name parameter is provided, lists all the children of the XMLList object that contain processing instructions with that name.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function processingInstructions(name:String = "*"):XMLList
		{
			var retVal:XMLList = new XMLList();
			if(!name)
				return retVal;
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				if(_xmlArray[i].nodeKind() != "processing-instruction")
					continue;
				if(name == "*")
				{
					retVal.appendChild(_xmlArray[i]);
				}
				else if(name == _xmlArray[i].localName)
					retVal.appendChild(_xmlArray[i]);
			}
			return retVal;
		}

		public function removeChild(child:*):void
		{
			var i:int;
			var len:int;
			if(child is XMLList)
			{
				len = child.length();
				for(i=0;i<len;i++)
				{
					removeChild(child[i]);
				}
			}
			else if(child is XML)
			{
				len = _xmlArray.length-1;
				for(i=len; i >= 0; i--)
				{
					if(_xmlArray[i] == child)
					{
						_xmlArray.splice(i,1);
					}
				}
			}
		}

		public function removeChildAt(idx:int):void
		{
			if(idx >= 0 && idx < _xmlArray.length)
				_xmlArray.splice(idx,1);
		}

		private var _targetObject:*;
		/**
		 * @private
		 * 
		 * Internally used to store an associated XML or XMLList object which will be effected by operations
		 */
		public function set targetObject(value:*):void
		{
			_targetObject = value;
		}
		public function get targetObject():*
		{
			return _targetObject;
		}

		private var _targetProperty:*;
		/**
		 * @private
		 * 
		 * The name of a property that may be created in the targetObject when objects are added to an empty XMLList.
		 */
		public function set targetProperty(value:*):void
		{
			_targetProperty = value;
		}
		public function get targetProperty():*
		{
			return _targetProperty;
		}
		
		/**
		 * Calls the text() method of each XML object and returns an XMLList object that contains the results.
		 * 
		 * @return 
		 * 
		 */
		public function text():XMLList
		{
			var retVal:XMLList = new XMLList();
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].text();
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}

		/**
		 * Returns the string representation of this object, formatted according to locale-specific conventions.
		 * 
		 * @return 
		 * 
		 */
		override public function toLocaleString():String
		{
			var retVal:Array = [];
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var str:String = _xmlArray[i].toLocaleString();
				if(str)
					retVal.push(str);
			}
			return retVal.join("");
		}
		
		/**
		 * Returns a string representation of all the XML objects in an XMLList object.
		 * 
		 * @return 
		 * 
		 */
		public function toString():String
		{
			var retVal:Array = [];
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var str:String = _xmlArray[i].toString();
				if(str)
					retVal.push(str);
			}
			return retVal.join("");
		}
		
		/**
		 * Returns a string representation of all the XML objects in an XMLList object.
		 * 
		 * @return 
		 * 
		 */
		public function toXMLString():String
		{
			var retVal:Array = [];
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var str:String = _xmlArray[i].toXMLString();
				if(str)
					retVal.push(str);
			}
			return retVal.join("");
		}
		
		/**
		 * Returns the XMLList object.
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
