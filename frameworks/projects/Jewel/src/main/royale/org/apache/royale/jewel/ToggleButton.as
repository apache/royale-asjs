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
    import flash.events.MouseEvent;

    import org.apache.royale.core.IToggleButtonModel;
    }
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.events.MouseEvent;
    }
	import org.apache.royale.core.IIcon;
	import org.apache.royale.core.ISelectable;
	import org.apache.royale.events.Event;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user clicks on a button.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  Dispatched when ToggleTextButton is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The ToggleButton class is a Button that supports a selected property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class ToggleButton extends IconButton implements ISelectable
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function ToggleButton()
		{
			super();

            typeNames = "jewel togglebutton";

            COMPILE::SWF
            {
            addEventListener(MouseEvent.CLICK, internalMouseHandler);
            }
		}

        private var _selected:Boolean = false;
        
        [Bindable("change")]
        /**
         *  <code>true</code> if the Button is selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
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
            internalSelected();
            dispatchEvent(new Event(Event.CHANGE));
            }
            COMPILE::JS
            {
            if (_selected != value)
            {
                _selected = value;
                internalSelected();
                dispatchEvent(new Event(Event.CHANGE));
            }
            }
        }

        private var _selectedText:String = null;

        [Bindable("selectedTextChange")]
        /**
         *  The selectedText of the icon
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get selectedText():String
		{
            if(_selectedText == null)
            {
                return text;
            }
            return _selectedText;            
		}
        public function set selectedText(value:String):void
		{
            _selectedText = value;
            internalSelected();
		}

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();
            element.addEventListener(MouseEvent.CLICK, clickHandler, false);
            internalSelected();
            
            return element;
        }

        COMPILE::JS
        private function clickHandler(event:Event):void
        {
            selected = !selected;
        }
        
        COMPILE::SWF
        private function internalMouseHandler(event:MouseEvent) : void
        {
            selected = !selected;
        }

        COMPILE::SWF
        private var savedClassName:String;

        private function internalSelected():void
        {
            COMPILE::SWF
            {
            if(!savedClassName == null)
                savedClassName = className;
            var name:String = savedClassName;
            if (selected)
            {
                className = "selected" + (name ? " " + name : "");
            }
            else
            {
                className = (name ? " " + name : "");
            }
            }
            
            var isToggleTextButtonSelected:Boolean = containsClass("selected");
            //sync the class with the state
            if(isToggleTextButtonSelected != _selected)
                toggleClass("selected", _selected);
            
            if(icon && icon is ISelectable)
            {
               var selectableIcon:ISelectable = icon as ISelectable;
               selectableIcon.selected = _selected;
            }

            COMPILE::JS
			{
                spanLabel.textContent = _selected ? selectedText : text;
			}
        }

        override public function set icon(value:IIcon):void
        {
            super.icon = value;
            if(icon && icon is ISelectable)
            {
               var selectableIcon:ISelectable = icon as ISelectable;
               selectableIcon.selected = _selected;
            }
        }

	}
}
