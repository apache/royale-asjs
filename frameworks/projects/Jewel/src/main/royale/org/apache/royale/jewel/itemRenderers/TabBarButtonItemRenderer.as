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
	import org.apache.royale.core.StyledMXMLItemRenderer;
	import org.apache.royale.jewel.supportClasses.INavigationRenderer;
	import org.apache.royale.jewel.supportClasses.util.getLabelFromData;
	import org.apache.royale.events.Event;
    
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

    
	/**
	 *  The TabBarButtonItemRenderer defines the basic Item Renderer for a Jewel 
     *  TabBar List Component. It handles Objects with "label" and "href" data.
	 *  Extend this (you can do it in MXML) to support more data like for example: icon data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class TabBarButtonItemRenderer extends StyledMXMLItemRenderer implements INavigationRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function TabBarButtonItemRenderer()
		{
			super();

			typeNames = "jewel tabbarbutton";
			addClass("selectable");
		}

		private var _href:String = "#";
        /**
         *  the navigation link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get href():String
		{
            return _href;   
		}
		public function set href(value:String):void
		{
            _href = value;
		}

		private var _text:String = "";

        /**
         *  The text of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
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
			super.data = value;

			if(value == null) return;

			if (labelField)
			{
                text = String(value[labelField]);
            }
			else if(value.label !== undefined)
			{
                text = String(value.label);
			}
			else
			{
				text = String(value);
			}
			// text = getLabelFromData(this, value);
			
            if(value.href !== undefined)
			{
                href = String(value.href);
			}

			COMPILE::JS
			{
			if(textNode != null)
			{
				textNode.nodeValue = text;
				(element as HTMLElement).setAttribute('href', href);
			}	
			}

			dispatchEvent(new Event("dataChange"));
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var a:WrappedHTMLElement = addElementToWrapper(this, 'a');
            a.setAttribute('href', href);

			if(MXMLDescriptor == null)
			{
				textNode = document.createTextNode('') as Text;
				a.appendChild(textNode);
			}

            return element;
        }

		/**
		 * @private
		 * 
		 * Styles are handled in CSS and usualy This renderer does not uses "selected" state
	 	 * at least if the drawer is closed after selection.
		 */
		override public function updateRenderer():void
		{
			// there's no selection only hover state
			if(hoverable)
            	toggleClass("hovered", hovered);
			if(selectable)
            	toggleClass("selected", selected);
		}
	}
}
