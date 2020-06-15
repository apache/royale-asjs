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
    import org.apache.royale.core.IToggleButtonModel;
    import org.apache.royale.events.MouseEvent;
    }

    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.util.addElementToWrapper;
    }

    import org.apache.royale.core.ITextButton;
    import org.apache.royale.jewel.supportClasses.IInputButton;
    import org.apache.royale.jewel.supportClasses.button.SelectableButtonBase;
    
    /**
     *  The Jewel CheckBox consists of a box, that can contain a check mark or not, and an optional label.
     *  
     *  When a user clicks or touches this control or its associated text, the CheckBox changes 
     *  its state from checked to unchecked or from unchecked to checked, communicating
     *  clearly a binary condition.
     *  
     *  Checkboxes can appear in groups (but not necesarily), and can be
     *  selected and deselected individually.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class CheckBox extends SelectableButtonBase implements IInputButton, ITextButton
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function CheckBox()
		{
			super();

            typeNames = "jewel checkbox";
        }

        [Bindable("change")]
        /**
         *  <code>true</code> if the check mark is displayed, <code>false</code> otherwise.
         *  
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		override public function get selected():Boolean
		{
            COMPILE::SWF
            {
			return IToggleButtonModel(model).selected;
            }
            COMPILE::JS
            {
            return input.checked;
            }
		}
        /**
         *  @private
         */
		override public function set selected(value:Boolean):void
		{
            COMPILE::SWF
            {
			IToggleButtonModel(model).selected = value;
            }
            COMPILE::JS
            {
            if(input.checked == value)
                return;
            input.checked = value;
            dispatchEvent(new Event(Event.CHANGE));
            }
		}

        /**
         *  The string used as a label for the CheckBox.
         *
         *  @royaleignorecoercion Text
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
            return IToggleButtonModel(model).text;
            }
            COMPILE::JS
            {
            return textNode ? textNode.nodeValue : "";
            }
		}
        /**
         *  @private
         */
        public function set text(value:String):void
		{
            COMPILE::SWF
            {
	        IToggleButtonModel(model).text = value;
            }
            COMPILE::JS
            {
            if(!textNode)
            {
                textNode = document.createTextNode('') as Text;
                spanLabel.appendChild(textNode);
            }
            
            textNode.nodeValue = value;
            }
		}

        /**
         *  The value associated with the CheckBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get value():String
        {
            COMPILE::SWF
            {
            return IToggleButtonModel(model).html;
            }
            COMPILE::JS
            {
            return input.value;
            }
        }
        public function set value(newValue:String):void
        {
            COMPILE::SWF
            {
            IToggleButtonModel(model).html = newValue;
            }
            COMPILE::JS
            {
            input.value = newValue;
            }
        }

        COMPILE::JS
        /**
         *  the org.apache.royale.core.HTMLElementWrapper#element for this component
         *  added to the positioner. Is a HTMLInputElement.
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var input:HTMLInputElement;

        /**
         *  the input button
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        COMPILE::JS
        public function get inputButton():HTMLInputElement {
            return input;
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
        
        COMPILE::JS
        /**
         * a Text node added to the checkbox HTMLSpanElement.
         * It's creation is deferred since Checkboxes sometimes are used without labels.
         */
        protected var textNode:Text;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            input = addElementToWrapper(this,'input') as HTMLInputElement;
            input.type = 'checkbox';
            spanLabel = document.createElement('span') as HTMLSpanElement;
            positioner = document.createElement('label') as WrappedHTMLElement;   
            return element;
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
			_positioner.appendChild(element);
            _positioner.appendChild(spanLabel);
		}
    }
}
