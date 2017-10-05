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
package org.apache.flex.mdl.itemRenderers
{
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.util.addElementToWrapper;
    }

	import org.apache.flex.html.supportClasses.MXMLItemRenderer;
    
	/**
	 *  The NavigationLinkItemRenderer defines the basic Item Renderer for a MDL NavigationLink List Component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class NavigationLinkItemRenderer extends MXMLItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function NavigationLinkItemRenderer()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
		private var _href:String = "#";
        /**
         *  the navigation link url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get href():String
		{
            return _href;   
		}
		public function set href(value:String):void
		{
            _href = value;
            
            COMPILE::JS
            {
                (element as HTMLElement).setAttribute('href', value);
            }
		}

		private var _label:String = "";

        /**
         *  The label of the navigation link
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get label():String
		{
            return _label;
		}

		public function set label(value:String):void
		{
             _label = value;
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
		 *  @productversion Royale 0.8
		 */
		override public function set data(value:Object):void
		{
			super.data = value;

			if(value == null) return;

			if(value.label !== undefined) {
                label = String(value.label);
			} else {
				label = String(value);
			}
			
            if(value.href !== undefined) {
                href = String(value.href);
			}

			COMPILE::JS
			{
				if(textNode != null)
				{
					textNode.nodeValue = label;
				}	
			}
		}

        /**
         * @royaleignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-navigation__link";
            var a:WrappedHTMLElement = addElementToWrapper(this,'a');
            a.setAttribute('href', href);

			if(MXMLDescriptor == null)
			{
				textNode = document.createTextNode('') as Text;
				a.appendChild(textNode);
			}
            return element;
        }
	}
}
