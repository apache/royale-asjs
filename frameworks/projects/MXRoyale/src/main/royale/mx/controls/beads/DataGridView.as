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
    import mx.collections.CursorBookmark;
    import mx.collections.ICollectionView;
    import mx.collections.IViewCursor;
    import mx.controls.DataGrid;
    import mx.controls.beads.models.DataGridPresentationModel;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.dataGridClasses.DataGridColumnList;
    import mx.controls.beads.models.DataGridColumnICollectionViewModel;
    import mx.controls.dataGridClasses.DataGridListArea;
    import mx.containers.beads.DataGridListListView;
    import mx.controls.listClasses.ListBase;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponent;
    import mx.events.ItemClickEvent;
    import mx.core.mx_internal;
    import mx.events.CollectionEvent;
    import mx.events.ListEvent;
    import mx.utils.ObjectUtil;
    import mx.core.ScrollControlBase;
    use namespace mx_internal;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.IChild;
    import org.apache.royale.core.IParent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DataGridView;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.html.DataGridButtonBar;
    import org.apache.royale.html.supportClasses.IDataGridColumnList;
    import org.apache.royale.html.supportClasses.IDataGridColumn;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.utils.getSelectionRenderBead;

COMPILE::JS{
    import goog.events.EventTarget;
}

    /**
     *  The AlertView class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DataGridView extends org.apache.royale.html.beads.DataGridView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function DataGridView()
		{
        }

        protected var columnClass:Class = DataGridColumn;
        
        public var visibleColumns:Array = [];
        
        override protected function handleInitComplete(event:Event):void
        {
            var host:IDataGrid = _strand as IDataGrid;
            
            if (host.model.columns == null && host.model.dataProvider != null)
            {
                generateCols();
            }
            
            super.handleInitComplete(event);
            
            IEventDispatcher(host).addEventListener(CollectionEvent.COLLECTION_CHANGE, handleCollectionChanged);
            if (host.model.dataProvider != null && host.model.dataProvider.length > 0)
            {
                // force update of list.adg and refresh renderers
                handleCollectionChanged(event);
            }
            else if (host.model.dataProvider == null)
            {
                IEventDispatcher(host.model).addEventListener("dataProviderChanged", handleCollectionChanged);
            }

            IEventDispatcher(host.model).addEventListener("columnsChanged", columnsChanged);
            var listBaseHost:ListBase = host as ListBase;
            if (listBaseHost) {
                if (!isNaN(listBaseHost.rowHeight))
                    header.height = listBaseHost.rowHeight;
                else
                    header.height = (listBaseHost.presentationModel as IListPresentationModel).rowHeight;
            }

            IEventDispatcher(host).addEventListener("columnsInvalid", handleColumnsInvalid);
            handleColumnsInvalid(null);

        }

        protected function columnsChanged(event:Event):void{
            if (columnLists == null) createLists()
            else recreateLists();
            handleColumnsInvalid(null);
        }

        
        protected function handleCollectionChanged(event:Event):void
        {
            if (columnLists == null) return;
            
            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:DataGridColumnList = columnLists[i] as DataGridColumnList;
                list.model.dispatchEvent(new Event("dataProviderChanged"));
            }

            host.dispatchEvent(new Event("layoutNeeded"));
        }

        protected function handleColumnsInvalid(event:Event):void
        {
            if (!columnLists) return;
            var host:ListBase = _strand as ListBase;
            udpateVisibleColumns(host);
            refreshButtonBarDataProvider(host);

            host.dispatchEvent(new Event("layoutNeeded"));
        }

        protected function udpateVisibleColumns(dataGrid:ListBase):void{
            var sharedModel:IDataGridModel = (dataGrid.model as IDataGridModel);
            columnLists.length = 0;
            visibleColumns.length = 0;
            for (var i:int=0; i < sharedModel.columns.length; i++)
            {
                var col:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
                //@todo check listeners are not already attached from previous occasion....here
                col.addEventListener("headerTextChanged", updateHeader);
                var list:DataGridColumnList = col.list as DataGridColumnList;
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
        }

        protected function refreshButtonBarDataProvider(dataGrid:ListBase):void{
            (header as DataGridButtonBar).dataProvider = visibleColumns.slice();
        }

        private function updateHeader(event:Event):void
        {
            (header as DataGridButtonBar).model.dispatchEvent(new Event("dataProviderChanged"));
        }

        /**
         *
         * @royaleignorecoercion mx.controls.DataGrid
         */
        protected function itemClickHandler(event:ListEvent):void
        {
            (_strand as DataGrid).dispatchEvent(event); // currently this doesn't clone and overwrites event.target
            //@todo this may get more of the ADG code descended for ItemEdit etc in regular DataGrid
        }
        
        /**
         * @private
         */
        override protected function handleDataProviderChanged(event:Event):void
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            if (sharedModel.columns == null && sharedModel.dataProvider != null && sharedModel.dataProvider.length > 0)
            {
                generateCols();
                createLists();
                (header as DataGridButtonBar).dataProvider = sharedModel.columns;            
            }
            if (sharedModel.columns == null)
                return;
            super.handleDataProviderChanged(event);
        }

        /**
         *  @private
         *  Searches the iterator to determine columns.
         */
        private function generateCols():void
        {
            var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
            if (sharedModel.dataProvider.length > 0)
            {
                var col:DataGridColumn;
                var newCols:Array = [];
                var cols:Array;
                if (sharedModel.dataProvider)
                {
                    var iterator:IViewCursor = sharedModel.dataProvider.createCursor();
                    //try
                    //{
                        iterator.seek(CursorBookmark.FIRST);
                    //}
                    /*
                    catch (e:ItemPendingError)
                    {
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                        e.addResponder(new ItemResponder(generateColumnsPendingResultHandler, seekPendingFailureHandler,
                            lastSeekPending));
                        iteratorValid = false;
                        return;
                    }
                        */
                    var info:Object =
                        ObjectUtil.getClassInfo(iterator.current,
                            ["uid", "mx_internal_uid"]);
                    
                    if(info)
                        cols = info.properties;
                }
                
                if (!cols)
                {
                    var index:int = 0;
                    // introspect the first item and use its fields
                    var itmObj:Object = iterator.current;

                    for (var p:String in itmObj)
                    {
                        if (p != "uid")
                        {
                            col = new columnClass() as DataGridColumn;
                            col.dataField = p;
                            newCols.push(col);
                            col.owner = _strand as UIComponent;
                            col.colNum = index++;
                        }
                    }
                }
                else
                {
                    // this is an old recordset - use its columns
                    var n:int = cols.length;
                    var colName:Object;
                    for (var i:int = 0; i < n; i++)
                    {
                        colName = cols[i];
                        if (colName is QName)
                            colName = QName(colName).localName;
                        col = new columnClass() as DataGridColumn;
                        col.dataField = String(colName);
                        col.owner = _strand as UIComponent;
                        col.colNum = i;
                        newCols.push(col);
                    }
                }
                sharedModel.columns = newCols;
                //generatedColumns = true;
            }
        }
        private var _recreatingLists:Boolean;
        protected function recreateLists():void{
            columnLists.length = 0;
            var listAreaAsParent:IParent = (listArea as IParent)
            var n:int = listAreaAsParent.numElements;
            //the lists are always below the other elements, so break as soon as we encounter something else:
            while (n!=0) {
                var list:IDataGridColumnList = listAreaAsParent.getElementAt(0) as IDataGridColumnList;
                if (list) {
                    preDestroyList(list);
                    listAreaAsParent.removeElement(list as IChild);
                } else break;
                n--;
            }
            if (listArea is DataGridListArea) DataGridListArea(listArea).resetEmpty();
            _recreatingLists = true;
            createLists();
        }

        override protected function createLists():void
        {
            var host:ListBase = _strand as ListBase;
            var sharedModel:IDataGridModel = (host.model as IDataGridModel);
            if (host.itemRenderer != null)
            {
                for (var i:int=0; i < sharedModel.columns.length; i++)
                {
                    if ((sharedModel.columns[i] as DataGridColumn).itemRenderer == null)
                        (sharedModel.columns[i] as DataGridColumn).itemRenderer = host.itemRenderer;
                }
            }
            super.createLists();
        }

        /**
         *
         * @royaleignorecoercion mx.controls.listClasses.ListBase
         * @royaleignorecoercion mx.controls.dataGridClasses.DataGridColumnList
         * @royaleignorecoercion mx.controls.dataGridClasses.DataGridColumn
         * @royaleignorecoercion org.apache.royale.core.UIBase;
         */
        override protected function onCreatedList(list:IDataGridColumnList, forColumn:IDataGridColumn):void{
            (list as DataGridColumnList).grid = _strand as ListBase;
            DataGridColumn(forColumn).list = list as UIBase;
        }

        protected function preDestroyList(list:IDataGridColumnList):void{

            COMPILE::JS{
                //@todo not sure if this is necessary?
                EventTarget(list).removeAllListeners();
            }

        }

        /**
         * Provides a place for pre-layout actions.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        override public function beforeLayout():Boolean
        {
            var check:Boolean = super.beforeLayout();
            if (_recreatingLists) {
                _recreatingLists = false;
                udpateVisibleColumns(_strand as ListBase);
            }
            return check;
        }

        private var _lastCaretIndex:int = -1;

        public function drawItem(index:int, selected:Boolean = false,
                                 highlighted:Boolean = false,
                                 caret:Boolean = false):void
        {
            var n:int = columnLists.length;
            var clearLastCaret:Boolean = caret && index != _lastCaretIndex && _lastCaretIndex > -1;
            for (var i:int = 0; i < n; i++)
            {
                var list:DataGridColumnList = columnLists[i] as DataGridColumnList;
                var view:DataGridListListView = list.view as DataGridListListView;
                var ir:IItemRenderer = view.getItemRendererForIndex(index) as IItemRenderer;
                if (ir)
                {
                    var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(ir);
                    if (selectionBead.selected != selected) selectionBead.selected = selected;
                    if (selectionBead.hovered != highlighted) selectionBead.hovered = highlighted;
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
