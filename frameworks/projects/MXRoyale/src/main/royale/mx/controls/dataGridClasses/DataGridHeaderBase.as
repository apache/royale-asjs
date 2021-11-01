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

package mx.controls.dataGridClasses
{

import mx.core.UIComponent;
import org.apache.royale.display.Graphics;
import mx.events.MouseEvent;
import org.apache.royale.geom.Matrix;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.DataGrid;
import mx.core.EdgeMetrics;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.events.DataGridEvent;
import mx.managers.CursorManager;
import mx.managers.CursorManagerPriority;
import mx.styles.ISimpleStyleClient;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The DataGridHeaderBase class defines the base class for the DataGridHeader class,
 *  the class that defines the item renderer for the DataGrid control. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataGridHeaderBase extends UIComponent
{

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function DataGridHeaderBase()
    {
        super();
    }

    /**
     *  a layer to draw selections
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal var selectionLayer:UIComponent;

    /**
     *  a function to clear selections
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function clearSelectionLayer():void
    {
    }

   /**
     *  @private
     *  the set of columns for this header
     */
    mx_internal var visibleColumns:Array;

   /**
     *  @private
     *  the set of columns for this header
     */
    mx_internal var headerItemsChanged:Boolean = false;
}

}