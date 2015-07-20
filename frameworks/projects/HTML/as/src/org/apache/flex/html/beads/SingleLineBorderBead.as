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
package org.apache.flex.html.beads
{
	import flash.display.Graphics;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStatesObject;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.utils.CSSUtils;
	import org.apache.flex.utils.SolidBorderUtil;
	import org.apache.flex.utils.StringTrimmer;

    /**
     *  The SingleLineBorderBead class draws a single line solid border.
     *  The color and thickness can be specified in CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SingleLineBorderBead implements IBead, IBorderBead, IGraphicsDrawing
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SingleLineBorderBead()
		{
		}
		
		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
            IEventDispatcher(value).addEventListener("heightChanged", changeHandler);
            IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
            IEventDispatcher(value).addEventListener("sizeChanged", changeHandler);
            changeHandler(null);
		}
		        
		private function changeHandler(event:Event):void
		{
            var host:UIBase = UIBase(_strand);
            var g:Graphics = host.graphics;
            var w:Number = host.width;
            var h:Number = host.height;
            var state:String;
            if (host is IStatesObject)
                state = IStatesObject(host).currentState;
			
			var gd:IGraphicsDrawing = _strand.getBeadByType(IGraphicsDrawing) as IGraphicsDrawing;
			if( this == gd ) g.clear();
			
            var borderColor:uint;
            var borderThickness:uint;
            var borderStyle:String;
            var borderStyles:Object = ValuesManager.valuesImpl.getValue(_strand, "border", state);
            if (borderStyles is Array)
            {
                borderColor = CSSUtils.toColor(borderStyles[2]);
                borderStyle = borderStyles[1];
                borderThickness = borderStyles[0];
            }
            else if (borderStyles is String)
                borderStyle = borderStyles as String;
            var value:Object = ValuesManager.valuesImpl.getValue(_strand, "border-style", state);
            if (value != null)
                borderStyle = value as String;
            value = ValuesManager.valuesImpl.getValue(_strand, "border-color", state);
            if (value != null)
                borderColor = CSSUtils.toColor(value);
            value = ValuesManager.valuesImpl.getValue(_strand, "border-width", state);
            if (value != null)
                borderThickness = value as uint;
            
            var borderRadius:String;
            var borderEllipseWidth:Number = NaN;
            var borderEllipseHeight:Number = NaN;
            value = ValuesManager.valuesImpl.getValue(_strand, "border-radius", state);
            if (value != null)
            {
                if (value is Number)
                    borderEllipseWidth = value as Number;
                else
                {
                    borderRadius = value as String;
                    var arr:Array = StringTrimmer.splitAndTrim(borderRadius, "/");
                    borderEllipseWidth = CSSUtils.toNumber(arr[0]);
                    if (arr.length > 1)
                        borderEllipseHeight = CSSUtils.toNumber(arr[1]);
                } 
            }
            if (borderStyle == "none")
            {
                var n:int;
                var values:Array;
                var colorTop:uint;
                var colorLeft:uint;
                var colorRight:uint;
                var colorBottom:uint;
                var widthTop:int = -1;
                var widthLeft:int = -1;
                var widthBottom:int = -1;
                var widthRight:int = -1;
                value = ValuesManager.valuesImpl.getValue(_strand, "border-top", state);
                if (value != null)
                {
                    values = value.split(" ");
                    n = values.length;
                    widthTop = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorTop = CSSUtils.toColorWithAlpha(values[2]);
                }
                value = ValuesManager.valuesImpl.getValue(_strand, "border-left", state);
                if (value != null)
                {
                    values = value.split(" ");
                    n = values.length;
                    widthLeft = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorLeft = CSSUtils.toColorWithAlpha(values[2]);
                }
                value = ValuesManager.valuesImpl.getValue(_strand, "border-bottom", state);
                if (value != null)
                {
                    values = value.split(" ");
                    n = values.length;
                    widthBottom = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorBottom = CSSUtils.toColorWithAlpha(values[2]);
                }
                value = ValuesManager.valuesImpl.getValue(_strand, "border-right", state);
                if (value != null)
                {
                    values = value.split(" ");
                    n = values.length;
                    widthRight = CSSUtils.toNumber(values[0]);
                    // assume solid for now
                    if (n > 2)
                        colorRight = CSSUtils.toColorWithAlpha(values[2]);
                }
                SolidBorderUtil.drawDetailedBorder(g, 0, 0, w, h,
                    colorTop, colorRight, colorBottom, colorLeft,
                    widthTop, widthRight, widthBottom, widthLeft);
            }
            else
            {
                borderThickness = 0;
                SolidBorderUtil.drawBorder(g, 
                    0, 0, w, h,
                    borderColor, null, borderThickness, 1,
                    borderEllipseWidth, borderEllipseHeight);
            }
		}
	}
}
