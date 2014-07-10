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
package org.apache.flex.html.beads
{	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IDataGridLayout;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.ButtonBar;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.layouts.ButtonBarLayout;
	import org.apache.flex.html.beads.layouts.DataGridLayout;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	
	/**
	 *  The DataGridView class is the visual bead for the org.apache.flex.html.DataGrid. 
	 *  This class constructs the items that make the DataGrid: Lists for each column and a 
	 *  org.apache.flex.html.ButtonBar for the column headers.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataGridView extends BeadViewBase implements IDataGridView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataGridView()
		{
		}
		
		//private var background:Shape;
		private var buttonBar:ButtonBar;
		private var buttonBarModel:ArraySelectionModel;
		private var columnContainer:Container;
		private var columns:Array;
		
		/**
		 *  The array of org.apache.flex.html.supportClasses.DataGridColumn instances.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getColumnLists():Array
		{
			return columns;
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			IEventDispatcher(sharedModel).addEventListener("dataProviderChanged",onDataProviderChanged);
			
			// create an array of columnLabels for use by the ButtonBar/DataGrid header.
			var columnLabels:Array = new Array();
			var buttonWidths:Array = new Array();
			for(var i:int=0; i < sharedModel.columns.length; i++) {
				var dgc:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
				columnLabels.push(dgc.label);
				buttonWidths.push(dgc.columnWidth);
			}
			var bblayout:ButtonBarLayout = new ButtonBarLayout();
			
			buttonBarModel = new ArraySelectionModel();
			buttonBarModel.dataProvider = columnLabels;
			
			buttonBar = new ButtonBar();
			buttonBar.addBead(buttonBarModel);
			buttonBar.addBead(bblayout);
			UIBase(_strand).addElement(buttonBar);
			
			// Create a List for each column, storing a reference to each List in
			// the columns property.
			columns = new Array();
			for(i=0; i < sharedModel.columns.length; i++) 
			{
				// Each list shares the same dataProvider but needs its own model to
				// keep track of its own data.
				var listModel:ISelectionModel = new ArraySelectionModel();
				listModel.dataProvider = sharedModel.dataProvider;
				
				var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
				
				var list:List = new List();
				list.addBead(listModel); 
				list.itemRenderer = dataGridColumn.itemRenderer;
				list.labelField = dataGridColumn.dataField;
				
				var colWidth:Number = dataGridColumn.columnWidth;
				if (!isNaN(colWidth)) list.width = colWidth;

				UIBase(_strand).addElement(list);
				columns.push(list);
				list.addEventListener('change',columnListChangeHandler);
				list.addEventListener('rollover',columnListRollOverHandler);
			}
			
			// TODO: allow a developer to specify their own DataGridLayout
			// possibly by seeing if a bead already exists
			
			var bead:IBead = _strand.getBeadByType(IDataGridLayout);
			var layout:IDataGridLayout;
			if (bead == null) {
				// NOTE: the following line will not cross-compile correctly into JavaScript
				// so it has been commented and the class hard-coded.
				//layout = new ValuesManager.valuesImpl.getValue(_strand, "iBeadLayout")) as IDataGridLayout;
				layout = new DataGridLayout();
				_strand.addBead(layout);
			} else {
				layout = bead as IDataGridLayout;
			}
			layout.header = buttonBar;
			layout.columns = columns;
			
			IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
		}
		
		/**
		 * @private
		 * When the dataProvider is changed for the DataGrid, this updates each List (column)
		 * with the new (or changed) dataProvider.
		 */
		private function onDataProviderChanged(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			
			for (var i:int=0; i < columns.length; i++)
			{
				var list:List = columns[i] as List;
				var listModel:ISelectionModel = list.getBeadByType(IBeadModel) as ISelectionModel;
				listModel.dataProvider = sharedModel.dataProvider;
			}
		}
		
		/**
		 * @private
		 */
		private function columnListChangeHandler(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var list:List = event.target as List;
			sharedModel.selectedIndex = list.selectedIndex;
			
			for(var i:int=0; i < columns.length; i++) {
				if (list != columns[i]) {
					var otherList:List = columns[i] as List;
					otherList.selectedIndex = list.selectedIndex;
				}
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event('change'));
		}
		
		/**
		 * @private
		 */
		private function columnListRollOverHandler(event:Event):void
		{
			var list:List = event.target as List;
			if (list == null) return;
			for(var i:int=0; i < columns.length; i++) {
				if (list != columns[i]) {
					var otherList:List = columns[i] as List;
					otherList.rollOverIndex = list.rollOverIndex;
				}
			}
			
			IEventDispatcher(_strand).dispatchEvent(new Event('rollOver'));
		}
	}
}
