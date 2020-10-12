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

package spark.components.beads
{

    import mx.core.IFlexDisplayObject;
    import mx.core.IUIComponent;
    import mx.managers.PopUpManager;

    import spark.components.Button;
    import spark.components.supportClasses.DropDownListButton;
    import spark.components.DropDownList;

    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IContainer;
    import org.apache.royale.core.ILayoutChild;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.core.IStyleableObject;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IDropDownListView;
    import org.apache.royale.html.util.getLabelFromData;

    /**
     *  @private
     *  The DropDownListView for emulation.
     */
    public class DropDownListView extends SkinnableContainerView implements IDropDownListView
    {
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function DropDownListView()
        {
            super();
        }

        /**
         *  @royalesuppresspublicvarwarning
         */
        public var label:Button;

        private var selectionModel:ISelectionModel;

        /**
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            selectionModel = (value as IStrandWithModel).model as ISelectionModel;
            selectionModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
            selectionModel.addEventListener("dataProviderChanged", selectionChangeHandler);

            (value as IEventDispatcher).addEventListener("initComplete", selectionChangeHandler);

            // remove the DataGroup.  It will be the dropdown
            var chost:IContainer = host as IContainer;
            chost.strandChildren.removeElement(viewport.contentView);

            label = new DropDownListButton();
            if (selectionModel.selectedIndex == -1)
                label.label = (host as DropDownList).prompt;
            chost.strandChildren.addElement(label);


            value.addBead(new DropDownListLayout());

        }

        private function selectionChangeHandler(event:Event):void
        {
            if (selectionModel.selectedItem == null)
            {
                label.label = (host as DropDownList).prompt;
            }
            else
            {

            }
            label.label = getLabelFromData(selectionModel,selectionModel.selectedItem);
        }

        /**
         *  The dropdown/popup that displays the set of choices.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUp():IStrand
        {
            return viewport.contentView as IStrand;
        }

        private var _popUpVisible:Boolean;

        /**
         *  A flag that indicates whether the dropdown/popup is
         *  visible.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get popUpVisible():Boolean
        {
            return _popUpVisible;
        }

        /**
         *  @private
         */
        public function set popUpVisible(value:Boolean):void
        {
            if (value != _popUpVisible)
            {
                _popUpVisible = value;
                var popUpDisplayObject:IFlexDisplayObject = popUp as IFlexDisplayObject;
                if (value)
                {
                    PopUpManager.addPopUp(popUpDisplayObject, _strand);
                    (popUpDisplayObject as IStyleableObject).className = "DropDownDataGroup";
                    (popUp as IUIComponent).setActualSize((popUp as IUIComponent).width, 100);
                }
                else
                {
                    PopUpManager.removePopUp(popUpDisplayObject);
                }
            }
        }
    }

}

    import spark.components.Button;
    import spark.components.DropDownList;
    import spark.components.beads.DropDownListView;

    import org.apache.royale.core.LayoutBase;

    // this layouts out the one Label/Button.
    class DropDownListLayout extends LayoutBase
    {
        override public function layout():Boolean
        {
            var list:DropDownList = host as DropDownList;
            var view:DropDownListView = list.view as DropDownListView;
            view.label.setActualSize(list.width, list.height);

            return false;
        }
    }


