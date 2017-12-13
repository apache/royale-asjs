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
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.svg.CompoundGraphic;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.svg.Path;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.charts.supportClasses.IWedgeItemRenderer;
	
	/**
	 *  The SVGWedgeItemRenderer draws its graphics directly into a SVGChartDataGroup
	 *  (a CompoundGraphic).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SVGWedgeItemRenderer extends DataItemRenderer implements IWedgeItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SVGWedgeItemRenderer()
		{
			super();
		}
		
		private var _series:IChartSeries;
		
		/**
		 *  The series to which this itemRenderer instance belongs. Or, the series
		 *  being presented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get series():IChartSeries
		{
			return _series;
		}
		public function set series(value:IChartSeries):void
		{
			_series = value;
		}
		
		private var _centerX:Number;
		
		/**
		 *  The X coordinate of the center of the pie. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get centerX():Number
		{
			return _centerX;
		}
		public function set centerX(value:Number):void
		{
			_centerX = value;
			drawWedgeInternal();
		}
		
		private var _centerY:Number;
		
		/**
		 *  The Y coordinate of the center of the pie. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get centerY():Number
		{
			return _centerY;
		}
		public function set centerY(value:Number):void
		{
			_centerY = value;
			drawWedgeInternal();
		}
		
		private var _startAngle:Number;
		
		/**
		 *  The starting angle (radians) of the wedge. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get startAngle():Number
		{
			return _startAngle;
		}
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			drawWedgeInternal();
		}
		
		private var _arc:Number;
		
		/**
		 *  The sweep (radians) of the wedge, relative to the startAngle. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get arc():Number
		{
			return _arc;
		}
		public function set arc(value:Number):void
		{
			_arc = value;
			drawWedgeInternal();
		}
		
		private var _radius:Number;
		
		/**
		 *  The radius of the pie. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(value:Number):void
		{
			_radius = value;
			drawWedgeInternal();
		}
		
		private var _fill:IFill;
		
		/**
		 *  The color used to fill the interior of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get fill():IFill
		{
			return _fill;
		}
		public function set fill(value:IFill):void
		{
			_fill = value;
		}
		
		private var _stroke:IStroke;
		
		/**
		 *  The outline of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get stroke():IStroke
		{
			return _stroke;
		}
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}
		
		/**
		 * @private
		 */
		private function drawWedgeInternal():void
		{
			if ( !isNaN(centerX) && !isNaN(centerY) && !isNaN(startAngle) && !isNaN(arc) && !isNaN(radius) ) {
				drawWedge(centerX, centerY, startAngle, arc, radius, radius, false);
			}
		}
		
		/**
		 * @private
		 * 
		 * Draw a wedge of a circle
		 * @param graphics      the graphics object to draw into
		 * @param x             the x center of the circle
		 * @param y             the y center of the circle
		 * @param startAngle    start angle (radians)
		 * @param arc           sweep angle (radians)
		 * @param radius        radius of the circle
		 * @param yRadius       vertical radius (or radius if none given)
		 * @param continueFlag  if true, uses a moveTo call to start drawing at the start point of the circle; else continues drawing using only lineTo and curveTo
		 * 
		 */			
		public function drawWedge(x:Number, y:Number,
								  startAngle:Number, arc:Number,
								  radius:Number, yRadius:Number = NaN,
								  continueFlag:Boolean = false):void
		{			
			var graphicsContainer:CompoundGraphic = this.itemRendererParent as CompoundGraphic;
			
			var x1:Number = x + radius * Math.cos(startAngle);
			var y1:Number = y + radius * Math.sin(startAngle);
			var x2:Number = x + radius * Math.cos(startAngle + arc);
			var y2:Number = y + radius * Math.sin(startAngle + arc);
			
			var pathString:String = 'M' + x + ' ' + y + ' L' + x1 + ' ' + y1 + ' A' + radius + ' ' + radius +
				' 0 0 1 ' + x2 + ' ' + y2 + ' z';
			
			graphicsContainer.fill = fill;
			graphicsContainer.stroke = stroke;
			graphicsContainer.drawStringPath(pathString);
		}
		
		/*
		* Ignored by WedgeItemRenderer
		*/
		
		/**
		 * @private
		 */
		public function get xField():String
		{
			return null;
		}
		public function set xField(value:String):void
		{
		}
		
		/**
		 * @private
		 */
		public function get yField():String
		{
			return null;
		}
		public function set yField(value:String):void
		{
		}
	}
}
