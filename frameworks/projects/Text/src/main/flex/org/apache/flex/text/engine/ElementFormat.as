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
package org.apache.royale.text.engine
{
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.text.engine.IFont;
	import org.apache.royale.text.engine.FontMetrics;
	
	public class ElementFormat
	{
		public function ElementFormat()
		{
		}

		public var alignmentBaseline:String ="useDominantBaseline";
		public var alpha:Number = 1;
		public var baselineShift:Number = 0;
		public var breakOpportunity:String = "auto";
		public var color:uint = 0;
		public var strokeColor:uint = 0;
		public var strokeWeight:Number = 0;
		public var strokeAlpha:Number = 1;
		public var digitCase:String = "default";
		public var digitWidth:String = "default";
		public var dominantBaseline:String = "roman";
		public var fontDescription:FontDescription;
		public var fontSize:Number = 12;
		public var kerning:String = "on";
		public var ligatureLevel:String = "common";
		public var locale:String = "en";
		public var locked:Boolean;
		public var textRotation:String = "auto";
		public var trackingLeft:Number = 0;
		public var trackingRight:Number = 0;
		public var typographicCase:String = "default";
		public var xScale:Number = 1;
		public var yScale:Number = 1;

 	
		public function clone():ElementFormat
		{
			var val:ElementFormat = new ElementFormat();
			val.alignmentBaseline = alignmentBaseline;
			val.alpha = alpha;
			val.baselineShift = baselineShift;
			val.breakOpportunity = breakOpportunity;
			val.color = color;
			val.strokeColor = strokeColor;
			val.strokeWeight = strokeWeight;
			val.strokeAlpha = strokeAlpha;
			val.digitCase = digitCase;
			val.digitWidth = digitWidth;
			val.dominantBaseline = dominantBaseline;
			val.fontDescription = fontDescription;
			val.fontSize = fontSize;
			val.kerning = kerning;
			val.ligatureLevel = ligatureLevel;
			val.locale = locale;
			val.locked = locked;
			val.textRotation = textRotation;
			val.trackingLeft = trackingLeft;
			val.trackingRight = trackingRight;
			val.typographicCase = typographicCase;
			val.xScale = xScale;
			val.yScale = yScale;
			return val;
		}
 	 	
		public function getFontMetrics():FontMetrics
		{
			assert(fontDescription != null,"fontDescription not assigned!");
            if (fontDescription.fontLoader)
    			return fontDescription.fontLoader.getFont(fontDescription.fontName,fontDescription.fontStyle).fontMetrics.clone();
            else
            {
                var fm:FontMetrics = new FontMetrics();
                // just a guess for now
                fm.emBox = new Rectangle(0, 1.2 - fontSize, fontSize, 1.2);
                return fm;                
            }
		}
	}
}
