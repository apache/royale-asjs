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
package org.apache.flex.mdl.beads.views
{
    import org.apache.flex.core.ISelectionModel;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.html.Div;
    import org.apache.flex.html.beads.GroupView;
    import org.apache.flex.mdl.DropDownList;
    import org.apache.flex.mdl.Menu;
    import org.apache.flex.mdl.materialIcons.MaterialIcon;
    import org.apache.flex.mdl.materialIcons.MaterialIconType;
    import org.apache.flex.events.Event;

    /**
     *  The DropDownListView class creates the visual elements of the org.apache.flex.mdl.DropDownList
     *  component. The job of the view bead is to put together the parts of the DropDownList such as the Label
     *  control and material icon ARROW_DROP_DOWN to trigger the pop-up.
     *
     *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    public class DropDownListView extends GroupView
    {
        public function DropDownListView()
        {
            super();
        }

        protected var _dropDown:Menu;
        protected var _labelDisplay:Div;

        public function get dropDown():Menu
        {
            return _dropDown;
        }

        public function get labelDisplay():Div
        {
            return _labelDisplay;
        }
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            
            var dropDownList:DropDownList = (value as DropDownList);

            _dropDown = new Menu();
            _dropDown.bottom = true;

            COMPILE::JS
            {
                setIdForDisplayList();
            }
            
            _labelDisplay = new Div();

            if (!dropDownList.icon)
            {
                var dropDownIcon:MaterialIcon = new MaterialIcon();
                dropDownIcon.text = MaterialIconType.ARROW_DROP_DOWN;
                dropDownList.icon = dropDownIcon;
            }

            var model:ISelectionModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            _dropDown.model = model;

            dropDownList.addElement(_labelDisplay);
            dropDownList.addElement(dropDownList.icon);
            dropDownList.addElement(_dropDown);
        }

        override protected function handleInitComplete(event:org.apache.flex.events.Event):void
        {
            super.handleInitComplete(event);

            COMPILE::JS
            {
                host.element.classList.add("DropDownList");
            }
            _dropDown.width = isNaN(host.width) ? 100 : host.width - 1;
            _labelDisplay.width = isNaN(host.width) ? 100 : host.width - 25;
        }

        COMPILE::JS
        private function setIdForDisplayList():void
        {
            if (!host.element.id)
            {
               host.element.id = "dropDownList" + Math.random();
            }

            _dropDown.dataMdlFor = host.element.id;
        }
    }
}
