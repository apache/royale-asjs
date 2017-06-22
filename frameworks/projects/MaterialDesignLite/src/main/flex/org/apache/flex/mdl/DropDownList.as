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
    import org.apache.flex.core.IItemRenderer;
    import org.apache.flex.core.ISelectionModel;
    import org.apache.flex.events.ItemAddedEvent;
    import org.apache.flex.html.DataContainer;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;        
    }

    [Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The DropDownList class is a component that displays label field and
     *  pop-up list (MDL Menu) with selections. Selecting an item from the pop-up list
     *  places that item into the label field of the DropDownList. The DropDownList
     *  uses the following bead types:
     *
     *  org.apache.flex.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
     *  so forth.
     *  org.apache.flex.core.IBeadView:  the bead that constructs the visual parts of the component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    public class DropDownList extends DataContainer
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function DropDownList()
        {
            super();
        }

        COMPILE::JS
        protected var _labelDisplay:HTMLLabelElement;
        COMPILE::JS
        protected var _dropDown:HTMLSelectElement;

        COMPILE::JS
        {
            /**
             * @flexjsignorecoercion HTMLSelectElement
             */
            public function get dropDown():HTMLSelectElement
            {
                return _dropDown;
            }

            /**
             * @flexjsignorecoercion HTMLSelectElement
             */
            public function set dropDown(value:HTMLSelectElement):void
            {
                _dropDown = value;
            }

            /**
             * @flexjsignorecoercion HTMLLabelElement
             */
            public function get labelDisplay():HTMLLabelElement
            {
                return _labelDisplay;
            }

            /**
             * @flexjsignorecoercion HTMLLabelElement
             */
            public function set labelDisplay(value:HTMLLabelElement):void
            {
                _labelDisplay = value;
            }
        }
        
        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedIndex
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get selectedIndex():int
        {
            return ISelectionModel(model).selectedIndex;
        }
        public function set selectedIndex(value:int):void
        {
            ISelectionModel(model).selectedIndex = value;
        }

        [Bindable("change")]
        /**
         *  @copy org.apache.flex.core.ISelectionModel#selectedItem
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get selectedItem():Object
        {
            return ISelectionModel(model).selectedItem;
        }
        public function set selectedItem(value:Object):void
        {
            ISelectionModel(model).selectedItem = value;
        }

        override public function removeAllItemRenderers():void
        {
            COMPILE::JS
            {
                var options:HTMLOptionsCollection = dropDown.options;
                var optionsCount:int = options.length;

                for (var i:int = 1; i < optionsCount; i++)
                {
                   dropDown.remove(i);
                }
            }
        }

        override public function addItemRenderer(renderer:IItemRenderer):void
        {
            COMPILE::JS
            {
                dropDown.appendChild(renderer.element);
            }
            
            var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
            newEvent.item = renderer;

            dispatchEvent(newEvent);
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = 'mdl-textfield mdl-js-textfield';
            
            element = document.createElement('div') as WrappedHTMLElement;
            element.classList.add("mdl-textfield--floating-label");

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
