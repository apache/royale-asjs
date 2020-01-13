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
    COMPILE::SWF
    {
        import flash.display.DisplayObject;
        import flash.events.MouseEvent;
        import flash.utils.Dictionary;
        import org.apache.royale.core.UIButtonBase;
    }

    COMPILE::JS
    {
        import org.apache.royale.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.supportClasses.RadioButtonIcon;
        import org.apache.royale.html.util.addElementToWrapper;
    }
	
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IValueToggleButtonModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.core.ISelectable;

	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 *  The RadioButton class is a component that displays a selectable Button. RadioButtons
	 *  are typically used in groups, identified by the groupName property. RadioButton use
	 *  the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the groupName.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the RadioButton..
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    COMPILE::SWF
	public class RadioButton extends UIButtonBase implements IStrand, ISelectable
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RadioButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);

			addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
		}

		protected static var dict:Dictionary = new Dictionary(true);

		private var _groupName:String;

		/**
		 *  The name of the group. Only one RadioButton in a group is selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
				for each(var rb:RadioButton in dict)
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
				for each(var rb:RadioButton in dict)
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
		private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				selected = !selected;
				dispatchEvent(new Event("change"));
			}
		}
	}

    [Event(name="change", type="org.apache.royale.events.Event")]
    
    COMPILE::JS
    public class RadioButton extends UIBase implements ISelectable
    {
        /**
         * @private
         * 
         *  @royalesuppresspublicvarwarning
         */
        public static var radioCounter:int = 0;

        private var labelFor:HTMLLabelElement;
        private var textNode:Text;
        private var icon:RadioButtonIcon;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
            icon = new RadioButtonIcon()
            icon.id = '_radio_' + RadioButton.radioCounter++;

            textNode = document.createTextNode('') as Text;

            labelFor = addElementToWrapper(this,'label') as HTMLLabelElement;
            labelFor.appendChild(icon.element);
            labelFor.appendChild(textNode);

           (textNode as WrappedHTMLElement).royale_wrapper = this;
			(icon.element as WrappedHTMLElement).royale_wrapper = this;

            typeNames = 'RadioButton';

            return element;
        }

        override public function set id(value:String):void
        {
            super.id = value;
            labelFor.id = value;
            icon.element.id = value;
        }

		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function get groupName():String
        {
            return (icon.element as HTMLInputElement).name as String;
        }
		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function set groupName(value:String):void
        {
            (icon.element as HTMLInputElement).name = value;
        }

        public function get text():String
        {
            return textNode.nodeValue as String;
        }
        public function set text(value:String):void
        {
            textNode.nodeValue = value;
        }

		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function get selected():Boolean
        {
            return (icon.element as HTMLInputElement).checked;
        }
		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function set selected(value:Boolean):void
        {
            (icon.element as HTMLInputElement).checked = value;
        }

		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function get value():String
        {
            return (icon.element as HTMLInputElement).value;
        }
		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function set value(v:String):void
        {
            (icon.element as HTMLInputElement).value = "" + v;
        }

		/**
		 * @royaleignorecoercion HTMLInputElement
		 */
        public function get selectedValue():Object
        {
            var buttons:NodeList;
            var groupName:String;
            var i:int;
            var n:int;

            groupName = (icon.element as HTMLInputElement).name;
            buttons = document.getElementsByName(groupName);
            n = buttons.length;

            for (i = 0; i < n; i++) {
                if (buttons[i].checked) {
                    return buttons[i].value;
                }
            }
            return null;
        }

        /**
         * @royaleignorecoercion Array
		 * @royaleignorecoercion HTMLInputElement
         */
        public function set selectedValue(value:Object):void
        {
            var buttons:NodeList;
            var groupName:String;
            var i:int;
            var n:int;

            groupName = (icon.element as HTMLInputElement).name;
            buttons = document.getElementsByName(groupName);
            n = buttons.length;
            for (i = 0; i < n; i++) {
                if (buttons[i].value === value) {
                    buttons[i].checked = true;
                    break;
                }
            }
        }
    }

}
