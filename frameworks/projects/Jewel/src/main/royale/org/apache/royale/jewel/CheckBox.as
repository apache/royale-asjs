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
    import org.apache.royale.core.ISelectable;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIButtonBase;
    import org.apache.royale.events.MouseEvent;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IToggleButtonModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.utils.ClassSelectorList;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The CheckBox class implements the common user interface
     *  control.  The CheckBox includes its text label.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    COMPILE::SWF
	public class CheckBox extends UIButtonBase implements IStrand, ISelectable
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

            classSelectorList = new ClassSelectorList(this);

			addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
		}

        protected var classSelectorList:ClassSelectorList;

        /**
         *  The text label for the CheckBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get text():String
		{
			return IToggleButtonModel(model).text;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
			IToggleButtonModel(model).text = value;
		}

        [Bindable("change")]
        /**
         *  <code>true</code> if the check mark is displayed.
         *
         *  @default false
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get selected():Boolean
		{
			return IToggleButtonModel(model).selected;
		}

        /**
         *  @private
         */
		public function set selected(value:Boolean):void
		{
			IToggleButtonModel(model).selected = value;
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
            return IToggleButtonModel(model).html;
        }
        public function set value(newValue:String):void
        {
            IToggleButtonModel(model).html = newValue;
        }
        
		private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
		{
			selected = !selected;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The CheckBox class provides a Jewel UI-like appearance for a CheckBox.
     *
     *  A checkbox consists of a small square and, typically, text that clearly 
     *  communicates a binary condition that will be set or unset when the user 
     *  clicks or touches it. 
     *  Checkboxes typically, but not necessarily, appear in groups, and can be
     *  selected and deselected individually. The Jewel checkbox component allows
     *  you to add display and click effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    COMPILE::JS
    public class CheckBox extends StyledUIBase
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

        private var _label:WrappedHTMLElement;

		private static var _checkNumber:Number = 0;
        
        COMPILE::JS
        protected var input:HTMLInputElement;

        COMPILE::JS
        protected var checkbox:HTMLSpanElement;
        
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
            checkbox = document.createElement('span') as HTMLSpanElement;
            positioner = document.createElement('label') as WrappedHTMLElement;   
            return element;
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
            _positioner.appendChild(checkbox);
		}

        /**
         *  The text label for the CheckBox.
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
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion HTMLInputElement
         */
		public function get selected():Boolean
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
         * @royaleignorecoercion HTMLInputElement
         */
        public function set selected(value:Boolean):void
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
    }

}
