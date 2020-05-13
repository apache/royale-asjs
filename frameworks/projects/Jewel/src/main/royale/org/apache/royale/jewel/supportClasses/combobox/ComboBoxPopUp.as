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
package org.apache.royale.jewel.supportClasses.combobox
{
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IPopUp;
    import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.jewel.beads.models.ComboBoxPresentationModel;
    
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  @copy org.apache.royale.core.ISelectionModel#change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
    [Event(name="change", type="org.apache.royale.events.Event")]
    
    /**
     *  The ComboBoxPopUp class is the popup that holds the List used internally
     *  by ComboBox as the dropdown/popup.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class ComboBoxPopUp extends StyledUIBase implements IPopUp
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function ComboBoxPopUp()
		{
			super();
            typeNames = "combobox-popup";
        }
		
        /**
		 *  The data for display by the ComboBox.
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

        [Bindable("change")]
		/**
		 *  The index of the currently selected item. Changing this item changes
		 *  the selectedItem value.
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
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedIndex(value:int):void
		{
			ISelectionModel(model).selectedIndex = value;
		}

        [Bindable("change")]
		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
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
		public function set selectedItem(value:Object):void
		{
			ISelectionModel(model).selectedItem = value;
		}

		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get rowHeight():Number
        {
            return (presentationModel as IComboBoxPresentationModel).rowHeight;
        }
        public function set rowHeight(value:Number):void
        {
            (presentationModel as IComboBoxPresentationModel).rowHeight = value;
        }

		/**
		 *  Maximum number of rows visible in the ComboBox popup list.
		 *  If there are fewer items in the dataProvider, the ComboBox shows only as many items as there are in the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get rowCount():int
        {
            return (presentationModel as IComboBoxPresentationModel).rowCount;
        }
        public function set rowCount(value:int):void
        {
            (presentationModel as IComboBoxPresentationModel).rowCount = value;
        }

		/**
		 *  The presentation model for the list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 */
		public function get presentationModel():IComboBoxPresentationModel
		{
			var presModel:IComboBoxPresentationModel = getBeadByType(IComboBoxPresentationModel) as IComboBoxPresentationModel;
			if (presModel == null) {
				presModel = new ComboBoxPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}

		/**
		 *  Used in the ComboBoxPopUp to configure user defined renderers for the popup list
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 * 
		 *  @royalesuppresspublicvarwarning
		 */
		public var itemRendererClass:Class;
	}
}
