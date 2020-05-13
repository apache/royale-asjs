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

package spark.components
{
/* 
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.SandboxMouseEvent;
import mx.utils.BitFlagUtil;

import spark.events.TitleWindowBoundsEvent;

use namespace mx_internal; */
    import mx.events.CloseEvent;
    import mx.events.MouseEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user selects the close button.
 *
 *  @eventType mx.events.CloseEvent.CLOSE
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
[Event(name="close", type="mx.events.CloseEvent")]

/**
 *  Dispatched when the user presses and hold the mouse button 
 *  in the move area and begins to drag the window.
 *
 *  @eventType spark.events.TitleWindowBoundsEvent.WINDOW_MOVE_START
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="windowMoveStart", type="spark.events.TitleWindowBoundsEvent")]

/**
 *  Dispatched when the user drags the window.
 *
 *  @eventType spark.events.TitleWindowBoundsEvent.WINDOW_MOVING
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="windowMoving", type="spark.events.TitleWindowBoundsEvent")]

/**
 *  Dispatched after the user dragged the window successfully.
 *
 *  @eventType spark.events.TitleWindowBoundsEvent.WINDOW_MOVE
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="windowMove", type="spark.events.TitleWindowBoundsEvent")]

/**
 *  Dispatched when the user releases the mouse button after
 *  dragging.
 *
 *  @eventType spark.events.TitleWindowBoundsEvent.WINDOW_MOVE_END
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[Event(name="windowMoveEnd", type="spark.events.TitleWindowBoundsEvent")]

//--------------------------------------
//  SkinStates
//--------------------------------------

/**
 *  Inactive view state used for a TitleWindow
 *  when it, or all of its children, are not in focus.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("inactive")]

/**
 *  Inactive view state with a control bar visible.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//[SkinState("inactiveWithControlBar")]

//[IconFile("TitleWindow.png")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="spark.accessibility.TitleWindowAccImpl")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
 */
//[DiscouragedForProfile("mobileDevice")]

/**
 *  The TitleWindow class extends Panel to include
 *  a close button and move area.
 * 
 *  <p>The TitleWindow is designed as a pop-up window.
 *  Do not create a TitleWindow in MXML as part of an application.
 *  Instead, you typically create a custom MXML component based on 
 *  the TitleWindow class, and then use the 
 *  <code>PopUpManager.createPopUp()</code> method to pop up the component, 
 *  and the <code>PopUpManager.removePopUp()</code> method 
 *  to remove the component.</p>
 *  
 *  <p>The TitleWindow container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Height is large enough to hold all of the children in the content area at the default or 
 *               explicit heights of the children, plus the title bar and border, plus any vertical gap between 
 *               the children, plus the top and bottom padding of the container.<br/> 
 *               Width is the larger of the default or explicit width of the widest child, plus the left and 
 *               right container borders padding, or the width of the title text.</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin class</td>
 *           <td>spark.skins.spark.TitleWindowSkin</td>
 *        </tr>
 *     </table>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;s:TitleWindow&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:TitleWindow&gt;
 *    <strong>Events</strong>
 *    close="<i>No default</i>"
 *    windowMove="<i>No default</i>"
 *    windowMoveEnd="<i>No default</i>"
 *    windowMoveStart="<i>No default</i>"
 *    windowMoving="<i>No default</i>"
 *  &lt;/s:TitleWindow&gt;
 *  </pre>
 *  
 *  @includeExample examples/SimpleTitleWindowExample.mxml -noswf
 *  @includeExample examples/TitleWindowApp.mxml
 *  
 *  @see spark.components.Panel
 *  @see spark.skins.spark.TitleWindowSkin
 *  @see spark.skins.spark.TitleWindowCloseButtonSkin
 *  @see mx.managers.PopUpManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class TitleWindow extends Panel
{
   // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by TitleWindowAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function TitleWindow()
    {
        super();
		
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /* private var addedHandlers:Boolean = false;
    private var active:Boolean = false; */
    
    /**
     *  @private
     *  Horizontal location where the user pressed the mouse button
     *  on the moveArea to start dragging, relative to the original
     *  horizontal location of the TitleWindow.
     */
    //private var offsetX:Number;
    
    /**
     *  @private
     *  Vertical location where the user pressed the mouse button
     *  on the moveArea to start dragging, relative to the original
     *  vertical location of the TitleWindow.
     */
    //private var offsetY:Number;
    
    /**
     *  @private
     *  The starting bounds of the TitleWindow before a user
     *  moves or resizes it.
     */
   // private var startBounds:Rectangle;
    
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  closeButton
    //---------------------------------- 
    
    [SkinPart(required="false")]
    
    /**
     *  The skin part that defines the appearance of the 
     *  close icon (a small x in the upper-right corner of the TitleWindow title bar).
     *  When clicked, the close icon dispatches a <code>close</code> event.
     *
     *  <p>Flex does not close the window automatically. 
     *  To suport the close icon, you must create a handler for the <code>close</code> event 
     *  and close the TitleWindow from that event handler.</p>
     *
     *  <p>Focus is disabled for this skin part.</p>
     */
    public var closeButton:Button;
    
    //----------------------------------
    //  moveArea
    //---------------------------------- 
    
    //[SkinPart(required="false")]
    
    /**
     *  The area where the user must click and drag to move the window.
     *  By default, the move area is the title bar of the TitleWindow container.
     *
     *  <p>To drag the TitleWindow container, click and hold the mouse pointer in 
     *  the title bar area of the window, then move the mouse. 
     *  Create a custom skin class to change the move area.</p>
     */
    //public var moveArea:InteractiveObject;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent, SkinnableComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
   /*  override protected function initializeAccessibility():void
    {
        if (TitleWindow.createAccessibilityImplementation != null)
            TitleWindow.createAccessibilityImplementation(this);
    } */

    /**
     *  @private
     */
    /* override public function parentChanged(p:DisplayObjectContainer):void
    {
        if (focusManager)
        {
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE, 
                                             activateHandler);
            focusManager.removeEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE, 
                                             deactivateHandler);
        }
        
        super.parentChanged(p);
        
        if (focusManager)
        {
            addActivateHandlers();
        }
        else
        {
            // if no focusmanager yet, add capture phase to detect when it
            // gets added
            if (systemManager)
            {
                systemManager.getSandboxRoot().addEventListener(
                    FlexEvent.ADD_FOCUS_MANAGER, addFocusManagerHandler, true, 0, true);
            }
            else
            {
                // no systemManager yet?  Check again when added to stage
                addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            }
        }
    } */
    
    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object) : void
    {
        super.partAdded(partName, instance);
        
        /*
        if (instance == moveArea)
        {
            moveArea.addEventListener(MouseEvent.MOUSE_DOWN, moveArea_mouseDownHandler);
        }
        else*/ if (instance == closeButton)
        {
            closeButton.focusEnabled = false;
            closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);   
        }
    }
    
    /**
     *  @private
     */
    /* override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);

        if (instance == moveArea)
            moveArea.removeEventListener(MouseEvent.MOUSE_DOWN, moveArea_mouseDownHandler);

        else if (instance == closeButton)
            closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
    } */
    
    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function getCurrentSkinState():String
    {
        // In focus window is the active window.
        if (enabled && isPopUp && !active)
        {
            var state:String = "inactive";
            
            if (controlBarGroup)
            {
                if (BitFlagUtil.isSet(controlBarGroupProperties as uint, CONTROLBAR_PROPERTY_FLAG) &&
                    BitFlagUtil.isSet(controlBarGroupProperties as uint, VISIBLE_PROPERTY_FLAG))
                    state += "WithControlBar";
            }
            else
            {
                if (controlBarGroupProperties.controlBarContent &&
                    controlBarGroupProperties.visible)
                    state += "WithControlBar";
            }
            
            return state;
        }
        
        return super.getCurrentSkinState();
    } */
    
    /**
     *  @private
     */
    /*override public function move(x:Number, y:Number) : void
    {
        var beforeBounds:Rectangle = new Rectangle(this.x, this.y, width, height);
        
        super.move(x, y);
        
        // Dispatch "windowMove" event when TitleWindow is moved.
        var afterBounds:Rectangle = new Rectangle(this.x, this.y, width, height);
        var e2:TitleWindowBoundsEvent =
            new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE,
                                       false, false, beforeBounds, afterBounds);
        
        dispatchEvent(e2);
    }*/
    
    //--------------------------------------------------------------------------
    // 
    // Event Handlers
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  closeButton Handler
    //---------------------------------- 
    
    /**
     *  @private
     *  Dispatches the "close" event when the closeButton
     *  is clicked.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    protected function closeButton_clickHandler(event:MouseEvent):void
    {
        /*
        var child:DisplayObject = getFocus() as DisplayObject;
        if (child && contains(child))
        {
            // make sure any internal component that has focus
            // loses focus so it commits changes internally
            if (stage)
                stage.focus = null;
        }
        */
        dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
    //----------------------------------
    //  moveArea Handlers
    //---------------------------------- 
    
    /**
     *  @private
     *  Called when the user starts dragging a TitleWindow.
     *  It begins a move on the TitleWindow if it was popped
     *  up either by PopUpManager or PopUpAnchor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* protected function moveArea_mouseDownHandler(event:MouseEvent):void
    {
        // Only allow dragging of pop-upped windows
        if (enabled && isPopUp)
        {
            // Calculate the mouse's offset in the window
            // TODO (klin): Investigate globalToLocal method
            offsetX = event.stageX - x;
            offsetY = event.stageY - y;
            
            var sbRoot:DisplayObject = systemManager.getSandboxRoot();
            
            sbRoot.addEventListener(
                MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler, true);
            sbRoot.addEventListener(
                MouseEvent.MOUSE_UP, moveArea_mouseUpHandler, true);
            sbRoot.addEventListener(
                SandboxMouseEvent.MOUSE_UP_SOMEWHERE, moveArea_mouseUpHandler)
            
            // add the mouse shield so we can drag over untrusted applications.
            systemManager.deployMouseShields(true);
        }
    } */
    
    /**
     *  @private
     *  Called when the user drags a TitleWindow.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* protected function moveArea_mouseMoveHandler(event:MouseEvent):void
    {
        // Check to see if this is the first mouseMove
        if (!startBounds)
        {
            // First dispatch a cancellable "windowMoveStart" event
            startBounds = new Rectangle(x, y, width, height);
            var startEvent:TitleWindowBoundsEvent =
                new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE_START,
                    false, true, startBounds, null);
            dispatchEvent(startEvent);

            if (startEvent.isDefaultPrevented())
            {
                // Clean up code if entire move is canceled.
                var sbRoot:DisplayObject = systemManager.getSandboxRoot();

                sbRoot.removeEventListener(
                    MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler, true);
                sbRoot.removeEventListener(
                    MouseEvent.MOUSE_UP, moveArea_mouseUpHandler, true);
                sbRoot.removeEventListener(
                    SandboxMouseEvent.MOUSE_UP_SOMEWHERE, moveArea_mouseUpHandler);
                
                systemManager.deployMouseShields(false);
                
                offsetX = NaN;
                offsetY = NaN;
                startBounds = null;
                return;
            }
        }
        
        // Dispatch cancelable "windowMoving" event with before and after bounds.
        var beforeBounds:Rectangle = new Rectangle(x, y, width, height);
        var afterBounds:Rectangle = 
            new Rectangle(Math.round(event.stageX - offsetX),
                          Math.round(event.stageY - offsetY),
                          width, height);
        
        var e1:TitleWindowBoundsEvent =
            new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVING,
                                       false, true, beforeBounds, afterBounds);
        dispatchEvent(e1);
        
        // Move only if not canceled.
        if (!(e1.isDefaultPrevented()))
            move(afterBounds.x, afterBounds.y);

        event.updateAfterEvent();
    } */
    
    /**
     *  @private
     *  Called when the user releases the TitleWindow.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* protected function moveArea_mouseUpHandler(event:Event):void
    {
        var sbRoot:DisplayObject = systemManager.getSandboxRoot();
        
        sbRoot.removeEventListener(
            MouseEvent.MOUSE_MOVE, moveArea_mouseMoveHandler, true);
        sbRoot.removeEventListener(
            MouseEvent.MOUSE_UP, moveArea_mouseUpHandler, true);
        sbRoot.removeEventListener(
            SandboxMouseEvent.MOUSE_UP_SOMEWHERE, moveArea_mouseUpHandler);
        
        systemManager.deployMouseShields(false);
        
        // Check to see that a move actually occurred and that the
        // user did not just click on the moveArea
        if (startBounds)
        {
            // Dispatch "windowMoveEnd" event with the starting bounds and current bounds.
            var endEvent:TitleWindowBoundsEvent =
                new TitleWindowBoundsEvent(TitleWindowBoundsEvent.WINDOW_MOVE_END,
                                           false, false, startBounds,
                                           new Rectangle(x, y, width, height));
            dispatchEvent(endEvent);
            startBounds = null;
        }
        
        offsetX = NaN;
        offsetY = NaN;
    } */

    //----------------------------------
    //  Active Window Handlers and helper methods
    //---------------------------------- 
    
    /**
     *  @private
     */
    /* private function activateHandler(event:Event):void
    {
        active = true;
        invalidateSkinState();
    } */
    
    /**
     *  @private
     */
    /* private function deactivateHandler(event:Event):void
    {
        active = false;
        invalidateSkinState();
    } */
    
    /**
     *  @private
     *  add listeners to focusManager
     */
    /* private function addActivateHandlers():void
    {
        focusManager.addEventListener(FlexEvent.FLEX_WINDOW_ACTIVATE, 
            activateHandler, false, 0, true);
        focusManager.addEventListener(FlexEvent.FLEX_WINDOW_DEACTIVATE, 
            deactivateHandler, false, 0, true);
    } */
    
    /**
     *  @private
     *  find the right time to listen to the focusmanager
     */
    /* private function addedToStageHandler(event:Event):void
    {
        if (event.target == this)
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            callLater(addActivateHandlers);
        }    
    } */
    
    /**
     *  @private
     *  Called when a FocusManager is added to an IFocusManagerContainer.
     *  We need to check that it belongs to us before listening to it.
     *  Because we listen to sandboxroot, you cannot assume the type of
     *  the event.
     */
    /* private function addFocusManagerHandler(event:Event):void
    {
        if (focusManager == event.target["focusManager"])
        {
            systemManager.getSandboxRoot().removeEventListener(FlexEvent.ADD_FOCUS_MANAGER, 
                addFocusManagerHandler, true);
            addActivateHandlers();
        }
    } */
}

}
