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
import mx.core.IIMESupport;
import mx.core.IVisualElement;
import mx.managers.IFocusManagerComponent;

import spark.components.gridClasses.GridItemRenderer;
import spark.components.gridClasses.GridColumn;
import spark.components.DataGrid;

/**
 *  The IGridItemEditor interface defines the interface that item editors for 
 *  the Spark DataGrid and Spark Grid controls must implement. 
 *  The DataGrid and Grid controls are referred to as the item renderer owner,
 *  or as the host component of the item editor.
 * 
 *  <p>All of the item editor's properties are set by the owner during 
 *  the start of the editor session. 
 *  The <code>data</code> property is the last property set. 
 *  When the <code>data</code> property is set, an item editor should
 *  set the value of the editor's controls. 
 *  Next, the editor's <code>prepare()</code> method is called. 
 *  IGridItemEditor implementations should override the <code>prepare()</code> method 
 *  to make any final adjustments to its properties or any aspect of its visual elements. 
 *  When the editor is closing, the <code>discard()</code> method is called.</p>
 *  
 *  <p>When the editor is closed, the input value can be saved or canceled. 
 *  If saving, the <code>save()</code> function is called by the editor
 *  to write new values to the data provider element corresponding to the 
 *  row of the edited cell. </p>
 *
 *  @see spark.components.DataGrid
 *  @see spark.components.Grid
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5 
 */
public interface IGridItemEditor extends IDataRenderer, IVisualElement, 
                                 IFocusManagerComponent, IIMESupport
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dataGrid
    //----------------------------------
    
    /**
     *  The control that owns this item editor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    function get dataGrid():DataGrid;

    //----------------------------------
    //  column
    //----------------------------------
    
    /**
     *  The column of the cell being edited.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    function get column():GridColumn;
    function set column(value:GridColumn):void;
    
    //----------------------------------
    //  columnIndex
    //----------------------------------
    
    /** 
     *  The zero-based index of the column being edited.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */ 
    function get columnIndex():int;

    //----------------------------------
    //  rowIndex
    //----------------------------------
    
    /** 
     *  The zero-based index of the row of the cell being edited.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */ 
    function get rowIndex():int;
    function set rowIndex(value:int):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Called after the editor has been created and sized but before the 
     *  editor is visible. 
     *  Use this method to adjust the appearance of the editor,
     *  add event listeners, or perform any other initializations 
     *  before it becomes visible.
     *  
     *  <p>Do not call this method directly. 
     *  It should only be called by the control hosting the item editor.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */ 
    function prepare():void;
    
    /**
     *  Called just before the editor is closed. 
     *  Use this method to perform any final cleanup, 
     *  such as cleaning up anything that was set in the 
     *  <code>prepare()</code> method.
     *  
     *  <p>Do not call this method directly. 
     *  It should only be called by the control hosting the item editor.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */ 
    function discard():void;
    
    /**
     *  Saves the value in the editor to the data provider of the 
     *  item renderer's owner. 
     *  This method updates the data provider element corresponding to the 
     *  row of the edited cell. 
     *  This function calls <code>GridItemEditor.validate()</code> to verify
     *  the data may be saved. 
     *  If the data is not valid, then the data is not saved 
     *  and the editor is not closed.
     * 
     *  <p>Do not call this method directly. 
     *  It should only be called by the control hosting the item editor.
     *  To save and close the editor, call the <code>endItemEditorSession()</code>
     *  method of the item renderer owner.</p>
     *
     *  @return <code>true</code> if the save operation succeeded, 
     *  and <code>false</code> if not.
     *  
     *  @see spark.components.DataGrid
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */  
    function save():Boolean;

    /**
     *  Called by the DataGrid when an open editor is being closed without 
     *  saving the data in the editor. Closing the editor may be 
     *  prevented by returning <code>false</code>
     * .  
     *  <p>Do not call this method directly. 
     *  It should only be called by the control hosting the item editor.
     *  To close the editor without saving its data, call the 
     *  <code>endItemEditorSession()</code> method with the <code>cancel</code>
     *  parameter set to <code>true</code>.</p>
     *
     *  @return <code>true</code> to close the editor without saving its data. 
     *  Return <code>false</code> to prevent the editor from closing.
     *  
     *  @see spark.components.DataGrid
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */  
    function cancel():Boolean;
    
}
}