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
    import org.apache.flex.core.ISelectionModel;
    import org.apache.flex.html.Group;
    import org.apache.flex.mdl.materialIcons.IMaterialIcon;

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
    public class DropDownList extends Group
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

        private var _icon:IMaterialIcon;

        /**
         *  The data for display by the DropDownList.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
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

        /**
         *  @copy org.apache.flex.core.ISelectionModel#labelField
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get labelField():String
        {
           return ISelectionModel(model).labelField;
        }

        public function set labelField(value:String):void
        {
            ISelectionModel(model).labelField = value;
        }

        /**
         *  DropDownList material icon - default: MaterialIconType.ARROW_DROP_DOWN
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get icon():IMaterialIcon
        {
            return _icon;
        }

        public function set icon(value:IMaterialIcon):void
        {
           _icon = value;
        }
    }
}
