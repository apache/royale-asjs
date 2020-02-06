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
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.svg.Path;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.charts.supportClasses.ChartItemRenderer;
    import org.apache.royale.charts.supportClasses.ILineSegmentItemRenderer;
	
	/**
	 *  The SVGLineSegmentItemRenderer draws its graphics directly into a SVGChartDataGroup (a
	 *  CompoundGraphic).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SVGLineSegmentItemRenderer extends ChartItemRenderer implements ILineSegmentItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SVGLineSegmentItemRenderer()
		{
			super();
		}
				
		private var _points:Array;
		
		/**
		 *  The points of the vertices. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get points():Array
		{
			return _points;
		}
		public function set points(value:Array):void
		{
			_points = value;
			drawLine();
		}
		
		private var _stroke:IStroke;
		
		public function get stroke():IStroke
		{
			return _stroke;
		}
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
			drawLine();
		}
		
		
		private var _fillColor:uint;
		
		/**
		 *  The color used to fill the interior of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get fillColor():uint
		{
			return _fillColor;
		}
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		/**
		 *  @private
		 */
		protected function drawLine():void
		{			
			if (points != null)
			{
				var graphicsContainer:CompoundGraphic = this.itemRendererOwnerView as CompoundGraphic;
				
				if (stroke == null) {
					var solidColorStroke:SolidColorStroke = new SolidColorStroke();
					solidColorStroke.color = 0x000088;
					solidColorStroke.weight = 1;
					solidColorStroke.alpha = 1;
					_stroke = solidColorStroke;
				}
				
				graphicsContainer.stroke = stroke;
				graphicsContainer.fill = null;
				
				var pathString:String = "";
				
				for (var i:int=0; i < points.length; i++) {
					var point:Object = points[i];
					if (i == 0) pathString += "M "+point.x+" "+point.y+" ";
					else pathString += "L "+point.x+" "+point.y+" ";
				}
				
				graphicsContainer.drawStringPath(pathString);
			}
		}
	}
}
