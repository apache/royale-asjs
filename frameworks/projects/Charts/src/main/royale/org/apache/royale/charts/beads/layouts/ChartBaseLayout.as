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
package org.apache.royale.charts.beads.layouts
{
	import org.apache.royale.charts.core.ChartBase;
	import org.apache.royale.charts.core.IChartDataGroup;
	import org.apache.royale.charts.core.IHorizontalAxisBead;
	import org.apache.royale.charts.core.IVerticalAxisBead;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	public class ChartBaseLayout extends LayoutBase implements IBeadLayout
	{
		public function ChartBaseLayout()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
		}
		public function get strand():IStrand
		{
			return _strand;
		}
		
		/**
		 *  Returns the strand, cast as an instance of ChartBase.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function get horizontalAxisBead():IHorizontalAxisBead
		{
			if (_xAxis == null) {
				if (_strand.getBeadByType(IHorizontalAxisBead)) _xAxis = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
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
		 *  @productversion Royale 0.0
		 */
		public function get verticalAxisBead():IVerticalAxisBead
		{
			if (_yAxis == null) {
				if (_strand.getBeadByType(IVerticalAxisBead)) _yAxis = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			}
			return _yAxis;
		}
		
		private var _chartDataGroup:IChartDataGroup;
		
		/**
		 *  Returns the object into which the chart elements are drawn or added. The ChartDataGroup implements
		 *  IContentView.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get chartDataGroup():IChartDataGroup
		{
			if (_chartDataGroup == null) {
				var layoutParent:ILayoutHost = _strand.getBeadByType(ILayoutHost) as ILayoutHost;
				_chartDataGroup = layoutParent.contentView as IChartDataGroup;
			}
			return _chartDataGroup;
		}
		
        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         */
//		public function layout():Boolean
//		{
//			performLayout();
//            return true;
//		}
		
		/**
		 *  Subclasses should implement this to draw the chart, adding elements to the chartDataGroup.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
//		protected function performLayout():void
//		{
//			// implement in subclass
//		}
	}
}
