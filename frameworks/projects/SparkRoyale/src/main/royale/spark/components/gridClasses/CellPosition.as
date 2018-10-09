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

/**
 *  The CellPosition class defines a data structure 
 *  used by the Spark data grid classes to represent selected cells in the 
 *  control.  
 *  Each selected cell is represented by an instance of this class.
 *
 *  @see spark.components.DataGrid#selectedCell
 *  @see spark.components.DataGrid#selectedCells
 *  @see spark.components.Grid#selectedCell
 *  @see spark.components.Grid#selectedCells
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class CellPosition
{    
    // include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @param rowIndex The 0-based row index of the cell. 
     *  A value of -1 indicates that the value is not set.
     * 
     *  @param columnIndex The 0-based column index of the cell. 
     *  A value of -1 indicates that the value is not set.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function CellPosition(rowIndex:int = -1, columnIndex:int = -1)
    {
        super();
        
        _rowIndex = rowIndex;
        _columnIndex = columnIndex;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  columnIndex
    //----------------------------------
    
    private var _columnIndex:int;
    
    /**
     *  The 0-based column index of the cell.
     *  A value of -1 indicates that the value is not set.
     * 
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get columnIndex():int
    {
        return _columnIndex;
    }
    
    /**
     *  @private
     */
    public function set columnIndex(value:int):void
    {
        _columnIndex = value;
    }
    
    //----------------------------------
    //  rowIndex
    //----------------------------------
    
    private var _rowIndex:int;
    
    /**
     *  The 0-based row index of the cell.  
     *  A value of -1 indicates that the value is not set.
     * 
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get rowIndex():int
    {
        return _rowIndex;
    }
    
    /**
     *  @private
     */
    public function set rowIndex(value:int):void
    {
        _rowIndex = value;
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Object
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    public function toString():String
    {
        return "[rowIndex=" + rowIndex + " columnIndex=" + columnIndex + "]";
    }   
}
}