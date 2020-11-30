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
 *  Dispatched when the <code>verticalScrollPosition</code> is going
 *  to change due to a <code>mouseWheel</code> event.
 * 
 *  <p>The default behavior is to scroll vertically by the event 
 *  <code>delta</code> number of "steps".  
 *  The viewport's <code>getVerticalScrollPositionDelta</code> method using 
 *  either <code>UP</code> or <code>DOWN</code>, depending on the scroll 
 *  direction, determines the height of the step.</p>
 * 
 *  <p>Calling the <code>preventDefault()</code> method
 *  on the event prevents the vertical scroll position from changing.
 *  Otherwise if you modify the <code>delta</code> property of the event,
 *  that value will be used as the number of vertical "steps".</p>
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

[IconFile("VScrollBar.png")]
[DefaultTriggerEvent("change")]

/**
 *  The VScrollBar (vertical scrollbar) control lets you control
 *  the portion of data that is displayed when there is too much data
 *  to fit vertically in a display area.
 * 
 *  <p>Although you can use the VScrollBar control as a stand-alone control,
 *  you usually combine it as part of another group of components to
 *  provide scrolling functionality.</p>
 *
 *  <p>The VScrollBar control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>15 pixels wide by 85 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>15 pixels wide and 15 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *        <tr>
 *           <td>Default skin classes</td>
 *           <td>spark.skins.spark.VScrollBarSkin
 *              <p>spark.skins.spark.VScrollBarThumbSkin</p>
 *              <p>spark.skins.spark.VScrollBarTrackSkin</p></td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  <p>The <code>&lt;s:VScrollBar&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:VScrollBar
 *    <strong>Properties</strong>
 *    viewport=""
 *  /&gt;
 *  </pre>
 *   
 *  @includeExample examples/VScrollBarExample.mxml
 *
 *  @see spark.skins.spark.VScrollBarSkin
 *  @see spark.skins.spark.VScrollBarThumbSkin
 *  @see spark.skins.spark.VScrollBarTrackSkin
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class VScrollBar extends ScrollBarBase
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
    public function VScrollBar()
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
        var vsp:Number = viewport.verticalScrollPosition;
        var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
        // Special case: if contentHeight is 0, assume that it hasn't been 
        // updated yet.  Making the maximum==vsp here avoids trouble later
        // when Range constrains value
        var cHeight:Number = viewport.contentHeight;
        
        if (getStyle("interactionMode") == InteractionMode.TOUCH)
        {
            // For mobile, we allow the min/max to extend a little beyond the ends so
            // we can support bounce/pull kinetic effects.
            minimum = -viewportHeight;
            maximum = (cHeight == 0) ? vsp + viewportHeight : cHeight;
        }
        else
        {
            minimum = 0;
            maximum = (cHeight == 0) ? vsp : cHeight - viewportHeight;
        }
        
        pageSize = viewportHeight;
    }
    
    /**
     *  The viewport controlled by this scrollbar.
     *  
     *  @default null
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
            removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
        }
        
        super.viewport = newViewport;

        if (newViewport)
        {
            updateMaximumAndPageSize()
            value = newViewport.verticalScrollPosition;;
            newViewport.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);  
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
        
        var r:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
        return minimum + ((r != 0) ? (y / r) * (maximum - minimum) : 0); 
    }

    /**
     *  @private
     */
    override protected function updateSkinDisplayList():void
    {
        if (!thumb || !track)
            return;

        var trackSize:Number = track.getLayoutBoundsHeight();

        var min:Number;
        var max:Number;
        if (getStyle("interactionMode") == InteractionMode.TOUCH && viewport)
        {
            // For calculating thumb position/size on mobile, we want to exclude
            // the extra margin we added to minimum and maximum for bounce/pull. 
            var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
            
            min = 0;
            max = Math.max(0, maximum - viewportHeight);
        }
        else
        {
            min = minimum;
            max = maximum;
        }
        var range:Number = max - min;

        var fixedThumbSize:Boolean = !(getStyle("fixedThumbSize") === false); 
        var thumbPos:Point;
        var thumbPosTrackY:Number = 0;
        var thumbPosParentY:Number = 0;
        var thumbSize:Number = trackSize;
        if (range > 0)
        {
            if (!fixedThumbSize)
            {
                thumbSize = Math.min((pageSize / (range + pageSize)) * trackSize, trackSize);
                thumbSize = Math.max(thumb.minHeight, thumbSize);
            }
            else
            {
                thumbSize = thumb ? thumb.height : 0;
            }
            
            // calculate new thumb position.
            thumbPosTrackY = (pendingValue - min) * ((trackSize - thumbSize) / range);
        }

        // Special thumb behavior for bounce/pull.  When the component is positioned
        // beyond its min/max, we want the scroll thumb to shink in size. 
        // Note: not checking interactionMode==TOUCH here because it is assumed that
        // value will never exceed min/max unless in touch mode.
        if (pendingValue < min)
        {
            if (!fixedThumbSize)
            {
                // The minimum size we'll shrink the thumb to is either thumb.minHeight or thumbSize: whichever is smaller.
                thumbSize = Math.max(Math.min(thumb.minHeight, thumbSize), thumbSize + pendingValue);
            }
            thumbPosTrackY = min;
        }
        if (pendingValue > max)
        {
            if (!fixedThumbSize)
            {
                // The minimum size we'll shrink the thumb to is either thumb.minHeight or thumbSize: whichever is smaller.
                thumbSize = Math.max(Math.min(thumb.minHeight, thumbSize), thumbSize - (pendingValue - max));
            }
            thumbPosTrackY = trackSize - thumbSize;
        }

        if (!fixedThumbSize)
            thumb.setLayoutBoundsSize(NaN, thumbSize);
        if (getStyle("autoThumbVisibility") === true)
            thumb.visible = thumbSize < trackSize;
        
        // convert thumb position to parent's coordinates.
        thumbPos = track.localToGlobal(new Point(0, thumbPosTrackY));
        if (thumb.parent)
            thumbPosParentY = thumb.parent.globalToLocal(thumbPos).y;
        
        thumb.setLayoutBoundsPosition(thumb.getLayoutBoundsX(), Math.round(thumbPosParentY));
    }
    
    
    /**
     *  Updates the value property and, if <code>viewport</code> is non null, then sets 
     *  its <code>verticalScrollPosition</code> to <code>value</code>.
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
            viewport.verticalScrollPosition = value;
    }
        
    /**
     *  Increment <code>value</code> by a page if <code>increase</code> is <code>true</code>, 
     *  or decrement <code>value</code>  by a page if <code>increase</code> is <code>false</code>.
     *  Increasing the scrollbar's <code>value</code> scrolls the viewport up. 
     *  Decreasing the <code>value</code> scrolls to the viewport down.
     *  
     *  <p>If the <code>viewport</code> property is set, then its 
     *  <code>getVerticalScrollPositionDelta()</code> method 
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
     *  @see spark.core.IViewport#verticalScrollPosition
     *  @see spark.core.IViewport#getVerticalScrollPositionDelta()     
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
            pageSize = Math.abs(viewport.getVerticalScrollPositionDelta(
                (increase) ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
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
            var vpPageSize:Number = Math.abs(viewport.getVerticalScrollPositionDelta(
                (newValue > value) ? NavigationUnit.PAGE_DOWN : NavigationUnit.PAGE_UP));
            super.animatePaging(newValue, vpPageSize);
            return;
        }        
        super.animatePaging(newValue, pageSize);
    }
    
    /**
     *  If <code>viewport</code> is not null, 
     *  changes the vertical scroll position for a line up or line down operation by 
     *  scrolling the viewport.
     *  This method calculates the amount to scroll by calling the 
     *  <code>IViewport.getVerticalScrollPositionDelta()</code> method 
     *  with either <code>flash.ui.Keyboard.RIGHT</code> 
     *  or <code>flash.ui.Keyboard.LEFT</code>.
     *  It then calls the <code>setValue()</code> method to 
     *  set the <code>IViewport.verticalScrollPosition</code> property 
     *  to the appropriate value.
     *
     *  <p>If <code>viewport</code> is null, 
     *  calling this method changes the vertical scroll position for 
     *  a line up or line down operation by calling 
     *  the <code>changeValueByStep()</code> method.</p>
     *
     *  @param increase Whether the line scoll is up (<code>true</code>) or
     *  down (<code>false</code>). 
     * 
     *  @see spark.components.supportClasses.Range#changeValueByStep()
     *  @see spark.components.supportClasses.Range#setValue()
     *  @see spark.core.IViewport
     *  @see spark.core.IViewport#verticalScrollPosition
     *  @see spark.core.IViewport#getVerticalScrollPositionDelta()
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
            stepSize = Math.abs(viewport.getVerticalScrollPositionDelta(
                (increase) ? NavigationUnit.DOWN : NavigationUnit.UP));
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
            thumb.setConstraintValue("top", undefined);
            thumb.setConstraintValue("bottom", undefined);
            thumb.setConstraintValue("verticalCenter", undefined);
        }      
        
        super.partAdded(partName, instance);
    }     

    /**
     *  @private
     *  Set this scrollbar's value to the viewport's current 
     *  verticalScrollPosition.
     */
    override mx_internal function viewportVerticalScrollPositionChangeHandler(event:PropertyChangeEvent):void
    {
        if (viewport)
            value = viewport.verticalScrollPosition;
    }
    
    /**
     *  @private
     *  Set this scrollbar's maximum to the viewport's contentHeight 
     *  less the viewport height and its pageSize to the viewport's height. 
     */
    override mx_internal function viewportResizeHandler(event:ResizeEvent):void
    {
        if (viewport)
            updateMaximumAndPageSize();
    }
    
    /**
     *  @private
     *  Set this scrollbar's maximum to the viewport's contentHeight 
     *  less the viewport height. 
     */
    override mx_internal function viewportContentHeightChangeHandler(event:PropertyChangeEvent):void
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
                maximum = viewport.contentHeight - viewport.height;
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
     *  Scroll vertically by event.delta "steps".  This listener is added to both the scrollbar 
     *  and the viewport so we short-ciruit if the viewport doesn't exist or isn't visible. 
     * 
     *  Note also: the HScrollBar class redispatches mouse wheel events that target the HSB 
     *  to its viewport.  If a vertical scrollbar exists, this listener will handle those
     *  events by scrolling vertically.   This is done so that if a VSB exists, the mouse
     *  wheel always scrolls vertically, even if it's over the HSB.
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
        navigationUnit = (delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
        for (var vStep:int = 0; vStep < nSteps; vStep++)
        {
            var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
            if (!isNaN(vspDelta))
            {
                vp.verticalScrollPosition += vspDelta;
                scrollPositionChanged = true;
                if (vp is IInvalidating)
                    IInvalidating(vp).validateNow();
            }
        }

        if (scrollPositionChanged)
            dispatchEvent(new Event(Event.CHANGE));

        event.preventDefault();
    }
    
}
}
