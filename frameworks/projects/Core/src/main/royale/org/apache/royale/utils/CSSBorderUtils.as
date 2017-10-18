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
    import flash.display.DisplayObject;
    import flash.display.Graphics;

    import org.apache.royale.core.ValuesManager;

	/**
	 *  The CSSBorderUtils class is shared code for getting the styles
     *  regarding borders and drawing one.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
    COMPILE::SWF
	public class CSSBorderUtils
	{
		/**
		 * @private
		 */
		public function CSSBorderUtils()
		{
			throw new Error("CSSBorderUtils should not be instantiated.");
		}
		
        /**
         *  Get the related styles and draw a border
         *
         *  @param g The flash.display.Graphics to draw into. 
         *  @param width The width.
         *  @param height The height.
         *  @param host The object to pull styles from. 
         *  @param state The pseudo-state, if any. 
         *  @param drawBackground True if area inside border should be filled with backgroundColor. 
         *  @param clear True if graphics.clear() should be called. 
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static function draw(g:Graphics, width:Number, height:Number,
                                    host:Object, state:String = null, 
                                    drawBackground:Boolean = false, clear:Boolean = true):void
        {            
            if (clear)
                g.clear();
            
            var needBorderColor:Boolean = true;
            var borderColor:uint;
            var borderThickness:uint = 0;
            var borderStyle:String = "none";
            var borderStyles:Object = ValuesManager.valuesImpl.getValue(host, "border", state);
            if (borderStyles is Array)
            {
                borderColor = CSSUtils.toColor(borderStyles[2]);
                borderStyle = borderStyles[1];
                borderThickness = borderStyles[0];
                needBorderColor = false;
            }
            else if (borderStyles is String)
                borderStyle = borderStyles as String;
            var value:Object = ValuesManager.valuesImpl.getValue(host, "border-style", state);
            if (value != null)
                borderStyle = value as String;
            value = ValuesManager.valuesImpl.getValue(host, "border-color", state);
            if (value != null)
                borderColor = CSSUtils.toColor(value);
            else if (needBorderColor)
            {
                value = ValuesManager.valuesImpl.getValue(host, "color", state);
                if (value != null)
                    borderColor = CSSUtils.toColor(value);                
            }
            // if alpha = 0; assume that alpha just wasn't specified
            if ((borderColor & 0xFF000000) == 0)
                borderColor = borderColor | 0xFF000000;
            value = ValuesManager.valuesImpl.getValue(host, "border-width", state);
            if (value != null)
                borderThickness = value as uint;
            
            var borderRadius:String;
            var borderEllipseWidth:Number = NaN;
            var borderEllipseHeight:Number = NaN;
            value = ValuesManager.valuesImpl.getValue(host, "border-radius", state);
            if (value != null)
            {
                if (value is Number)
                    borderEllipseWidth = 2 * (value as Number);
                else
                {
                    borderRadius = value as String;
                    var arr:Array = StringTrimmer.splitAndTrim(borderRadius, "/");
                    borderEllipseWidth = 2 * CSSUtils.toNumber(arr[0]);
                    if (arr.length > 1)
                        borderEllipseHeight = 2 * CSSUtils.toNumber(arr[1]);
                } 
            }
            if (borderStyle == "none" && isNaN(borderEllipseWidth))
            {
                var n:int;
                var values:Array;
                var colorTop:uint;
                var colorLeft:uint;
                var colorRight:uint;
                var colorBottom:uint;
                var widthTop:int = 0;
                var widthLeft:int = 0;
                var widthBottom:int = 0;
                var widthRight:int = 0;
                value = ValuesManager.valuesImpl.getValue(host, "border-top", state);
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    widthTop = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorTop = CSSUtils.toColorWithAlpha(values[2]);
                    else
                        colorTop = borderColor;
                }
                value = ValuesManager.valuesImpl.getValue(host, "border-left", state);
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    widthLeft = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorLeft = CSSUtils.toColorWithAlpha(values[2]);
                    else
                        colorLeft = borderColor;
                }
                value = ValuesManager.valuesImpl.getValue(host, "border-bottom", state);
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    widthBottom = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorBottom = CSSUtils.toColorWithAlpha(values[2]);
                    else
                        colorBottom = borderColor;
                }
                value = ValuesManager.valuesImpl.getValue(host, "border-right", state);
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    widthRight = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorRight = CSSUtils.toColorWithAlpha(values[2]);
                    else
                        colorRight = borderColor;
                }
                SolidBorderUtil.drawDetailedBorder(g, 0, 0, width, height,
                    colorTop, colorRight, colorBottom, colorLeft,
                    widthTop, widthRight, widthBottom, widthLeft);
            }
            else
            {
                if (borderStyle == "none")
                    borderThickness = 0;
                var backgroundColor:Object = null;
                if (drawBackground)
                {
                    value = ValuesManager.valuesImpl.getValue(host, "background-color", state);
                    if (value != null)
                        backgroundColor = CSSUtils.toColorWithAlpha(value);
                }
                SolidBorderUtil.drawBorder(g, 
                    0, 0, width, height,
                    borderColor & 0xFFFFFF, backgroundColor, borderThickness, borderColor >>> 24 / 255,
                    borderEllipseWidth, borderEllipseHeight);
            }
            
        }

    }
}
