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
import mx.core.IDataRenderer;
import mx.core.IVisualElement;

import spark.components.Grid;
    
/**
 *  The IGridItemRenderer interface must be implemented by DataGrid item renderers.  The
 *  DataGrid uses this API to provide the item renderer with the information needed to 
 *  render one grid or header <i>cell</i>.  
 *
 *  <p>All of the renderer's properties are set during the execution of its parent's 
 *  <code>updateDisplayList()</code> method.  After the properties have been set, the 
 *  item renderer's <code>prepare()</code> method is called.  
 *  An IGridItemRenderer implementation should override the <code>prepare()</code> method 
 *  to make any final adjustments to its properties or any aspect of its visual elements.
 *  Typically, the <code>prepare()</code> is used to configure the renderer's visual
 *  elements based on the <code>data</code> property.</p>
 * 
 *  <p>When an item renderer is no longer needed, either because it's going to be added 
 *  to an internal reusable renderer "free" list, or because it's never going to be 
 *  used again, the IGridItemRenderer <code>discard()</code> method is called.</p> 
 * 
 *  @see spark.components.DataGrid
 *  @see spark.components.Grid
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5 
 */
public interface IGridItemRenderer extends IDataRenderer, IVisualElement
{
    /**
     *  The Grid associated with this item renderer, typically just the value of
     *  <code>column.grid</code>.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get grid():Grid;
    
    /**
     *  The zero-based index of the row of the cell being rendered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get rowIndex():int;
    function set rowIndex(value:int):void;
    
    /**
     *  This property is set to <code>true</code> when one of two input gestures occurs within a 
     *  grid cell:  either the mouse button or the touch screen is pressed.   
     *  The <code>down</code> property is reset to <code>false</code> when 
     *  the mouse button goes up, the user lifts off 
     *  the touch screen, or the mouse/touch is dragged out of the grid cell.   
     * 
     *  <p>Unlike a List item renderer, grid item renderers do not have exclusive
     *  responsibility for displaying the down indicator.  The Grid itself
     *  renders the down indicator for the selected row or cell. 
     *  The item renderer can also change its visual properties to emphasize
     *  that it's being pressed.</p>   
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get down():Boolean;
    function set down(value:Boolean):void;
    
    /**
     *  Contains <code>true</code> if the item renderer is being dragged, 
     *  typically as part of a drag and drop operation.
     *  Currently, drag and drop is not supported by the Spark DataGrid control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get dragging():Boolean;
    function set dragging(value:Boolean):void;
    
    /**
     *  Contains <code>true</code> if the item renderer is under the mouse and 
     *  the Grid's selectionMode is <code>GridSelectionMode.SINGLE_CELL</code> or
     *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, or if the mouse is within the 
     *  row the item renderer belongs to and the Grid's selectionMode is 
     *  <code>GridSelectionMode.SINGLE_ROW</code> or 
     *  <code>GridSelectionMode.MULTIPLE_ROWS</code>.
     * 
     *  <p>Unlike a List item renderer, grid item renderers do not have exclusive
     *  responsibility for displaying something to indicate that the renderer 
     *  or its row is under the mouse.  The Grid itself automatically displays the
     *  hoverIndicator skin part for the hovered row or cell.  Grid item renderers 
     *  can also change their properties to emphasize that they're hovered.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get hovered():Boolean;
    function set hovered(value:Boolean):void;
    
    /**
     *  The String to display in the item renderer.  
     * 
     *  <p>The GridItemRenderer class automatically copies the 
     *  value of this property to the <code>text</code> property 
     *  of its <code>labelDisplay</code> element, if that element was specified. 
     *  The Grid sets the <code>label</code> to the value returned by the column's 
     *  <code>itemToLabel()</code> method.</p>
     *
     *  @see spark.components.gridClasses.GridItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get label():String;
    function set label(value:String):void;
    
    /**
     *  Contains <code>true</code> if the item renderer's cell is part 
     *  of the current selection.
     * 
     *  <p> Unlike a List item renderer, 
     *  grid item renderers do not have exclusive responsibility for displaying 
     *  something to indicate that they're part of the selection.  The Grid 
     *  itself automatically displays the selectionIndicator skin part for the 
     *  selected rows or cells.  The item renderer can also change its visual properties 
     *  to emphasize that it's part of the selection.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get selected():Boolean;
    function set selected(value:Boolean):void;
    
    /**
     *  Contains <code>true</code> if the item renderer's cell is indicated by the caret.
     * 
     *  <p> Unlike a List item renderer, grid item renderers do not have exclusive 
     *  responsibility for displaying something to indicate their cell or row has
     *  the caret.  The Grid itself automatically displays the caretIndicator skin part for the 
     *  caret row or cell.  The item renderer can also change its visual properties 
     *  to emphasize that it has the caret.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function get showsCaret():Boolean;
    function set showsCaret(value:Boolean):void;    
    
    /**
     *  The GridColumn object representing the column associated with this item renderer.  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    function get column():GridColumn;
    function set column(value:GridColumn):void;
    
    /**
     *  The column index for this item renderer's cell.  
     *  This is the same value as <code>column.columnIndex</code>.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    function get columnIndex():int;    
    
    /**
     *  Called from the item renderer parent's <code>updateDisplayList()</code> method 
     *  after all of the renderer's properties have been set.  
     *  The <code>hasBeenRecycled</code> parameter is <code>false</code>
     *  if this renderer has not been used before, meaning it was not recycled.  
     *  This method is called when a renderer is about to become visible 
     *  and each time it's redisplayed because of a change in a renderer
     *  property, or because a redisplay was explicitly requested. 
     * 
     *  <p>This method can be used to configure all of a renderer's visual 
     *  elements and properties.
     *  Using this method can be more efficient than binding <code>data</code>
     *  properties to visual element properties.  
     *  Note: Because the <code>prepare()</code> method is called frequently, 
     *  make sure that it is coded efficiently.</p>
     *
     *  <p>The <code>prepare()</code> method may be called many times 
     *  before the <code>discard()</code> method is called.</p>
     * 
     *  <p>This method is not intended to be called directly.
     *  It is called by the DataGrid implementation.</p>
     * 
     *  @param hasBeenRecycled  <code>true</code> if this renderer is being reused.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    function prepare(hasBeenRecycled:Boolean):void;
        
    /**
     *  Called from the item renderer parent's <code>updateDisplayList()</code> method 
     *  when it has been determined that this renderer will no longer be visible.   
     *  If the <code>willBeRecycled</code> parameter is <code>true</code>, 
     *  then the owner adds this renderer to its internal free list for reuse.  
     *  Implementations can use this method to clear any renderer properties that are no longer needed.
     * 
     *  <p>This method is not intended to be called directly.
     *  It is called by the DataGrid implementation.</p>
     * 
     *  @param willBeRecycled <code>true</code> if this renderer is going to be added 
     *  to the owner's internal free list for reuse.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5  
     */
    function discard(willBeRecycled:Boolean):void;
}
}