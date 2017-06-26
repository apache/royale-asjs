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
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.core.IBead;
	import org.apache.flex.graphics.IFill;
	import org.apache.flex.graphics.IStroke;
	import org.apache.flex.svg.Rect;
	import org.apache.flex.graphics.SolidColor;
	import org.apache.flex.svg.LinearGradient;
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
		
		override public function addedToParent():void
		{
			super.addedToParent();
		}
		
		override public function addBead(bead:IBead):void
		{
			super.addBead(bead);
		}
		
		private var _series:IChartSeries;
		
		/**
		 *  The series to which this itemRenderer instance belongs. Or, the series
		 *  being presented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get series():IChartSeries
		{
			return _series;
		}
		public function set series(value:IChartSeries):void
		{
			_series = value;
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
		
		private var _fill:IFill;
		
		/**
		 *  The color used to fill the interior of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
				
				filledRect.fill = fill;
				filledRect.stroke = stroke;
				filledRect.x = 0;
				filledRect.y = 0;
				filledRect.width = this.width;
				filledRect.height = this.height;
				
				if (needsAdd) {
					addElement(filledRect);
				}
			}
		}
		
		private var hoverFill:IFill;
		
		override public function updateRenderer():void
		{			
			if (filledRect == null) return;
			
			if (down||selected||hovered) {
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
				filledRect.fill = hoverFill;
			}
			else {
				filledRect.fill = fill;
			}
			
			filledRect.drawRect(filledRect.x, filledRect.y, filledRect.width, filledRect.height);
		}
	}
}
