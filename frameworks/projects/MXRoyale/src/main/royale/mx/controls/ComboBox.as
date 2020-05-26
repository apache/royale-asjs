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
import mx.controls.beads.HideComboPopupOnMouseDownBead;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
//import mx.controls.listClasses.ListData;
import mx.events.FlexEvent;

import org.apache.royale.html.beads.IComboBoxView;
import org.apache.royale.core.ISelectionModel;

COMPILE::SWF
{
}

/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;
*/

/*
import mx.collections.ArrayCollection;
import mx.collections.CursorBookmark;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.controls.listClasses.ListBase;
import mx.controls.listClasses.ListData;
import mx.core.ClassFactory;
import mx.core.EdgeMetrics;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.LayoutDirection;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.DropdownEvent;
import mx.events.FlexEvent;
import mx.events.FlexMouseEvent;
import mx.events.InterManagerRequest;
import mx.events.ListEvent;
import mx.events.SandboxMouseEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDetail;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.styles.CSSStyleDeclaration;
import mx.utils.MatrixUtil;

use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the ComboBox contents changes as a result of user
 *  interaction, when the <code>selectedIndex</code> or
 *  <code>selectedItem</code> property changes, and, if the ComboBox control
 *  is editable, each time a keystroke is entered in the box.
 *
 *  @eventType mx.events.ListEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.events.ListEvent")]

/**
 *  Dispatched when the drop-down list is dismissed for any reason such when 
 *  the user:
 *  <ul>
 *      <li>selects an item in the drop-down list</li>
 *      <li>clicks outside of the drop-down list</li>
 *      <li>clicks the drop-down button while the drop-down list is 
 *  displayed</li>
 *      <li>presses the ESC key while the drop-down list is displayed</li>
 *  </ul>
 *
 *  @eventType mx.events.DropdownEvent.CLOSE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="close", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains an item from the
 *  dataProvider.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched if the <code>editable</code> property
 *  is set to <code>true</code> and the user presses the Enter key
 *  while typing in the editable text field.
 *
 *  @eventType mx.events.FlexEvent.ENTER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="enter", type="mx.events.FlexEvent")]

/**
 *  Dispatched when user rolls the mouse out of a drop-down list item.
 *  The event object's <code>target</code> property contains a reference
 *  to the ComboBox and not the drop-down list.
 *
 *  @eventType mx.events.ListEvent.ITEM_ROLL_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemRollOut", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user rolls the mouse over a drop-down list item.
 *  The event object's <code>target</code> property contains a reference
 *  to the ComboBox and not the drop-down list.
 *
 *  @eventType mx.events.ListEvent.ITEM_ROLL_OVER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemRollOver", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user clicks the drop-down button
 *  to display the drop-down list.  It is also dispatched if the user
 *  uses the keyboard and types Ctrl-Down to open the drop-down.
 *
 *  @eventType mx.events.DropdownEvent.OPEN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="open", type="org.apache.royale.events.Event")]

/**
 *  Dispatched when the user scrolls the ComboBox control's drop-down list.
 *
 *  @eventType mx.events.ScrollEvent.SCROLL
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="scroll", type="mx.events.ScrollEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/*
include "../styles/metadata/FocusStyles.as"
include "../styles/metadata/IconColorStyles.as"
include "../styles/metadata/LeadingStyle.as"
include "../styles/metadata/PaddingStyles.as"
include "../styles/metadata/SkinStyles.as"
include "../styles/metadata/TextStyles.as"
*/

/**
 *  The set of BackgroundColors for drop-down list rows in an alternating
 *  pattern.
 *  Value can be an Array of two of more colors.
 *  If <code>undefined</code> then the rows will use the drop-down list's 
 *  backgroundColor style.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes")]

/**
 *  Width of the arrow button in pixels.
 *  
 *  The default value for the Halo theme is 22.
 *  The default value for the Spark theme is 18.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="arrowButtonWidth", type="Number", format="Length", inherit="no")]

/**
 *  The thickness of the border of the drop-down list, in pixels. 
 *  This value is overridden if you define 
 *  <code>borderThickness</code> when setting the 
 *  <code>dropdownStyleName</code> CSSStyleDeclaration. 
 *
 *  @default 1
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="borderThickness", type="Number", format="Length", inherit="no")]

/**
 *  The length of the transition when the drop-down list closes, in milliseconds.
 *  The default transition has the drop-down slide up into the ComboBox.
 *
 *  The default value for the Halo theme is 250.
 *  The default value for the Spark theme is 50.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="closeDuration", type="Number", format="Time", inherit="no")]

/**
 *  An easing function to control the close transition.  Easing functions can
 *  be used to control the acceleration and deceleration of the transition.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="closeEasingFunction", type="Function", inherit="no")]

/**
 *  The color of the border of the ComboBox.  If <code>undefined</code>
 *  the drop-down list will use its normal borderColor style.  This style
 *  is used by the validators to show the ComboBox in an error state.
 * 
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dropdownBorderColor", type="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  The name of a CSSStyleDeclaration to be used by the drop-down list.  This
 *  allows you to control the appearance of the drop-down list or its item
 *  renderers.
 * 
 *  [deprecated]
 *
 *  @default "comboDropDown"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dropDownStyleName", type="String", inherit="no", deprecatedReplacement="dropdownStyleName")]

/**
 *  The name of a CSSStyleDeclaration to be used by the drop-down list.  This
 *  allows you to control the appearance of the drop-down list or its item
 *  renderers.
 *
 *  @default "comboDropdown"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dropdownStyleName", type="String", inherit="no")]

/**
 *  Length of the transition when the drop-down list opens, in milliseconds.
 *  The default transition has the drop-down slide down from the ComboBox.
 *
 *  The default value for the Halo theme is 250.
 *  The default value for the Spark theme is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="openDuration", type="Number", format="Time", inherit="no")]

/**
 *  An easing function to control the open transition.  Easing functions can
 *  be used to control the acceleration and deceleration of the transition.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="openEasingFunction", type="Function", inherit="no")]

/**
 *  Number of pixels between the control's bottom border
 *  and the bottom of its content area.
 *  When the <code>editable</code> property is <code>true</code>, 
 *  <code>paddingTop</code> and <code>paddingBottom</code> affect the size 
 *  of the ComboBox control, but do not affect the position of the editable text field.
 *  
 *  The default value for the Halo theme is 0.
 *  The default value for the Spark theme is -2.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the control's top border
 *  and the top of its content area.
 *  When the <code>editable</code> property is <code>true</code>, 
 *  <code>paddingTop</code> and <code>paddingBottom</code> affect the size 
 *  of the ComboBox control, but do not affect the position of the editable text field.
 *  
 *  The default value for the Halo theme is 0.
 *  The default value for the Spark theme is -1.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  The rollOverColor of the drop-down list.
 *  
 *  The default value for the Halo theme is <code>0xB2E1FF</code>.
 *  The default value for the Spark theme is <code>0xCEDBEF</code>.
 * 
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  The selectionColor of the drop-down list.
 *  
 *  The default value for the Halo theme is <code>0x7FCEFF</code>.
 *  The default value for the Spark theme is <code>0xA8C6EE</code>.
 * 
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  The selectionDuration of the drop-down list.
 * 
 *  @default 250
 * 
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectionDuration", type="uint", format="Time", inherit="no")]

/**
 *  The selectionEasingFunction of the drop-down list.
 * 
 *  @default undefined
 * 
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectionEasingFunction", type="Function", inherit="no")]

/**
 *  The textRollOverColor of the drop-down list.
 * 
 *  The default value for the Halo theme is <code>0x2B333C</code>.
 *  The default value for the Spark theme is <code>0x000000</code>.
 *  
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  The textSelectedColor of the drop-down list.
 * 
 *  The default value for the Halo theme is <code>0x2B333C</code>.
 *  The default value for the Spark theme is <code>0x000000</code>.
 * 
 *  @see mx.controls.List
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.ComboBoxAccImpl")]

[DataBindingInfo("acceptedTypes", "{ dataProvider: { label: &quot;String&quot; } }")]

[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

[DefaultProperty("dataProvider")]

[DefaultTriggerEvent("change")]

//[IconFile("ComboBox.png")]

[Alternative(replacement="spark.components.DropDownList", since="4.0")]
[Alternative(replacement="spark.components.ComboBox", since="4.0")]

/**
 *  The ComboBox control contains a drop-down list
 *  from which the user can select a single value.
 *  Its functionality is very similar to that of the
 *  SELECT form element in HTML.
 *  The ComboBox can be editable, in which case
 *  the user can type entries into the TextInput portion
 *  of the ComboBox that are not in the list.
 *
 *  <p>The ComboBox control has the following default sizing 
 *     characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to accommodate the longest entry in the 
 *               drop-down list in the display area of the main
 *               control, plus the drop-down button. When the 
 *               drop-down list is not visible, the default height 
 *               is based on the label text size. 
 *
 *               <p>The default drop-down list height is five rows, or 
 *               the number of entries in the drop-down list, whichever 
 *               is smaller. The default height of each entry in the 
 *               drop-down list is 22 pixels.</p></td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels.</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>5000 by 5000.</td>
 *        </tr>
 *        <tr>
 *           <td>dropdownWidth</td>
 *           <td>The width of the ComboBox control.</td>
 *        </tr>
 *        <tr>
 *           <td>rowCount</td>
 *           <td>5 rows.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ComboBox&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:ComboBox
 *    <b>Properties</b>
 *    dataProvider="null"
 *    dropdownFactory="<i>ClassFactory that creates an mx.controls.List</i>"
 *    dropdownWidth="<i>100 or width of the longest text in the dataProvider</i>"
 *    itemRenderer="null"
 *    labelField="label"
 *    labelFunction="null"
 *    prompt="null"
 *    rowCount="5"
 *    selectedIndex="-1"
 *    selectedItem="null"
 *    
 *    <b>Styles</b>
 *    alternatingItemColors="undefined"
 *    arrowButtonWidth="22"
 *    borderColor="0xB7BABC"
 *    borderThickness="1"
 *    closeDuration="250"
 *    closeEasingFunction="undefined"
 *    color="0x0B333C"
 *    cornerRadius="0"
 *    disabledColor="0xAAB3B3"
 *    disabledIconColor="0x919999"
 *    dropdownBorderColor="undefined"
 *    dropdownStyleName="comboDropdown"
 *    fillAlphas="[0.6,0.4]"
 *    fillColors="[0xFFFFFF, 0xCCCCCC]"
 *    focusAlpha="0.4"
 *    focusRoundedCorners="tl tr bl br"
 *    fontAntiAliasType="advanced|normal"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel|none|subpixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="normal|bold"
 *    highlightAlphas="[0.3,0.0]"
 *    iconColor="0x111111"
 *    leading="0"
 *    openDuration="250"
 *    openEasingFunction="undefined"
 *    paddingTop="0"
 *    paddingBottom="0"
 *    paddingLeft="5"
 *    paddingRight="5"
 *    rollOverColor="<i>Depends on theme color"</i>
 *    selectionColor="<i>Depends on theme color"</i>
 *    selectionDuration="250"
 *    selectionEasingFunction="undefined"
 *    textAlign="left|center|right"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    textRollOverColor="0x2B333C"
 *    textSelectedColor="0x2B333C"
 *    
 *    <b>Events</b>
 *    change="<i>No default</i>"
 *    close="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *    enter="<i>No default</i>"
 *    itemRollOut="<i>No default</i>"
 *    itemRollOver="<i>No default</i>"
 *    open="<i>No default</i>"
 *    scroll="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SimpleComboBox.mxml
 *
 *  @see mx.controls.List
 *  @see mx.effects.Tween
 *  @see mx.managers.PopUpManager
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ComboBox extends ComboBase
                      /*implements IDataRenderer, IDropInListItemRenderer,
                      IListItemRenderer*/
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
    public function ComboBox()
    {
        super();
        if((model as ISelectionModel).labelField == null) 
			labelField =  "label";
        addBead(new HideComboPopupOnMouseDownBead());

        // It it better to start out with an empty data provider rather than
        // an undefined one. Otherwise, code in getDropdown() sets it to []
        // later, but via setDataProvider(). This API has side effects like
        // setting selectionChanged, which causes the text in an editable
        // ComboBox to be lost.
        //dataProvider = new ArrayCollection();

    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    public function get labelField():String
    {
        return (model as ISelectionModel).labelField;
    }

    public function set labelField(value:String):void
    {
        (model as ISelectionModel).labelField = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    //----------------------------------
    //  dropdown
    //----------------------------------
    
    /**
     *  A reference to the List control that acts as the drop-down in the ComboBox.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dropdown():Object // was ListBase
    {
        return (view as IComboBoxView).popUp;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the data property.
     */
    private var _data:Object;
    
    [Bindable("dataChange")]
    [Inspectable(environment="none")]
    
    /**
     *  The <code>data</code> property lets you pass a value
     *  to the component when you use it in an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>The ComboBox control uses the <code>listData</code> property and the
     *  <code>data</code> property as follows. If the ComboBox is in a 
     *  DataGrid control, it expects the <code>dataField</code> property of the 
     *  column to map to a property in the data and sets 
     *  <code>selectedItem</code> to that property. If the ComboBox control is 
     *  in a List control, it expects the <code>labelField</code> of the list 
     *  to map to a property in the data and sets <code>selectedItem</code> to 
     *  that property. 
     *  Otherwise, it sets <code>selectedItem</code> to the data itself.</p>
     *
     *  <p>You do not set this property in MXML.</p>
     *
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get data():Object
    {
        return _data;
    }
    
    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        var newSelectedItem:*;
        
        _data = value;
        
        if (_listData && _listData is DataGridListData)
            newSelectedItem = _data[DataGridListData(_listData).dataField];
        //else if (_listData is ListData && ListData(_listData).labelField in _data)
        //    newSelectedItem = _data[ListData(_listData).labelField];
        else
            newSelectedItem = _data;
        
        if (newSelectedItem !== undefined /* && !selectedItemSet*/)
        {
            selectedItem = newSelectedItem;
            /*selectedItemSet = false;*/
        }
        
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    //----------------------------------
    //  listData
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the listData property.
     */
    private var _listData:BaseListData;
    
    [Bindable("dataChange")]
    [Inspectable(environment="none")]
    
    /**
     *  When a component is used as a drop-in item renderer or drop-in item 
     *  editor, Flex initializes the <code>listData</code> property of the 
     *  component with the appropriate data from the List control. The 
     *  component can then use the <code>listData</code> property and the 
     *  <code>data</code> property to display the appropriate information 
     *  as a drop-in item renderer or drop-in item editor.
     *
     *  <p>You do not set this property in MXML or ActionScript; Flex sets it 
     *  when the component
     *  is used as a drop-in item renderer or drop-in item editor.</p>
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get listData():BaseListData
    {
        return _listData;
    }
    
    /**
     *  @private
     */
    public function set listData(value:BaseListData):void
    {
        _listData = value;
    }
    
    //----------------------------------
    //  selectedLabel
    //----------------------------------

    /**
     *  The String displayed in the TextInput portion of the ComboBox. It
     *  is calculated from the data by using the <code>labelField</code> 
     *  or <code>labelFunction</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedLabel():String
    {
        return itemToLabel(selectedItem);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a string representing the <code>item</code> parameter.
     *  
     *  <p>This method checks in the following order to find a value to return:</p>
     *  
     *  <ol>
     *    <li>If you have specified a <code>labelFunction</code> property,
     *  returns the result of passing the item to the function.</li>
     *    <li>If the item is a String, Number, Boolean, or Function, returns
     *  the item.</li>
     *    <li>If the item has a property with the name specified by the control's
     *  <code>labelField</code> property, returns the contents of the property.</li>
     *    <li>If the item has a label property, returns its value.</li>
     *  </ol>
     * 
     *  @param item The object that contains the value to convert to a label. 
     *  If the item is null, this method returns the empty string.
     *
     *  @return A string representing the <code>item</code> parameter.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function itemToLabel(item:Object, ...rest):String
    {
        // rest args are needed in case dropdown is some other thing like DataGrid
        // that has multiple arguments to labelFunction

        // we need to check for null explicitly otherwise
        // a numeric zero will not get properly converted to a string.
        // (do not use !item)
        if (item == null)
            return "";

        /*
        if (labelFunction != null)
            return labelFunction(item);
        */
        
        if (typeof(item) == "object")
        {
            try
            {
                if (item[labelField] != null)
                    item = item[labelField];
            }
            catch(e:Error)
            {
            }
        }
        else if (typeof(item) == "xml")
        {
            try
            {
                if (item[labelField].length() != 0)
                    item = item[labelField];
            }
            catch(e:Error)
            {
            }
        }

        if (typeof(item) == "string")
            return String(item);

        try
        {
            return item.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    }


}

}
