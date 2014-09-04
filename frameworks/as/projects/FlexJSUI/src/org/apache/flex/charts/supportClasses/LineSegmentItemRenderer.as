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
	import flash.display.Shape;
	
	import org.apache.flex.core.FilledRectangle;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	public class LineSegmentItemRenderer extends DataItemRenderer
	{
		public function LineSegmentItemRenderer()
		{
			super();
		}
		
		private var filledRect:FilledRectangle;
		
		private var _points:Array;
		
		public function get points():Array
		{
			return _points;
		}
		public function set points(value:Array):void
		{
			_points = value;
			
			if (shape == null) {
				shape = new Shape();
				addElement(shape);
			}
			
			drawLine();
		}
		
		private var shape:Shape;
		
		private var _lineColor:uint = 0xFF0000;
		
		/**
		 *  The color used to draw the line segments
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get lineColor():uint
		{
			return _lineColor;
		}
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
		
		private var _lineThickness:int = 1;
		
		/**
		 *  The thickness or weight of the line segments
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get lineThickness():int
		{
			return _lineThickness;
		}
		public function set lineThickness(value:int):void
		{
			_lineThickness = value;
		}
		
		/**
		 *  @copy org.apache.flex.supportClasses.UIItemRendererBase#data
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;		
			
			if (shape == null) {
				shape = new Shape();
				addElement(shape);
			}	
//			if (filledRect == null) {
//				filledRect = new FilledRectangle();
//				addElement(filledRect);
//			}
		}
		
		/**
		 *  @private
		 */
		protected function drawLine():void
		{
//			if (filledRect) {
//				filledRect.fillColor = fillColor;
//				filledRect.drawRect(0,0,this.width,this.height);
//			}
//			if (shape && (!isNaN(x)) && (!isNaN(y)) && (!isNaN(x2)) && (!isNaN(y2))) {
//				shape.graphics.clear();
//				shape.graphics.lineStyle(1,fillColor,1);
//				shape.graphics.moveTo(0,0);
//				shape.graphics.lineTo(x2-x,y2-y);
//			}
			if (shape != null && points != null)
			{
				shape.graphics.clear();
				shape.graphics.lineStyle(lineThickness,lineColor,1);
				
				for (var i:int=0; i < points.length; i++) {
					var point:Object = points[i];
					if (i == 0) shape.graphics.moveTo(point.x,point.y);
					else shape.graphics.lineTo(point.x,point.y);
				}
			}
		}
	}
}