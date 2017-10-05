
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
package org.apache.royale.charts.beads
{
	import org.apache.royale.charts.core.IAxisBead;
	import org.apache.royale.charts.core.IAxisGroup;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.svg.CompoundGraphic;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.graphics.SolidColorStroke;
	
	/**
	 * The AxisBaseBead is the base class for the chart axis beads.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class AxisBaseBead implements IAxisBead
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function AxisBaseBead()
		{
			// create default dark stroke for the axis line and tick marks
			// in case they are not set otherwise.
			
			var blackLine:SolidColorStroke = new SolidColorStroke();
			blackLine.color = 0x111111;
			blackLine.weight = 1;
			blackLine.alpha = 1.0;
			
			axisStroke = blackLine;
			tickStroke = blackLine;
			
			var blackFill:SolidColor = new SolidColor();
			blackFill.color = 0x111111;
			blackFill.alpha = 1.0;
			
			tickFill = blackFill;
		}
		
		private var _strand:IStrand;
		private var wrapper:CompoundGraphic;
		private var _axisGroup:IAxisGroup;
	
		private var _placement:String = "unset";
		private var _axisStroke:IStroke;
		private var _tickStroke:IStroke;
		private var _tickFill:IFill;
		
		private var tickPathString:String = null;
		private var tickMaxWidth:Number = 0;
		private var tickMaxHeight:Number = 0;
		
		/**
		 * The placement of the axis with respect to the chart area. Valid
		 * values are: top, bottom (for IHorizontalAxisBeads), left, and right
		 * (for IVerticalAxisBeads).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get placement():String
		{
			return _placement;
		}
		public function set placement(value:String):void
		{
			_placement = value;
		}
		
		/**
		 * The stroke used to draw the line for the axis.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get axisStroke():IStroke
		{
			return _axisStroke;
		}
		public function set axisStroke(value:IStroke):void
		{
			_axisStroke = value;
		}
		
		/**
		 * The stroke used to draw each tick mark.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get tickStroke():IStroke
		{
			return _tickStroke;
		}
		public function set tickStroke(value:IStroke):void
		{
			_tickStroke = value;
		}
		
		/**
		 * The stroke used to draw each tick label.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get tickFill():IFill
		{
			return _tickFill;
		}
		public function set tickFill(value:IFill):void
		{
			_tickFill = value;
		}
		
		/**
		 * The container space for lines, tick marks, etc.
		 */
		public function get axisGroup():IAxisGroup
		{
			return _axisGroup;
		}
		public function set axisGroup(value:IAxisGroup):void
		{
			_axisGroup = value;
			
			wrapper = new CompoundGraphic();
			UIBase(_axisGroup).addElement(wrapper);
			wrapper.x = 0;
			wrapper.y = 0;
			wrapper.width = UIBase(_axisGroup).width;
			wrapper.height = UIBase(_axisGroup).height;
			COMPILE::JS {
				wrapper.element.style.position = "absolute";
				UIBase(_axisGroup).element.style.position = "absolute";
			}
		}
		
		/**
		 * @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		public function get strand():IStrand
		{
			return _strand;
		}
		
		/**
		 * Removes all graphic elements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		protected function clearGraphics():void
		{
			axisGroup.removeAllElements();
		}
		
		/**
		 * @private
		 */
		protected function drawAxisPath(originX:Number, originY:Number, xoffset:Number, yoffset:Number):void
		{
			axisGroup.drawAxisLine(originX, originY, xoffset, yoffset, axisStroke);
		}
		
		/**
		 * @private
		 */
		protected function addTickLabel(text:String, xpos:Number, ypos:Number, boxWidth:Number, boxHeight:Number):Object
		{
			var isHorizontal:Boolean = (placement == "bottom") || (placement == "top");
			
			var label:Object;
			
			if (isHorizontal) label = axisGroup.drawHorizontalTickLabel(text, xpos, ypos, boxWidth, boxHeight, tickFill);
			else label = axisGroup.drawVerticalTickLabel(text, xpos, ypos, boxWidth, boxHeight, tickFill);
			
			COMPILE::JS {
				label.element.style.position = "absolute";
			}
			
			return label;
		}
		
		/**
		 * @private
		 */
		protected function addTickMark(xpos:Number, ypos:Number, xoffset:Number, yoffset:Number):void
		{
			if (tickPathString == null) tickPathString = "";
			tickPathString = tickPathString + " M "+String(xpos)+" "+String(ypos);
			tickPathString = tickPathString + " l " + String(xoffset)+" "+String(yoffset);
			
			tickMaxWidth = Math.max(tickMaxWidth, xpos+xoffset);
			tickMaxHeight= Math.max(tickMaxHeight, ypos+yoffset);
		}
		
		/**
		 * @private
		 */
		protected function drawTickPath(originX:Number, originY:Number):void
		{
			axisGroup.drawTickMarks(originX, originY, tickMaxWidth, tickMaxHeight, tickPathString, tickStroke);
			tickPathString = null;
		}
	}
}
