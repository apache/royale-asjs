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
package org.apache.royale.jewel.supportClasses.textinput
{
    COMPILE::SWF
    {
    import org.apache.royale.core.ITextModel;
    }

    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    }

    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.KeyboardEvent;
    import org.apache.royale.jewel.supportClasses.textinput.ITextInput;
    import org.apache.royale.events.utils.WhitespaceKeys;
    
    /**
     *  Dispatched when text in the control changes through user input.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  Dispatched when the user presses the Enter key.
     *
     *  @eventType org.apache.royale.events.utils.WhitespaceKeys.ENTER
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    [Event(name="enter", type="org.apache.royale.events.Event")]

    /**
     *  The TextInputBase class is the base class for TextInput and TextArea Jewel controls.
     *  Implements text and html properties and change event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */    
	public class TextInputBase extends StyledUIBase implements ITextInput
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function TextInputBase()
		{
			super();

            COMPILE::SWF
            {
            model.addEventListener("textChange", textChangeHandler);
            }
		}

        COMPILE::SWF
        private var inSetter:Boolean;

        /**
         *  @copy org.apache.royale.jewel.Label#text
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion HTMLInputElement
         */
		[Bindable(event="change")]
		[Bindable(event="textChange")]
		public function get text():String
		{
            COMPILE::SWF
            {
            return ITextModel(model).text;
            }
            COMPILE::JS
            {
            return input.value;
            }
		}
        /**
         *  @private
         *  @royaleignorecoercion HTMLInputElement
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
            input.value = value;
            dispatchEvent(new Event('textChange'));
            }
		}

        /**
         *  @copy org.apache.royale.jewel.Label#html
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion HTMLInputElement
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
            return input.value;
            }
		}
        /**
         *  @private
         *  @royaleignorecoercion HTMLInputElement
         */
		public function set html(value:String):void
		{
            COMPILE::SWF
            {
            ITextModel(model).html = value;
            }
            COMPILE::JS
            {
            input.value = value;
            dispatchEvent(new Event('textChange'));
            }
		}

        /**
		 *  Dispatch change event in response to a textChange event
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
		 */
		protected function textChangeHandler(event:Event):void
		{
            COMPILE::SWF
            {
            if (!inSetter)
                dispatchEvent(new Event(Event.CHANGE));
            }
            dispatchEvent(new Event(Event.CHANGE));
		}

        /**
         *  dispatch change event in response to a textChange event
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        protected function enterEventHandler(event:KeyboardEvent):void
        {
            COMPILE::JS
            {
            if (event.key === WhitespaceKeys.ENTER) {
                // Cancel the default action, if needed
                event.preventDefault();
                dispatchEvent(new Event("enter"));
            }
            }
        }

        COMPILE::JS
        private var _input:HTMLInputElement;
        /**
         *  @copy org.apache.royale.jewel.supportClasses.textinput.ITextInput#input
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        public function get input():HTMLInputElement
        {
            return _input;
        }
        COMPILE::JS
        public function set input(value:HTMLInputElement):void
        {
            _input = value;
        }

        COMPILE::JS
		private var _positioner:WrappedHTMLElement;
        /**
         *  @copy org.apache.royale.core.IUIBase#positioner
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		COMPILE::JS
		override public function get positioner():WrappedHTMLElement
		{
			return _positioner;
		}

		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			_positioner = value;
            _positioner.royale_wrapper = this;
			_positioner.appendChild(input);
		}
	}
}
