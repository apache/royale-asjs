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
    import org.apache.flex.mdl.supportClasses.IMaterialIconProvider;
    import org.apache.flex.mdl.materialIcons.IMaterialIcon;
    import org.apache.flex.mdl.supportClasses.MaterialIconBase;
    import org.apache.flex.core.IToggleButtonModel;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.MouseEvent;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.html.TextButton;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.core.IUIBase;

    COMPILE::JS
    {    
        import org.apache.flex.core.WrappedHTMLElement;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user clicks on IconToggle.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
	[Event(name="click", type="org.apache.flex.events.MouseEvent")]

    /**
     *  Dispatched when IconToggle is being selected/unselected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    [Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The Material Design Lite (MDL) icon-toggle component is an enhanced version of
     *  the standard HTML <input type="checkbox"> element. An icon-toggle consists of a 
     *  user defined icon that indicates, by visual highlighting, a binary condition that
     *  will be set or unset when the user clicks or touches it. Like checkboxes, 
     *  icon-toggles may appear individually or in groups, and can be selected and 
     *  deselected individually.
     *
     *  Icon toggles, particularly as a replacement for certain checkboxes, can be a valuable
     *  feature in user interfaces, regardless of a site's content or function.
     *  
     *  The icon-toggle component can have a more customized visual look than a standard
     *  checkbox, and may be initially or programmatically disabled.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */    
    public class IconToggle extends TextButton implements IStrand, IEventDispatcher, IUIBase, IMaterialIconProvider
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function IconToggle()
        {
            super();

            COMPILE::SWF
            {
                addEventListener(MouseEvent.CLICK, internalMouseHandler);
            }

            className = "";
        }

        [Bindable("change")]
        /**
         *  <code>true</code> if the Button is selected.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
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
            if (IToggleButtonModel(model).selected != value)
            {
                IToggleButtonModel(model).selected = value;
                dispatchEvent(new Event(Event.CHANGE))
            }
        }

        private var _dataMdlFor:String = "icon-toggle-1";
        /**
         *  The id value of the associated input
         *  Need to specify for display content of IconToggle
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get dataMdlFor():String
        {
            return _dataMdlFor;
        }
        public function set dataMdlFor(value:String):void
        {
            _dataMdlFor = value;

            COMPILE::JS
            {
                if (input)
                {
                    input.id = _dataMdlFor;
                }
                element.setAttribute('for', _dataMdlFor);
            }
        }

        private var _ripple:Boolean = false;
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

        private var _materialIcon:IMaterialIcon;
        /**
         *  A material icon.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get materialIcon():IMaterialIcon
        {
            return _materialIcon;
        }
        public function set materialIcon(value:IMaterialIcon):void
        {
            _materialIcon = value;

            COMPILE::JS
            {
                var icon:MaterialIconBase = (value as MaterialIconBase);
                if (icon)
                {
                    icon.iconToggleLabel = true;
                }
                
                addElement(_materialIcon);
            }
        }

        COMPILE::JS
        protected var label:HTMLLabelElement;

        COMPILE::JS
        protected var input:HTMLInputElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-icon-toggle mdl-js-icon-toggle";

            label = document.createElement("label") as HTMLLabelElement;

            element = label as WrappedHTMLElement;
            element.setAttribute('for', _dataMdlFor);

            if (_dataMdlFor)
            {
                input = document.createElement("input") as HTMLInputElement;
                input.id = _dataMdlFor;
                input.type = "checkbox";
                input.checked = false;
                input.classList.add("mdl-icon-toggle__input");
                
                label.appendChild(input);
            }
            else 
            {
                throw new Error("dataMdlFor need to be specify in order to display IconToggle");
            }
            
            positioner = element;

            (input as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;

            element.addEventListener(MouseEvent.CLICK, clickHandler, false);

            return element;
        }
                
        COMPILE::JS
        public function clickHandler(event:Event):void
        {
            event.preventDefault();
            selected = !selected;
            input.checked = selected;
            label.classList.toggle("is-checked", selected);
        }

        COMPILE::SWF
        private function internalMouseHandler(event:MouseEvent) : void
        {
            //selected = !selected;
        }
    }
}
