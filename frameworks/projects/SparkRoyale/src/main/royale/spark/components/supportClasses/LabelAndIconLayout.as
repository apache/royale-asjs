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
    
import mx.core.ILayoutElement;

import spark.components.IconPlacement;
import spark.components.supportClasses.GroupBase;
import spark.core.IDisplayText;
import spark.layouts.supportClasses.LayoutBase;
import spark.layouts.supportClasses.LayoutElementHelper;

[ExcludeClass]

/**
 *  Helper layout to layout a label relative to a sibling element.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4.5
 */
public class LabelAndIconLayout extends LayoutBase
{        
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
    public function LabelAndIconLayout():void
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */  
    private var labelElement:ILayoutElement;
    
    /**
     * @private
     */  
    private var iconElement:ILayoutElement;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  gap
    //----------------------------------
    
    private var _gap:int = 6;
    
    [Inspectable(category="General")]
    
    /**
     *  The horizontal space between layout elements, in pixels.
     * 
     *  Note that the gap is only applied between layout elements, so if there's
     *  just one element, the gap has no effect on the layout.
     * 
     *  @default 6
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
        invalidateTargetSizeAndDisplayList();
    }
    
    //----------------------------------
    //  iconPlacement
    //----------------------------------
    
    private var _iconPlacement:String = IconPlacement.LEFT;
    
    [Inspectable(category="General")]
    
    /**
     *  Position of icon relative to label.
     * 
     *  @default IconPlacement.LEFT
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get iconPlacement():String
    {
        return _iconPlacement;
    }
    
    /**
     *  @private
     */
    public function set iconPlacement(value:String):void
    {
        if (_iconPlacement == value)
            return;
        
        _iconPlacement = value;
        invalidateTargetSizeAndDisplayList();
    }  
    
    //----------------------------------
    //  paddingLeft
    //----------------------------------
    
    private var _paddingLeft:Number = 0;
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's left edge
     *  and the left edge of the first layout element.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingLeft():Number
    {
        return _paddingLeft;
    }
    
    /**
     *  @private
     */
    public function set paddingLeft(value:Number):void
    {
        if (_paddingLeft == value)
            return;
        
        _paddingLeft = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingRight
    //----------------------------------
    
    private var _paddingRight:Number = 0;
    
    [Inspectable(category="General")]
    
    /**
     *  Number of pixels between the container's right edge
     *  and the right edge of the last layout element.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingRight():Number
    {
        return _paddingRight;
    }
    
    /**
     *  @private
     */
    public function set paddingRight(value:Number):void
    {
        if (_paddingRight == value)
            return;
        
        _paddingRight = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingTop
    //----------------------------------
    
    private var _paddingTop:Number = 0;
    
    [Inspectable(category="General")]
    
    /**
     *  The minimum number of pixels between the container's top edge and
     *  the top of all the container's layout elements. 
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingTop():Number
    {
        return _paddingTop;
    }
    
    /**
     *  @private
     */
    public function set paddingTop(value:Number):void
    {
        if (_paddingTop == value)
            return;
        
        _paddingTop = value;
        invalidateTargetSizeAndDisplayList();
    }    
    
    //----------------------------------
    //  paddingBottom
    //----------------------------------
    
    private var _paddingBottom:Number = 0;
    
    [Inspectable(category="General")]
    
    /**
     *  The minimum number of pixels between the container's bottom edge and
     *  the bottom of all the container's layout elements. 
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get paddingBottom():Number
    {
        return _paddingBottom;
    }
    
    /**
     *  @private
     */
    public function set paddingBottom(value:Number):void
    {
        if (_paddingBottom == value)
            return;
        
        _paddingBottom = value;
        invalidateTargetSizeAndDisplayList();
    }
    
    //--------------------------------------------------------------------------
    //
    //  LayoutBase methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     */
    override public function measure():void
    {
        super.measure();
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;
        
        var width:Number = _paddingLeft + _paddingRight;
        var height:Number = _paddingTop + _paddingBottom;

        var horizontal:Boolean = 
            iconPlacement == IconPlacement.LEFT ||
            iconPlacement == IconPlacement.RIGHT;

        assignLayoutElements();
        
        var iconHeight:Number = iconElement ? iconElement.getPreferredBoundsHeight() : 0;
        var iconWidth:Number = iconElement ? iconElement.getPreferredBoundsWidth() : 0;
        
        var labelWidth:Number = labelElement && IDisplayText(labelElement).text ? 
            labelElement.getPreferredBoundsWidth() : 0;
        var labelHeight:Number = labelElement && IDisplayText(labelElement).text ? 
            labelElement.getPreferredBoundsHeight() : 0;
        
        if (horizontal)
        {
            width += labelWidth + iconWidth;
            if (labelWidth && iconWidth)
                width += _gap;
            height += Math.max(labelHeight, iconHeight);
        }
        else
        {
            width += Math.max(labelWidth, iconWidth);
            height += labelHeight + iconHeight;
            if (labelHeight && iconHeight)
                height += _gap;
        }
        
        layoutTarget.measuredWidth = Math.ceil(width);
        layoutTarget.measuredHeight = Math.ceil(height);
    }
        
    /**
     *  @private 
     */
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return;
        
        var width:Number = _paddingLeft + _paddingRight;
        var height:Number = _paddingTop + _paddingBottom;
        
        var gap:Number;
        
        var horizontal:Boolean = 
            iconPlacement == IconPlacement.LEFT ||
            iconPlacement == IconPlacement.RIGHT;

        assignLayoutElements();
        
        var iconHeight:Number = iconElement ? iconElement.getPreferredBoundsHeight() : 0;
        var iconWidth:Number = iconElement ? iconElement.getPreferredBoundsWidth() : 0;
        
        var validLabel:Boolean = labelElement && IDisplayText(labelElement).text;
        
        var labelWidth:Number = validLabel ?  labelElement.getPreferredBoundsWidth() : 0;
        var labelHeight:Number = validLabel ? labelElement.getPreferredBoundsHeight() : 0;
        var labelVerticalCenter:Number = validLabel ? 
            LayoutElementHelper.parseConstraintValue(labelElement.verticalCenter) : 0;
        
        var labelX:Number = 0;
        var labelY:Number = 0;
        var iconX:Number = 0;
        var iconY:Number = 0;
        
        var viewWidth:Number = unscaledWidth - _paddingLeft - _paddingRight;
        var viewHeight:Number = unscaledHeight - _paddingTop - _paddingBottom;
        
        if (horizontal)
        {
           gap = (iconWidth && labelWidth) ? _gap : 0;
           
           if (labelWidth > 0)
           {
               labelWidth = Math.max(Math.min(viewWidth - iconWidth - gap, labelWidth), 0);
           }
           labelHeight = Math.min(unscaledHeight, labelHeight);
           
           labelX = ((viewWidth - labelWidth - iconWidth - gap) / 2) + paddingLeft;
           
           if (iconPlacement == IconPlacement.LEFT)
           {
               labelX += iconWidth + gap;
               iconX = labelX - (iconWidth + gap);
           }
           else
           {
               iconX = labelX + labelWidth + gap;
           }
           
           // Collapse padding as necessary if we're lacking the space.
           if ((_paddingLeft + _paddingRight + iconWidth) > unscaledWidth)
               iconX = (unscaledWidth/2 - iconWidth/2);
           
           iconY = ((viewHeight - iconHeight)/2) + _paddingTop;
           labelY = ((viewHeight - labelHeight)/2) + 
               _paddingTop + labelVerticalCenter;
        }
        else
        {
            gap = (iconHeight && labelHeight) ? _gap : 0;
            
            if (labelWidth > 0)
            {
                labelWidth = Math.max(viewWidth, 0);
                labelHeight = Math.min(viewHeight - iconHeight - gap, labelHeight);
            }
            
            labelX = _paddingLeft;
            iconX += ((viewWidth - iconWidth) / 2) + _paddingLeft;
            
            if (iconPlacement == IconPlacement.BOTTOM)
            {
                labelY += ((viewHeight - labelHeight - iconHeight - gap)/2) + 
                    labelVerticalCenter + _paddingTop;
                iconY += labelY + labelHeight + gap;
            }
            else
            {
                iconY = ((viewHeight - labelHeight- iconHeight - gap)/2) + _paddingTop;
                labelY += iconY + iconHeight + gap + labelVerticalCenter;
            }
            
            // Collapse padding as necessary if we're lacking the space.
            if ((_paddingTop + _paddingBottom + iconHeight) > unscaledHeight)
                iconY = (unscaledHeight/2 - iconHeight/2);

        }

        if (labelElement)
        {
            labelElement.setLayoutBoundsSize(labelWidth, labelHeight);
            labelElement.setLayoutBoundsPosition(Math.ceil(labelX), Math.ceil(labelY));
        }
        
        if (iconElement)
        {
            iconElement.setLayoutBoundsSize(iconWidth, iconHeight);
            iconElement.setLayoutBoundsPosition(Math.ceil(iconX), Math.ceil(iconY));
        }

        // Make sure that if the content spans partially over a pixel to the right/bottom,
        // the content size includes the whole pixel.
        layoutTarget.setContentSize(
            Math.ceil(Math.max(unscaledWidth, Math.max(iconWidth, labelWidth))), 
            Math.ceil(Math.max(unscaledHeight, Math.max(iconHeight, labelHeight)))
            );
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     *  Convenience function for subclasses that invalidates the
     *  target's size and displayList so that both layout's <code>measure()</code>
     *  and <code>updateDisplayList</code> methods get called.
     * 
     *  <p>Typically a layout invalidates the target's size and display list so that
     *  it gets a chance to recalculate the target's default size and also size and
     *  position the target's elements. For example changing the <code>gap</code>
     *  property on a <code>VerticalLayout</code> will internally call this method
     *  to ensure that the elements are re-arranged with the new setting and the
     *  target's default size is recomputed.</p> 
     */
    private function invalidateTargetSizeAndDisplayList():void
    {
        var g:GroupBase = target;
        if (!g)
            return;
        
        g.invalidateSize();
        g.invalidateDisplayList();
    }
    
    /**
     *  @private 
     *  Determine which is our label and which is its sibling.
     *  Technically we're expecting at most two elements here
     *  but its not fatal if there are more, though one may obtain 
     *  unexpected results. 
     */ 
    private function assignLayoutElements():void
    {
        for (var i:int = 0; i < target.numElements; i++)
        {
            var layoutElement:ILayoutElement = target.getElementAt(i) as ILayoutElement;
            if (!layoutElement || !layoutElement.includeInLayout)
                continue;
            
            if (layoutElement is IDisplayText)
                labelElement = layoutElement;
            else
                iconElement = layoutElement;
        }
    }
}
    
}
