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
     *  The EditorActivationMouseEvent class defines the possible values for the 
     *  the kinds of mouse events that cause an editor to be opened on a Spark
     *  DataGrid component.
     *  
     *  @see spark.components.DataGrid
     *
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
public final class GridItemEditorActivationMouseEvent
{
    // include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  A single click mouse evnet on a previously selected cell.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public static const SINGLE_CLICK_ON_SELECTED_CELL:String = "singleClickOnSelectedCell";

    /**
     *  A single click mouse event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public static const SINGLE_CLICK:String = "singleClick";

    /**
     *  A double click mouse event. A DataGrid component must have its 
     *  <code>doubleClickEnabled</code> property set to <code>true</code>
     *  in order for the component to receive a double click mouse event. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public static const DOUBLE_CLICK:String = "doubleClick";

    
    /**
     *  No mouse event will cause an editor to be opened. An editor may still
     *  be opened using the keyboard or programatically.
     *    
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public static const NONE:String = "none";
    
}
}