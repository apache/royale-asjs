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
	import org.apache.flex.core.graphics.Path;
	import org.apache.flex.core.graphics.SolidColorStroke;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	/**
	 *  The LineSegmentItemRenderer class draws a line between the vertices of a LineSeries. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class LineSegmentItemRenderer extends DataItemRenderer implements ILineSegmentItemRenderer
	{
		public function LineSegmentItemRenderer()
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
		 *  @productversion FlexJS 0.0
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
		
		private var path:Path;
		
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
		}
		
		/**
		 *  The name of the field containing the value for the Y axis. This is not implemented by this class.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get yField():String
		{
			return null;
		}
		public function set yField(value:String):void
		{
		}
		
		/**
		 *  The name of the field containing the value for the X axis. This is not implemented by this class.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get xField():String
		{
			return null;
		}
		public function set xField(value:String):void
		{
		}
		
		private var _fillColor:uint;
		
		/**
		 *  The color used to fill the interior of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
			var needsAddElement:Boolean = false;
			
			if (points != null)
			{
				if (path == null) {
					path = new Path();
					needsAddElement = true;
				}
				
				var stroke:SolidColorStroke = new SolidColorStroke();
				stroke.color = lineColor;
				stroke.weight = lineThickness;
				path.stroke = stroke;
				path.fill = null;
				
				var pathString:String = "";
				
				for (var i:int=0; i < points.length; i++) {
					var point:Object = points[i];
					if (i == 0) pathString += "M "+point.x+" "+point.y+" ";
					else pathString += "L "+point.x+" "+point.y+" ";
				}
				
				path.drawPath(0, 0, pathString);
				
				if (needsAddElement) {
					addElement(path);
				}
			}
		}
	}
}