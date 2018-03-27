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
    import org.apache.royale.events.Event;
    import org.apache.royale.events.MouseEvent;

    COMPILE::SWF
    {
        import flash.utils.Dictionary;
        import org.apache.royale.core.UIButtonBase;
        import org.apache.royale.core.IStrand;
        import org.apache.royale.core.IValueToggleButtonModel;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.utils.cssclasslist.addStyles;
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
     *  @productversion Royale 0.8
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  Dispatched when RadioButton is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The Jewel radio button component is an enhanced version of the
     *  standard HTML <input type="radio">, or "radio button" element. A radio button
     *  consists of a small circle and, typically, text that clearly communicates a
     *  condition that will be set when the user clicks or touches it. Radio buttons
     *  always appear in groups of two or more and, while they can be individually
     *  selected, can only be deselected by selecting a different radio button in the
     *  same group (which deselects all other radio buttons in the group).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		public function RadioButton()
		{
            super();

            typeNames = "jewel radiobutton";

			addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
		}

		protected static var dict:Dictionary = new Dictionary(true);

		/**
		 *  The name of the group. Only one RadioButton in a group is selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
				for each(var rb:org.apache.royale.jewel.RadioButton in dict)
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
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
				for each(var rb:org.apache.royale.jewel.RadioButton in dict)
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
		private function internalMouseHandler(event:MouseEvent) : void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				selected = !selected;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
    
    /**
     *  Dispatched when the user clicks on RadioButton.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="click", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Dispatched when RadioButton is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    [Event(name="change", type="org.apache.royale.events.Event")]
    
    COMPILE::JS
    public class RadioButton extends UIBase
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function RadioButton()
		{
            super();

            typeNames = "jewel radiobutton";
        }

        /**
         * Provides unique name
         */
        protected static var radioCounter:int = 0;

        private var radio:HTMLSpanElement;
        private var icon:HTMLInputElement;
        private var label:HTMLLabelElement;
        private var textNode:Text;

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
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
            var label:HTMLLabelElement = document.createElement('label') as HTMLLabelElement;
            
            icon = addElementToWrapper(this,'input') as HTMLInputElement;
            icon.type = "radio";
            //icon.className = 'input';
            icon.id = '_radio_' + + Math.random();
            label.appendChild(icon);

            textNode = document.createTextNode('') as Text;

            radio = document.createElement('span') as HTMLSpanElement;
            //radio.className = 'span';
            radio.appendChild(textNode);
            label.appendChild(radio);
            //radio.addEventListener('mouseover', mouseOverHandler, false);
            //radio.addEventListener('mouseout', mouseOutHandler, false);

            // (textNode as WrappedHTMLElement).royale_wrapper = this;
            // (icon as WrappedHTMLElement).royale_wrapper = this;
            // (radio as WrappedHTMLElement).royale_wrapper = this;

            positioner = label as WrappedHTMLElement;
            _positioner.royale_wrapper = this;

            return element;
        }

        /**
		 *  override UIBase to affect positioner instead of element
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.2
		 */
        COMPILE::JS
		override protected function setClassName(value:String):void
		{
			addStyles(positioner, value);
		}

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

        public function clickHandler(event:Event):void
        {
            selected = !selected;
        }
        
        public function get groupName():String
        {
            return icon.name as String;
        }

        public function set groupName(value:String):void
        {
            icon.name = value;
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
            return icon.checked;
        }

        public function set selected(value:Boolean):void
        {
            if(icon.checked == value)
                return;
            var instance:Object = element['MaterialRadio'];
            if(instance)
            {
                if(value)
                    instance["check"]();
                else
                    instance["uncheck"]();
            }
            else
                icon.checked = value;
            dispatchEvent(new Event(Event.CHANGE));
        }
        
        public function get value():Object
        {
            return icon.value;
        }
        public function set value(v:Object):void
        {
            icon.value = v as String;
        }
        
        public function get selectedValue():Object
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

        /**
         * @royaleignorecoercion HTMLInputElement
         */
        public function set selectedValue(value:Object):void
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
}