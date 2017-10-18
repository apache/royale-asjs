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
package org.apache.royale.charts.optimized
{
	import org.apache.royale.charts.core.IAxisGroup;
	import org.apache.royale.svg.CompoundGraphic;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	
	/**
	 * The SVGChartAxisGroup provides a CompoundGraphic whose drawing functions
	 * can be used to display a chart's axis graphics without resorting to the
	 * creation of extra objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SVGChartAxisGroup extends CompoundGraphic implements IAxisGroup
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SVGChartAxisGroup()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
		}
		
		/**
		 * Draws a horizontal tick label centered in the box at the given position.
		 * 
		 * @param text The label to display.
		 * @param xpos The x position of the label's upper left corner.
		 * @param ypos The y position of the label's upper left corner.
		 * @param boxWith The size of the box into which the label should be drawn.
		 * @param boxHeight The size of the box into which the label should be drawn.
		 * @param tickFill A fill to use to display the label.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function drawHorizontalTickLabel( text:String, xpos:Number, ypos:Number, boxWidth:Number, boxHeight:Number, tickFill:IFill ):Object
		{
			fill = tickFill;
			return drawText(text, xpos-boxWidth/2, ypos);
		}
		
		/**
		 * Draws a vertical tick label centered in the box at the given position.
		 * 
		 * @param text The label to display.
		 * @param xpos The x position of the label's upper left corner.
		 * @param ypos The y position of the label's upper left corner.
		 * @param boxWith The size of the box into which the label should be drawn.
		 * @param boxHeight The size of the box into which the label should be drawn.
		 * @param tickFill A fill to use to display the label.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function drawVerticalTickLabel( text:String, xpos:Number, ypos:Number, boxWidth:Number, boxHeight:Number, tickFill:IFill ):Object
		{
			fill = tickFill;
			return drawText(text, xpos, ypos-boxHeight/4);
		}
		
		/**
		 * Draws an set of tick marks are determined in the marks path.
		 * 
		 * @param originX The upper left corner of the space into which the tick marks are drawn.
		 * @param originY The upper left corner of the space into which the tick marks are drawn.
		 * @param width The size of the box into which the tick marks are drawn.
		 * @param height The size of the box into which the tick marks are drawn.
		 * @param tickStroke The stroke to use to display the tick marks.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function drawTickMarks( originX:Number, originY:Number, width:Number, height:Number, marks:String, tickStroke:IStroke ):void
		{
			stroke = tickStroke;
			drawStringPath(marks);
		}
		
		/**
		 * Draws the axis line at the given position.
		 * 
		 * @param originX The upper left corner of the space into which the axis line is drawn.
		 * @param originY The upper left corner of the space into which the axis line is drawn.
		 * @param width The size of the box into which the line is drawn.
		 * @param height The size of the box into which the line is drawn.
		 * @param lineStroke The stroke to use to display the line.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function drawAxisLine( originX:Number, originY:Number, width:Number, height:Number, lineStroke:IStroke ):void
		{
			stroke = lineStroke;
			var pathLine:String = "M " + String(originX) + " " + String(originY) + " l "+String(width)+" "+String(height);
			drawStringPath(pathLine);
		}
	}
}
