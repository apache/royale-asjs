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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.jewel.supportClasses.INavigationRenderer;

	/**
	 *  The NavigationLinkItemRenderer defines the basic Item Renderer for a Jewel 
     *  Navigation List Component. It handles Objects with "label" and "href" data.
	 *  Extend this (you can do it in MXML) to support more data like for example: icon data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class NavigationLinkItemRenderer extends StyledMXMLItemRenderer implements INavigationRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function NavigationLinkItemRenderer()
		{
			super();

			typeNames = "jewel navigationlink";
		}

		// private var _href:String = "#";
        /**
         *  the navigation link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		// [Bindable('dataChange')]
		// public function get href():String
		// {
        //     return _href;   
		// }
		// public function set href(value:String):void
		// {
        //     _href = value;
		// }

		private var _text:String = "";

        /**
         *  The text of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		[Bindable('dataChange')]
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
             _text = value;
		}

		COMPILE::JS
        private var textNode:Text;

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 * 
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function set data(value:Object):void
		{
			if (value == null) {
				// _href = "#";
				_text = null;
				//super.data setter will dispatch dataChange
				super.data = value;
				return;
			}
			
			if (labelField)
			{
                _text = String(value[labelField]);
            }
			else if(value.label !== undefined)
			{
				if (value.label === null) _text = null;
                else _text = String(value.label);
			}
			else
			{
				_text = String(value);
			}
			// text = getLabelFromData(this, value);
			
            // if(value.href !== undefined)
			// {
			// 	if (value.href === null) _href = "#";
            //     else _href = String(value.href);
			// } else _href = "#";

			COMPILE::JS
			{
			if(textNode != null)
			{
				textNode.nodeValue = _text;
				//(element as HTMLElement).setAttribute('href', _href);
			}	
			}
			//super.data setter will dispatch dataChange
			super.data = value;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var a:WrappedHTMLElement = addElementToWrapper(this, 'a');
            //a.setAttribute('href', href);

			if(MXMLDescriptor == null)
			{
				textNode = document.createTextNode('') as Text;
				a.appendChild(textNode);
			}

            return element;
        }
	}
}
