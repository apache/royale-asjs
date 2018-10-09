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
 *  The GridSelectionMode class defines the valid constant values for the 
 *  <code>selectionMode</code> property of the Spark DataGrid and Grid controls.
 *  
 *  <p>Use the constants in ActionsScript, as the following example shows: </p>
 *  <pre>
 *    myDG.selectionMode = GridSelectionMode.MULTIPLE_CELLS;
 *  </pre>
 *
 *  <p>In MXML, use the String value of the constants, 
 *  as the following example shows:</p>
 *  <pre>
 *    &lt;s:DataGrid id="myGrid" width="350" height="150"
 *        selectionMode="multipleCells"&gt; 
 *        ...
 *    &lt;/s:DataGrid&gt; 
 *  </pre>
 * 
 *  @see spark.components.DataGrid#selectionMode
 *  @see spark.components.Grid#selectionMode
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public final class GridSelectionMode
{
    
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function GridSelectionMode()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Specifies that no selection is allowed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const NONE:String = "none";

    /**
     *  Specifies that one row can be selected.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SINGLE_ROW:String = "singleRow";

    /**
     *  Specifies that one or more rows can be selected.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const MULTIPLE_ROWS:String = "multipleRows";

    /**
     *  Specifies that one cell can be selected.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const SINGLE_CELL:String = "singleCell";

    /**
     *  Specifies that one or more cells can be selected.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const MULTIPLE_CELLS:String = "multipleCells";
    
}
}