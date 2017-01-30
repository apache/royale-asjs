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
package org.apache.flex.mdl
{
    import org.apache.flex.events.Event;

    COMPILE::SWF
    {
        import flash.utils.Dictionary;
        import org.apache.flex.core.UIButtonBase;
        import org.apache.flex.core.IStrand;
        import org.apache.flex.core.IValueToggleButtonModel;
        import org.apache.flex.events.MouseEvent;
        import org.apache.flex.html.RadioButton;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.supportClasses.RadioButtonIcon;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user clicks on RadioButton.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	[Event(name="click", type="org.apache.flex.events.MouseEvent")]

    /**
     *  Dispatched when RadioButton is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    [Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The Material Design Lite (MDL) radio component is an enhanced version of the
     *  standard HTML <input type="radio">, or "radio button" element. A radio button
     *  consists of a small circle and, typically, text that clearly communicates a
     *  condition that will be set when the user clicks or touches it. Radio buttons
     *  always appear in groups of two or more and, while they can be individually
     *  selected, can only be deselected by selecting a different radio button in the
     *  same group (which deselects all other radio buttons in the group). The MDL
     *  radio component allows you to add display and click effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    COMPILE::SWF
	public class RadioButton extends UIButtonBase implements IStrand
	{
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function RadioButton()
		{
			super();

			addEventListener(org.apache.flex.events.MouseEvent.CLICK, internalMouseHandler);
		}

		protected static var dict:Dictionary = new Dictionary(true);

		private var _groupName:String;

		/**
		 *  The name of the group. Only one RadioButton in a group is selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get groupName() : String
		{
			return IValueToggleButtonModel(model).groupName;
		}
		public function set groupName(value:String) : void
		{
			IValueToggleButtonModel(model).groupName = value;
		}

		/**
		 *  The string used as a label for the RadioButton.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get text():String
		{
			return IValueToggleButtonModel(model).text;
		}
		public function set text(value:String):void
		{
			IValueToggleButtonModel(model).text = value;
		}

		/**
		 *  Whether or not the RadioButton instance is selected. Setting this property
		 *  causes the currently selected RadioButton in the same group to lose the
		 *  selection.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get selected():Boolean
		{
			return IValueToggleButtonModel(model).selected;
		}
		public function set selected(selValue:Boolean):void
		{
			IValueToggleButtonModel(model).selected = selValue;

			// if this button is being selected, its value should become
			// its group's selectedValue
			if( selValue ) {
				for each(var rb:org.apache.flex.mdl.RadioButton in dict)
				{
					if( rb.groupName == groupName )
					{
						rb.selectedValue = value;
					}
				}
			}
		}

		/**
		 *  The value associated with the RadioButton. For example, RadioButtons with labels,
		 *  "Red", "Green", and "Blue" might have the values 0, 1, and 2 respectively.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get value():Object
		{
			return IValueToggleButtonModel(model).value;
		}
		public function set value(newValue:Object):void
		{
			IValueToggleButtonModel(model).value = newValue;
		}

		/**
		 *  The group's currently selected value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get selectedValue():Object
		{
			return IValueToggleButtonModel(model).selectedValue;
		}
		public function set selectedValue(newValue:Object):void
		{
			// a radio button is really selected when its value matches that of the group's value
			IValueToggleButtonModel(model).selected = (newValue == value);
			IValueToggleButtonModel(model).selectedValue = newValue;
		}

		/**
		 * @private
		 */
		override public function addedToParent():void
		{
            super.addedToParent();

            // if this instance is selected, set the local selectedValue to
			// this instance's value
			if( selected ) selectedValue = value;

			else {

				// make sure this button's selectedValue is set from its group's selectedValue
				// to keep it in sync with the rest of the buttons in its group.
				for each(var rb:org.apache.flex.mdl.RadioButton in dict)
				{
					if( rb.groupName == groupName )
					{
						selectedValue = rb.selectedValue;
						break;
					}
				}
			}

			dict[this] = this;
		}

		/**
		 * @private
		 */
		private function internalMouseHandler(event:org.apache.flex.events.MouseEvent) : void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				selected = !selected;
				dispatchEvent(new Event("change"));
			}
		}

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;
        }
	}
    
    COMPILE::JS
    public class RadioButton extends UIBase
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function RadioButton()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * Provides unique name
         */
        protected static var radioCounter:int = 0;

        private var radio:HTMLSpanElement;
        private var icon:RadioButtonIcon;
        private var label:HTMLLabelElement;
        private var textNode:Text;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-radio mdl-js-radio";

            icon = new RadioButtonIcon();
            icon.className = 'mdl-radio__button';
            icon.id = '_radio_' + RadioButton.radioCounter++;
            
            textNode = document.createTextNode('') as Text;

            radio = document.createElement('span') as HTMLSpanElement;
            radio.className = 'mdl-radio__label';
            //radio.addEventListener('mouseover', mouseOverHandler, false);
            //radio.addEventListener('mouseout', mouseOutHandler, false);
            
            label = document.createElement('label') as HTMLLabelElement;
            label.appendChild(icon.element);
            label.appendChild(radio);
            radio.appendChild(textNode);
            
            element = label as WrappedHTMLElement;
            
            positioner = element;
            (element as WrappedHTMLElement).flexjs_wrapper = this;
            (textNode as WrappedHTMLElement).flexjs_wrapper = this;
            (icon.element as WrappedHTMLElement).flexjs_wrapper = this;
            (radio as WrappedHTMLElement).flexjs_wrapper = this;

            element.addEventListener("click", clickHandler, false);
            
            return element;
        };

        COMPILE::JS
        public function clickHandler(event:Event):void
        {
            event.preventDefault();
            unselectAll();
            selected = !selected;
            (icon.element as HTMLInputElement).checked = selected;
            label.classList.toggle("is-checked", selected);
        }

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
         *  Applies ripple click effect. May be used in combination with any other classes
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
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
        
        override public function set id(value:String):void
        {
            super.id = value;
            label.id = value;
            icon.element.id = value;
        }
        
        public function get groupName():String
        {
            return (icon.element as HTMLInputElement).name as String;
        }
        public function set groupName(value:String):void
        {
            (icon.element as HTMLInputElement).name = value;
        }
        
        public function get text():String
        {
            return textNode.nodeValue;
        }
        
        public function set text(value:String):void
        {
            textNode.nodeValue = value;
        }
        
        /** @export */
        public function get selected():Boolean
        {
            return (icon.element as HTMLInputElement).checked;
        }
        public function set selected(value:Boolean):void
        {
            (icon.element as HTMLInputElement).checked = value;
            dispatchEvent(new Event(Event.CHANGE))
        }
        
        public function get value():Object
        {
            return (icon.element as HTMLInputElement).value;
        }
        public function set value(v:Object):void
        {
            (icon.element as HTMLInputElement).value = v as String;
        }
        
        public function get selectedValue():Object
        {
            var groupName:String = (icon.element as HTMLInputElement).name as String;
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

        /**
         * @flexjsignorecoercion HTMLInputElement
         */
        public function set selectedValue(value:Object):void
        {
            var groupName:String = (icon.element as HTMLInputElement).name as String;
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

        COMPILE::JS
        private function unselectAll():void
        {
            var groupName:String = (icon.element as HTMLInputElement).name as String;
            var buttons:NodeList = document.getElementsByName(groupName);
            var n:int = buttons.length;

            for (var i:int = 0; i < n; i++)
            {
                var radio:HTMLInputElement = buttons[i];
                radio.checked = false;

                var labels:NodeList = radio["labels"];
                var labelsLength:int = labels.length;
                
                for (var l:int = 0; l < labelsLength; l++)
                {
                    var lbl:Object = labels[l];
                    lbl.classList.remove("is-checked");
                }
            }
        }
        /**
         * @param e The event object.
         */
        /*private function mouseOverHandler(e:Event):void
        {
            //radio.className = 'radio-icon-hover';
        }*/
        
        
        /**
         * @param e The event object.
         */
        /*private function mouseOutHandler(e:Event):void
        {
            if (input.checked)
                radio.className = 'radio-icon-checked';
            else
                radio.className = 'radio-icon';
        }*/
        
    }

}
