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
COMPILE::JS
{
    import goog.DEBUG;
}
import org.apache.royale.events.Event;
/*
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
*/
import mx.events.FlexEvent;
/*
import mx.core.FlexVersion;
import mx.core.IToggleButton;
import mx.events.ItemClickEvent;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerGroup;
import mx.core.UITextField;
import mx.styles.CSSStyleDeclaration;
import mx.styles.StyleManager;
import flash.text.TextLineMetrics;
import flash.utils.getQualifiedClassName;

use namespace mx_internal;
*/

/**
 *  The RadioButton control lets the user make a single choice
 *  within a set of mutually exclusive choices.
 *  A RadioButton group is composed of two or more RadioButton controls
 *  with the same <code>groupName</code> property. While grouping RadioButton instances
 *  in a RadioButtonGroup is optional, a group lets you do things
 *  like set a single event handler on a group of buttons, rather than
 *  on each individual button. The RadioButton group can refer to a group created by the
 *  <code>&lt;mx:RadioButtonGroup&gt;</code> tag.
 *  The user selects only one member of the group at a time.
 *  Selecting an unselected group member deselects the currently selected
 *  RadioButton control within that group.
 *
 *  <p>The RadioButton control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Wide enough to display the text label of the control</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>Undefined</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:RadioButton&gt;</code> tag inherits all of the tag
 *  attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:RadioButton
 *    <strong>Properties</strong>
 *    groupName=""
 *    labelPlacement="right|left|top|bottom"
 *
 *    <strong>Styles</strong>
 *    disabledIconColor="0x999999"
 *    iconColor="0x2B333C"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/RadioButtonExample.mxml
 *
 *  @see mx.controls.RadioButtonGroup
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class RadioButton extends Button
{
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

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
    public function RadioButton()
    {
        super();
        typeNames = "RadioButton";
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
    //  emphasized
    //----------------------------------

    //----------------------------------
    //  labelPlacement
    //----------------------------------

    [Bindable("labelPlacementChanged")]
    [Inspectable(category="General", enumeration="left,right,top,bottom", defaultValue="right")]

    /**
     *  Position of the label relative to the RadioButton icon.
     *  Valid values in MXML are <code>"right"</code>, <code>"left"</code>,
     *  <code>"bottom"</code>, and <code>"top"</code>.
     *
     *  <p>In ActionScript, you use the following constants
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
    override public function get labelPlacement():String
    {
        return "right";
    }

    //----------------------------------
    //  toggle
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @private
     *  A RadioButton is always toggleable by definition, so toggle is set
     *  true in the constructor and can't be changed for a RadioButton.
     */

    override public function get toggle():Boolean
    {
        return super.toggle;
    }

    /**
     *  @private
     */
    override public function set toggle(value:Boolean):void
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  group
    //----------------------------------

    /**
     *  @private
     *  Storage for the group property.
     */
    private var _group:RadioButtonGroup;

    /**
     *  The RadioButtonGroup object to which this RadioButton belongs.
     *
     *  @default "undefined"
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get group():RadioButtonGroup
    {
        return _group;
    }

    /**
     *  @private
     */
    public function set group(value:RadioButtonGroup):void
    {
        _group = value;
    }

    //----------------------------------
    //  groupName
    //----------------------------------

    /**
     *  @private
     *  Storage for groupName property.
     */
    protected var _groupName:String;

    /**
     *  @private
     */
    private var groupChanged:Boolean = false;

    [Bindable("groupNameChanged")]
    [Inspectable(category="General", defaultValue="radioGroup")]

    /**
     *  Specifies the name of the group to which this RadioButton control belongs, or
     *  specifies the value of the <code>id</code> property of a RadioButtonGroup control
     *  if this RadioButton is part of a group defined by a RadioButtonGroup control.
     *
     *  @default "undefined"
     *  @throws ArgumentError Throws an ArgumentError if you are using Flex 4 or later and the groupName starts with the string "_fx_".
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get groupName():String
    {
        return _groupName;
    }

    /**
     *  @private
     */
    public function set groupName(value:String):void
    {
        _groupName = value;

        dispatchEvent(new Event("groupNameChanged"));
    }

    //----------------------------------
    //  value
    //----------------------------------

    /**
     *  @private
     *  Storage for value property.
     */
    private var _value:Object;

    [Bindable("valueChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  Optional user-defined value
     *  that is associated with a RadioButton control.
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get value():Object
    {
        return _value;
    }

    /**
     *  @private
     */
    public function set value(value:Object):void
    {
        _value = value;

    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------


    /**
     *  @private
     *  Update properties before measurement/layout.
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
    }

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


}

}
