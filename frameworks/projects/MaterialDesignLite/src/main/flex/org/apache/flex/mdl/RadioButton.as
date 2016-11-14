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
    COMPILE::SWF
    {
        import org.apache.flex.html.RadioButton;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.supportClasses.RadioButtonIcon;
    }

    /**
     *  The RadioButton class provides a MDL UI-like appearance for
     *  a RadioButton.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class RadioButton extends org.apache.flex.html.RadioButton
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function RadioButton()
		{
			super();
		}

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
         */
		public function RadioButton()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * Provides unique name
         */
        public static var radioCounter:int = 0;

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
            radio.addEventListener('mouseover', mouseOverHandler, false);
            radio.addEventListener('mouseout', mouseOutHandler, false);
            
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
            
            return element;
        };
        
        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
         *  Applies ripple click effect. May be used in combination with any other classes
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            className += (_ripple ? " mdl-js-ripple-effect" : "");
        }
        
        /**
         * @param e The event object.
         */
        private function mouseOverHandler(e:Event):void
        {
            //radio.className = 'radio-icon-hover';
        }
        
        
        /**
         * @param e The event object.
         */
        private function mouseOutHandler(e:Event):void
        {
            /*if (input.checked)
                radio.className = 'radio-icon-checked';
            else
                radio.className = 'radio-icon';*/
        }
        
        
        /**
         * @param e The event object.
         */
        private function selectionChangeHandler(e:Event):void 
        {
            // this should reset the icons in the non-selected radio
            selectedValue = value;
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
            var buttons:NodeList;
            var groupName:String;
            var i:int;
            var n:int;

            groupName = (icon.element as HTMLInputElement).name as String;
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

            groupName = (icon.element as HTMLInputElement).name as String;
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
