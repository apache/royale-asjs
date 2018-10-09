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
// import flash.geom.Rectangle;
import org.apache.royale.geom.Rectangle;

import mx.collections.IList;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.PropertyChangeEvent;

[ExcludeClass]

/**
 *  A sparse data structure that represents the widths and heights of a grid.
 *  
 *  <p>Provides efficient support for finding the cumulative y distance to the
 *  start of a particular cell as well as finding the index of a particular
 *  cell at a certain y value.
 *  GridDimensions optimizes these operations by bookmarking the most recently
 *  visited rows.</p>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
public class GridDimensions 
{
    // include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Inserts specified elements starting from startIndex.
     *  
     *  <pre>Our implementation of:
     *      var argArray:Array = [];
     *      for each (var x:Number in values)
     *      {
     *          argArray.push(x);
     *      }
     *      argArray.splice(0, 0, startIndex, 0);
     *      vec.splice.apply(vec, argArray);</pre>
     * 
     *  @param vec The vector to insert into.
     *  @param startIndex The index to insert at.
     *  @param elements The elements to be inserted.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public static function insertElementsToVector(vec:Vector.<Number>, startIndex:int, elements:Vector.<Number>):void
    {
        const oldLength:int = vec.length;
        const count:int = elements.length;
        vec.length += count;
        const vecLength:int = vec.length;
        var i:int;

        // Shift elements down by count.
        for (i = oldLength - 1; i >= startIndex; i--)
            vec[i + count] = vec[i];
        
        const endIndex:int = startIndex + elements.length;
        var j:int = 0;
        for (i = startIndex; i < endIndex; i++)
            vec[i] = elements[j++];
    }
    
    /**
     *  Insert count elements of the specified value starting from
     *  startIndex.
     *  
     *  @param vec The vector to insert into.
     *  @param startIndex The index to insert at.
     *  @param count The number of elements to insert
     *  @param value The value of the inserted elements
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public static function insertValueToVector(vec:Vector.<Number>, startIndex:int, count:int, value:Number):void
    {
        const oldLength:int = vec.length;
        vec.length += count;
        const vecLength:int = vec.length;
        
        // Shift elements down by count.
        for (var i:int = oldLength - 1; i >= startIndex; i--)
            vec[i + count] = vec[i];
        
        clearVector(vec, value, startIndex, count);
    }
    
    /**
     *  Sets all of the numbers in a vector to be value unless otherwise
     *  specified.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public static function clearVector(vec:Vector.<Number>, value:Number, startIndex:int = 0, count:int = -1):void
    {
        const endIndex:int = (count == -1) ? vec.length : startIndex + count;
        
        for (var i:int = startIndex; i < endIndex; i++)
            vec[i] = value;
    }
    
    /**
     *  @private
     *  Restrict a number to a particular min and max.
     */
    private static function bound(a:Number, min:Number, max:Number):Number
    {
        if (a < min)
            a = min;
        else if (a > max)
            a = max;
        
        return a;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var rowList:GridRowList = new GridRowList();
    private var _columnWidths:Vector.<Number> = new Vector.<Number>();

    // Bookmark recently visited rows by caching the node representing the row
    // and the y-value corresponding to the start of the node.
    // startY/recentNode is the bookmark used by getRowIndexAt()
    private var startY:Number = 0;
    private var recentNode:GridRowNode = null;
    // startY2/recentNode2 is bookmark used by getCellY()
    private var startY2:Number = 0;
    private var recentNode2:GridRowNode = null;
    
    private const typicalCellWidths:Vector.<Number> = new Vector.<Number>();
    private const typicalCellHeights:Vector.<Number> = new Vector.<Number>();
    private var maxTypicalCellHeight:Number = NaN;
    private var useMaxTypicalCellHeight:Boolean = true;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function GridDimensions()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  rowCount
    //----------------------------------
    
    private var _rowCount:int = 0;
    
    /**
     *  The number of rows in the Grid. If this is decreased, the 
     *  excess rows will be removed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get rowCount():int
    {
        return _rowCount;
    }
    
    /**
     *  @private
     */
    public function set rowCount(value:int):void
    {
        if (value == _rowCount)
            return;
        
        // remove rows greater than value.
        // This also clears the cached nodes.
        if (value < _rowCount)
            removeRowsAt(value, value - _rowCount)
        
        _rowCount = value;
    }
    
    //----------------------------------
    //  columnCount
    //----------------------------------
    
    private var _columnCount:int = 0;
    
    /**
     *  The number of columns in the Grid.
     *  Setting this property will clear the cache.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get columnCount():int
    {
        return _columnCount;
    }
    
    /**
     *  @private
     */
    public function set columnCount(value:int):void
    {
        // Don't short-circuit return if the column count didn't change.
        // There might be a new set of columns which is the same length
        // as the old set of columns.

        // clear cached information
        clearHeights();
        
        // fix up the number of columns
        _columnCount = value;
        _columnWidths.length = value;
        typicalCellHeights.length = value;
        typicalCellWidths.length = value;
        rowList.numColumns = value;
        
        // clear the rest of the vectors
        clearTypicalCellWidthsAndHeights();
        clearVector(_columnWidths, NaN, 0, _columnCount);
    }

    //----------------------------------
    //  rowGap
    //----------------------------------

    private var _rowGap:Number = 0;
    
    /**
     *  The gap between rows.
     * 
     *  @default 0 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get rowGap():Number
    {
        return _rowGap;
    }
    
    /**
     *  @private
     */
    public function set rowGap(value:Number):void
    {
        if (value == _rowGap)
            return;
        
        _rowGap = value;

        clearCachedNodes();
    }
    
    //----------------------------------
    //  columnGap
    //----------------------------------

    private var _columnGap:Number = 0;
    
    /**
     *  The gap between columns.
     * 
     *  @default 0
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5 
     */
    public function get columnGap():Number
    {
        return _columnGap;
    }
    
    /**
     *  @private
     */
    public function set columnGap(value:Number):void
    {
        if (value == _columnGap)
            return;
        
        _columnGap = value;

        clearCachedNodes();
    }
    
    //----------------------------------
    //  defaultRowHeight
    //----------------------------------

    private var _defaultRowHeight:Number = NaN;
    
    /**
     *  The default height of a row.
     *
     *  <p>If this property is not set explicitly, it will use the maximum
     *  of the typical cell heights.</p>
     *
     *  <p>When variableRowHeight is false, all rows have a height of
     *  defaultRowHeight.</p>
     *
     *  @default NaN
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get defaultRowHeight():Number
    {
        return useMaxTypicalCellHeight ? maxTypicalCellHeight : _defaultRowHeight;
    }
    
    /**
     *  @private
     */
    public function set defaultRowHeight(value:Number):void
    {
        if (value == _defaultRowHeight)
            return;
        
        _defaultRowHeight = bound(value, _minRowHeight, _maxRowHeight);
        useMaxTypicalCellHeight = isNaN(_defaultRowHeight);
        
        clearCachedNodes();
    }
    
    //----------------------------------
    //  defaultColumnWidth
    //----------------------------------
    
    private var _defaultColumnWidth:Number = 150;
    
    /**
     *  The default width of a column.
     *  If this changes, update the ASDoc for GridLayout/getItemRendererAt().
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get defaultColumnWidth():Number
    {
        return _defaultColumnWidth;
    }
    
    /**
     *  @private
     */
    public function set defaultColumnWidth(value:Number):void
    {
        if (value == _defaultColumnWidth)
            return;
        
        _defaultColumnWidth = value;
    }    
    
    //----------------------------------
    //  variableRowHeight
    //----------------------------------
    
    private var _variableRowHeight:Boolean = false;  // default value must match Grid property default value
    
    /**
     *  If variableRowHeight is false, calling getRowHeight
     *  will return the value of defaultRowHeight.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get variableRowHeight():Boolean
    {
        return _variableRowHeight;
    }
    
    /**
     *  @private
     */
    public function set variableRowHeight(value:Boolean):void
    {
        if (value == _variableRowHeight)
            return;
        
        _variableRowHeight = value;
    }       
    
    //----------------------------------
    //  minRowHeight
    //----------------------------------
    
    private var _minRowHeight:Number = 0;
    
    /**
     *  The minimum height of each row.
     * 
     *  @default 0
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get minRowHeight():Number
    {
        return _minRowHeight;
    }
    
    /**
     *  @private
     */
    public function set minRowHeight(value:Number):void
    {
        if (value == _minRowHeight)
            return;
        
        _minRowHeight = value;
        _defaultRowHeight = Math.max(_defaultRowHeight, _minRowHeight);
    }
    
    //----------------------------------
    //  maxRowHeight
    //----------------------------------
    
    private var _maxRowHeight:Number = 10000;
    
    /**
     *  The maximum height of each row.
     * 
     *  @default 10000
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get maxRowHeight():Number
    {
        return _maxRowHeight;
    }
    
    /**
     *  @private
     */
    public function set maxRowHeight(value:Number):void
    {
        if (value == _maxRowHeight)
            return;
        
        _maxRowHeight = value;
        _defaultRowHeight = Math.min(_defaultRowHeight, _maxRowHeight);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Clears bookmarked nodes.
     *  Each bookmarked node is associated with a cumulative y-value representing
     *  the total height of the grid up to the start of the row.
     *  These values are cleared as well.
     */
    private function clearCachedNodes():void
    {
        recentNode = null;
        startY = 0;
        recentNode2 = null;
        startY2 = 0;
    }
    
    /**
     *  Returns the height of the row at the given index. If variableRowHeight
     *  is true, then the height in precendence order is: the height set by setRowHeight,
     *  the natural height of the row (determined by the maximum of its cell heights),
     *  and defaultRowHeight. If variableRowHeight is false, then the height returned
     *  is the defaultRowHeight. The returned height is always bounded by the minRowHeight
     *  and maxRowHeight.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getRowHeight(row:int):Number
    {
        // Unless setRowHeight is called, return the max cell height for this row
        var height:Number = defaultRowHeight;
        
        if (variableRowHeight)
        {
            var node:GridRowNode = rowList.find(row);
            if (node)
            {
                if (node.fixedHeight >= 0)
                    height = node.fixedHeight;
                else if (node.maxCellHeight >= 0)
                    height = node.maxCellHeight;
            }
        }
        
        return (!isNaN(height)) ? bound(height, minRowHeight, maxRowHeight) : height;
    }
    
    /**
     *  Sets the height of a given row. This height takes precedence over
     *  the natural height of the row (determined by the maximum of its 
     *  cell heights) and the defaultRowHeight. However, if variableRowHeight
     *  is true, this method has no effect.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function setRowHeight(row:int, height:Number):void
    {
        if (!variableRowHeight)
            return;
        
        var node:GridRowNode = rowList.find(row);
        
        if (node)
        {
            node.fixedHeight = bound(height, minRowHeight, maxRowHeight);
        }
        else
        {
            node = rowList.insert(row);
            
            if (node)
                node.fixedHeight = bound(height, minRowHeight, maxRowHeight);
        }
        
        clearCachedNodes();
    }

    /**
     *  Returns the width of the column at the given index. Returns
     *  the width specified by setColumnWidth. If no width has been
     *  specified, returns the typical width. If no typical width has
     *  been set, it returns the defaultColumnWidth.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getColumnWidth(col:int):Number
    {    
        var w:Number = NaN;

        w = _columnWidths[col];
        
        if (isNaN(w))
            w = typicalCellWidths[col];
        
        if (isNaN(w))
            w = this.defaultColumnWidth;
        
        return w;
    }
    
    /**
     *  Sets the width of a given column.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function setColumnWidth(col:int, width:Number):void
    {
        _columnWidths[col] = width;
    }

    /**
     *  Returns the height of the specified cell. Returns the height
     *  specified by setCellHeight. If the height has not been specified,
     *  returns NaN.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getCellHeight(row:int, col:int):Number
    {
        var node:GridRowNode = rowList.find(row);
        
        if (node)
            return node.getCellHeight(col);
        
        return NaN;
    }
    
    /**
     *  Sets the height of the specified cell.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function setCellHeight(row:int, col:int, height:Number):void
    {
        if (!variableRowHeight)
            return;
        
        var node:GridRowNode = rowList.find(row);
        var oldHeight:Number = defaultRowHeight;
        
        if (node == null)
            node = rowList.insert(row);
        else
            oldHeight = node.maxCellHeight;
        
        if (node && node.setCellHeight(col, height))
        {
           if (recentNode && node.rowIndex < recentNode.rowIndex)
               startY += node.maxCellHeight - oldHeight;
           
           if (recentNode2 && node.rowIndex < recentNode2.rowIndex)
               startY2 += node.maxCellHeight - oldHeight;
        }
    }
    
    /**
     *  Returns the layout bounds of the specified cell. The cell height
     *  and width are determined by its row's height and column's width.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getCellBounds(row:int, col:int):Rectangle
    {
        // TODO (klin): provide optional return value (Rectangle) parameter
        if (row < 0 || row >= rowCount || col < 0 || col >= columnCount)
            return null;
        
        var x:Number = getCellX(row, col);
        var y:Number = getCellY(row, col);
        
        var width:Number = getColumnWidth(col);
        var height:Number = getRowHeight(row);
        
        return new Rectangle(x, y, width, height);
    }
    
    /**
     *  Returns the X coordinate of the origin of the specified cell.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getCellX(row:int, col:int):Number
    {   
        var x:Number = 0;
        
        for (var i:int = 0; i < col; i++)
        {
            x += getColumnWidth(i) + columnGap;
        }
        
        return x;
    }
    
    /**
     *  Returns the Y coordinate of the origin of the specified cell.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getCellY(row:int, col:int):Number
    { 
        // no cache so we use default heights for each row.
        if (!variableRowHeight || rowList.length == 0)
            return row * (defaultRowHeight + rowGap);
        
        if (row == 0)
            return 0;
        
        // initialize first node.
        if (!recentNode2)
        {
            recentNode2 = rowList.first;
            startY2 = recentNode2.rowIndex * (defaultRowHeight + rowGap);
        }
        
        var y:Number;
        var recentIndex:int = recentNode2.rowIndex;

        if (row == recentIndex)
            y = startY2;
        else if (row < recentIndex)
            y = getPrevYAt(row, recentNode2, startY2);
        else
            y = getNextYAt(row, recentNode2, startY2);

        return y;
    }

    /**
     *  @private
     *  Returns the starting y value of the specified row. The row must be before
     *  startNode.
     *  
     *  @param row the target row
     *  @param startNode the node to search from
     *  @param startY the cumulative y value from the first row to the beginning
     *  of startNode's row.
     * 
     *  @return the y value of the start of the row.
     */
    private function getPrevYAt(row:int, startNode:GridRowNode, startY:Number):Number
    {
        var node:GridRowNode = startNode;
        var nodeY:Number = startY;
        var prevNode:GridRowNode;
        var currentY:Number = startY;
        var indDiff:int;
        
        while (node)
        {
            if (node.rowIndex == row)
                break;
            
            prevNode = node.prev;
            
            if (!prevNode || (row < node.rowIndex && row > prevNode.rowIndex))
            {
                // at the beginning or somewhere between nodes
                // so we've found the target row.
                indDiff = node.rowIndex - row;
                currentY -= indDiff * (defaultRowHeight + rowGap);
                break;
            }
            
            // subtract previous node's height and its gap.
            indDiff = node.rowIndex - prevNode.rowIndex - 1;
            currentY = currentY - indDiff * (defaultRowHeight + rowGap) - (getRowHeight(prevNode.rowIndex) + rowGap);
            nodeY = currentY;
            node = prevNode;
        }
        
        this.recentNode2 = node;
        this.startY2 = nodeY;
        
        return currentY;
    }
    
    /**
     *  @private
     *  Returns the starting y value of the specified row. The row must be after
     *  startNode.
     *  
     *  @param row the target row
     *  @param startNode the node to search from
     *  @param startY the cumulative y value from the first row to beginning of
     *  startNode's row.
     * 
     *  @return the y value of the start of the row.
     */
    private function getNextYAt(row:int, startNode:GridRowNode, startY:Number):Number
    {
        var node:GridRowNode = startNode;
        var nodeY:Number = startY;
        var nextNode:GridRowNode;
        var currentY:Number = startY;
        var indDiff:int;
        
        while (node)
        {
            if (node.rowIndex == row)
                break;

            // add next row's height and rowGap
            currentY += getRowHeight(node.rowIndex);
            if (node.rowIndex < _rowCount - 1)
                currentY += rowGap;
            
            nextNode = node.next;
            
            if (!nextNode || (row > node.rowIndex && row < nextNode.rowIndex))
            {
                // at the beginning or somewhere between nodes
                // so we've found the target row.
                indDiff = row - node.rowIndex - 1;
                currentY += indDiff * (defaultRowHeight + rowGap);
                break;
            }
            
            // add estimated heights of rows in between measured rows.
            indDiff = nextNode.rowIndex - node.rowIndex - 1;
            currentY = currentY + indDiff * (defaultRowHeight + rowGap);
            nodeY = currentY; 
            node = nextNode;
        }
        
        this.recentNode2 = node;
        this.startY2 = nodeY;
        
        return currentY;
    }
    
    /**
     *  Returns the layout bounds of the specified row.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getRowBounds(row:int):Rectangle
    {
        // TODO (klin): provide optional return value (Rectangle) parameter    
        if ((row < 0) || (row >= _rowCount))
            return null;
        
        if (_columnCount == 0 || _rowCount == 0)
            return new Rectangle(0, 0, 0, 0);
        
        const x:Number = getCellX(row, 0);
        const y:Number = getCellY(row, 0);
        const rowWidth:Number = getCellX(row, _columnCount - 1) + getColumnWidth(_columnCount - 1) - x;
        const rowHeight:Number = getRowHeight(row);
        return new Rectangle(x, y, rowWidth, rowHeight);
    }
    
    /**
     *  Return the dimensions of a row that's being used to "pad" the grid
     *  by filling unused space below the last row in a layout where all rows
     *  are visible.  Pad rows have index >= rowCount, height = defaultRowHeight.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getPadRowBounds(row:int):Rectangle
    {
        if (row < 0)
            return null;
        
        if (row < rowCount)
            return getRowBounds(row);
        
        const lastRow:int = rowCount - 1;
        const lastCol:int = columnCount - 1;
        
        const x:Number = (lastRow >= 0) ? getCellX(lastRow, 0) : 0;
        const lastRowBottom:Number = (lastRow >= 0) ? getCellY(lastRow, 0) + getRowHeight(lastRow) : 0;
        const padRowCount:int = row - rowCount;
        const padRowTotalGap:Number = (padRowCount > 0) ? (padRowCount - 1) * rowGap : 0;
        const y:Number = lastRowBottom + (padRowCount * defaultRowHeight) + padRowTotalGap;
        
        var rowWidth:Number = 0;
        if ((lastCol >= 0) && (lastRow >= 0))
            rowWidth = getCellX(lastRow, lastCol) + getColumnWidth(lastCol) - x;
        else if (lastCol >= 0)
            rowWidth = getCellX(0, lastCol) + getColumnWidth(lastCol) - x;
        else if (lastRow >= 0)
            rowWidth = getCellX(lastRow, 0) + getColumnWidth(0) - x;
        
        return new Rectangle(x, y, rowWidth, defaultRowHeight);
        
    }
    
    /**
     *  Returns the layout bounds of the specified column.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getColumnBounds(col:int):Rectangle
    {
        // TODO (klin): provide optional return value (Rectangle) parameter
        if ((col < 0) || (col >= _columnCount))
            return null;
        
        if (_columnCount == 0)
            return new Rectangle(0, 0, 0, 0);

        const x:Number = getCellX(0, col);
        const y:Number = getCellY(0, col);
        const colWidth:Number = getColumnWidth(col);
        var colHeight:Number = 0;
		
		if (_rowCount > 0)
			colHeight = getCellY(_rowCount - 1, col) + getRowHeight(_rowCount - 1) - y;

        return new Rectangle(x, y, colWidth, colHeight);
    }
    
    /**
     *  Returns the index of the row at the specified coordinates. If
     *  the coordinates lie in a gap area, the index returned is the
     *  previous row.
     * 
     *  @return The index of the row at the coordinates provided. If the
     *  coordinates are out of bounds, return -1.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getRowIndexAt(x:Number, y:Number):int
    {
        if (y < 0)
            return -1;
        
        var index:int;
        
        if (!variableRowHeight || rowList.length == 0)
        {
            index = y / (defaultRowHeight + rowGap);
            return index < _rowCount ? index : -1;
        }
        
        if (y == 0)
            return _rowCount > 0 ? 0 : -1;
        
        // initialize first node.
        if (!recentNode)
        {
            recentNode = rowList.first;
            startY = recentNode.rowIndex * (defaultRowHeight + rowGap);
        }
        
        // if we are already at the right row, then use the index.
        if (isYInRow(y, startY, recentNode))
            index = recentNode.rowIndex;
        else if (y < startY)
            index = getPrevRowIndexAt(y, recentNode, startY);
        else
            index = getNextRowIndexAt(y, recentNode, startY);
        
        return index < _rowCount ? index : -1;
    }
    
    /**
     *  @private
     *  Checks if a certain y value lies in a row's bounds.
     */
    private function isYInRow(y:Number, startY:Number, node:GridRowNode):Boolean
    {
        var end:Number = startY + getRowHeight(node.rowIndex);
        
        // don't add gap for last row.
        if (node.rowIndex != rowCount - 1)
            end += rowGap;
        
        // if y is between cumY and cumY + rowHeight - 1 then y is in the row.
        if (y >= startY && y < end)
            return true;
        
        return false;
    }
    
    /**
     *  @private
     *  Returns the index of the row that contains the specified y value.
     *  The row will be before startNode.
     *  
     *  @param y the target y value
     *  @param startNode the node to search from
     *  @param startY the cumulative y value from the first row to startNode
     * 
     *  @return the index of the row that contains the y value.
     */
    private function getPrevRowIndexAt(y:Number, startNode:GridRowNode, startY:Number):int
    {
        var node:GridRowNode = startNode;
        var prevNode:GridRowNode = null;
        var index:int = node.rowIndex;
        var currentY:Number = startY;
        var prevY:Number;
        var targetY:Number = y;

        while (node)
        {
            // check the current node.
            if (isYInRow(targetY, currentY, node))
                break;
            
            // calculate previous y.
            prevNode = node.prev;
            
            if (!prevNode)
            {
                prevY = 0;
            }
            else
            {
                prevY = currentY;
                
                var indDiff:int = node.rowIndex - prevNode.rowIndex;
                
                // subtract default row heights if difference is greater than one.
                if (indDiff > 1)
                    prevY -= (indDiff - 1) * (defaultRowHeight + rowGap);
            }
            
            // check if target Y is in range.
            if (targetY < currentY && targetY >= prevY)
            {
                index = index - Math.ceil(Number(currentY - targetY)/(defaultRowHeight + rowGap));
                break;
            }

            // subtract previous node's height and its gap.
            currentY = prevY - getRowHeight(prevNode.rowIndex) - rowGap;
            node = node.prev;
            index = node.rowIndex;
        }
        
        this.recentNode = node;
        this.startY = currentY;
        
        return index;
    }
    
    /**
     *  @private
     *  Returns the index of the row that contains the specified y value.
     *  The row will be after startNode.
     *  
     *  @param y the target y value
     *  @param startNode the node to search from
     *  @param startY the cumulative y value from the first row to startNode
     * 
     *  @return the index of the row that contains the y value.
     */
    private function getNextRowIndexAt(y:Number, startNode:GridRowNode, startY:Number):int
    {
        var node:GridRowNode = startNode;
        var nextNode:GridRowNode = null;
        var index:int = node.rowIndex;
        var nodeY:Number = startY;
        var currentY:Number = startY;
        var nextY:Number;
        var targetY:Number = y;
        
        while (node)
        {
            // check the current node.
            if (isYInRow(targetY, nodeY, node))
                break;
            
            // currentY increments to end of the current node.
            currentY += getRowHeight(node.rowIndex);
            if (node.rowIndex != rowCount - 1)
                currentY += rowGap;
            
            // calculate end of next section.
            nextNode = node.next;
            nextY = currentY;
            
            var indDiff:int;
            
            if (!nextNode)
            {
                indDiff = rowCount - 1 - node.rowIndex;
                // the y at the end doesn't have a rowGap, but includes the final pixel.
                nextY += indDiff * (defaultRowHeight + rowGap) - rowGap + 1;
            }
            else
            {
                indDiff = nextNode.rowIndex - node.rowIndex;
                nextY += (indDiff - 1) * (defaultRowHeight + rowGap);
            }
            
            // check if target Y is within default row heights range.
            if (targetY >= currentY && targetY < nextY)
            {
                index = index + Math.ceil(Number(targetY - currentY)/(defaultRowHeight + rowGap));
                break;
            }
            
            // if no next node and we didn't find the target, then the row doesn't exist.
            if (!nextNode)
            {
                index = -1;
                break;
            }
            
            // move y values ahead to next node.
            nodeY = currentY = nextY;
            
            node = node.next;
            index = node.rowIndex;
        }
        
        this.recentNode = node;
        this.startY = nodeY;
        
        return index;
    }
    
    /**
     *  Returns the index of the column at the specified coordinates. If
     *  the coordinates lie in a gap area, the index returned is the
     *  previous column. Returns -1 if the coordinates are out of bounds.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getColumnIndexAt(x:Number, y:Number):int
    {
        var current:Number = x;
        var i:int;

        if(current < 0)
            return -1;

        for (i = 0; i < _columnCount; i++)
        {
            var columnWidth:Number = _columnWidths[i];
            
            // fall back on typical widths if the actual width isn't set.
            if (isNaN(columnWidth))
            {
                columnWidth = typicalCellWidths[i];
                if (columnWidth == 0) // invisible column
                    continue;
            }
            
            // fall back on defaultColumnWidth
            if (isNaN(columnWidth))
                columnWidth = defaultColumnWidth;
            
            current -= columnWidth + columnGap;

            if (current < 0)
                return i;
        }
        
        return -1;
    }
    
    /**
     *  Returns the total layout width of the content including gaps.   If 
	 *  columnCountOverride is specified, then the overall width of as many columns
	 *  is returned.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getContentWidth(columnCountOverride:int = -1, startColumnIndex:int = 0):Number
    {
        const nCols:int = (columnCountOverride == -1) ? columnCount - startColumnIndex : columnCountOverride;
        var contentWidth:Number = 0;
        var measuredColCount:int = 0;
        
        for (var columnIndex:int = startColumnIndex; (columnIndex < columnCount) && (measuredColCount < nCols); columnIndex++)
        {
            if (columnIndex >= _columnWidths.length)
            {
                contentWidth += defaultColumnWidth;
                measuredColCount++;
                continue;
            }
            
            var width:Number = _columnWidths[columnIndex];
            
            // fall back on typical width
            if (isNaN(width))
            {
                width = typicalCellWidths[columnIndex];
                // column.visible==false, skip this column.
                if (width == 0)
                    continue;
            }
            
            // fall back on defaultColumnWidth
            if (isNaN(width))
                width = defaultColumnWidth;
            
            contentWidth += width;
            measuredColCount++;
        }
        
        if (measuredColCount > 1)
            contentWidth += (measuredColCount - 1) * columnGap;
        
        return contentWidth;
    }
    
    /**
     *  Returns the total layout height of the content including gaps.  If 
	 *  rowCountOverride is specified, then the overall height of as many rows
	 *  is returned.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getContentHeight(rowCountOverride:int = -1, startRowIndex:int = 0):Number
    {
        const nRows:int = (rowCountOverride == -1) ? rowCount - startRowIndex : rowCountOverride;        
        const maxRow:int = (rowCountOverride == -1) ? rowCount : startRowIndex + rowCountOverride;
		var contentHeight:Number = 0;
        
        if (nRows > 1)
            contentHeight += (nRows - 1) * rowGap;
        
        if (!variableRowHeight || rowList.length == 0)
            return contentHeight + nRows * defaultRowHeight;
        
        var node:GridRowNode = (startRowIndex == 0) ? rowList.first : rowList.findNearestLTE(startRowIndex);
        var numRows:int = 0;
        
        while (node && node.rowIndex < maxRow)  
        {
            if (node.rowIndex < startRowIndex)
            {
                node = node.next;
                continue;
            }
            contentHeight += getRowHeight(node.rowIndex);
            numRows++;
            node = node.next;
        }
    
        contentHeight += (nRows - numRows) * defaultRowHeight;
        
        return contentHeight;
    }
    
    /**
     *  Returns the sum of the typical cell widths including gaps.  If 
	 *  columnCountOverride is specified, then the overall typicalCellWidth 
     *  of as many columns is returned. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getTypicalContentWidth(columnCountOverride:int = -1, startColumnIndex:int = 0):Number
    {
        const nCols:int = (columnCountOverride == -1) ? columnCount - startColumnIndex : columnCountOverride;
        var contentWidth:Number = 0;
        var measuredColCount:int = 0;
        
        for (var columnIndex:int = startColumnIndex; (columnIndex < columnCount) && (measuredColCount < nCols); columnIndex++)
        {
            // column.visible==false columns will have a typicalCellWidth of 0, so skip them.
            var width:Number = columnIndex < columnCount ? typicalCellWidths[columnIndex] : NaN;
            if (width == 0)
                continue;
            
            if (isNaN(width))
                width = defaultColumnWidth;
            
            contentWidth += width;
            measuredColCount++;
        }
        
        if (measuredColCount > 1)
            contentWidth += (measuredColCount - 1) * columnGap;

        return contentWidth;
    }
    
    /**
     *  Returns the content height which is maximum cell height of the
     *  typical item times the total number of rows including gaps. 
     *  If rowCountOverride is specified, then we only include that many rows.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getTypicalContentHeight(rowCountOverride:int = -1, startRowIndex:int = 0):Number
    {
        const nRows:int = (rowCountOverride == -1) ? rowCount - startRowIndex : rowCountOverride;          
        var contentHeight:Number = 0;
        
        if (nRows > 1)
            contentHeight += (nRows - 1) * rowGap;
        
        if (!isNaN(defaultRowHeight))
            return contentHeight + nRows * defaultRowHeight;
        
        return 0;
    }
        
    /**
     *  Return the preferred bounds width of the grid's typicalItem when rendered with the item renderer 
     *  for the specified column.  If no value has yet been specified, return NaN.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getTypicalCellWidth(columnIndex:int):Number
    {
        return typicalCellWidths[columnIndex];
    }
    
    /**
     *  Sets the preferred bounds width of the grid's typicalItem for the specified column.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function setTypicalCellWidth(columnIndex:int, value:Number):void
    {
        typicalCellWidths[columnIndex] = value;
    }
    
    /**
     *  Return the preferred bounds height of the grid's typicalItem when rendered with the item renderer 
     *  for the specified column.  If no value has yet been specified, return NaN.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */    
    public function getTypicalCellHeight(columnIndex:int):Number
    {
        return typicalCellHeights[columnIndex];
    }
    
    /**
     *  Sets the preferred bounds height of the grid's typicalItem for the specified column.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */    
    public function setTypicalCellHeight(columnIndex:int, value:Number):void
    {
        typicalCellHeights[columnIndex] = value;
        
        var max:Number = 0;
        const typicalCellHeightsLength:int = typicalCellHeights.length;
        for (var i:int = 0; i < typicalCellHeightsLength; i++)
        {
            if (!isNaN(typicalCellHeights[i])) 
                max = Math.max(max, typicalCellHeights[i]);
        }
        this.maxTypicalCellHeight = max;
    }
    
    /**
     *  Clears the typical cell for every column and row.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearTypicalCellWidthsAndHeights():void
    {
        clearVector(typicalCellWidths, NaN);
        clearVector(typicalCellHeights, NaN);
        maxTypicalCellHeight = NaN;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods for handling dataProvider and column list changes
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Inserts count number of rows starting from startRow. This shifts
     *  any rows after startRow down by count and will increment 
     *  rowCount.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertRows(startRow:int, count:int):void
    {
        insertRowsAt(startRow, count);
    }
    
    /**
     *  Inserts count number of columns starting from startColumn. This
     *  shifts any columns after startColumn down by count and will
     *  increment columnCount. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertColumns(startColumn:int, count:int):void
    {
        const oldColumnCount:int = _columnCount;
        const newColumnCount:int = _columnCount + count;
        
        if (startColumn < 0 || startColumn > oldColumnCount)
            return;
        
        // change column count of all nodes in GridRowList.
        rowList.insertColumns(startColumn, count);
        
        // add to columnCount
        _columnCount = newColumnCount;
        
        // insert new values into the arrays.
        insertValueToVector(_columnWidths, startColumn, count, NaN);
        insertValueToVector(typicalCellWidths, startColumn, count, NaN);
        insertValueToVector(typicalCellHeights, startColumn, count, NaN);
    }
    
    /**
     *  Removes count number of rows starting from startRow. This
     *  shifts any rows after startRow up by count and will
     *  decrement rowCount.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeRows(startRow:int, count:int):void
    {
        removeRowsAt(startRow, count);
    }
    
    /**
     *  Removes count number of columns starting from startColumn. This
     *  shifts any columns after startColumn up by count and will
     *  decrement columnCount.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeColumns(startColumn:int, count:int):void
    {
        const oldColumnCount:int = _columnCount;
        const newColumnCount:int = _columnCount - count;
        
        if (startColumn < 0 || startColumn >= oldColumnCount)
            return;
        
        // if we remove all the columns, clear everything.
        if (newColumnCount <= 0)
        {
            columnCount = 0;
            return;
        }
        
        // Otherwise, lets remove the specified columns.
        // change column count of all nodes in GridRowList.
        rowList.removeColumns(startColumn, count)
        
        // lower columnCount without clearing anything else.
        _columnCount = newColumnCount;
        
        // remove values from the needed vectors
        _columnWidths.splice(startColumn, count);
        typicalCellWidths.splice(startColumn, count);
        typicalCellHeights.splice(startColumn, count);
        
        // bookmarks are invalid because row heights may have changed.
        clearCachedNodes();
    }
    
    /**
     *  Removes any nodes that occupy the indices between startRow
     *  and startRow + count.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearRows(startRow:int, count:int):void
    {
        if (startRow < 0 || count <= 0)
            return;
        
        var node:GridRowNode = rowList.findNearestLTE(startRow);
        var endRow:int = startRow + count;
        var oldNode:GridRowNode;
        
        if (node && node.rowIndex < startRow)
            node = node.next;
        
        while (node && node.rowIndex < endRow)
        {
            oldNode = node;
            node = node.next;
            rowList.removeNode(oldNode);
        }
        
        // bookmarks are invalid because row heights may have changed.
        clearCachedNodes();
    }
    
    /**
     *  Clears any columns that occupy the indices between startColumn
     *  and startColumn + count.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearColumns(startColumn:int, count:int):void
    {
        if (startColumn < 0 || startColumn >= _columnCount)
            return;
        
        rowList.clearColumns(startColumn, count);
        
        clearVector(typicalCellWidths, NaN, startColumn, count);
        clearVector(typicalCellHeights, NaN, startColumn, count);
        clearVector(_columnWidths, NaN, startColumn, count);
        
        // bookmarks are invalid because row heights may have changed.
        clearCachedNodes(); 
    }
        
    /**
     *  Moves count number of rows from the fromRow index to the toRow
     *  index. This operation will not affect rowCount.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function moveRows(fromRow:int, toRow:int, count:int):void
    {
        var rows:Vector.<GridRowNode> = removeRowsAt(fromRow, count);
        
        // Set the row indices of the nodes that are moving.
        var diff:int = toRow - fromRow;
        for each (var node:GridRowNode in rows)
        {
            node.rowIndex = node.rowIndex + diff;
        }
        
        insertRowsAt(toRow, count, rows);
    }
    
    /**
     *  Moves count number of columns from the fromCol index to the toCol
     *  index. This operation will not affect colCount.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function moveColumns(fromCol:int, toCol:int, count:int):void
    {
        if (fromCol < 0 || fromCol >= _columnCount || toCol < 0 || toCol > _columnCount)
            return;
        
        rowList.moveColumns(fromCol, toCol, count);
        
        insertElementsToVector(_columnWidths, toCol, _columnWidths.splice(fromCol, count));
        insertElementsToVector(typicalCellWidths, toCol, typicalCellWidths.splice(fromCol, count));
        insertElementsToVector(typicalCellHeights, toCol, typicalCellHeights.splice(fromCol, count));
    }
    
    /**
     *  Clears all cached heights.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearHeights():void
    {
        rowList.removeAll();
        clearCachedNodes();
    }
    
    /**
     *  @private
     *  Inserts count number of rows starting from startRow. This will increment 
     *  rowCount. If the nodes parameter is set, the nodes will be inserted
     *  to the rowList.
     */
    private function insertRowsAt(startRow:int, count:int, nodes:Vector.<GridRowNode> = null):void
    {
        // TODO (klin): Push this to GridRowList.
        
        if (startRow < 0 || count <= 0)
            return;
        
        var startNode:GridRowNode = rowList.findNearestLTE(startRow);
        var node:GridRowNode;
        
        if (startNode && startNode.rowIndex < startRow)
            startNode = startNode.next;
        
        // first we insert the nodes before this node if it exists,
        // if not, we just push it at the end.
        if (nodes)
        {
            if (startNode)
            {
                for each (node in nodes)
                    rowList.insertBefore(startNode, node);
            }
            else
            {
                for each (node in nodes)
                    rowList.push(node);
            }
        }
        
        // increment the index of nodes after the last node.
        node = startNode;
        while (node)
        {
            node.rowIndex += count;
            node = node.next;
        }
        
        this.rowCount += count;
        
        // bookmarks are invalid because row heights may have changed.
        clearCachedNodes();
    }
    
    /**
     *  @private
     *  Removes count number of rows starting from startRow. This will
     *  decrement rowCount. Returns any removed nodes.
     */
    private function removeRowsAt(startRow:int, count:int):Vector.<GridRowNode>
    {
        var vec:Vector.<GridRowNode> = new Vector.<GridRowNode>();
        if (startRow < 0 || count <= 0)
            return vec;
        
        var node:GridRowNode = rowList.findNearestLTE(startRow);
        var endRow:int = startRow + count;
        var oldNode:GridRowNode;
        
        if (node && node.rowIndex < startRow)
            node = node.next;
        
        while (node && node.rowIndex < endRow)
        {
            oldNode = node;
            vec.push(oldNode);
            node = node.next;
            rowList.removeNode(oldNode);
        }
        
        while (node)
        {
            node.rowIndex -= count;
            node = node.next;
        }
        
        _rowCount -= count;
        
        // bookmarks are invalid because row heights may have changed.
        clearCachedNodes();
        return vec;
    }
    
    /**
     *  Handles changes in the dataProvider.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function dataProviderCollectionChanged(event:CollectionEvent):void 
    {
        switch (event.kind)
        {
            case CollectionEventKind.ADD: 
            {
                insertRows(event.location, event.items.length);
                break;
            }
                
            case CollectionEventKind.REMOVE:
            {
                removeRows(event.location, event.items.length);
                break;
            }
                
            case CollectionEventKind.MOVE:
            {
                moveRows(event.oldLocation, event.location, event.items.length);
                break;
            }
                
            case CollectionEventKind.REFRESH:
            {
                clearHeights();
                break;
            }
                
            case CollectionEventKind.RESET:
            {
                clearHeights();
                clearTypicalCellWidthsAndHeights();
                break;
            }
                
            case CollectionEventKind.UPDATE:
            {
                // handled by GridLayout
                break;
            }
                
            case CollectionEventKind.REPLACE:
            {
                clearRows(event.location, event.items.length);
                break;
            }   
        }
    }
    
    /**
     *  Handles changes in columns.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function columnsCollectionChanged(event:CollectionEvent):void
    {
        switch (event.kind)
        {
            case CollectionEventKind.ADD: 
            {
                insertColumns(event.location, event.items.length);
                break;
            }
            
            case CollectionEventKind.REMOVE:
            {
                removeColumns(event.location, event.items.length);
                break;
            }
            
            case CollectionEventKind.MOVE:
            {
                moveColumns(event.oldLocation, event.location, event.items.length);
                break;
            }
                    
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
            {
                columnCount = IList(event.target).length;
                break;
            }
                
            case CollectionEventKind.UPDATE:
            {
                // column may have changed visiblity                
                var pcEvent:PropertyChangeEvent;
                
                const itemsLength:int = event.items ? event.items.length : 0;                
                for (var i:int = 0; i < itemsLength; i++)
                {
                    pcEvent = event.items[i] as PropertyChangeEvent;
                    if (pcEvent && pcEvent.property == "visible")
                        columns_visibleChangedHandler(pcEvent);
                }
                break;
            }
            
            case CollectionEventKind.REPLACE:
            {
                clearColumns(event.location, event.items.length);
                break;
            }
        }
    }
    
    /**
     *  @private
     *  Handle CollectionEventKind.UPDATE for a column whose 'visibility' 
     *  property changed.
     */
    private function columns_visibleChangedHandler(pcEvent:PropertyChangeEvent):void
    {
		/*
        const column:GridColumn = pcEvent.source as GridColumn;
        const columnIndex:int = column.columnIndex;
        if (!column || columnIndex < 0 || columnIndex >= _columnCount)
            return;
        
        clearColumns(columnIndex, 1);
        
        // column.visible==true columns need to have their typical sizes and 
        // actual column width updated, while column.visible==false column
        // have their typical sizes updated to 0 and actual column width
        // set to NaN.
        if (column.visible)
        {
            setTypicalCellWidth(columnIndex, NaN);
            setTypicalCellHeight(columnIndex, NaN);
            if (!isNaN(column.width))
                setColumnWidth(columnIndex, column.width);
        }
        else
        {
            setTypicalCellWidth(columnIndex, 0);
            setTypicalCellHeight(columnIndex, 0);
            setColumnWidth(columnIndex, NaN);
        }
		*/
    }
    
    /**
     *  @private
     *  For debugging purposes.
     */
    public function toString():String
    {
        return rowList.toString();
    }
}
}
