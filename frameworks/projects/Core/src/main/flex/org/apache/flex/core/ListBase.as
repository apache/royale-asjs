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
	import org.apache.flex.core.IMXMLDocument;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.states.State;
	import org.apache.flex.utils.MXMLDataInterpreter;
    
    /**
     *  The ListBase class is the base class for most lists
     *  in FlexJS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ListBase extends UIBase implements IContentViewHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ListBase()
		{
			super();
            
			_strandChildren = new ListBaseStrandChildren(this);
		}
		
		private var _strandChildren:ListBaseStrandChildren;
		
		/**
		 * @private
		 */
		public function get strandChildren():IParent
		{
			return _strandChildren;
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $numElements():int
		{
			return super.numElements();
		}
		
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementIndex(c:IChild):int
		{
			return super.getElementIndex(c);
		}
		
		/**
		 * @private
         * @suppress {undefinedNames}
		 * Support strandChildren.
		 */
		public function $getElementAt(index:int):IChild
		{
			return super.getElementAt(index);
		}

    }
}
