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
    import org.apache.flex.html.CheckBox;
    import org.apache.flex.core.IToggleButtonModel;
    import org.apache.flex.mdl.beads.UpgradeChildren;
    import org.apache.flex.mdl.beads.UpgradeElement;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.events.Event;
        import org.apache.flex.html.util.addElementToWrapper;
    }

    /**
     *  The CheckBox class provides a MDL UI-like appearance for a CheckBox.
     *
     *  The Material Design Lite (MDL) checkbox component is an enhanced version 
     *  of the standard HTML <input type="checkbox"> element. A checkbox consists 
     *  of a small square and, typically, text that clearly communicates a binary 
     *  condition that will be set or unset when the user clicks or touches it. 
     *  Checkboxes typically, but not necessarily, appear in groups, and can be
     *  selected and deselected individually. The MDL checkbox component allows
     *  you to add display and click effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	public class CheckBox extends org.apache.flex.html.CheckBox
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function CheckBox()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;

            addBead(new UpgradeElement());
            addBead(new UpgradeChildren(["mdl-checkbox__ripple-container"]));
        }
        
        COMPILE::JS
        protected var input:HTMLInputElement;

        COMPILE::JS
        protected var checkbox:HTMLSpanElement;

        COMPILE::JS
        protected var label:HTMLLabelElement;
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-checkbox mdl-js-checkbox";
			

            label = addElementToWrapper(this,'label') as HTMLLabelElement;
            
            input = document.createElement('input') as HTMLInputElement;
            input.type = 'checkbox';    
            input.className = 'mdl-checkbox__input';
            label.appendChild(input);
            
            checkbox = document.createElement('span') as HTMLSpanElement;
            checkbox.className = 'mdl-checkbox__label';
            label.appendChild(checkbox);
            
            (input as WrappedHTMLElement).flexjs_wrapper = this;
            (checkbox as WrappedHTMLElement).flexjs_wrapper = this;
            return element;
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
        
        /**
         *  The text label for the CheckBox.
         *
         *  @flexjsignorecoercion Text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		override public function get text():String
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
        override public function set text(value:String):void
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
                    checkbox.appendChild(textNode);
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
         *  @productversion FlexJS 0.9
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
        protected var textNode:Text;

        [Bindable("change")]
        /**
         *  <code>true</code> if the check mark is displayed.
         *
         *  @default false
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
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
                var instance:Object = element['MaterialCheckbox'];
                if(instance)
                {
                    if(value)
                        instance["check"]();
                    else
                        instance["uncheck"]();
                }
                else
                    input.checked = value;
                dispatchEvent(new Event(Event.CHANGE));
            }
        }
    }

}
