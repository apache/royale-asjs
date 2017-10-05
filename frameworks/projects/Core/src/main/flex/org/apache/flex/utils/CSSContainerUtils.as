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
package org.apache.flex.utils
{
import org.apache.flex.core.ValuesManager;
import org.apache.flex.geom.Rectangle;

/**
 *  The CSSContainerUtils class is a utility class that computes the values
 *  containers often need to know like border widths and padding styles.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class CSSContainerUtils
{
    /**
     *  Compute the width/thickness of the four border edges.
     *  
     *  @param object The object with style values.
     *  @param quick True to assume all four edges have the same widths.
     *  @return A Rectangle representing the four sides.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public static function getBorderMetrics(object:Object, quick:Boolean = false):Rectangle
	{
		var borderThickness:Object = ValuesManager.valuesImpl.getValue(object, "border-width");
        var borderStyle:Object = ValuesManager.valuesImpl.getValue(object, "border-style");
        var border:Object = ValuesManager.valuesImpl.getValue(object, "border");
		var borderOffset:Number;
        if (borderStyle == "none")
            borderOffset = 0;
        else if (borderStyle != null && borderThickness != null)
        {
            if (borderThickness is String)
                borderOffset = CSSUtils.toNumber(borderThickness as String, object.width);
            else
                borderOffset = Number(borderThickness);
            if( isNaN(borderOffset) ) borderOffset = 0;            
        }
        else // no style and/or no width
        {
            border = ValuesManager.valuesImpl.getValue(object,"border");
            if (border != null)
            {
                if (border is Array)
                {
                    borderOffset = CSSUtils.toNumber(border[0], object.width);
                    borderStyle = border[1];
                }
                else if (border == "none")
                    borderOffset = 0;
                else if (border is String)
                    borderOffset = CSSUtils.toNumber(border as String, object.width);
                else
                    borderOffset = Number(border);
            }
            else // no border style set at all so default to none
                borderOffset = 0;
        }
        
        if (quick)
            return new Rectangle(borderOffset, borderOffset, 0, 0);
    
        var widthTop:int = borderOffset;
        var widthLeft:int = borderOffset;
        var widthBottom:int = borderOffset;
        var widthRight:int = borderOffset;
        var value:*;
        var values:Array;
        var n:int;
        value = ValuesManager.valuesImpl.getValue(object, "border-top");
        if (value != null)
        {
            if (value is Array)
                values = value as Array;
            else
                values = value.split(" ");
            n = values.length;
            widthTop = CSSUtils.toNumber(values[0]);
        }
        value = ValuesManager.valuesImpl.getValue(object, "border-left");
        if (value != null)
        {
            if (value is Array)
                values = value as Array;
            else
                values = value.split(" ");
            n = values.length;
            widthLeft = CSSUtils.toNumber(values[0]);
        }
        value = ValuesManager.valuesImpl.getValue(object, "border-bottom");
        if (value != null)
        {
            if (value is Array)
                values = value as Array;
            else
                values = value.split(" ");
            n = values.length;
            widthBottom = CSSUtils.toNumber(values[0]);
        }
        value = ValuesManager.valuesImpl.getValue(object, "border-right");
        if (value != null)
        {
            if (value is Array)
                values = value as Array;
            else
                values = value.split(" ");
            n = values.length;
            widthRight = CSSUtils.toNumber(values[0]);
        }
        // do the math so consumer can use
        // left, right, top, bottom properties and not width/height
        return new Rectangle(widthLeft, widthTop, widthRight - widthLeft, widthTop - widthBottom);
    }
    
    /**
     *  Compute the width/thickness of the four padding sides.
     *  
     *  @param object The object with style values.
     *  @return A Rectangle representing the padding on each of the four sides.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function getPaddingMetrics(object:Object):Rectangle
    {
		var paddingLeft:Object;
		var paddingTop:Object;
		var paddingRight:Object;
		var paddingBottom:Object;
		
		var padding:Object = ValuesManager.valuesImpl.getValue(object, "padding");
		paddingLeft = ValuesManager.valuesImpl.getValue(object, "padding-left");
		paddingTop = ValuesManager.valuesImpl.getValue(object, "padding-top");
		paddingRight = ValuesManager.valuesImpl.getValue(object, "padding-right");
		paddingBottom = ValuesManager.valuesImpl.getValue(object, "padding-bottom");
		var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, object.width);
		var pt:Number = CSSUtils.getTopValue(paddingTop, padding, object.height);
		var pr:Number = CSSUtils.getRightValue(paddingRight, padding, object.width);
		var pb:Number = CSSUtils.getBottomValue(paddingBottom, padding, object.height);
		
        // do the math so consumer can use
        // left, right, top, bottom properties and not width/height
		return new Rectangle(pl, pt, pr - pl, pb - pt);
	}


    /**
     *  Combine padding and border.  Often used in non-containers.
     *  
     *  @param object The object with style values.
     *  @return A Rectangle representing the padding and border on each of the four sides.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public static function getBorderAndPaddingMetrics(object:Object):Rectangle
    {
        var borderMetrics:Rectangle = getBorderMetrics(object);
        var paddingMetrics:Rectangle = getPaddingMetrics(object);
       return new Rectangle(borderMetrics.left + paddingMetrics.left, 
                            borderMetrics.top + paddingMetrics.top,
                            borderMetrics.width + paddingMetrics.width,
                            borderMetrics.height + paddingMetrics.height);
    }
}
}
