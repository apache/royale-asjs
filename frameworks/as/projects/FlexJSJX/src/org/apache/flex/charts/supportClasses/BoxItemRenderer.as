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
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.core.graphics.Rect;
	import org.apache.flex.core.graphics.SolidColor;
	import org.apache.flex.core.graphics.SolidColorStroke;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	/**
	 *  The BoxItemRenderer displays a colored rectangular area suitable for use as
	 *  an itemRenderer for a BarChartSeries. This class implements the 
	 *  org.apache.flex.charts.core.IChartItemRenderer
	 *  interface. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class BoxItemRenderer extends DataItemRenderer implements IChartItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function BoxItemRenderer()
		{
			super();
		}
		
		private var filledRect:Rect;
		
		private var _yField:String = "y";
		
		/**
		 *  The name of the field containing the value for the Y axis.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get yField():String
		{
			return _yField;
		}
		public function set yField(value:String):void
		{
			_yField = value;
		}
		
		private var _xField:String = "x";
		
		/**
		 *  The name of the field containing the value for the X axis.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get xField():String
		{
			return _xField;
		}
		public function set xField(value:String):void
		{
			_xField = value;
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
			drawBar();
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
			drawBar();
		}
		
		/**
		 *  @copy org.apache.flex.core.UIBase#width
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			drawBar();
		}
		
		/**
		 *  @copy org.apache.flex.core.UIBase#height
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			drawBar();
		}
		
		/**
		 *  @private
		 */
		protected function drawBar():void
		{
			if ((this.width > 0) && (this.height > 0))
			{
				var needsAdd:Boolean = false;
				
				if (filledRect == null) {
					filledRect = new Rect();
					needsAdd = true;
				}
				
				var solidColor:SolidColor = new SolidColor();
				solidColor.color = fillColor;
				var solidStroke:SolidColorStroke = new SolidColorStroke();
				solidStroke.color = fillColor;
				solidStroke.weight = 1;
				filledRect.fill = solidColor;
				filledRect.stroke = solidStroke;
				filledRect.drawRect(0,0,this.width,this.height);
				
				if (needsAdd) {
					addElement(filledRect);
				}
			}
		}
	}
}
