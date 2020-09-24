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
{

import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.mx_internal;
import mx.utils.MatrixUtil;

import spark.primitives.supportClasses.FilledElement;

use namespace mx_internal;

/**
 *  The Ellipse class is a filled graphic element that draws an ellipse.
 *  To draw the ellipse, this class calls the <code>Graphics.drawEllipse()</code> 
 *  method.
 *  
 *  @see flash.display.Graphics
 *  
 *  @includeExample examples/EllipseExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Ellipse extends FilledElement
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
    public function Ellipse()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
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
     *  @productversion Flex 4
     */
    override protected function draw(g:Graphics):void
    {
        g.drawEllipse(drawX, drawY, width, height);
    }
    
    /**
     *  @private
     */
    override protected function transformWidthForLayout(width:Number,
                                                        height:Number,
                                                        postLayoutTransform:Boolean = true):Number
    {
        if (postLayoutTransform && hasComplexLayoutMatrix)
            width = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
                                                     layoutFeatures.layoutMatrix).width;    

        // Take stroke into account
        return width + getStrokeExtents(postLayoutTransform).width;
    }

    /**
     *  @private
     */
    override protected function transformHeightForLayout(width:Number,
                                                         height:Number,
                                                         postLayoutTransform:Boolean = true):Number
    {
        if (postLayoutTransform && hasComplexLayoutMatrix)
            height = MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
                                                      layoutFeatures.layoutMatrix).height;

        // Take stroke into account
        return height + getStrokeExtents(postLayoutTransform).height;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var strokeExtents:Rectangle = getStrokeExtents(postLayoutTransform);
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        if (!m)
            return strokeExtents.left + this.x;

        if (!isNaN(width))
            width -= strokeExtents.width;
        if (!isNaN(height))
            height -= strokeExtents.height;

        // Calculate the width and height pre-transform:
        var newSize:Point = MatrixUtil.fitBounds(width, height, m,
                                                 explicitWidth, explicitHeight,
                                                 preferredWidthPreTransform(),
                                                 preferredHeightPreTransform(),
                                                 minWidth, minHeight,
                                                 maxWidth, maxHeight);
        if (!newSize)
            newSize = new Point(minWidth, minHeight);

        return strokeExtents.left + 
            MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).x;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number
    {
        var strokeExtents:Rectangle = getStrokeExtents(postLayoutTransform);
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        if (!m)
            return strokeExtents.top + this.y;

        if (!isNaN(width))
            width -= strokeExtents.width;
        if (!isNaN(height))
            height -= strokeExtents.height;

        // Calculate the width and height pre-transform:
        var newSize:Point = MatrixUtil.fitBounds(width, height, m,
                                                 explicitWidth, explicitHeight,
                                                 preferredWidthPreTransform(),
                                                 preferredHeightPreTransform(),
                                                 minWidth, minHeight,
                                                 maxWidth, maxHeight);
        if (!newSize)
            newSize = new Point(minWidth, minHeight);

        return strokeExtents.top + 
            MatrixUtil.getEllipseBoundingBox(newSize.x / 2, newSize.y / 2, newSize.x / 2, newSize.y / 2, m).y;
    }

    /**
     *  @private
     */
    override public function getLayoutBoundsX(postLayoutTransform:Boolean = true):Number
    {
        var stroke:Number = getStrokeExtents(postLayoutTransform).left;
        
        if (postLayoutTransform && hasComplexLayoutMatrix)
            return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
                                                             layoutFeatures.layoutMatrix).x;
        
        return stroke + this.x;
    }

    /**
     *  @private
     */
    override public function getLayoutBoundsY(postLayoutTransform:Boolean = true):Number
    {
        var stroke:Number = getStrokeExtents(postLayoutTransform).top;

        if (postLayoutTransform && hasComplexLayoutMatrix)
                return stroke + MatrixUtil.getEllipseBoundingBox(width / 2, height / 2, width / 2, height / 2, 
                                                                 layoutFeatures.layoutMatrix).y;

        return stroke + this.y;
    }
    
    /**
     *  @private
     *  Returns the bounding box of the transformed ellipse(width, height) with matrix m.
     */
    private function getBoundingBox(width:Number, height:Number, m:Matrix):Rectangle
    {
        return MatrixUtil.getEllipseBoundingBox(0, 0, width / 2, height / 2, m);
    }
    
    /**
     *  @private
     */
    override public function setLayoutBoundsSize(width:Number,
                                                 height:Number,
                                                 postLayoutTransform:Boolean = true):void
    {
        var m:Matrix = getComplexMatrix(postLayoutTransform);
        if (!m)
        {
            super.setLayoutBoundsSize(width, height, postLayoutTransform);
            return;
        }
        
        setLayoutBoundsTransformed(width, height, m);
    }
   
    /**
     *  @private
     */
    private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix):void
    {
        var strokeExtents:Rectangle = getStrokeExtents(true);
        width -= strokeExtents.width;
        height -= strokeExtents.height;
        
        var size:Point = fitLayoutBoundsIterative(width, height, m);
        
        // We couldn't find a solution, try to relax the constraints
        if (!size && !isNaN(width) && !isNaN(height))
        {
            // Try without width constraint
            var size1:Point = fitLayoutBoundsIterative(NaN, height, m);
            
            // Try without height constraint
            var size2:Point = fitLayoutBoundsIterative(width, NaN, m);
            
            // Ignore solutions that will exceed the requested size
            if (size1 && getBoundingBox(size1.x, size1.y, m).width > width)
                size1 = null;
            if (size2 && getBoundingBox(size2.x, size2.y, m).height > height)
                size2 = null;
            
            // Which size was better?
            if (size1 && size2)
            {
                var pickSize1:Boolean = size1.x * size1.y > size2.x * size2.y;
                
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
    }
    
    /**
     *  Iteratively approach a solution. Returns 0 if no exact solution exists.
     *  NaN values for width/height mean "not constrained" in that dimesion. 
     * 
     *  @private
     */
    private function fitLayoutBoundsIterative(width:Number, height:Number, m:Matrix):Point
    {
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
            var postTransformBounds:Rectangle = getBoundingBox(newWidth, newHeight, m);
            
            var widthDifference:Number = isNaN(width) ? 0 : width - postTransformBounds.width;
            var heightDifference:Number = isNaN(height) ? 0 : height - postTransformBounds.height;
            
            if (Math.abs(widthDifference) < 0.1 && Math.abs(heightDifference) < 0.1)
            {
                return new Point(newWidth, newHeight);
            }
            
            fitWidth += widthDifference * 0.5;
            fitHeight += heightDifference * 0.5;
            
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
    }
}
}
