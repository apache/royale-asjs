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
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataGrid;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IDataGridPresentationModel;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.jewel.beads.layouts.ButtonBarLayout;
	import org.apache.royale.jewel.supportClasses.Viewport;
	import org.apache.royale.jewel.supportClasses.datagrid.DataGridButtonBar;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList;
	import org.apache.royale.utils.IEmphasis;
    
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
    public class DataGridView extends GroupView implements IBeadView, IDataGridView
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

        private var _dg:IDataGrid = _strand as IDataGrid;
        private var _sharedModel:IDataGridModel;
        private var _header:DataGridButtonBar;
        private var _listArea:IUIBase;
        private var _lists:Array;

        COMPILE::JS
        private var rq:int;
        
        override public function set strand(value:IStrand):void
		{
			super.strand = value;

            _dg = _strand as IDataGrid;
            _dg.addEventListener("widthChanged", handleSizeChanges);
            _dg.addEventListener("heightChanged", handleSizeChanges);
            
            // see if there is a presentation model already in place. if not, add one.
            _sharedModel = _dg.model as IDataGridModel;
            IEventDispatcher(_sharedModel).addEventListener("dataProviderChanged", handleDataProviderChanged);
            IEventDispatcher(_sharedModel).addEventListener("selectedIndexChanged", handleSelectedIndexChanged);

            createChildren();
		}

        /**
		 * @private
		 */
		private function createChildren():void
		{
            // header
            var headerClass:Class = ValuesManager.valuesImpl.getValue(host, "headerClass") as Class;
            _header = new headerClass() as DataGridButtonBar;
            _header.dataProvider = new ArrayList(_sharedModel.columns);
            _header.emphasis = (_dg as IEmphasis).emphasis;
            _header.labelField = "label";
            _header.height = 38;
            var headerLayoutClass:Class = ValuesManager.valuesImpl.getValue(host, "headerLayoutClass") as Class;
            var bblayout:ButtonBarLayout = new headerLayoutClass() as ButtonBarLayout;
            _header.addBead(bblayout as IBead);
            _header.addBead(new Viewport() as IBead);
            _sharedModel.headerModel = _header.model as IBeadModel;
            _dg.strandChildren.addElement(_header as IChild);

            // columns
            var listAreaClass:Class = ValuesManager.valuesImpl.getValue(host, "listAreaClass") as Class;
            _listArea = new listAreaClass() as IUIBase;

            _dg.height = 240;// must be the same as in CSS default (get from CSS)
            _listArea.height = _dg.height - _header.height;
            COMPILE::JS
            {
            (_listArea as UIBase).positioner.style.top = _header.height + "px";
            }

            _dg.strandChildren.addElement(_listArea as IChild);

            if (_sharedModel.columns)
                createLists();
            
            handleDataProviderChanged(null);
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
        public function get header():IUIBase
        {
            return _header;
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.core.IBeadModel
         * @royaleignorecoercion org.apache.royale.core.IChild
         * @royaleignorecoercion org.apache.royale.core.IUIBase
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
        override protected function handleInitComplete(event:Event):void
        {
            // _header.dispatchEvent(new Event("layoutNeeded"));
            // _listArea.dispatchEvent(new Event("layoutNeeded"));
        }

        /**
         * @private
         */
        private function handleSizeChanges(event:Event):void
        {
            _header.dispatchEvent(new Event("layoutNeeded"));
            _listArea.dispatchEvent(new Event("layoutNeeded"));
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        protected function handleDataProviderChanged(event:Event):void
        {
            var presentationModel:IDataGridPresentationModel = _dg.presentationModel as IDataGridPresentationModel;

            for (var i:int=0; i < _lists.length; i++)
            {
                var list:IDataGridColumnList = _lists[i] as IDataGridColumnList;
                list.dataProvider = _sharedModel.dataProvider;
                
                COMPILE::JS
                {
                if(_sharedModel.dataProvider && _sharedModel.dataProvider.length * presentationModel.rowHeight < _dg.height)
                {
                    (list as UIBase).positioner.style.height = "inherit";
                    _listArea.positioner.style.overflow = "hidden";
                } else
                {
                    (list as UIBase).positioner.style.height = null;
                    _listArea.positioner.style.overflow = null;
                }
                }
            }

            host.dispatchEvent(new Event("layoutNeeded"));
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        private function handleSelectedIndexChanged(event:Event):void
        {
            var newIndex:int = _sharedModel.selectedIndex;

            for (var i:int=0; i < _lists.length; i++)
            {
                var list:IDataGridColumnList = _lists[i] as IDataGridColumnList;
                list.selectedIndex = newIndex;
            }
        }

        /**
         * @private
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        private function handleColumnListChange(event:Event):void
        {
            var list:IDataGridColumnList = event.target as IDataGridColumnList;
            _sharedModel.selectedIndex = list.selectedIndex;

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
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumnList
         */
        private function handleColumnListRollOverChange(event:Event):void
        {
            var list:IDataGridColumnList = event.target as IDataGridColumnList;
            _sharedModel.rollOverIndex = list.rollOverIndex;

            for(var i:int=0; i < _lists.length; i++) {
                if (list != _lists[i]) {
                    var otherList:IDataGridColumnList = _lists[i] as IDataGridColumnList;
                    otherList.rollOverIndex = list.rollOverIndex;
                }
            }

            host.dispatchEvent(new Event('rollOverIndex'));
        }

        /**
         * @private
         * @royaleignorecoercion Class
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.core.IChild
         * @royaleignorecoercion org.apache.royale.core.IParent
         * @royaleignorecoercion org.apache.royale.core.IDataGrid
         * @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
         * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn
         */
        protected function createLists():void
        {
            // get the name of the class to use for the columns
            var columnClass:Class = ValuesManager.valuesImpl.getValue(host, "columnClass") as Class;
            var presentationModel:IDataGridPresentationModel = _dg.presentationModel as IDataGridPresentationModel;

            _lists = [];

            for (var i:int=0; i < _sharedModel.columns.length; i++)
            {
                var dataGridColumn:IDataGridColumn = _sharedModel.columns[i] as IDataGridColumn;

                var list:IDataGridColumnList = new columnClass();
                list.emphasis = (_dg as IEmphasis).emphasis;
                
                if (i == 0)
                {
                    list.className = "first";
                }
                else if (i == _sharedModel.columns.length-1)
                {
                    list.className = "last";
                }
                else
                {
                    list.className = "middle";
                }
                
                // by default make columns get the 1/n of the maximun space available
                (list as UIBase).percentWidth = 100 / _sharedModel.columns.length;
                list.itemRenderer = dataGridColumn.itemRenderer;
                list.labelField = dataGridColumn.dataField;
                list.addEventListener('rollOverIndexChanged', handleColumnListRollOverChange);
                list.addEventListener('selectionChanged', handleColumnListChange);
                list.addBead(presentationModel as IBead);

                (_listArea as UIBase).percentWidth = 100;
                (_listArea as IParent).addElement(list as IChild);
                _lists.push(list);
            }
        }
    }
}

