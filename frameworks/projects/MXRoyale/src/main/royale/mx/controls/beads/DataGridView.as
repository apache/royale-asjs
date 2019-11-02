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
    import mx.controls.AdvancedDataGrid;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList;
    import mx.events.CollectionEvent;
    import mx.utils.ObjectUtil;
    
    import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DataGridView;
    import org.apache.royale.html.DataGridButtonBar;
    import org.apache.royale.html.supportClasses.IDataGridColumnList;
	
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
        }		
        
        private function handleCollectionChanged(event:Event):void
        {
            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:AdvancedDataGridColumnList = columnLists[i] as AdvancedDataGridColumnList;
                list.adg = _strand as AdvancedDataGrid;
                list.model.dispatchEvent(new Event("dataProviderChanged"));
            }
            host.dispatchEvent(new Event("layoutNeeded"));
            
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
                var col:AdvancedDataGridColumn;
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
                    // introspect the first item and use its fields
                    var itmObj:Object = iterator.current;
                    for (var p:String in itmObj)
                    {
                        if (p != "uid")
                        {
                            col = new AdvancedDataGridColumn();
                            col.dataField = p;
                            newCols.push(col);
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
                        col = new AdvancedDataGridColumn();
                        col.dataField = String(colName);
                        newCols.push(col);
                    }
                }
                sharedModel.columns = newCols;
                //generatedColumns = true;
            }
        }
	}
}
