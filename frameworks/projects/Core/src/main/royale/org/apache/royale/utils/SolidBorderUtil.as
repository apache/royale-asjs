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
package org.apache.royale.utils
{
import flash.display.Graphics;

    
/**
 *  The SolidBorderUtil class is a utility class that draws a solid color
 *  border of a specified color, thickness and alpha.  This class is used
 *  to composite Flash equivalents of JS entities and has no JS
 *  equivalent.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
COMPILE::SWF
public class SolidBorderUtil
{
    /**
     *  Draw a solid color border as specified.  Will fill with
     *  the backgroundColor if specified.  The border draws
     *  inside with given width/height.
     * 
     *  @param g The flash.display.DisplayObject#graphics
     *  @param x The x position
     *  @param y The y position
     *  @param width The width 
     *  @param height The height 
     *  @param color The color
     *  @param backgroundColor The optional fill color
     *  @param thickness The thickness of the border
     *  @param alpha The alpha
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public static function drawBorder(g:Graphics, x:Number, y:Number, 
									  width:Number, height:Number,
									  color:uint, backgroundColor:Object = null, 
									  thickness:int = 1, alpha:Number = 1.0, 
                                      ellipseWidth:Number = NaN, ellipseHeight:Number = NaN):void
	{
		g.lineStyle();  // don't draw the line, it tends to get aligned on half-pixels
		
        if (thickness > 0)
        {
            g.beginFill(color, alpha);	
            if (!isNaN(ellipseWidth))
            {
                g.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
                g.drawRoundRect(x + thickness, y + thickness, 
                    width - thickness * 2, height - thickness * 2, 
                    ellipseWidth, ellipseHeight);
            }
            else
            {
        		g.drawRect(x, y, width, height);
                g.drawRect(x + thickness, y + thickness, 
                    width - thickness * 2, height - thickness * 2);
            }
    		g.endFill();
        }
        
        if (backgroundColor != null)
        {
            g.beginFill(uint(backgroundColor), alpha);	
        
            if (!isNaN(ellipseWidth))
                g.drawRoundRect(x + thickness, y + thickness, 
                    width - thickness * 2, height - thickness * 2, 
                    ellipseWidth, ellipseHeight);
            else
                g.drawRect(x + thickness, y + thickness, 
                    width - thickness * 2, height - thickness * 2);
            g.endFill();
        }
	}
    
    /**
     *  Draw a solid color border as specified.  Only square corners
     *  are supported as the real usage for this is to handle
     *  CSS triangles.  The border is drawn around the given
     *  width and height.
     * 
     *  @param g The flash.display.DisplayObject#graphics
     *  @param x The x position
     *  @param y The y position
     *  @param width The width 
     *  @param height The height 
     *  @param colorTop The rgba color (alpha is in highest order byte)
     *  @param colorRight The rgba color
     *  @param colorBottom The rgba color
     *  @param colorLeft The rgba color
     *  @param backgroundColor The optional fill color
     *  @param thicknessTop The thickness of the border
     *  @param thicknessRight The thickness of the border
     *  @param thicknessBottom The thickness of the border
     *  @param thicknessLeft The thickness of the border
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function drawDetailedBorder(g:Graphics, x:Number, y:Number, 
                                      width:Number, height:Number,
                                      colorTop:uint, colorRight:uint, colorBottom:uint, colorLeft:uint,
                                      thicknessTop:int = 0, thicknessRight:int = 0, thicknessBottom:int = 0, thicknessLeft:int = 0  
                                      ):void
    {
        g.lineStyle();  // don't draw the line, it tends to get aligned on half-pixels
        
        var color:uint;
        var alpha:Number;
        if (thicknessTop > 0)
        {
            color = colorTop & 0xFFFFFF;
            alpha = (colorTop >>> 24 & 0xFF) / 255;
            g.beginFill(color, alpha);
            g.moveTo(0, 0);
            g.lineTo(width + thicknessRight + thicknessLeft, 0);
            if (width > 0)
                g.lineTo(width + thicknessLeft, thicknessTop);
            g.lineTo(thicknessLeft, thicknessTop);
            g.lineTo(0, 0);
            g.endFill();
        }
        if (thicknessLeft > 0)
        {
            color = colorLeft & 0xFFFFFF;
            alpha = (colorLeft >>> 24 & 0xFF) / 255;
            g.beginFill(color, alpha);
            g.moveTo(0, 0);
            g.lineTo(thicknessLeft, thicknessTop);
            if (height > 0)
                g.lineTo(thicknessLeft, thicknessTop + height);
            g.lineTo(0, height + thicknessBottom);
            g.lineTo(0, 0);
            g.endFill();
        }
        if (thicknessRight > 0)
        {
            color = colorRight & 0xFFFFFF;
            alpha = (colorRight >>> 24 & 0xFF) / 255;
            g.beginFill(color, alpha);
            g.moveTo(width + thicknessRight + thicknessLeft, 0);
            g.lineTo(width + thicknessRight + thicknessLeft, height + thicknessBottom + thicknessTop);
            if (height > 0)
                g.lineTo(width + thicknessLeft, height + thicknessTop);
            g.lineTo(width + thicknessLeft, thicknessTop);
            g.lineTo(width + thicknessRight + thicknessLeft, 0);
            g.endFill();
        }
        if (thicknessBottom > 0)
        {
            color = colorBottom & 0xFFFFFF;
            alpha = (colorBottom >>> 24 & 0xFF) / 255;
            g.beginFill(color, alpha);
            g.moveTo(0, height + thicknessBottom + thicknessTop);
            g.lineTo(thicknessLeft, height + thicknessTop);
            if (width > 0)
                g.lineTo(width + thicknessLeft, height + thicknessTop);
            g.lineTo(width + thicknessRight + thicknessLeft, height + thicknessBottom + thicknessTop);
            g.lineTo(0, height + thicknessBottom + thicknessTop);
            g.endFill();
        }
    }

}
}
