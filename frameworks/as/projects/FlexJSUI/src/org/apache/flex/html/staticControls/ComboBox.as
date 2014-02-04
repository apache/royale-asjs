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
package org.apache.flex.html.staticControls
{
	import org.apache.flex.core.IComboBoxModel;
	import org.apache.flex.core.UIBase;
	
	[Event(name="change", type="org.apache.flex.events.Event")]
	
	/**
	 *  The ComboBox class is a component that displays an input field and
	 *  pop-up List with selections. Selecting an item from the pop-up List
	 *  places that item into the input field of the ComboBox. The ComboBox
	 *  uses the following bead types:
	 * 
	 *  IBeadModel: the data model, which includes the dataProvider, selectedItem, and
	 *  so forth.
	 *  IBeadView:  the bead that constructs the visual parts of the component.
	 *  IBeadController: the bead that handles input and output.
	 *  IPopUp: the bead responsible for displaying the selection list.
	 *  IDataProviderItemRendererMapper: the bead responsible for creating the itemRenders.
	 *  IItemRenderer: the class or factory used to display an item in the component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ComboBox extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ComboBox()
		{
			super();
		}
		
		/**
		 *  The data for display by the ComboBox.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataProvider():Object
		{
			return IComboBoxModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			IComboBoxModel(model).dataProvider = value;
		}
		
		/**
		 *  The index of the currently selected item. Changing this item changes
		 *  the selectedItem value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedIndex():int
		{
			return IComboBoxModel(model).selectedIndex;
		}
		public function set selectedIndex(value:int):void
		{
			IComboBoxModel(model).selectedIndex = value;
		}
		
		/**
		 *  The item that is currently selected. Changing this item changes
		 *  the selectedIndex.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedItem():Object
		{
			return IComboBoxModel(model).selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			IComboBoxModel(model).selectedItem = value;
		}
				
	}
}