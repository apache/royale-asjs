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
package org.apache.royale.html.beads
{
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
    import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IDataGridPresentationModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.DataGridButtonBar;
	import org.apache.royale.html.beads.layouts.ButtonBarLayout;
	import org.apache.royale.html.supportClasses.IDataGridColumnList;
	import org.apache.royale.html.supportClasses.IDataGridColumn;
	import org.apache.royale.html.supportClasses.Viewport;

		/**
		 *  The DataGridView class is the visual bead for the org.apache.royale.html.DataGrid.
		 *  This class constructs the items that make the DataGrid: Lists for each column and a
		 *  org.apache.royale.html.ButtonBar for the column headers.
		 *
		 *  @viewbead
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public class DataGridView extends GroupView implements IBeadView, IDataGridView
		{
			/**
			 *  constructor.
			 *
			 *  @langversion 3.0
			 *  @playerversion Flash 10.2
			 *  @playerversion AIR 2.6
			 *  @productversion Royale 0.9
			 */
			public function DataGridView()
			{
				super();
			}

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

            public function refreshContent():void
            {
                handleInitComplete(null);
            }

			/**
			 * @private
			 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
			 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
			 * @royaleignorecoercion org.apache.royale.core.IBead
			 * @royaleignorecoercion org.apache.royale.core.IBeadModel
			 * @royaleignorecoercion org.apache.royale.core.IChild
			 * @royaleignorecoercion org.apache.royale.html.DataGrid
			 */
			override protected function handleInitComplete(event:Event):void
			{
				var host:IDataGrid = _strand as IDataGrid;

				// see if there is a presentation model already in place. if not, add one.
				var sharedModel:IDataGridModel = host.model as IDataGridModel;
				IEventDispatcher(sharedModel).addEventListener("dataProviderChanged",handleDataProviderChanged);
				IEventDispatcher(sharedModel).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);

				_header = new DataGridButtonBar();
				// header's height is set in CSS
				_header.percentWidth = 100;
				_header.dataProvider = sharedModel.columns;
				_header.labelField = "label";
				sharedModel.headerModel = _header.model as IBeadModel;

				_listArea = new DataGridListArea();
				_listArea.percentWidth = 100;

				createLists();

				var bblayout:ButtonBarLayout = new ButtonBarLayout();
				_header.addBead(bblayout as IBead);
				_header.addBead(new Viewport() as IBead);
				host.strandChildren.addElement(_header as IChild);

				host.strandChildren.addElement(_listArea as IChild);

				handleDataProviderChanged(event);

				host.addEventListener("widthChanged", handleSizeChanges);
				host.addEventListener("heightChanged", handleSizeChanges);

				host.dispatchEvent(new Event("dataGridViewCreated"));
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
                    var list:IDataGridColumnList = _lists[i] as IDataGridColumnList;
                    list.dataProvider = sharedModel.dataProvider;
                }
				host.dispatchEvent(new Event("layoutNeeded"));
			}

			/**
			 * @private
			 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
			 * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumnList
			 */
			private function handleSelectedIndexChanged(event:Event):void
			{
				var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
				var newIndex:int = sharedModel.selectedIndex;

				for (var i:int=0; i < _lists.length; i++)
				{
					var list:IDataGridColumnList = _lists[i] as IDataGridColumnList;
					list.selectedIndex = newIndex;
				}
			}

			/**
			 * @private
			 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
			 * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumnList
			 */
			private function handleColumnListChange(event:Event):void
			{
				var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
				var list:IDataGridColumnList = event.target as IDataGridColumnList;
				sharedModel.selectedIndex = list.selectedIndex;

				for(var i:int=0; i < _lists.length; i++) {
					if (list != _lists[i]) {
						var otherList:IDataGridColumnList = _lists[i] as IDataGridColumnList;
						otherList.selectedIndex = list.selectedIndex;
					}
				}

				host.dispatchEvent(new Event('change'));
			}

			/**
			 * @private
			 * @royaleignorecoercion String
			 * @royaleignorecoercion Class
			 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
			 * @royaleignorecoercion org.apache.royale.core.IBead
			 * @royaleignorecoercion org.apache.royale.core.IChild
			 * @royaleignorecoercion org.apache.royale.core.IDataGrid
			 * @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
			 * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumn
			 */
			private function createLists():void
			{
				var host:IDataGrid = _strand as IDataGrid;
				
				// get the name of the class to use for the columns
				var columnClass:Class = ValuesManager.valuesImpl.getValue(host, "columnClass") as Class;
				assert(columnClass != null,"ColumnClass for DataGrid must be set!")

				var sharedModel:IDataGridModel = host.model as IDataGridModel;
				var presentationModel:IDataGridPresentationModel = host.presentationModel as IDataGridPresentationModel;

				_lists = [];

				for (var i:int=0; i < sharedModel.columns.length; i++)
				{
					var dataGridColumn:IDataGridColumn = sharedModel.columns[i] as IDataGridColumn;

					var list:IDataGridColumnList = new columnClass();
					
					if (i == 0)
					{
						list.className = "first";
					}
					else if (i == sharedModel.columns.length-1)
					{
						list.className = "last";
					}
					else
					{
						list.className = "middle";
					}
					
					list.id = "dataGridColumn" + i;
					list.dataProvider = sharedModel.dataProvider;
					list.itemRenderer = dataGridColumn.itemRenderer;
					list.labelField = dataGridColumn.dataField;
					list.addEventListener('change',handleColumnListChange);
					list.addBead(presentationModel as IBead);

					_listArea.addElement(list as IChild);
					_lists.push(list);
				}

				host.dispatchEvent(new Event("layoutNeeded"));
			}
		}
}

