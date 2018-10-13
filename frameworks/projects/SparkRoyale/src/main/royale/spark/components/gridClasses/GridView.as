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

package spark.components.gridClasses
{
/*
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
*/
	
import org.apache.royale.events.Event;
import mx.events.MouseEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

import mx.collections.IList;
import mx.core.LayoutDirection;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;

import spark.collections.SubListView;
import spark.components.Grid;
import spark.components.Group;

use namespace mx_internal;

/**
 *  This class is internal to the DataGrid implementation.
 * 
 *  A Grid element (child) that displays a rectangular region within the Grid.   
 *  The GridView's region is defined by four GridViewLayout properties: viewRowIndex and 
 *  viewColumnIndex - the origin of the region, viewRowCount and viewColumnCount - the size 
 *  of the region.  The GridView contains GridLayers which contain all of the Grid's visual
 *  elements, the renderers, indicators, separators, etc.
 * 
 *  GridViews are created automatically by the Grid class, based on the values of 
 *  the lockedRowCount and lockedColumnCount Grid properties.
 */
public class GridView extends Group
{
    private static const zeroPoint:Point = new Point(0, 0);
    
    /**
     *  Creates a GridView group with its layout set to a private GridView specific value.
     */
    public function GridView()
    {
        super();
        // layout = new GridViewLayout();
        // layout.clipAndEnableScrolling = true;
    }
    
    /**
     *  Return this GridView's GridViewLayout.
     */
	
    public function get gridViewLayout():GridViewLayout
    {
        return layout as GridViewLayout;
    }    
    
    /**
     *  True if this GridView's bounds contain the event.
     * 
     *  Currently this method does not account for the possibility that this GridView has been
     *  rotated or scaled.
     */
    public function containsMouseEvent(event:MouseEvent):Boolean
    {
        const eventStageX:Number = event.stageX;
        const eventStageY:Number = event.stageY;
        const origin:Point = null; //localToGlobal(zeroPoint);

        origin.x += horizontalScrollPosition;
       /* if (layoutDirection == LayoutDirection.RTL)
            origin.x -= width;*/

        origin.y += verticalScrollPosition;
        
        return (eventStageX >= origin.x) && (eventStageY >= origin.y) && 
            (eventStageX < (origin.x + width)) && (eventStageY < (origin.y + height));
    }
    
    /**
     *  Returns the view-relative index of the next GridColumn.visible==true column
     *  after index.
     *  Returns -1 if there are no more visible columns.
     *  To find the first GridColumn.visible==true column index, use
     *  getNextVisibleColumnIndex(-1).
     */
    public function getNextVisibleColumnIndex(index:int=-1):int
    {
        if (index < -1)
            return -1;
        /*
        const columnsView:SubListView = this.gridViewLayout.columnsView;
        const columnsLength:int = (columnsView) ? columnsView.length : 0;
        
        for (var i:int = index + 1; i < columnsLength; i++)
        {
            var column:GridColumn = columnsView.getItemAt(i) as GridColumn;
            if (column && column.visible)
                return i;
        }
		*/        
        return -1;
    }
    
    /**
     *  Returns the view-relative index of the previous GridColumn.visible==true column
     *  before index.
     *  Returns -1 if there are no more visible columns.
     *  To find the last GridColumn.visible==true column index, use
     *  getPreviousVisibleColumnIndex(columns.length).
     */
    public function getPreviousVisibleColumnIndex(index:int):int
    {
        /*const columnsView:SubListView = this.gridViewLayout.columnsView;
        if (!columnsView || index > columnsView.length)
            return -1;
        
        for (var i:int = index - 1; i >= 0; i--)
        {
            var column:GridColumn = columnsView.getItemAt(i) as GridColumn;
            if (column && column.visible)
                return i;
        }*/
        
        return -1;
    }    
    
    /**
     *  @private 
     */
    override protected function dispatchPropertyChangeEvent(property:String, oldValue:*, newValue:*):void    
    {
        switch(property) 
        {
            case "contentWidth": 
            case "contentHeight":
                const grid:Grid = parent as Grid;
                if (grid)
                {
                    const pce:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(grid, property, null, null);
                    grid.dispatchEvent(pce);
                }
                break;
        }
    }
}
}