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
package org.apache.royale.jewel.beads.controls.datagrid
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.jewel.beads.views.DataGridView;
    import org.apache.royale.events.KeyboardEvent;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumnList;
    import org.apache.royale.jewel.DataGrid;
    import org.apache.royale.collections.ICollectionView;
    import org.apache.royale.jewel.itemRenderers.EditableDataGridItemRenderer;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;
    import org.apache.royale.jewel.VirtualDataGrid;
    import org.apache.royale.jewel.supportClasses.datagrid.VirtualDataGridColumnList;
    import org.apache.royale.jewel.beads.views.VirtualListView;
    import org.apache.royale.jewel.beads.views.ListView;

	/**
	 *  The DataGridNavigateItems bead class is a specialty bead that can be use with a Jewel DataGrid and VirtualDataGrid control
	 *  in conjuntion with EditableItemRenderer for navigate between cells with keyboard
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
    public class DataGridNavigateItems implements IBead
    {
		private static const KEY_ENTER:String = "Enter";
		private static const KEY_TAB:String = "Tab";

        private var dataGrid:IDataGrid;

		public function DataGridNavigateItems()
		{
			super();
		}

		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
        public function set strand(value:IStrand):void
        {
            dataGrid = value as IDataGrid;
        	dataGrid.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function onKeyDown(event:KeyboardEvent):void
        {
            if (event.key == KEY_ENTER || event.key == KEY_TAB)
            {
                var selectedColumnList:UIBase = (event.target as UIBase).parent as UIBase;
                while (!(selectedColumnList is IDataGridColumnList))
                {
                    selectedColumnList = selectedColumnList.parent as UIBase;
                }

                var dataGridView:DataGridView = ((dataGrid as DataGrid).view as DataGridView);
                var selectedColumnIndex:int = dataGridView.columnLists.indexOf(selectedColumnList);
                var dataGridItemRenderer:EditableDataGridItemRenderer;
                if (dataGrid is VirtualDataGrid)
                    dataGridItemRenderer = ((dataGridView.columnLists[selectedColumnIndex] as VirtualDataGridColumnList).view as VirtualListView).getItemRendererForIndex((dataGrid as VirtualDataGrid).selectedIndex) as EditableDataGridItemRenderer;
                else
                    dataGridItemRenderer = ((dataGridView.columnLists[selectedColumnIndex] as DataGridColumnList).view as ListView).getItemRendererForIndex((dataGrid as DataGrid).selectedIndex) as EditableDataGridItemRenderer;
                var dataProviderSize:int = ((dataGrid as DataGrid).dataProvider as ICollectionView).length;

                dataGridItemRenderer.endEditMode();

                if ((dataGrid as DataGrid).selectedIndex == dataProviderSize - 1 && (event.key == KEY_ENTER || selectedColumnIndex == dataGridView.columnLists.length - 1))
                    return;
                
                if (event.key == KEY_ENTER || selectedColumnIndex == dataGridView.columnLists.length - 1)
                    (dataGrid as DataGrid).selectedIndex++;

                if (event.key == KEY_TAB)
                {
                    if (selectedColumnIndex == dataGridView.columnLists.length - 1)
                        selectedColumnIndex = 0;
                    else
                        selectedColumnIndex++;
                }

                if (dataGrid is VirtualDataGrid)
                    dataGridItemRenderer = ((dataGridView.columnLists[selectedColumnIndex] as VirtualDataGridColumnList).view as VirtualListView).getItemRendererForIndex((dataGrid as VirtualDataGrid).selectedIndex) as EditableDataGridItemRenderer;
                else
                    dataGridItemRenderer = ((dataGridView.columnLists[selectedColumnIndex] as DataGridColumnList).view as ListView).getItemRendererForIndex((dataGrid as DataGrid).selectedIndex) as EditableDataGridItemRenderer;

                dataGridItemRenderer.goToEditMode();
            }
        }
    }
}