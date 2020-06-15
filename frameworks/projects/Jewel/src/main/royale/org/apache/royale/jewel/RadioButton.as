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
    import flash.utils.Dictionary;

    import org.apache.royale.core.IValueToggleButtonModel;
    }

    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.util.addElementToWrapper;
    }

    import org.apache.royale.core.ITextButton;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.jewel.supportClasses.IInputButton;
    import org.apache.royale.jewel.supportClasses.button.SelectableButtonBase;
    
    /**
     *  The Jewel RadioButton control lets the user make a single choice within a set of mutually exclusive choices.
     *  
     *  A RadioButton consists of a circle and, typically, text that clearly communicates a
     *  condition that will be set when the user clicks or touches it. Radio buttons
     *  always appear in groups of two or more with the same <code>groupName</code> propert. 
     *  While they can be individually selected, can only be deselected by selecting 
     *  a different RadioButton in the same group (which deselects the rest of RadioButton).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    public class RadioButton extends SelectableButtonBase implements IInputButton, ITextButton
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function RadioButton()
		{
            super();

            typeNames = "jewel radiobutton";
        }

        /**
		 * @private
		 */
        COMPILE::SWF
		override protected function internalMouseHandler(event:MouseEvent):void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				super.internalMouseHandler(event);
			}
        }

        COMPILE::SWF
        protected static var dict:Dictionary = new Dictionary(true);
		/**
		 *  Whether or not the RadioButton instance is selected. Setting this property
		 *  causes the currently selected RadioButton in the same group to lose the
		 *  selection.
         * 
         *  <code>true</code> if the radio mark is displayed, <code>false</code> otherwise.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        [Bindable("change")]
		override public function get selected():Boolean
		{
            COMPILE::SWF
            {
			return IValueToggleButtonModel(model).selected;
            }
            COMPILE::JS
            {
            return icon.checked;
            }
		}
		override public function set selected(selValue:Boolean):void
		{
            COMPILE::SWF
            {
			IValueToggleButtonModel(model).selected = selValue;

			// if this button is being selected, its value should become
			// its group's selectedValue
			if( selValue ) {
				for each(var rb:RadioButton in dict)
				{
					if( rb.groupName == groupName )
					{
						rb.selectedValue = value;
					}
				}
			}
            }
            COMPILE::JS
            {
            if(icon.checked == selValue) {
                return;
            }
            icon.checked = selValue;
            dispatchEvent(new Event(Event.CHANGE));
            }
		}

        /**
		 *  The currently selected value in the group.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get selectedValue():Object
		{
            COMPILE::SWF
            {
			return IValueToggleButtonModel(model).selectedValue;
            }
            COMPILE::JS
            {
            var groupName:String = icon.name as String;
            var buttons:NodeList = document.getElementsByName(groupName);
            var n:int = buttons.length;

            for (var i:int = 0; i < n; i++)
            {
                if (buttons[i].checked)
                {
                    return buttons[i].value;
                }
            }
            return null;
            }
		}
        /**
         * @royaleignorecoercion HTMLInputElement
         */
		public function set selectedValue(newValue:Object):void
		{
            COMPILE::SWF
            {
			// a radio button is really selected when its value matches that of the group's value
			IValueToggleButtonModel(model).selected = (newValue == value);
			IValueToggleButtonModel(model).selectedValue = newValue;
            }
            COMPILE::JS
            {
            var groupName:String = icon.name as String;
            var buttons:NodeList = document.getElementsByName(groupName);
            var n:int = buttons.length;

            for (var i:int = 0; i < n; i++)
            {
                if (buttons[i].value === value)
                {
                    buttons[i].checked = true;
                    break;
                }
            }
            }
		}
        
        /**
		 *  The string used as a label for the RadioButton.
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
			return IValueToggleButtonModel(model).text;
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
			IValueToggleButtonModel(model).text = value;
            }
            COMPILE::JS
            {
            textNode.nodeValue = value;
            }
		}

        /**
         *  The value associated with the RadioButton. For example, RadioButtons with labels,
		 *  "Red", "Green", and "Blue" might have the values 0, 1, and 2 respectively.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get value():Object
        {
            COMPILE::SWF
            {
            return IValueToggleButtonModel(model).value;
            }
            COMPILE::JS
            {
            return icon.value;
            }
        }
        public function set value(value:Object):void
        {
            COMPILE::SWF
            {
            IValueToggleButtonModel(model).value = value;
            }
            COMPILE::JS
            {
            icon.value = String(value);
            }
        }
        
        /**
         *  The name of the group to which this radio belongs.
         *  Only one RadioButton in a group can be selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get groupName():String
        {
            COMPILE::SWF
            {
            return IValueToggleButtonModel(model).groupName;
            }
            COMPILE::JS
            {
            return icon.name as String;
            }
        }
        public function set groupName(value:String):void
        {
            COMPILE::SWF
            {
            IValueToggleButtonModel(model).groupName = value;
            }
            COMPILE::JS
            {
            icon.name = value;
            }
        }

        COMPILE::JS
        /**
         * the org.apache.royale.core.HTMLElementWrapper#element for this component
         * added to the positioner. Is a HTMLInputElement.
         */
        protected var icon:HTMLInputElement;

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
            return icon;
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
         * a Text node added to the radio HTMLSpanElement
         */
        protected var textNode:Text;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            icon = addElementToWrapper(this, 'input') as HTMLInputElement;
            icon.type = 'radio';
            icon.id = '_radio_' + Math.random();
            icon.value = String(value);
            
            textNode = document.createTextNode('') as Text;
            spanLabel = document.createElement('span') as HTMLSpanElement;
            spanLabel.appendChild(textNode);
            
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

        /**
         * @copy org.apache.royale.events.EventDispatcher#addEventListener
         */
        COMPILE::JS
        override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
        {
            if (type == MouseEvent.CLICK)
            {
                icon.addEventListener(type, handler, opt_capture);
            }
            else
            {
                super.addEventListener(type, handler, opt_capture, opt_handlerScope);
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#addElement()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.6
         */
        COMPILE::SWF
		override public function addedToParent():void
		{
            super.addedToParent();

            // if this instance is selected, set the local selectedValue to
			// this instance's value
			if(selected) {
                selectedValue = value;
            }
			else {
				// make sure this button's selectedValue is set from its group's selectedValue
				// to keep it in sync with the rest of the buttons in its group.
				for each(var rb:RadioButton in dict)
				{
					if(rb.groupName == groupName)
					{
						selectedValue = rb.selectedValue;
						break;
					}
				}
			}

			dict[this] = this;
		}
    }
}