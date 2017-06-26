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
package org.apache.flex.text.engine
{
	public class ElementFormat
	{
		public function ElementFormat(fontDescription:FontDescription = null, fontSize:Number = 12.0, color:uint = 0x000000, alpha:Number = 1.0, textRotation:String = "auto", dominantBaseline:String = "roman", alignmentBaseline:String = "useDominantBaseline", baselineShift:Number = 0.0, kerning:String = "on", trackingRight:Number = 0.0, trackingLeft:Number = 0.0, locale:String = "en", breakOpportunity:String = "auto", digitCase:String = "default", digitWidth:String = "default", ligatureLevel:String = "common", typographicCase:String = "default")
		{
			this.alignmentBaseline = alignmentBaseline;
			this.alpha = alpha;
			this.baselineShift = baselineShift;
			this.breakOpportunity = breakOpportunity;
			this.color = color;
			this.digitCase = digitCase;
			this.digitWidth = digitWidth;
			this.dominantBaseline = dominantBaseline;
			this.fontDescription = fontDescription;
			this.fontSize = fontSize;
			this.kerning = kerning;
			this.ligatureLevel = ligatureLevel;
			this.locale = locale;
			this.textRotation = textRotation;
			this.trackingLeft = trackingLeft;
			this.trackingRight = trackingRight;
			this.typographicCase = typographicCase;
		}

		public var alignmentBaseline : String;
		public var alpha : Number;
		public var baselineShift : Number;
		public var breakOpportunity : String;
		public var color : uint;
		public var strokeColor : uint;
		public var strokeWeight:Number = 0;
		public var strokeAlpha:Number = 1;
		public var digitCase : String;
		public var digitWidth : String;
		public var dominantBaseline : String;
		public var fontDescription : FontDescription;
		public var fontSize : Number;
		public var kerning : String;
		public var ligatureLevel : String;
		public var locale : String;
		public var locked : Boolean;
		public var textRotation : String;
		public var trackingLeft : Number;
		public var trackingRight : Number;
		public var typographicCase : String;

 	
		public function clone():ElementFormat
		{
			return new ElementFormat(fontDescription, fontSize, color, alpha, textRotation, dominantBaseline, alignmentBaseline, baselineShift, kerning, trackingRight, trackingLeft, locale, breakOpportunity, digitCase, digitWidth, ligatureLevel, typographicCase)
		}
 	 	
		public function getFontMetrics():FontMetrics
		{
			return null;
		}
	}
}