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
	
	import spark.components.gridClasses.GridColumn;
	
	/**
	 *  The GridItemEditorEvent class represents events that are dispatched over 
	 *  the life cycle of an item editor.
	 *
	 *  <p>The life cycle starts with the dispatch of an <code>
	 *  GRID_ITEM_EDITOR_SESSION_STARTING</code> event. 
	 *  You can cancel the event to stop the editing session by 
	 *  calling the <code>preventDefault()</code> method in the event listener.</p>
	 * 
	 *  <p>After the item editor opens, the <code>GRID_ITEM_EDITOR_SESSION_START</code> 
	 *  is dispatched to notify listeners that the editor has been opened.</p>
	 * 
	 *  <p>The editing session can be saved or canceled. If the session is saved,
	 *  then the <code>GRID_ITEM_EDITOR_SESSION_SAVE</code> event is dispatched.
	 *  If the editor is canceled, a <code>GRID_ITEM_EDITOR_SESSION_CANCEL</code>
	 *  event is dispatched. </p>
	 * 
	 *  @see spark.components.DataGrid
	 *  @see spark.components.gridClasses.IGridItemEditor
	 *  @see spark.components.gridClasses.GridColumn
	 *  @see spark.components.gridClasses.GridColumn#itemEditor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class GridItemEditorEvent extends Event
	{
		// include "../core/Version.as";    
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  The <code>GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING</code> 
		 *  constant defines the value of the <code>type</code> property of the
		 *  event object for a <code>startGridItemEditorSession</code> event. 
		 *  Dispatched when a new item editor session has been requested. A listener
		 *  can dynamically determine if a cell is editable and cancel the edit by calling 
		 *  the <code>preventDefault()</code> method if it is not. 
		 *  A listener can also dynamically change the editor used 
		 *  by assigning a different item editor to a grid column.
		 * 
		 *  <p>If this event is canceled the item editor will not be created.</p>
		 *
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>true</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>columnIndex</code></td><td>The zero-based column 
		 *       index of the requested item editor.</td></tr>
		 *     <tr><td><code>rowIndex</code></td><td>The zero-based row index 
		 *        of the requested item editor.</td></tr>
		 *     <tr><td><code>column</code></td><td>The column of the cell associated
		 *     with the edit request.
		 *     </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>
		 *     GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING</td></tr>
		 *  </table>
		 *   
		 *  @eventType gridItemEditorSessionStarting
		 * 
		 *  @see spark.components.gridClasses.GridColumn
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const GRID_ITEM_EDITOR_SESSION_STARTING:String = "gridItemEditorSessionStarting";
		
		/**
		 *  The <code>GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START</code> 
		 *  constant defines the value of the <code>type</code> property of the
		 *  event object for a <code>openGridItemEditor</code> event. 
		 *  Dispatched immediately after an item editor has been opened. 
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
		 *     <tr><td><code>columnIndex</code></td><td>The zero-based column 
		 *       index of the item editor.</td></tr>
		 *     <tr><td><code>rowIndex</code></td><td>The zero-based row index 
		 *        of the item editor.</td></tr>
		 *     <tr><td><code>column</code></td><td>The column of the cell that is
		 *     being edited.
		 *     </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>
		 *     GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START</td></tr>
		 *  </table>
		 *   
		 *  @eventType gridItemEditorSessionStart
		 * 
		 *  @see spark.components.gridClasses.GridColumn
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const GRID_ITEM_EDITOR_SESSION_START:String = "gridItemEditorSessionStart";
		
		/**
		 *  The <code>GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE</code> 
		 *  constant defines the value of the <code>type</code> property of the
		 *  event object for a <code>saveGridItemEditor</code> event. 
		 *  Dispatched after the data in item editor has been saved into the data 
		 *  provider and the editor has been closed.  
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
		 *     <tr><td><code>columnIndex</code></td><td>The zero-based column 
		 *       index of the item that was modified.</td></tr>
		 *     <tr><td><code>rowIndex</code></td><td>The zero-based row index 
		 *        of the item that was modified.</td></tr>
		 *     <tr><td><code>column</code></td><td>The column of the cell that was
		 *     edited.
		 *     </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>
		 *     GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE</td></tr>
		 *  </table>
		 *   
		 *  @eventType gridItemEditorSessionSave
		 * 
		 *  @see spark.components.gridClasses.GridColumn
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const GRID_ITEM_EDITOR_SESSION_SAVE:String = "gridItemEditorSessionSave";
		
		/**
		 *  The <code>GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL</code> 
		 *  constant defines the value of the <code>type</code> property of the
		 *  event object for a <code>cancelridItemEditor</code> event. 
		 *  Dispatched after the item editor has been closed without saving its data.  
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
		 *     <tr><td><code>columnIndex</code></td><td>The zero-based column 
		 *       index of the item that was edited but not modified.</td></tr>
		 *     <tr><td><code>rowIndex</code></td><td>The zero-based row index 
		 *        of the item that was edited but not modified.</td></tr>
		 *     <tr><td><code>column</code></td><td>The column of the cell that was
		 *     edited.
		 *     </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *     <tr><td><code>type</code></td><td>
		 *     GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL</td></tr>
		 *  </table>
		 *   
		 *  @eventType gridItemEditorSessionCancel
		 * 
		 *  @see spark.components.gridClasses.GridColumn
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public static const GRID_ITEM_EDITOR_SESSION_CANCEL:String = "gridItemEditorSessionCancel";
		
		
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
		 *  @param rowIndex The zero-based index of the column that is being edited.
		 * 
		 *  @param columnIndex The zero-based index of the column that is being edited.
		 * 
		 *  @param column The column that is being edited.
		 *   
		 *  @see spark.components.gridClasses.GridColumn
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function GridItemEditorEvent(type:String, 
											bubbles:Boolean = false, 
											cancelable:Boolean = false,
											rowIndex:uint = 0, //int.MAX_VALUE,
											columnIndex:uint = 0, //int.MAX_VALUE, 
											column:GridColumn = null)
		{
			super(type, bubbles, cancelable);
			
			this.rowIndex = rowIndex;
			this.columnIndex = columnIndex;
			this.column = column;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  columnIndex
		//----------------------------------
		
		/** 
		 *  The zero-based index of the column that is being edited.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */ 
		public var columnIndex:int;
		
		
		//----------------------------------
		//  column
		//----------------------------------
		
		/**
		 *  The column of the cell that is being edited.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public var column:GridColumn;
		
		//----------------------------------
		//  rowIndex
		//----------------------------------
		
		/**
		 *  The index of the row that is being edited.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public var rowIndex:int;
		
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
			var cloneEvent:GridItemEditorEvent = new GridItemEditorEvent(type, bubbles, cancelable, 
				rowIndex, columnIndex, column); 
			
			return cloneEvent;
		}*/
		
	}
}