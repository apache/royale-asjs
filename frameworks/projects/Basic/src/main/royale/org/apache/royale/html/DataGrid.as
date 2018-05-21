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
package org.apache.royale.html
{
	import org.apache.royale.core.GroupBase;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChangePropagator;
	import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IDataGridPresentationModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.models.DataGridPresentationModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	[Event(name="change", type="org.apache.royale.events.Event")]
	
	/**
	 *  The DataGrid class displays a collection of data using columns and rows. Each
	 *  column represents a specific field in the data set; each row represents a specific
	 *  datum. The DataGrid is a composite component built with a org.apache.royale.html.ButtonBar 
	 *  for the column headers and a org.apache.royale.html.List for each column. The DataGrid's 
	 *  view bead (usually org.apache.royale.html.beads.DataGridView) constructs these parts while 
	 *  itemRenderer factories contruct the elements to display the data in each cell.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGrid extends GroupBase implements IDataGrid
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGrid()
		{
			super();
			
			typeNames = "DataGrid";
			
			// set a reasonable default size
			width = 200;
			height = 200;
		}
		
		/**
		 *  The array of org.apache.royale.html.supportClasses.DataGridColumns used to 
		 *  describe each column.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
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
		 *  The object used to provide data to the org.apache.royale.html.DataGrid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
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
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 */
		[Bindable("change")]
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
		
		/**
		 * @private
		 */
		private var _presentationModel:IDataGridPresentationModel;
		
		/**
		 *  The DataGrid's presentation model
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
		 *  @royaleignorecoercion org.apache.royale.core.IBead
		 */
		public function get presentationModel():IBead
		{
			if (_presentationModel == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(this, "iDataGridPresentationModel");
				if (c) {
					_presentationModel = new c() as IDataGridPresentationModel;
					addBead(_presentationModel as IBead);
				}
			}
			
			return _presentationModel;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
		 */
		public function set presentationModel(value:IBead):void
		{
			_presentationModel = value as IDataGridPresentationModel;
		}
				
		/**
		 *  The default height of each cell in every column
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
		 */
		public function get rowHeight():Number
		{
			return (presentationModel as IDataGridPresentationModel).rowHeight;
		}
        /**
         * @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
         */
		public function set rowHeight(value:Number):void
		{
			(presentationModel as IDataGridPresentationModel).rowHeight = value;
		}
		
		override public function addedToParent():void
		{
			loadBeadFromValuesManager(IChangePropagator, "iChangePropagator", this);
			super.addedToParent();
			dispatchEvent(new Event("initComplete"));
		}
	}
}
