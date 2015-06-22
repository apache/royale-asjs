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
package org.apache.flex.charts.beads
{
	import org.apache.flex.charts.core.IAxisGroup;
	import org.apache.flex.charts.core.IHorizontalAxisBead;
	import org.apache.flex.charts.core.IVerticalAxisBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.ListView;
	import org.apache.flex.utils.BeadMetrics;
	
	public class ChartView extends ListView implements IBeadView
	{
		public function ChartView()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _horizontalAxisGroup:IAxisGroup;
		private var _verticalAxisGroup:IAxisGroup;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			_strand = value;
			
			if (border) {
				IParent(_strand).removeElement(border);
			}
            
			var listModel:ISelectionModel = value.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			var haxis:IHorizontalAxisBead = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			if (haxis && _horizontalAxisGroup == null) {
				var m1:Class = ValuesManager.valuesImpl.getValue(value, "iHorizontalAxisGroup");
				_horizontalAxisGroup = new m1();
				haxis.axisGroup = _horizontalAxisGroup;
				IParent(_strand).addElement(_horizontalAxisGroup);
			}
			
			var vaxis:IVerticalAxisBead = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			if (vaxis && _verticalAxisGroup == null) {
				var m2:Class = ValuesManager.valuesImpl.getValue(value, "iVerticalAxisGroup");
				_verticalAxisGroup = new m2();
				vaxis.axisGroup = _verticalAxisGroup;
				IParent(_strand).addElement(_verticalAxisGroup);
			}
						
			IEventDispatcher(_strand).dispatchEvent( new Event("viewCreated") );
		}
		
		public function get horizontalAxisGroup():IAxisGroup
		{
			return _horizontalAxisGroup;
		}
		
		public function get verticalAxisGroup():IAxisGroup
		{
			return _verticalAxisGroup;
		}
		
		/**
		 * @private
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if (verticalAxisGroup) {
				verticalAxisGroup.removeAllElements();
			}
			
			if (horizontalAxisGroup) {
				horizontalAxisGroup.removeAllElements();
			}
			
			dataGroup.removeAllElements();
		}
		
		/**
		 * @private
		 */
		protected function layoutList():void
		{	
			var metrics:UIMetrics = BeadMetrics.getMetrics(_strand);
			
			var widthAdjustment:Number = 0;
			var heightAdjustment:Number = 0;
			
			var vaxis:IVerticalAxisBead = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			var haxis:IHorizontalAxisBead = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			
			if (vaxis) {
				widthAdjustment = vaxis.axisWidth;
			}
			
			if (haxis) {
				heightAdjustment = haxis.axisHeight;
			}
			
			var dg:UIBase = UIBase(dataGroup);
			var strandWidth:Number = UIBase(_strand).width;
			var strandHeight:Number = UIBase(_strand).height;
			
			dg.x = widthAdjustment + metrics.left;
			dg.y = metrics.top;
			dg.width = strandWidth - widthAdjustment - metrics.right - metrics.left;
			dg.height= strandHeight - heightAdjustment - metrics.bottom - metrics.top;
			
			if (verticalAxisGroup) {
				UIBase(verticalAxisGroup).x = metrics.left;
				UIBase(verticalAxisGroup).y = metrics.top;
				UIBase(verticalAxisGroup).width = widthAdjustment;
				UIBase(verticalAxisGroup).height = strandHeight - heightAdjustment - metrics.bottom - metrics.top;
			}
			
			if (horizontalAxisGroup) {
				UIBase(horizontalAxisGroup).x = widthAdjustment + metrics.left;
				UIBase(horizontalAxisGroup).y = strandHeight - heightAdjustment - metrics.bottom;
				UIBase(horizontalAxisGroup).width = strandWidth - widthAdjustment - metrics.left - metrics.right;
				UIBase(horizontalAxisGroup).height = heightAdjustment;
			}
		}
	}
}