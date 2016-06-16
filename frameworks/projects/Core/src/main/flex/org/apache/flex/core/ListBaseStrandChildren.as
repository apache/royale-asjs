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
package org.apache.flex.core
{
	
    
    /**
     *  The ListBaseStrandChildren exists so that Lists are compatible with
	 *  the ListView/ContainerView beads. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ListBaseStrandChildren implements IParent
	{
        /**
         *  Constructor.
         *  
         *  @flexjsignorecoercion org.apache.flex.core.ListBase
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ListBaseStrandChildren(owner:IParent)
		{
			super();
			
			this.owner = owner as ListBase;
		}
		
		public var owner:ListBase;
		
		/**
		 *  @private
		 */
		public function get numElements():int
		{
			return owner.$numElements();
		}
		
		/**
		 *  @private
		 */
		public function addElement(c:IVisualElement):IVisualElement
		{
			owner.$addElement(c);
			return c;
		}
		
		/**
		 *  @private
		 */
		public function addElementAt(c:IVisualElement, index:int):IVisualElement
		{
			owner.$addElementAt(c, index);
			return c;
		}
		
		/**
		 *  @private
		 */
		public function removeElement(c:IVisualElement):IVisualElement
		{
			owner.$removeElement(c);
			return c;
		}
		
		/**
		 *  @private
		 */
		public function getElementIndex(c:IVisualElement):int
		{
			return owner.$getElementIndex(c);
		}
		
		/**
		 *  @private
		 */
		public function getElementAt(index:int):IVisualElement
		{
			return owner.$getElementAt(index);
		}
    }
}
