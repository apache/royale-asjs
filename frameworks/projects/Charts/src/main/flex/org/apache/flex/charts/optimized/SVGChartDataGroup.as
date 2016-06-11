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
package org.apache.flex.charts.optimized
{
	import org.apache.flex.charts.core.IChartDataGroup;
	import org.apache.flex.charts.core.IChartItemRenderer;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.core.IContentView;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.graphics.GraphicsContainer;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Point;
	
	/**
	 *  The SVGChartDataGroup serves as the drawing canvas for SVG itemRenderers. Rather than having
	 *  individual itemRenderer objects in the display list, this class provides a canvas where the
	 *  itemRenderers can draw directly using the flex.core.graphics package.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class SVGChartDataGroup extends GraphicsContainer implements IItemRendererParent, IContentView, IChartDataGroup
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function SVGChartDataGroup()
		{
			super();
			
			_children = new Array();
						
			addEventListener("widthChanged", resizeContainer);
			addEventListener("heightChanged", resizeContainer);
		}
		
		private var _children:Array;
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		public function get strand():IStrand
		{
			return _strand;
		}
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#getItemRendererForIndex()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (index < 0 || index >= _children.length) return null;
			return _children[index] as IItemRenderer;
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
			var n:int = _children.length;
			for(var i:int=0; i < n; i++)
			{
				var child:IChartItemRenderer = _children[i] as IChartItemRenderer;
				if (child && child.series == series) {
					if (index == 0) return child;
					--index;
				}
			}
			
			return null;
		}
		
		/**
		 *  @copy org.apache.flex.core.IItemRendererParent#removeAllElements()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function removeAllElements():void
		{
			super.removeAllElements();
			_children = new Array();
		}
		
		/**
		 *  Overrides the addElement function to set the element into an internal
		 *  list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function addElement(value:Object, dispatchEvent:Boolean = true):void
		{
			_children.push(value);
			
			var base:UIBase = value as UIBase;
			base.addedToParent();
			
			super.addElement(value, dispatchEvent);
		}
		
		/**
		 *  Overrides the addElementAt function to set the element into an internal
		 *  list.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function addElementAt(value:Object, index:int, dispatchEvent:Boolean = true):void
		{
			if (index >= _children.length) _children.push(value);
			else _children.splice(index, 0, value);
			
			var base:UIBase = value as UIBase;
			base.addedToParent();
			
			super.addElementAt(value, index, dispatchEvent);
		}
		
		/**
		 *  @private
		 */
		private function resizeContainer(event:Event) : void
		{
			// might need to do something with this
		}
		
		public function getItemRendererUnderPoint(point:Point):IChartItemRenderer
		{
			return null;
		}
		
		public function updateAllItemRenderers():void
		{
			
		}
	}
}
