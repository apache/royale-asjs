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

package spark.events
{

/**
 *  The GridSelectionEventKind class defines constants for the valid values 
 *  of the spark.events.GridSelectionEvent class <code>kind</code> property.
 *  These constants indicate the kind of change that was made to the selection.
 *
 *  @see spark.events.GridSelectionEvent#kind
 *  @see spark.events.GridSelectionEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public final class GridSelectionEventKind
{
    // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /** 
     *  Indicates that the entire grid should be selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SELECT_ALL:String = "selectAll";

    /** 
     *  Indicates that current selection should be cleared.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const CLEAR_SELECTION:String = "clearSelection";
    
    /** 
     *  Indicates that the current selection should be set to this row.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SET_ROW:String = "setRow";
    
    /** 
     *  Indicates that this row should be added to the current selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const ADD_ROW:String = "addRow";

    /** 
     *  Indicates that this row should be removed from the current selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const REMOVE_ROW:String = "removeRow";

    /** 
     *  Indicates that the current selection should be set to these rows.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SET_ROWS:String = "setRows";
    
    /** 
     *  Indicates that the current selection should be set to this cell.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SET_CELL:String = "setCell";

    /** 
     *  Indicates that this cell should be added to the current selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */    
    public static const ADD_CELL:String = "addCell";
    
    /** 
     *  Indicates that this cell should be removed from the current selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const REMOVE_CELL:String = "removeCell";
    
    /** 
     *  Indicates that the current selection should be set to this cell region.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SET_CELL_REGION:String = "setCellRegion";
}

}
