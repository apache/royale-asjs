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

package spark.primitives
{/* 

import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent;
import mx.utils.MatrixUtil;

import spark.primitives.supportClasses.FilledElement;
 */
import mx.core.mx_internal;

import mx.graphics.IStroke;
import mx.graphics.IFill;

import org.apache.royale.events.EventDispatcher;
use namespace mx_internal;
/**
 *  The Path class is a filled graphic element that draws a series of path segments.
 *  In vector graphics, a path is a series of points connected by straight or curved line segments. 
 *  Together the lines form an image. In Flex, you use the Path class to define a complex vector shape 
 *  constructed from a set of line segments. 
 * 
 *  <p>Typically, the first element of a path definition is a Move segment to specify the starting pen 
 *  position of the graphic. You then use the Line, CubicBezier and QuadraticBezier segments to  
 *  draw the lines of the graphic. When using these classes, you only specify the x and y coordinates 
 *  of the end point of the line; the x and y coordinate of the starting point is defined by the current 
 *  pen position.</p>
 *  
 *  <p>After drawing a line segment, the current pen position becomes the x and y coordinates of the end 
 *  point of the line. You can use multiple Move segments in the path definition to 
 *  reposition the pen.</p>
 *  
 *  <p>The syntax used by the Path class to define the shape is the same as the SVG path syntax, 
 *  which makes it easy to convert SVG paths to Flex paths.</p>
 *  
 *  @includeExample examples/ArrowExample.mxml
 *    
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class Path extends EventDispatcher
{//extends FilledElement
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function Path()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Dirty flag to indicate when path data has changed. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    //private var graphicsPathChanged:Boolean = true;
    
    /**
     *  Private data structure to hold the parsed 
     *  path segment information  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */ 
    //private var segments:PathSegmentsCollection;
    
    /**
     *  A GraphicsPath object that contains the drawing 
     *  commands to draw this Path.  
     *  
     *  The data commands expressed in a Path's <code>data</code> 
     *  property are translated into drawing commands and 
     *  coordinate parameters for those commands, and then
     *  drawn to screen. 
     */ 
    //mx_internal var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  data
    //----------------------------------
    
    private var _data:String;
    
    [Inspectable(category="General")]
    
    /**
     *  A string containing a compact represention of the path segments. This is an alternate
     *  way of setting the segments property. Setting this property overrides any values
     *  stored in the segments array property.
     *
     *  <p>The value is a space-delimited string describing each path segment. Each
     *  segment entry has a single character which denotes the segment type and
     *  two or more segment parameters.</p>
     * 
     *  <p>If the segment command is upper-case, the parameters are absolute values.
     *  If the segment command is lower-case, the parameters are relative values.</p>
     *
     *  <p>The following table shows the syntax for the segments:
     *  
     *  
     *  <table class="innertable">
     *    <tr>
     *      <th>Segment Type</th>
     *      <th>Command</th>
     *      <th>Parameters</th>
     *      <th>Example</th>
     *    </tr>
     *    <tr>
     *      <td>Move</td>
     *      <td>M/m</td>
     *      <td>x y</td>
     *      <td><code>M 10 20</code> - Move line to 10, 20.</td>
     *    </tr>
     *    <tr>
     *      <td>Line</td>
     *      <td>L/l</td>
     *      <td>x y</td>
     *      <td><code>L 50 30</code> - Line to 50, 30.</td>
     *    </tr>
     *    <tr>
     *      <td>Horizontal line</td>
     *      <td>H/h</td>
     *      <td>x</td>
     *      <td><code>H 40</code> = Horizontal line to 40.</td>
     *    </tr>
     *    <tr>
     *      <td>Vertical line</td>
     *      <td>V/v</td>
     *      <td>y</td>
     *      <td><code>V 100</code> - Vertical line to 100.</td>
     *    </tr>
     *    <tr>
     *      <td>QuadraticBezier</td>
     *      <td>Q/q</td>
     *      <td>controlX controlY x y</td>
     *      <td><code>Q 110 45 90 30</code> - Curve to 90, 30 with the control point at 110, 45.</td>
     *    </tr>
     *    <tr>
     *      <td>CubicBezier</td>
     *      <td>C/c</td>
     *      <td>control1X control1Y control2X control2Y x y</td>
     *      <td><code>C 45 50 20 30 10 20</code> - Curve to 10, 20 with the first control point at 45, 50 and the second control point at 20, 30.</td>
     *    </tr>
     *    <tr>
     *      <td>Close path</td>
     *      <td>Z/z</td>
     *      <td>n/a</td>
     *      <td>Closes off the path.</td>
     *    </tr>
     *  </table>
     *  </p>
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function set data(value:String):void
    {
        if (_data == value)
            return;
        
        /* segments = new PathSegmentsCollection(value);
        
        graphicsPathChanged = true;
        
        // Clear our cached measurement and data values
        clearCachedBoundingBoxWithStroke();
        invalidateSize();
        invalidateDisplayList(); */
        
        _data = value;
    }
    
    /** 
     *  @private
     */
    public function get data():String 
    {
        return _data;
    }
    
    //----------------------------------
    //  winding
    //----------------------------------
    
    //private var _winding:String = "evenOdd";
    
    /**
     *  Fill rule for intersecting or overlapping path segments. 
     *  Possible values are <code>GraphicsPathWinding.EVEN_ODD</code> or <code>GraphicsPathWinding.NON_ZERO</code>.
     *
     *  @default evenOdd
     *  
     *  @see flash.display.GraphicsPathWinding 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function set winding(value:String):void
    {
        if (_winding != value)
        {
            _winding = value;
            graphicsPathChanged = true;
            invalidateDisplayList();
        } 
    } */
    
    /** 
     *  @private
     */
    /* public function get winding():String 
    {
        return _winding; 
    } */
    
    //----------------------------------
    //  bounds
    //----------------------------------
    
    /* private function getBounds():Rectangle
    {
        return segments ? segments.getBounds() : new Rectangle();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function measure():void
    {
        var bounds:Rectangle = getBounds();
        measuredWidth = bounds.width;
        measuredHeight = bounds.height;
        measuredX = bounds.left;
        measuredY = bounds.top;
    } */
    
    /**
     *  @private
     *  Storage for the cached bounding box for particular transformation and size.
     *  We are also caching the bounding box original x & y, so that we can reuse it
     *  when bounds are requested with same size and transform that only differs by offsets. 
     */
    /* private var _boundingBoxCached:Rectangle;
    private var _boundingBoxMatrixCached:Matrix;
    private var _boundingBoxWidthParamCached:Number;
    private var _boundingBoxHeightParamCached:Number;
    private var _boundingBoxX:Number;
    private var _boundingBoxY:Number; */
    
    /**
     *  @private
     *  Returns the bounding box for the path including stroke, if the path is resized
     *  to the specified size and transformed with "m". 
     *  Pass null for "m" to specify identity matrix.
     *
     *  Calling this method multiple times with the same parameters, or differences
     *  only in the matrix offset is fast, as it returns the cached bounding box.
     * 
     *  Don't modify directly the return value!
     */
    /* private function getBoundingBoxWithStroke(width:Number, height:Number, m:Matrix):Rectangle
    {
        if (_boundingBoxCached && 
            _boundingBoxWidthParamCached == width && 
            _boundingBoxHeightParamCached == height)
        {
            // Compare matrices:
            if (!m && !_boundingBoxMatrixCached)
            {
                _boundingBoxCached.x = _boundingBoxX;
                _boundingBoxCached.y = _boundingBoxY;
                return _boundingBoxCached;
            }
            else if (m && _boundingBoxMatrixCached &&
                m.a == _boundingBoxMatrixCached.a &&
                m.b == _boundingBoxMatrixCached.b &&
                m.c == _boundingBoxMatrixCached.c &&
                m.d == _boundingBoxMatrixCached.d)
            {
                _boundingBoxCached.x = _boundingBoxX + m.tx;
                _boundingBoxCached.y = _boundingBoxY + m.ty;
                return _boundingBoxCached;
            }
        }
        
        // Setup the matrix, ignore tx & ty, we'll account for it later
        if (m)
        {
            _boundingBoxMatrixCached = m.clone();
            _boundingBoxMatrixCached.tx = 0;
            _boundingBoxMatrixCached.ty = 0;
        }
        else
            _boundingBoxMatrixCached = null;
        
        // Remember width and height
        _boundingBoxWidthParamCached = width;
        _boundingBoxHeightParamCached = height;
        
        _boundingBoxCached = computeBoundsWithStroke(_boundingBoxWidthParamCached,
            _boundingBoxHeightParamCached,
            m);
        
        // Remember the original x & y:
        _boundingBoxX = _boundingBoxCached.x - (m ? m.tx : 0);
        _boundingBoxY = _boundingBoxCached.y - (m ? m.ty : 0);
        
        return _boundingBoxCached; // No need to return clone, as this is for internal use only
    } */
    
    /**
     *  @private
     *  Static storage for intermediate calculations while calculating miter-limit bounds. 
     */
    //static private var tangent:Point = new Point();
    
    /**
     *  @private
     *  Returns true when we have a valid tangent for curSegment. Pass prevSegment
     *  to know what the starting point of curSegment is.
     */
    /* private function tangentIsValid(prevSegment:PathSegment, curSegment:PathSegment,
                                    sx:Number, sy:Number, m:Matrix):Boolean
    {
        // TODO (egeorgie): optimize, we don't need to compute the tangent,
        // but just make sure the segment is not collapsed into a single point?
        
        // Check the start tangent only. If it's valid,
        // then there is a valid end tangent as well.
        curSegment.getTangent(prevSegment, true, sx, sy, m, tangent);
        return (tangent.x != 0 || tangent.y != 0);
    } */
    
    /**
     *  @private
     *  @return Returns the axis aligned bounding box of the path when
     *  resized to (width, height) and then transformed by matrix m.
     */
    /* mx_internal function computeBoundsWithStroke(width:Number,
                                                 height:Number,
                                                 m:Matrix):Rectangle
    {
        var naturalBounds:Rectangle = getBounds();
        var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
        var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
        
        // First, figure out the bounding box without stroke
        var pathBBox:Rectangle;
        // Special case, if there's no transformation or only offset,
        // then the non-stroked path bounds for the give size can be
        // scaled from the pre-transform natural bounds:
        if (!m || MatrixUtil.isDeltaIdentity(m) || !this.segments)
        {
            pathBBox = new Rectangle(naturalBounds.x * sx,
                naturalBounds.y * sy,
                naturalBounds.width * sx,
                naturalBounds.height * sy);
            if (m)
                pathBBox.offset(m.tx, m.ty);
        }
        else
        {
            pathBBox = this.segments.getBoundingBox(width, height, m);
        }
        
        // Do we have stroke? 
        var strokeSettings:IStroke = this.stroke;
        if (!strokeSettings || !this.segments)
            return pathBBox;
        
        // Always add half the stroke weight, even for miter limit paths,
        // as a point on a curve and not necessarily a joint tip could be
        // an extreme that pushes the bounds.
        var strokeExtents:Rectangle = getStrokeExtents();
        pathBBox.inflate(strokeExtents.right, strokeExtents.bottom);
        
        var seg:Vector.<PathSegment> = segments.data;
        
        if (strokeSettings.joints != "miter" || seg.length < 2)
        {
            // TODO (egeorgie): Will overshoot for "bevel"
            // by the assumed roundness of the joints.
            return pathBBox;
        }
        
        // Use strokeExtents to get the transformed stroke weight.
        var halfWeight:Number = strokeExtents.width / 2;
        
        // Miter limit is always at least 1
        var miterLimit:Number = Math.max(1, strokeSettings.miterLimit);
        var count:int = seg.length;
        var start:int = 0;
        var end:int;
        var lastMoveX:Number = 0;
        var lastMoveY:Number = 0;
        var lastOpenSegment:int = 0;
        
        while (true)
        {
            // Find a segment with a valid tangent or stop at a MoveSegment
            while (start < count && !(seg[start] is MoveSegment))
            {
                var prevSegment:PathSegment = start > 0 ? seg[start - 1] : null;
                if (tangentIsValid(prevSegment, seg[start], sx, sy, m))
                    break;
                start++;
            }
            
            if (start >= count)
                break; // No more segments with valid tangents
            
            var startSegment:PathSegment = seg[start];
            if (startSegment is MoveSegment)
            {
                // remember the last move segment 
                lastOpenSegment = start + 1;
                lastMoveX = startSegment.x;
                lastMoveY = startSegment.y;
                
                // move onto next segment:
                start++;
                continue;
            }
            
            // Does the current segment close to a previous segment and form a joint with it?
            // Note, even if the segment was originally a close segment, it may not form a joint
            // with the segment it closes to, unless it's followed by a MoveSegment or it's the last
            // segment in the sequence.
            if ((start == count - 1 || seg[start + 1] is MoveSegment) && 
                startSegment.x == lastMoveX &&
                startSegment.y == lastMoveY)
            {
                end = lastOpenSegment;
            }
            else
                end = start + 1;
            
            // Find a segment with a valid tangent or stop at a MoveSegment 
            while (end < count && !(seg[end] is MoveSegment))
            {
                if (tangentIsValid(startSegment, seg[end], sx, sy, m))
                    break;
                end++;
            }
            
            if (end >= count)
                break; // No more segments with valid tangents
            
            var endSegment:PathSegment = seg[end];
            
            if (!(endSegment is MoveSegment))
            {
                addMiterLimitStrokeToBounds(start > 0 ? seg[start - 1] : null, 
                    startSegment,
                    endSegment, 
                    miterLimit,
                    halfWeight,
                    sx,
                    sy,
                    m,
                    pathBBox);
            }
            
            // Move on to the next segment, but never go back. End could be less
            // than start, because of implicit/explicit CloseSegments.
            start = start > end ? start + 1 : end;
        }
        return pathBBox;
    } */
    
    /**
     *  @private
     *  Returns the bounds of the element, including stroke in local coordinates.
     */  
    /* override protected function getStrokeBounds():Rectangle
    {
        return getBoundingBoxWithStroke(width, height, null);
    } */
    
    /**
     *  @private 
     */
    /* override protected function get needsDisplayObject():Boolean
    {
        // Rendering with miter limit into the same DisplayObject will cause the
        // slow code-path Player execution for all graphics in that DisplayObject.
        // Make sure that we don't share the DisplayObject with other elements when 
        // we have stroke with miter joints.
        return super.needsDisplayObject || (stroke && stroke.joints == "miter");
    } */
    
    /**
     *  @private
     *  Calculates the miter stroke contribution to the "result" bounding box.
     *  
     *  @param segment0 The segment before the first segment of the joint.
     *  @param segment1 The first segment of the joint.
     *  @param segment2 The second segment of the joint.
     * 
     *  @param miterLimit The miter limit. It must be at least 1. 
     * 
     *  @param weight The transformed stroke weight (the outside part only,
     *  if stroke is centered, this must be weight/2).
     * 
     *  @param sx The pre-transform horizontal scale factor for the segments.
     *  @param sy The pre-transform vertical scale factor for the segments.
     * 
     *  @param m The transformation for the segments.
     * 
     *  @param result The bounding box to be accumulating the bounds.
     */    
    /* private function addMiterLimitStrokeToBounds(segment0:PathSegment,
                                                 segment1:PathSegment,
                                                 segment2:PathSegment,
                                                 miterLimit:Number,
                                                 weight:Number,
                                                 sx:Number,
                                                 sy:Number,
                                                 m:Matrix,
                                                 result:Rectangle):void
    {
        // The tip of the joint
        var pt:Point;
        pt = MatrixUtil.transformPoint(segment1.x * sx, segment1.y * sy, m).clone();
        var jointX:Number = pt.x;
        var jointY:Number = pt.y;
        
        // End tangent for segment1:
        var t0:Point = new Point();
        segment1.getTangent(segment0, false /*start*//*, sx, sy, m, t0);
        
        // Start tangent for segment2:
        var t1:Point = new Point();
        segment2.getTangent(segment1, true /*start*//*, sx, sy, m, t1);
        
        // Valid tangents?
        if (t0.length == 0 || t1.length == 0)
            return;
        
        // The tip of the stroke lies on the bisector of the angle and lies at a distance
        // of weight / sin(A/2), where A is the angle between the tangents.
        
        // Quick and dirty way to calculate it, make the tangents unit length:
        t0.normalize(1);
        t0.x = -t0.x;
        t0.y = -t0.y;
        t1.normalize(1);
        
        // Find the vector from t0 to the midPoint from t0 to t1
        var halfT0T1:Point = new Point( (t1.x - t0.x) * 0.5, (t1.y - t0.y) * 0.5);
        
        // sin(A/2) == halfT0T1.length / t1.length()
        var sinHalfAlpha:Number = halfT0T1.length;
        if (Math.abs(sinHalfAlpha) < 1.0E-9)
        {
            // Don't count degenerate joints that are close to 0 degrees so
            // we avoid cases like this one L 0 0  0 50  100 0  30 0 50 0 Z
            return; 
        }
        
        // Find the vector of the bisect
        var bisect:Point = new Point( -0.5 * (t0.x + t1.x), -0.5 * (t0.y + t1.y) );
        if (bisect.length == 0)
        {
            // 180 degrees, nothing to contribute
            return;
        }
        
        // Is there miter limit at play?
        if (sinHalfAlpha == 0 || miterLimit < 1 / sinHalfAlpha)
        {
            // The miter limit is reached. Calculate two extra points that may
            // contribute to the bounds.
            // The points lie on the line perpendicular to the bisect and intersecting
            // it at offset of miterLimit * weight from the joint tip.
            // The points are equally offset from the bisect by a factor of X,
            // where X / sinAlpha == (weight / sinAlpha - miterLimit * weight) / bisect.lenght. 
            
            var bisectLength:Number = bisect.length;
            bisect.normalize(1);
            
            halfT0T1.normalize((weight - miterLimit * weight * sinHalfAlpha) / bisectLength);
            
            var pt0:Point = new Point(jointX + miterLimit * weight * bisect.x + halfT0T1.x,
                jointY + miterLimit * weight * bisect.y + halfT0T1.y);
            
            var pt1:Point = new Point(jointX + miterLimit * weight * bisect.x - halfT0T1.x,
                jointY + miterLimit * weight * bisect.y - halfT0T1.y);
            
            // Add it to the rectangle:
            MatrixUtil.rectUnion(pt0.x, pt0.y, pt0.x, pt0.y, result);
            MatrixUtil.rectUnion(pt1.x, pt1.y, pt1.x, pt1.y, result);
        }
        else
        {
            // miter limit is not reached, add the tip of the stroke
            bisect.normalize(1);
            var strokeTip:Point = new Point(jointX + bisect.x * weight / sinHalfAlpha,
                jointY + bisect.y * weight / sinHalfAlpha);
            
            // Add it to the rectangle:
            MatrixUtil.rectUnion(strokeTip.x, strokeTip.y, strokeTip.x, strokeTip.y, result);
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function transformWidthForLayout(width:Number,
                                                        height:Number,
                                                        postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        // Optimize for no-stroke, no transform
        if (!m && !stroke)
            return width;
        return getBoundingBoxWithStroke(width, height, m).width;
    } */
    
    /**
     *  @private
     */
    /* override protected function transformHeightForLayout(width:Number,
                                                         height:Number,
                                                         postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        // Optimize for no-stroke, no transform
        if (!m && !stroke)
            return height;
        return getBoundingBoxWithStroke(width, height, m).height;
    } */
    
    /**
     *  @private
     *  A helper function to implement the getBoundsXAtSize() and getBoundsYAtSize()
     *  mehtods. Calculates where the top-left corner of the bounds would end up 
     *  if the path is resized to the specified size.
     */
    /* private function getBoundsAtSize(width:Number, height:Number, m:Matrix):Rectangle
    {
        var strokeExtents:Rectangle = null;
        
        if (!isNaN(width))
        {
            strokeExtents = getStrokeExtents(true /*postLayoutTransform*//*);
            width -= strokeExtents.width;
        }
        
        if (!isNaN(height))
        {
            if (!strokeExtents)
                strokeExtents = getStrokeExtents(true /*postLayoutTransform*//*);
            height -= strokeExtents.height;
        }
        
        var newWidth:Number = preferredWidthPreTransform();
        var newHeight:Number = preferredHeightPreTransform();
        
        // Calculate the width and height pre-transform:
        if (m)
        {
            var newSize:Point = MatrixUtil.fitBounds(width,
                height,
                m,
                explicitWidth,
                explicitHeight,
                newWidth,
                newHeight,
                minWidth, minHeight,
                maxWidth, maxHeight);
            
            if (newSize)
            {
                newWidth = newSize.x;
                newHeight = newSize.y;
            }
            else
            {
                newWidth = minWidth;
                newHeight = minHeight;
            }
        }
        
        return getBoundingBoxWithStroke(newWidth, newHeight, m);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        return getBoundsAtSize(width, height, m).x + (m ? 0 : this.x);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        return getBoundsAtSize(width, height, m).y + (m ? 0 : this.y);
    } */
    
    /**
     *  @private
     */
    /* override public function getLayoutBoundsX(postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        // Optimize for no-stroke, no transform
        if (!m && !stroke)
        {
            if (measuredX == 0)
                return this.x;
            var naturalBounds:Rectangle = getBounds();
            var sx:Number = (naturalBounds.width == 0 || _width == 0) ? 1 : _width / naturalBounds.width;
            return this.x + measuredX * sx;
        }
        return getBoundingBoxWithStroke(_width, _height, m).x + (m ? 0 : this.x);
    } */
    
    /**
     *  @private
     */
    /* override public function getLayoutBoundsY(postLayoutTransform:Boolean = true):Number
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        // Optimize for no-stroke, no transform
        if (!m && !stroke)
        {
            if (measuredY == 0)
                return this.y;
            var naturalBounds:Rectangle = getBounds();
            var sy:Number = (naturalBounds.height == 0 || _height == 0) ? 1 : _height / naturalBounds.height;
            return this.y + measuredY * sy;
        }
        return getBoundingBoxWithStroke(_width, _height, m).y + (m ? 0 : this.y);
    } */
    
    /**
     *  @private
     */    
    /* private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix):void
    {
        var size:Point = fitLayoutBoundsIterative(width, height, m);
        
        // We couldn't find a solution, try to relax the constraints
        if (!size && !isNaN(width) && !isNaN(height))
        {
            // Try without width constraint
            var size1:Point = fitLayoutBoundsIterative(NaN, height, m);
            
            // Try without height constraint
            var size2:Point = fitLayoutBoundsIterative(width, NaN, m);
            
            // Ignore solutions that will exceeed the requested size
            if (size1 && getBoundingBoxWithStroke(size1.x, size1.y, m).width > width)
                size1 = null;
            if (size2 && getBoundingBoxWithStroke(size2.x, size2.y, m).height > height)
                size2 = null;
            
            // Which size was better?
            if (size1 && size2)
            {
                // Pick the one closest to the natural bounds ratio:
                //   ?  abs(n.x / n.y - size1.x / size1.y) < abs(n.x / n.y - size2.x / size2.y)
                // <=>  abs((n.x * size1.y - n.y * size1.x) / (n.y * size1.y)) < abs((n.x * size2.y - n.y * size2.x) / (n.y * size2.y))
                // <=>  abs((n.x * size1.y - n.y * size1.x)) / (n.y * size1.y) < abs((n.x * size2.y - n.y * size2.x)) / (n.y * size2.y) 
                // <=>  abs(n.x * size1.y - n.y * size1.x) / size1.y < abs(n.x * size2.y - n.y * size2.x) / size2.y
                // <=>  abs(n.x * size1.y - n.y * size1.x) * size2.y < abs(n.x * size2.y - n.y * size2.x) * size1.y

                var n:Point = getBounds().size;
                var pickSize1:Boolean = Math.abs( n.x * size1.y - n.y * size1.x ) * size2.y < 
                                        Math.abs( n.x * size2.y - n.y * size2.x ) * size1.y;

                if (pickSize1)
                    size = size1;
                else
                    size = size2;
            }
            else if (size1)
            {
                size = size1;
            }
            else
            {
                size = size2;
            }
        }
        
        if (size)
            setActualSize(size.x, size.y);
        else
            setActualSize(minWidth, minHeight);
    } */
    
    /**
     *  Iteratively approach a solution. Returns 0 if no exact solution exists.
     *  NaN values for width/height mean "not constrained" in that dimesion. 
     * 
     *  @private
     */
    /* private function fitLayoutBoundsIterative(width:Number, height:Number, m:Matrix):Point
    {
        // Start from the natural bounds
        //var naturalBounds:Rectangle = getBounds();
        var newWidth:Number = this.preferredWidthPreTransform();
        var newHeight:Number = this.preferredHeightPreTransform();
        var fitWidth:Number = MatrixUtil.transformBounds(newWidth, newHeight, m).x;
        var fitHeight:Number = MatrixUtil.transformBounds(newWidth, newHeight, m).y;
        
        if (isNaN(width))
            fitWidth = NaN;
        if (isNaN(height))
            fitHeight = NaN;
        
        var i:int = 0;
        while (i++ < 150)
        {
            // Get current post-transform bounds
            var transformedBounds:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, m);
            
            var widthDistance:Number = isNaN(width) ? 0 : width - transformedBounds.width;
            var heightDistance:Number = isNaN(height) ? 0 : height - transformedBounds.height;
            if (Math.abs(widthDistance) < 0.1 && Math.abs(heightDistance) < 0.1)
            {
                return new Point(newWidth, newHeight);
            }
            
            // Try to fit bounds plus difference between
            fitWidth += widthDistance * 0.5;
            fitHeight += heightDistance * 0.5;
            
            var newSize:Point = MatrixUtil.fitBounds(fitWidth, 
                                                     fitHeight, 
                                                     m,
                                                     explicitWidth, 
                                                     explicitHeight,
                                                     preferredWidthPreTransform(),
                                                     preferredHeightPreTransform(),
                                                     minWidth, minHeight,
                                                     maxWidth, maxHeight);
            if (!newSize)
                break;

            newWidth = newSize.x;
            newHeight = newSize.y;
        }
        return null;
    } */

    /**
     *  @private
     */
    /* override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean=true):void
    {
        // We have special handling for miter-limit stroked non-transformed paths,
        // Otherwise we default to the generic GraphicElement sizing algorithm.
        if (isNaN(width) && isNaN(height))     // resetting to original size?
        {
            super.setLayoutBoundsSize(width, height, postLayoutTransform);
            return;
        }

        // Resize transformed path with the iterative solution
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        if (m)
        {
            setLayoutBoundsTransformed(width, height, m);
            return;
        }

        if (!stroke || stroke.joints != "miter") // no stroke or no miter joints?
        {
            super.setLayoutBoundsSize(width, height, postLayoutTransform);
            return;
        }

        // Miter limit requires special handling since the stroke extents depend on
        // the path size as the size changes the angles of the joints.
        var newWidth:Number = preferredWidthPreTransform();
        var newHeight:Number = preferredHeightPreTransform();
        var bestWidth:Number;
        var bestHeight:Number;
        var bestScore:Number;
        
        // Special case if we are constrained in both dimensions
        if (!isNaN(width) && !isNaN(height))
        {
            var size:Point = fitLayoutBoundsIterative(width, height, new Matrix());
            if (size)
            {
                setActualSize(size.x, size.y);
                return;
            }

            // If we didn't find a solution, start from the natural bounds
            newWidth = getBounds().width;
            newHeight = getBounds().height;
            bestWidth = this.minWidth;
            bestHeight = this.minHeight;
            bestScore = (width - bestWidth) * (width - bestWidth) + (height - bestHeight) * (height - bestHeight);
        }

        var i:int = 0;
        while (i++ < 150)
        {
            var boundsWithStroke:Rectangle = getBoundingBoxWithStroke(newWidth, newHeight, null);
            
            var widthProximity:Number = 0;
            var heightProximity:Number = 0;
            if (!isNaN(width))
                widthProximity = Math.abs(width - boundsWithStroke.width);
            if (!isNaN(height))
                heightProximity = Math.abs(height - boundsWithStroke.height);
            
            if (!isNaN(width) && !isNaN(height))
            {
                var score:Number = (width - boundsWithStroke.width) * (width - boundsWithStroke.width) + 
                                   (height - boundsWithStroke.height) * (height - boundsWithStroke.height);
                
                if (!isNaN(score) && score < bestScore && boundsWithStroke.width <= width && boundsWithStroke.height <= height)
                {
                    bestScore = score;
                    bestWidth = newWidth;
                    bestHeight = newHeight;
                }
            }
            
            // Are we close enough? We want sub-pixel difference
            if (widthProximity < 1e-5 && heightProximity < 1e-5)
            {
                setActualSize(newWidth, newHeight);
                return;
            }
            
            var boundsWithoutStroke:Rectangle = segments.getBoundingBox(newWidth, newHeight, null);
            var strokeWidth:Number = boundsWithStroke.width - boundsWithoutStroke.width;
            var strokeHeight:Number = boundsWithStroke.height - boundsWithoutStroke.height;

            if (!isNaN(width))
                newWidth = width - strokeWidth;
            
            if (!isNaN(height))
                newHeight = height - strokeHeight;
        }

        setActualSize(bestWidth, bestHeight);
    } */
    
    /**
     *  @private
     *  Use measuredX and measuredY instead of drawX and drawY
     */
    /* override protected function beginDraw(g:Graphics):void
    {
        // Don't call super.beginDraw() since it will also set up an 
        // invisible fill.
        
        // Adjust the position by the internal scale factor
        var naturalBounds:Rectangle = getBounds();
        var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
        var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
        
        var origin:Point = new Point(drawX, drawY);
        var bounds:Rectangle = new Rectangle(
                                    drawX + measuredX * sx,
                                    drawY + measuredY * sy,
                                    width, 
                                    height);
        if (stroke)
        {
            var strokeBounds:Rectangle = getStrokeBounds();
            // Objects drawn in shared display objects are drawn at x,y rather
            // than 0,0 so need to move the strokeBounds if sharing.
            strokeBounds.offsetPoint(origin);
            stroke.apply(g, strokeBounds, origin);
        }
        else
        {
            g.lineStyle();
        }
        
        if (fill)
            fill.begin(g, bounds, origin);
    } */
    
   // private var _drawBounds:Rectangle = new Rectangle(); 
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    /* override protected function draw(g:Graphics):void
    {
        if (drawX !=  _drawBounds.x || drawY !=  _drawBounds.y ||
            width !=  _drawBounds.width || height !=  _drawBounds.height)
        {
            graphicsPathChanged = true;
            _drawBounds.x = drawX;
            _drawBounds.y = drawY;
            _drawBounds.width = width;
            _drawBounds.height = height;            
        }
        
        if (graphicsPathChanged)
        {
            var rcBounds:Rectangle = getBounds();
            var sx:Number = rcBounds.width == 0 ? 1 : width / rcBounds.width;
            var sy:Number = rcBounds.height == 0 ? 1 : height / rcBounds.height;
            if (segments)
                segments.generateGraphicsPath(graphicsPath, drawX, drawY, sx, sy);
            graphicsPathChanged = false;
        }
        
        g.drawPath(graphicsPath.commands, graphicsPath.data, winding);
    } */
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function endDraw(g:Graphics):void
    {
        // Set a transparent line style because filled, unclosed shapes will
        // automatically be closed by the Player. When they are, we want the line
        // to be invisible. 
        g.lineStyle();
        super.endDraw(g);
    }  */
    
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override protected function invalidateDisplayObjectSharing():void
    {
        graphicsPathChanged = true;
        super.invalidateDisplayObjectSharing();
    } */
    
    /**
     *  @private
     */
    /* private function clearCachedBoundingBoxWithStroke():void
    {
        _boundingBoxCached = null;
        _boundingBoxMatrixCached = null;
    } */
    
    /**
     *  @private
     *  Make sure we clear the cached boundingBoxWithStroke
     */
    /* override protected function stroke_propertyChangeHandler(event:PropertyChangeEvent):void
    {
        super.stroke_propertyChangeHandler(event);
        switch (event.property)
        {
            case "weight":
            case "scaleMode":
            case "joints":
            case "miterLimit":
                clearCachedBoundingBoxWithStroke();
                // Parent layout takes stroke weight into account
                invalidateParentSizeAndDisplayList();
                break;
        }
    } */
    
    /**
     *  @private
     *  Make sure we clear the cached boundingBoxWithStroke
     */
    /* override public function set stroke(value:IStroke):void
    {
        super.stroke = value;
        clearCachedBoundingBoxWithStroke();
    } */
	
	
	//----------------------------------
    //  visible copied from GraphicElement
    //----------------------------------

    /**
     *  @private
     *  Storage for the visible property.
     */
    private var _visible:Boolean = true;
    
    
    /**
     *  @private
     *  The actual 'effective' visibility of this
     *  element, one that considers the visibility of
     *  the owning design layer parent (if any).
     */
   // protected var _effectiveVisibility:Boolean = true;
    
    /**
     *  @private
     */
  //  private var visibleChanged:Boolean;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     *  @royalesuppresspublicvarwarning
	*/
    public function get visible():Boolean
    {
        return _visible;
    }

    /**
     *  @private
     */
    public function set visible(value:Boolean):void
    {
        _visible = value;
        
        /* if (designLayer && !designLayer.effectiveVisibility)
            value = false; 
        
        if (_effectiveVisibility == value)
            return;
        
        _effectiveVisibility = value;
        visibleChanged = true;
        invalidateProperties(); */
    }
	
	
	//----------------------------------
    //  left copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the left property.
     */
    private var _left:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get left():Object
    {
        return _left;
    }

    /**
     *  @private
     */
    public function set left(value:Object):void
    {
        if (_left == value)
            return;

        _left = value;
       // invalidateParentSizeAndDisplayList();
    }
	
	//----------------------------------
    //  right copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the right property.
     */
    private var _right:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get right():Object
    {
        return _right;
    }

    /**
     *  @private
     */
    public function set right(value:Object):void
    {
        if (_right == value)
            return;

        _right = value;
        //invalidateParentSizeAndDisplayList();
    }
	//----------------------------------
    //  top copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the top property.
     */
    private var _top:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get top():Object
    {
        return _top;
    }

    /**
     *  @private
     */
    public function set top(value:Object):void
    {
        if (_top == value)
            return;

        _top = value;
       // invalidateParentSizeAndDisplayList();
    }
	
	//----------------------------------
    //  bottom copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the bottom property.
     */
    private var _bottom:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get bottom():Object
    {
        return _bottom;
    }

    /**
     *  @private
     */
    public function set bottom(value:Object):void
    {
        if (_bottom == value)
            return;

        _bottom = value;
       // invalidateParentSizeAndDisplayList();
    }
    //----------------------------------
    //  verticalCenter copied from GraphicElement
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the verticalCenter property.
     */
    private var _verticalCenter:Object;

    [Inspectable(category="General")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get verticalCenter():Object
    {
        return _verticalCenter;
    }

    /**
     *  @private
     */
    public function set verticalCenter(value:Object):void
    {
        if (_verticalCenter == value)
            return;

        _verticalCenter = value;
       // invalidateParentSizeAndDisplayList();
    }
    
    //----------------------------------
    //  stroke copied from StrokedElement
    //----------------------------------

    /**
     *  @private
     */
     /* mx_internal */ private var _stroke:IStroke;
    
    [Bindable("propertyChange")]    
    [Inspectable(category="General")]

    /**
     *  The stroke used by this element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
	 *  @royalesuppresspublicvarwarning
	*/
    public function get stroke():IStroke
    {
        return _stroke;
    }
    
    /**
     *  @private
     */
    public function set stroke(value:IStroke):void
    {
       /*  var strokeEventDispatcher:EventDispatcher;
        var oldValue:IStroke = _stroke;
        
        strokeEventDispatcher = _stroke as EventDispatcher;
        if (strokeEventDispatcher)
            strokeEventDispatcher.removeEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                stroke_propertyChangeHandler); */
            
        _stroke = value;
        
        /* strokeEventDispatcher = _stroke as EventDispatcher;
        if (strokeEventDispatcher)
            strokeEventDispatcher.addEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                stroke_propertyChangeHandler);
     
     	dispatchPropertyChangeEvent("stroke", oldValue, _stroke);
     
        invalidateDisplayList();
        // Parent layout takes stroke into account
        invalidateParentSizeAndDisplayList(); */
    }
	
	
	//----------------------------------
    //  fill copied from FilledElement
    //----------------------------------

    /**
     *  @private
     */
    protected var _fill:IFill;
    [Bindable("propertyChange")]
    [Inspectable(category="General")]

    /**
     *  The object that defines the properties of the fill.
     *  If not defined, the object is drawn without a fill.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get fill():IFill
    {
        return _fill;
    }
    
    /**
     *  @private
     */
    public function set fill(value:IFill):void
    {
    	/*var oldValue:IFill = _fill;
        var fillEventDispatcher:EventDispatcher;
        
        fillEventDispatcher = _fill as EventDispatcher;
        if (fillEventDispatcher)
            fillEventDispatcher.removeEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                fill_propertyChangeHandler); */
            
        _fill = value;
        
        /* fillEventDispatcher = _fill as EventDispatcher;
        if (fillEventDispatcher)
            fillEventDispatcher.addEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, 
                fill_propertyChangeHandler);
                
        dispatchPropertyChangeEvent("fill", oldValue, _fill);    
        invalidateDisplayList(); */
    }
	
}

}

//--------------------------------------------------------------------------
//
//  Internal Helper Class - PathSegmentsCollection
//
//--------------------------------------------------------------------------

/**
 *  Helper class that takes in a string and stores and generates a vector of
 *  Path segments.
 *  Provides methods for generating GraphicsPath and calculating bounds. 
 */
//class PathSegmentsCollection
//{
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

/**
 *  Constructor.
 * 
 *  @param value 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* public function PathSegmentsCollection(value:String)
{
    if (!value)
    {
        _segments = new Vector.<PathSegment>();
        return;
    }
    
    var newSegments:Vector.<PathSegment> = new Vector.<PathSegment>();
    var charCount:int = value.length;
    var c:Number; // current char code, String.charCodeAt() returns Number.
    var useRelative:Boolean;
    var prevIdentifier:Number = 0;
    var prevX:Number = 0;
    var prevY:Number = 0;
    var lastMoveX:Number = 0;
    var lastMoveY:Number = 0;
    var x:Number;
    var y:Number;
    var controlX:Number;
    var controlY:Number;
    var control2X:Number;
    var control2Y:Number;
    var lastMoveSegmentIndex:int = -1;
    
    _dataLength = charCount;
    _charPos = 0;
    while (true)
    {
        // Skip any whitespace or commas first
        skipWhiteSpace(value);
        
        // Are we done parsing?
        if (_charPos >= charCount)
            break;
        
        // Get the next character
        c = value.charCodeAt(_charPos++);
        
        // Is this a start of a number? 
        // The RegExp for a float is /[+-]?\d*\.?\d+([Ee][+-]?\d+)?/
        if ((c >= 0x30 && c < 0x3A) ||   // A digit
            (c == 0x2B || c == 0x2D) ||  // '+' & '-'
            (c == 0x2E))                 // '.'
        {
            c = prevIdentifier;
            _charPos--;
        }
        else if (c >= 0x41 && c <= 0x56) // Between 'C' and 'V' 
            useRelative = false;
        else if (c >= 0x61 && c <= 0x7A) // Between 'c' and 'v'
            useRelative = true;
        
        switch(c)
        {
            case 0x63:  // c
            case 0x43:  // C
                controlX = getNumber(useRelative, prevX, value);
                controlY = getNumber(useRelative,  prevY, value);
                control2X = getNumber(useRelative, prevX, value);
                control2Y = getNumber(useRelative, prevY, value);
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new CubicBezierSegment(controlX, controlY, 
                    control2X, control2Y,
                    x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x63;
                
                break;
            
            case 0x6D:  // m
            case 0x4D:  // M
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new MoveSegment(x, y));
                prevX = x;
                prevY = y;
                // If a moveto is followed by multiple pairs of coordinates, 
                // the subsequent pairs are treated as implicit lineto commands.
                prevIdentifier = (c == 0x6D) ? 0x6C : 0x4C; // c == 'm' ? 'l' : 'L'
                
                // Fix for bug SDK-24457:
                // If the Quadratic segment is isolated, the Player
                // won't draw fill correctly. We need to generate
                // a dummy line segment.
                var curSegmentIndex:int = newSegments.length - 1;
                if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
                    newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
                {
                    // Insert a dummy LineSegment
                    newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
                    curSegmentIndex++;
                }
                
                lastMoveSegmentIndex = curSegmentIndex;
                lastMoveX = x;
                lastMoveY = y;
                break;
            
            case 0x6C:  // l
            case 0x4C:  // L
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new LineSegment(x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x6C;
                break;
            
            case 0x68:  // h
            case 0x48:  // H
                x = getNumber(useRelative, prevX, value);
                y = prevY;
                newSegments.push(new LineSegment(x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x68;
                break;
            
            case 0x76:  // v
            case 0x56:  // V
                x = prevX;
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new LineSegment(x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x76;
                break;
            
            case 0x71:  // q
            case 0x51:  // Q
                controlX = getNumber(useRelative, prevX, value);
                controlY = getNumber(useRelative, prevY, value);
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x71;
                break;
            
            case 0x74:  // t
            case 0x54:  // T
                // control is a reflection of the previous control point
                if (prevIdentifier == 0x74 || prevIdentifier == 0x71) // 't' or 'q'
                {
                    controlX = prevX + (prevX - controlX);
                    controlY = prevY + (prevY - controlY);
                }
                else
                {
                    controlX = prevX;
                    controlY = prevY;
                }
                
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new QuadraticBezierSegment(controlX, controlY, x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x74;
                
                break;
            
            case 0x73:  // s
            case 0x53:  // S
                if (prevIdentifier == 0x73 || prevIdentifier == 0x63) // s or c
                {
                    controlX = prevX + (prevX - control2X);
                    controlY = prevY + (prevY - control2Y);
                }
                else
                {
                    controlX = prevX;
                    controlY = prevY;
                }
                
                control2X = getNumber(useRelative, prevX, value);
                control2Y = getNumber(useRelative, prevY, value);
                x = getNumber(useRelative, prevX, value);
                y = getNumber(useRelative, prevY, value);
                newSegments.push(new CubicBezierSegment(controlX, controlY,
                    control2X, control2Y, x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x73;
                
                break;
            
            case 0x7A:  // z
            case 0x5A:  // Z
                x = lastMoveX;
                y = lastMoveY;
                newSegments.push(new LineSegment(x, y));
                prevX = x;
                prevY = y;
                prevIdentifier = 0x7A;
                
                break;
            
            default:
                // unknown identifier, throw error?
                _segments = new Vector.<PathSegment>();
                return;
        }
    }
    
    // Fix for bug SDK-24457:
    // If the Quadratic segment is isolated, the Player
    // won't draw fill correctly. We need to generate
    // a dummy line segment.
    curSegmentIndex = newSegments.length;
    if (lastMoveSegmentIndex + 2 == curSegmentIndex && 
        newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
    {
        // Insert a dummy LineSegment
        newSegments.splice(lastMoveSegmentIndex + 1, 0, new LineSegment(lastMoveX, lastMoveY));
        curSegmentIndex++;
    }
    
    _segments = newSegments;
} */

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------

//----------------------------------
//  data
//----------------------------------

//private var _segments:Vector.<PathSegment>;

/**
 *  A Vector of the actual path segments. May be empty, but always non-null. 
 */
/* public function get data():Vector.<PathSegment>
{
    return _segments;
} */

//----------------------------------
//  bounds
//----------------------------------

//private var _bounds:Rectangle;

/**
 *  The bounds of the segments in local coordinates.  
 */
/* public function getBounds():Rectangle
{
    if (_bounds)
        return _bounds;
    
    // First, allocate temporary bounds, as getBoundingBox() requires
    // natual bounds to calculate a scaling factor
    _bounds = new Rectangle(0, 0, 1, 1);
    
    // Pass in the same size to getBoundingBox
    // so that the scaling factor is (1, 1).
    _bounds = getBoundingBox(1, 1, null /*Matrix*//*);
    return _bounds;
} */

//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------

/**
 *  @return Returns the axis aligned bounding box of the segments stretched to 
 *  width, height and then transformed with transformation matrix m.
 */
/* public function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
{
    var naturalBounds:Rectangle = getBounds();
    var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
    var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height; 
    
    var prevSegment:PathSegment;
    var pathBBox:Rectangle;
    var count:int = _segments.length;
    
    for (var i:int = 0; i < count; i++)
    {
        var segment:PathSegment = _segments[i];
        pathBBox = segment.getBoundingBox(prevSegment, sx, sy, m, pathBBox);
        prevSegment = segment;
    }
    
    // If path is empty, it's untransformed bounding box is (0,0), so we return transformed point (0,0)
    if (!pathBBox)
    {
        var x:Number = m ? m.tx : 0;
        var y:Number = m ? m.ty : 0;
        pathBBox = new Rectangle(x, y);
    }
    return pathBBox;
} */

/**
 *  Workhorse method that iterates through the <code>segments</code>
 *  array and draws each path egment based on its control points. 
 *  
 *  Segments are drawn from the x and y position of the path. 
 *  Additionally, segments are drawn by taking into account the scale  
 *  applied to the path. 
 * 
 *  @param tx A Number representing the x position of where this 
 *  path segment should be drawn
 *  
 *  @param ty A Number representing the y position of where this  
 *  path segment should be drawn
 * 
 *  @param sx A Number representing the scaleX at which to draw 
 *  this path segment 
 * 
 *  @param sy A Number representing the scaleY at which to draw this
 *  path segment
 */
/* public function generateGraphicsPath(graphicsPath:GraphicsPath,
                                     tx:Number, 
                                     ty:Number, 
                                     sx:Number, 
                                     sy:Number):void
{
    graphicsPath.commands = null;
    graphicsPath.data = null;
    
    // Always start by moving to drawX, drawY. Otherwise
    // the path will begin at the previous pen location
    // if it does not start with a MoveSegment.
    graphicsPath.moveTo(tx, ty);
    
    var curSegment:PathSegment;
    var prevSegment:PathSegment;
    var count:int = _segments.length;
    for (var i:int = 0; i < count; i++)
    {
        prevSegment = curSegment;
        curSegment = _segments[i];
        curSegment.draw(graphicsPath, tx, ty, sx, sy, prevSegment);
    }
} */

//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------

/* private var _charPos:int = 0;
private var _dataLength:int = 0;

private function skipWhiteSpace(data:String):void
{
    while (_charPos < _dataLength)
    {
        var c:Number = data.charCodeAt(_charPos);
        if (c != 0x20 && // Space
            c != 0x2C && // Comma
            c != 0xD  && // Carriage return
            c != 0x9  && // Tab
            c != 0xA)    // New line
        {
            break;
        }
        _charPos++;
    }
}

private function getNumber(useRelative:Boolean, offset:Number, value:String):Number
{
    // Parse the string and find the first occurrance of the following RexExp
    // numberRegExp:RegExp = /[+-]?\d*\.?\d+([Ee][+-]?\d+)?/g;
    
    skipWhiteSpace(value); // updates _charPos
    if (_charPos >= _dataLength)
        return NaN;
    
    // Remember the start of the number
    var numberStart:int = _charPos;
    var hasSignCharacter:Boolean = false;
    var hasDigits:Boolean = false;
    
    // The number could start with '+' or '-' (the "[+-]?" part of the RegExp)
    var c:Number = value.charCodeAt(_charPos);
    if (c == 0x2B || c == 0x2D) // '+' or '-'
    {
        hasSignCharacter = true;
        _charPos++;
    }
    
    // The index of the '.' if any
    var dotIndex:int = -1;
    
    // First sequence of digits and optional dot in between (the "\d*\.?\d+" part of the RegExp)
    while (_charPos < _dataLength)
    {
        c = value.charCodeAt(_charPos);
        
        if (c >= 0x30 && c < 0x3A) // A digit
        {
            hasDigits = true;
        }
        else if (c == 0x2E && dotIndex == -1) // '.'
        {
            dotIndex = _charPos;
        }
        else
            break;
        
        _charPos++;
    }
    
    // Now check whether we had at least one digit.
    if (!hasDigits)
    {
        // Go to the end of the data
        _charPos = _dataLength;
        return NaN;
    }
    
    // 1. Was the last character a '.'? If so, rewind one character back.
    if (c == 0x2E)
        _charPos--;
    
    // So far we have a valid number, remember its end character index
    var numberEnd:int = _charPos;
    
    // Check to see if we have scientific notation (the "([Ee][+-]?\d+)?" part of the RegExp)
    if (c == 0x45 || c == 0x65)
    {
        _charPos++;
        
        // Check for '+' or '-'
        if (_charPos < _dataLength)
        {            
            c = value.charCodeAt(_charPos);
            if (c == 0x2B || c == 0x2D)
                _charPos++;
        }
        
        // Find all the digits
        var digitStart:int = _charPos;
        while (_charPos < _dataLength)
        {
            c = value.charCodeAt(_charPos);
            
            // Not a digit?
            if (!(c >= 0x30 && c < 0x3A))
            {
                break;
            }
            
            _charPos++;
        }
        
        // Do we have at least one digit?
        if (digitStart < _charPos)
            numberEnd = _charPos; // Scientific notation, update the end index of the number.
        else
            _charPos = numberEnd; // No scientific notation, rewind back to the end index of the number.
    }
    
    // Use parseFloat to get the actual number.
    // TODO (egeorgie): we could build the number while matching the RegExp which will save the substr and parseFloat
    var subString:String = value.substr(numberStart, numberEnd - numberStart);
    var result:Number = parseFloat(subString);
    if (isNaN(result))
    {
        // Go to the end of the data
        _charPos = _dataLength;
        return NaN;
    }
    _charPos = numberEnd;
    return useRelative ? result + offset : result;
}
} */

//--------------------------------------------------------------------------
//
//  Internal Helper Class - PathSegment 
//
//--------------------------------------------------------------------------
/* import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import mx.events.PropertyChangeEvent; */

/**
 *  The PathSegment class is the base class for a segment of a path.
 *  This class is not created directly. It is the base class for 
 *  MoveSegment, LineSegment, CubicBezierSegment and QuadraticBezierSegment.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class PathSegment extends Object
{ */

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

/**
 *  Constructor.
 * 
 *  @param _x The x position of the pen in the current coordinate system.
 *  
 *  @param _y The y position of the pen in the current coordinate system.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* public function PathSegment(_x:Number = 0, _y:Number = 0)
{
    super();
    x = _x;  
    y = _y; 
}   */ 

//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------

//----------------------------------
//  x
//----------------------------------

/**
 *  The ending x position for this segment.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//public var x:Number = 0;

//----------------------------------
//  y
//----------------------------------

/**
 *  The ending y position for this segment.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
//public var y:Number = 0;

//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------

/**
 *  Draws this path segment. You can determine the current pen position by 
 *  reading the x and y values of the previous segment. 
 *
 *  @param g The graphics context to draw into.
 *  @param prev The previous segment drawn, or null if this is the first segment.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
{
    // Override to draw your segment
} */

/**
 *  @param prev The previous segment drawn, or null if this is the first segment.
 *  @param sx Pre-transform scale factor for x coordinates.
 *  @param sy Pre-transform scale factor for y coordinates.
 *  @param m Transformation matrix.
 *  @param rect If non-null, rect is expanded to include the bounding box of the segment.
 *  @return Returns the union of rect and the axis aligned bounding box of the post-transformed
 *  path segment.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */    
/* public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
{
    // Override to calculate your segment's bounding box.
    return rect;
} */

/**
 *  Returns the tangent for the segment. 
 *  @param prev The previous segment drawn, or null if this is the first segment.
 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
 *  @param sx Pre-transform scale factor for x coordinates.
 *  @param sy Pre-transform scale factor for y coordinates.
 *  @param m Transformation matrix.
 *  @param result The tangent is returned as vector (x, y) in result.
 */
/* public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
{
    result.x = 0;
    result.y = 0;
}
} */


//--------------------------------------------------------------------------
//
//  Internal Helper Class - LineSegment 
//
//--------------------------------------------------------------------------
/* 
import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.MatrixUtil; */

/**
 *  The LineSegment draws a line from the current pen position to the coordinate located at x, y.
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class LineSegment extends PathSegment
{
 */
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

/**
 *  Constructor.
 *  
 *  @param x The current location of the pen along the x axis. The <code>draw()</code> method uses 
 *  this value to determine where to draw to.
 * 
 *  @param y The current location of the pen along the y axis. The <code>draw()</code> method uses 
 *  this value to determine where to draw to.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* public function LineSegment(x:Number = 0, y:Number = 0)
{
    super(x, y);
}   
 */
//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------

/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
{
    graphicsPath.lineTo(dx + x*sx, dy + y*sy);
}
 */
/**
 *  @inheritDoc
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle):Rectangle
{
    pt = MatrixUtil.transformPoint(x * sx, y * sy, m);
    var x1:Number = pt.x;
    var y1:Number = pt.y;
    
    // If the previous segment actually draws, then only add the end point to the rectangle,
    // as the start point would have been added by the previous segment:
    if (prev != null && !(prev is MoveSegment))
        return MatrixUtil.rectUnion(x1, y1, x1, y1, rect); 
    
    var pt:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m);
    var x2:Number = pt.x;
    var y2:Number = pt.y;
    
    return MatrixUtil.rectUnion(Math.min(x1, x2), Math.min(y1, y2),
        Math.max(x1, x2), Math.max(y1, y2), rect); 
} */

/**
 *  Returns the tangent for the segment. 
 *  @param prev The previous segment drawn, or null if this is the first segment.
 *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
 *  @param sx Pre-transform scale factor for x coordinates.
 *  @param sy Pre-transform scale factor for y coordinates.
 *  @param m Transformation matrix.
 *  @param result The tangent is returned as vector (x, y) in result.
 */
/* override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
{
    var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
    var pt1:Point = MatrixUtil.transformPoint(x * sx, y * sy, m);
    
    result.x = pt1.x - pt0.x;
    result.y = pt1.y - pt0.y;
}
} */

//--------------------------------------------------------------------------
//
//  Internal Helper Class - MoveSegment 
//
//--------------------------------------------------------------------------
//import flash.display.GraphicsPath;

/**
 *  The MoveSegment moves the pen to the x,y position. This class calls the <code>Graphics.moveTo()</code> method 
 *  from the <code>draw()</code> method.
 * 
 *  
 *  @see flash.display.Graphics
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class MoveSegment extends PathSegment
{
 */
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

/**
 *  Constructor.
 *  
 *  @param x The target x-axis location in 2-d coordinate space.
 *  
 *  @param y The target y-axis location in 2-d coordinate space.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* public function MoveSegment(x:Number = 0, y:Number = 0)
{
    super(x, y);
}   */ 

//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------

/**
 *  @inheritDoc
 * 
 *  The MoveSegment class moves the pen to the position specified by the
 *  x and y properties.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
{
    graphicsPath.moveTo(dx+x*sx, dy+y*sy);
}
} */

//--------------------------------------------------------------------------
//
//  Internal Helper Class - CubicBezierSegment 
//
//--------------------------------------------------------------------------
/* 
import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.MatrixUtil; */

/**
 *  The CubicBezierSegment draws a cubic bezier curve from the current pen position 
 *  to x, y. The control1X and control1Y properties specify the first control point; 
 *  the control2X and control2Y properties specify the second control point.
 *
 *  <p>Cubic bezier curves are not natively supported in Flash Player. This class does
 *  an approximation based on the fixed midpoint algorithm and uses 4 quadratic curves
 *  to simulate a cubic curve.</p>
 *
 *  <p>For details on the fixed midpoint algorithm, see:<br/>
 *  http://timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm</p>
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class CubicBezierSegment extends PathSegment
{ */
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  <p>For a CubicBezierSegment, there are two control points, each with x and y coordinates. Control points 
     *  are points that define the direction and amount of curves of a Bezier curve. 
     *  The curved line never reaches the control points; however, the line curves as though being drawn 
     *  toward the control point.</p>
     *  
     *  @param _control1X The x-axis location in 2-d coordinate space of the first control point.
     *  
     *  @param _control1Y The y-axis location of the first control point.
     *  
     *  @param _control2X The x-axis location of the second control point.
     *  
     *  @param _control2Y The y-axis location of the second control point.
     *  
     *  @param x The x-axis location of the starting point of the curve.
     *  
     *  @param y The y-axis location of the starting point of the curve.
     *  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function CubicBezierSegment(
        _control1X:Number = 0, _control1Y:Number = 0,
        _control2X:Number = 0, _control2Y:Number = 0,
        x:Number = 0, y:Number = 0)
    {
        super(x, y);
        
        control1X = _control1X;
        control1Y = _control1Y;
        control2X = _control2X;
        control2Y = _control2Y;
    }    */
    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    //private var _qPts:QuadraticPoints;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  control1X
    //----------------------------------
    
    /**
     *  The first control point x position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var control1X:Number = 0;
    
    //----------------------------------
    //  control1Y
    //----------------------------------
    
    /**
     *  The first control point y position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var control1Y:Number = 0;
    
    //----------------------------------
    //  control2X
    //----------------------------------
    
    /**
     *  The second control point x position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var control2X:Number = 0;
    
    //----------------------------------
    //  control2Y
    //----------------------------------
    
    /**
     *  The second control point y position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var control2Y:Number = 0;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Draws the segment.
     *
     *  @param g The graphics context where the segment is drawn.
     *  
     *  @param prev The previous location of the pen.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment):void
    {
        var qPts:QuadraticPoints = getQuadraticPoints(prev);
        
        graphicsPath.curveTo(dx + qPts.control1.x*sx, dy+qPts.control1.y*sy, dx+qPts.anchor1.x*sx, dy+qPts.anchor1.y*sy);
        graphicsPath.curveTo(dx + qPts.control2.x*sx, dy+qPts.control2.y*sy, dx+qPts.anchor2.x*sx, dy+qPts.anchor2.y*sy);
        graphicsPath.curveTo(dx + qPts.control3.x*sx, dy+qPts.control3.y*sy, dx+qPts.anchor3.x*sx, dy+qPts.anchor3.y*sy);
        graphicsPath.curveTo(dx + qPts.control4.x*sx, dy+qPts.control4.y*sy, dx+qPts.anchor4.x*sx, dy+qPts.anchor4.y*sy);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
                                            m:Matrix, rect:Rectangle):Rectangle
    {
        var qPts:QuadraticPoints = getQuadraticPoints(prev);
        
        rect = MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
            qPts.control1.x, qPts.control1.y,
            qPts.anchor1.x, qPts.anchor1.y,
            sx, sy, m, rect); 
        
        rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor1.x, qPts.anchor1.y,
            qPts.control2.x, qPts.control2.y,
            qPts.anchor2.x, qPts.anchor2.y,
            sx, sy, m, rect); 
        
        rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor2.x, qPts.anchor2.y,
            qPts.control3.x, qPts.control3.y,
            qPts.anchor3.x, qPts.anchor3.y,
            sx, sy, m, rect); 
        
        rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor3.x, qPts.anchor3.y,
            qPts.control4.x, qPts.control4.y,
            qPts.anchor4.x, qPts.anchor4.y,
            sx, sy, m, rect); 
        return rect;
    } */
    
    /**
     *  Returns the tangent for the segment. 
     *  @param prev The previous segment drawn, or null if this is the first segment.
     *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
     *  @param sx Pre-transform scale factor for x coordinates.
     *  @param sy Pre-transform scale factor for y coordinates.
     *  @param m Transformation matrix.
     *  @param result The tangent is returned as vector (x, y) in result.
     */
    /* override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
    {
        // Get the approximation (we want the tangents to be the same as the ones we use to draw
        var qPts:QuadraticPoints = getQuadraticPoints(prev);
        
        var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
        var pt1:Point = MatrixUtil.transformPoint(qPts.control1.x * sx, qPts.control1.y * sy, m).clone();
        var pt2:Point = MatrixUtil.transformPoint(qPts.anchor1.x * sx, qPts.anchor1.y * sy, m).clone();
        var pt3:Point = MatrixUtil.transformPoint(qPts.control2.x * sx, qPts.control2.y * sy, m).clone();
        var pt4:Point = MatrixUtil.transformPoint(qPts.anchor2.x * sx, qPts.anchor2.y * sy, m).clone();
        var pt5:Point = MatrixUtil.transformPoint(qPts.control3.x * sx, qPts.control3.y * sy, m).clone();
        var pt6:Point = MatrixUtil.transformPoint(qPts.anchor3.x * sx, qPts.anchor3.y * sy, m).clone();
        var pt7:Point = MatrixUtil.transformPoint(qPts.control4.x * sx, qPts.control4.y * sy, m).clone();
        var pt8:Point = MatrixUtil.transformPoint(qPts.anchor4.x * sx, qPts.anchor4.y * sy, m).clone();
        
        if (start)
        {
            QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
            // If there is no tangent
            if (result.x == 0 && result.y == 0)
            {
                // Try 3 & 4
                QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt3.x, pt3.y, pt4.x, pt4.y, start, result);
                
                // If there is no tangent
                if (result.x == 0 && result.y == 0)
                {
                    // Try 5 & 6
                    QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt5.x, pt5.y, pt6.x, pt6.y, start, result);
                    
                    // If there is no tangent
                    if (result.x == 0 && result.y == 0)
                        // Try 7 & 8
                        QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
                }
            }
        }
        else
        {
            QuadraticBezierSegment.getQTangent(pt6.x, pt6.y, pt7.x, pt7.y, pt8.x, pt8.y, start, result);
            // If there is no tangent
            if (result.x == 0 && result.y == 0)
            {
                // Try 4 & 5
                QuadraticBezierSegment.getQTangent(pt4.x, pt4.y, pt5.x, pt5.y, pt8.x, pt8.y, start, result);
                
                // If there is no tangent
                if (result.x == 0 && result.y == 0)
                {
                    // Try 2 & 3
                    QuadraticBezierSegment.getQTangent(pt2.x, pt2.y, pt3.x, pt3.y, pt8.x, pt8.y, start, result);
                    
                    // If there is no tangent
                    if (result.x == 0 && result.y == 0)
                        // Try 0 & 1
                        QuadraticBezierSegment.getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt8.x, pt8.y, start, result);
                }
            }
        }
    }   */  
    
    /** 
     *  @private
     *  Tim Groleau's method to approximate a cubic bezier with 4 quadratic beziers, 
     *  with endpoint and control point of each saved. 
     */
    /* private function getQuadraticPoints(prev:PathSegment):QuadraticPoints
    {
        if (_qPts)
            return _qPts;
        
        var p1:Point = new Point(prev ? prev.x : 0, prev ? prev.y : 0);
        var p2:Point = new Point(x, y);
        var c1:Point = new Point(control1X, control1Y);     
        var c2:Point = new Point(control2X, control2Y);
        
        // calculates the useful base points
        var PA:Point = Point.interpolate(c1, p1, 3/4);
        var PB:Point = Point.interpolate(c2, p2, 3/4);
        
        // get 1/16 of the [p2, p1] segment
        var dx:Number = (p2.x - p1.x) / 16;
        var dy:Number = (p2.y - p1.y) / 16;
        
        _qPts = new QuadraticPoints;
        
        // calculates control point 1
        _qPts.control1 = Point.interpolate(c1, p1, 3/8);
        
        // calculates control point 2
        _qPts.control2 = Point.interpolate(PB, PA, 3/8);
        _qPts.control2.x -= dx;
        _qPts.control2.y -= dy;
        
        // calculates control point 3
        _qPts.control3 = Point.interpolate(PA, PB, 3/8);
        _qPts.control3.x += dx;
        _qPts.control3.y += dy;
        
        // calculates control point 4
        _qPts.control4 = Point.interpolate(c2, p2, 3/8);
        
        // calculates the 3 anchor points
        _qPts.anchor1 = Point.interpolate(_qPts.control1, _qPts.control2, 0.5); 
        _qPts.anchor2 = Point.interpolate(PA, PB, 0.5); 
        _qPts.anchor3 = Point.interpolate(_qPts.control3, _qPts.control4, 0.5); 
        
        // the 4th anchor point is p2
        _qPts.anchor4 = p2;
        
        return _qPts;      
    }
} */

//--------------------------------------------------------------------------
//
//  Internal Helper Class - QuadraticPoints  
//
//--------------------------------------------------------------------------
//import flash.geom.Point;

/**
 *  Utility class to store the computed quadratic points.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class QuadraticPoints
{
    public var control1:Point;
    public var anchor1:Point;
    public var control2:Point;
    public var anchor2:Point;
    public var control3:Point;
    public var anchor3:Point;
    public var control4:Point;
    public var anchor4:Point; */
    
    /**
     * Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   /*  public function QuadraticPoints()
    {
        super();
    }
} */

//--------------------------------------------------------------------------
//
//  Internal Helper Class - QuadraticBezierSegment 
//
//--------------------------------------------------------------------------
/* import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.utils.MatrixUtil; */

/**
 *  The QuadraticBezierSegment draws a quadratic curve from the current pen position 
 *  to x, y. 
 *
 *  Quadratic bezier is the native curve type
 *  in Flash Player.
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
/* class QuadraticBezierSegment extends PathSegment
{ */
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  <p>For a QuadraticBezierSegment, there is one control point. A control point
     *  is a point that defines the direction and amount of a Bezier curve. 
     *  The curved line never reaches the control point; however, the line curves as though being drawn 
     *  toward the control point.</p>
     * 
     *  @param _control1X The x-axis location in 2-d coordinate space of the control point.
     *  
     *  @param _control1Y The y-axis location in 2-d coordinate space of the control point.
     *  
     *  @param x The x-axis location of the starting point of the curve.
     *  
     *  @param y The y-axis location of the starting point of the curve.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function QuadraticBezierSegment(
        _control1X:Number = 0, _control1Y:Number = 0, 
        x:Number = 0, y:Number = 0)
    {
        super(x, y);
        
        control1X = _control1X;
        control1Y = _control1Y;
    }  */  
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  control1X
    //----------------------------------
    
    /**
     *  The control point's x position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
   // public var control1X:Number = 0;
    
    //----------------------------------
    //  control1Y
    //----------------------------------
    
    /**
     *  The control point's y position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    //public var control1Y:Number = 0;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Draws the segment using the control point location and the x and y coordinates. 
     *  This method calls the <code>Graphics.curveTo()</code> method.
     *  
     *  @see flash.display.Graphics
     *
     *  @param g The graphics context where the segment is drawn.
     *  
     *  @param prev The previous location of the pen.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function draw(graphicsPath:GraphicsPath, dx:Number,dy:Number,sx:Number,sy:Number,prev:PathSegment):void
    {
        graphicsPath.curveTo(dx+control1X*sx, dy+control1Y*sy, dx+x*sx, dy+y*sy);
    }
    
    static public function getQTangent(x0:Number, y0:Number,
                                       x1:Number, y1:Number,
                                       x2:Number, y2:Number,
                                       start:Boolean,
                                       result:Point):void
    {
        if (start)
        {
            if (x0 == x1 && y0 == y1)
            {
                result.x = x2 - x0;
                result.y = y2 - y0;
            }
            else
            {
                result.x = x1 - x0;
                result.y = y1 - y0;
            }
        }
        else
        {
            if (x2 == x1 && y2 == y1)
            {
                result.x = x2 - x0;
                result.y = y2 - y0;
            }
            else
            {
                result.x = x2 - x1;
                result.y = y2 - y1;
            }
        }
    } */
    
    /**
     *  Returns the tangent for the segment. 
     *  @param prev The previous segment drawn, or null if this is the first segment.
     *  @param start If true, returns the tangent to the start point, otherwise the tangend to the end point.
     *  @param sx Pre-transform scale factor for x coordinates.
     *  @param sy Pre-transform scale factor for y coordinates.
     *  @param m Transformation matrix.
     *  @param result The tangent is returned as vector (x, y) in result.
     */
    /* override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point):void
    {
        var pt0:Point = MatrixUtil.transformPoint(prev ? prev.x * sx : 0, prev ? prev.y * sy : 0, m).clone();
        var pt1:Point = MatrixUtil.transformPoint(control1X * sx, control1Y * sy, m).clone();;
        var pt2:Point = MatrixUtil.transformPoint(x * sx, y * sy, m).clone();
        
        getQTangent(pt0.x, pt0.y, pt1.x, pt1.y, pt2.x, pt2.y, start, result);
    } */
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number,
                                            m:Matrix, rect:Rectangle):Rectangle
    {
        return MatrixUtil.getQBezierSegmentBBox(prev ? prev.x : 0, prev ? prev.y : 0,
            control1X, control1Y, x, y, sx, sy, m, rect);
    }
} */
