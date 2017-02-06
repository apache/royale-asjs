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
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataGridModel;
    import org.apache.flex.core.IDataGridPresentationModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.html.DataGrid;
	import org.apache.flex.html.DataGridButtonBar;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.beads.layouts.ButtonBarLayout;
	import org.apache.flex.html.beads.layouts.VerticalLayout;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.html.beads.layouts.IDataGridLayout;
	import org.apache.flex.html.beads.models.ArraySelectionModel;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	import org.apache.flex.html.supportClasses.DataGridColumnList;
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
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
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
		public function set strand(value:IStrand):void
		{
			_strand = value;

			var host:UIBase = value as UIBase;

			_header = new DataGridButtonBar();
			_header.id = "dataGridHeader";

			var scrollPort:ScrollingViewport = new ScrollingViewport();

			_listArea = new Container();
			_listArea.id = "dataGridListArea";
			_listArea.className = "DataGridListArea";
			_listArea.addBead(scrollPort);
			
			if (_strand.getBeadByType(IBeadLayout) == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
				if (c)
				{
					var layout:IBeadLayout = new c() as IBeadLayout;
					_strand.addBead(layout);
				}
			}

			finishSetup(null);
		}

		/**
		 * @private
		 */
		private function finishSetup(event:Event):void
		{
            var host:DataGrid = _strand as DataGrid;
            
			// see if there is a presentation model already in place. if not, add one.
            var presentationModel:IDataGridPresentationModel = host.presentationModel;
            var sharedModel:IDataGridModel = host.model as IDataGridModel;
			IEventDispatcher(sharedModel).addEventListener("dataProviderChanged",handleDataProviderChanged);
            IEventDispatcher(sharedModel).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);

			var columnLabels:Array = new Array();

			for(var i:int=0; i < sharedModel.columns.length; i++) {
				var dgc:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
				columnLabels.push(dgc.label);
			}

			var bblayout:ButtonBarLayout = new ButtonBarLayout();
			var buttonBarModel:ArraySelectionModel = new ArraySelectionModel();
			buttonBarModel.dataProvider = columnLabels;

			_header.addBead(buttonBarModel);
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
			var layoutBead:IDataGridLayout = _strand.getBeadByType(IBeadLayout) as IDataGridLayout;
			layoutBead.header = _header;
			layoutBead.columns = _lists;
			layoutBead.listArea = _listArea;
			layoutBead.layout();
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
			var listWidth:Number = host.width / sharedModel.columns.length;

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

				_listArea.addElement(list);
				_lists.push(list);
			}

			host.dispatchEvent(new Event("layoutNeeded"));
		}
	}
}

