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
    import mx.containers.beads.AdvancedDataGridListVirtualListView;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.DataGrid;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
    import mx.controls.listClasses.ListBase;
    import mx.controls.beads.models.DataGridColumnICollectionViewModel;
    import mx.core.mx_internal;
    import mx.events.AdvancedDataGridEvent;
    import mx.events.CollectionEvent;
    import mx.events.ItemClickEvent;
    import mx.events.ListEvent;
    
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IItemRenderer;
  //  import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.DataGridButtonBar;
    import org.apache.royale.utils.getSelectionRenderBead;

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
            columnClass = AdvancedDataGridColumn;
        }

        override protected function handleInitComplete(event:Event):void
        {

/*            var host:AdvancedDataGrid = _strand as AdvancedDataGrid;
            if (!isNaN(host.rowHeight))
                header.height = host.rowHeight;
            else
                header.height = (host.presentationModel as IListPresentationModel).rowHeight;*/

            super.handleInitComplete(event);
        }		
        
        override protected function handleCollectionChanged(event:Event):void
        {
            if (columnLists == null) return;
            
            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:AdvancedDataGridColumnList = columnLists[i] as AdvancedDataGridColumnList;
                list.grid = _strand as AdvancedDataGrid;
                list.model.dispatchEvent(new Event("dataProviderChanged"));
            }
            host.dispatchEvent(new Event("layoutNeeded"));
            
        }



        /**
         *
         * @royaleignorecoercion mx.controls.AdvancedDataGrid
         */
        override protected function refreshButtonBarDataProvider(dataGrid:ListBase):void{
            var host:AdvancedDataGrid = dataGrid as AdvancedDataGrid;
            if (host.groupedColumns != null)
            {
                var groupedColumns:Array = [];
                for (var i:uint = 0; i < host.groupedColumns.length; i++)
                {
                    if ((host.groupedColumns[i] as AdvancedDataGridColumn).visible)
                        groupedColumns.push(host.groupedColumns[i]);
                }
                (header as DataGridButtonBar).dataProvider = groupedColumns;
            } else super.refreshButtonBarDataProvider(dataGrid)
        }

        
       /* private function updateHeader(event:Event):void
        {
            (header as DataGridButtonBar).model.dispatchEvent(new Event("dataProviderChanged"));
        }*/
        
        override protected function itemClickHandler(event:ListEvent):void
        {
			var target:AdvancedDataGridColumnList = event.target as AdvancedDataGridColumnList;
            super.itemClickHandler(event);
            var host:AdvancedDataGrid = _strand as AdvancedDataGrid;
			if (host.editable)
			{
	            for (var i:int = 0; i < columnLists.length; i++)
	            {
	                var list:AdvancedDataGridColumnList = columnLists[i] as AdvancedDataGridColumnList;
	                if (target == list && visibleColumns[i].editable)
					{
	                    var advancedDataGridEvent:AdvancedDataGridEvent =
	                        new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING, false, true);
	                    // ITEM_EDIT events are cancelable
	                    advancedDataGridEvent.columnIndex = i;
	                    advancedDataGridEvent.dataField = visibleColumns[i].dataField;
	                    advancedDataGridEvent.rowIndex = event.rowIndex;
	                    host.dispatchEvent(advancedDataGridEvent);
						break;
					}
				}
			}
        }


        private var _lastCaretIndex:int = -1;

        override public function drawItem(index:int, selected:Boolean = false,
                                    highlighted:Boolean = false,
                                    caret:Boolean = false):void
        {
            var n:int = columnLists.length;
            var clearLastCaret:Boolean = caret && index != _lastCaretIndex && _lastCaretIndex > -1;
            for (var i:int = 0; i < n; i++)
            {
                var list:AdvancedDataGridColumnList = columnLists[i] as AdvancedDataGridColumnList;
                var view:AdvancedDataGridListVirtualListView = list.view as AdvancedDataGridListVirtualListView;
                var ir:IItemRenderer = view.getItemRendererForIndex(index) as IItemRenderer;
                if (ir)
                {
                    var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(ir);
                    //these following two might not be needed here:
                    selectionBead.selected = selected;
                    selectionBead.hovered = highlighted;
                    COMPILE::JS
                    {
                    if (caret)
                        (ir as UIBase).element.style.border = "1px solid #000";
                    else
                        (ir as UIBase).element.style.border = "none";
                    }                        
                }

                if (clearLastCaret) {
                    ir = view.getItemRendererForIndex(_lastCaretIndex) as IItemRenderer;
                    if (ir)
                    {
                        COMPILE::JS
                        {
                            (ir as UIBase).element.style.border = "none";
                        }
                    }
                }
            }
            if (caret) _lastCaretIndex = index;
        }


	}
}
