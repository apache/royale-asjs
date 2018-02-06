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
package org.apache.royale.mdl.itemRenderers
{
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	import org.apache.royale.html.supportClasses.MXMLItemRenderer;
    
	/**
	 *  The FooterLinkItemRenderer defines the basic Item Renderer for a MDL Footer Link List Component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class FooterLinkItemRenderer extends MXMLItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function FooterLinkItemRenderer()
		{
			super();
		}
		
		private var _text:String = "";

        /**
         *  The text of the item renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
             _text = value;
		}

		private var _href:String = "#";
        /**
         *  the link url
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

            if (labelField)
            {
                text = String(value[labelField]);
            }
            else
            {
                text = String(value);
            }

            if (dataField)
            {
                href = String(value[dataField]);
            }

            COMPILE::JS
            {
                textNode.nodeValue = text;
                (link as HTMLElement).setAttribute('href', href);
            }
		}

        COMPILE::JS
        protected var link:HTMLElement;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            addElementToWrapper(this,'li');

            link = document.createElement('a') as HTMLElement;
            link.setAttribute('href', href);

            textNode = document.createTextNode('') as Text;
            link.appendChild(textNode);

            element.appendChild(link);

            return element;
        }
	}
}
