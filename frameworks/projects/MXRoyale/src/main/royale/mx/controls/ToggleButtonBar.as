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
import mx.collections.IList;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
use namespace mx_internal;

import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IDataProviderItemRendererMapper;
import org.apache.royale.core.IItemRendererClassFactory;
import org.apache.royale.core.ILayoutParent;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.ILayoutView;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.html.beads.models.ButtonBarModel;
import org.apache.royale.utils.loadBeadFromValuesManager;
import org.apache.royale.core.ILayoutHost;


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
//[Style(name="buttonWidth", type="Number", format="Length", inherit="no")]


	


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
public class ToggleButtonBar extends UIComponent implements ILayoutParent, ILayoutView
{
  //  include "../core/Version.as";
	
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
        widthType = ButtonBarModel.NATURAL_WIDTHS;
    }

    /**
     *  @see org.apache.royale.html.beads.models.ButtonBarModel#buttonWidths
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     *  @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
     */
    public function get buttonWidths():Array
    {
        return ButtonBarModel(model).buttonWidths;
    }
    /**
     * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
     */
    public function set buttonWidths(value:Array):void
    {
        ButtonBarModel(model).buttonWidths = value;
    }
    
    /**
     *  @see org.apache.royale.html.beads.models.ButtonBarModel#widthType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     *  @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
     */
    public function get widthType():Number
    {
        return ButtonBarModel(model).widthType;
    }
    /**
     * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
     */
    public function set widthType(value:Number):void
    {
        ButtonBarModel(model).widthType = value;
    }
   
    //----------------------------------
    //  dataProvider
    //----------------------------------
    
    [Bindable("collectionChange")]
    [Inspectable(category="Data", defaultValue="undefined")]
    
    /**
     *  Set of data to be viewed.
     *  This property lets you use most types of objects as data providers.
     *  If you set the <code>dataProvider</code> property to an Array, 
     *  it will be converted to an ArrayCollection. If you set the property to
     *  an XML object, it will be converted into an XMLListCollection with
     *  only one item. If you set the property to an XMLList, it will be 
     *  converted to an XMLListCollection.  
     *  If you set the property to an object that implements the 
     *  IList or ICollectionView interface, the object will be used directly.
     *
     *  <p>As a consequence of the conversions, when you get the 
     *  <code>dataProvider</code> property, it will always be
     *  an ICollectionView, and therefore not necessarily be the type of object
     *  you used to  you set the property.
     *  This behavior is important to understand if you want to modify the data 
     *  in the data provider: changes to the original data may not be detected, 
     *  but changes to the ICollectionView object that you get back from the 
     *  <code>dataProvider</code> property will be detected.</p>
     * 
     *  @default null
     *  @see mx.collections.ICollectionView
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function get dataProvider():Object
    {
        return (model as ISelectionModel).dataProvider;
    }
    /**
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function set dataProvider(value:Object):void
    {
        (model as ISelectionModel).dataProvider = value;
    }

    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]
    
    /**
     *  The index in the data provider of the selected item.
     * 
     *  <p>The default value is -1 (no selected item).</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function get selectedIndex():int
    {
        return (model as ISelectionModel).selectedIndex;
    }
    
    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function set selectedIndex(value:int):void
    {
        // if (!collection || collection.length == 0)
        // {
        (model as ISelectionModel).selectedIndex = value;
        //   bSelectionChanged = true;
        //   bSelectedIndexChanged = true;
        //  invalidateDisplayList();
        return;
        // }
        //commitSelectedIndex(value);
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

    /**
     * Returns the ILayoutHost which is its view. From ILayoutParent.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
     */
    public function getLayoutHost():ILayoutHost
    {
        return view as ILayoutHost;
    }
    
    /**
     * @private
     */
    override public function addedToParent():void
    {
        super.addedToParent();
        
        // Load the layout bead if it hasn't already been loaded.
        loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);
        
        // Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
        // and item factory beads. These beads are added after super.addedToParent is called in case substitutions
        // were made; these are just defaults extracted from CSS.
        loadBeadFromValuesManager(IDataProviderItemRendererMapper, "iDataProviderItemRendererMapper", this);
        loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", this);
        
        dispatchEvent(new Event("initComplete"));
    }

    private var _buttonWidth:int;
    
    public function get buttonWidth():int
    {
        return _buttonWidth;
    }
    public function set buttonWidth(value:int):void
    {
        _buttonWidth = value;
    }
    
    override public function get measuredWidth():Number
    {
        if (dataProvider)
            return buttonWidth * dataProvider.length;
        return 0;
    }
    
    override public function get measuredHeight():Number
    {
        if (dataProvider)
        {
            COMPILE::JS
            {
                // if the height was set to zero by setActualSize because
                // there were no buttons to measure, clear the width
                // style so the buttonbar can get its natural height
                if (height == 0 && isNaN(explicitHeight))
                {
                    element.style.height = null;
                    _height = NaN;
                }
            }
            return height; // do a better measurement someday
        }
        return 0;
    }
}

}
