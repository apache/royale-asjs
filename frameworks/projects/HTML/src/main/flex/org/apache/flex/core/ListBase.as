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
	import org.apache.flex.core.IContainer;
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
	public class ListBase extends UIBase implements ILayoutParent, IParentIUIBase, IContainer
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
		}
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElement('div') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			
			positioner = element;
			
			return element;
		}
		
		/**
		 * Returns the ILayoutHost which is its view. From ILayoutParent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getLayoutHost():ILayoutHost
		{
			return view as ILayoutHost; 
		} 
		
		/**
		 * @private
		 */
		public function childrenAdded():void
		{
			dispatchEvent(new Event("childrenAdded"));
		}
		
		/**
		 * @private
		 * This is a hidden function used by ContainerView to insert the nested contentView
		 * into this outer shell.
		 */
		COMPILE::SWF
		public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			super.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.addElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.addElementAt(c, index, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function getElementIndex(c:IChild):int
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.getElementIndex(c);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			contentView.removeElement(c, dispatchEvent);
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function get numElements():int
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.numElements;
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		override public function getElementAt(index:int):IChild
		{
			var layoutHost:ILayoutHost = view as ILayoutHost;
			var contentView:IParent = layoutHost.contentView as IParent;
			return contentView.getElementAt(index);
		}

    }
}
