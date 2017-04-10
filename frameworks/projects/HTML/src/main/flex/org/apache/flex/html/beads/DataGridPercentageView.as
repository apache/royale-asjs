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
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.IDataGridPresentationModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.DataGrid;
	import org.apache.flex.html.DataGridButtonBar;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.beads.layouts.ButtonBarLayout;
	import org.apache.flex.html.beads.models.ButtonBarModel;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	import org.apache.flex.html.supportClasses.DataGridColumnList;
	import org.apache.flex.html.supportClasses.Viewport;
	
	COMPILE::SWF {
		import org.apache.flex.core.SimpleCSSStyles;
	}

	/**
	 *  The DataGridPercentageView class is the visual bead for the org.apache.flex.html.DataGrid.
	 *  This class constructs the items that make the DataGrid: Lists for each column and a
	 *  org.apache.flex.html.ButtonBar for the column headers. This class interprets the
	 *  columnWidth value of each column to be a percentage rather than a pixel value.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataGridPercentageView extends GroupView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataGridPercentageView()
		{
			super();
		}

		private var _strand:IStrand;
		private var _header:DataGridButtonBar;
		private var _listArea:Container;
		
		private var _lists:Array;
		
		/**
		 * An array of List objects the comprise the columns of the DataGrid.
		 */
		public function get columnLists():Array
		{
			return _lists;
		}
		
		/**
		 * The area used to hold the columns
		 *
		 */
		public function get listArea():Container
		{
			return _listArea;
		}
		
		/**
		 * Returns the component used as the header for the DataGrid.
		 */
		public function get header():IUIBase
		{
			return _header;
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
			_strand = value;

			var host:DataGrid = value as DataGrid;

			_header = new DataGridButtonBar();
			_header.height = 30;
			_header.percentWidth = 100;

			_listArea = new Container();
			_listArea.percentWidth = 100;
			_listArea.className = "DataGridListArea";
			
			COMPILE::SWF {
				_header.style = new SimpleCSSStyles();
				_header.style.flexGrow = 0;
				
				_listArea.style = new SimpleCSSStyles();
				_listArea.style.flexGrow = 1;
			}
			COMPILE::JS {
				_header.element.style["flex-grow"] = "0";
				_header.element.style["min-height"] = "30px";
				_listArea.element.style["flex-grow"] = "1";
			}
			
			IEventDispatcher(_strand).addEventListener("initComplete", finishSetup);
		}

		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{
			var host:DataGrid = _strand as DataGrid;
			
			if (_lists == null || _lists.length == 0) {
				createLists();
			}

			// see if there is a presentation model already in place. if not, add one.
			var presentationModel:IDataGridPresentationModel = host.presentationModel;
			var sharedModel:IDataGridModel = host.model as IDataGridModel;
			IEventDispatcher(sharedModel).addEventListener("dataProviderChanged",handleDataProviderChanged);
			IEventDispatcher(sharedModel).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);

			var columnLabels:Array = new Array();
			var buttonWidths:Array = new Array();

			for(var i:int=0; i < sharedModel.columns.length; i++) {
				var dgc:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
				columnLabels.push(dgc.label);
				var colWidth:Number = dgc.columnWidth;
				buttonWidths.push(colWidth);
				
				var list:DataGridColumnList = _lists[i] as DataGridColumnList;
				if (!isNaN(colWidth)) {
					list.percentWidth = Number(colWidth);
				} else {
					COMPILE::SWF {
						list.style = new SimpleCSSStyles();
						list.style.flexGrow = 1;
					}
						COMPILE::JS {
							list.element.style["flex-grow"] = "1";
						}
				}
			}

			var bblayout:ButtonBarLayout = new ButtonBarLayout();
			_header.buttonWidths = buttonWidths
			_header.widthType = ButtonBarModel.PERCENT_WIDTHS;
			_header.dataProvider = columnLabels;
			_header.addBead(bblayout);
			_header.addBead(new Viewport());
			host.addElement(_header);

			host.addElement(_listArea);

			handleDataProviderChanged(event);
		}

		/**
		 * @private
		 */
		private function handleSizeChanges(event:Event):void
		{	
			_header.dispatchEvent(new Event("layoutChanged"));
			_listArea.dispatchEvent(new Event("layoutChanged"));
		}

		/**
		 * @private
		 */
		private function handleDataProviderChanged(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;

			for (var i:int=0; i < _lists.length; i++)
			{
				var list:DataGridColumnList = _lists[i] as DataGridColumnList;
				var listModel:ISelectionModel = list.getBeadByType(IBeadModel) as ISelectionModel;
				listModel.dataProvider = sharedModel.dataProvider;
			}

			host.dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		private function handleSelectedIndexChanged(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var newIndex:int = sharedModel.selectedIndex;
			
			for (var i:int=0; i < _lists.length; i++)
			{
				var list:DataGridColumnList = _lists[i] as DataGridColumnList;
				list.selectedIndex = newIndex;
			}
		}

		/**
		 * @private
		 */
		private function handleColumnListChange(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var list:DataGridColumnList = event.target as DataGridColumnList;
			sharedModel.selectedIndex = list.selectedIndex;

			for(var i:int=0; i < _lists.length; i++) {
				if (list != _lists[i]) {
					var otherList:DataGridColumnList = _lists[i] as DataGridColumnList;
					otherList.selectedIndex = list.selectedIndex;
				}
			}

			host.dispatchEvent(new Event('change'));
		}

		/**
		 * @private
		 */
		private function createLists():void
		{
			var host:DataGrid = _strand as DataGrid;
			
			var sharedModel:IDataGridModel = host.model as IDataGridModel;
			var presentationModel:IDataGridPresentationModel = host.presentationModel;

			_lists = new Array();

			for (var i:int=0; i < sharedModel.columns.length; i++) {
				var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;

				var list:DataGridColumnList = new DataGridColumnList();
				list.id = "dataGridColumn"+String(i);
				list.addBead(sharedModel);
				list.itemRenderer = dataGridColumn.itemRenderer;
				list.labelField = dataGridColumn.dataField;
				list.addEventListener('change',handleColumnListChange);
				list.addBead(presentationModel);
				
				if (i == 0) {
					list.className = "first";
				} else if (i == sharedModel.columns.length-1) {
					list.className = "last";
				} else {
					list.className = "middle";
				}

				_listArea.addElement(list);
				_lists.push(list);
			}

			host.dispatchEvent(new Event("layoutNeeded"));
		}
	}
}

