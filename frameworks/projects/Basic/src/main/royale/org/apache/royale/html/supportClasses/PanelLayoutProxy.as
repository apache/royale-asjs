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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainerBaseStrandChildrenHost;
    import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.IParent;
	import org.apache.royale.events.IEventDispatcher;

	COMPILE::JS {
		import org.apache.royale.core.WrappedHTMLElement;
	}

    /**
     *  The PanelLayoutProxy class is used by Panel in order for layouts to operate
	 *  on the Panel itself. If Panel were being used, its numElements, getElementAt, etc.
	 *  functions would actually redirect to its Container content. In order for a layout
	 *  to work on the Panel directly (its TitleBar, Container, and ControlBar children),
	 *  this proxy is used which will invoke the Panel's $numElements, $getElementAt, etc
	 *  functions.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class PanelLayoutProxy implements ILayoutView, IParent
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function PanelLayoutProxy(host:Object)
		{
			super();
			_host = host;
		}

		private var _host:Object;

		public function get host():Object
		{
			return _host;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  The width of the bounding box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get width():Number {
			return (host as UIBase).width;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 * The height of the bounding box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get height():Number {
			return (host as UIBase).height;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
		 *  The number of elements in the parent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get numElements():int
		{
			return (host as IContainerBaseStrandChildrenHost).$numElements;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
		 *  Get a component from the parent.
		 *
		 *  @param c The index of the subcomponent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getElementAt(index:int):IChild
		{
			return (host as IContainerBaseStrandChildrenHost).$getElementAt(index);
		}

        /**
         *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
         *  Gets the index of this subcomponent.
         * 
         *  @param c The subcomponent to add.
         *  @return The index (zero-based).
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getElementIndex(c:IChild):int
        {
            return (host as IContainerBaseStrandChildrenHost).$getElementIndex(c);
        }
        
        /**
         *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
         *  Add a component to the parent.
         * 
         *  @param c The subcomponent to add.
         *  @param dispatchEvent Whether to dispatch an event after adding the child.
         * 
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            (host as IContainerBaseStrandChildrenHost).$addElement(c);
        }
        
        /**
         *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
         *  Add a component to the parent.
         * 
         *  @param c The subcomponent to add.
         *  @param index The index where the subcomponent should be added.
         *  @param dispatchEvent Whether to dispatch an event after adding the child.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            return (host as IContainerBaseStrandChildrenHost).$addElementAt(c, index);
        }
        
        /**
         *  @royaleignorecoercion org.apache.royale.core.IContainerBaseStrandChildrenHost
         *  Remove a component from the parent.
         * 
         *  @param c The subcomponent to remove.
         *  @param dispatchEvent Whether to dispatch an event after removing the child.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            return (host as IContainerBaseStrandChildrenHost).$removeElement(c);
        }

		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		public function get element():WrappedHTMLElement
		{
			return (host as UIBase).element;
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  The display style is used for both visible
		 *  and layout so is managed as a special case.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function setDisplayStyleForLayout(value:String):void
		{
			(host as UIBase).setDisplayStyleForLayout(value);
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		public function get displayStyleForLayout():String
		{
			return (host as UIBase).displayStyleForLayout;
		}

	}
}
