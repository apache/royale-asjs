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
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.core.IBead;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.svg.Rect;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.svg.LinearGradient;
	
	/**
	 *  The BoxItemRenderer displays a colored rectangular area suitable for use as
	 *  an itemRenderer for a BarChartSeries. This class implements the 
	 *  org.apache.royale.charts.core.IChartItemRenderer
	 *  interface. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class BoxItemRenderer extends ChartItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function BoxItemRenderer()
		{
			super();
		}
						
		private var filledRect:Rect;
		
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
            drawBar();
            
			if (filledRect == null) return;
			
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
				filledRect.fill = hoverFill;
			}
			else {
				filledRect.fill = fill;
			}
			
			filledRect.drawRect(filledRect.x, filledRect.y, filledRect.width, filledRect.height);
		}
	}
}
