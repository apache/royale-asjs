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
	import goog.DEBUG;

/*
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextFormatAlign;
import flash.text.TextLineMetrics;
import flash.ui.Keyboard;
import flash.utils.Timer;

import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.FlexVersion;
import mx.core.IBorder;
import mx.core.IButton;
import mx.core.IDataRenderer;
import mx.core.IFlexAsset;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IFontContextComponent;
import mx.core.IInvalidating;
import mx.core.ILayoutDirectionElement;
import mx.core.IProgrammaticSkin;
import mx.core.IStateClient;
import mx.core.IUIComponent;
import mx.core.IUITextField;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.MoveEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.styles.ISimpleStyleClient;


use namespace mx_internal;
*/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user presses the Button control.
 *  If the <code>autoRepeat</code> property is <code>true</code>,
 *  this event is dispatched repeatedly as long as the button stays down.
 *
 *  @eventType mx.events.FlexEvent.BUTTON_DOWN
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="buttonDown", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the <code>selected</code> property
 *  changes for a toggle Button control. A toggle Button control means that the
 *  <code>toggle</code> property is set to <code>true</code>.
 *
 *  For the RadioButton controls, this event is dispatched when the <code>selected</code>
 *  property changes.
 *
 *  For the CheckBox controls, this event is dispatched only when the
 *  user interacts with the control by using the mouse.
 *
 *  @eventType flash.events.Event.CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="flash.events.Event")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
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



//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.ButtonAccImpl")]

[DefaultBindingProperty(source="selected", destination="label")]

[DefaultTriggerEvent("click")]


/**
 *  The Button control is a commonly used rectangular button.
 *  Button controls look like they can be pressed.
 *  They can have a text label, an icon, or both on their face.
 *
 *  <p>Buttons typically use event listeners to perform an action
 *  when the user selects the control. When a user clicks the mouse
 *  on a Button control, and the Button control is enabled,
 *  it dispatches a <code>click</code> event and a <code>buttonDown</code> event.
 *  A button always dispatches events such as the <code>mouseMove</code>,
 *  <code>mouseOver</code>, <code>mouseOut</code>, <code>rollOver</code>,
 *  <code>rollOut</code>, <code>mouseDown</code>, and
 *  <code>mouseUp</code> events whether enabled or disabled.</p>
 *
 *  <p>You can customize the look of a Button control
 *  and change its functionality from a push button to a toggle button.
 *  You can change the button appearance by using a skin
 *  for each of the button's states.</p>
 *
 *  <p>The label of a Button control uses a bold typeface. If you embed
 *  a font that you want to use for the label of the Button control, you must
 *  embed the bold typeface; for example:</p>
 *
 *  <pre>
 *  &lt;fx:style&gt;
 *    &#64;font-face {
 *      src:url("../MyFont-Bold.ttf");
 *      fontFamily: myFont;
 *      fontWeight: bold;
 *    }
 *   .myBoldStyle {
 *      fontFamily: myFont;
 *      fontWeight: bold;
 *    }
 *  &lt;/fx:style&gt;
 *  ...
 *  &lt;mx:Button ... styleName="myBoldStyle"/&gt;
 *  </pre>
 *
 *  <p>The Button control has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>A size large enough to hold the label text, and any icon</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>No limit</td></tr>
 *  </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Button&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Button
 *    <b>Properties</b>
 *    autoRepeat="false|true"
 *    emphasized="false|true"
 *    fontContext="<i>IFontModuleFactory</i>"
 *    label=""
 *    labelPlacement="right|left|bottom|top"
 *    selected="false|true"
 *    selectedField="null"
 *    stickyHighlighting="false|true"
 *    toggle="false|true"
 *
 *    <b>Styles</b>
 *    borderColor="0xAAB3B3"
 *    color="0x0B333C"
 *    cornerRadius="4"
 *    disabledColor="0xAAB3B3"
 *    disabledIcon="null"
 *    disabledSkin="mx.skins.halo.ButtonSkin"
 *    downIcon="null"
 *    downSkin="mx.skins.halo.ButtonSkin"
 *    fillAlphas="[0.6, 0.4]"
 *    fillColors="[0xE6EEEE, 0xFFFFFF]"
 *    focusAlpha="0.5"
 *    focusRoundedCorners"tl tr bl br"
 *    fontAntiAliasType="advanced"
 *    fontFamily="Verdana"
 *    fontGridFitType="pixel"
 *    fontSharpness="0"
 *    fontSize="10"
 *    fontStyle="normal|italic"
 *    fontThickness="0"
 *    fontWeight="bold|normal"
 *    highlightAlphas="[0.3, 0.0]"
 *    horizontalGap="2"
 *    icon="null"
 *    kerning="false|true"
 *    leading="2"
 *    letterSpacing="0"
 *    overIcon="null"
 *    overSkin="mx.skins.halo.ButtonSkin"
 *    paddingBottom="2"
 *    paddingLeft="0"
 *    paddingRight="0"
 *    paddingTop="2"
 *    repeatDelay="500"
 *    repeatInterval="35"
 *    selectedDisabledIcon="null"
 *    selectedDisabledSkin="mx.skins.halo.ButtonSkin"
 *    selectedDownIcon="null"
 *    selectedDownSkin="mx.skins.halo.ButtonSkin"
 *    selectedOverIcon="null"
 *    selectedOverSkin="mx.skins.halo.ButtonSkin"
 *    selectedUpIcon="null"
 *    selectedUpSkin="mx.skins.halo.ButtonSkin"
 *    skin="mx.skins.halo.ButtonSkin"
 *    textAlign="center|left|right"
 *    textDecoration="none|underline"
 *    textIndent="0"
 *    textRollOverColor="0x2B333C"
 *    textSelectedColor="0x000000"
 *    upIcon="null"
 *    upSkin="mx.skins.halo.ButtonSkin"
 *    verticalGap="2"
 *
 *    <b>Events</b>
 *    buttonDown="<i>No default</i>"
 *    change="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/ButtonExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Button extends UIComponent
       implements IDataRenderer, IDropInListItemRenderer,
       IFocusManagerComponent, IListItemRenderer,
       IFontContextComponent, IButton
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
    public function Button()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------



    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    private var enabledChanged:Boolean = false;

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     *  This is called whenever the enabled state changes.
     */
    override public function set enabled(value:Boolean):void
    {
        if (super.enabled == value)
            return;

        super.enabled = value;
        enabledChanged = true;

        invalidateProperties();
        invalidateDisplayList();
    }


    //----------------------------------
    //  toolTip
    //----------------------------------

    /**
     *  @private
     */
    private var toolTipSet:Boolean = false;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  @private
     */
    override public function set toolTip(value:String):void
    {
        super.toolTip = value;

        if (value)
        {
            toolTipSet = true;
        }
        else
        {
            toolTipSet = false;
            invalidateDisplayList();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------


    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property;
     */
    private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]

    /**
     *  The <code>data</code> property lets you pass a value
     *  to the component when you use it as an item renderer or item editor.
     *  You typically use data binding to bind a field of the <code>data</code>
     *  property to a property of this component.
     *
     *  <p>When you use the control as a drop-in item renderer or drop-in
     *  item editor, Flex automatically writes the current value of the item
     *  to the <code>selected</code> property of this control.</p>
     *
     *  <p>You do not set this property in MXML.</p>
     *
     *  @default null
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
        var newSelected:*;
        var newLabel:*;

        _data = value;

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    //----------------------------------
    //  label
    //----------------------------------

    /**
     *  @private
     *  Storage for label property.
     */
    private var _label:String = "";

    /**
     *  @private
     */
    private var labelChanged:Boolean = false;

    [Bindable("labelChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Text to appear on the Button control.
     *
     *  <p>If the label is wider than the Button control,
     *  the label is truncated and terminated by an ellipsis (...).
     *  The full label displays as a tooltip
     *  when the user moves the mouse over the Button control.
     *  If you have also set a tooltip by using the <code>tooltip</code>
     *  property, the tooltip is displayed rather than the label text.</p>
     *
     *  @default ""
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get label():String
    {
        return _label;
    }

    /**
     *  @private
     */
    public function set label(value:String):void
    {
        labelSet = true;

        if (_label != value)
        {
            _label = value;
            labelChanged = true;

            invalidateSize();
            invalidateDisplayList();

            dispatchEvent(new Event("labelChanged"));
        }
    }

    //----------------------------------
    //  labelPlacement
    //----------------------------------

    /**
     *  @private
     *  Storage for labelPlacement property.
     */
    mx_internal var _labelPlacement:String = ButtonLabelPlacement.RIGHT;

    [Bindable("labelPlacementChanged")]
    [Inspectable(category="General", enumeration="left,right,top,bottom", defaultValue="right")]

    /**
     *  Orientation of the label in relation to a specified icon.
     *  Valid MXML values are <code>right</code>, <code>left</code>,
     *  <code>bottom</code>, and <code>top</code>.
     *
     *  <p>In ActionScript, you can use the following constants
     *  to set this property:
     *  <code>ButtonLabelPlacement.RIGHT</code>,
     *  <code>ButtonLabelPlacement.LEFT</code>,
     *  <code>ButtonLabelPlacement.BOTTOM</code>, and
     *  <code>ButtonLabelPlacement.TOP</code>.</p>
     *
     *  @default ButtonLabelPlacement.RIGHT
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelPlacement():String
    {
        return _labelPlacement;
    }

    /**
     *  @private
     */
    public function set labelPlacement(value:String):void
    {
        _labelPlacement = value;

        invalidateSize();
        invalidateDisplayList();

        dispatchEvent(new Event("labelPlacementChanged"));
    }

    //----------------------------------
    //  selected
    //----------------------------------

    /**
     *  @private
     *  Storage for selected property.
     */
    mx_internal var _selected:Boolean = false;

    [Bindable("click")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     *  Indicates whether a toggle button is toggled
     *  on (<code>true</code>) or off (<code>false</code>).
     *  This property can be set only if the <code>toggle</code> property
     *  is set to <code>true</code>.
     *
     *  <p>For a CheckBox control, indicates whether the box
     *  is displaying a check mark. For a RadioButton control,
     *  indicates whether the control is selected.</p>
     *
     *  <p>The user can change this property by clicking the control,
     *  but you can also set the property programmatically.</p>
     *
     *  <p>In previous versions, If the <code>toggle</code> property
     *  was set to <code>true</code>, changing this property also dispatched
     *  a <code>change</code> event. Starting in version 3.0, setting this
     *  property programmatically only dispatches a
     *  <code>valueCommit</code> event.</p>
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selected():Boolean
    {
        return _selected;
    }

    /**
     *  @private
     */
    public function set selected(value:Boolean):void
    {
        selectedSet = true;
        setSelected(value, true);
    }

    //----------------------------------
    //  toggle
    //----------------------------------

    /**
     *  @private
     *  Storage for toggle property.
     */
    mx_internal var _toggle:Boolean = false;

    /**
     *  @private
     */
    mx_internal var toggleChanged:Boolean = false;

    [Bindable("toggleChanged")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     *  Controls whether a Button is in a toggle state or not.
     *
     *  If <code>true</code>, clicking the button toggles it
     *  between a selected and an unselected state.
     *  You can get or set this state programmatically
     *  by using the <code>selected</code> property.
     *
     *  If <code>false</code>, the button does not stay pressed
     *  after the user releases it.
     *  In this case, its <code>selected</code> property
     *  is always <code>false</code>.
     *  Buttons like this are used for performing actions.
     *
     *  When <code>toggle</code> is set to <code>false</code>,
     *  <code>selected</code> is forced to <code>false</code>
     *  because only toggle buttons can be selected.
     *
     *  @default false
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get toggle():Boolean
    {
        return _toggle;
    }

    /**
     *  @private
     */
    public function set toggle(value:Boolean):void
    {
        _toggle = value;
        toggleChanged = true;

        invalidateProperties();
        invalidateDisplayList();

        dispatchEvent(new Event("toggleChanged"));
    }=

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        if (goog.DEBUG)
        	trace("focusOutHandler not implemented");
    }

    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (goog.DEBUG)
        	trace("keyDownHandler not implemented");
    }

    /**
     *  @private
     */
    override protected function keyUpHandler(event:KeyboardEvent):void
    {
        if (goog.DEBUG)
        	trace("keyUpHandler not implemented");
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /*

    Mouse interaction sequences that Button must handle:

    All start with Button in "up" phase, mouse outside Button,
    and mouse button up.

    Normal click:
        roll over Button -> "over" phase
        mouse down on Button -> "down" phase, dispatch "buttonDown"
        mouse up while over Button -> "over" phase, dispatch "click"
        roll out of Button -> "up" phase

    Click canceled:
        roll over Button -> "over" phase
        mouse down on Button -> "down" phase, dispatch "buttonDown"
        roll out of Button -> "over" phase
        maybe roll over and out of other objects -> dispatch events from them
        maybe roll off the stage, or off and back on
        mouse up while out of Button -> "up" phase
        if mouseup was over another Button, it goes into "over" phase

    Click resumed:
        roll over Button -> "over" phase
        mouse down on Button -> "down" phase, dispatch "buttonDown"
        roll out of Button -> "over" phase
        maybe roll over and out of other objects -> dispatch events from them
        roll over Button -> "down" phase
        maybe roll off the stage, or off and back on
        maybe repeat last four steps
        mouse up while over Button -> "over" phase, dispatch "click"
        roll out of Button -> "up" phase

    Drag over and out
        mouse down while out of Button
        roll over Button -> stay in "up" phase
        roll out of Button -> stay in "up" phase

    Drag over and up
        mouse down while out of Button
        roll over Button -> stay in "up" phase
        mouse up while over Button -> "over" phase
        continue with step 2 of first three sequences above

    */

    /**
     *  The default handler for the <code>MouseEvent.ROLL_OVER</code> event.
     *
     *  @param The event object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function rollOverHandler(event:MouseEvent):void
    {
       if (goog.DEBUG)
        	trace("rollOverHandler not implemented");
    }

    /**
     *  The default handler for the <code>MouseEvent.ROLL_OUT</code> event.
     *
     *  @param The event object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function rollOutHandler(event:MouseEvent):void
    {

        if (goog.DEBUG)
        	trace("rollOutHandler not implemented");
    }

    /**
     *  The default handler for the <code>MouseEvent.MOUSE_DOWN</code> event.
     *
     *  @param The event object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function mouseDownHandler(event:MouseEvent):void
    {
        if (goog.DEBUG)
        	trace("mouseDownHandler not implemented");
    }

    /**
     *  The default handler for the <code>MouseEvent.MOUSE_UP</code> event.
     *
     *  @param The event object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function mouseUpHandler(event:MouseEvent):void
    {
        if (goog.DEBUG)
        	trace("mouseUpHandler not implemented");
    }

    /**
     *  The default handler for the <code>MouseEvent.CLICK</code> event.
     *
     *  @param The event object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function clickHandler(event:MouseEvent):void
    {
        if (goog.DEBUG)
        	trace("clickHandler not implemented");
    }
}

}
