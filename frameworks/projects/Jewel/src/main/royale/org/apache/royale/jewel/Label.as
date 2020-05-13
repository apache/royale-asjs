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
package org.apache.royale.jewel
{
    COMPILE::SWF
    {
	import org.apache.royale.core.ITextModel;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.utils.sendEvent;
	
    /**
     *  Dispatched when the user clicks on a Label.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event(name="click", type="org.apache.royale.events.MouseEvent")]

	/*
	 *  Label probably should extend TextInput directly,
	 *  but the player's APIs for TextLine do not allow
	 *  direct instantiation, and we might want to allow
	 *  Labels to be declared and have their actual
	 *  view be swapped out.
	 */

    /**
     *  The Label class implements the basic control for labeling
     *  other controls.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class Label extends StyledUIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function Label()
		{
			super();
            typeNames = "jewel label";
		}

        COMPILE::JS
        protected var textNode:Text;

        COMPILE::JS
        private var _text:String = "";

        [Bindable("textChange")]
        /**
         *  The text to display in the label.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get text():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).text;
            }
            COMPILE::JS
            {
                return _text;
            }
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                ITextModel(model).text = value;
            }
            COMPILE::JS
            {
                if (textNode)
                {
                    value = value != null ? value + '' : '';
                    _text = value;
                    textNode.nodeValue = value;
                    sendEvent(this, "textChange");
                }
            }

		}

        [Bindable("htmlChange")]
        /**
         *  The html-formatted text to display in the label.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get html():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).html;
            }
            COMPILE::JS
            {
                return element.innerHTML;
            }
		}

        /**
         *  @private
         */
		public function set html(value:String):void
        {
            COMPILE::SWF
            {
                ITextModel(model).html = value;
            }
            COMPILE::JS
            {
                element.innerHTML = value;
                sendEvent(this, "textChange");
            }
        }

        private var _multiline:Boolean;
        /**
		 *  A boolean flag to activate "multiline" effect selector.
		 *  Allow the label to have more than one line if needed
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get multiline():Boolean
        {
            return _multiline;
        }

        public function set multiline(value:Boolean):void
        {
            if (_multiline != value)
            {
                _multiline = value;
                toggleClass("multiline", _multiline);
            }
        }

        /**
         *  @private
         */
        COMPILE::SWF
        override public function addedToParent():void
        {
            super.addedToParent();
            model.addEventListener("textChange", repeaterListener);
            model.addEventListener("htmlChange", repeaterListener);
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');

            textNode = document.createTextNode(_text) as Text;
            element.appendChild(textNode);
            
            return element;
        }

	}
}
