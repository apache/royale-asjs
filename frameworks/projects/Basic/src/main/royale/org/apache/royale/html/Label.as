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
package org.apache.royale.html
{
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.utils.sendEvent;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  Dispatched when the user clicks on a Label.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.0
     */
    [Event(name="click", type="org.apache.royale.events.MouseEvent")]

	/*
	 *  Label probably should extend TextField directly,
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
     *  @productversion Royale 0.0
     */
    public class Label extends UIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function Label()
		{
			super();
            typeNames = "Label";
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
         *  @productversion Royale 0.0
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
                    sendEvent(this,"textChange");
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
         *  @productversion Royale 0.0
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
                this.element.innerHTML = value;
                sendEvent(this,'textChange');
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
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'span');

            textNode = document.createTextNode(_text) as Text;
            element.appendChild(textNode);

            element.style.whiteSpace = "nowrap";

            return element;
        }

	}
}
