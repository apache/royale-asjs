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
package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.IChild;
	import org.apache.flex.events.IEventDispatcher;

	import org.apache.flex.html.Panel;

	COMPILE::JS {
		import org.apache.flex.core.WrappedHTMLElement;
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
     *  @productversion FlexJS 0.0
     */
	public class PanelLayoutProxy implements ILayoutView
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
		 *  @flexjsignorecoercion org.apache.flex.html.Panel
		 *  The width of the bounding box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get width():Number {
			return (host as Panel).width;
		}

		/**
		 *  @flexjsignorecoercion org.apache.flex.html.Panel
		 * The height of the bounding box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get height():Number {
			return (host as Panel).height;
		}

		/**
		 *  @flexjsignorecoercion org.apache.flex.html.Panel
		 *  The number of elements in the parent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get numElements():int
		{
			return (host as Panel).$numElements;
		}

		/**
		 *  @flexjsignorecoercion org.apache.flex.html.Panel
		 *  Get a component from the parent.
		 *
		 *  @param c The index of the subcomponent.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getElementAt(index:int):IChild
		{
			return (host as Panel).$getElementAt(index);
		}

		/**
		 * @flexjsignorecoercion org.apache.flex.html.Panel
		 */
		COMPILE::JS
		public function get somethingelse():WrappedHTMLElement
		{
			return (host as Panel).element;
		}

		/**
		 * @flexjsignorecoercion org.apache.flex.html.Panel
		 */
		COMPILE::JS
		public function get element():WrappedHTMLElement
		{
			return (host as Panel).element;
		}

		/**
		 *  @flexjsignorecoercion org.apache.flex.html.Panel
		 *  The display style is used for both visible
		 *  and layout so is managed as a special case.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		COMPILE::JS
		public function setDisplayStyleForLayout(value:String):void
		{
			(host as Panel).setDisplayStyleForLayout(value);
		}

	}
}
