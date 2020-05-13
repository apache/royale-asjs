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
import mx.controls.MenuBar;

import org.apache.royale.events.Event;

/*
import flash.events.Event;
import mx.controls.Menu;
import mx.controls.MenuBar;
import mx.controls.listClasses.IListItemRenderer;
*/
/**
 *  The MenuEvent class represents events that are associated with menu 
 *  activities in controls such as Menu, MenuBar, and PopUpMenuButton. 
 *
 *  @see mx.controls.Menu
 *  @see mx.controls.MenuBar
 *  @see mx.controls.PopUpMenuButton
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class MenuEvent extends ListEvent
{
 //   include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The MenuEvent.CHANGE event type constant indicates that selection
     *  changed as a result of user interaction.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>The index in the menu of the selected menu item.</td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>The item in the dataProvider that was selected.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The item renderer of the selected menu item.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td>The label text of the selected menu item.</td></tr>
     *     <tr><td><code>menu</code></td>
     *         <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.CHANGE</td></tr>
     *  </table>
     *
     *  @eventType change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const CHANGE:String = "change";

    /**
     *  The MenuEvent.ITEM_CLICK event type constant indicates that the
     *  user selected a menu item.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>The index in the menu of the selected menu item.</td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>The item in the dataProvider that was selected.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer of the selected menu item.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td>The label text of the selected menu item.</td></tr>
     *     <tr><td><code>menu</code></td>
     *          <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.ITEM_CLICK</td></tr>
     *  </table>
     *
     *  @eventType itemClick
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static const ITEM_CLICK:String = "itemClick";

    /**
     *  The MenuEvent.MENU_HIDE event type constant indicates that
     *  a menu or submenu closed.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>-1. This property is not set for this type of event. </td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>null. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>null. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td>null. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>menu</code></td>
     *          <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.MENU_HIDE</td></tr>
     *  </table>
     *
     *  @eventType menuHide
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
     //public static const MENU_HIDE:String = "menuHide";

    /**
     *  The MenuEvent.ITEM_ROLL_OUT type constant indicates that
     *  the mouse pointer rolled out of a menu item.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>The index in the menu of the menu item that was rolled out of.</td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>The item in the dataProvider corresponding to the menu item that was 
     *          rolled out of.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer of the menu item that was rolled out of.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td>The label text of the menu item that was rolled out of.</td></tr>
     *     <tr><td><code>menu</code></td>
     *          <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.ITEM_ROLL_OUT</td></tr>
     *  </table>
     *
     *  @eventType itemRollOut
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const ITEM_ROLL_OUT:String = "itemRollOut";

    /**
     *  The MenuEvent.ITEM_ROLL_OVER type constant indicates that
     *  the mouse pointer rolled over a menu item.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>The index in the menu of the menu item that was rolled over.</td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>The item in the dataProvider associated with the rolled over 
     *          menu item.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>The ListItemRenderer of the menu item that was rolled over.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td>The label text of the menu item that was rolled over.</td></tr>
     *     <tr><td><code>menu</code></td>
     *          <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.ITEM_ROLL_OVER</td></tr>
     *  </table>
     *
     *  @eventType itemRollOver
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const ITEM_ROLL_OVER:String = "itemRollOver";

    /**
     *  The MenuEvent.MENU_SHOW type constant indicates that
     *  the mouse pointer rolled a menu or submenu opened.
     *
     *  <p>The properties of the event object for this event type have the
     *  following values.
     *  Not all properties are meaningful for all kinds of events.
     *  See the detailed property descriptions for more information.</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>index</code></td>
     *         <td>-1. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>item</code></td>
     *         <td>null. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>itemRenderer</code></td>
     *         <td>null. This property is not set for this type of event.</td></tr>
     *     <tr><td><code>label</code></td>
     *         <td><code>null. This property is not set for this type of event.</code></td></tr>
     *     <tr><td><code>menu</code></td>
     *          <td>The specific Menu instance associated with this event, or 
     *             <code>null</code> if a MenuBar item is dispatching the event.</td></tr>
     *     <tr><td><code>menuBar</code></td>
     *         <td>The MenuBar instance that is the parent of the
     *             Menu control, or <code>null</code> if the Menu control is not
     *             parented by a MenuBar control.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the
     *             event; it is not always the Object listening for the event.
     *             Use the <code>currentTarget</code> property to always access the
     *             Object listening for the event.</td></tr>
     *     <tr><td><code>type</code></td><td>MenuEvent.MENU_SHOW</td></tr>
     *  </table>
     *
     *  @eventType menuShow
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    //public static const MENU_SHOW:String = "menuShow";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     *  Normally called by the Menu object. 
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param menuBar The MenuBar instance that is the parent
     *  of the selected Menu control, or null when the target Menu control
     *  is not parented by a MenuBar control.
     *
     *  @param menu The specific Menu instance associated with the event,
     *  such as the menu or submenu that was hidden or opened. This property
     *  is null if a MenuBar item dispatches the event. 
     *
     *  @param item The item in the dataProvider of the associated menu item.
     *
     *  @param itemRenderer The ListItemRenderer of the associated menu item.
     * 
     *  @param label The label text of the associated menu item.
     * 
     *  @param index The index in the menu of the associated menu item. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function MenuEvent(type:String, bubbles:Boolean = false, 
                              cancelable:Boolean = false, item:Object = null)
	{
		super(type, bubbles, cancelable);
		/*
		this.menuBar = menuBar;
        this.menu = menu;*/
        this.item = item;
		/*
        this.itemRenderer = itemRenderer;
        this.label = label;
        this.index = index;
		*/
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  index
    //----------------------------------
    
    private var _index:int = -1;
    
    /**
     *  The index of the associated menu item within its parent menu or submenu. 
     *  This is -1 for the menuShow and menuHide events.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get index():int
    {
        return _index;
    }
    
    public function set index(value:int):void
    {
        _index = value;
    }
    
    //----------------------------------
    //  item
    //----------------------------------

    /**
     *  The specific item in the dataProvider. 
     *  This is null for the menuShow and menuHide events. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    private var _item:Object;
	
	public function get item():Object
    {
        return _item;
    }

    public function set item(value:Object):void
    {
        _item = value;
    }
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 *  The label text of the associated menu item.
	 *  This is null for the menuShow and menuHide events. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var label:String;
    //----------------------------------
    //  menu
    //----------------------------------

    /**
     *  The specific Menu instance associated with the event,
     *  such as the menu or submenu that was hidden or opened.
     *  
     *  This property is null if a MenuBar item is dispatching
     *  the event. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
	 *	@royalesuppresspublicvarwarning
     */
    public var menu:Object; //Menu;

    //----------------------------------
    //  menuBar
    //----------------------------------

    /**
     *  The MenuBar instance that is the parent of the selected Menu control,
     *  or null when the target Menu control is not parented by a
     *  MenuBar control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public var menuBar:Object;//MenuBar;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  override public function clone():Event
    {
        return new MenuEvent(type, bubbles, cancelable,
                             menuBar, menu, item, itemRenderer, label, index);
    } */
}

}
