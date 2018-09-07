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
package
{

import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

import mx.core.ILayoutElement;
import mx.core.IVisualElement;

import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.supportClasses.LayoutBase;

public class WheelLayout extends LayoutBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function WheelLayout()
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

    private var _gap:Number = 0;

    /**
     *  The gap between the items
     */
    public function get gap():Number
    {
        return _gap;
    }
    
    public function set gap(value:Number):void
    {
        _gap = value;
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
        {
            layoutTarget.invalidateSize();
            layoutTarget.invalidateDisplayList();
        }
    }
    
    //----------------------------------
    //  axisAngle
    //----------------------------------

    /**
     *  @private  
     *  The total width of all items, including gap space.
     */
    private var _totalWidth:Number;

    /**
     *  @private  
     *  Cache which item is currently in view, to facilitate scrollposition delta calculations
     */
    private var _centeredItemIndex:int = 0;
    private var _centeredItemCircumferenceBegin:Number = 0;
    private var _centeredItemCircumferenceEnd:Number = 0;
    private var _centeredItemDegrees:Number = 0;

    /**
     *  The axis to tilt the 3D wheel 
     */
    private var _axis:Vector3D = new Vector3D(0, 1, 0.1);
    
    /**
     *  The angle to tilt the axis of the wheel
     */
    public function set axisAngle(value:Number):void
    {
        _axis = new Vector3D(0, Math.cos(Math.PI * value /180), Math.sin(Math.PI * value /180));
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
        {
            layoutTarget.invalidateSize();
            layoutTarget.invalidateDisplayList();
        }
    }
    
    /**
     *  @private 
     *  Given the radius of the sphere, return the radius of the
     *  projected sphere. Uses the projection matrix of the
     *  layout target to calculate.
     */    
    private function projectSphere(radius:Number, radius1:Number):Number
    {
        var fl:Number = target.transform.perspectiveProjection.focalLength;
        var alpha:Number = Math.asin( radius1 / (radius + fl) );
        return fl * Math.tan(alpha) * 2;
    }
    
    /**
     *  @private
     *  Given the totalWidth, maxHeight and maxHalfWidthDiagonal, calculate the bounds of the items
     *  on screen.  Uses the projection matrix of the layout target to calculate. 
     */
    private function projectBounds(totalWidth:Number, maxWidth:Number, maxHeight:Number, maxHalfWidthDiagonal:Number):Point
    {
        // Use the the total width as a circumference of an imaginary circle which we will use to
        // align the items in 3D:
        var radius:Number = _totalWidth * 0.5 / Math.PI;
        
        // Now since we are going to arrange all the items along circle, middle of the item being the tangent point,
        // we need to calculate the minimum bounding circle. It is easily calculated from the maximum width item:
        var boundingRadius:Number = Math.sqrt(radius * radius + 0.25 * maxWidth * maxWidth);
                                      
        var projectedBoundsW:Number = _axis.z * _axis.z * (maxHalfWidthDiagonal + 2 * radius) + 
                                      projectSphere(radius, boundingRadius ) * _axis.y * _axis.y;
                                      
        var projectedBoundsH:Number = Math.abs(_axis.z) * (maxHalfWidthDiagonal + 2 * radius) +
                                      maxHeight * _axis.y * _axis.y;
                                      
        return new Point(projectedBoundsW + 10, projectedBoundsH + 10);
    }

    /**
     *  @private 
     *  Iterates through all the items, calculates the projected bounds on screen, updates _totalWidth member variable.
     */    
    private function calculateBounds():Point
    {
        // Calculate total width:
        _totalWidth = 0;
     
        var maxHeight:Number = 0;
        var maxWidth:Number = 0;
        var maxD:Number = 0;
   
        // Add up all the widths
        var iter:LayoutIterator = new LayoutIterator(target);
        var el:ILayoutElement;
        while (el = iter.nextElement())
        {
            var preferredWidth:Number = el.getPreferredBoundsWidth(false /*postTransform*/);
            var preferredHeight:Number = el.getPreferredBoundsHeight(false /*postTransform*/);

            // Add up item width
            _totalWidth += preferredWidth;
            
            // Max up item size
            maxWidth = Math.max(maxWidth, preferredWidth);
            maxHeight = Math.max(maxHeight, preferredHeight);
            
            maxD = Math.max(maxD, Math.sqrt(preferredWidth * preferredWidth / 4 + 
                                            preferredHeight * preferredHeight));    
        }
        
        // Add up the gap
        _totalWidth += gap * iter.numVisited;

        // Project        
        return projectBounds(_totalWidth, maxWidth, maxHeight, maxD);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: LayoutBase
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    override public function set target(value:GroupBase):void
    {
        // Make sure that if layout is swapped out, we clean up
        if (!value && target)
        {
            target.maintainProjectionCenter = false;

            var iter:LayoutIterator = new LayoutIterator(target);
            var el:ILayoutElement;
            while (el = iter.nextElement())
            {
                el.setLayoutMatrix(new Matrix(), false /*triggerLayout*/);
            }
        }
        
        super.target = value;

        // Make sure we turn on projection the first time the layout
        // gets assigned to the group
        if (target)
            target.maintainProjectionCenter = true;
    }
    
    override public function measure():void
    {
        var bounds:Point = calculateBounds();
        
        target.measuredWidth = bounds.x;
        target.measuredHeight = bounds.y;
    }
    
    override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // Get the bounds, this will also update _totalWidth
        var bounds:Point = calculateBounds();

        // Update the content size
        target.setContentSize(_totalWidth + unscaledWidth, bounds.y); 
        var radius:Number = _totalWidth * 0.5 / Math.PI;
        var gap:Number = this.gap;
        _centeredItemDegrees = Number.MAX_VALUE;
        
        var scrollPosition:Number = target.horizontalScrollPosition;
        var totalWidthSoFar:Number = 0;
        // Subtract the half width of the first element from totalWidthSoFar: 
        var iter:LayoutIterator = new LayoutIterator(target);
        var el:ILayoutElement = iter.nextElement();
        if (!el)
            return;
        totalWidthSoFar -= el.getPreferredBoundsWidth(false /*postTransform*/) / 2;
        
        // Set the 3D Matrix for all the elements:
        iter.reset();
        while (el = iter.nextElement())
        { 
            // Size the item, no need to position it, since we'd set the computed matrix
            // which defines the position.
            el.setLayoutBoundsSize(NaN, NaN, false /*postTransform*/);
            var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
            var elementHeight:Number = el.getLayoutBoundsHeight(false /*postTransform*/); 
            var degrees:Number = 360 * (totalWidthSoFar + elementWidth/2 - scrollPosition) / _totalWidth; 

            // Remember which item is centered, this is used during scrolling
            var curDegrees:Number = degrees % 360;
            if (Math.abs(curDegrees) < Math.abs(_centeredItemDegrees))
            {
                _centeredItemDegrees = curDegrees;
                _centeredItemIndex = iter.curIndex;
                _centeredItemCircumferenceBegin = totalWidthSoFar - gap;
                _centeredItemCircumferenceEnd = totalWidthSoFar + elementWidth + gap;
            }

            // Calculate and set the 3D Matrix 
            var m:Matrix3D = new Matrix3D();
            m.appendTranslation(-elementWidth/2, -elementHeight/2 + radius * _axis.z, -radius * _axis.y );
            m.appendRotation(-degrees, _axis);
            m.appendTranslation(unscaledWidth/2, unscaledHeight/2, radius * _axis.y);
            el.setLayoutMatrix3D(m, false /*triggerLayout*/);
            
            // Update the layer for a correct z-order
            if (el is IVisualElement)
                IVisualElement(el).depth = Math.abs( Math.floor(180 - Math.abs(degrees % 360)) );

            // Move on to next item
            totalWidthSoFar += elementWidth + gap;
        }
    }
    
    private function scrollPositionFromCenterToNext(next:Boolean):Number
    {
        var iter:LayoutIterator = new LayoutIterator(target, _centeredItemIndex);
        var el:ILayoutElement = next ? iter.nextElementWrapped() : iter.prevElementWrapped();
        if (!el)
            return 0;
        
        var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
        
        var value:Number; 
        if (next)
        {
            if (_centeredItemDegrees > 0.1)
                return (_centeredItemCircumferenceEnd + _centeredItemCircumferenceBegin) / 2;
            
            value = _centeredItemCircumferenceEnd + elementWidth/2;
            if (value > _totalWidth)
                value -= _totalWidth;
        }
        else
        {
            if (_centeredItemDegrees < -0.1)
                return (_centeredItemCircumferenceEnd + _centeredItemCircumferenceBegin) / 2;

            value = _centeredItemCircumferenceBegin - elementWidth/2;
            if (value < 0)
                value += _totalWidth;
        }
        return value;     
    }
    
    override protected function scrollPositionChanged():void
    {
        if (target)
            target.invalidateDisplayList();
    }

    override public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
    {
        var g:GroupBase = target;
        if (!g || g.numElements == 0)
            return 0;
            
        var value:Number;     

        switch (navigationUnit)
        {
            case NavigationUnit.LEFT:
            {
                value = target.horizontalScrollPosition - 30;
                if (value < 0)
                    value += _totalWidth;
                return value - target.horizontalScrollPosition;
            }
                
            case NavigationUnit.RIGHT:
            {
                value = target.horizontalScrollPosition + 30;
                if (value > _totalWidth)
                    value -= _totalWidth;
                return value - target.horizontalScrollPosition;
            }
                
            case NavigationUnit.PAGE_LEFT:
                return scrollPositionFromCenterToNext(false) - target.horizontalScrollPosition;
                
            case NavigationUnit.PAGE_RIGHT:
                return scrollPositionFromCenterToNext(true) - target.horizontalScrollPosition;
                
            case NavigationUnit.HOME: 
                return 0;
                
            case NavigationUnit.END: 
                return _totalWidth;
                
            default:
                return 0;
        }       
    }
    
    /**
     *  @private
     */ 
    override public function getScrollPositionDeltaToElement(index:int):Point
    {
        var layoutTarget:GroupBase = target;
        if (!layoutTarget)
            return null;
       
        var gap:Number = this.gap;     
        var totalWidthSoFar:Number = 0;
        var iter:LayoutIterator = new LayoutIterator(layoutTarget);

        var el:ILayoutElement = iter.nextElement();
        if (!el)
            return null;
        totalWidthSoFar -= el.getLayoutBoundsWidth(false /*postTransform*/) / 2;

        iter.reset();
        while (null != (el = iter.nextElement()) && iter.curIndex <= index)
        {    
            var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
            totalWidthSoFar += gap + elementWidth;
        }
        return new Point(totalWidthSoFar - elementWidth / 2 -gap - layoutTarget.horizontalScrollPosition, 0);
    }

    /**
     *  @private
     */ 
    override public function updateScrollRect(w:Number, h:Number):void
    {
        var g:GroupBase = target;
        if (!g)
            return;
            
        if (clipAndEnableScrolling)
        {
            // Since scroll position is reflected in our 3D calculations,
            // always set the top-left of the srcollRect to (0,0).
            g.scrollRect = new Rectangle(0, verticalScrollPosition, w, h);
        }
        else
            g.scrollRect = null;
    } 
}
}

import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
    
class LayoutIterator 
{
    private var _curIndex:int;
    private var _numVisited:int = 0;
    private var totalElements:int;
    private var _target:GroupBase;
    private var _loopIndex:int = -1;
	private var _useVirtual:Boolean;

    public function get curIndex():int
    {
        return _curIndex;
    }

    public function LayoutIterator(target:GroupBase, index:int=-1):void
    {
        totalElements = target.numElements;
        _target = target;
        _curIndex = index;
		_useVirtual = _target.layout.useVirtualLayout;
    }

    public function nextElement():ILayoutElement
    {
        while (_curIndex < totalElements - 1)
        {
            var el:ILayoutElement = _useVirtual ? _target.getVirtualElementAt(++_curIndex) :
										 		  _target.getElementAt(++_curIndex);
            if (el && el.includeInLayout)
            {
                ++_numVisited;
                return el;
            }
        }
        return null;
    }
    
    public function prevElement():ILayoutElement
    {
        while (_curIndex > 0)
        {
            var el:ILayoutElement = _useVirtual ? _target.getVirtualElementAt(--_curIndex) :
												  _target.getElementAt(--_curIndex);
            if (el && el.includeInLayout)
            {
                ++_numVisited;
                return el;
            }
        }
        return null;
    }

    public function nextElementWrapped():ILayoutElement
    {
        if (_loopIndex == -1)
            _loopIndex = _curIndex;
        else if (_loopIndex == _curIndex)
            return null;

        var el:ILayoutElement = nextElement();
        if (el)
            return el;
        else if (_curIndex == totalElements - 1)
            _curIndex = -1;
        return nextElement();
    }
    
    public function prevElementWrapped():ILayoutElement
    {
        if (_loopIndex == -1)
            _loopIndex = _curIndex;
        else if (_loopIndex == _curIndex)
            return null;

        var el:ILayoutElement = prevElement();
        if (el)
            return el;
        else if (_curIndex == 0)
            _curIndex = totalElements;
        return prevElement();
    }

    public function reset():void
    {
        _curIndex = -1;
        _numVisited = 0;
        _loopIndex = -1;
    }

    public function get numVisited():int
    {
        return _numVisited;
    }
}
    
