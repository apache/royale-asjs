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
    import org.apache.royale.html.supportClasses.MXMLItemRenderer;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;        
        import org.apache.royale.html.util.addElementToWrapper;    
    }
	
    /**
     *  The MenuItemRenderer class creates a MDL menu item
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */    
	public class MenuItemRenderer extends MXMLItemRenderer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function MenuItemRenderer()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }
        
        private var _text:String = "";

        /**
         *  The text of the menu item
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get text():String
		{
            COMPILE::SWF
            {
                return _text;
            }
            COMPILE::JS
            {
                return textNode.nodeValue;
            }
		}

		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                _text = value;
            }
            COMPILE::JS
            {
                textNode.nodeValue = value;
            }
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

            var text:String;
            if (labelField || dataField)
            {
                text = String(value[labelField]);
            }
            else
            {
                text = String(value);
            }

            COMPILE::JS
            {
                if(textNode != null)
                {
                    textNode.nodeValue = text;
                }
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-menu__item";
			addElementToWrapper(this,'li');
            
            textNode = document.createTextNode('') as Text;
            element.appendChild(textNode); 
            return element;
        }

        private var _divider:Boolean;

		/**
		 *  A boolean flag to activate "mdl-menu__item--full-bleed-divider" effect selector.
         *  Modifies an item to have a full bleed divider between it and the next list item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get divider():Boolean
		{
			return _divider;
		}
		public function set divider(value:Boolean):void
		{
			_divider = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-menu__item--full-bleed-divider", _divider);
                typeNames = element.className;
            }
		}
		
		override public function updateRenderer():void
		{
			// don't change background-color, let mdl library take care of that.
		}

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-js-ripple-effect", _ripple);
                typeNames = element.className;
            }
        }     

	}
}
