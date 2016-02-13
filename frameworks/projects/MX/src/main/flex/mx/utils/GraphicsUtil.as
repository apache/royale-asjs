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

package mx.utils
{

import flash.display.Graphics;

/**
 *  The Graphics class is an all-static class with utility methods
 *  related to the Graphics class.
 *  You do not create instances of GraphicsUtil;
 *  instead you simply call methods such as the
 *  <code>GraphicsUtil.drawRoundRectComplex()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class GraphicsUtil
{
	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
    
    /**
     * Draws a rounded rectangle using the size of a radius to draw the rounded corners. 
     * You must set the line style, fill, or both 
     * on the Graphics object before 
     * you call the <code>drawRoundRectComplex()</code> method 
     * by calling the <code>linestyle()</code>, 
     * <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
     * <code>beginGradientFill()</code>, or 
     * <code>beginBitmapFill()</code> method.
     * 
     * @param graphics The Graphics object that draws the rounded rectangle.
     *
     * @param x The horizontal position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param y The vertical position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param width The width of the round rectangle, in pixels.
     * 
     * @param height The height of the round rectangle, in pixels.
     * 
     * @param topLeftRadius The radius of the upper-left corner, in pixels.
     * 
     * @param topRightRadius The radius of the upper-right corner, in pixels.
     * 
     * @param bottomLeftRadius The radius of the bottom-left corner, in pixels.
     * 
     * @param bottomRightRadius The radius of the bottom-right corner, in pixels.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                topLeftRadius:Number, topRightRadius:Number, 
                                                bottomLeftRadius:Number, bottomRightRadius:Number):void
    {
        var xw:Number = x + width;
        var yh:Number = y + height;
        
        // Make sure none of the radius values are greater than w/h.
        // These are all inlined to avoid function calling overhead
        var minSize:Number = width < height ? width * 2 : height * 2;
        topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
        topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
        bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
        bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
        
        // Math.sin and Math,tan values for optimal performance.
        // Math.rad = Math.PI / 180 = 0.0174532925199433
        // r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
        // r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
        //
        // We can save further cycles by precalculating
        // 1.0 - 0.707106781186547 = 0.292893218813453 and
        // 1.0 - 0.414213562373095 = 0.585786437626905
        
        // bottom-right corner
        var a:Number = bottomRightRadius * 0.292893218813453;		// radius - anchor pt;
        var s:Number = bottomRightRadius * 0.585786437626905; 	// radius - control pt;
        graphics.moveTo(xw, yh - bottomRightRadius);
        graphics.curveTo(xw, yh - s, xw - a, yh - a);
        graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
        
        // bottom-left corner
        a = bottomLeftRadius * 0.292893218813453;
        s = bottomLeftRadius * 0.585786437626905;
        graphics.lineTo(x + bottomLeftRadius, yh);
        graphics.curveTo(x + s, yh, x + a, yh - a);
        graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
        
        // top-left corner
        a = topLeftRadius * 0.292893218813453;
        s = topLeftRadius * 0.585786437626905;
        graphics.lineTo(x, y + topLeftRadius);
        graphics.curveTo(x, y + s, x + a, y + a);
        graphics.curveTo(x + s, y, x + topLeftRadius, y);
        
        // top-right corner
        a = topRightRadius * 0.292893218813453;
        s = topRightRadius * 0.585786437626905;
        graphics.lineTo(xw - topRightRadius, y);
        graphics.curveTo(xw - s, y, xw - a, y + a);
        graphics.curveTo(xw, y + s, xw, y + topRightRadius);
        graphics.lineTo(xw, yh - bottomRightRadius);
    }
    
    /**
     * Draws a rounded rectangle using the size of individual x and y radii to 
     * draw the rounded corners. 
     * You must set the line style, fill, or both 
     * on the Graphics object before 
     * you call the <code>drawRoundRectComplex2()</code> method 
     * by calling the <code>linestyle()</code>, 
     * <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
     * <code>beginGradientFill()</code>, or 
     * <code>beginBitmapFill()</code> method.
     * 
     * @param graphics The Graphics object that draws the rounded rectangle.
     *
     * @param x The horizontal position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param y The vertical position relative to the 
     * registration point of the parent display object, in pixels.
     * 
     * @param width The width of the round rectangle, in pixels.
     * 
     * @param height The height of the round rectangle, in pixels.
     * 
     * @param radiusX The default radiusX to use, if corner-specific values are not specified.
     * This value must be specified.
     * 
     * @param radiusY The default radiusY to use, if corner-specific values are not specified. 
     * If 0, the value of radiusX is used.
     * 
     * @param topLeftRadiusX The x radius of the upper-left corner, in pixels. If NaN, 
     * the value of radiusX is used.
     * 
     * @param topLeftRadiusY The y radius of the upper-left corner, in pixels. If NaN,
     * the value of topLeftRadiusX is used.
     * 
     * @param topRightRadiusX The x radius of the upper-right corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param topRightRadiusY The y radius of the upper-right corner, in pixels. If NaN,
     * the value of topRightRadiusX is used.
     * 
     * @param bottomLeftRadiusX The x radius of the bottom-left corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param bottomLeftRadiusY The y radius of the bottom-left corner, in pixels. If NaN,
     * the value of bottomLeftRadiusX is used.
     * 
     * @param bottomRightRadiusX The x radius of the bottom-right corner, in pixels. If NaN,
     * the value of radiusX is used.
     * 
     * @param bottomRightRadiusY The y radius of the bottom-right corner, in pixels. If NaN,
     * the value of bottomRightRadiusX is used.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function drawRoundRectComplex2(graphics:Graphics, x:Number, y:Number, 
                                                width:Number, height:Number, 
                                                radiusX:Number, radiusY:Number,
                                                topLeftRadiusX:Number, topLeftRadiusY:Number,
                                                topRightRadiusX:Number, topRightRadiusY:Number,
                                                bottomLeftRadiusX:Number, bottomLeftRadiusY:Number,
                                                bottomRightRadiusX:Number, bottomRightRadiusY:Number):void
    {
        var xw:Number = x + width;
        var yh:Number = y + height;
        var maxXRadius:Number = width / 2;
        var maxYRadius:Number = height / 2;
        
        // Rules for determining radius for each corner:
        //  - If explicit nnnRadiusX value is set, use it. Otherwise use radiusX.
        //  - If explicit nnnRadiusY value is set, use it. Otherwise use corresponding nnnRadiusX.
        if (radiusY == 0)
            radiusY = radiusX;
        if (isNaN(topLeftRadiusX))
            topLeftRadiusX = radiusX;
        if (isNaN(topLeftRadiusY))
            topLeftRadiusY = topLeftRadiusX;
        if (isNaN(topRightRadiusX))
            topRightRadiusX = radiusX;
        if (isNaN(topRightRadiusY))
            topRightRadiusY = topRightRadiusX;
        if (isNaN(bottomLeftRadiusX))
            bottomLeftRadiusX = radiusX;
        if (isNaN(bottomLeftRadiusY))
            bottomLeftRadiusY = bottomLeftRadiusX;
        if (isNaN(bottomRightRadiusX))
            bottomRightRadiusX = radiusX;
        if (isNaN(bottomRightRadiusY))
            bottomRightRadiusY = bottomRightRadiusX;
        
        // Pin radius values to half of the width/height
        if (topLeftRadiusX > maxXRadius)
            topLeftRadiusX = maxXRadius;
        if (topLeftRadiusY > maxYRadius)
            topLeftRadiusY = maxYRadius;
        if (topRightRadiusX > maxXRadius)
            topRightRadiusX = maxXRadius;
        if (topRightRadiusY > maxYRadius)
            topRightRadiusY = maxYRadius;
        if (bottomLeftRadiusX > maxXRadius)
            bottomLeftRadiusX = maxXRadius;
        if (bottomLeftRadiusY > maxYRadius)
            bottomLeftRadiusY = maxYRadius;
        if (bottomRightRadiusX > maxXRadius)
            bottomRightRadiusX = maxXRadius;
        if (bottomRightRadiusY > maxYRadius)
            bottomRightRadiusY = maxYRadius;
        
        // Math.sin and Math,tan values for optimal performance.
        // Math.rad = Math.PI / 180 = 0.0174532925199433
        // r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
        // r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
        //
        // We can save further cycles by precalculating
        // 1.0 - 0.707106781186547 = 0.292893218813453 and
        // 1.0 - 0.414213562373095 = 0.585786437626905
        
        // bottom-right corner
        var aX:Number = bottomRightRadiusX * 0.292893218813453;		// radius - anchor pt;
        var aY:Number = bottomRightRadiusY * 0.292893218813453;		// radius - anchor pt;
        var sX:Number = bottomRightRadiusX * 0.585786437626905; 	// radius - control pt;
        var sY:Number = bottomRightRadiusY * 0.585786437626905; 	// radius - control pt;
        graphics.moveTo(xw, yh - bottomRightRadiusY);
        graphics.curveTo(xw, yh - sY, xw - aX, yh - aY);
        graphics.curveTo(xw - sX, yh, xw - bottomRightRadiusX, yh);
        
        // bottom-left corner
        aX = bottomLeftRadiusX * 0.292893218813453;
        aY = bottomLeftRadiusY * 0.292893218813453;
        sX = bottomLeftRadiusX * 0.585786437626905;
        sY = bottomLeftRadiusY * 0.585786437626905;
        graphics.lineTo(x + bottomLeftRadiusX, yh);
        graphics.curveTo(x + sX, yh, x + aX, yh - aY);
        graphics.curveTo(x, yh - sY, x, yh - bottomLeftRadiusY);
        
        // top-left corner
        aX = topLeftRadiusX * 0.292893218813453;
        aY = topLeftRadiusY * 0.292893218813453;
        sX = topLeftRadiusX * 0.585786437626905;
        sY = topLeftRadiusY * 0.585786437626905;
        graphics.lineTo(x, y + topLeftRadiusY);
        graphics.curveTo(x, y + sY, x + aX, y + aY);
        graphics.curveTo(x + sX, y, x + topLeftRadiusX, y);
        
        // top-right corner
        aX = topRightRadiusX * 0.292893218813453;
        aY = topRightRadiusY * 0.292893218813453;
        sX = topRightRadiusX * 0.585786437626905;
        sY = topRightRadiusY * 0.585786437626905;
        graphics.lineTo(xw - topRightRadiusX, y);
        graphics.curveTo(xw - sX, y, xw - aX, y + aY);
        graphics.curveTo(xw, y + sY, xw, y + topRightRadiusY);
        graphics.lineTo(xw, yh - bottomRightRadiusY);
    }
}

}
