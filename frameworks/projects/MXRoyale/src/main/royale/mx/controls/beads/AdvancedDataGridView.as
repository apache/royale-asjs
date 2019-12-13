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
package mx.controls.beads
{
    import mx.controls.beads.models.DataGridColumnICollectionViewModel;

    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.DataGridButtonBar;
    
    import mx.events.CollectionEvent;
    import mx.events.ItemClickEvent;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
    import mx.controls.AdvancedDataGrid;
	
    import mx.core.mx_internal;
    use namespace mx_internal;

    /**
     *  The AlertView class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AdvancedDataGridView extends DataGridView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AdvancedDataGridView()
		{
        }

        override protected function handleInitComplete(event:Event):void
        {
            super.handleInitComplete(event);
            
            var host:AdvancedDataGrid = _strand as AdvancedDataGrid;
            if (!isNaN(host.rowHeight))
                header.height = host.rowHeight;
            else
                header.height = (host.presentationModel as IListPresentationModel).rowHeight;
            
            IEventDispatcher(host).addEventListener("columnsInvalid", handleColumnsInvalid);
            handleColumnsInvalid(null);
        }		
        
        private function handleColumnsInvalid(event:Event):void
        {
            if (!columnLists) return;
            
            var host:IDataGrid = _strand as IDataGrid;
            var sharedModel:IDataGridModel = (host.model as IDataGridModel);
            
            var visibleColumns:Array = [];
            columnLists.length = 0;
            for (var i:int=0; i < sharedModel.columns.length; i++)
            {
                var col:AdvancedDataGridColumn = sharedModel.columns[i] as AdvancedDataGridColumn;
                col.addEventListener("headerTextChanged", updateHeader);
                var list:AdvancedDataGridColumnList = col.list as AdvancedDataGridColumnList;
                var adgColumnListModel:DataGridColumnICollectionViewModel = list.getBeadByType(DataGridColumnICollectionViewModel) as DataGridColumnICollectionViewModel;
                adgColumnListModel.columnIndex = i;
                list.visible = col.visible;
                list.addEventListener(ItemClickEvent.ITEM_CLICK, itemClickHandler);
                if (list.visible)
                {
                    visibleColumns.push(sharedModel.columns[i]);
                    columnLists.push(list);
                }
            }
            (header as DataGridButtonBar).dataProvider = visibleColumns;
            
            host.dispatchEvent(new Event("layoutNeeded"));
        }
        
        private function updateHeader(event:Event):void
        {
            (header as DataGridButtonBar).model.dispatchEvent(new Event("dataProviderChanged"));
        }
        
        private function itemClickHandler(event:ItemClickEvent):void
        {
            host.dispatchEvent(event);
        }
        
        override protected function createLists():void
        {
            super.createLists();
            var host:IDataGrid = _strand as IDataGrid;
            var sharedModel:IDataGridModel = (host.model as IDataGridModel);
            
            for (var i:int=0; i < sharedModel.columns.length; i++)
            {
                (sharedModel.columns[i] as AdvancedDataGridColumn).list = columnLists[i];
            }
        }

	}
}
