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
						if(idx >= _xmlArray.length)
							append(newValue);
						else
							replaceChildAt(idx,newValue);
					},
					enumerable: true,
					configurable: true
				}
			);
		}
		
		public function append(child:XML):void
		{
			_xmlArray[_xmlArray.length] = child;
			addIndex(_xmlArray.length);
			do//while false
			{
				if(!_targetObject)
					break;
				if(!_targetProperty)
				{
					_targetObject.appendChild(child);
					break;
				}
				var objToAppend:XMLList = _targetObject.child(_targetProperty);
				if(!objToAppend.length())
				{
					_targetObject.appendChild(child);
					break;
				}
				_targetObject.insertChildAfter(objToAppend[objToAppend.length()-1],child);
			}while(false);
		}

		public function appendChild(child:XML):XML
		{
			if(isSingle())
				return _xmlArray[0].appendChild(child);
			return null;
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
			var propNum:Number = parseInt(propertyName,10);
			if(propNum.toString() == propertyName)
			{
				if(propNum >= 0 && propNum < _xmlArray.length)
				{
					retVal.append(_xmlArray[propNum]);
					retVal.targetObject = _xmlArray[propNum];
				}
				return retVal;
			}

			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
			{
				var list:XMLList = _xmlArray[i].child(propertyName);
				if(list.length())
					retVal.concat(list);
			}
			return retVal;
		}

		public function childIndex():int
		{
			if(isSingle())
				return _xmlArray[0].childIndex();

			throw new Error("childIndex can only be called on an XMLList with one item.");
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
				newList.append(list);
				list = newList;
			}
			if(!(list is XMLList))
				throw new TypeError("invalid type");

			var item:XML;
			//work-around for FLEX-35070
			var len:int = list.length();
			var i:int=0;
			while(i<len)
				append(list[i++]);

//			var xmlList:XMLList = list;
//			for each(item in xmlList)
//				append(item);
				
			return this;
		}
		
		/**
		 * Checks whether the XMLList object contains an XML object that is equal to the given value parameter.
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function contains(value:*):Boolean
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
				retVal.append(_xmlArray[i].copy());
			
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

		public function elementNames():Array
		{
			var retVal:Array = [];
			var i:int=0;
			var len:int = _xmlArray.length;
			while(i<len)
				retVal.push(i++);
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
		public function filter(callback:Function):XMLList
		{
			var list:XMLList = new XMLList();
			for(var i:int = 0;i<_xmlArray.length;i++)
			{
				if(callback(_xmlArray[i]))
					list.append(_xmlArray[i]);
			}
			list.targetObject = _targetObject;
			list.targetProperty = _targetProperty;
			return list;
		}
		
		public function hasComplexContent():Boolean
		{
			//what to do with multiple nodes? If anything is complex, we return true.
			if(isEmpty())
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
			if(isEmpty())
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
		
		public function name():QName
		{
			if(isSingle())
				return _xmlArray[0].name();
			return null;
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
			if(isEmpty())
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

		public function plus(rightHand:*):*
		{
			/*
				Semantics
				The production AdditiveExpression : AdditiveExpression + MultiplicativeExpression is evaluated as follows:
				
				1. Let a be the result of evalutating AdditiveExpression
				2. Let left = GetValue(a)
				3. Let m be the result of evaluating MultiplicativeExpression
				4. Let right = GetValue(m)
				5. If (Type(left) ∈ {XML, XMLList}) and (Type(right) ∈ {XML, XMLList})
				  a. Let list be a new XMLList
				  b. Call the [[Append]] method of list with argument x
				  c. Call the [[Append]] method of list with argument y
				  d. Return list
				6. Let pLeft = ToPrimitive(left)
				7. Let pRight = ToPrimitive(right)
				8. If Type(pLeft) is String or Type(pRight) is String
				  a. Return the result of concatenating ToString(pLeft) and ToString(pRight)
				9. Else
				  a. Apply the addition operation to ToNumber(pLeft) and ToNumber(pRight) and return the result. See ECMAScript Edition 3, section 11.6.3 for details.
			*/
			if(rightHand is XML || rightHand is XMLList)
			{
				var list:XMLList = new XMLList();
				list.concat(this);
				list.concat(rightHand);
				if(rightHand is XML)
					list.targetObject = rightHand;
				else{
					list.targetObject = rightHand.targetObject;
					list.targetProperty = rightHand.targetProperty;
				}
				return list;
			}
			if(rightHand is String)
				return this.toString() + rightHand;
			if(rightHand is Number && isNaN(rightHand))
				return NaN;
			if(isNaN(Number( this.toString() )) || isNaN(Number( rightHand.toString() )))
				return this.toString() + rightHand.toString();
			return Number(this.toString()) + rightHand;
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
					retVal.append(_xmlArray[i]);
				}
				else if(name == _xmlArray[i].localName)
					retVal.append(_xmlArray[i]);
			}
			return retVal;
		}

		public function removeChild(child:*):void
		{
			var i:int;
			var len:int;
			if(child is String)
			{
				var propNum:Number = parseInt(child,10);
				if(propNum.toString() == child)
				{
					removeChildAt(propNum);
				}
				else if (isSingle())
				{
					_xmlArray[0].removeChild(child);
				}
				return;
			}

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
						if(child.hasAncestor(_targetObject))
							child.parent().removeChild(child);
					}
				}
			}
		}

		public function removeChildAt(idx:int):void
		{
			if(idx >= 0 && idx < _xmlArray.length)
			{
				var child:XML = _xmlArray[idx];
				_xmlArray.splice(idx,1);
				if(child.hasAncestor(_targetObject))
					child.parent().removeChild(child);
			}
		}
		private function replaceChildAt(idx:int,child:*):void
		{
			var i:int;
			var childToReplace:XML = _xmlArray[idx];
			if(childToReplace && _targetObject)
			{
				_targetObject.replaceChildAt(childToReplace.childIndex(),child);
			}
			if(child is XML)
			{
				_xmlArray[idx] = child;
			}
			else if(child is XMLList)
			{
				var len:int = child.length();
				for(i=0;i<len;i++)
				{
					// replace the first one and add each additonal one.
					if(i==0)
						_xmlArray[idx] = child[i];
					else
						_xmlArray.splice(idx+i,0,child[i]);
				}
			}
			// add indexes as necessary
			while(idx++ < _xmlArray.length)
			{
				if(!this.hasOwnProperty(idx))
					addIndex(idx);
			}
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
		
		public function setAttribute(attr:*,value:String):void
		{
			var len:int = _xmlArray.length;
			for (var i:int=0;i<len;i++)
				_xmlArray[i].setAttribute(attr,value);

		}
		public function hasAncestor(obj:*):Boolean
		{
			if(isSingle())
				return _xmlArray[0].hasAncestor(obj);

			return false;
		}
		public function insertChildAfter(child1:XML, child2:XML):XML
		{
			if(isSingle())
				return _xmlArray[0].insertChildAfter(child1,child2);

			return null;
		}
		public function insertChildBefore(child1:XML, child2:XML):XML
		{
			if(isSingle())
				return _xmlArray[0].insertChildAfter(child1,child2);

			return null;
		}

		public function namespace(prefix:String = null):*
		{
			if(isSingle())
				return _xmlArray[0].namespace(prefix);

			return null;
		}
		public function nodeKind():String
		{
			if(isSingle())
				return _xmlArray[0].nodeKind();

			return null;
		}

		public function removeNamespace(ns:*):XML
		{
			if(isSingle())
				return _xmlArray[0].removeNamespace(ns);

			return null;
		}
		public function replace(propertyName:Object, value:*):*
		{
			if(isSingle())
				return _xmlArray[0].replace(propertyName,value);
		}
		public function setChild(elementName:*, elements:Object):void
		{
			if(isSingle())
				_xmlArray[0].setChild(elementName,elements);

		}

		public function setParent(parent:XML):void
		{
			if(isSingle())
				_xmlArray[0].setParent(parent);

		}

		public function setChildren(value:Object):XML
		{
			if(isSingle())
				return _xmlArray[0].setChildren(value);

			return null;
		}
	
		public function setLocalName(name:String):void
		{
			if(isSingle())
				_xmlArray[0].setLocalName(name);
		}
 	 	public function setName(name:String):void
 	 	{
 	 		if(isSingle())
				_xmlArray[0].setName(name);
 	 	}
 	 	
		public function setNamespace(ns:Namespace):void
		{
			if(isSingle())
				_xmlArray[0].setNamespace(ns);
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
			return retVal.join("\n");
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
			return retVal.join("\n");
		}
		
		/**
		 * Returns the XMLList object.
		 * 
		 * @return 
		 * 
		 */
		override public function valueOf():*
		{
			if(isEmpty())
				return "";
			if(isSingle())
				return _xmlArray[0].valueOf();

			return this.toString();
		}

		////////////////////////////////////////////////////////////////
		///
		///
		/// METHODS to allow XML to behave as if it's a string or number
		/// 
		///
		////////////////////////////////////////////////////////////////
		
		public function anchor(name:String):String
		{
			return isSingle() ? _xmlArray[0].anchor(name) : "";
		}
		public function charAt(index:Number):String
		{
			return isSingle() ? _xmlArray[0].charAt(index) : "";
		}
		public function charCodeAt(index:Number):Number
		{
			return isSingle() ? _xmlArray[0].charCodeAt(index) : -1;
		}
		public function codePointAt(pos:Number):Number
		{
			return isSingle() ? _xmlArray[0].codePointAt(pos): -1;
		}
/*
		public function concat(... args):Array
		{
			return isSingle() ? _xmlArray[0].concat(args) : null;
		}
*/

		public function indexOf(searchValue:String,fromIndex:Number=0):Number
		{
			return isSingle() ? _xmlArray[0].indexOf(searchValue,fromIndex) : -1;
		}
		public function lastIndexOf(searchValue:String,fromIndex:Number=0):Number
		{
			return isSingle() ? _xmlArray[0].lastIndexOf(searchValue,fromIndex) : -1;
		}
		public function localeCompare(compareString:String,locales:*=undefined, options:*=undefined):Number
		{
			return isSingle() ? _xmlArray[0].localeCompare(compareString,locales,options) : NaN;
		}
		public function match(regexp:*):Array
		{
			return isSingle() ? _xmlArray[0].match(regexp) : null;
		}
/*
		public function replace(regexp:*,withStr:*):String
		{
			return isSingle() ? _xmlArray[0].replace(regexp,withStr) : null;
		}
*/
		public function search(regexp:*):Number
		{
			return isSingle() ? _xmlArray[0].search(regexp) : -1;
		}
		public function slice(beginSlice:Number, endSlice:*=undefined):String
		{
			return isSingle() ? _xmlArray[0].slice(beginSlice,endSlice) : null;
		}
		public function split(separator:*=undefined,limit:*=undefined):Array
		{
			return isSingle() ? _xmlArray[0].split(separator,limit) : null;
		}
		public function substr(start:Number, length:*=undefined):String
		{
			return isSingle() ? _xmlArray[0].substr(start,length) : null;
		}
		public function substring(indexStart:Number, indexEnd:*=undefined):String
		{
			return isSingle() ? _xmlArray[0].substring(indexStart,indexEnd) :null;
		}
		public function toLocaleLowerCase():String
		{
			return isSingle() ? _xmlArray[0].toLocaleLowerCase() : null;
		}
		public function toLocaleUpperCase():String
		{
			return isSingle() ? _xmlArray[0].toLocaleUpperCase() : null;
		}
		public function toLowerCase():String
		{
			return isSingle() ? _xmlArray[0].toLowerCase() : null;
		}
		public function toUpperCase():String
		{
			return isSingle() ? _xmlArray[0].toUpperCase() : null;
		}
		public function trim():String
		{
			return isSingle() ? _xmlArray[0].trim() : null;
		}

		// Number methods
		
		
		public function toExponential(fractionDigits:*=undefined):Number
		{
			return isSingle() ? _xmlArray[0].toExponential(fractionDigits) : NaN;
		}
		public function toFixed(digits:*=undefined):Number
		{
			return isSingle() ? _xmlArray[0].toFixed(digits) : NaN;
		}
		public function toPrecision(precision:*=undefined):Number
		{
			return isSingle() ? _xmlArray[0].toPrecision(precision) : NaN;
		}
		private function isEmpty():Boolean
		{
			return _xmlArray.length == 0;
		}
		private function isSingle():Boolean
		{
			return _xmlArray.length == 1;
		}
	}
}

