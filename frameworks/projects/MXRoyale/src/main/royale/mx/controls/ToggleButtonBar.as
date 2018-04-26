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

/* import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent; 
import flash.ui.Keyboard;*/
import mx.core.IFlexDisplayObject;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import org.apache.royale.html.ButtonBar;
import mx.events.ItemClickEvent;
import mx.collections.IList;
use namespace mx_internal;



//--------------------------------------
//  Events 
//--------------------------------------
//copied from flexsdk ButtonBar
/**
 *  Dispatched when a user clicks a button.
 *  This event is only dispatched if the <code>dataProvider</code> property
 *  does not refer to a ViewStack container.
 *
 *  @eventType mx.events.ItemClickEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="itemClick", type="mx.events.ItemClickEvent")]


//copied from flexsdk ButtonBar
/**
 *  Number of pixels between children in the horizontal direction.
 *
 *  The default value for the Halo theme is <code>0</code>.
 *  The default value for the Spark theme is <code>-1</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
 
[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

//copied from flexsdk ButtonBar
/**
 *  Width of each button, in pixels.
 *  If undefined, the default width of each button is calculated from its label text.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="buttonWidth", type="Number", format="Length", inherit="no")]


	


//--------------------------------------
//  Other metadata
//-------------------------------------- 

//[IconFile("ButtonBar.png")]

[Alternative(replacement="spark.components.ButtonBar", since="4.0")]

[DefaultTriggerEvent("itemClick")]



/**
 *  The ToggleButtonBar control defines a horizontal or vertical 
 *  group of buttons that maintain their selected or deselected state.
 *  Only one button in the ToggleButtonBar control
 *  can be in the selected state.
 *  This means that when a user selects a button in a ToggleButtonBar control,
 *  the button stays in the selected state until the user selects a different button.
 *
 *  <p>If you set the <code>toggleOnClick</code> property of the
 *  ToggleButtonBar container to <code>true</code>,
 *  selecting the currently selected button deselects it.
 *  By default the <code>toggleOnClick</code> property is set to
 *  <code>false</code>.</p>
 *
 *  <p>You can use the ButtonBar control to define a group
 *  of push buttons.</p>
 *
 *  <p>The typical use for a toggle button is for maintaining selection
 *  among a set of options, such as switching between views in a ViewStack
 *  container.</p>
 *
 *  <p>The ToggleButtonBar control creates Button controls based on the value of 
 *  its <code>dataProvider</code> property. 
 *  Even though ToggleButtonBar is a subclass of Container, do not use methods such as 
 *  <code>Container.addChild()</code> and <code>Container.removeChild()</code> 
 *  to add or remove Button controls. 
 *  Instead, use methods such as <code>addItem()</code> and <code>removeItem()</code> 
 *  to manipulate the <code>dataProvider</code> property. 
 *  The ToggleButtonBar control automatically adds or removes the necessary children based on 
 *  changes to the <code>dataProvider</code> property.</p>
 *
 *  <p>To control the styling of the buttons of the ToggleButtonBar control, 
 *  use the <code>buttonStyleName</code>, <code>firstButtonStyleName</code>, 
 *  and <code>lastButtonStyleName</code> style properties; 
 *  do not try to style the individual Button controls 
 *  that make up the ToggleButtonBar control.</p>
 *
 *  <p>ToggleButtonBar control has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr>
 *        <th>Characteristic</th>
 *        <th>Description</th>
 *     </tr>
 *     <tr>
 *        <td>Preferred size</td>
 *        <td>Wide enough to contain all buttons with their label text and icons, if any, plus any 
 *            padding and separators, and high enough to accommodate the button height.</td>
 *     </tr>
 *     <tr>
 *        <td>Control resizing rules</td>
 *        <td>The controls do not resize by default. Specify percentage sizes if you want your 
 *            ToggleButtonBar to resize based on the size of its parent container.</td>
 *     </tr>
  *     <tr>
 *        <td>selectedIndex</td>
 *        <td>Determines which button will be selected when the control is created. The default value is "0" 
 *            and selects the leftmost button in the bar. Setting the selectedIndex property to "-1" deselects 
 *            all buttons in the bar.</td>
 *     </tr>
*     <tr>
 *        <td>Padding</td>
 *        <td>0 pixels for the top, bottom, left, and right properties.</td>
 *     </tr>
 *  </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ToggleButtonBar&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:ToggleButtonBar
 *    <b>Properties</b>
 *    selectedIndex="0"
 *    toggleOnClick="false|true"
 * 
 *    <b>Styles</b>
 *    selectedButtonTextStyleName="<i>Name of CSS style declaration that specifies styles for the text of the selected button.</i>"&gt;
 *    ...
 *       <i>child tags</i>
 *    ...
 *  &lt;/mx:ToggleButtonBar&gt;
 *  </pre>
 *
 *  @includeExample examples/ToggleButtonBarExample.mxml
 *
 *  @see mx.controls.ButtonBar
 *  @see mx.controls.LinkBar
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class ToggleButtonBar extends org.apache.royale.html.ButtonBar
{
  //  include "../core/Version.as";

  
  //----------------------------------
    //  dataProvider copied from flexsdk NavBar
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataProvider property.
     */
    private var _dataProvider:IList;

	
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
     *  @productversion Royale 0.9.3
     */
    public function ToggleButtonBar()
    {
        super();
    }

   

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  selectedIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedIndex property.
     */
    private var _selectedIndex:int = -2;

    
    /**
     *  Index of the selected button.
     *  Indexes are in the range of 0, 1, 2, ..., n - 1,
     *  where <i>n</i> is the number of buttons.
     *
     *  <p>The default value is 0.
	 *  A value of -1 deselects all the buttons in the bar.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    override public function get selectedIndex():int
    {
      return super.selectedIndex;
      //return _selectedIndex;
    }

    /**
     *  @private.
     */
    override public function set selectedIndex(value:int):void
    {  
    	//#SDK-15690 - if the user has asked for -1 (no child selected) then we must preserve this
		if (value == selectedIndex && value != -1)
			return;
    	
		_selectedIndex = value;
       
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  toggleOnClick
    //----------------------------------

    /**
     *  @private
     *  Storage for the toggleOnClick property.
     */
    private var _toggleOnClick:Boolean = false;

    [Inspectable(category="General", defaultValue="false")]

    /**
     *  Specifies whether the currently selected button can be deselected by
     *  the user.
     *
     *  By default, the currently selected button gets deselected
     *  automatically only when another button in the group is selected.
     *  Setting this property to <code>true</code> lets the user
     *  deselect it.
     *  When the currently selected button is deselected,
     *  the <code>selectedIndex</code> property is set to <code>-1</code>.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get toggleOnClick():Boolean
    {
        return _toggleOnClick;
    }

    /**
     *  @private
     */
    public function set toggleOnClick(value:Boolean):void
    {
        _toggleOnClick = value;
    }

}

}
