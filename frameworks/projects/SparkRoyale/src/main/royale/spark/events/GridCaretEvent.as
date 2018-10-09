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

// import flash.events.Event;
import org.apache.royale.events.Event;

/**
 *  The GridCaretEvent class represents events that are dispatched when 
 *  the caret changes in a Spark DataGrid control as the result of 
 *  user interaction.
 *
 *  @see spark.components.DataGrid
 *  @see spark.components.Grid
 *  @see spark.components.gridClasses.GridSelectionMode
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
public class GridCaretEvent extends Event
{
    // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>GridSelectionEvent.CARET_CHANGE</code> constant defines 
     *  the value of the <code>type</code> property of the event object for a 
     *  <code>caretChange</code> event, which indicates that the current 
     *  caret position has just been changed.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>newColumnIndex</code></td><td>The zero-based column 
     *       index of the caret position after it was changed.  It is -1 if
     *       the <code>selectionMode</code> is row-based.</td></tr>
     *     <tr><td><code>newRowIndex</code></td><td>The zero-based row index 
     *       of the caret position after it was changed.</td></tr>
     *     <tr><td><code>oldColumnIndex</code></td><td>The zero-based column 
     *       index of the caret position before it was changed.  It is -1 if
     *       the <code>selectionMode</code> is row-based.</td></tr>
     *     <tr><td><code>oldRowIndex</code></td><td>The zero-based row index 
     *       of the caret position before it was changed.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>GirdCaretEvent.CARET_CHANGE</td></tr>
     *  </table>
     *   
     *  @eventType caretChange
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public static const CARET_CHANGE:String = "caretChange";
        
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param oldColumnIndex The zero-based column index of the caret position
     *  before the change.  If the <code>selectionMode</code> is either 
     *  <code>SelectionMode.SINGLE_ROW</code> or 
     *  <code>SelectionMode.MULTIPLE_ROWS</code>, this is -1.
     * 
     *  @param oldRowIndex The zero-based row index of the caret position before 
     *  the change.
     * 
     *  @param newColumnIndex The zero-based column index of the caret position
     *  after the change.  If the <code>selectionMode</code> is either 
     *  <code>SelectionMode.SINGLE_ROW</code> or 
     *  <code>SelectionMode.MULTIPLE_ROWS</code>, this is -1.
     * 
     *  @param newRowIndex The zero-based row index of the caret position after 
     *  the change.
     * 
     *  @see spark.components.DataGrid#columns
     *  @see spark.components.DataGrid#dataProvider
     *  @spark.events.GridSelectionEventKind
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function GridCaretEvent(type:String, 
                                       bubbles:Boolean = false,
                                       cancelable:Boolean = false,
                                       oldRowIndex:int = -1,
                                       oldColumnIndex:int = -1,
                                       newRowIndex:int = -1,
                                       newColumnIndex:int = -1)
     {
        super(type, bubbles, cancelable);

        this.oldRowIndex = oldRowIndex;
        this.oldColumnIndex = oldColumnIndex;
        this.newRowIndex = newRowIndex;
        this.newColumnIndex = newColumnIndex;
    }

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------
       
    
    //----------------------------------
    //  oldRowIndex
    //----------------------------------

    /**
     *  The zero-based index of the row of the
     *  caret position before it was changed.
     * 
     *  @default -1
     * 
     *  @see spark.components.DataGrid#dataProvider
     *  @see spark.components.Grid#dataProvider
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    private var _oldRowIndex:int;
	public function get oldRowIndex():int
	{
		return _oldRowIndex;
	}
	
	public function set oldRowIndex(value:int):void
	{
		_oldRowIndex = value;
	}
    //----------------------------------
    //  oldColumnIndex
    //----------------------------------
    
    /**
     *  The zero-based index of the column of the
     *  caret position before it was changed.      
     * 
     *  <p>If the <code>selectionMode</code> is <code>SelectionMode.SINGLE_ROW</code> or 
     *  <code>SelectionMode.MULTIPLE_ROWS</code>, this valueis -1 to indicate
     *  it is not being used.</p>
     *  
     *  @see spark.components.DataGrid#columns
     *  @see spark.components.Grid#columns
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    private var _oldColumnIndex:int;
	public function get oldColumnIndex():int
	{
		return _oldColumnIndex;
	}
	
	public function set oldColumnIndex(value:int):void
	{
		_oldColumnIndex = value;
	}
    //----------------------------------
    //  newRowIndex
    //----------------------------------
    
    /**
     *  The zero-based index of the row of the
     *  caret position after it was changed.
     * 
     *  @see spark.components.DataGrid#dataProvider
     *  @see spark.components.Grid#dataProvider
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    private var _newRowIndex:int;
	public function get newRowIndex():int
	{
		return _newRowIndex;
	}
	
	public function set newRowIndex(value:int):void
	{
		_newRowIndex = value;
	}
    //----------------------------------
    //  newColumnIndex
    //----------------------------------
    
    /**
     *  The zero-based index of the column of the
     *  caret position after it was changed.  
     * 
     *  <p>If the <code>selectionMode</code> is <code>SelectionMode.SINGLE_ROW</code> or 
     *  <code>SelectionMode.MULTIPLE_ROWS</code> this will be -1 to indicate
     *  it is not being used.</p>
     *  
     *  @see spark.components.DataGrid#columns
     *  @see spark.components.Grid#columns
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    private var _newColumnIndex:int;    
	public function get newColumnIndex():int
	{
		return _newColumnIndex;
	}
	
	public function set newColumnIndex(value:int):void
	{
		_newColumnIndex = value;
	}
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Object
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /*override public function toString():String
    {
        return formatToString(
            "GridCaretEvent", "type", 
            "bubbles", "cancelable", "eventPhase",
            "oldRowIndex","oldColumnIndex", 
            "newRowIndex", "newColumnIndex");
    }*/
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /*override public function clone():Event
    {
        return new GridCaretEvent(
            type, bubbles, cancelable, 
            oldRowIndex, oldColumnIndex, 
            newRowIndex, newColumnIndex);
    }*/
}

}
