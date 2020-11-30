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
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Point;

import mx.core.EventPriority;
import mx.core.IInvalidating;
import mx.core.InteractionMode;
import mx.core.mx_internal;
import mx.events.FlexMouseEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;

import spark.components.supportClasses.ScrollBarBase;
import spark.core.IViewport;
import spark.core.NavigationUnit;
import spark.utils.MouseEventUtil;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>horizontalScrollPosition</code> is going
 *  to change due to a <code>mouseWheel</code> event.
 * 
 *  <p>The default behavior is to scroll horizontally by the event 
 *  <code>delta</code> number of "steps".  
 *  The viewport's <code>getHorizontalScrollPositionDelta</code> method using 
 *  either <code>LEFT</code> or <code>RIGHT</code>, depending on the scroll 
 *  direction, determines the width of the step.</p>
 * 
 *  <p>Calling the <code>preventDefault()</code> method
 *  on the event prevents the horizontal scroll position from changing.
 *  Otherwise if you modify the <code>delta</code> property of the event,
 *  that value will be used as the number horizontal of "steps".</p>
 *
 *  @eventType mx.events.FlexMouseEvent.MOUSE_WHEEL_CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="mouseWheelChanging", type="mx.events.FlexMouseEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("HScrollBar.png")]
[DefaultTriggerEvent("change")]

/**
 *  The HScrollBar (horizontal scrollbar) control lets you control
 *  the portion of data that is displayed when there is too much data
 *  to fit horizontally in a display area.
 * 
 *  <p>Although you can use the HScrollBar control as a stand-alone control,
 *  you usually combine it as part of another group of components to
 *  provide scrolling functionality.</p>
 *
 *  <p>The HScrollBar control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>85 pixels wide by 15 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>35 pixels wide and 35 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin classes</td>
 *           <td>spark.skins.spark.HScrollBarSkin
 *              <p>spark.skins.spark.HScrollBarThumbSkin</p>
 *              <p>spark.skins.spark.HScrollBarTrackSkin</p></td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  <p>The <code>&lt;s:HScrollBar&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:HScrollBar
 *
 *    <strong>Properties</strong>
 *    viewport=""
 *  /&gt;
 *  </pre>
 *  
 *  @see spark.skins.spark.HScrollBarSkin
 *  @see spark.skins.spark.HScrollBarThumbSkin
 *  @see spark.skins.spark.HScrollBarTrackSkin
 *
 *  @includeExample examples/HScrollBarExample.mxml
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class HScrollBar extends ScrollBarBase
{
    include "../core/Version.as";

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
     *  @productversion Flex 4
     */
    public function HScrollBar()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    private function updateMaximumAndPageSize():void
    {
        var hsp:Number = viewport.horizontalScrollPosition;
        var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;
        // Special case: if contentWidth is 0, assume that it hasn't been 
        // updated yet.  Making the maximum==hsp here avoids trouble later
        // when Range constrains value
        var cWidth:Number = viewport.contentWidth;

        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            // For mobile, we allow the min/max to extend a little beyond the ends so
            // we can support bounce/pull kinetic effects.
            minimum = -viewportWidth;
            maximum = (cWidth == 0) ? hsp + viewportWidth : cWidth;
        }
        else
        {
            minimum = 0;
            maximum = (cWidth == 0) ? hsp : cWidth - viewportWidth;
        }
        
        
        pageSize = viewportWidth;
    }
    
    /**
     *  The viewport controlled by this scrollbar.
     * 
     *  @default null
     *
     *  @see spark.core.IViewport
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *
     */
    override public function set viewport(newViewport:IViewport):void
    {
        
        const oldViewport:IViewport = super.viewport;
        if (oldViewport == newViewport)
            return;
        
        if (oldViewport)
        {
            oldViewport.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            removeEventListener(MouseEvent.MOUSE_WHEEL, hsb_mouseWheelHandler, true);
        }
        
        super.viewport = newViewport;
        
        if (newViewport)
        {
            updateMaximumAndPageSize()
            value = newViewport.horizontalScrollPosition;
            
            // The HSB viewport mouse wheel listener is added at a low priority so that 
            // if a VSB installs a listener it will run first and cancel the event.
            newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, EventPriority.DEFAULT_HANDLER);

            // The HSB mouse wheel listener stops propagation and redispatches its event, 
            // so we listen during the capture phase.
            addEventListener(MouseEvent.MOUSE_WHEEL, hsb_mouseWheelHandler, true); 
        }
    }      
    
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function pointToValue(x:Number, y:Number):Number
    {
        if (!thumb || !track)
            return 0;
        
        var r:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
        return minimum + ((r != 0) ? (x / r) * (maximum - minimum) : 0); 
    }
    
    /**
     *  @private
     */
    override protected function updateSkinDisplayList():void
    {
        if (!thumb || !track)
            return;
        
        var trackSize:Number = track.getLayoutBoundsWidth();
        
        var min:Number;
        var max:Number;
        if (getStyle("interactionMode") == InteractionMode.TOUCH && viewport)
        {
            // For calculating thumb position/size on mobile, we want to exclude
            // the extra margin we added to minimum and maximum for bounce/pull. 
            var viewportWidth:Number = isNaN(viewport.width) ? 0 : viewport.width;

            min = 0;
            max = Math.max(0, maximum - viewportWidth);
        }
        else
        {
            min = minimum;
            max = maximum;
        }
        var range:Number = max - min;
        
        var fixedThumbSize:Boolean = !(getStyle("fixedThumbSize") === false); 
        var thumbPos:Point;
        var thumbPosTrackX:Number = 0;
        var thumbPosParentX:Number = 0;
        var thumbSize:Number = trackSize;
        if (range > 0)
        {
            if (!fixedThumbSize)
            {
                thumbSize = Math.min((pageSize / (range + pageSize)) * trackSize, trackSize)
                thumbSize = Math.max(thumb.minWidth, thumbSize);
            }
            else
            {
                thumbSize = thumb ? thumb.width : 0;
            }
            
            // calculate new thumb position.
            thumbPosTrackX = (pendingValue - min) * ((trackSize - thumbSize) / range);
        }

        // Special thumb behavior for bounce/pull.  When the component is positioned
        // beyond its min/max, we want the scroll thumb to shink in size. 
        // Note: not checking interactionMode==TOUCH here because it is assumed that
        // value will never exceed min/max unless in touch mode.
        if (pendingValue < min)
        {
            if (!fixedThumbSize)
            {
                // The minimum size we'll shrink the thumb to is either thumb.minWidth or thumbSize: whichever is smaller.
                thumbSize = Math.max(Math.min(thumb.minWidth, thumbSize), thumbSize + pendingValue);
            }
            thumbPosTrackX = min;
        }
        if (pendingValue > max)
        {
            if (!fixedThumbSize)
            {
                // The minimum size we'll shrink the thumb to is either thumb.minWidth or thumbSize: whichever is smaller.
                thumbSize = Math.max(Math.min(thumb.minWidth, thumbSize), thumbSize - (pendingValue - max));
            }
            thumbPosTrackX = trackSize - thumbSize;
        }
        
        if (!fixedThumbSize)
            thumb.setLayoutBoundsSize(thumbSize, NaN);
        if (getStyle("autoThumbVisibility") === true)
            thumb.visible = thumbSize < trackSize;
        
        // convert thumb position to parent's coordinates.
        thumbPos = track.localToGlobal(new Point(thumbPosTrackX, 0));
        if (thumb.parent)
            thumbPosParentX = thumb.parent.globalToLocal(thumbPos).x;
        
        thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.getLayoutBoundsY());
    }
    
    /**
     *  Updates the <code>value</code> property and, if viewport is non-null, sets 
     *  its <code>horizontalScrollPosition</code> to <code>value</code>.
     * 
     *  @param value The new value of the <code>value</code> property. 
     *  @see #viewport
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override protected function setValue(value:Number):void
    {
        super.setValue(value);
        if (viewport)
            viewport.horizontalScrollPosition = value;
    }
    

    /**
     *  Increment <code>value</code> by a page if <code>increase</code> is <code>true</code>, 
     *  or decrement <code>value</code>  by a page if <code>increase</code> is <code>false</code>.
     *  Increasing the scrollbar's <code>value</code> scrolls the viewport to the right. 
     *  Decreasing the <code>value</code> scrolls to the viewport to the left.
     *  
     *  <p>If the <code>viewport</code> property is set, then its 
     *  <code>getHorizontalScrollPositionDelta()</code> method 
     *  is used to compute the size of the page increment.  
     *  If <code>viewport</code> is null, then the scrollbar's
     *  <code>pageSize</code> property is used.</p>
     *
     *  @param increase Whether to increment (<code>true</code>) or
     *  decrement (<code>false</code>) <code>value</code>. 
     * 
     *  @see spark.components.supportClasses.ScrollBarBase#changeValueByPage()
     *  @see spark.components.supportClasses.Range#setValue()
     *  @see spark.core.IViewport
     *  @see spark.core.IViewport#horizontalScrollPosition
     *  @see spark.core.IViewport#getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function changeValueByPage(increase:Boolean = true):void
    {
        var oldPageSize:Number;
        if (viewport)
        {
            // Want to use ScrollBarBase's changeValueByPage() implementation to get the same
            // animated behavior for scrollbars with and without viewports.
            // For now, just change pageSize temporarily and call the superclass
            // implementation.
            oldPageSize = pageSize;
            pageSize = Math.abs(viewport.getHorizontalScrollPositionDelta(
                (increase) ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
        }
        super.changeValueByPage(increase);
        if (viewport)
            pageSize = oldPageSize;
    }

    /**
     * @private
     */
    override protected function animatePaging(newValue:Number, pageSize:Number):void
    {
        if (viewport)
        {
            var vpPageSize:Number = Math.abs(viewport.getHorizontalScrollPositionDelta(
                (newValue > value) ? NavigationUnit.PAGE_RIGHT : NavigationUnit.PAGE_LEFT));
            super.animatePaging(newValue, vpPageSize);
            return;
        }        
        super.animatePaging(newValue, pageSize);
    }
    
    /**
     *  If <code>viewport</code> is not null, 
     *  changes the horizontal scroll position for a line up
     *  or line down operation by 
     *  scrolling the viewport.
     *  This method calculates the amount to scroll by calling the 
     *  <code>IViewport.getHorizontalScrollPositionDelta()</code> method 
     *  with either <code>flash.ui.Keyboard.RIGHT</code> 
     *  or <code>flash.ui.Keyboard.LEFT</code>.
     *  It then calls the <code>setValue()</code> method to 
     *  set the <code>IViewport.horizontalScrollPosition</code> property 
     *  to the appropriate value.
     *
     *  <p>If <code>viewport</code> is null, 
     *  calling this method changes the scroll position for a line up
     *  or line down operation by calling 
     *  the <code>changeValueByStep()</code> method.</p>
     *
     *  @param increase Whether the line scoll is up (<code>true</code>) or
     *  down (<code>false</code>). 
     * 
     *  @see spark.components.supportClasses.Range#changeValueByStep()
     *  @see spark.components.supportClasses.Range#setValue()
     *  @see spark.core.IViewport
     *  @see spark.core.IViewport#horizontalScrollPosition
     *  @see spark.core.IViewport#getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function changeValueByStep(increase:Boolean = true):void
    {
        var oldStepSize:Number;
        if (viewport)
        {
            // Want to use ScrollBarBase's changeValueByStep() implementation to get the same
            // animated behavior for scrollbars with and without viewports.
            // For now, just change stepSize temporarily and call the superclass
            // implementation.
            oldStepSize = stepSize;
            stepSize = Math.abs(viewport.getHorizontalScrollPositionDelta(
                (increase) ? NavigationUnit.RIGHT : NavigationUnit.LEFT));
        }
        super.changeValueByStep(increase);
        if (viewport)
            stepSize = oldStepSize;
    }   
    
    /**
     *  @private
     */    
    override protected function partAdded(partName:String, instance:Object):void
    {
        if (instance == thumb)
        {
            thumb.setConstraintValue("left", undefined);
            thumb.setConstraintValue("right", undefined);
            thumb.setConstraintValue("horizontalCenter", undefined);
        }      
        
        super.partAdded(partName, instance);
    }
    
    /**
     *  @private 
     *  Set this scrollbar's value to the viewport's current horizontalScrollPosition.
     */
    override mx_internal function viewportHorizontalScrollPositionChangeHandler(event:PropertyChangeEvent):void
    {
        if (viewport)
            value = viewport.horizontalScrollPosition;
    } 
    
    /**
     *  @private 
     *  Set this scrollbar's maximum to the viewport's contentWidth 
     *  less the viewport width and its pageSize to the viewport's width. 
     */
    override mx_internal function viewportResizeHandler(event:ResizeEvent):void
    {
        if (viewport)
            updateMaximumAndPageSize();
    }
    
    /**
     *  @private 
     *  Set this scrollbar's maximum to the viewport's contentWidth less the viewport width. 
     */
    override mx_internal function viewportContentWidthChangeHandler(event:PropertyChangeEvent):void
    {
        if (viewport)
        {
            if (getStyle("interactionMode") == InteractionMode.TOUCH)
            {
                updateMaximumAndPageSize();
            }
            else
            {
                // SDK-28898: reverted previous behavior for desktop, resets
                // scroll position to zero when all content is removed.
                maximum = viewport.contentWidth - viewport.width;
            }
        }
    }
    
    /**
     *  @private 
     */
    override public function styleChanged(styleName:String):void
    {
        super.styleChanged(styleName);
        
        var allStyles:Boolean = !styleName || styleName == "styleName";
        
        if (allStyles || styleName == "interactionMode")
        {
            if (viewport)
                updateMaximumAndPageSize();
        }
    }
    
    /**
     *  @private
     *  Scroll horizontally by event.delta "steps".  This listener is added to the viewport
     *  at a lower priority then the vertical scrollbar mouse wheel listener, so that vertical 
     *  scrolling is preferred when both scrollbars exist.
     */
    mx_internal function mouseWheelHandler(event:MouseEvent):void
    {
        const vp:IViewport = viewport;
        if (event.isDefaultPrevented() || !vp || !vp.visible || !visible)
            return;
        
        // Dispatch the "mouseWheelChanging" event. If preventDefault() is called
        // on this event, the event will be cancelled.  Otherwise if  the delta
        // is modified the new value will be used.
        var changingEvent:FlexMouseEvent = MouseEventUtil.createMouseWheelChangingEvent(event);
        if (!dispatchEvent(changingEvent))
        {
            event.preventDefault();
            return;
        }
        
        const delta:int = changingEvent.delta;
        
        var nSteps:uint = Math.abs(delta);
        var navigationUnit:uint;
        var scrollPositionChanged:Boolean;

        // Scroll delta "steps".  
        navigationUnit = (delta < 0) ? NavigationUnit.RIGHT : NavigationUnit.LEFT;
        for (var hStep:int = 0; hStep < nSteps; hStep++)
        {
            var hspDelta:Number = vp.getHorizontalScrollPositionDelta(navigationUnit);
            if (!isNaN(hspDelta))
            {
                vp.horizontalScrollPosition += hspDelta;
                scrollPositionChanged = true;
                if (vp is IInvalidating)
                    IInvalidating(vp).validateNow();
            }
        }
        
        if (scrollPositionChanged)
            dispatchEvent(new Event(Event.CHANGE));

        event.preventDefault();
    }
    
    /**
     *  @private
     *  Redispatch HSB mouse wheel events to the viewport to give the VSB's listener, if any,
     *  an opportunity to handle/cancel them.  If no VSB exists, mouseWheelHandler (see above)
     *  will process the event.
     */
    private function hsb_mouseWheelHandler(event:MouseEvent):void
    {
        const vp:IViewport = viewport;
        if (event.isDefaultPrevented() || !vp || !vp.visible)
            return;

        event.stopImmediatePropagation();            
        vp.dispatchEvent(event);        
    }
}
}
