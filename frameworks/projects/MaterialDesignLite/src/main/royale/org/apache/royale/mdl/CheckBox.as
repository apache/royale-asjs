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
package org.apache.royale.mdl
{
    import org.apache.royale.html.CheckBox;
    import org.apache.royale.core.IToggleButtonModel;
    import org.apache.royale.mdl.beads.UpgradeChildren;
    import org.apache.royale.mdl.beads.UpgradeElement;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.events.Event;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
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
     *  @productversion Royale 0.8
     */
	public class CheckBox extends org.apache.royale.html.CheckBox
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function CheckBox()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-checkbox mdl-js-checkbox";

            addBead(new UpgradeElement());
            addBead(new UpgradeChildren(["mdl-checkbox__ripple-container"]));
        }

        COMPILE::JS
        private var _classList:CSSClassList;

        COMPILE::JS
        protected var input:HTMLInputElement;

        COMPILE::JS
        protected var checkbox:HTMLSpanElement;

        COMPILE::JS
        protected var label:HTMLLabelElement;
        
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLLabelElement
         * @royaleignorecoercion HTMLInputElement
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            label = addElementToWrapper(this,'label') as HTMLLabelElement;
            
            input = document.createElement('input') as HTMLInputElement;
            input.type = 'checkbox';    
            input.className = 'mdl-checkbox__input';
            label.appendChild(input);
            
            checkbox = document.createElement('span') as HTMLSpanElement;
            checkbox.className = 'mdl-checkbox__label';
            label.appendChild(checkbox);
            
            (input as WrappedHTMLElement).royale_wrapper = this;
            (checkbox as WrappedHTMLElement).royale_wrapper = this;
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
		 *  @productversion Royale 0.8
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }

        public function set ripple(value:Boolean):void
        {
            if (_ripple != value)
            {
                _ripple = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-js-ripple-effect";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }
        
        /**
         *  The text label for the CheckBox.
         *
         *  @royaleignorecoercion Text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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
         * @royaleignorecoercion Text
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
         *  @productversion Royale 0.9
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
         *  @productversion Royale 0.8
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

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
    }

}
