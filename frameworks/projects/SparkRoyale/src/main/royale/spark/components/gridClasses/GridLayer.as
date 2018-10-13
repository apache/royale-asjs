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
    
import mx.core.IVisualElement;
import mx.core.mx_internal;

import spark.components.Grid;
import spark.components.Group;
import spark.layouts.supportClasses.LayoutBase;

use namespace mx_internal;

/**
 *  The GridLayer class defines a container used for the layers of the 
 *  Grid control's visual elements.  
 *  The Grid control creates and adds visual elements to its layers
 *  as needed, and is responsible for their layout.
 *
 *  @see spark.components.Grid
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class GridLayer extends Group
{
    
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
    public function GridLayer()
    {
        super();
        layout = new LayoutBase();   // essentially "no layout"       
    }
    
    //--------------------------------------------------------------------------
    //
    //  Method Overrides
    //
    //--------------------------------------------------------------------------      
    
    /**
     *  @private
     */
    override public function invalidateDisplayList():void
    {
        const grid:Grid = parent as Grid;
        if (grid && grid.inUpdateDisplayList)
            return;
        
        if (grid)
            grid.invalidateDisplayList();
    }
    
    /**
     *  @private
     */
    override public function invalidateSize():void
    {   
        const grid:Grid = parent as Grid;
        if (grid && grid.inUpdateDisplayList)
            return;
        
        if (grid)
            grid.invalidateSize();        
    }
}
}