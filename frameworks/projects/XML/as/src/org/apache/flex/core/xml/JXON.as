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
package org.apache.flex.core.xml
{
	public class JXON implements IJXON
	{
		public function JXON(xml:String)
		{
			
		}
		public function isText():Boolean
		{
			return false;
		}
		

		private var _appliedNamespace:JXONNamespace;

		public function get appliedNamespace():JXONNamespace
		{
			return _appliedNamespace;
		}

		public function set appliedNamespace(value:JXONNamespace):void
		{
			_appliedNamespace = value;
		}
		
		private var _namespaces:Array;
		private var _uriLookup:Object;
		private function get uriLookup():Object{
			if(!_uriLookup)
				_uriLookup = {};
			return _uriLookup;
		}
		private var _prefixLookup:Object
		private function get prefixLookup():Object{
			if(!_prefixLookup)
				_prefixLookup = {};
			return _prefixLookup;
		}

		/**
		 * Adds a namespace to the set of in-scope namespaces for the XML object.
		 *  
		 * @param ns
		 * 
		 */
		public function addNamespace(ns:JXONNamespace):void
		{
			//throw an error?
			if(prefixLookup[ns.prefix])
				return;
			
			if(uriLookup[ns.uri])
				return;
			
			prefixLookup[ns.prefix] = ns;
			uriLookup[ns.uri] = ns;
			_namespaces.push(ns);
		}
		
		/**
		 * Appends the given child to the end of the XML object's properties.
		 *  
		 * @param child
		 * @return 
		 * 
		 */
		public function appendChild(child:IJXON):IJXON
		{
			return null;
		}
		
		/**
		 * Returns the XML value of the attribute that has the name matching the attributeName parameter.
		 * 
		 * @param attributeName
		 * @return 
		 * 
		 */
		public function attribute(attributeName:*):JXONList
		{
			return null;
		}
		
		private var _attributes:Array;

		/**
		 * Returns a list of attribute values for the given XML object.
		 * 
		 * @return 
		 * 
		 */
		public function get attributes():JXONList
		{
			return null;
		}
		
		/**
		 * Lists the children of an XML object with a specific property name.
		 *  
		 * @param propertyName
		 * @return 
		 * 
		 */
		public function child(propertyName:Object):JXONList
		{
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
			//TODO
			return 0;
		}
		
		private var _children:JXONList;
		
		/**
		 * Lists the children of the XML object in the sequence in which they appear.
		 *  
		 * @return 
		 * 
		 */
		public function get children():JXONList
		{
			return _children;
		}
		
		//comments():XMLList include?
		//Lists the properties of the XML object that contain XML comments.
		
		/**
		 * Compares the XML object against the given value parameter.
		 *  
		 * @param value
		 * @return 
		 * 
		 */
		public function contains(value:JXON):Boolean
		{
			//TODO
			return true;
		}
		
		/**
		 * Returns a copy of the given XML object.
		 * 
		 * @return 
		 * 
		 */
		public function copy():JXON
		{
			return null;
		}
		
		/**
		 * Returns an object with the following properties set to the default values: 
		 * ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * 
		 * @return 
		 * 
		 */
		static public function defaultSettings():Object
		{
			return {};
		}
		
		/**
		 * Returns all descendants (children, grandchildren, great-grandchildren, and so on) of the XML object that have the given name parameter.
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function descendants(name:Object = null):JXONList
		{
			return null;
		}
		
		/**
		 * Lists the elements of an XML object.
		 *  
		 * @param name
		 * @return 
		 * 
		 */
		public function elements(name:Object = null):JXONList
		{
			return null;
		}
		
		/**
		 * filters XML content based on logic in the callback function
		 * @param callback
		 * @param thisObject
		 * @return 
		 * 
		 */
		public function filter(callback:Function, thisObject:* = null):JXONList
		{
			return null;
		}
		
		/**
		 * Checks to see whether the XML object contains complex content.
		 *  
		 * @return 
		 * 
		 */
		public function hasComplexContent():Boolean
		{
			return true;
		}
		
		/**
		 * Checks to see whether the XML object contains simple content.
		 * 
		 * @return 
		 * 
		 */
		public function hasSimpleContent():Boolean
		{
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
			
		}
		
		/**
		 * For XML objects, this method always returns the integer 1.
		 * 
		 * @return 
		 * 
		 */
		public function get length():int
		{
			return 1;
		}
		
		/**
		 * Gives the local name portion of the qualified name of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function get localName():Object
		{
			return null;
		}
		/**
		 * Changes the local name of the XML object to the given name parameter.
		 * 
		 * @param name
		 * 
		 */
		public function set localName(name:String):void
		{
			
		}
		/**
		 * Gives the qualified name for the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function get name():Object
		{
			return null;
		}
		
		/**
		 * Sets the name of the XML object to the given qualified name or attribute name.
		 * 
		 * @param name
		 * 
		 */
		public function set name(name:String):void
		{
			
		}
		
		/**
		 * If no parameter is provided, gives the namespace associated with the qualified name of this XML object.
		 * @param prefix
		 * @return 
		 * 
		 */
		public function xmlNamespace(prefix:String = null):*
		{
			
		}
		
		/**
		 * Lists namespace declarations associated with the XML object in the context of its parent.
		 * 
		 * @return 
		 * 
		 */
		public function get namespaceDeclarations():Array
		{
			return null;
		}
		
		/**
		 * Specifies the type of node: text, comment, processing-instruction, attribute, or element.
		 * 
		 * @return 
		 * 
		 */
		public function get nodeKind():String
		{
			return "element";
		}
		
		/**
		 * For the XML object and all descendant XML objects, merges adjacent text nodes and eliminates empty text nodes.
		 * 
		 * @return 
		 * 
		 */
		public function normalize():JXON
		{
			return null;
		}
		
		private var _parent:*;

		public function set parent(value:*):void
		{
			_parent = value;
		}

		/**
		 * Returns the parent of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function get parent():*
		{
			return _parent;
		}
		
		/**
		 * Inserts a copy of the provided child object into the XML element before any existing XML properties for that element.
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function prependChild(value:Object):JXON
		{
			return null;
		}
		
		/**
		 * If a name parameter is provided, lists all the children of the XML object that contain processing instructions with that name.
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public function processingInstructions(name:String = ""):JXONList
		{
			return null;
		}
		
		/**
		 * Removes the given namespace for this object and all descendants.
		 * 
		 * @param ns
		 * @return 
		 * 
		 */
		public function removeNamespace(ns:Namespace):JXON
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
		public function replace(propertyName:Object, value:JXON):JXON
		{
			return null;
		}
		
		/**
		 * Replaces the child properties of the XML object with the specified set of XML properties, provided in the value parameter.
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function setChildren(value:JXONList):JXON
		{
			return null;
		}
		
		
		/**
		 * Sets the namespace associated with the XML object.
		 * 
		 * @param ns
		 * 
		 */
		public function setNamespace(ns:JXONNamespace):void
		{
			
		}
		
		/**
		 * Sets values for the following XML properties:
		 * ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * 
		 * @param rest
		 * 
		 */
		static public function setSettings(... rest):void
		{
			
		}
		
		/**
		 * Retrieves the following properties:
		 * ignoreComments, ignoreProcessingInstructions, ignoreWhitespace, prettyIndent, and prettyPrinting.
		 * 
		 * @return 
		 * 
		 */
		static public function getSettings():Object
		{
			return null;
		}
		
		/**
		 * Returns an XMLNodeList object of all XML properties of the XML object that represent XML text nodes.
		 * 
		 * @return 
		 * 
		 */
		public function get text():JXONList
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
			
		}
		
		/**
		 * Returns a string representation of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function toString():String
		{
			return "";
		}
		
		/**
		 * Returns a string representation of the XML object.
		 * 
		 * @return 
		 * 
		 */
		public function toXMLString():String
		{
			return "";
		}
	}
}