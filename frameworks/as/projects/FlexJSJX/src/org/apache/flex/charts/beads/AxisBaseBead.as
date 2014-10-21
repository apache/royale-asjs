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
package org.apache.flex.charts.beads
{
	import org.apache.flex.charts.core.IAxisBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.graphics.IStroke;
	import org.apache.flex.core.graphics.Path;
	import org.apache.flex.core.graphics.SolidColorStroke;
	
	public class AxisBaseBead implements IAxisBead
	{
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
		}
		
		private var _placement:String = "unset";
		
		/**
		 * The placement of the axis with respect to the chart area. Valid
		 * values are: top, bottom (for IHorizontalAxisBeads), left, and right
		 * (for IVerticalAxisBeads).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get placement():String
		{
			return _placement;
		}
		public function set placement(value:String):void
		{
			_placement = value;
		}
		
		private var _axisStroke:IStroke;
		
		/**
		 * The stroke used to draw the line for the axis.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get axisStroke():IStroke
		{
			return _axisStroke;
		}
		public function set axisStroke(value:IStroke):void
		{
			_axisStroke = value;
		}
		
		private var _tickStroke:IStroke;
		
		/**
		 * The stroke used to draw each tick mark.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get tickStroke():IStroke
		{
			return _tickStroke;
		}
		public function set tickStroke(value:IStroke):void
		{
			_tickStroke = value;
		}
		
		private var _strand:IStrand;
		
		/**
		 * @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		public function get strand():IStrand
		{
			return _strand;
		}
		
		protected function drawAxisPath(originX:Number, originY:Number, xoffset:Number, yoffset:Number):Path
		{
			var axisPath:Path = new Path();
			// set (x,y) before adding as element to set the location correctly
			axisPath.x = originX;
			axisPath.y = originY;
			axisPath.width = 1+xoffset;
			axisPath.height = 1+yoffset;
			UIBase(strand).addElement(axisPath);
			axisPath.stroke = axisStroke;
			var pathLine:String = "M 0 0 l "+String(xoffset)+" "+String(yoffset);
			axisPath.drawPath(0, 0, pathLine);
			
			return axisPath;
		}
		
		private var tickPathString:String = null;
		private var tickMaxWidth:Number = 0;
		private var tickMaxHeight:Number = 0;
		
		protected function addTickMark(xpos:Number, ypos:Number, xoffset:Number, yoffset:Number):void
		{
			if (tickPathString == null) tickPathString = "";
			tickPathString = tickPathString + " M "+String(xpos)+" "+String(ypos);
			tickPathString = tickPathString + " l " + String(xoffset)+" "+String(yoffset);
			
			tickMaxWidth = Math.max(tickMaxWidth, xpos+xoffset);
			tickMaxHeight= Math.max(tickMaxHeight, ypos+yoffset);
		}
		
		protected function drawTickPath(originX:Number, originY:Number):void
		{
			var tickPath:Path = new Path();
			// set (x,y) before adding as element to set the location correctly
			tickPath.x = originX;
			tickPath.y = originY;
			tickPath.width = tickMaxWidth;
			tickPath.height = tickMaxHeight;
			UIBase(strand).addElement(tickPath);
			tickPath.stroke = tickStroke;
			tickPath.drawPath( 0, 0, tickPathString );
			
			tickPathString = null;
		}
	}
}