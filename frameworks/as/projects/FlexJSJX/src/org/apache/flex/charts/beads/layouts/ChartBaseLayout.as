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
package org.apache.flex.charts.beads.layouts
{
	import org.apache.flex.charts.supportClasses.ChartDataGroup;
	import org.apache.flex.charts.core.ChartBase;
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class ChartBaseLayout implements IBeadLayout
	{
		public function ChartBaseLayout()
		{
		}
		
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
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
			IEventDispatcher(value).addEventListener("layoutNeeded", changeHandler);
		}
		
		/**
		 *  Returns the strand, cast as an instance of ChartBase.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get chart():ChartBase
		{
			return _strand as ChartBase;
		}
		
		private var _xAxis:IHorizontalAxisBead = null;
		
		/**
		 *  The horizontal axis bead or null if one is not present.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get horizontalAxisBead():IHorizontalAxisBead
		{
			if (_xAxis == null) {
				if (chart.getBeadByType(IHorizontalAxisBead)) _xAxis = chart.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			}
			return _xAxis;
		}
		
		private var _yAxis:IVerticalAxisBead = null;
		
		/**
		 *  The vertical axis bead or null if one is not present.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get verticalAxisBead():IVerticalAxisBead
		{
			if (_yAxis == null) {
				if (chart.getBeadByType(IVerticalAxisBead)) _yAxis = chart.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			}
			return _yAxis;
		}
		
		private var _chartDataGroup:ChartDataGroup;
		
		/**
		 *  Returns the object into which the chart elements are drawn or added. The ChartDataGroup implements
		 *  IContentView.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get chartDataGroup():ChartDataGroup
		{
			if (_chartDataGroup == null) {
				var layoutParent:ILayoutParent = chart.getBeadByType(ILayoutParent) as ILayoutParent;
				_chartDataGroup = layoutParent.contentView as ChartDataGroup;
			}
			return _chartDataGroup;
		}
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			performLayout();
		}
		
		/**
		 *  Subclasses should implement this to draw the chart, adding elements to the chartDataGroup.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function performLayout():void
		{
			// implement in subclass
		}
	}
}