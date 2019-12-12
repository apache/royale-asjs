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

package mx.controls
{
/*
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import mx.collections.CursorBookmark;
import mx.collections.IList;
import mx.collections.ItemResponder;
import mx.collections.ItemWrapper;
import mx.collections.ModifiedCollectionView;
import mx.collections.errors.ItemPendingError;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.listClasses.ListBaseContentHolder;
import mx.controls.listClasses.ListBaseSeekPending;
import mx.controls.listClasses.ListData;
import mx.controls.listClasses.ListItemRenderer;
import mx.controls.listClasses.ListRowInfo;
import mx.controls.scrollClasses.ScrollBar;
import mx.core.EdgeMetrics;
import mx.core.EventPriority;
import mx.core.FlexShape;
import mx.core.FlexSprite;
import mx.core.IChildList;
import mx.core.IFactory;
import mx.core.IIMESupport;
import mx.core.IInvalidating;
import mx.core.IPropertyChangeNotifier;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.ListEvent;
import mx.events.ListEventReason;
import mx.events.SandboxMouseEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDetail;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;

use namespace mx_internal;
*/
    
import mx.core.ClassFactory;
import mx.controls.listClasses.ListBase;

//[IconFile("List.png")]

[DataBindingInfo("acceptedTypes", "{ dataProvider: { label: &quot;String&quot; } }")]

[DefaultProperty("dataProvider")]

[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

[DefaultTriggerEvent("change")]

[AccessibilityClass(implementation="mx.accessibility.ListAccImpl")]

/**
 *  Dispatched when the user releases the mouse button while over an item,
 *  tabs to the List or within the List, or in any other way
 *  attempts to edit an item.
 *
 *  @eventType mx.events.ListEvent.ITEM_EDIT_BEGINNING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemEditBeginning", type="mx.events.ListEvent")]

/**
 *  Dispatched when the <code>editedItemPosition</code> property is set
 *  and the item can be edited.
 *
 *  @eventType mx.events.ListEvent.ITEM_EDIT_BEGIN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemEditBegin", type="mx.events.ListEvent")]

/**
 *  Dispatched when an item editing session is ending for any reason.
 *
 *  @eventType mx.events.ListEvent.ITEM_EDIT_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemEditEnd", type="mx.events.ListEvent")]

/**
 *  Dispatched when an item renderer gets focus, which can occur if the user
 *  clicks on an item in the List control or navigates to the item using a 
 *  keyboard.
 *  Only dispatched if the list item is editable.
 *
 *  @eventType mx.events.ListEvent.ITEM_FOCUS_IN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemFocusIn", type="mx.events.ListEvent")]

/**
 *  Dispatched when an item renderer loses the focus, which can occur if the 
 *  user clicks another item in the List control or outside the list, 
 *  or uses the keyboard to navigate to another item in the List control
 *  or outside the List control.
 *  Only dispatched if the list item is editable.
 *
 *  @eventType mx.events.ListEvent.ITEM_FOCUS_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemFocusOut", type="mx.events.ListEvent")]

//--------------------------------------
//  Effects
//--------------------------------------

/**
 *  The data effect to play when a change occur to the control's data provider.
 *
 *  <p>By default, the List control does not use a data effect. 
 *  For the List control, use an instance of the the DefaultListEffect class 
 *  to configure the data effect. </p>
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="itemsChangeEffect", event="itemsChange")]

[Alternative(replacement="spark.components.List", since="4.0")]

/**
 *  The List control displays a vertical list of items.
 *  Its functionality is very similar to that of the SELECT
 *  form element in HTML.
 *  If there are more items than can be displayed at once, it
 *  can display a vertical scroll bar so the user can access
 *  all items in the list.
 *  An optional horizontal scroll bar lets the user view items
 *  when the full width of the list items is unlikely to fit.
 *  The user can select one or more items from the list, depending
 *  on the value of the <code>allowMultipleSelection</code> property.
 *
 *  <p>The List control has the following default sizing 
 *     characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to fit the widest label in the first seven 
 *               visible items (or all visible items in the list, if 
 *               there are less than seven); seven rows high, where 
 *               each row is 20 pixels high.</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels.</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>5000 by 5000.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:List&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:List
 *    <b>Properties</b>
 *    editable="false|true"
 *    editedItemPosition="<i>No default</i>"
 *    editorDataField="text"
 *    editorHeightOffset="0"
 *    editorUsesEnterKey="false|true"
 *    editorWidthOffset="0"
 *    editorXOffset="0"
 *    editorYOffset="0"
 *    imeMode="null"    
 *    itemEditor="TextInput"
 *    itemEditorInstance="<i>Current item editor</i>"
 *    rendererIsEditor="false|true"
 *    
 *    <b>Styles</b>
 *    backgroundDisabledColor="0xDDDDDD"
 *    
 *    <b>Events</b>
 *    itemEditBegin="<i>No default</i>"
 *    itemEditEnd="<i>No default</i>"
 *    itemEditBeginning="<i>No default</i>"
 *    itemFocusIn="<i>No default</i>"
 *    itemFocusOut="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SimpleList.mxml
 *
 *  @see mx.events.ListEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class List extends ListBase // implements IIMESupport
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function List()
    {
        super();
        typeNames = "List";
    }


    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  editable
    //----------------------------------

    private var _editable:Boolean = false;

    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether or not the user can edit
     *  items in the data provider.
     *  If <code>true</code>, the item renderers in the control are editable.
     *  The user can click on an item renderer to open an editor.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get editable():Boolean
    {
        return _editable;
    }

    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        _editable = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    [Inspectable(category="Data", defaultValue="undefined")]

    /**
     *  @private
    override public function set dataProvider(value:Object):void
    {
        if (itemEditorInstance)
            endEdit(ListEventReason.OTHER);
        
        super.dataProvider = value;
    }
     */

}

}
