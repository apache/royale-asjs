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

package mx.events
{

/* import flash.events.Event;
 */
import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

 
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;

/**
 *   The AdvancedDataGridEvent class represents event objects that are specific to
 *   the AdvancedDataGrid control, such as the event that is dispatched when an 
 *   editable grid item gets the focus.
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.events.AdvancedDataGridEventReason
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class AdvancedDataGridEvent extends Event
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The AdvancedDataGridEvent.ITEM_CLOSE event type constant indicates that a AdvancedDataGrid
     *  branch closed or collapsed.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the data associated with the column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer for the node that closed.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>-1</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_CLOSE</td></tr>
     *  </table>
     *
     *  @eventType itemClose
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_CLOSE:String = "itemClose";
    
    /**
     *  The AdvancedDataGridEvent.ITEM_EDIT_BEGIN constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemEditBegin</code> event, which indicates that an 
     *  item is ready to be edited. 
     *
     *  <p>The default listener for this event performs the following actions:</p>
     * 
     *  <ul>
     *    <li>Creates an item editor object by using a call to the
     *    <code>createItemEditor()</code> method.</li>
     *    <li>Copies the <code>data</code> property
     *    from the item to the editor. By default, the item editor object is an instance 
     *    of the TextInput control. You use the <code>itemEditor</code> property of the 
     *    list control to specify a custom item editor class.</li>
     *
     *    <li>Sets the <code>itemEditorInstance</code> property of the list control 
     *    to reference the item editor instance.</li>
     *  </ul>
     *
     *  <p>You can write an event listener for this event to modify the data passed to 
     *  the item editor. For example, you might modify the data, its format, or other information 
     *  used by the item editor.</p>
     *
     *  <p>You can also create an event listener to specify the item editor used to 
     *  edit the item. For example, you might have two different item editors. 
     *  Within the event listener, you can examine the data to be edited or 
     *  other information, and open the appropriate item editor by doing the following:</p>
     * 
     *  <ol>
     *     <li>Call <code>preventDefault()</code> to stop Flex from calling 
     *         the <code>createItemEditor()</code> method as part 
     *         of the default event listener.</li>
     *     <li>Set the <code>itemEditor</code> property to the appropriate editor.</li>
     *     <li>Call the <code>createItemEditor()</code> method.</li>
     *  </ol>
     *
     *  <p>The properties of the event object have the following values:</p>
     *
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>null</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node).</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer for the item
     *       that is being edited.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_EDIT_BEGIN</td></tr>
     *  </table>
     *
     *  @eventType itemEditBegin
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";

    /**
     *  The AdvancedDataGridEvent.ITEM_EDIT_END constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemEditEnd</code> event, which indicates that an edit 
     *  session is ending.  
     *
     *  <p>The list components have a default handler for this event that copies the data 
     *  from the item editor to the data provider of the list control. 
     *  The default event listener performs the following actions:</p>
     * 
     *  <ul>
     *    <li>Uses the <code>editorDataField</code> property of the AdvancedDataGridColumn 
     *    associated with this event to 
     *    determine the property of the item editor containing the new data and updates
     *    the data provider item with that new data.
     *    Since the default item editor is the TextInput control, the default value of the 
     *    <code>editorDataField</code> property 
     *    is <code>"text"</code>, to specify that the <code>text</code> property of the 
     *    TextInput contains the new item data.</li>
     *
     *    <li>Calls the <code>destroyItemEditor()</code> method to close the item editor.</li>
     *  </ul>
     *
     *  <p>You typically write an event listener for this event to perform the following actions:</p>
     *  <ul>
     *    <li>In your event listener, you can modify the data returned by the editor 
     *    to the list component. For example, you can reformat the data before returning 
     *    it to the list control. By default, an item editor can only return a single value. 
     *    You must write an event listener for the <code>itemEditEnd</code> event 
     *    if you want to return multiple values.</li> 
     *
     *    <li>In your event listener, you can examine the data entered into the item editor. 
     *    If the data is incorrect, you can call the <code>preventDefault()</code> method 
     *    to stop Flex from passing the new data back to the list control and from closing 
     *    the editor. </li>
     *  </ul>
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the item's column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer for the item
     *       that is being edited.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>A constant defining the reason for the event. 
     *       The value must be a member of the <code>AdvancedDataGridEventReason</code> class.</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_EDIT_END</td></tr>
     *  </table>
     *
     *  @eventType itemEditEnd
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_EDIT_END:String = "itemEditEnd"

    /**
     *  The AdvancedDataGridEvent.ITEM_FOCUS_IN constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemFocusIn</code> event, which indicates that an 
     *  item has received the focus. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>null</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item editor instance for the item
     *       that is being edited.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_FOCUS_IN</td></tr>
     *  </table>
     *
     *  @eventType itemFocusIn
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
    */
   public static const ITEM_FOCUS_IN:String = "itemFocusIn";

    /**
     *  The AdvancedDataGridEvent.ITEM_FOCUS_OUT constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemFocusOut</code> event, which indicates that an 
     *  item has lost the focus. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>null</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item editor instance for the item
     *       that is being edited.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_FOCUS_OUT</td></tr>
     *  </table>
     *
     *  @eventType itemFocusOut
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_FOCUS_OUT:String = "itemFocusOut";

    /**
     *  The AdvancedDataGridEvent.ITEM__EDIT_BEGINNING constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>itemEditBeginning</code> event, which indicates that the user has 
     *  prepared to edit an item, for example, by releasing the mouse button 
     *  over the item. 
     *
     *  <p>The default listener for this event sets the <code>AdvancedDataGrid.editedItemPosition</code> 
     *  property to the item that has focus, which starts the item editing session.</p>
     *
     *  <p>You typically write your own event listener for this event to 
     *  disallow editing of a specific item or items. 
     *  Calling the <code>preventDefault()</code> method from within your own 
     *  event listener for this event prevents the default listener from executing.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the item's column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The item renderer for the item
     *       that will be edited. This property is null if this event is
     *       generated by keyboard, as the item to be edited may be off-screen.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_EDIT_BEGINNING</td></tr>
     *  </table>
     *
     *  @eventType itemEditBeginning
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";
    
    /**
     *  The AdvancedDataGridEvent.ITEM_OPEN event type constant indicates that an AdvancedDataGrid
     *  branch opened or expanded.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid node that opened.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer for the item (node) that opened.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>-1</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the item (node) opened in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_OPEN</td></tr>
     *  </table>
     *
     *  @eventType itemOpen
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_OPEN:String = "itemOpen";
    
    /**
     *  The AdvancedDataGridEvent.ITEM_OPENING event type constant is dispatched immediately 
     *  before a AdvancedDataGrid opens or closes.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>animate</code></td><td>Whether to animate the opening 
     *             or closing operation.</td></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *              event listener that handles the event. For example, if you use
     *              <code>myButton.addEventListener()</code> to register an event
     *              listener, myButton is the value of the <code>currentTarget</code>.</td></tr>
     *     <tr><td><code>dispatchEvent</code></td><td>Whether to dispatch an 
     *             <code>ITEM_OPEN</code> or <code>ITEM_CLOSE</code> event
     *              after the open or close animation is complete. true</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid node that opened.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer for the item (node) that opened.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>-1</td></tr>
     *     <tr><td><code>opening</code></td><td><code>true</code> if the item is opening, false
     *             if it is closing.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the item opened in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.ITEM_OPENING</td></tr>
     *  </table>
     *
     *  @eventType itemOpening
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_OPENING:String = "itemOpening";

    /**
     *  The AdvancedDataGridEvent.COLUMN_STRETCH constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>columnStretch</code> event, which indicates that a
     *  user expanded a column horizontally.
     *  <p>The properties of the event object have the following values:</p>
     * 
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>null</td></tr>
     *     <tr><td><code>localX</code></td><td>The x position of the mouse.</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>The zero-based index of the 
     *       item in the data provider.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.COLUMN_STRETCH</td></tr>
     *  </table>
     *
     *  @eventType columnStretch
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public static const COLUMN_STRETCH:String = "columnStretch";

    /**
     *  The AdvancedDataGridEvent.HEADER_DRAG_OUTSIDE constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>headerDragOutside</code> event, which indicates that the
     *  user pressed and released the mouse on a column header.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the column.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The header renderer that is
     *       being released.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>rowIndex</code></td><td>null</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.HEADER_RELEASE</td></tr>
     *  </table>
     *
     *  @eventType headerDragOutside
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public static const HEADER_DRAG_OUTSIDE:String = "headerDragOutside";

    /**
     *  The AdvancedDataGridEvent.HEADER_DROP_OUTSIDE constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>headerDropOutside</code> event.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The header renderer that is
     *       being released.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>false</code></td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>null</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.HEADER_RELEASE</td></tr>
     *  </table>
     *
     *  @eventType headerDropOutside
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public static const HEADER_DROP_OUTSIDE:String = "headerDropOutside";

    /**
     *  The AdvancedDataGridEvent.HEADER_RELEASE constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>headerRelease</code> event, which indicates that the
     *  user pressed and released the mouse on a column header.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the column.</td></tr>
     *     <tr><td><code>item</code></td><td>The AdvancedDataGrid item (node) that closed.</td></tr>
     *     <tr><td><code>itemRenderer</code></td><td>The header renderer that is
     *       being released.</td></tr>
     *     <tr><td><code>localX</code></td><td>NaN</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td><code>undefined</code> - Use the <code>sort</code> event
     *       if you want to sort on multiple columns. </td></tr>
     *     <tr><td><code>reason</code></td><td>null</td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>rowIndex</code></td><td>null</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.HEADER_RELEASE</td></tr>
     *  </table>
     *
     *  @eventType headerRelease
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const HEADER_RELEASE:String = "headerRelease";
    
    /**
     *  The AdvancedDataGridEvent.SORT constant defines the value of the 
     *  <code>type</code> property of the event object for a 
     *  <code>sort</code> event. 
     *  The AdvancedDataGrid control performs sorting based on the value of the 
     *  <code>dataField</code> and <code>multiColumnSort</code> properties.
     * 
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     *     <tr><td><code>columnIndex</code></td><td> The zero-based index of the 
     *       item's column in the AdvancedDataGrid object's <code>columns</code> array.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>dataField</code></td><td>The name of the field or property in the
     *       data associated with the column.</td></tr>
     *     <tr><td><code>multiColumnSort </code></td><td>If <code>true</code>, 
     *       indicates that the new <code>dataField</code> property 
     *       should be used along with whatever sorting
     *       is already in use, resulting in a multicolumn sort.
     * 
     *       <p>If <code>false</code>, any sorting present should be removed,
     *       and a fresh sorting should be done for the new <code>dataField</code> property.</p>
     *       </td></tr>
     *     <tr><td><code>removeColumnFromSort</code></td><td><code>false</code></td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>triggerEvent</code></td>
     *         <td>If the node closed in response to a user action,
     *             identifies it as a keyboard action or a mouse action.</td></tr>
     *     <tr><td><code>type</code></td><td>AdvancedDataGridEvent.SORT</td></tr>
     *  </table>
     *
     * @eventType sort
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const SORT:String = "sort";

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
     *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
     *
     *  @param columnIndex The zero-based index of the column where the event occurred.
     *
     *  @param dataField  The name of the field or property in the data associated with the column.
     *
     *  @param rowIndex The zero-based index of the item in the data provider.
     *
     *  @param reason The reason for an <code>itemEditEnd</code> event.
     *
     *  @param itemRenderer The item renderer that is being edited or the header renderer that
     *  was clicked.
     *
     *  @param localX Column x position for replaying <code>columnStretch</code> events.
     *
     *  @param multiColumnSort Specifies a multicolumn sort.
     *
     *  @param removeColumnFromSort Specifies to remove the column from the multicolumn sort.
     *
     *  @param item Specifies the <code>node</code> property. .
     *
     *  @param triggerEvent The MouseEvent or KeyboardEvent that triggered this
     *  event or <code>null</code> if this event was triggered programmatically.
     *
     *  @param headerPart The part of the header that was clicked.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function AdvancedDataGridEvent(type:String, bubbles:Boolean = false,
                                  cancelable:Boolean = false,
                                  columnIndex:int = -1,
                                  dataField:String = null,
                                  rowIndex:int = -1,
                                  reason:String = null,
                                  itemRenderer:IListItemRenderer = null,
                                  localX:Number = NaN,
                                  multiColumnSort:Boolean = false,
                                  removeColumnFromSort:Boolean = false,
                                  item:Object = null,
                                  triggerEvent:Event = null,
                                  headerPart:String = null)
    {
        super(type, bubbles, cancelable);

        this.columnIndex = columnIndex;
        this.dataField = dataField;
        this.rowIndex = rowIndex;
        this.reason = reason;
        this.itemRenderer = itemRenderer;
      //  this.localX = localX;
       // this.multiColumnSort = multiColumnSort;
       // this.removeColumnFromSort = removeColumnFromSort;
       // this.item = item;
       // this.triggerEvent = triggerEvent;
       // this.headerPart = headerPart;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  animate
    //----------------------------------

    /**
     *  If <code>true</code>, animate an opening or closing operation; used for 
     *  <code>ITEM_OPENING</code> type events only.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var animate:Boolean;
    
    //----------------------------------
    //  columnIndex
    //----------------------------------

    /**
     *  The zero-based index in the AdvancedDataGrid object's <code>columns</code> Array
     *  of the column associated with the event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var columnIndex:int;

    //----------------------------------
    //  dataField
    //----------------------------------

    /**
     *  The name of the field or property in the data associated with the column.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var dataField:String;
    
    //----------------------------------
    //  dispatchEvent
    //----------------------------------

    /**
     *  Whether to dispatch an <code>ITEM_OPEN</code> or 
     *  <code>ITEM_CLOSE</code> event after the open or close animation 
     *  is complete. Used for <code>ITEM_OPENING</code> events only.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var dispatchEvent:Boolean;
    
    //----------------------------------
    //  item
    //----------------------------------

    /**
     *  Storage for the <code>node</code> property.
     *  If you populate the AdvancedDataGrid control from XML data, access
     *  the <code>label</code> and <code>data</code> properties for 
     *  the <code>node</code> as
     *  <code>event.node.attributes.label</code> and
     *  <code>event.node.attributes.data</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var item:Object;

    //----------------------------------
    //  itemRenderer
    //----------------------------------

    /**
     *  The item renderer for the item that is being edited, or the header
     *  render that is being clicked or stretched.
     *  You can access the data provider by using this property. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var itemRenderer:IListItemRenderer;

    //----------------------------------
    //  localX
    //----------------------------------

    /**
     *  The column's x-position, in pixels; used for replaying column stretch events.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public var localX:Number;
    
    //----------------------------------
    //  multiColumnSort
    //----------------------------------
    
    /**
     *  If <code>true</code>, indicates that the new <code>dataField</code> property 
     *  should be used along with whatever sorting
     *  is already in use, resulting in a multicolumn sort.
     *
     *  <p>If <code>false</code>, any sorting present should be removed,
     *  and a fresh sorting should be done for the new <code>dataField</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var multiColumnSort:Boolean;
    
    //----------------------------------
    //  removeColumnFromSort
    //----------------------------------

    /**
     *  If <code>true</code>, remove the column from the multicolumn sort.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var removeColumnFromSort:Boolean;

    //----------------------------------
    //  opening
    //----------------------------------

    /**
     *  Indicates whether the item 
     *  is opening <code>true</code>, or closing <code>false</code>.
     *  Used for an <code>ITEM_OPENING</code> type events only.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var opening:Boolean;

    //----------------------------------
    //  reason
    //----------------------------------

    /**
     *  The reason the <code>itemEditEnd</code> event was dispatched. 
     *  Valid only for events with type <code>ITEM_EDIT_END</code>.
     *  The possible values are defined in the AdvancedDataGridEventReason class.
     * 
     *  @see AdvancedDataGridEventReason
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var reason:String;

    //----------------------------------
    //  rowIndex
    //----------------------------------

    /**
     *  The zero-based index of the item in the data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var rowIndex:int;
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------

    /**
     *  The MouseEvent object or KeyboardEvent object for the event that triggered this
     *  event, or <code>null</code> if this event was triggered programmatically.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var triggerEvent:Event;

    //----------------------------------
    //  parent
    //----------------------------------

    /**
     * The AdvancedDataGridColumnGroup instance for the column that caused the event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
  //  public var column:AdvancedDataGridColumn;

    //----------------------------------
    //  headerPart
    //----------------------------------

    /**
     * If HEADER_RELEASE event, which part of the header was clicked.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   // public var headerPart:String;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function cloneEvent():Event
    {
        return new AdvancedDataGridEvent(type, bubbles, cancelable,
                                 columnIndex, dataField, rowIndex,
                                 null, null, null,
                                 false, null,
                                 null, null, "");
    }
}

}