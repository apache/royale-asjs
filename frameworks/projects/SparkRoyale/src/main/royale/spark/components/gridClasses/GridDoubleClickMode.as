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
    *  The GridDoubleClickMode class defines the valid constant values for the 
    *  <code>doubleClickMode</code> property of the Spark DataGrid and Grid controls.
    *  
    *  <p>Use the constants in ActionsScript, as the following example shows: </p>
    *  <pre>
    *    myDG.doubleClickMode = GridDoubleClickMode.ROW;
    *    myDG.doubleClickEnabled = true;
    *  </pre>
    *
    *  <p>In MXML, use the String value of the constants, 
    *  as the following example shows:</p>
    *  <pre>
    *    &lt;s:DataGrid id="myGrid" width="350" height="150"
    *        doubleClickMode="row" doubleClickEnabled="true"&gt; 
    *        ...
    *    &lt;/s:DataGrid&gt; 
    *  </pre>
    * 
    *  @see spark.components.DataGrid#doubleClickMode
    *  @see spark.components.Grid#doubleClickMode
    *  
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public final class GridDoubleClickMode
    {
        /**
        *  Constructor.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public function GridDoubleClickMode()
        {
        }

        //----------------------------------------
        //  Class constants
        //----------------------------------------

        /**
        *  Specifies that the doubleClick event should be based on a cell.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const CELL:String = "cell";


        /**
        *  Specifies that the doubleClick event should be based on the entire grid.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const GRID:String = "grid";


        /**
        *  Specifies that the doubleClick event should be based on a row.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const ROW:String = "row";

    }
}