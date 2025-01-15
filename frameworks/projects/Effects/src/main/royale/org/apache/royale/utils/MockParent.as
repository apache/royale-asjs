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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IParent;
	import org.apache.royale.events.EventDispatcher;

	public class MockParent extends EventDispatcher implements IParent
	{
		public function MockParent()
		{
			super();
		}

		public function addElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean=true):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function getElementAt(index:int):IChild
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getElementIndex(c:IChild):int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function get numElements():int
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function removeElement(c:IChild, dispatchEvent:Boolean=true):void
		{
			// TODO Auto Generated method stub
			
		}
		
		//----------------------------------
		//  document
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the enabled property.
		 */
		private var _mxmlDocument:Object;

		/**
		 *  A reference to the document object associated with this UITextField object. 
		 *  A document object is an Object at the top of the hierarchy of a Flex application, 
		 *  MXML component, or AS component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get mxmlDocument():Object
		{
			return _mxmlDocument;
		}

		/**
		 *  @private
		 */
		public function set mxmlDocument(value:Object):void
		{
			_mxmlDocument = value;
		}
		
	}
}
