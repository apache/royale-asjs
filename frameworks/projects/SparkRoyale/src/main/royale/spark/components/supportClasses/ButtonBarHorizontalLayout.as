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

package spark.components.supportClasses
{

import spark.components.supportClasses.GroupBase;
import mx.core.ILayoutElement;
import spark.layouts.supportClasses.LayoutBase;

/**
 *  The ButtonBarHorizontalLayout class is a layout specifically designed for the
 *  Spark ButtonBar skins.
 *  The layout lays out the children horizontally, left to right.
 *  
 *  <p>The layout attempts to size all children to their preferred size.
 *  If there is enough space, each child is set to its preferred size, plus any
 *  excess space evenly distributed among the children.</p>
 * 
 *  <p>If there is not enough space for all the children to be sized to their
 *  preferred size, then the children that are smaller than the average width
 *  are allocated their preferred size and the rest of the elements are
 *  reduced equally.</p>
 * 
 *  <p>All children are set to the height of the parent.</p>
 * 
 *  @see spark.skins.spark.ButtonBarSkin
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class ButtonBarHorizontalLayout extends LayoutBase
{
    //include "../../core/Version.as";

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
    public function ButtonBarHorizontalLayout():void
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  gap
    //----------------------------------

    private var _gap:int = 0;

    [Inspectable(category="General")]

    /**
     *  The horizontal space between layout elements.
     * 
     *  Note that the gap is only applied between layout elements, so if there's
     *  just one element, the gap has no effect on the layout.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function get gap():int
    {
        return _gap;
    }

    /**
     *  @private
     */
    public function set gap(value:int):void
    {
        if (_gap == value) 
            return;
    
        _gap = value;

        var g:GroupBase = target;
        if (g)
        {
            g.invalidateSize();
            g.invalidateDisplayList();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function measure():void
    {
        super.measure();
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;

        var elementCount:int = 0;
        var gap:Number = this.gap;

        var width:Number = 0;
        var height:Number = 0;

        var count:int = layoutTarget.numElements;
        for (var i:int = 0; i < count; i++)
        {
            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;

            width += layoutElement.getPreferredBoundsWidth();
            elementCount++;
            height = Math.max(height, layoutElement.getPreferredBoundsHeight());

        }

        if (elementCount > 1)
            width += gap * (elementCount - 1);

        layoutTarget.measuredWidth = width;
        layoutTarget.measuredHeight = height;
    }

    /**
     *  @private 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function updateDisplayList(width:Number, height:Number):void
    {
        var gap:Number = this.gap;
        super.updateDisplayList(width, height);
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;

        // Pass one: calculate the excess space
        var totalPreferredWidth:Number = 0;            
        var count:int = layoutTarget.numElements;
        var elementCount:int = count;
        var layoutElement:ILayoutElement;
        for (var i:int = 0; i < count; i++)
        {
            layoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
            {
                elementCount--;
                continue;
            }
            totalPreferredWidth += layoutElement.getPreferredBoundsWidth();
        }
        
        // Special case for no elements
        if (elementCount == 0)
        {
            layoutTarget.setContentSize(0, 0);
            return;
        }
        
        // The content size is always the parent size
        layoutTarget.setContentSize(width, height);

        // Special case: if width is zero, make the gap zero as well
        if (width == 0)
            gap = 0;

        // excessSpace can be negative
        var excessSpace:Number = width - totalPreferredWidth - gap * (elementCount - 1);
        var widthToDistribute:Number = width - gap * (elementCount - 1);
        
        // Special case: when we don't have enough space we need to count
        // the number of children smaller than the averager size.
        var averageWidth:Number;
        var largeChildrenCount:int = elementCount;
        if (excessSpace < 0)
        {
            averageWidth = width / elementCount;
            for (i = 0; i < count; i++)
            {
                layoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
                if (!layoutElement || !layoutElement.includeInLayout)
                    continue;

                var preferredWidth:Number = layoutElement.getPreferredBoundsWidth();
                if (preferredWidth <= averageWidth)
                {
                    widthToDistribute -= preferredWidth;
                    largeChildrenCount--;
                    continue;
                }
            }
            widthToDistribute = Math.max(0, widthToDistribute);
        }
        
        // Resize and position children
        var x:Number = 0;
        var childWidth:Number = NaN;
        var childWidthRounded:Number = NaN;
        var roundOff:Number = 0;
        for (i = 0; i < count; i++)
        {
            layoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;

            if (excessSpace > 0)
            {
                childWidth = widthToDistribute * layoutElement.getPreferredBoundsWidth() / totalPreferredWidth;
            }
            else if (excessSpace < 0)
            {
                childWidth = (averageWidth < layoutElement.getPreferredBoundsWidth()) ? widthToDistribute / largeChildrenCount : NaN;  
            }
            
            if (!isNaN(childWidth))
            {
                // Round, we want integer values
                childWidthRounded = Math.round(childWidth + roundOff);
                roundOff += childWidth - childWidthRounded;
            }

            layoutElement.setLayoutBoundsSize(childWidthRounded, height);
            layoutElement.setLayoutBoundsPosition(x, 0);
            
            // No need to round, width should be an integer number
            x += gap + layoutElement.getLayoutBoundsWidth(); 
            
            // Reset childWidthRounded
            childWidthRounded = NaN;
        }
    }
}

}
