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

import mx.controls.listClasses.IListItemRenderer;
import mx.core.EdgeMetrics;
import mx.core.IFlexDisplayObject;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.FocusEvent;
import mx.events.KeyboardEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.events.MouseEvent;
import mx.events.SandboxMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.ISystemManager;
import mx.managers.SystemManager;
import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;

import org.apache.royale.events.Event;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.utils.PointUtils;

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

        addEventListener(MouseEvent.CLICK, clickHandler);

    }
    
    /**
     *  @private
     *  Is the popUp list currently shown?
     */
    private var showingPopUp:Boolean = false;
    
    /**
     *  Opens the UIComponent object specified by the <code>popUp</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public function open():void
    {
        openWithEvent(null);
    }
    
    /**
     *  @private
     */
    private function openWithEvent(trigger:MouseEvent = null):void
    {
        if (!showingPopUp && enabled)
        {
            displayPopUp(true);
            
            /*
            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
            */
        }
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
        closeWithEvent(null);
    }
    
    /**
     *  @private
     */
    private function closeWithEvent(trigger:MouseEvent = null):void
    {
        if (showingPopUp)
        {
            displayPopUp(false);
            
            /*
            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
            */
        }
    }

    /**
     *  @private
     */
    protected function clickHandler(event:MouseEvent):void
    {
        /*
        if (overArrowButton(event))
        {*/
            if (showingPopUp)
                closeWithEvent(event);
            else
                openWithEvent(event);
            
            event.stopImmediatePropagation();
        /*
        }
        else
        {
            super.clickHandler(event);
            if (openAlways) 
            {
                if (showingPopUp)
                    closeWithEvent(event);
                else
                    openWithEvent(event);       
            }   
        }
        */
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

    /**
     *  @private
     *  Used by PopUpMenuButton
     */     
    mx_internal function getPopUp():IUIComponent
    {
        return _popUp ? _popUp : null;
    }
    
    /**
     *  @private
     */
    private function displayPopUp(show:Boolean):void
    {
        if (!initialized || (show == showingPopUp))
            return;
        // Subclasses may extend to do pre-processing
        // before the popUp is displayed
        // or override to implement special display behavior
        
        if (getPopUp() == null)
            return;
        
        /*
        if (_popUp is ILayoutDirectionElement)
        {
            ILayoutDirectionElement(_popUp).layoutDirection = layoutDirection;
        }
        
        //Show or hide the popup
        var endY:Number;
        var easingFunction:Function;
        var duration:Number;
        */
        var initY:Number;
        var sm:SystemManager = systemManager as SystemManager; //.topLevelSystemManager;
        var screen:Rectangle = sm.screen; //getVisibleApplicationRect(null, true);
        
        if (show)
        {
            if (_popUp.parent == null)
            {
                PopUpManager.addPopUp(_popUp, this, false);
                _popUp.owner = this;
            }
            /*
            else
                PopUpManager.bringToFront(_popUp);
            */
        }
        
        var popUpGap:Number = 0; //getStyle("popUpGap");
        var point:Point = new Point(/*layoutDirection == "rtl" ?*/ _popUp.width /*: 0*/, unscaledHeight + popUpGap);
        point = localToGlobal(point);
        
        if (show)
        {          
            if (point.y + _popUp.height > screen.bottom && 
                point.y > (screen.top + height + _popUp.height))
            { 
                // PopUp will go below the bottom of the stage
                // and be clipped. Instead, have it grow up.
                point.y -= (unscaledHeight + _popUp.height + 2*popUpGap);
                initY = -_popUp.height;
            }
            else
            {
                initY = _popUp.height;
            }
            
            point.x = Math.min( point.x, screen.right - _popUp.width);
            point.x = Math.max( point.x, 0);
            point = PointUtils.globalToLocal(point, _popUp.parent);
            if (_popUp.x != point.x)
                _popUp.x = point.x;
            if (_popUp.y != point.y)
                _popUp.y = point.y;
            
            /*
            _popUp.scrollRect = new Rectangle(0, initY,
                _popUp.width, _popUp.height);
            */
            if (!_popUp.visible)
                _popUp.visible = true;
            
            showingPopUp = show;
            /*
            endY = 0;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
            */
        }
        else
        {
            showingPopUp = show;
            
            if (_popUp.parent == null)
                return;
            
            PopUpManager.removePopUp(_popUp);

            /*
            point = (_popUp.parent as UIComponent).globalToLocal(point);
            endY = (point.y + _popUp.height > screen.bottom && 
                point.y > (screen.top + height + _popUp.height)
                ? -_popUp.height - 2
                : _popUp.height + 2);
            initY = 0;
            duration = getStyle("closeDuration")
            easingFunction = getStyle("closeEasingFunction") as Function;
            */
        }
        /*
        inTween = true;
        UIComponentGlobals.layoutManager.validateNow();
        
        // Block all layout, responses from web service, and other background
        // processing until the tween finishes executing.
        UIComponent.suspendBackgroundProcessing();
        
        tween = new Tween(this, initY, endY, duration);
        if (easingFunction != null)
            tween.easingFunction = easingFunction;
        */
    }

}

}
