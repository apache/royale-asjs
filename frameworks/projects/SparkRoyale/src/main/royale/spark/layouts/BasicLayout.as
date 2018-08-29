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

package spark.layouts
{

import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.mx_internal;
//import mx.resources.ResourceManager;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;
import spark.layouts.supportClasses.LayoutElementHelper;

use namespace mx_internal;

//[ResourceBundle("layout")]

/**
 *  The BasicLayout class arranges the layout elements according to their individual settings,
 *  independent of each-other. BasicLayout, also called absolute layout, requires that you 
 *  explicitly position each container child. 
 *  You can use the <code>x</code> and <code>y</code> properties of the child, 
 *  or constraints to position each child.
 *
 *  <p><b>Note: </b>The Spark list-based controls (the Spark List control and its subclasses
 *  such as ButtonBar, ComboBox, DropDownList, and TabBar) do not support the BasicLayout class. 
 *  Do not use BasicLayout with the Spark list-based controls.</p>
 *
 *  <p>Per-element supported constraints are <code>left</code>, <code>right</code>, 
 *  <code>top</code>, <code>bottom</code>, <code>horizontalCenter</code>,
 *  <code>verticalCenter</code>, <code>baseline</code>, <code>percentWidth</code>, and <code>percentHeight</code>.
 *  Element's minimum and maximum sizes will always be respected.</p>
 *
 *  <p>The measured size of the container is calculated from the elements, their
 *  constraints and their preferred sizes. The measured size of the container
 *  is big enough to fit in all of the elements at their preferred sizes with
 *  their constraints satisfied. </p>
 *
 *  <p>Here are some examples of how measured size is calculated:
 *  <ul>
 *    <li>If the container has a single element with <code>left</code> constraint specified,
 *    then the container's measured width will be equal to the element's preferred
 *    width plus the value of the <code>left</code> constraint.</li>
 *
 *    <li>If the container has a single element with <code>percentWidth</code> specified, 
 *    then the container's measured width will be equal to the element's preferred width.
 *    Even though the element's <code>percentWidth</code> is not directly factored in the calculations,
 *    it will be respected during a call to the <code>updateDisplayList()</code> method.</li>
 * 
 *    <li>If the container has a single element with <code>baseline</code> constraint specified,
 *    then the container's measured height will be equal to the element's preferred height
 *    plus the <code>baseline</code> and minus the value of the element's <code>baselinePosition</code> property.</li>
 *
 *    <li>If the container has a single element with <code>verticalCenter</code> constraint specified,
 *    then the container's measured height will be equal to the element's preferred height
 *    plus double the value of the <code>verticalCenter</code> constraint.</li>
 *  </ul>
 * </p>
 *
 *  <p>During a call to the <code>updateDisplayList()</code> method, 
 *  the element's size is determined according to
 *  the rules in the following order of precedence (the element's minimum and
 *  maximum sizes are always respected):</p>
 *  <ul>
 *    <li>If the element has <code>percentWidth</code> or <code>percentHeight</code> set, 
 *    then its size is calculated as a percentage of the available size, where the available
 *    size is the container size minus any <code>left</code>, <code>right</code>,
 *    <code>top</code>, or <code>bottom</code> constraints.</li>
 *
 *    <li>If the element has both left and right constraints, it's width is
 *    set to be the container's width minus the <code>left</code> 
 *    and <code>right</code> constraints.</li>
 * 
 *    <li>If the element has both <code>top</code> and <code>bottom</code> constraints, 
 *    it's height is set to be the container's height minus the <code>top</code> 
 *    and <code>bottom</code> constraints.</li>
 *
 *    <li>The element is set to its preferred width and/or height.</li>
 *  </ul>
 *
 *  <p>The BasicLayout class calculates its minimum size as the maximum of the minimum child sizes:</p>
 *
 *  <ol>
 *    <li>For each child in the container, determine the minimum size 
 *        to which the child could shrink:
 *        <ul>
 *          <li>If the child is constrained to its parent's width or height, 
 *              then the child could shrink to its minimum width or height.  
 *              Use the minimum size of the child.</li>
 *          <li>If the child is not constrained to the parent, 
 *              then it remains at its preferred size.  
 *              Use the preferred size of the child.  </li>
 *        </ul></li>
 *     <li>Find the maximum of the sizes from step 1. </li>
 *  </ol>
 *
 *  <p>Therefore, if a child is constrained to its parent, then the layout 
 *  uses the child's minimum size. 
 *  Otherwise, it uses its preferred size of the child to calculate 
 *  the minimum size for the container.</p>
 * 
 *  <p>The element's position is determined according to the rules in the following
 *  order of precedence:</p>
 *  <ul>
 *    <li>The <code>horizontalCenter</code> or <code>verticalCenter</code> constraints 
 *    specify the distance between the container's center and the element's center.
 *    Set the <code>horizontalCenter</code> or <code>verticalCenter</code> constraints 
 *    to zero to center the element within the container in 
 *    the horizontal or vertical direction.</li>
 * 
 *    <li>If element's baseline is specified, then the element is positioned in
 *    the vertical direction such that its <code>baselinePosition</code> (usually the base line
 *    of its first line of text) is aligned with <code>baseline</code> constraint.</li>
 *
 *    <li>If element's <code>top</code> or <code>left</code> constraints 
 *    are specified, then the element is
 *    positioned such that the top-left corner of the element's layout bounds is
 *    offset from the top-left corner of the container by the specified values.</li>
 *
 *    <li>If element's <code>bottom</code> or <code>right</code> constraints are specified, 
 *    then the element is positioned such that the bottom-right corner 
 *    of the element's layout bounds is
 *    offset from the bottom-right corner of the container by the specified values.</li>
 * 
 *    <li>When no constraints determine the position in the horizontal or vertical
 *    direction, the element is positioned according to its x and y coordinates.</li>
 *  </ul>
 *
 *  <p>The content size of the container is calculated as the maximum of the
 *  coordinates of the bottom-right corner of all the layout elements.</p>
 *
 *  @mxml 
 *  <p>The <code>&lt;s:BasicLayout&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds no additional tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:BasicLayout/&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class BasicLayout extends LayoutBase
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    private static function constraintsDetermineWidth(layoutElement:ILayoutElement):Boolean
    {
        return !isNaN(layoutElement.percentWidth) ||
               !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.left)) &&
               !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.right));
    }

    private static function constraintsDetermineHeight(layoutElement:ILayoutElement):Boolean
    {
        return !isNaN(layoutElement.percentHeight) ||
               !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.top)) &&
               !isNaN(LayoutElementHelper.parseConstraintValue(layoutElement.bottom));
    }

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
    public function BasicLayout():void
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */ 
    override mx_internal function get virtualLayoutSupported():Boolean
    {
        return false;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private 
     */
    private function checkUseVirtualLayout():void
    {
        if (useVirtualLayout)
            throw new Error(/*ResourceManager.getInstance().getString("layout", */"basicLayoutNotVirtualized"/*)*/);
    }

    /**
     *  @private 
     */
    override public function measure():void
    {
        // Check for unsuported values here instead of in the useVirtualLayout setter, as
        // List may toggle the property several times before the actual layout pass.
        checkUseVirtualLayout();
        super.measure();
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;

        var width:Number = 0;
        var height:Number = 0;
        var minWidth:Number = 0;
        var minHeight:Number = 0;

        var count:int = layoutTarget.numElements;
        for (var i:int = 0; i < count; i++)
        {
            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;

            var hCenter:Number   = LayoutElementHelper.parseConstraintValue(layoutElement.horizontalCenter);
            var vCenter:Number   = LayoutElementHelper.parseConstraintValue(layoutElement.verticalCenter);
            //var baseline:Number  = LayoutElementHelper.parseConstraintValue(layoutElement.baseline);
            var left:Number      = LayoutElementHelper.parseConstraintValue(layoutElement.left);
            var right:Number     = LayoutElementHelper.parseConstraintValue(layoutElement.right);
            var top:Number       = LayoutElementHelper.parseConstraintValue(layoutElement.top);
            var bottom:Number    = LayoutElementHelper.parseConstraintValue(layoutElement.bottom);

            // Extents of the element - how much additional space (besides its own width/height)
            // the element needs based on its constraints.
            var extX:Number;
            var extY:Number;

            if (!isNaN(left) && !isNaN(right))
            {
                // If both left & right are set, then the extents is always
                // left + right so that the element is resized to its preferred
                // size (if it's the one that pushes out the default size of the container).
                extX = left + right;                
            }
            else if (!isNaN(hCenter))
            {
                // If we have horizontalCenter, then we want to have at least enough space
                // so that the element is within the parent container.
                // If the element is aligned to the left/right edge of the container and the
                // distance between the centers is hCenter, then the container width will be
                // parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
                // <=> parentWidth = 2 * abs(hCenter) + elementWidth
                // Since the extents is the additional space that the element needs
                // extX = parentWidth - elementWidth = 2 * abs(hCenter)
                extX = Math.abs(hCenter) * 2;
            }
            else if (!isNaN(left) || !isNaN(right))
            {
                extX = isNaN(left) ? 0 : left;
                extX += isNaN(right) ? 0 : right;
            }
            else
            {
                extX = layoutElement.getBoundsXAtSize(NaN, NaN);
            }
            
            if (!isNaN(top) && !isNaN(bottom))
            {
                // If both top & bottom are set, then the extents is always
                // top + bottom so that the element is resized to its preferred
                // size (if it's the one that pushes out the default size of the container).
                extY = top + bottom;                
            }
            else if (!isNaN(vCenter))
            {
                // If we have verticalCenter, then we want to have at least enough space
                // so that the element is within the parent container.
                // If the element is aligned to the top/bottom edge of the container and the
                // distance between the centers is vCenter, then the container height will be
                // parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
                // <=> parentHeight = 2 * abs(vCenter) + elementHeight
                // Since the extents is the additional space that the element needs
                // extY = parentHeight - elementHeight = 2 * abs(vCenter)
                extY = Math.abs(vCenter) * 2;
            }
            /*else if (!isNaN(baseline))
            {
                extY = Math.round(baseline - layoutElement.baselinePosition);
            }*/
            else if (!isNaN(top) || !isNaN(bottom))
            {
                extY = isNaN(top) ? 0 : top;
                extY += isNaN(bottom) ? 0 : bottom;
            }
            else
            {
                extY = layoutElement.getBoundsYAtSize(NaN, NaN);
            }

            var preferredWidth:Number = layoutElement.getPreferredBoundsWidth();
            var preferredHeight:Number = layoutElement.getPreferredBoundsHeight();

            width = Math.max(width, extX + preferredWidth);
            height = Math.max(height, extY + preferredHeight);

            // Find the minimum default extents, we take the minimum width/height only
            // when the element size is determined by the parent size
            var elementMinWidth:Number =
                constraintsDetermineWidth(layoutElement) ? layoutElement.getMinBoundsWidth() :
                                                           preferredWidth;
            var elementMinHeight:Number =
                constraintsDetermineHeight(layoutElement) ? layoutElement.getMinBoundsHeight() : 
                                                            preferredHeight;

            minWidth = Math.max(minWidth, extX + elementMinWidth);
            minHeight = Math.max(minHeight, extY + elementMinHeight);
        }

        // Use Math.ceil() to make sure that if the content partially occupies
        // the last pixel, we'll count it as if the whole pixel is occupied.
        layoutTarget.measuredWidth = Math.ceil(Math.max(width, minWidth));
        layoutTarget.measuredHeight = Math.ceil(Math.max(height, minHeight));
        layoutTarget.measuredMinWidth = Math.ceil(minWidth);
        layoutTarget.measuredMinHeight = Math.ceil(minHeight);
    }

    /**
     *  @return Returns the maximum value for an element's dimension so that the component doesn't
     *  spill out of the container size. Calculations are based on the layout rules.
     *  Pass in unscaledWidth, hCenter, left, right, childX to get a maxWidth value.
     *  Pass in unscaledHeight, vCenter, top, bottom, childY to get a maxHeight value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    static private function maxSizeToFitIn(totalSize:Number,
                                           center:Number,
                                           lowConstraint:Number,
                                           highConstraint:Number,
                                           position:Number):Number
    {
        if (!isNaN(center))
        {
            // (1) x == (totalSize - childWidth) / 2 + hCenter
            // (2) x + childWidth <= totalSize
            // (3) x >= 0
            //
            // Substitue x in (2):
            // (totalSize - childWidth) / 2 + hCenter + childWidth <= totalSize
            // totalSize - childWidth + 2 * hCenter + 2 * childWidth <= 2 * totalSize
            // 2 * hCenter + childWidth <= totalSize se we get:
            // (3) childWidth <= totalSize - 2 * hCenter
            //
            // Substitute x in (3):
            // (4) childWidth <= totalSize + 2 * hCenter
            //
            // From (3) & (4) above we get:
            // childWidth <= totalSize - 2 * abs(hCenter)

            return totalSize - 2 * Math.abs(center);
        }
        else if (!isNaN(lowConstraint))
        {
            // childWidth + left <= totalSize
            return totalSize - lowConstraint;
        }
        else if (!isNaN(highConstraint))
        {
            // childWidth + right <= totalSize
            return totalSize - highConstraint;
        }
        else
        {
            // childWidth + childX <= totalSize
            return totalSize - position;
        }
    }

    /**
     *  @private 
     */
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Check for unsuported values here instead of in the useVirtualLayout setter, as
        // List may toggle the property several times before the actual layout pass.
        checkUseVirtualLayout();
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;

        var count:int = layoutTarget.numElements;
        var maxX:Number = 0;
        var maxY:Number = 0;
        for (var i:int = 0; i < count; i++)
        {
            var layoutElement:ILayoutElement = layoutTarget.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;

            var hCenter:Number          = LayoutElementHelper.parseConstraintValue(layoutElement.horizontalCenter);
            var vCenter:Number          = LayoutElementHelper.parseConstraintValue(layoutElement.verticalCenter);
            //var baseline:Number         = LayoutElementHelper.parseConstraintValue(layoutElement.baseline);
            var left:Number             = LayoutElementHelper.parseConstraintValue(layoutElement.left);
            var right:Number            = LayoutElementHelper.parseConstraintValue(layoutElement.right);
            var top:Number              = LayoutElementHelper.parseConstraintValue(layoutElement.top);
            var bottom:Number           = LayoutElementHelper.parseConstraintValue(layoutElement.bottom);
            var percentWidth:Number     = layoutElement.percentWidth;
            var percentHeight:Number    = layoutElement.percentHeight;
            
            var elementMaxWidth:Number = NaN; 
            var elementMaxHeight:Number = NaN;

            // Calculate size
            var childWidth:Number = NaN;
            var childHeight:Number = NaN;

            if (!isNaN(percentWidth))
            {
                var availableWidth:Number = unscaledWidth;
                if (!isNaN(left))
                    availableWidth -= left;
                if (!isNaN(right))
                     availableWidth -= right;

                childWidth = Math.round(availableWidth * Math.min(percentWidth * 0.01, 1));
                elementMaxWidth = Math.min(layoutElement.getMaxBoundsWidth(),
                    maxSizeToFitIn(unscaledWidth, hCenter, left, right, layoutElement.getLayoutBoundsX()));
            }
            else if (!isNaN(left) && !isNaN(right))
            {
                childWidth = unscaledWidth - right - left;
            }

            if (!isNaN(percentHeight))
            {
                var availableHeight:Number = unscaledHeight;
                if (!isNaN(top))
                    availableHeight -= top;
                if (!isNaN(bottom))
                    availableHeight -= bottom;    
                    
                childHeight = Math.round(availableHeight * Math.min(percentHeight * 0.01, 1));
                elementMaxHeight = Math.min(layoutElement.getMaxBoundsHeight(),
                    maxSizeToFitIn(unscaledHeight, vCenter, top, bottom, layoutElement.getLayoutBoundsY()));
            }
            else if (!isNaN(top) && !isNaN(bottom))
            {
                childHeight = unscaledHeight - bottom - top;
            }

            // Apply min and max constraints, make sure min is applied last. In the cases
            // where childWidth and childHeight are NaN, setLayoutBoundsSize will use preferredSize
            // which is already constrained between min and max.
            if (!isNaN(childWidth))
            {
                if (isNaN(elementMaxWidth))
                    elementMaxWidth = layoutElement.getMaxBoundsWidth();
                childWidth = Math.max(layoutElement.getMinBoundsWidth(), Math.min(elementMaxWidth, childWidth));
            }
            if (!isNaN(childHeight))
            {
                if (isNaN(elementMaxHeight))
                    elementMaxHeight = layoutElement.getMaxBoundsHeight();
                childHeight = Math.max(layoutElement.getMinBoundsHeight(), Math.min(elementMaxHeight, childHeight));
            }

            // Set the size.
            layoutElement.setLayoutBoundsSize(childWidth, childHeight);
            var elementWidth:Number = layoutElement.getLayoutBoundsWidth();
            var elementHeight:Number = layoutElement.getLayoutBoundsHeight();

            var childX:Number = NaN;
            var childY:Number = NaN;
            
            // Horizontal position
            if (!isNaN(hCenter))
                childX = Math.round((unscaledWidth - elementWidth) / 2 + hCenter);
            else if (!isNaN(left))
                childX = left;
            else if (!isNaN(right))
                childX = unscaledWidth - elementWidth - right;
            else
                childX = layoutElement.getLayoutBoundsX();

            // Vertical position
            if (!isNaN(vCenter))
                childY = Math.round((unscaledHeight - elementHeight) / 2 + vCenter);
            //else if (!isNaN(baseline))
            //    childY = Math.round(baseline - IVisualElement(layoutElement).baselinePosition);
            else if (!isNaN(top))
                childY = top;
            else if (!isNaN(bottom))
                childY = unscaledHeight - elementHeight - bottom;
            else
                childY = layoutElement.getLayoutBoundsY();

            // Set position
            layoutElement.setLayoutBoundsPosition(childX, childY);

            // update content limits
            maxX = Math.max(maxX, childX + elementWidth);
            maxY = Math.max(maxY, childY + elementHeight);
        }

        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        layoutTarget.setContentSize(Math.ceil(maxX), Math.ceil(maxY));
    }
}

}
