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
    import org.apache.flex.html.Option;
    import org.apache.flex.html.Select;
    import org.apache.flex.html.beads.DataContainerView;
    import org.apache.flex.mdl.DropDownList;
    import org.apache.flex.events.Event;

    /**
     *  The DropDownListView class creates the visual elements of the org.apache.flex.mdl.DropDownList
     *  component. The job of the view bead is to put together the parts of the DropDownList such as the Select and Label
     *
     *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    public class DropDownListView extends DataContainerView
    {
        public function DropDownListView()
        {
            super();
        }

        /**
         *  @copy org.apache.flex.core.IBead#strand
         *
         *  @flexjsignorecoercion HTMLLabelElement
         *     
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            COMPILE::JS
            {
                var dropDownList:DropDownList = (value as DropDownList);

                dropDownList.labelDisplay = document.createElement('label') as HTMLLabelElement;
                dropDownList.labelDisplay.classList.add("mdl-textfield__label");

                dropDownList.dropDown = new Select();
                dropDownList.dropDown.element.classList.add("mdl-textfield__input");

                var emptyOption:Option = new Option();
                emptyOption.element.style.display = "none";

                dropDownList.dropDown.addElement(emptyOption);
                
                setNameForDropDownList();

                dropDownList.element.appendChild(dropDownList.labelDisplay);
                dropDownList.addElement(dropDownList.dropDown);
            }
        }

        override protected function dataProviderChangeHandler(event:Event):void
        {
            super.dataProviderChangeHandler(event);

            COMPILE::JS
            {
                setProgrammaticallyChangedSelection();
            }
        }

        override protected function itemsCreatedHandler(event:org.apache.flex.events.Event):void
        {
            super.itemsCreatedHandler(event);

            COMPILE::JS
            {
                setProgrammaticallyChangedSelection();
            }
        }

        private function selectionChangeHandler(event:Event):void
        {
            COMPILE::JS
            {
                setProgrammaticallyChangedSelection();
            }
        }

        override protected function handleInitComplete(event:Event):void
        {
            super.handleInitComplete(event);
            
            dataModel.addEventListener("selectedIndexChanged", selectionChangeHandler);

            COMPILE::JS
            {
                host.element.classList.add("DropDownList");
            }
        }

        COMPILE::JS
        private function setNameForDropDownList():void
        {
            var dropDownList:DropDownList = (_strand as DropDownList);

            var name:String = "dropDownList" + Math.random();
            dropDownList.labelDisplay.htmlFor = name;
            dropDownList.dropDown.element.name = name;
        }

        COMPILE::JS
        private function setProgrammaticallyChangedSelection():void
        {
            var dropDownList:DropDownList = (_strand as DropDownList);
            var selectedIndex:int = dropDownList.dropDown.element["selectedIndex"] - 1;
            var model:ISelectionModel = dataModel as ISelectionModel;

            if (model.selectedIndex > -1 && model.dataProvider && model.selectedIndex != selectedIndex)
            {
                dropDownList.dropDown.element["selectedIndex"] = model.selectedIndex + 1;
            }
        }
    }
}