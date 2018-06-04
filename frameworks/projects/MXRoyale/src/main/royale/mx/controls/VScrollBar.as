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
/* 
import flash.ui.Keyboard;
import mx.controls.scrollClasses.ScrollBar;
import mx.controls.scrollClasses.ScrollBarDirection;

 */
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.ScrollEvent;
use namespace mx_internal;


//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="scrollPosition", destination="scrollPosition")]

[DefaultTriggerEvent("scroll")]

//[IconFile("VScrollBar.png")]

[Alternative(replacement="spark.components.VScrollBar", since="4.0")]

/**
 *  The VScrollBar (vertical ScrollBar) control  lets you control
 *  the portion of data that is displayed when there is too much data
 *  to fit in a display area.
 * 
 *  This control extends the base ScrollBar control. 
 *  
 *  <p>Although you can use the VScrollBar control as a stand-alone control,
 *  you usually combine it as part of another group of components to
 *  provide scrolling functionality.</p>
 *  
 *  <p>A ScrollBar control consist of four parts: two arrow buttons,
 *  a track, and a thumb. 
 *  The position of the thumb and the display of the arrow buttons
 *  depend on the current state of the ScrollBar control.
 *  The ScrollBar control uses four parameters to calculate its 
 *  display state:</p>
 *
 *  <ul>
 *    <li>Minimum range value</li>
 *    <li>Maximum range value</li>
 *    <li>Current position - must be within the
 *    minimum and maximum range values</li>
 *    <li>Viewport size - represents the number of items
 *    in the range that you can display at one time. The
 *    number of items must be less than or equal to the 
 *    range, where the range is the set of values between
 *    the minimum range value and the maximum range value.</li>
 *  </ul>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:VScrollBar&gt;</code> tag inherits all the
 *  tag attributes of its superclass, and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:VScrollBar
 *    <strong>Styles</strong>
 *    repeatDelay="500"
 *    repeatInterval="35"
 * 
 *    <strong>Events</strong>
 *    scroll="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/VScrollBarExample.mxml
 *
 *  @see mx.controls.scrollClasses.ScrollBar
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class VScrollBar extends UIComponent
{
   // include "../core/Version.as";

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
    public function VScrollBar()
    {
        super();

    }

	 //----------------------------------
    //  scrollPosition
    //----------------------------------

    /**
     *  @private
     *  Storage for the scrollPosition property.
     */
    private var _scrollPosition:Number = 0;

    [Inspectable(category="Other", defaultValue="0")]

    /**
     *  Number that represents the current scroll position.
     * 
     *  The value is between <code>minScrollPosition</code> and
     *  <code>maxScrollPosition</code> inclusively.
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get scrollPosition():Number
    {
        return _scrollPosition;
    }

    /**
     *  @private
     */
    public function set scrollPosition(value:Number):void
    {
        _scrollPosition = value;

        /* if (scrollThumb)
        {
            // Turn on bitmap caching whenever we start scrolling.  Turn it
            // off whenever we resize the scrollbar (because caching hurts
            // performance during a resize animation)
            if (!cacheAsBitmap)
                cacheHeuristic = scrollThumb.cacheHeuristic = true;

            if (!isScrolling)
            {
                // Update thumb.
                value = Math.min(value, maxScrollPosition);
                value = Math.max(value, minScrollPosition);

                var denom:Number = maxScrollPosition - minScrollPosition;
                var y:Number = (denom == 0 || isNaN(denom)) ? 0 :
                    ((value - minScrollPosition) * (trackHeight - scrollThumb.height) /
                    (denom)) + trackY;

                var x:Number = (virtualWidth - scrollThumb.width) / 2  + getStyle("thumbOffset");
                scrollThumb.move(Math.round(x), Math.round(y));
            }
        } */
    }
	  /**
     *  Sets the range and viewport size of the ScrollBar control. 
     * 
     *  The ScrollBar control updates the state of the arrow buttons and 
     *  size of the scroll thumb accordingly.
     *
     *  @param pageSize Number which represents the size of one page. 
     *
     *  @param minScrollPosition Number which represents the bottom of the 
     *  scrolling range.
     *
     *  @param maxScrollPosition Number which represents the top of the 
     *  scrolling range.
     *
     *  @param pageScrollSize Number which represents the increment to move when 
     *  the scroll track is pressed.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setScrollProperties(pageSize:Number,
                                        minScrollPosition:Number,
                                        maxScrollPosition:Number,
                                        pageScrollSize:Number = 0):void
    {
       /*  var thumbHeight:Number;

        this.pageSize = pageSize;

        _pageScrollSize = (pageScrollSize > 0) ? pageScrollSize : pageSize;

        this.minScrollPosition = Math.max(minScrollPosition, 0);
        this.maxScrollPosition = Math.max(maxScrollPosition, 0);

        _scrollPosition = Math.max(this.minScrollPosition, _scrollPosition);
        _scrollPosition = Math.min(this.maxScrollPosition, _scrollPosition);

        // If the ScrollBar is enabled and has a nonzero range ...
        if (this.maxScrollPosition - this.minScrollPosition > 0 && enabled)
        {
            upArrow.enabled = true;
            downArrow.enabled = true;
            scrollTrack.enabled = true;

            addEventListener(MouseEvent.MOUSE_DOWN,
                             scrollTrack_mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_OVER,
                             scrollTrack_mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT,
                             scrollTrack_mouseOutHandler);

            if (!scrollThumb)
            {
                scrollThumb = new ScrollThumb();

                scrollThumb.focusEnabled = false;
                scrollThumb.tabEnabled = false;
                
                // Add the thumb above the up arrow but below the down arrow
                addChildAt(scrollThumb, getChildIndex(downArrow));

                scrollThumb.styleName = new StyleProxy(this, thumbStyleFilters);

                // This button is a 4-state Button
                // that by default uses the ScrollThumbSkin.
                scrollThumb.upSkinName = "thumbUpSkin";
                scrollThumb.overSkinName = "thumbOverSkin";
                scrollThumb.downSkinName = "thumbDownSkin";
                scrollThumb.iconName = "thumbIcon";
                scrollThumb.skinName = "thumbSkin";
            }

            thumbHeight = trackHeight < 0 ? 0 : Math.round(
                pageSize /
                (this.maxScrollPosition - this.minScrollPosition + pageSize) *
                trackHeight);

            if (thumbHeight < scrollThumb.minHeight)
            {
                if (trackHeight < scrollThumb.minHeight)
                {
                    scrollThumb.visible = false;
                }
                else
                {
                    thumbHeight = scrollThumb.minHeight;
                    scrollThumb.visible = true;
                    scrollThumb.setActualSize(scrollThumb.measuredWidth, scrollThumb.minHeight);
                }
            }
            else
            {
                scrollThumb.visible = true;
                scrollThumb.setActualSize(scrollThumb.measuredWidth, thumbHeight);
            }

            scrollThumb.setRange(upArrow.getExplicitOrMeasuredHeight() + 0,
                                 virtualHeight -
                                 downArrow.getExplicitOrMeasuredHeight() -
                                 scrollThumb.height,
                                 this.minScrollPosition,
                                 this.maxScrollPosition);

            scrollPosition = Math.max(Math.min(scrollPosition, this.maxScrollPosition), this.minScrollPosition);
        }
        else
        {
            upArrow.enabled = false;
            downArrow.enabled = false;
            scrollTrack.enabled = false;

            if (scrollThumb)
                scrollThumb.visible = false;
        } */
    }
   
   
}

}
