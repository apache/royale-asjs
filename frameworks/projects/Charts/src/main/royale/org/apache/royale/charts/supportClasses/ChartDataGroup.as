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
	import org.apache.royale.charts.core.IChartDataGroup;
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.charts.core.IChartSeries;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.supportClasses.DataGroup;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.geom.Point;
	
	/**
	 *  The ChartDataGroup class provides the actual space for rendering the
	 *  chart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ChartDataGroup extends DataGroup implements IChartDataGroup
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ChartDataGroup()
		{
			super();
		}
		
		/*
		 * IChartDataGroup
		 */
		
		/**
		 *  Returns the itemRenderer that matches both the series and child index. A null return is
		 *  valid since some charts have optional itemRenderers for their series.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getItemRendererForSeriesAtIndex(series:IChartSeries, index:int):IChartItemRenderer
		{
			var n:int = numElements;
			for(var i:int=0; i < n; i++)
			{
				var child:IChartItemRenderer = getElementAt(i) as IChartItemRenderer;
				if (child && child.series == series) {
					if (index == 0) return child;
					--index;
				}
			}
			
			return null;
		}
		
		/**
		 *  Returns the first itemRenderer that encompasses the point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function getItemRendererUnderPoint(point:Point):IChartItemRenderer
		{
			var n:int = numElements;
			for(var i:int=0; i < n; i++)
			{
				var child:IUIBase = getElementAt(i) as IUIBase;
				if (child) {
					if (child.x <= point.x && point.x <= (child.x+child.width) &&
						child.y <= point.y && point.y <= (child.y+child.height))
						return child as IChartItemRenderer;
				}
			}
			
			return null;
		}
	}
}
