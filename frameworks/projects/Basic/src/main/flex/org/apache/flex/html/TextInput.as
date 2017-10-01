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
package org.apache.flex.html
{
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.util.addElementToWrapper;
    }

	/**
     *  Dispatched when the user changes the text.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The TextInput class implements the basic control for
     *  single-line text input.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class TextInput extends UIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextInput()
		{
			super();

            COMPILE::SWF
            {
                model.addEventListener("textChange", textChangeHandler);
            }
		}

        /**
         *  @copy org.apache.flex.html.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion HTMLInputElement
         */
		[Bindable(event="change")]
		public function get text():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).text;
            }
            COMPILE::JS
            {
                return (element as HTMLInputElement).value;
            }
		}

        /**
         *  @private
         *  @flexjsignorecoercion HTMLInputElement
         */
		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                inSetter = true;
                ITextModel(model).text = value;
                inSetter = false;
            }
            COMPILE::JS
            {
                (element as HTMLInputElement).value = value;
                dispatchEvent(new Event('textChange'));
            }
		}

        /**
         *  @copy org.apache.flex.html.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion HTMLInputElement
         */
		[Bindable(event="change")]
		public function get html():String
		{
            COMPILE::SWF
            {
                return ITextModel(model).html;
            }
            COMPILE::JS
            {
                return (element as HTMLInputElement).value;
            }
		}

        /**
         *  @private
         *  @flexjsignorecoercion HTMLInputElement
         */
		public function set html(value:String):void
		{
            COMPILE::SWF
            {
                ITextModel(model).html = value;
            }
            COMPILE::JS
            {
                (element as HTMLInputElement).value = value;
                dispatchEvent(new Event('textChange'));
            }
		}

        private var inSetter:Boolean;

		/**
		 *  dispatch change event in response to a textChange event
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function textChangeHandler(event:Event):void
		{
            if (!inSetter)
                dispatchEvent(new Event(Event.CHANGE));
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'input');
            element.setAttribute('type', 'text');
            element.className = 'TextInput';
            typeNames = 'TextInput';

            //attach input handler to dispatch flexjs change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(element, 'input', textChangeHandler);
            return element;
        }

	}
}
