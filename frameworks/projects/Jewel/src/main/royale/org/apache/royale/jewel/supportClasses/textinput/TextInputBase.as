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
    COMPILE::JS
    {
    import goog.events;

    import org.apache.royale.core.WrappedHTMLElement;
    }
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.supportClasses.textinput.ITextInput;
    
    /**
     *  Dispatched when the user changes the text.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The TextInputBase class is the base class for TextInput and TextArea Jewel controls
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

        /**
         *  @copy org.apache.royale.html.Label#text
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
            return (element as HTMLInputElement).value;
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
            (element as HTMLInputElement).value = value;
            dispatchEvent(new Event('textChange'));
            }
		}

        /**
         *  @copy org.apache.royale.html.Label#html
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
            return (element as HTMLInputElement).value;
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
            (element as HTMLInputElement).value = value;
            dispatchEvent(new Event('textChange'));
            }
		}

        COMPILE::SWF
        private var inSetter:Boolean;

        /**
		 *  dispatch change event in response to a textChange event
		 *
		 *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
		 */
		public function textChangeHandler(event:Event):void
		{
            COMPILE::SWF
            {
            if (!inSetter)
                dispatchEvent(new Event(Event.CHANGE));
            }
            dispatchEvent(new Event(Event.CHANGE));
		}

        COMPILE::JS
        private var _textNode:Text;

        /**
         *  @copy org.apache.royale.jewel.supportClasses.ITextInput#textNode
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        public function get textNode():Text
        {
            return _textNode;
        }

        COMPILE::JS
        public function set textNode(value:Text):void
        {
            _textNode = value;
        }

        COMPILE::JS
        private var _input:HTMLInputElement;
        /**
         *  @copy org.apache.royale.jewel.supportClasses.ITextInput#input
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
        private var _label:HTMLLabelElement;

        /**
         *  @copy org.apache.royale.jewel.supportClasses.ITextInput#label
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        public function get label():HTMLLabelElement
        {
            return _label;
        }

        COMPILE::JS
        public function set label(value:HTMLLabelElement):void
        {
            _label = value;
        }

        COMPILE::JS
		private var _positioner:WrappedHTMLElement;

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
			_positioner.appendChild(element);
		}
	}
}
