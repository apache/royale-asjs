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
package org.apache.flex.html
{
    COMPILE::AS3
    {
        import flash.display.DisplayObject;
        import flash.events.MouseEvent;
        import flash.utils.Dictionary;            
    }
	
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IValueToggleButtonModel;
    COMPILE::AS3
    {
        import org.apache.flex.core.UIButtonBase;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }
	import org.apache.flex.events.Event;
	import org.apache.flex.core.IUIBase;
	
	[Event(name="change", type="org.apache.flex.events.Event")]

	/**
	 *  The RadioButton class is a component that displays a selectable Button. RadioButtons
	 *  are typically used in groups, identified by the groupName property. RadioButton use
	 *  the following beads:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model, which includes the groupName.
	 *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the RadioButton..
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
    COMPILE::AS3
	public class RadioButton extends UIButtonBase implements IStrand
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function RadioButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			
			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}
		
		protected static var dict:Dictionary = new Dictionary(true);
		
		private var _groupName:String;
		
		/**
		 *  The name of the group. Only one RadioButton in a group is selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		private function internalMouseHandler(event:Event) : void
		{
			// prevent radiobutton from being turned off by a click
			if( !selected ) {
				selected = !selected;
				dispatchEvent(new Event("change"));
			}
		}
	}
    
    COMPILE::JS
    public class RadioButton extends UIBase
    {
        public static var radioCounter:int = 0;
        
        private var input:HTMLInputElement;
        private var labelFor:HTMLLabelElement;
        private var textNode:Text;
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {            
            input = document.createElement('input') as HTMLInputElement;
            input.type = 'radio';
            input.id = '_radio_' + RadioButton.radioCounter++;
            
            textNode = document.createTextNode('radio button') as Text;
            
            labelFor = document.createElement('label') as HTMLLabelElement;
            labelFor.appendChild(input);
            labelFor.appendChild(textNode);
            
            element = labelFor as WrappedHTMLElement;
            element.className = 'RadioButton';
            typeNames = 'RadioButton';
            
            positioner = element;
            positioner.style.position = 'relative';
            
            (input as WrappedHTMLElement).flexjs_wrapper = this;
            (element as WrappedHTMLElement).flexjs_wrapper = this;
            (textNode as WrappedHTMLElement).flexjs_wrapper = this;
            
            return element;
        }        
        
        override public function set id(value:String):void 
        {
            super.id = value;
            labelFor.id = value;
            input.id = value;
        }
        
        public function get groupName():String
        {
            return input.name as String;
        }
        public function set groupName(value:String):void
        {
            input.name = value;
        }
        
        public function get text():String
        {
            return textNode.nodeValue as String;
        }
        public function set text(value:String):void
        {
            textNode.nodeValue = value;
        }
        
        /** @export */
        public function get selected():Boolean
        {
            return input.checked;
        }
        public function set selected(value:Boolean):void
        {
            input.checked = value;            
        }
        
        public function get value():Object
        {
            return input.value;
        }
        public function set value(v:Object):void
        {
            input.value = v as String;
        }
        
        public function get selectedValue():Object
        {
            var buttons:NodeList;
            var groupName:String;
            var i:int;
            var n:int;
            
            groupName = input.name as String;
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
         * @flexjsignorecoercion Array
         */
        public function set selectedValue(value:Object):void
        {
            var buttons:NodeList;
            var groupName:String;
            var i:int;
            var n:int;
            
            groupName = input.name as String;
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
