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
    COMPILE::JS
    {
    import goog.events;

    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    import org.apache.royale.jewel.beads.models.IDropDownListModel;
    }
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.html.elements.Select;
    import org.apache.royale.jewel.beads.models.ListPresentationModel;
    import org.apache.royale.jewel.supportClasses.container.DataContainerBase;
    import org.apache.royale.jewel.supportClasses.list.IListPresentationModel;


    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user selects an item.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The DropDownList class implements the basic equivalent of
     *  the <code>&lt;select&gt;</code> tag in HTML.
     *  The default implementation only lets the user see and
     *  choose from an array of strings.  More complex controls
     *  would display icons as well as strings, or colors instead
     *  of strings or just about anything.
     *
     *  The default behavior only lets the user choose one and
     *  only one item.  More complex controls would allow
     *  mutiple selection by not dismissing the dropdown as soon
     *  as a selection is made.
     *
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class DropDownList extends DataContainerBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function DropDownList()
		{
            super();
            typeNames = "jewel dropdownlist";
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

        [Bindable("labelFieldChanged")]
        /**
		 *  The name of field within the data used for display. Each item of the
		 *  data should have a property with this name.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get labelField():String
		{
			return IDataProviderModel(model).labelField;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function set labelField(value:String):void
		{
            IDataProviderModel(model).labelField = value;
		}

        [Bindable("dataProviderChanged")]
        /**
		 *  The data being display by the List.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
        public function get dataProvider():Object
        {
            return IDataProviderModel(model).dataProvider;
        }
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
        public function set dataProvider(value:Object):void
        {
            IDataProviderModel(model).dataProvider = value;
        }

        [Bindable("selectionChanged")]
        /**
         *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
         *
         *  @copy org.apache.royale.core.ISelectionModel#selectedIndex
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get selectedIndex():int
        {
            return ISelectionModel(model).selectedIndex;
        }

        /**
         *  @private
         *  @royaleignorecoercion HTMLSelectElement
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         *  @royaleignorecoercion org.apache.royale.jewel.beads.models.IDropDownListModel
         */
        public function set selectedIndex(value:int):void
        {
            ISelectionModel(model).selectedIndex = value;
            COMPILE::JS
            {
                value = ISelectionModel(model).selectedIndex;
                if (model is IDropDownListModel) {
                    value += IDropDownListModel(model).offset;
                }
                (element as HTMLSelectElement).selectedIndex = value;
            }
        }

        [Bindable("selectionChanged")]
        /**
         *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
         *
         *  @copy org.apache.royale.core.ISelectionModel#selectedItem
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get selectedItem():Object
        {
            return ISelectionModel(model).selectedItem;
        }

        /**
         *  @private
         *  @royaleignorecoercion HTMLSelectElement
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set selectedItem(value:Object):void
        {
            ISelectionModel(model).selectedItem = value;
            COMPILE::JS
            {
                const offset:int = model is IDropDownListModel ? IDropDownListModel(model).offset : 0;
                (element as HTMLSelectElement).selectedIndex = ISelectionModel(model).selectedIndex + offset;
            }
        }

        /**
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 */
		public function get presentationModel():IListPresentationModel
		{
			var presModel:IListPresentationModel = getBeadByType(IListPresentationModel) as IListPresentationModel;
			if (presModel == null) {
				presModel = new ListPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}


        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLSelectElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this, 'select');
            (element as HTMLSelectElement).size = 1;

            goog.events.listen(element, 'change', changeHandler);

            return element;
        }

        /**
         * @royaleignorecoercion HTMLSelectElement
         */
        COMPILE::JS
        protected function changeHandler(event:Event):void
        {
            var index:int = (element as HTMLSelectElement).selectedIndex;

            var ddModel:IDropDownListModel = model as IDropDownListModel;
            if (ddModel) {
                index -= ddModel.offset;
            }

            model.selectedIndex = index;
        }
    }
}
