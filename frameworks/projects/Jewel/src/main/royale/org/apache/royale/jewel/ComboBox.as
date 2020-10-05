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
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.jewel.beads.models.ComboBoxPresentationModel;
	import org.apache.royale.jewel.supportClasses.combobox.IComboBoxPresentationModel;

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
     *  Dispatched when the popup is opened.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	[Event(name="popUpOpened", type="org.apache.royale.events.Event")]
	
	/**
     *  Dispatched when the popup is closed.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	[Event(name="popUpClosed", type="org.apache.royale.events.Event")]

	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("dataProvider")]

	/**
	 *  The ComboBox class is a component that displays an input field and
	 *  pop-up List with selections. Selecting an item from the pop-up List
	 *  places that item into the input field of the ComboBox. The ComboBox
	 *  uses the following bead types:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the component.
	 *  org.apache.royale.core.IBeadController: the bead that handles input and output.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBox extends StyledUIBase
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ComboBox()
		{
			super();

            typeNames = "jewel combobox";
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

        [Bindable("selectionChanged")]
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

        [Bindable("selectionChanged")]
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
		 *  The presentation model for the combobox.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IBead
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.combobox.IComboBoxPresentationModel
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

	}
}
