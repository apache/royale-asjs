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
    //@gregdove: Below is needed to avoid dispatching native JS Event, which seems to still work in Chrome and probably other browsers,
    //but IE11 will break if the following import is removed:
    //@carlosrovira: Probably the above issue is due to the need to be in COMPILE::JS, so IDEs organizing imports don't remove this one
    import org.apache.royale.events.Event;
    import org.apache.royale.core.WrappedHTMLElement;
    }
    import org.apache.royale.jewel.supportClasses.button.SimpleButton;
    import org.apache.royale.core.ITextButton;

    [DefaultProperty("text")]

    /**
     *  The Jewel Button class adds text capabilities to Jewel SimpleButton.
     * 
     *  Button is a commonly used rectangular button with text inside. It looks like it can be pressed 
     *  and allow users to take actions, and make choices, with a single click or tap. It typically
     *  use event listeners to perform an action when the user interact with the control. When a user
     *  clicks the mouse or tap with the finger this control it dispatches a click event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class Button extends SimpleButton implements ITextButton
    {
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Button()
		{
			super();
		}

		[Bindable("textChange")]
		/**
		 *  The text to appear on the control.
		 * 
		 *  @copy org.apache.royale.jewel.Label#text
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
			return spanLabel.textContent;
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
			spanLabel.textContent = value;
			dispatchEvent(new Event('textChange'));
			}
		}


		[Bindable("htmlChange")]
		/**
		 *  The html text to appear on the control.
		 *  
		 *  @copy org.apache.royale.jewel.Label#html
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
			return spanLabel.innerHTML;
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
			spanLabel.innerHTML = value;
			dispatchEvent(new Event('htmlChange'));
			}
		}

		COMPILE::JS
		private var _spanLabel:HTMLSpanElement;
		/**
         *  the span for the label text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
		COMPILE::JS
		public function get spanLabel():HTMLSpanElement {
			return _spanLabel;
		}
		COMPILE::JS
		public function set spanLabel(value:HTMLSpanElement):void {
			_spanLabel = value;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			super.createElement();
            
			spanLabel = document.createElement('span') as HTMLSpanElement;
			spanLabel.textContent = text;
			element.appendChild(spanLabel);

            return element;
        }
	}
}
