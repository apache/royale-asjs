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
import mx.core.IInvalidating;
import mx.core.IVisualElement;
import mx.managers.ILayoutManagerClient;

import spark.components.DataGrid;

/**
 *  Visual elements of the Spark DataGrid control that must 
 *  remain in sync with the grid's layout and scroll
 *  position must implement this interface.   
 *  When the DataGrid control's <code>grid</code> skin part is added, 
 *  it sets the <code>IDataGridElement.dataGrid</code> property. 
 *  The IDataGridElements object can respond by adding event listeners 
 *  for scroll position changes.  
 *  When the DataGrid control is changed in a way that affects 
 *  its row or column layout, all IDataGridElements object are invalidated.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5 
 */
public interface IDataGridElement extends IVisualElement, ILayoutManagerClient, IInvalidating
{
    /**
     *  The DataGrid control associated with this element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get dataGrid():DataGrid;
    function set dataGrid(value:DataGrid):void;        
}
}