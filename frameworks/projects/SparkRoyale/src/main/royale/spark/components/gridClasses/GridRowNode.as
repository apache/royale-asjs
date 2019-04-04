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
    
[ExcludeClass]
    
/**
 *  A GridRowNode represents the heights of each cell for the row at rowIndex,
 *  and keeps track of the maximum cell height.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
public final class GridRowNode
{
    private var _rowIndex:int;
	
	public function get rowIndex():int
	{
		return _rowIndex;
	}
    
	public function set rowIndex(value:int):void
	{
		_rowIndex = value;
	}
	
    private var cellHeights:Vector.<Number>;
    
	private var _maxCellHeight:Number = -1;
	public function get maxCellHeight():Number
	{
		return _maxCellHeight;
	}
	
	public function set maxCellHeight(value:Number):void
	{
		_maxCellHeight = value;
	}
	
    private var _fixedHeight:Number = -1;
	public function get fixedHeight():Number
	{
		return _fixedHeight;
	}
	
	public function set fixedHeight(value:Number):void
	{
		_fixedHeight = value;
	}
    
	private var _next:GridRowNode;
	public function get next():GridRowNode
	{
		return _next;
	}
	
	public function set next(value:GridRowNode):void
	{
		_next = value;
	}
	
	private var _prev:GridRowNode;
	public function get prev():GridRowNode
	{
		return _prev;
	}
	
	public function set prev(value:GridRowNode):void
	{
		_prev = value;
	}
	
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function GridRowNode(numColumns:uint, rowIndex:int)
    {
        super();
        
        this.rowIndex = rowIndex;
        _numColumns = numColumns;
        
        // initialize cellHeights. all are -1 to start out with.
        cellHeights = new Vector.<Number>(numColumns);
        GridDimensions.clearVector(cellHeights, -1);
    }
    
    private var _numColumns:uint;
    
    /**
     *  Number of columns in this row.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function get numColumns():uint
    {
        return _numColumns;
    }
    
    /**
     *  @private
     */
    public function set numColumns(value:uint):void
    {
        if (value == _numColumns)
            return;
        
        cellHeights.length = value;
        
        if (value > _numColumns)
        {
            for (var i:int = value - _numColumns; i < value; i++)
                cellHeights[i] = -1;
        }
        else
        {
            updateMaxHeight();
        }
        
        _numColumns = value;
    }

    /**
     *  Updates the current max height.
     * 
     *  @return true if changed
     */
    private function updateMaxHeight():Boolean
    {
        var max:Number = -1;
        for each (var cellHeight:Number in cellHeights)
        {
            if (cellHeight > max)
                max = cellHeight;
        }
        
        const changed:Boolean = maxCellHeight != max;
        if (changed)
            maxCellHeight = max;
        return changed;
    }
    
    /**
     *  Returns the cell height at the specified column.
     *  
     *  @return the cell height at the given column. NaN if index
     *  is out of bounds.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function getCellHeight(index:int):Number
    {
        if (index < 0 || index >= cellHeights.length)
            return NaN;
        return cellHeights[index];
    }
    
    /**
     *  Updates the height at the specified column.
     * 
     *  @return true if max height has changed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function setCellHeight(index:int, value:Number):Boolean
    {
        if (cellHeights[index] == value)
            return false;
        
        cellHeights[index] = value;
        
        // If new height is equal to maxCellHeight, it doesn't change
        // so just return.
        if (value == maxCellHeight)
            return false;
        
        // If new height is greater than maxCellHeight, the new height 
        // is the new maxCellHeight.
        if (value > maxCellHeight)
        {
            maxCellHeight = value;
            return true;
        }
        
        // If new height is less than maxCellHeight, we need to check if
        // the maxCellHeight has changed.
        return updateMaxHeight();
    }
    
    /**
     *  Shifts values such that count columns are inserted
     *  from the startIndex.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function insertColumns(startColumn:int, count:int):void
    {
        GridDimensions.insertValueToVector(cellHeights, startColumn, count, -1);
    }
    
    /**
     *  Removes and adds values such that the specified columns are moved.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function moveColumns(fromCol:int, toCol:int, count:int):void
    {
        GridDimensions.insertElementsToVector(cellHeights, toCol, cellHeights.splice(fromCol, count));
    }
    
    /**
     *  Clears values such that count columns are 0.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function clearColumns(startColumn:int, count:int):void
    {
        GridDimensions.clearVector(cellHeights, -1, startColumn, count);
        updateMaxHeight();
    }
    
    /**
     *  Shifts values such that count columns are removed
     *  from the startColumn. We assume that cellHeights is the right length.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    public function removeColumns(startColumn:int, count:int):void
    {
        cellHeights.splice(startColumn, count);
        updateMaxHeight();
    }
    
    /**
     *  @private
     *  toString method for testing.
     */
    public function toString():String
    {
        var s:String = "";
        
        s += "(" + rowIndex + ", " + maxCellHeight + ") ";
        s += cellHeights + "\n";
        if (prev)
            s += prev.rowIndex;
        else
            s += "null";
        
        s += " <- -> ";
        if (next)
            s += next.rowIndex;
        else
            s += "null";
        
        return s;
    }
}
}