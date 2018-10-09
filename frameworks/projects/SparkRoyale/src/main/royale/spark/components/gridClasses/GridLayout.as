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
import flash.geom.Rectangle;
*/
	
import org.apache.royale.events.Event;
import org.apache.royale.geom.Rectangle;

import mx.collections.IList;
import mx.core.IVisualElement;
import mx.core.mx_internal;

import spark.collections.SubListView;
import spark.components.Grid;
import spark.components.Group;
import spark.layouts.supportClasses.LayoutBase;

use namespace mx_internal;

//[ExcludeClass]  TBD

/**
 *  @private
 *  The internal layout class used by the Grid class.   Responsible for laying out
 *  the target Grid's 1-4 GridViews: centerGridView, leftGridView, topGridView, topLeftGridView.
 *  The GridViews are created/removed as needed by the Grid.  The layout arranges the GridViews
 *  within the available space.  There are no gaps between the GridViews, and no space between
 *  the GridViews and the edges (no leftPadding, rightPadding, etc..).
 * 
 *  This class is private to the DataGrid implementation.  It's only used by the 
 *  DataGrid's Grid skin part (see Grid/configureGridViews()).
 */
public class GridLayout extends LayoutBase
{
    public function GridLayout()
    {
        super();
    }
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private function dispatchChangeEvent(type:String):void
	{
		if (hasEventListener(type))
			dispatchEvent(new Event(type));
	}
	
	//----------------------------------
	//  centerGridView
	//----------------------------------
	
	private var _centerGridView:GridView = null; 
	
	[Bindable("centerGridViewChanged")]
	
	/**
	 *  Displays unlocked rows and columns.   This GridView is created unconditionally.
	 * 
	 *  <p>The Grid responds to vertical and horizontal scroll position changes by scrolling the 
	 *  centerGridView</p>
	 * 
	 *  @default null
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get centerGridView():GridView
	{
		return _centerGridView;
	}
	
	/**
	 *  @private
	 */
	public function set centerGridView(value:GridView):void
	{
		if (_centerGridView == value)
			return;
		
        _centerGridView = value;
		dispatchChangeEvent("centerGridViewChanged");
	}
    
    //----------------------------------
    //  grid (private, read-only)
    //----------------------------------  
    
    private function get grid():Grid
    {
        return target as Grid;
    }
	
	//----------------------------------
	//  leftGridView
	//----------------------------------
	
	private var _leftGridView:GridView = null; 
	
	[Bindable("leftGridViewChanged")]
	
	/**
	 *  Displays the unlocked rows subset of the locked columns.  This GridView is created when 
	 *  lockedColumnCount is greater than 0, it's removed if lockedRowCount is reset to zero.
	 * 
	 *  <p>If the Grid is scrolled verticallyi, i.e. if its verticalScrollPosition is changed, 
	 *  then the leftGridView and centerGridView are also scrolled vertically.  The leftGridView
	 *  does not scroll horizontally.</p> 
	 * 
	 *  @default null
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get leftGridView():GridView
	{
		return _leftGridView;
	}
	
	/**
	 *  @private
	 */
	public function set leftGridView(value:GridView):void
	{
		if (_leftGridView == value)
			return;
		
        _leftGridView = value;
		dispatchChangeEvent("leftGridViewChanged");
	}
	
	//----------------------------------
	//  lockedColumnsSeparatorElement
	//----------------------------------
	
	private var _lockedColumnsSeparatorElement:IVisualElement = null; 
	
	[Bindable("lockedColumnsSeparatorElementChanged")]
	
	/**
	 *  If lockedColumnCount is greater than zero, this element is displayed in between the locked
	 *  and unlocked columns.  It's created (and removed) as needed with the lockedColumnssSeparator IFactory.
	 * 
	 *  @default null
	 * 
	 *  @see spark.components.GridLayout#lockedColumnsSeparator 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get lockedColumnsSeparatorElement():IVisualElement
	{
		return _lockedColumnsSeparatorElement;
	}
	
	/**
	 *  @private
	 */
	public function set lockedColumnsSeparatorElement(value:IVisualElement):void
	{
		if (_lockedColumnsSeparatorElement == value)
			return;
		
		_lockedColumnsSeparatorElement = value;
		dispatchChangeEvent("lockedColumnsSeparatorElementChanged");
	}
	
	
	//----------------------------------
	//  lockedRowsSeparatorElement
	//----------------------------------
	
	private var _lockedRowsSeparatorElement:IVisualElement = null; 
	
	[Bindable("lockedRowsSeparatorElementChanged")]
	
	/**
	 *  If lockedRowCount is greater than zero, this element is displayed in between the locked
	 *  and unlocked rows.  It's created (and removed) as needed with the lockedRowsSeparator IFactory.
	 * 
	 *  @default null
	 * 
	 *  @see spark.components.Grid#lockedRowsSeparator
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get lockedRowsSeparatorElement():IVisualElement
	{
		return _lockedRowsSeparatorElement;
	}
	
	/**
	 *  @private
	 */
	public function set lockedRowsSeparatorElement(value:IVisualElement):void
	{
		if (_lockedRowsSeparatorElement == value)
			return;
		
		_lockedRowsSeparatorElement = value;
		dispatchChangeEvent("lockedRowsSeparatorElementChanged");
	}	
	
	//----------------------------------
	//  topGridView
	//----------------------------------
	
	private var _topGridView:GridView = null; 
	
	[Bindable("topGridViewChanged")]
	
	/**
	 *  Displays the unlocked columns subset of the locked rows.  This GridView is created when 
	 *  lockedRowCount is greater than 0, it's removed if lockedRowCount is reset to zero.
	 * 
	 *  <p>If the Grid is scrolled horizontally, i.e. if its horizontalScrollPosition is changed, 
	 *  then the topGridView and centerGridView are also scrolled horizontally.   The topGridView
	 *  does not scroll vertically.</p>
	 * 	
	 *  @default null
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get topGridView():GridView
	{
		return _topGridView;
	}
	
	/**
	 *  @private
	 */
	public function set topGridView(value:GridView):void
	{
		if (_topGridView == value)
			return;
		
        _topGridView = value;
		dispatchChangeEvent("topGridViewChanged");		
	}
	
	
	//----------------------------------
	//  topLeftGridView
	//----------------------------------
	
	private var _topLeftGridView:GridView = null; 
	
	[Bindable("topLeftGridViewChanged")]
	
	/**
	 *  This GridView is only created when both lockedRowCount and lockedColumnCount are greater
	 *  than zero.  It displays as many rows and columns and does not scroll.
	 * 
	 *  @default null
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 5.0
	 */
	public function get topLeftGridView():GridView
	{
		return _topLeftGridView;
	}
	
	/**
	 *  @private
	 */
	public function set topLeftGridView(value:GridView):void
	{
		if (_topLeftGridView == value)
			return;
		
		_topLeftGridView = value;
		dispatchChangeEvent("topLeftGridViewChanged");			
	}	

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
    
	/**
	 *  @private
	 */
    override public function measure():void
    {
        const grid:Grid = target as Grid;
        if (!grid)
            return;
        
        const gridDimensions:GridDimensions = grid.gridDimensions;
        
        var measuredRowCount:int = grid.requestedRowCount;
        if (measuredRowCount == -1)
        {
            const rowCount:int = gridDimensions.rowCount;
            if (grid.requestedMaxRowCount != -1)
                measuredRowCount = Math.min(grid.requestedMaxRowCount, rowCount);
            if (grid.requestedMinRowCount != -1)
                measuredRowCount = Math.max(grid.requestedMinRowCount, measuredRowCount);                
        }
        
        var measuredWidth:Number = gridDimensions.getTypicalContentWidth(grid.requestedColumnCount);
        var measuredHeight:Number = gridDimensions.getTypicalContentHeight(measuredRowCount);
        var measuredMinWidth:Number = gridDimensions.getTypicalContentWidth(grid.requestedMinColumnCount);
        var measuredMinHeight:Number = gridDimensions.getTypicalContentHeight(grid.requestedMinRowCount);
        
        if (grid.lockedRowCount > 0)
        {
            if (lockedRowsSeparatorElement && lockedRowsSeparatorElement.includeInLayout)
            {
                measuredHeight += lockedRowsSeparatorElement.getPreferredBoundsHeight();
                measuredMinHeight += lockedRowsSeparatorElement.getMinBoundsHeight();
                measuredMinWidth = Math.max(measuredMinWidth, lockedRowsSeparatorElement.getMinBoundsWidth());                
            }
        }
        
        if (grid.lockedColumnCount > 0)
        {
            if (lockedColumnsSeparatorElement && lockedColumnsSeparatorElement.includeInLayout)
            {
                measuredWidth += lockedColumnsSeparatorElement.getPreferredBoundsWidth();
                measuredMinWidth += lockedColumnsSeparatorElement.getMinBoundsWidth();
                measuredMinHeight = Math.max(measuredMinHeight, lockedColumnsSeparatorElement.getMinBoundsHeight());
            }
        }
        
        // Use Math.ceil() to make sure that if the content partially occupies
        // the last pixel, we'll count it as if the whole pixel is occupied.

		target.measuredWidth = Math.ceil(measuredWidth);    
        target.measuredHeight = Math.ceil(measuredHeight);
        target.measuredMinWidth = Math.ceil(measuredMinWidth);    
        target.measuredMinHeight = Math.ceil(measuredMinHeight);
		
		//trace("gridLayout measure", target.measuredWidth, target.measuredHeight);
    }
	
    /**
	 *  @private
	 */
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        const grid:Grid = target as Grid;
        if (!grid || !centerGridView)
            return;
  
		//trace("gridLayout updateDisplayList", unscaledWidth, unscaledHeight);

        const lockedRowCount:int = grid.lockedRowCount;
        const lockedColumnCount:int = grid.lockedColumnCount;
        const lockedRowsExist:Boolean = lockedRowCount > 0;
        const lockedColumnsExist:Boolean = lockedColumnCount > 0;
        
        // Initialize the size of topLeft,top,leftGridView
        
        if (lockedRowsExist)
        {
			const lastLockedRowIndex:int = lockedRowCount - 1;
			const lastRowBounds:Rectangle = grid.getRowBounds(lastLockedRowIndex);
			const lockedRowsHeight:Number = (lastRowBounds) ? Math.min(unscaledHeight, lastRowBounds.bottom) : NaN;			
            topGridView.setLayoutBoundsSize(unscaledWidth, lockedRowsHeight);
			
            if (lockedRowsSeparatorElement)
                lockedRowsSeparatorElement.setLayoutBoundsSize(unscaledWidth, NaN);
        }
        
        if (lockedColumnsExist)
        {
			const lastLockedColumnIndex:int = lockedColumnCount - 1;
			const lastColumnBounds:Rectangle = grid.getColumnBounds(lastLockedColumnIndex);
			const lockedColumnsWidth:Number = (lastColumnBounds) ? Math.min(unscaledWidth, lastColumnBounds.right) : NaN;
            leftGridView.setLayoutBoundsSize(lockedColumnsWidth, unscaledHeight);
			
            if (lockedColumnsSeparatorElement)
                lockedColumnsSeparatorElement.setLayoutBoundsSize(NaN, unscaledHeight);
        }
        
        if (lockedRowsExist && lockedColumnsExist)
            topLeftGridView.setLayoutBoundsSize(leftGridView.getLayoutBoundsWidth(), topGridView.getLayoutBoundsHeight());
        
        // Position topLeft, compute centerX,Y
        
        const separatorX:Number = (lockedColumnsExist) ? leftGridView.getLayoutBoundsWidth() : 0;
        const separatorY:Number = (lockedRowsExist) ? topGridView.getLayoutBoundsHeight() : 0;
        
        var centerX:Number = separatorX;
        var centerY:Number = separatorY;
        
        if (lockedRowsExist && lockedColumnsExist)
            topLeftGridView.setLayoutBoundsPosition(0, 0);
        
        if (lockedRowsExist && lockedRowsSeparatorElement)
        {
            lockedRowsSeparatorElement.setLayoutBoundsPosition(0, separatorY);
            centerY += lockedRowsSeparatorElement.getLayoutBoundsHeight();
        }
            
        if (lockedColumnsExist && lockedColumnsSeparatorElement)
        {
            lockedColumnsSeparatorElement.setLayoutBoundsPosition(separatorX, 0);
            centerX += lockedColumnsSeparatorElement.getLayoutBoundsWidth();
        }
		
        // Set topLeft bounds and fix up top.width and left.height when both lockedRow,ColumnCount > 0
        
        if (lockedColumnsExist && lockedRowsExist)
        {
            topGridView.setLayoutBoundsSize(unscaledWidth - centerX, lockedRowsHeight);
            leftGridView.setLayoutBoundsSize(lockedColumnsWidth, unscaledHeight - centerY);
			
			topLeftGridView.setLayoutBoundsSize(separatorX, separatorY);
			topLeftGridView.setLayoutBoundsPosition(0,0);
        }
        
        // Position leftGridView, topGridView, size and position centerGridView.
		
		if (lockedRowsExist)
			topGridView.setLayoutBoundsPosition(centerX, 0);
		
		if (lockedColumnsExist)
			leftGridView.setLayoutBoundsPosition(0, centerY);
		
        centerGridView.setLayoutBoundsSize(unscaledWidth - centerX, unscaledHeight - centerY);
        centerGridView.setLayoutBoundsPosition(centerX, centerY);
        
        // Note: Grid overrides its contentWidth,Height properties, no need to set them here
    }
}
}