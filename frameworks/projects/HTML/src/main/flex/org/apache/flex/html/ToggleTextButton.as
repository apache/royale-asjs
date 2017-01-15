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
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IToggleButtonModel;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.Event;

    COMPILE::SWF
    {
        import flash.events.MouseEvent;
    }

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.events.MouseEvent;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user clicks on a button.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="click", type="org.apache.flex.events.MouseEvent")]

    /**
     *  Dispatched when ToggleTextButton is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The ToggleButton class is a TextButton that supports
     *  a selected property.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class ToggleTextButton extends TextButton implements IStrand, IEventDispatcher, IUIBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function ToggleTextButton()
		{
			super();
            COMPILE::SWF
            {
                addEventListener(MouseEvent.CLICK, internalMouseHandler);
            }
            COMPILE::JS
            {
                this.typeNames = 'toggleTextButton';
            }
		}

        COMPILE::JS
        private var _selected:Boolean;

        COMPILE::JS
        private var SELECTED:String = "selected";

        [Bindable("change")]
        /**
         *  <code>true</code> if the Button is selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get selected():Boolean
        {
            COMPILE::SWF
            {
                return IToggleButtonModel(model).selected;
            }
            COMPILE::JS
            {
                return _selected;
            }
        }

        /**
         *  @private
         */
        public function set selected(value:Boolean):void
        {
            COMPILE::SWF
            {
                IToggleButtonModel(model).selected = value;
            }
            COMPILE::JS
            {
                if (_selected != value)
                {
                    _selected = value;

                    var className:String = this.className;
                    var typeNames:String = this.typeNames;
                    if (value) {
                        if (typeNames.indexOf(SELECTED) == -1) {
                            typeNames = typeNames + SELECTED;
                            if (className)
                                element.className = typeNames + ' ' + className;
                            else
                                element.className = typeNames;
                        }
                    }
                    else {
                        if (typeNames.indexOf(SELECTED) == typeNames.length - SELECTED.length) {
                            typeNames = typeNames.substring(0, typeNames.length - SELECTED.length);
                            if (className)
                                element.className = typeNames + ' ' + className;
                            else
                                element.className = typeNames;
                        }
                    }
                }
            }
        }

        /**
         *  @private
         *  add another class selector
         */
        override public function get className():String
        {
            // we don't have a model yet so just pass through otherwise you will loop
            if (!parent)
                return super.className;

            var name:String = super.className;
            if (selected)
                return "toggleTextButton_Selected" + (name ? " " + name : "");
            else
                return "toggleTextButton" + (name ? " " + name : "");
        }

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();
            element.addEventListener("click", clickHandler, false);
            return element;
        }

        COMPILE::JS
        private function clickHandler(event:Event):void
        {
            selected = !selected;
            dispatchEvent(new Event("change"));
        }

        COMPILE::SWF
        private function internalMouseHandler(event:MouseEvent) : void
        {
            selected = !selected;
            dispatchEvent(new Event("change"));
        }
	}
}
