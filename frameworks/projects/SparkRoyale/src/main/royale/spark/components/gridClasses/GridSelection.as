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

import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;

import spark.components.Grid;
import spark.components.gridClasses.CellPosition;

use namespace mx_internal;
  
[ExcludeClass]

/**
 *  Use the GridSelection class to track a Grid control's 
 *  <code>selectionMode</code> property and its set of selected rows, columns, or cells.   
 *  The selected elements are defined by integer indices.
 * 
 *  @see spark.components.Grid
 *  @see spark.components.Grid#columns
 *  @see spark.components.Grid#dataProvider
 *  @see spark.components.gridClasses.GridSelectionMode
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class GridSelection
{
    //include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
        
    /**
     *  @private
     *  List of ordered selected/de-selected cell regions used to represent
     *  either row or cell selections depending on the selection mode.  
     *  (For row selection, a row region will be in column 0 and column count 
     *  will be 1.)
     *
     *  This is the list of cell regions that have
     *  been added (isAdd==true) and removed (isAdd==false). 
     *   
     *  Internally, regionsContainCell should be used to determine if a cell/row
     *  is in the selection.
     */    
    private var cellRegions:Vector.<CellRect> = new Vector.<CellRect>();
           
    /**
     *  @private
     *  If preserveSelection, and selectionMode is "singleRow" or "singleCell",
     *  cache the dataItem that goes with the selection so we can find the
     *  index of the selection after a collection refresh event.
     */    
    private var selectedItem:Object;
    
    /**
     *  @private
     *  True if in a collection handler.  If this is the case, there is no
     *  need to validate the index/indices.  In the case of 
     *  CollectionEventKind.REMOVE, when the last item selected and it is 
     *  removed from the collection, the validate would fail since the index is 
     *  now out of range and the item would incorrectly remain in the selection.
     */    
    private var inCollectionHandler:Boolean;
    
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
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function GridSelection()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
   
    //----------------------------------
    //  grid
    //----------------------------------
    
    private var _grid:Grid;
    
    /**
     *  The grid control associated with this object. 
     *  This property should only be set once.
     *
     *  <p>For the Spark DataGrid, this value is initialized by 
     *  the <code>DataGrid.partAdded()</code> method.</p>   
     * 
     *  @default null
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get grid():Grid
    {
        return _grid;
    }
    
    /**
     *  @private
     */
    public function set grid(value:Grid):void
    {
        _grid = value;
    }
    
    //----------------------------------
    //  preserveSelection
    //----------------------------------
    
    private var _preserveSelection:Boolean = true;
    
    /**
     *  If <code>true</code>, and <code>selectionMode</code> is 
     *  <code>GridSelectionMode.SINGLE_ROW</code> or 
     *  <code>GridSelectionMode.SINGLE_CELL</code>, then selection is
     *  preserved when the <code>dataProvider</code> refreshes its collection,
     *  and the selected item is contained in the collection after
     *  the refresh.
     *
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get preserveSelection():Boolean
    {
        return _preserveSelection;
    }
    
    /**
     *  @private
     */    
    public function set preserveSelection(value:Boolean):void
    {
        if (_preserveSelection == value)
            return;
        
        _preserveSelection = value;
        
        selectedItem = null;
        
        // If preserving the selection and there is currently a selection,
        // save the corresponding data item.
        if (_preserveSelection && 
            (selectionMode == GridSelectionMode.SINGLE_ROW || 
                selectionMode == GridSelectionMode.SINGLE_CELL) && 
            selectionLength > 0)
        {
            if (selectionMode == GridSelectionMode.SINGLE_ROW)
                selectedItem = grid.dataProvider.getItemAt(allRows()[0]);
            else  // SINGLE_CELL
                selectedItem = grid.dataProvider.getItemAt(allCells()[0].rowIndex);
        }
    }
    
    //----------------------------------
    //  requireSelection
    //----------------------------------
    
    private var _requireSelection:Boolean = false;
    
    /**
     *  If <code>true</code>, a data item must always be selected in the 
     *  control as long as there is at least one item in 
     *  <code>dataProvider</code> and one column in <code>columns</code>.
     *
     *  @default false
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requireSelection():Boolean
    {
        return _requireSelection;
    }
    
    /**
     *  @private
     */    
    public function set requireSelection(value:Boolean):void
    {
        if (_requireSelection == value)
            return;
        
        _requireSelection = value;
             
        if (_requireSelection)
            ensureRequiredSelection();
    }

    //----------------------------------
    //  selectionLength
    //----------------------------------
       
    /**
     *  @private
     *  Cache the selectionLength.  Only recalculate if selectionLength is -1.
     */
    private var _selectionLength:int = 0;    
    
    /**
     *  The length of the selection.
     * 
     *  <p>If the <code>selectionMode</code> is either 
     *  <code>GridSelectionMode.SINGLE_ROW</code> or
     *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, contains the number of
     *  selected rows.  If a selected row has no <code>columns</code> whose 
     *  <code>visible</code> property is set to <code>true</code> it is still
     *  included in the number of selected rows.</p>
     * 
     *  <p>If the <code>selectionMode</code> is either 
     *  <code>GridSelectionMode.SINGLE_CELL</code> or
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, contains the number of
     *  selected cells.  
     *  If a selected cell is in a column which has its <code>visible</code>
     *  property set to false after it is selected, the cell is included in 
     *  the number of selected cells.</p>
     * 
     *  <p>If the <code>selectionMode</code> is <code>GridSelectionMode.NONE</code>, 
     *  contains 0.</p>
     *  
     *  @default 0
     * 
     *  @return Number of selected rows or cells.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectionLength():int
    {
        // Note: this assumes there are no duplicate cells in cellRegions - ie
        // 2 adds of the same cell without an intermediate delete.
        
        const isRows:Boolean = isRowSelectionMode();
        
        if (_selectionLength < 0)
        {
            _selectionLength = 0;
            
            const cellRegionsLength:int = cellRegions.length;            
            /*for (var i:int = 0; i < cellRegionsLength; i++)
            {
                var cr:CellRect = cellRegions[i];
                const numSelected:int = isRows ? cr.height : cr.height * cr.width;
               
                if (cr.isAdd)
                    _selectionLength += numSelected;
                else
                    _selectionLength -= numSelected;
            }*/
        }
        
        return _selectionLength;        
    }
    
    //----------------------------------
    //  selectionMode
    //----------------------------------
    
    private var _selectionMode:String = GridSelectionMode.SINGLE_ROW;
    
    /**
     *  The selection mode of the control.  Possible values are:
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, 
     *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
     *  <code>GridSelectionMode.NONE</code>, 
     *  <code>GridSelectionMode.SINGLE_CELL</code>, and 
     *  <code>GridSelectionMode.SINGLE_ROW</code>.
     * 
     *  <p>Changing the <code>selectionMode</code> causes the 
     *  current selection to be cleared.</p>
     *
     *  @default GridSelectionMode.SINGLE_ROW
     * 
     *  @see spark.components.gridClasses.GridSelectionMode
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectionMode():String
    {
        return _selectionMode;
    }
    
    /**
     *  @private
     */
    public function set selectionMode(value:String):void
    {
        if (value == _selectionMode)
            return;
        
        switch (value)
        {
            case GridSelectionMode.SINGLE_ROW:
            case GridSelectionMode.MULTIPLE_ROWS:
            case GridSelectionMode.SINGLE_CELL:
            case GridSelectionMode.MULTIPLE_CELLS:
            case GridSelectionMode.NONE:
                _selectionMode = value;
                removeAll();
                break;
        }
    }
    
    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_CELL</code> or
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, returns a list of all the
     *  selected cells.
     * 
     *  @return Vector of selected cell locations as row and column indices or,
     *  if none are selected, a Vector of length 0.  
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
	
    public function allCells():Vector.<CellPosition>
    {
        var cells:Vector.<CellPosition> = new Vector.<CellPosition>;
    	/*    
        if (!isCellSelectionMode())
            return cells;

        // Iterate over the selected cells region.
        const bounds:Rectangle = getCellRegionsBounds();        
        const left:int = bounds.left;
        const right:int = bounds.right;
        const bottom:int = bounds.bottom;
              
        for (var rowIndex:int = bounds.top; rowIndex < bottom; rowIndex++)
        {
            for (var columnIndex:int = left; columnIndex < right; columnIndex++)
            {
                if (regionsContainCell(rowIndex, columnIndex))
                    cells.push(new CellPosition(rowIndex, columnIndex));
            }
        }
        */
        return cells;
    }
     
    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_ROW</code> or
     *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns a list of all the
     *  selected rows.
     * 
     *  @return Vector of selected rows as row indices or, if none, a Vector 
     *  of length 0.  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function allRows():Vector.<int>
    {
        if (!isRowSelectionMode())
            return new Vector.<int>(0, true);
        
        var rows:Vector.<int> = new Vector.<int>();
        
        const bounds:Rectangle = getCellRegionsBounds();
        const bottom:int = bounds.bottom;
                
        for (var rowIndex:int = bounds.top; rowIndex < bottom; rowIndex++)
        {
            // row is represented as cell in column 0 of the row   
            if (regionsContainCell(rowIndex, 0))
                rows.push(rowIndex);
        }
       
        return rows;
    }

    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_ROWS</code> 
     *  selects all the rows in the grid and if <code>selectionMode</code> is 
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, selects all the cells in
     *  columns with <code>visible</code> set to <code>true</code>.
     * 
     *  @return <code>true</code> if the selection changed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectAll():Boolean
    {
        const maxRows:int = getGridDataProviderLength();

        if (selectionMode == GridSelectionMode.MULTIPLE_ROWS)
        {
            return setRows(0, maxRows);
        }
        else if (selectionMode == GridSelectionMode.MULTIPLE_CELLS)
        {
            const maxColumns:int = getGridColumnsLength();
            return setCellRegion(0, 0, maxRows, maxColumns);
        }
            
        return false;
     }
    
    /**
     *  Remove the current selection.  
     *  If <code>requireSelection</code> is <code>true</code>,
     *  and the <code>selectionMode</code> is row-based, then row 0
     *  is selected.
     *  If the <code>selectionMode</code> is cell-based,
     *  then cell 0,0 is selected.
     * 
     *  @return <code>true</code> if the list of selected items has changed from the last call.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function removeAll():Boolean
    {
        var selectionChanged:Boolean = removeSelection();        
        return ensureRequiredSelection() || selectionChanged;
    }
            
    //----------------------------------
    //  Rows
    //----------------------------------

    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_ROW</code> or
     *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, determines if the row is in 
     *  the current selection. 
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @return <code>true</code> if the row is in the selection
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function containsRow(rowIndex:int):Boolean
    {
        if (!validateIndex(rowIndex))
            return false;

        return regionsContainCell(rowIndex, 0);
    }
    
    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
     *  determines if the rows are in the current selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @return <code>true</code> if the rows are in the selection
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function containsRows(rowsIndices:Vector.<int>):Boolean
    {
        if (!validateIndices(rowsIndices))
            return false;
        
        for each (var rowIndex:int in rowsIndices)
        {
            if (!regionsContainCell(rowIndex, 0))
                return false;            
        }
                
        return true;
    }
    
    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_ROW</code> 
     *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, replaces the current 
     *  selection with the specified row.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @return <code>true</code> if no errors, or <code>false</code> if the 
     *  <code>rowIndex</code> is not a valid index in the control's <code>dataProvider</code>, 
     *  or if the <code>selectionMode</code> is not valid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function setRow(rowIndex:int):Boolean
    {        
        if (!validateIndex(rowIndex))
            return false;
    
        internalSetCellRegion(rowIndex);
                
        return true;
    }
    
    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
     *  adds the row to the selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @return <code>true</code> if no errors, or <code>false</code> if the 
     *  <code>rowIndex</code> is not a valid index in the 
     *  control's <code>dataProvider</code>, or the <code>selectionMode</code> is not valid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function addRow(rowIndex:int):Boolean
    {
        if (!validateIndex(rowIndex))
            return false;
             
        if (selectionMode != GridSelectionMode.MULTIPLE_ROWS)
            return false;
        
        internalAddCell(rowIndex);

        return true;
   }
    
    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_ROW</code> 
     *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, removes the row from 
     *  the selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @return <code>true</code> if no errors.
     *  Returns <code>false</code> if the 
     *  <code>rowIndex</code> is not a valid index in the 
     *  control's <code>dataProvider</code>, 
     *  or if the <code>selectionMode</code> is not valid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function removeRow(rowIndex:int):Boolean
    {
        if (!validateIndex(rowIndex) )
            return false;
        
        if (requireSelection && containsRow(rowIndex) && selectionLength == 1)
            return false;
                            
        internalRemoveCell(rowIndex);
        
        return true;
    }
    
    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
     *  replaces the current selection with the <code>rowCount</code> rows starting at 
     *  <code>rowIndex</code>.
     * 
     *  @param rowIndex 0-based row index of the first row in the selection.
     *  @param rowCount Number of rows in the selection.
     * 
     *  @return <code>true</code> if no errors. 
     *  Returns <code>false</code> if any of the indices are invalid,
     *  if <code>startRowIndex</code> is not less than or equal to <code>endRowIndex</code>,
     *  or if the <code>selectionMode</code> is not valid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function setRows(rowIndex:int, rowCount:int):Boolean
    {
        if (!validateRowRegion(rowIndex, rowCount))
            return false;

        internalSetCellRegion(rowIndex, 0, rowCount, 1);
         
        return true;
    }
     
    //----------------------------------
    //  Cells
    //----------------------------------

    /**
     *  If the <code>selectionMode</code> is either 
     *  <code>GridSelectionMode.SINGLE_CELLS</code> 
     *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, determines if the cell 
     *  is in the current selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @param columnsIndex The 0-based column index.
     * 
     *  @return <code>true</code> if the cell is in the selection.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function containsCell(rowIndex:int, columnIndex:int):Boolean
    {   
        if (!validateCell(rowIndex, columnIndex))
            return false;
                
        return regionsContainCell(rowIndex, columnIndex);
    }
        
    /**
     *  If the <code>selectionMode</code> is
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, determines if all the 
     *  cells in the cell region are in the current selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @param columnsIndex The 0-based column index.
     * 
     *  @param rowCount The row height of the region.
     * 
     *  @param columnsCount The width of the cell region, in columns.
     * 
     *  @return <code>true</code> if the cells are in the selection.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function containsCellRegion(rowIndex:int, columnIndex:int,
                                       rowCount:int, columnCount:int):Boolean
    {
        if (!validateCellRegion(rowIndex, columnIndex, rowCount, columnCount))
            return false;
        
        if (rowCount * columnCount > selectionLength)
            return false;
        
        const cellRegionsLength:int = cellRegions.length;
        
        if (cellRegionsLength == 0)
            return false;
        
        // Simple selection.
        /*
        if (cellRegionsLength == 1)
        {
            const cr:CellRect = cellRegions[0];
            return (rowIndex >= cr.top && columnIndex >= cr.left &&
                    rowIndex + rowCount <= cr.bottom &&
                    columnIndex + columnCount <= cr.right);
        }
        */
        // Not a simple selection so we're going to have to check each cell.
        
        const bottom:int = rowIndex + rowCount;
        const right:int = columnIndex + columnCount;
        
        for (var r:int = rowIndex; r < bottom; r++)
        {
            for (var c:int = columnIndex; c < right; c++)
            {
                if (!containsCell(r, c))
                    return false;
            }
        }
        
        return true;
    }
        
    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_CELLS</code> 
     *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, replaces the current 
     *  selection with the cell at the given location.  The cell must be in
     *  a visible column.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @param columnsIndex The 0-based column index.
     * 
     *  @return <code>true</code> no errors.
     *  Returns <code>false</code> if 
     *  <code>rowIndex</code> is not a valid index in <code>dataProvider</code>, 
     *  if <code>columnIndex</code> is not a valid index in <code>columns</code>,
     *  if the <code>selectionMode</code> is invalid or the column is not visible.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function setCell(rowIndex:int, columnIndex:int):Boolean
    {
        if (!validateCell(rowIndex, columnIndex))
            return false;
        
        // columns and indexes validated above.
        const columnVisible:Boolean = isColumnVisible(columnIndex);
        if (columnVisible)
            internalSetCellRegion(rowIndex, columnIndex, 1, 1);
        
        return columnVisible;
    }
        
    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_CELLS</code>, 
     *  adds the cell at the given location to the cell selection.  The cell
     *  must be in a visible column.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @param columnsIndex The 0-based column index.
     * 
     *  @return <code>true</code> no errors.
     *  Returns <code>false</code> if 
     *  <code>rowIndex</code> is not a valid index in <code>dataProvider</code>, 
     *  if <code>columnIndex</code> is not a valid index in <code>columns</code>,
     *  if the <code>selectionMode</code> is invalid or the column is not visible.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function addCell(rowIndex:int, columnIndex:int):Boolean
    {   
        if (!validateCellRegion(rowIndex, columnIndex, 1, 1))
            return false;
        
        // columns and indexes validated above.
        const columnVisible:Boolean = isColumnVisible(columnIndex);
        if (columnVisible)
            internalAddCell(rowIndex, columnIndex);
        
        return columnVisible;
    }

    /**
     *  If the <code>selectionMode</code> is either <code>GridSelectionMode.SINGLE_CELL</code>
     *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, removes the cell at the
     *  given position from the cell selection.
     * 
     *  @param rowIndex The 0-based row index.
     * 
     *  @param columnsIndex The 0-based column index.
     * 
     *  @return <code>true</code> if no errors.
     *  Returns <code>false</code> if <code>rowIndex</code>
     *  is not a valid index in <code>dataProvider</code>, or if  
     *  <code>columnIndex</code> is not a valid index in <code>columns</code>,
     *  or if the <code>selectionMode</code> is invalid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function removeCell(rowIndex:int, columnIndex:int):Boolean
    {
        if (!validateCell(rowIndex, columnIndex))
            return false;

        if (requireSelection && containsCell(rowIndex, columnIndex) && selectionLength == 1)
            return false;
        
        internalRemoveCell(rowIndex, columnIndex);
        
        return true;
    }

    /**
     *  If the <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_CELLS</code>, 
     *  replaces the current selection with the cells in the given cell region.
     *  The origin of the cell region is the cell location specified by
     *  <code>rowIndex</code> and <code>columnIndex</code>, the width is
     *  <code>columnCount</code> and the height is <code>rowCound</code>.
     *
     *  <p>Only cells in columns which are visible at the time of selection are
     *  included in the selection.</p>
     *
     *  @param rowIndex The 0-based row index of the origin.
     * 
     *  @param columnsIndex The 0-based column index of the origin.
     * 
     *  @param rowCount The row height of the cell region.
     * 
     *  @param columnsCount The column width of the cell region.
     * 
     *  @return <code>true</code> if no errors.
     *  Returns <code>false</code> if 
     *  <code>rowIndex</code> is not a valid index in <code>dataProvider</code>, 
     *  if <code>columnIndex</code> is not a valid index in <code>columns</code>,
     *  or if the <code>selectionMode</code> is invalid.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public function setCellRegion(rowIndex:int, columnIndex:int, 
                                  rowCount:uint, columnCount:uint):Boolean
    {
        if (!validateCellRegion(rowIndex, columnIndex, rowCount, columnCount))
            return false;

        removeSelection();
        
        var startColumnIndex:int = columnIndex;
        var curColumnCount:int = 0;
        
        const endColumnIndex:int = columnIndex + columnCount - 1;
        for (var i:int = columnIndex; i <= endColumnIndex; i++)
        {    
            // columns and indexes validated above.
            const columnVisible:Boolean = isColumnVisible(i);
            if (columnVisible)
            {
                curColumnCount++;
                continue;
            }
            
            // This column isn't visible so commit the cell region.
            internalAddCellRegion(rowIndex, startColumnIndex, rowCount, curColumnCount);
            
            curColumnCount = 0;
            startColumnIndex = i + 1;
        }
             
        // If the last column(s) are not visible, need to commit the last
        // cell region.
        if (curColumnCount > 0)
            internalAddCellRegion(rowIndex, startColumnIndex, rowCount, curColumnCount);
            
        return true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
        
    /**
     *  @private
     */
    private function isRowSelectionMode():Boolean
    {
        const mode:String = selectionMode;       
        return mode == GridSelectionMode.SINGLE_ROW || 
                mode == GridSelectionMode.MULTIPLE_ROWS;
    }
    
    /**
     *  @private
     */
    private function isCellSelectionMode():Boolean
    {
        const mode:String = selectionMode;        
        return mode == GridSelectionMode.SINGLE_CELL || 
                mode == GridSelectionMode.MULTIPLE_CELLS;
    }     
    
    /**
     *  @private
     *  Assumes columns is set and index is valid.
     */
    private function isColumnVisible(columnIndex:int):Boolean
    {
        return false; // GridColumn(grid.columns.getItemAt(columnIndex)).visible;
    }
    
    /**
     *  @private
     */
    private function getGridColumnsLength():uint
    {
        if (grid == null)
            return 0;
        
        const columns:IList = grid.columns;
        return (columns) ? columns.length : 0;
    }
    
    /**
     *  @private
     */
    private function getGridDataProviderLength():uint
    {
        if (grid == null)
            return 0;
        
        const dataProvider:IList = grid.dataProvider;
        return (dataProvider) ? dataProvider.length : 0;
    }    
        
    /**
     *  @private
     *  True if the given cell is contained in the list of cell regions.
     */
    private function regionsContainCell(rowIndex:int, columnIndex:int):Boolean
    {   
        // Find the index of the last isAdd=true cell region that contains 
        // row,columnIndex.
        const cellRegionsLength:int = cellRegions.length;
        var index:int = -1;
        for (var i:int = 0; i < cellRegionsLength; i++)
        {
            var cr:CellRect = cellRegions[i];
            if (cr.isAdd && cr.containsCell(rowIndex, columnIndex))
                index = i;
        }
        
        // Is there an isAdd=true CellRegion that contains the cell?
        if (index == -1) 
            return false;
        
        // Starting with index, if any subsequent isAdd=false cell region
        // contains row,columnIndex return false.
        for (i = index + 1; i < cellRegionsLength; i++)
        {
            cr = cellRegions[i];
            if (!cr.isAdd && cr.containsCell(rowIndex, columnIndex))
                return false;
        }
        
        return true;
    }

    /**
     *  @private
     *  If requiredSelection, then there must always be at least one row/cell
     *  selected.  If the selection is changed, the caret is changed to match.
     * 
     *  @return true if the selection has changed.
     */    
    private function ensureRequiredSelection():Boolean
    {
        var selectionChanged:Boolean;
        
        if (!requireSelection)
            return false;
        
        if (getGridDataProviderLength() == 0 || getGridColumnsLength() == 0)
             return false;
        
        // If there isn't a selection, set one, using the grid method rather
        // than the internal one, so that the caretPosition will be updated too.
        if (isRowSelectionMode())
        {
            if (selectionLength == 0)
                selectionChanged = grid.setSelectedIndex(0);
        }
        else if (isCellSelectionMode())
        {
            if (selectionLength == 0)
                selectionChanged = grid.setSelectedCell(0, 0);
        }
                
        return selectionChanged;
    }
    
    /**
     *  @private
     *  Remove any currently selected rows, cells and cached items.  This
     *  disregards the requireSelection flag.
     */    
    private function removeSelection():Boolean
    {
        const selectionChanged:Boolean = (selectionLength > 0);
        
        cellRegions.length = 0;       
        _selectionLength = 0;
        selectedItem = null;
        
        return selectionChanged;
    }
        
    /**
     *  @private
     *  True if the selection mode is row-based and the 0-based index is 
     *  valid index in the <code>dataProvider</code>.
     */    
    protected function validateIndex(index:int):Boolean
    {
        // Don't validate.
        if (inCollectionHandler)
            return true;
        
        return isRowSelectionMode() && 
            index >= 0 && index < getGridDataProviderLength();
    }
    
    /**
     *  @private
     *  True if the selection mode is <code>GridSelectionMode.MULTIPLE_ROWS</code>
     *  and each index in indices is a valid index into the 
     *  <code>dataProvider</code>.
     */    
    protected function validateIndices(indices:Vector.<int>):Boolean
    {
        if (selectionMode == GridSelectionMode.MULTIPLE_ROWS)
        {
            // Don't validate.
            if (inCollectionHandler)
                return true;

            for each (var index:int in indices)
            {
                if (index < 0 || index >= getGridDataProviderLength())
                    return false;
            }            
            return true;
        }
        
        return false;
    }
    
    /**
     *  @private
     *  True if the selection mode is <code>GridSelectionMode.SINGLE_CELL</code>
     *  or code>GridSelectionMode.MULTIPLE_CELLS</code>
     *  and the 0-based index is valid index in <code>columns</code>.
     */    
    protected function validateCell(rowIndex:int, columnIndex:int):Boolean
    {
        // Don't validate.
        if (inCollectionHandler)
            return true;

        return isCellSelectionMode() && 
            rowIndex >= 0 && rowIndex < getGridDataProviderLength() &&
            columnIndex >= 0 && columnIndex < getGridColumnsLength();
    }
    
    /**
     *  @private
     *  True if the selection mode is 
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code> and the entire cell region 
     *  is contained within the grid.
     */    
    protected function validateCellRegion(rowIndex:int, columnIndex:int, 
                                          rowCount:int, columnCount:int):Boolean
    {
        if (selectionMode == GridSelectionMode.MULTIPLE_CELLS)
        {
            // Don't validate.
            if (inCollectionHandler)
                return true;

            const maxRows:int = getGridDataProviderLength();
            const maxColumns:int = getGridColumnsLength();
            return (rowIndex >= 0 && rowCount >= 0 &&
                    rowIndex + rowCount <= maxRows &&
                    columnIndex >= 0 && columnCount >= 0 &&
                    columnIndex + columnCount <= maxColumns);
        }
        
        return false;       
    }
    
    /**
     *  @private
     *  True if the selection mode is 
     *  <code>GridSelectionMode.MULTIPLE_ROW</code> and the entire row region 
     *  is contained within the grid.
     */    
    protected function validateRowRegion(rowIndex:int, rowCount:int):Boolean
    {
        if (selectionMode == GridSelectionMode.MULTIPLE_ROWS)
        {
            // Don't validate.
            if (inCollectionHandler)
                return true;
            
            const maxRows:int = getGridDataProviderLength();
            return (rowIndex >= 0 && rowCount >= 0 && rowIndex + rowCount <= maxRows);
        }
        
        return false;       
    }
            
    /**
     *  @private
     *  Initalize the list of cellRegions with this one.
     */
    private function internalSetCellRegion(rowIndex:int, columnIndex:int=0, 
                                           rowCount:uint=1, columnCount:uint=1):void
    {
        const cr:CellRect = 
            new CellRect(rowIndex, columnIndex, rowCount, columnCount, true);
        
        removeSelection();
        cellRegions.push(cr);
        
        _selectionLength = rowCount * columnCount;
        
        if (preserveSelection && 
            (selectionMode == GridSelectionMode.SINGLE_ROW || 
            selectionMode == GridSelectionMode.SINGLE_CELL))
        {
            selectedItem = grid.dataProvider.getItemAt(rowIndex);
        }
    }

    /**
     *  @private
     *  This should only be called by setCellRegion after the selection has been
     *  removed.
     *  This will add a cellRegion to the list of cellRegions.
     *  This allows the special-handling needed for setting a cell region 
     *  which has one of more columns which are not visible since only visible columns should
     *  be included in the selection.
     *  
     *  The code is not equipped to handle the general case of overlapping
     *  cell regions.
     */
    private function internalAddCellRegion(rowIndex:int, columnIndex:int=0, 
                                           rowCount:uint=1, columnCount:uint=1):void
    {
        const cr:CellRect = 
            new CellRect(rowIndex, columnIndex, rowCount, columnCount, true);
        
        cellRegions.push(cr);
        
        _selectionLength += rowCount * columnCount;
    }

    /**
     *  @private
     *  Add the given row/cell to the list of cellRegions.
     */
    private function internalAddCell(rowIndex:int, columnIndex:int=0):void
    {
        if (!regionsContainCell(rowIndex, columnIndex))
        {
            const cr:CellRect = 
                new CellRect(rowIndex, columnIndex, 1, 1, true);
            cellRegions.push(cr);
            
            // If the length is current before this add, just increment the 
            // length.
            if (_selectionLength >= 0)
                _selectionLength++;
        }
    }
              
    /**
     *  @private
     *  Remove the given row/cell from the list of cellRegions.
     */
    private function internalRemoveCell(rowIndex:int, columnIndex:int=0):void
    {
        if (regionsContainCell(rowIndex, columnIndex))
        {
            const cr:CellRect = 
                new CellRect(rowIndex, columnIndex, 1, 1, false);
            cellRegions.push(cr);
            
            // If the length is current before this remove, just decrement the 
            // length.
            if (_selectionLength >= 0)
                _selectionLength--;
            
            selectedItem = null;
        }
    }
    
    /**
     *  @private
     *  Find the bounding box for all the added cell regions.  It could be
     *  larger than the current selection region if cell regions have been
     *  removed.
     */

	private function getCellRegionsBounds():Rectangle
    {
        var bounds:Rectangle = new Rectangle();/*                         
        const cellRegionsLength:int = cellRegions.length;
        for (var i:int = 0; i < cellRegionsLength; i++)
        {
            var cr:CellRect = cellRegions[i];
            if (!cr.isAdd)
                continue;
                
            bounds = bounds.union(cr);
        }
        */
        return bounds;
    }
      
    //--------------------------------------------------------------------------
    //
    //  Data Provider Collection methods
    //
    //-------------------------------------------------------------------------- 

    /**
     *  @private
     *  Called when the grid's dataProvider dispatches a 
     *  <code>CollectionEvent.COLLECTION_CHANGE</code> event.  It handles
     *  each of the events defined in <code>CollectionEventKind</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function dataProviderCollectionChanged(event:CollectionEvent):Boolean
    {
        var selectionChanged:Boolean = false;
        
        inCollectionHandler = true;
        
        switch (event.kind)
        {
            case CollectionEventKind.ADD: 
            {
                selectionChanged = dataProviderCollectionAdd(event);
                break;
            }
                
            case CollectionEventKind.MOVE:
            {
                selectionChanged = dataProviderCollectionMove(event);
                break;
            }

            case CollectionEventKind.REFRESH:
            {
                selectionChanged = dataProviderCollectionRefresh(event);
                break;
            }

            case CollectionEventKind.REMOVE:
            {
                selectionChanged = dataProviderCollectionRemove(event);
                break;
            }
                
            case CollectionEventKind.REPLACE:
            {
                selectionChanged = dataProviderCollectionReplace(event);
                break;
            }
                
            case CollectionEventKind.RESET:
            {
                selectionChanged = dataProviderCollectionReset(event);
                break;
            }

            case CollectionEventKind.UPDATE:
            {
                selectionChanged = dataProviderCollectionUpdate(event);
                break;
            }                
        }
        
        inCollectionHandler = false;
        
        return selectionChanged;
    }
        
    /**
     *  @private
     *  Add an item to the collection.
     */
    private function dataProviderCollectionAdd(event:CollectionEvent):Boolean
    {
        var selectionChanged:Boolean = handleRowAdd(event.location, event.items.length);        
        return ensureRequiredSelection() || selectionChanged;
    }

    /**
     *  @private
     */
    private function handleRowAdd(insertIndex:int, insertCount:int=1):Boolean
    {
        var selectionChanged:Boolean = false;
        
        for (var cnt:int = 0; cnt < insertCount; cnt++)
        {
            for (var crIndex:int = 0; crIndex < cellRegions.length; crIndex++)
            {
                var cr:CellRect = cellRegions[crIndex];
                
                // If the insert is before the region or at the first row of
                // the region, move the region down a row.  If the insert is
                // in the region (but not the first row), split the region
                // into two and insert the new region.
                /*if (insertIndex <= cr.y)
                {
                    cr.y++;
                    selectionChanged = true;
                }
                else if (insertIndex < cr.bottom)
                {
                    var newCR:CellRect = 
                        new CellRect(insertIndex + 1, cr.x, 
                            cr.bottom - insertIndex, cr.width, 
                            cr.isAdd);
                    
                    cr.height = insertIndex - cr.y;
                    
                    // insert newCR just after cr
                    cellRegions.splice(++crIndex, 0, newCR);                    
                    _selectionLength = -1;      // recalculate
                    selectionChanged = true;
                }*/
            }
        }
        
        return selectionChanged;
    }

    /**
     *  @private
     *  The item has been moved from the oldLocation to location.
     */
    private function dataProviderCollectionMove(event:CollectionEvent):Boolean
    {
        var selectionChanged:Boolean = false;
        
        const oldRowIndex:int = event.oldLocation;
        var newRowIndex:int = event.location;
        
        selectionChanged = handleRowRemove(oldRowIndex);
        
        // If the row is removed before the newly added item
        // then change index to account for this.
        if (newRowIndex > oldRowIndex)
            newRowIndex--;

        return handleRowAdd(newRowIndex) || selectionChanged;
    }

    /**
     *  @private
     *  The sort or filter on the collection changed.
     */
    private function dataProviderCollectionRefresh(event:CollectionEvent):Boolean
    {       
        return handleRefreshAndReset(event);
    }
      
    /**
     *  @private
     *  If preserving the selection and the selected item is in the new view, 
     *  keep the item selected.  Otherwise, clear the selection (or maintain one
     *  if requireSelection is true).
     */
    private function handleRefreshAndReset(event:CollectionEvent):Boolean
    {
        // Is the selectedItem still in the collection?
        if (selectedItem)
        {
            const view:ICollectionView = event.currentTarget as ICollectionView;       
            if (view && view.contains(selectedItem))
            {
                // Selection is in view so move it to the new row location.
                const newRowIndex:int = grid.dataProvider.getItemIndex(selectedItem);
                if (selectionMode == GridSelectionMode.SINGLE_ROW)
                {
                    internalSetCellRegion(newRowIndex);
                }
                else
                {
                    var oldSelectedCell:CellPosition = allCells()[0];
                    internalSetCellRegion(newRowIndex, oldSelectedCell.columnIndex);
                }
                return true;
            }
        }
        
        // Not preserving selection or selection not in current view so remove 
        // selection.
        var selectionChanged:Boolean = removeSelection();
        return ensureRequiredSelection() || selectionChanged;
    }
    
    /**
     *  @private
     *  An item has been removed from the collection.
     */
    private function dataProviderCollectionRemove(event:CollectionEvent):Boolean
    {
        if (getGridDataProviderLength() == 0)
            return removeSelection();

        var selectionChanged:Boolean = handleRowRemove(event.location, event.items.length);         
        return ensureRequiredSelection() || selectionChanged;
    }
     
    /**
     *  @private
     */
    private function handleRowRemove(removeIndex:int, removeCount:int=1):Boolean
    {
        var selectionChanged:Boolean = false;
        
        for (var cnt:int = 0; cnt < removeCount; cnt++)
        {
            var crIndex:int = 0
            while (crIndex < cellRegions.length)
            {
                var cr:CellRect = cellRegions[crIndex];
                
                // Handle the cases where the remove is before the cell region
                // or in the cell region.
                /*if (removeIndex < cr.y)
                {
                    cr.y--;
                    selectionChanged = true;
                }
                else if (removeIndex >= cr.y && removeIndex < cr.bottom)
                {
                    _selectionLength = -1;  // recalculate 
                    selectionChanged = true;
                    cr.height--;
                    if (cr.height == 0)
                    {
                        cellRegions.splice(crIndex, 1);
                        continue;
                    }
                }*/
                crIndex++;
            }
        }
        
        return selectionChanged;
    }
        
    /**
     *  @private
     *  The item has been replaced.
     */
    private function dataProviderCollectionReplace(event:CollectionEvent):Boolean
    {
        // Nothing to do here unless we're saving the data items to preserve
        // the selection.
        return false;
    }
    
    /**
     *  @private
     *  The data source changed or all the items were removed from the data
     *  source.  If there is a preserved selected item and it is in the new
     *  data source the selection will be maintained.
     */
    private function dataProviderCollectionReset(event:CollectionEvent):Boolean
    {        
        return handleRefreshAndReset(event);
    }

    /**
     *  @private
     *  One or more items in the collection have been updated.
     */
    private function dataProviderCollectionUpdate(event:CollectionEvent):Boolean
    {
        // Nothing to do.
        return false;
    }

    //--------------------------------------------------------------------------
    //
    //  Columns Collection methods
    //
    //-------------------------------------------------------------------------- 
    
    /**
     *  @private
     *  Called when the grid's columns dispatches a 
     *  <code>CollectionEvent.COLLECTION_CHANGE</code> event.  It handles
     *  each of the events defined in <code>CollectionEventKind</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function columnsCollectionChanged(event:CollectionEvent):Boolean
    {
        var selectionChanged:Boolean = false;

        inCollectionHandler = true;
        
        switch (event.kind)
        {
            case CollectionEventKind.ADD: 
            {
                selectionChanged = columnsCollectionAdd(event);
                break;
            }
                
            case CollectionEventKind.MOVE:
            {
                selectionChanged = columnsCollectionMove(event);
                break;
            }
                                
            case CollectionEventKind.REMOVE:
            {
                selectionChanged = columnsCollectionRemove(event);
                break;
            }
                
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
            {
                break;
            }
                
            case CollectionEventKind.REFRESH:
            {
                selectionChanged = columnsCollectionRefresh(event);
                break;                
            }
            case CollectionEventKind.RESET:
            {
                selectionChanged = columnsCollectionReset(event);
                break;                
           }
        }
        
        inCollectionHandler = false;
        
        return selectionChanged;
    }

    /**
     *  @private
     *  Add a column to the columns collection.
     */
    private function columnsCollectionAdd(event:CollectionEvent):Boolean
    {
        // If no selectionMode or a row-based selectionMode, nothing to do.
        if (!isCellSelectionMode())
            return false;
        
        var selectionChanged:Boolean = handleColumnAdd(event.location, event.items.length);
        
        return ensureRequiredSelection() || selectionChanged;
    }

    /**
     *  @private
     */
    private function handleColumnAdd(insertIndex:int, insertCount:int=1):Boolean
    {
        var selectionChanged:Boolean = false;

        for (var cnt:int = 0; cnt < insertCount; cnt++)
        {
            for (var crIndex:int = 0; crIndex < cellRegions.length; crIndex++)
            {
                var cr:CellRect = cellRegions[crIndex];
                
                // If the insert is to the left of the region or at the 
                // first column of the region, move the region to the right a
                // column.  If the insert is in the region (but not the first
                // column), split the region into two and insert the new region.
                /*if (insertIndex <= cr.x)
                {
                    cr.x++;
                    selectionChanged = true;
                }
                else if (insertIndex < cr.x)
                {
                    var newCR:CellRect = 
                        new CellRect(cr.y, insertIndex + 1,
                            cr.height, cr.right - insertIndex, 
                            cr.isAdd);
                    
                    cr.width = insertIndex - cr.x;
                    
                    // insert newCR just after cr
                    cellRegions.splice(++crIndex, 0, newCR);
                    _selectionLength = -1;  // recalculate 
                    selectionChanged = true;
                }*/
            }
        }
        
        return selectionChanged;
    }

    /**
     *  @private
     *  The column has been moved from the oldLocation to location in the 
     *  columns collection.
     */
    private function columnsCollectionMove(event:CollectionEvent):Boolean
    {
        // If no selectionMode or a row-based selectionMode, nothing to do.
        if (!isCellSelectionMode())
            return false;

        const oldColumnIndex:int = event.oldLocation;
        var newColumnIndex:int = event.location;
        
        var selectionChanged:Boolean = handleColumnRemove(oldColumnIndex);
        
        // If the column is removed before the newly added column
        // then change index to account for this.
        if (newColumnIndex > oldColumnIndex)
            newColumnIndex--;
        
        return handleColumnAdd(newColumnIndex) || selectionChanged;
    }   

    /**
     *  @private
     *  A column has been removed from the columns collection.
     */
    private function columnsCollectionRemove(event:CollectionEvent):Boolean
    {
        // If no selectionMode or a row-based selectionMode, nothing to do.
        if (!isCellSelectionMode())
            return false;

        if (getGridColumnsLength() == 0)
            return removeSelection();
        
        var selectionChanged:Boolean = handleColumnRemove(event.location, event.items.length);         
        return ensureRequiredSelection() || selectionChanged;
    }
    
    /**
     *  @private
     */
    private function handleColumnRemove(removeIndex:int, removeCount:int=1):Boolean
    {
        var selectionChanged:Boolean = false;
        
        for (var cnt:int = 0; cnt < removeCount; cnt++)
        {
            var crIndex:int = 0
            while (crIndex < cellRegions.length)
            {
                var cr:CellRect = cellRegions[crIndex];
                
                // Handle the cases where the remove is before the cell region
                // or in the cell region.
                /*if (removeIndex < cr.x)
                {
                    cr.x--;
                    selectionChanged = true;
                }
                else if (removeIndex >= cr.x && removeIndex < cr.right)
                {
                    _selectionLength = -1;  // recalculate
                    selectionChanged = true;
                    cr.width--;
                    if (cr.width == 0)
                    {
                        cellRegions.splice(crIndex, 1);
                        continue;
                    }
                }*/
                crIndex++;
            }
        }  
        
        return selectionChanged;
    }

    /**
     *  @private
     *  The sort or filter on the collection changed. For columns, this is
     *  the same as a "reset" event.
     */
    private function columnsCollectionRefresh(event:CollectionEvent):Boolean
    {
        return columnsCollectionReset(event);
    }

    /**
     *  @private
     *  The columns changed.  If the selectionMode is cell-based, don't preserve 
     *  the selection.
     */
    private function columnsCollectionReset(event:CollectionEvent):Boolean
    {
        // If no selectionMode or a row-based selectionMode, nothing to do.
        if (!isCellSelectionMode())
            return false;

        var selectionChanged:Boolean = removeSelection();        
        return ensureRequiredSelection() || selectionChanged;
    }
}
}

// import flash.geom.Rectangle;
import org.apache.royale.geom.Rectangle;
/**
 * @private
 * A CellRect is a rectangle with one additional, isAdd property.
 * A CellRect for a row is represented with columnIndex=0 and columnCount=1.
 * 
 * Mappings between Rectangle and selection cell regions:
 *     y = rowIndex
 *     x = columnIndex
 *     height = rowCount
 *     width = columnCount
 */
internal class CellRect extends Rectangle
{
    private var _isAdd:Boolean = false;
	public function get isAdd():Boolean
	{
		return _isAdd;
	}
	
	public function set isAdd(value:Boolean):void
	{
		_isAdd = value;
	}                                         
    // For a row, columnIndex=0 and columnCount=1.
    public function CellRect(rowIndex:int, columnIndex:int, 
                               rowCount:uint, columnCount:uint, isAdd:Boolean)
    {
        super(columnIndex, rowIndex, columnCount, rowCount);
        this.isAdd = isAdd;
    }
    
    public function containsCell(cellRowIndex:int, cellColumnIndex:int):Boolean
    {
        return contains(cellColumnIndex, cellRowIndex);
    }
}