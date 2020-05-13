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
package org.apache.royale.charts.supportClasses
{	
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.core.IBead;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.svg.Path;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.svg.LinearGradient;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	
	/**
	 *  The WedgeItemRenderer draws a single slide of a PieSeries. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class WedgeItemRenderer extends ChartItemRenderer implements IWedgeItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function WedgeItemRenderer()
		{
			super();
		}
		
		private var filledPath:Path;
		
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
			var needsAdd:Boolean = false;
			
			if (filledPath == null) {
				filledPath = new Path();
				needsAdd = true;
			}
			
			var x1:Number = x + radius * Math.cos(startAngle);
			var y1:Number = y + radius * Math.sin(startAngle);
			var x2:Number = x + radius * Math.cos(startAngle + arc);
			var y2:Number = y + radius * Math.sin(startAngle + arc);
			
			var pathString:String = 'M' + x + ' ' + y + ' L' + x1 + ' ' + y1 + ' A' + radius + ' ' + radius +
				' 0 0 1 ' + x2 + ' ' + y2 + ' z';
			
			filledPath.fill = fill;
			filledPath.stroke = stroke;
			filledPath.x = 0;
			filledPath.y = 0;
			filledPath.data = pathString;
			
			if (needsAdd) {	
				addElement(filledPath);
			}
		}
		
		private var hoverFill:IFill;
		
		override public function updateRenderer():void
		{				
            drawWedgeInternal();
            
            if (!filledPath) return; // too early
            
			if (selectionBead.down || selectionBead.selected || selectionBead.hovered) {
				if (hoverFill == null) {
					if(fill is SolidColor)
					{
						hoverFill = new SolidColor();
						(hoverFill as SolidColor).color = (fill as SolidColor).color;
						(hoverFill as SolidColor).alpha = 0.65;
					}
					else if(fill is LinearGradient)
					{
						hoverFill = new LinearGradient();
						(hoverFill as LinearGradient).entries = (fill as LinearGradient).entries;
						for (var i:int=0; i<(hoverFill as LinearGradient).entries; i++)
						{
							(hoverFill as LinearGradient).entries[i].alpha = 0.65;
						}
					}
				}
				filledPath.fill = hoverFill;
			}
			else {
				filledPath.fill = fill;
			}
			
			filledPath.drawStringPath(0, 0, filledPath.data);
		}
		
	}
}
