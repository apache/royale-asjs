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
package org.apache.flex.charts.supportClasses
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	public class WedgeItemRenderer extends DataItemRenderer implements IChartItemRenderer
	{
		public function WedgeItemRenderer()
		{
			super();
		}
		
		private var _itemRendererParent:Object;
		
		/**
		 *  The parent component of the itemRenderer instance. This is the container that houses
		 *  all of the itemRenderers for the series.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get itemRendererParent():Object
		{
			return _itemRendererParent;
		}
		public function set itemRendererParent(value:Object):void
		{
			_itemRendererParent = value;
		}
		
		private var _fillColor:uint = 0xFF0000;
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		/**
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
			var chartArea:UIBase = this.itemRendererParent as UIBase;
			var g:Graphics = chartArea.graphics;
			
			if (isNaN(yRadius))
				yRadius = radius;
			
			var segAngle:Number
			var theta:Number
			var angle:Number
			var angleMid:Number
			var segs:Number
			var ax:Number
			var ay:Number
			var bx:Number
			var by:Number
			var cx:Number
			var cy:Number;
			
			if (Math.abs(arc) > 2 * Math.PI)
				arc = 2 * Math.PI;
			
			segs = Math.ceil(Math.abs(arc) / (Math.PI / 4));
			segAngle = arc / segs;
			theta = -segAngle;
			angle = -startAngle;
			
			if (segs > 0)
			{
				ax = x + Math.cos(startAngle) * radius;
				ay = y + Math.sin(-startAngle) * yRadius;
				
				g.beginFill(fillColor);
				
				g.moveTo(x,y);
				
				if (continueFlag == true)
					g.lineTo(ax, ay);
				else
					g.moveTo(ax, ay);
				
				for (var i:uint = 0; i < segs; i++)
				{
					angle += theta;
					angleMid = angle - theta / 2;
					
					bx = x + Math.cos(angle) * radius;
					by = y + Math.sin(angle) * yRadius;
					cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
					cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
					
					g.curveTo(cx, cy, bx, by);
				}
				
				g.lineTo(x,y);
				
				g.endFill();
			}
		}
		
		/*
		 * Ignored by WedgeItemRenderer
		 */
		
		public function get xField():String
		{
			return null;
		}
		
		public function set xField(value:String):void
		{
		}
		
		public function get yField():String
		{
			return null;
		}
		
		public function set yField(value:String):void
		{
		}
	}
}