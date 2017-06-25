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
    import org.apache.flex.core.UIBase;
    import org.apache.flex.events.ItemAddedEvent;
    import org.apache.flex.html.DataContainer;
    import org.apache.flex.html.Select;

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
         *  @productversion FlexJS 0.8
         */
        public function DropDownList()
        {
            super();
        }

        private var _prompt:String = "";

        /**
         *  The prompt for the DropDownList control.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.9
         */
        public function get prompt():String
        {
            return _prompt;
        }

        public function set prompt(value:String):void
        {
            _prompt = value;
        }

        protected var _dropDown:Select;

        public function get dropDown():Select
        {
            return _dropDown;
        }

        public function set dropDown(value:Select):void
        {
            _dropDown = value;
        }
        
        COMPILE::JS
        {
            protected var _labelDisplay:HTMLLabelElement;

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
                var optionsCount:int = dropDown.numElements;
                
                for (var i:int = 1; i < optionsCount; i++)
                {
                   var item:UIBase = dropDown.getElementAt(i) as UIBase;
                   dropDown.removeElement(item);
                }
            }
        }

        override public function addItemRenderer(renderer:IItemRenderer):void
        {
            COMPILE::JS
            {
                dropDown.addElement(renderer);
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
