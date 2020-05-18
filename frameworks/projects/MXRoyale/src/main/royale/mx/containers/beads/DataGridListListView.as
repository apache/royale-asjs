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

package mx.containers.beads
{
import mx.controls.DataGrid;
import mx.controls.listClasses.IListItemRenderer;

import org.apache.royale.html.beads.ListView;
COMPILE::SWF
{
    import org.apache.royale.core.IStrand;
}
import org.apache.royale.core.IItemRenderer;
import org.apache.royale.core.IRollOverModel;
import org.apache.royale.core.ISelectableItemRenderer;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.events.Event;
import org.apache.royale.utils.getSelectionRenderBead;

import mx.controls.dataGridClasses.DataGridColumnList;

/**
 *  @private
 *  The DataGridListListView class is for internal use only.
 */
public class DataGridListListView extends ListView
{
    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DataGridListListView()
    {
        super();
    }

    private var _lastIndices:Array;

    override protected function selectionChangeHandler(event:Event):void{
        var dataGrid:DataGrid = (this._strand as DataGridColumnList).grid as DataGrid;
        if (dataGrid && dataGrid.allowMultipleSelection) {

            var selectedIndices:Array = dataGrid.selectedIndices;
            var alreadySelected:Array = [];
            if (_lastIndices) {
                for (var i:int=0;i<_lastIndices.length;i++) {
                    var previousSelected:int = _lastIndices[i];
                    if (selectedIndices.indexOf(previousSelected) == -1) {
                        adjustSelection(dataGroup.getItemRendererForIndex(previousSelected) as IItemRenderer, false);
                    } else {
                        alreadySelected.push(previousSelected);
                    }
                }
            }
            _lastIndices = selectedIndices.slice();
            while (selectedIndices.length) {
                var selectedIndex:int = selectedIndices.pop();
                if (alreadySelected.indexOf(selectedIndex) == -1) {
                    adjustSelection(dataGroup.getItemRendererForIndex(selectedIndex) as IItemRenderer, true);
                }
            }

        } else {
            if (_lastIndices) {
                while (_lastIndices.length) {
                    adjustSelection(dataGroup.getItemRendererForIndex(_lastIndices.pop()) as IItemRenderer, false);
                }
                _lastIndices = null;
            }
            super.selectionChangeHandler(event)
        }
    }

    private function adjustSelection(ir:IItemRenderer, selected:Boolean):void{
        if (ir)
        {
            var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(ir);
            if (selectionBead)
                selectionBead.selected = selected;
        }
    }

}
}

