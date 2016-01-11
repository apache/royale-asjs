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
     *  The ContainerBaseStrandChildren class the provides a way for advanced
	 *  components to place children directly into the strand unlike the
	 *  addElement() APIs on the Container which place children into the contentView.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ContainerBaseStrandChildren implements IParent
	{
        /**
         *  Constructor.
         *  
         *  @flexjsignorecoercion org.apache.flex.core.ContainerBase
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ContainerBaseStrandChildren(owner:IParent)
		{
			super();
			
			this.owner = owner as ContainerBase;
		}
		
		public var owner:ContainerBase;
		
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
		public function addElement(c:Object, dispatchEvent:Boolean = true):void
		{
			owner.$addElement(c, dispatchEvent);
		}
		
		/**
		 *  @private
		 */
		public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
		{
			owner.$addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 *  @private
		 */
		public function removeElement(c:Object, dispatchEvent:Boolean = true):void
		{
			owner.$removeElement(c, dispatchEvent);
		}
		
		/**
		 *  @private
		 */
		public function getElementIndex(c:Object):int
		{
			return owner.$getElementIndex(c);
		}
		
		/**
		 *  @private
		 */
		public function getElementAt(index:int):Object
		{
			return owner.$getElementAt(index);
		}
    }
}