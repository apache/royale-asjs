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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
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
		 * Support strandChildren.
		 */
		public function $numElements():int
		{
			return super.numElements();
		}
		
		
		/**
		 * @private
		 * Support strandChildren.
		 */
		public function $addElement(c:Object, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 * Support strandChildren.
		 */
		public function $addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
		{
			super.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
		 * Support strandChildren.
		 */
		public function $removeElement(c:Object, dispatchEvent:Boolean = true):void
		{
			super.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 * Support strandChildren.
		 */
		public function $getElementIndex(c:Object):int
		{
			return super.getElementIndex(c);
		}
		
		/**
		 * @private
		 * Support strandChildren.
		 */
		public function $getElementAt(index:int):Object
		{
			return super.getElementAt(index);
		}

    }
}