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
	import org.apache.flex.charts.core.IChartDataGroup;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.geom.Point;
	import org.apache.flex.html.supportClasses.ContainerContentArea;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IChild;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	/**
	 *  The ChartDataGroup class provides the actual space for rendering the
	 *  chart. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ChartDataGroup extends ContainerContentArea implements IChartDataGroup
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ChartDataGroup()
		{
			super();
		}
		
		/**
		 *  Returns the itemRenderer that matches both the series and child index. A null return is
		 *  valid since some charts have optional itemRenderers for their series.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		
		/*
		* IItemRendererParent
		*/
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#addItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function addItemRenderer(renderer:IItemRenderer):void
		{
			addElement(renderer, true);
			
//			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
//			newEvent.item = renderer;
//			
//			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#removeItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			removeElement(renderer, true);
			
//			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
//			newEvent.item = renderer;
//			
//			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#removeAllItemRenderers()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function removeAllItemRenderers():void
		{
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (index < 0 || index >= numElements) return null;
			return getElementAt(index) as IItemRenderer;
		}
		
		/**
		 *  Refreshes the itemRenderers. Useful after a size change by the data group.
		 *
		 *  @copy org.apache.flex.core.IItemRendererParent#updateAllItemRenderers()
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function updateAllItemRenderers():void
		{
			var n:Number = numElements;
			for (var i:Number = 0; i < n; i++)
			{
				var renderer:DataItemRenderer = getItemRendererForIndex(i) as DataItemRenderer;
				if (renderer) {
					renderer.setWidth(this.width,true);
					renderer.adjustSize();
				}
			}
		}
	}
}
