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
	import org.apache.royale.core.ClassFactory;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.jewel.beads.models.DataGridPresentationModel;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel;
	
	/**
	 *  The change event is dispatched whenever the datagrid's selection changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]
	
	/**
	 * The default property uses when additional MXML content appears within an element's
	 * definition in an MXML file.
	 */
	[DefaultProperty("dataProvider")]
	
	/**
	 *  The DataGrid class displays a collection of data using columns and rows. Each
	 *  column represents a specific field in the data set; each row represents a specific
	 *  datum. The DataGrid is a composite component built with a org.apache.royale.jewel.ButtonBar 
	 *  for the column headers and a org.apache.royale.jewel.List for each column. The DataGrid's 
	 *  view bead (usually org.apache.royale.jewel.beads.views.DataGridView) constructs these parts while 
	 *  itemRenderer factories contruct the elements to display the data in each cell.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGrid extends Group implements IDataGrid, IItemRendererProvider
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGrid()
		{
			super();
			typeNames = "jewel datagrid";
		}
		
		[Bindable("columnsChanged")]
		/**
		 *  The array of org.apache.royale.jewel.supportClasses.datagrid.DataGridColumn used to 
		 *  describe each column.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function get columns():Array
		{
			return IDataGridModel(model).columns;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set columns(value:Array):void
		{
			IDataGridModel(model).columns = value;
		}
		
		/**
		 *  The object used to provide data to the org.apache.royale.jewel.DataGrid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function get dataProvider():Object
		{
			return IDataGridModel(model).dataProvider;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set dataProvider(value:Object):void
		{
			IDataGridModel(model).dataProvider = value;
		}
		
		/**
		 *  The currently selected row.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		[Bindable("selectionChanged")]
		public function get selectedIndex():int
		{
			return IDataGridModel(model).selectedIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set selectedIndex(value:int):void
		{
			IDataGridModel(model).selectedIndex = value;
		}

		[Bindable("rollOverIndexChanged")]
		/**
		 *  The index of the item currently below the pointer.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
        public function get rollOverIndex():int
		{
			return IDataGridModel(model).rollOverIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set rollOverIndex(value:int):void
		{
			IDataGridModel(model).rollOverIndex = value;
		}
		
		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
        [Bindable("selectionChanged")]
		public function get selectedItem():Object
		{
			return IDataGridModel(model).selectedItem;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		public function set selectedItem(value:Object):void
		{
			IDataGridModel(model).selectedItem = value;
		}

		/*
		* IItemRendererProvider
		*/
		
		private var _itemRenderer:IFactory = null;
		
		/**
		 *  The class or factory used to display each item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}

		/**
		 *  The DataGrid's presentation model
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IBead
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel
		 */
		public function get presentationModel():IBead
		{
			var presModel:IDataGridPresentationModel = getBeadByType(IDataGridPresentationModel) as IDataGridPresentationModel;
			if (presModel == null) {
				presModel = new DataGridPresentationModel();
				addBead(presModel);
			}
			return presModel;
		}

		/**
         *  load necesary beads. This method can be override in subclasses to
         *  add other custom beads needed, so all requested beads be loaded before
         *  signal the "beadsAdded" event.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
        override protected function loadBeads():void
        {
			// check for item renderer in css if it was not provided in code
			// this must be done before load of view bead, since we'll use the renderer at that time
			if(!itemRenderer) {
				var itemRendererClass:Class = ValuesManager.valuesImpl.getValue(this, "iItemRenderer") as Class;
				if (itemRendererClass) {
					itemRenderer = new ClassFactory(itemRendererClass);			
				}
			}

			// load view (and other) beads
			super.loadBeads();
		}
	}
}
