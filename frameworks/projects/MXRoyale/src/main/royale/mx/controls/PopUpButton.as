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

/* import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.getTimer; */

import org.apache.royale.events.Event;
import mx.events.FocusEvent;
import mx.events.KeyboardEvent;
import mx.events.MouseEvent;

import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.IFlexDisplayObject;
//import mx.core.ILayoutDirectionElement;
//import mx.core.IRectangularBorder;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
//import mx.events.DropdownEvent;
//import mx.events.FlexMouseEvent;
//import mx.events.InterManagerRequest;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;


/** 
 *  The PopUpButton control adds a flexible pop-up control
 *  interface  to a Button control.
 *  It contains a main button and a secondary button,
 *  called the pop-up button, which pops up any UIComponent
 *  object when a user clicks the pop-up button. 
 *
 *  <p>A PopUpButton control can have a text label, an icon,
 *  or both on its face.
 *  When a user clicks the main part of the PopUpButton 
 *  control, it dispatches a <code>click</code> event.</p>
 *
 *  <p>One common use for the PopUpButton control is to have
 *  the pop-up button open a List control or a Menu control
 *  that changes  the function and label of the main button.</p>
 *
 *  <p>The PopUpButton control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Sufficient width to accommodate the label and icon on the main button and the icon on the pop-up button</td>
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
 *  <p>The <code>&lt;mx:PopUpButton&gt;</code> tag inherits all of the tag
 *  attributes of its superclass and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:PopUpButton
 *    <strong>Properties</strong> 
 *    openAlways="false|true
 *    popUp="No default"
 *  
 *    <strong>Styles</strong>
 *    arrowButtonWidth="16"
 *    closeDuration="250"
 *    closeEasingFunction="No default"
 *    disabledIconColor="0x999999"
 *    iconColor="0x111111"
 *    openDuration="250"
 *    openEasingFunction="No default"
 *    popUpDownSkin="popUpDownSkin"
 *    popUpGap="0"
 *    popUpIcon="PopUpIcon"
 *    popUpOverSkin="popUpOverSkin"
 *  
 *    <strong>Events</strong>
 *    close="No default"
 *    open="No default"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/PopUpButtonExample.mxml
 * 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PopUpButton extends Button 
{
    //include "../core/Version.as";
    
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
    public function PopUpButton()
    {
        super();               
        //addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        //addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }
    
    /**
     *  Closes the UIComponent object opened by the PopUpButton control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public function close():void
    {
    }

    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     *  @private
     *  Storage for popUp property.
     */    
    private var _popUp:IUIComponent = null;
    
    [Bindable(event='popUpChanged')]
    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  Specifies the UIComponent object, or object defined by a subclass 
     *  of UIComponent, to pop up. 
     *  For example, you can specify a Menu, TileList, or Tree control. 
     *
     *  @default null 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get popUp():IUIComponent
    {
        return _popUp;
    }
    
    /**
     *  @private
     */  
    public function set popUp(value:IUIComponent):void
    {
        _popUp = value;
        //popUpChanged = true;
        
        //invalidateProperties();
    }

}

}
