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
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.DataGridButtonBar;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.layouts.ButtonBarLayout;
	import org.apache.flex.html.beads.layouts.VerticalLayout;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.beads.models.DataGridPresentationModel;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	import org.apache.flex.html.supportClasses.ScrollingViewport;
	import org.apache.flex.html.supportClasses.Viewport;

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
	public class DataGridView implements IBeadView
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

		private var _strand:IStrand;
		private var _header:DataGridButtonBar;
		private var _listArea:Container;
		
		private var _lists:Array;
		
		/**
		 * An array of List objects the comprise the columns of the DataGrid.
		 */
		public function get getColumnLists():Array
		{
			return _lists;
		}

		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			var host:UIBase = value as UIBase;
			host.addEventListener("widthChanged", handleSizeChanges);
			host.addEventListener("heightChanged", handleSizeChanges);

			_header = new DataGridButtonBar();
			_header.id = "dataGridHeader";

			var scrollPort:ScrollingViewport = new ScrollingViewport();
//			scrollPort.showsHorizontalScrollBar = false;

			_listArea = new Container();
			_listArea.id = "dataGridListArea";
			_listArea.className = "DataGridListArea";
			_listArea.addBead(scrollPort);

			finishSetup(null);
		}

		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{
			var host:UIBase = _strand as UIBase;

			// see if there is a presentation model already in place. if not, add one.
			var presentationModel:DataGridPresentationModel = _strand.getBeadByType(DataGridPresentationModel) as DataGridPresentationModel;
			if (presentationModel == null) {
				presentationModel = new DataGridPresentationModel();
				_strand.addBead(presentationModel);
			}

			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			IEventDispatcher(sharedModel).addEventListener("dataProviderChanged",handleDataProviderChanged);

			var columnLabels:Array = new Array();
			var buttonWidths:Array = new Array();

			for(var i:int=0; i < sharedModel.columns.length; i++) {
				var dgc:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
				columnLabels.push(dgc.label);
				if (!isNaN(dgc.columnWidth)) buttonWidths.push(dgc.columnWidth);
			}

			var bblayout:ButtonBarLayout = new ButtonBarLayout();
			if (buttonWidths.length == sharedModel.columns.length) {
				bblayout.buttonWidths = buttonWidths;
			}

			var buttonBarModel:ArraySelectionModel = new ArraySelectionModel();
			buttonBarModel.dataProvider = columnLabels;

			_header.addBead(buttonBarModel);
			_header.addBead(bblayout);
			_header.addBead(new Viewport());
			host.addElement(_header);

			host.addElement(_listArea);

			// do we know what the size is? If not, wait to be sized

			if (host.isHeightSizedToContent() || host.isWidthSizedToContent()) {
				host.addEventListener("sizeChanged", handleSizeChanges);
			}

				// else size now
			else {
				handleDataProviderChanged(event);
			}
		}

		/**
		 * @private
		 */
		private function handleSizeChanges(event:Event):void
		{
			var useWidth:Number = _listArea.width;
			var useHeight:Number = _listArea.height;

			if (host.width > 0) {
				useWidth = host.width;
			}

			_header.x = 0;
			_header.y = 0;
			_header.width = useWidth;
			_header.height = 25;

			if (host.height > 0) {
				useHeight = host.height - _header.height;
			}

			_listArea.x = 0;
			_listArea.y = 26;
			_listArea.width = useWidth;
			_listArea.height = useHeight;

			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;

			if (_lists != null && _lists.length > 0) {
				var xpos:Number = 0;
				var listWidth:Number = host.width / _lists.length;
				for (var i:int=0; i < _lists.length; i++) {
					var list:List = _lists[i] as List;
					list.x = xpos;
					list.y = 0;

					var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
					var colWidth:Number = dataGridColumn.columnWidth;
					if (!isNaN(colWidth)) list.width = colWidth;
					else list.width = listWidth;

					xpos += list.width;
				}
			}
		}

		/**
		 * @private
		 */
		private function handleDataProviderChanged(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;

			if (_lists == null || _lists.length == 0) {
				createLists();
			}

			for (var i:int=0; i < _lists.length; i++)
			{
				var list:List = _lists[i] as List;
				var listModel:ISelectionModel = list.getBeadByType(IBeadModel) as ISelectionModel;
				listModel.dataProvider = sharedModel.dataProvider;
			}

			handleSizeChanges(event);
		}

		/**
		 * @private
		 */
		private function handleColumnListChange(event:Event):void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var list:List = event.target as List;
			sharedModel.selectedIndex = list.selectedIndex;

			for(var i:int=0; i < _lists.length; i++) {
				if (list != _lists[i]) {
					var otherList:List = _lists[i] as List;
					otherList.selectedIndex = list.selectedIndex;
				}
			}

			IEventDispatcher(_strand).dispatchEvent(new Event('change'));
		}

		/**
		 * @private
		 */
		private function createLists():void
		{
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			var presentationModel:DataGridPresentationModel = _strand.getBeadByType(DataGridPresentationModel) as DataGridPresentationModel;
			var listWidth:Number = host.width / sharedModel.columns.length;

			_lists = new Array();

			for (var i:int=0; i < sharedModel.columns.length; i++) {
				var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;

				var list:List = new List();
				list.id = "dataGridColumn"+String(i);
				list.className = "DataGridColumn";
				list.addBead(sharedModel);
				list.itemRenderer = dataGridColumn.itemRenderer;
				list.labelField = dataGridColumn.dataField;
				list.addEventListener('change',handleColumnListChange);
				list.addBead(presentationModel);

				var colWidth:Number = dataGridColumn.columnWidth;
				if (!isNaN(colWidth)) list.width = colWidth;
				else list.width = listWidth;

				_listArea.addElement(list);
				_lists.push(list);
			}

			_listArea.dispatchEvent(new Event("layoutNeeded"));
		}
	}
}

