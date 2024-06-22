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
package org.apache.royale.jewel.beads.views
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.IDataGridHeader;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.LabelFunction;
	import org.apache.royale.jewel.beads.models.DataGridColumnListPresentationModel;
	import org.apache.royale.jewel.beads.models.IJewelSelectionModel;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel;
	import org.apache.royale.utils.IEmphasis;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.observeElementSize;
    
    /**
     *  The DataGridView class is the visual bead for the org.apache.royale.jewel.DataGrid.
     *  This class constructs the items that make the DataGrid: Lists for each column and a
     *  org.apache.royale.jewel.ButtonBar for the column headers.
     * 
     *  Columns without specific columnWidths gets 1/n of the maximun space available where n is the
     *  number of columns.
     *
     *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public class DataGridView extends GroupView implements IBeadView, IDataGridView, IScrollToIndexView
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function DataGridView()
        {
            super();
        }

        protected var _dg:IDataGrid = _strand as IDataGrid;
        private var _header:IDataGridHeader;
        private var _listArea:IUIBase;
        private var _lists:Array = [];

        protected var sharedModel:IDataGridModel;

        override public function set strand(value:IStrand):void
		{
			super.strand = value;

            _dg = _strand as IDataGrid;
            _presentationModel = _dg.presentationModel as IDataGridPresentationModel;
            
            // see if there is a presentation model already in place. if not, add one.
            sharedModel = _dg.model as IDataGridModel;
            IEventDispatcher(sharedModel).addEventListener("dataProviderChanged", handleDataProviderChanged);
            IEventDispatcher(sharedModel).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);

            listenOnStrand("initComplete", initCompleteHandler);

            createChildren();
		}

        private var _presentationModel:IDataGridPresentationModel;

        /**
		 * @private
		 */
		protected function createChildren():void
		{
            // header
            var headerClass:Class = ValuesManager.valuesImpl.getValue(host, "headerClass") as Class;
            _header = new headerClass() as IDataGridHeader;
            _header.dataProvider = new ArrayList(sharedModel.columns);
            (_header as IEmphasis).emphasis = (_dg as IEmphasis).emphasis;
            _header.labelField = "label";
            
            var headerLayoutClass:Class = ValuesManager.valuesImpl.getValue(host, "headerLayoutClass") as Class;
            var bblayout:IBead = new headerLayoutClass() as IBeadLayout;
            _header.addBead(bblayout /*as IBead*/);
            sharedModel.headerModel = _header.model as IBeadModel;
            _dg.strandChildren.addElement(_header as IChild);

            // columns
            var listAreaClass:Class = ValuesManager.valuesImpl.getValue(host, "listAreaClass") as Class;
            _listArea = new listAreaClass() as IUIBase;
            (_listArea as StyledUIBase).tabIndex = 0;
            _dg.strandChildren.addElement(_listArea as IChild);

            if (sharedModel.columns)
                createLists();

            COMPILE::JS{
                observeElementSize(_listArea.element, onInternalSizeChange);
                _listArea.element.addEventListener('scroll', synchHScroll)
            }
        }

		/**
		 *  Ensures that the data provider item at the given index is visible.
		 *  
		 *  If the item is visible, the <code>verticalScrollPosition</code>
		 *  property is left unchanged even if the item is not the first visible
		 *  item. If the item is not currently visible, the 
		 *  <code>verticalScrollPosition</code>
		 *  property is changed make the item the first visible item, unless there
		 *  aren't enough rows to do so because the 
		 *  <code>verticalScrollPosition</code> value is limited by the 
		 *  <code>maxVerticalScrollPosition</code> property.
		 *
		 *  @param index The index of the item in the data provider.
		 *
		 *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.10
		 */
		public function scrollToIndex(index:int):Boolean
		{
			COMPILE::JS {
				if (index == -1) return false;
			
				var scrollArea:HTMLElement = listArea.element;
				var oldScroll:Number = scrollArea.scrollTop;

				var rowHeight:Number = _presentationModel.rowHeight;
				var totalHeight:Number = sharedModel.dataProvider.length * rowHeight - scrollArea.clientHeight;
            
				scrollArea.scrollTop = Math.min(index * rowHeight, totalHeight);

				return oldScroll != scrollArea.scrollTop;
			}
			COMPILE::SWF {
 				return false;
			}
		}

        /**
         * @private
         */
        protected function handleColumnsChanged(event:Event):void
        {
            if (this.columnLists.length) {
                destroyLists();

                createLists();

                //@todo the following sequence all needs to be refactored somehow.
                this.sharedModel.headerModel['buttonWidths'] = null;

                var arrayList:ArrayList = new ArrayList();
                //a) set an empty ArrayList to empty the buttonBar
                (sharedModel.headerModel as IDataProviderModel).dataProvider = arrayList;
                //b) set the source to match the columns (but don't do layout yet)
                arrayList.source = sharedModel.columns;
                //c) trigger dataProviderChange from the DataGrid
                handleDataProviderChanged(event);
                //d) now refresh the buttonbar view
                (sharedModel.headerModel as IDataProviderModel).dataProvider = new ArrayList(sharedModel.columns);
            }

        }

        private var ignoreSizeChange:Boolean;
        COMPILE::JS
        protected function onInternalSizeChange():void{
            if (ignoreSizeChange) return;
            //check for vertical scrollbar presence
            _header.dispatchEvent(new Event("headerLayout"));
        }

        COMPILE::JS
        protected function synchHScroll(event:Event):void{
            _header.element.scrollLeft = _listArea.element.scrollLeft;
            if (!event) {
                _header.dispatchEvent(new Event("headerLayoutReset"));
                _header.dispatchEvent(new Event("layoutNeeded"));
            }
        }
        /**
         * @private
         * @royaleignorecoercion Class
         * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.core.IChild
         * @royaleignorecoercion org.apache.royale.core.IParent
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         * @royaleignorecoercion org.apache.royale.jewel.beads.models.DataGridColumnListPresentationModel
         */
        protected function createLists():void
        {
            var len:uint = sharedModel.columns.length;
            for (var i:int=0; i < len; i++)
            {
                ignoreSizeChange = i != len-1;
                var dataGridColumn:IDataGridColumn = sharedModel.columns[i] as IDataGridColumn;
                IEventDispatcher(dataGridColumn).addEventListener("labelChanged", labelChangedHandler);
                IEventDispatcher(dataGridColumn).addEventListener("itemRendererChanged", itemRendererChangedHandler);

                var list:IDataGridColumnList = createColumnList(i, len, dataGridColumn);

                (_listArea as IParent).addElement(list as IChild);

                columnLists.push(list);
            }
        }

        /**
         * set the height of the column if necessary
         */
        protected function setColumnHeight(column:StyledUIBase):void {
            // override in subclasses if necessary - VirtualDataGrid needs to use this since it can't left height unset
        }

        /**
         * @private
         */
        protected function configureColumnListPresentationModel(event:Event):void
        {
            var list:IDataGridColumnList = event.target as IDataGridColumnList;
            var pm:DataGridColumnListPresentationModel = list.presentationModel as DataGridColumnListPresentationModel;
            pm.rowHeight = _presentationModel.rowHeight;
            pm.variableRowHeight = false;
            pm.align = list.columnInfo.align;
        }

        protected function destroyLists():void
        {
            var listAreaParent:IParent = listArea as IParent;
            var l:uint = listAreaParent.numElements;
            while (l)
            {
                l--;
                ignoreSizeChange = l > 0;
                var list:IDataGridColumnList = listAreaParent.getElementAt(l) as IDataGridColumnList;
                listAreaParent.removeElement(list as IChild);
                list.removeEventListener('rollOverIndexChanged', handleColumnListRollOverChange);
                list.removeEventListener('selectionChanged', handleColumnListSelectionChange);
                list.dataProvider = null;

            }
            columnLists.length = 0;
        }

        protected function createColumnList(index:int, len:int, dataGridColumn:IDataGridColumn):IDataGridColumnList
        {
            // get the name of the class to use for the columns
            var columnClass:Class = ValuesManager.valuesImpl.getValue(host, "columnClass") as Class;
            var list:IDataGridColumnList = new columnClass();
                list.columnInfo = dataGridColumn;

                list.datagrid = _dg;
                list.emphasis = (_dg as IEmphasis).emphasis;

                if (index == 0) {
                    list.className = "first";
                }
                else if (index == len-1) {
                    list.className = "last";
                }
                else {
                    list.className = "middle";
                }

                // by default make columns get the 1/n of the maximun space available
                // (list as ILayoutChild).percentWidth = 100 / len;

                // need to add itemRenderer interface to DataGrid
                if((_dg as IItemRendererProvider).itemRenderer)
                    list.itemRenderer = (_dg as IItemRendererProvider).itemRenderer;
                else
                    list.itemRenderer = dataGridColumn.itemRenderer;
                list.labelField = dataGridColumn.dataField;
                if(dataGridColumn.labelFunction)
                {
                    var lf:LabelFunction = new LabelFunction();
                    lf.labelFunction = dataGridColumn.labelFunction;
                    list.addBead(lf);
                }
                list.addEventListener('rollOverIndexChanged', handleColumnListRollOverChange);
                list.addEventListener('selectionChanged', handleColumnListSelectionChange);
                list.addEventListener('beadsAdded', configureColumnListPresentationModel);
                (list as StyledUIBase).tabIndex = -1;
                setColumnHeight(list as StyledUIBase);
             return list;
        }

        /**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  
         *  @param event 
         */
        protected function initCompleteHandler(event:Event):void
		{
            IEventDispatcher(_strand).removeEventListener("initComplete", initCompleteHandler);
            handleDataProviderChanged(null);
            IEventDispatcher(sharedModel).addEventListener("columnsChanged", handleColumnsChanged);
        }

        /**
         * An array of List objects the comprise the columns of the DataGrid.
         */
        public function get columnLists():Array
        {
            return _lists;
        }

        /**
         * The area used to hold the columns
         */
        public function get listArea():IUIBase
        {
            return _listArea;
        }

        /**
         * Returns the component used as the header for the DataGrid.
         */
        public function get header():IDataGridHeader
        {
            return _header;
        }

        private var dp:IEventDispatcher;
        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        protected function handleDataProviderChanged(event:Event):void
        {
            if(dp)
			{
				dp.removeEventListener(CollectionEvent.ITEM_ADDED, handleItemAddedAndRemoved);
				dp.removeEventListener(CollectionEvent.ITEM_UPDATED, handleItemAddedAndRemoved);
				dp.removeEventListener(CollectionEvent.ITEM_REMOVED, handleItemAddedAndRemoved);
				dp.removeEventListener(CollectionEvent.ALL_ITEMS_REMOVED, handleItemAddedAndRemoved);
				dp.removeEventListener(CollectionEvent.COLLECTION_CHANGED, handleCollectionChanged);
			}
			dp = sharedModel.dataProvider as IEventDispatcher;
			if (dp)
            {
			    // listen for individual items being added in the future.
			    dp.addEventListener(CollectionEvent.ITEM_ADDED, handleItemAddedAndRemoved);
			    dp.addEventListener(CollectionEvent.ITEM_UPDATED, handleItemAddedAndRemoved);
				dp.addEventListener(CollectionEvent.ITEM_REMOVED, handleItemAddedAndRemoved);
				dp.addEventListener(CollectionEvent.ALL_ITEMS_REMOVED, handleItemAddedAndRemoved);
				dp.addEventListener(CollectionEvent.COLLECTION_CHANGED, handleCollectionChanged);
            }

            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:IDataGridColumnList = columnLists[i] as IDataGridColumnList;
                list.dataProvider = dp;
            }

            if(!layout) {
                // Load the layout bead if it hasn't already been loaded (init time)
			    layout = loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", _strand) as IBeadLayout;
            }
            host.dispatchEvent(new Event("layoutNeeded"));

            COMPILE::JS{
                synchHScroll(null);
            }
        }

        private var layout:IBeadLayout;

        /**
		 *  Handles the itemAdded event by adding the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
		 */
		protected function handleCollectionChanged(event:CollectionEvent):void
		{
            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:IDataGridColumnList = columnLists[i] as IDataGridColumnList;
                ((list as UIBase).model as IJewelSelectionModel).setDataProvider__NoCheck(dp);
            }

            host.dispatchEvent(new Event("layoutNeeded"));
        }

        /**
		 *  Handles the itemAdded event by adding the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
		 */
		protected function handleItemAddedAndRemoved(event:CollectionEvent):void
		{
            host.dispatchEvent(new Event("layoutNeeded"));
        }
        
        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        private function handleSelectedIndexChanged(event:Event):void
        {
            var newIndex:int = sharedModel.selectedIndex;

            for (var i:int=0; i < columnLists.length; i++)
            {
                var list:IDataGridColumnList = columnLists[i] as IDataGridColumnList;
                list.selectedIndex = newIndex;
            }
            host.dispatchEvent(new Event('selectionChanged'));
        }

        // COLUMNS (list) events

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        protected function handleColumnListSelectionChange(event:Event):void
        {
            var list:IDataGridColumnList = event.target as IDataGridColumnList;
            sharedModel.selectedIndex = list.selectedIndex;
            trackColumns ++;
            proxyDispatchChange();   
        }

        private var trackColumns:int = 0;
        public function proxyDispatchChange():void
        {
            if(columnLists.length == trackColumns){
                host.dispatchEvent(new Event('change'));
                trackColumns = 0;
            }
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        protected function handleColumnListRollOverChange(event:Event):void
        {
            var list:IDataGridColumnList = event.target as IDataGridColumnList;
            sharedModel.rollOverIndex = list.rollOverIndex;
            var columnLists:Array = this.columnLists;
            for(var i:int=0; i < columnLists.length; i++) {
                if (list != columnLists[i])
                {
                    var otherList:IDataGridColumnList = columnLists[i] as IDataGridColumnList;
                    otherList.rollOverIndex = list.rollOverIndex;
                }
            }

            host.dispatchEvent(new Event('rollOverIndex'));
        }

        /**
         * manages column label changes, included binding
         */
        private function labelChangedHandler(event:Event):void
        {
            var _sharedModel:IDataGridModel = _dg.model as IDataGridModel;
            var dp:Array = _sharedModel.columns as Array;
            var len:int = dp.length;
            for (var index:int = 0; index < len; index++)
            {
                var column:IDataGridColumn = dp[index] as IDataGridColumn;
                if(column == event.target) {
                    column.label = event.target.label;
                    break;
                }
            }
            _header.dataProvider = new ArrayList(_sharedModel.columns);
        }

        private function itemRendererChangedHandler(event:Event):void
        {
            var columnListLength:int = columnLists.length;
            for(var i:int=0; i < columnLists.length; i++)
            {
                var dataGridColumnList:IDataGridColumnList = columnLists[i] as IDataGridColumnList;
                if (dataGridColumnList.columnInfo == event.currentTarget)
                {
                    var elementIndex:int = (_listArea as IParent).getElementIndex(dataGridColumnList as IChild);
                     (_listArea as IParent).removeElement(dataGridColumnList as IChild);

                     var newDataGridColumnList:IDataGridColumnList = createColumnList(elementIndex, columnListLength, sharedModel.columns[i]);

                     COMPILE::JS
                     {
                        (newDataGridColumnList as IChild).element.style["minWidth"] = (dataGridColumnList as IChild).element.style["minWidth"];
                        (newDataGridColumnList as IChild).element.style["maxWidth"] = (dataGridColumnList as IChild).element.style["maxWidth"];
                        (newDataGridColumnList as IChild).element.style["width"] = (dataGridColumnList as IChild).element.style["width"];
                        (newDataGridColumnList as IChild).element.style["flex"] = (dataGridColumnList as IChild).element.style["flex"];
                     }

                     (_listArea as IParent).addElementAt(newDataGridColumnList as IChild, elementIndex);
                     columnLists[elementIndex] = newDataGridColumnList;

                     newDataGridColumnList.dataProvider = dp;

                     break;
                }
            }
        }
    }
}

