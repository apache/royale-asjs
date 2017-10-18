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
	import org.apache.royale.text.engine.FontMetrics;

    /**
     *  The FontMetrics class contains metrics specific to the font.
	 *  The information contained in this class is all located in the OS/2 font table.
     *  It is important to note that there can be two distinct uses for this class.
	 *  By default IFont has a FontMetrics which contains the raw data which is dependent on unitsPerEm.
	 *  Clients would usually need a FontMetrics which is calculated based on a specific font size.
     *  
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */    
	public class FontMetrics
	{
		public var unitsPerEm:int;
		public var emBox : Rectangle;
		public var lineGap : Number;
		public var strikethroughOffset : Number;
		public var strikethroughThickness : Number;
		public var subscriptOffset : Number;
		public var subscriptScale : Number;
		public var superscriptOffset : Number;
		public var superscriptScale : Number;
		public var underlineOffset : Number;
		public var underlineThickness : Number;
		public var ascender:Number;
		public var descender:Number;
		public var xHeight:Number;
		public var capsHeight:Number;

		public function get isScaled():Boolean
		{
			return isNaN(unitsPerEm);
		}

		/**
		 * Returns a new FontMetrics object with values scaled to the specified fontSize in points/pixels.
		 */
		public function getScaledMetrics(fontSize:Number):FontMetrics
		{
			var scale:Number = 1 / unitsPerEm * fontSize;
			var metrics:FontMetrics = new FontMetrics();
			if(emBox)
			{
				metrics.emBox = new Rectangle(emBox.x * scale, emBox.y * scale, emBox.width * scale, emBox.height * scale);
			}
			metrics.lineGap = lineGap * scale;
			metrics.strikethroughOffset = strikethroughOffset * scale;
			metrics.strikethroughThickness = strikethroughThickness * scale;
			metrics.subscriptOffset = subscriptOffset * scale;
			metrics.subscriptScale = subscriptScale * scale;
			metrics.superscriptOffset = superscriptOffset * scale;
			metrics.superscriptScale = superscriptScale * scale;
			metrics.underlineOffset = underlineOffset * scale;
			metrics.underlineThickness = underlineThickness * scale;
			metrics.ascender = ascender * scale;
			metrics.descender = descender * scale;
			metrics.xHeight = xHeight * scale;
			metrics.capsHeight = capsHeight * scale;
			return metrics;
		}
		private function getScale(fontSize:Number):Number
		{
			return 1 / unitsPerEm * fontSize;
		}
		public function clone():FontMetrics
		{
			var metrics:FontMetrics = new FontMetrics();
			if(emBox)
				metrics.emBox = emBox.clone();
			metrics.lineGap = lineGap;
			metrics.strikethroughOffset = strikethroughOffset;
			metrics.strikethroughThickness = strikethroughThickness;
			metrics.subscriptOffset = subscriptOffset;
			metrics.subscriptScale = subscriptScale;
			metrics.superscriptOffset = superscriptOffset;
			metrics.superscriptScale = superscriptScale;
			metrics.underlineOffset = underlineOffset;
			metrics.underlineThickness = underlineThickness;
			metrics.ascender = ascender;
			metrics.descender = descender;
			metrics.xHeight = xHeight;
			metrics.capsHeight = capsHeight;
			return metrics;
		}
	}
}
