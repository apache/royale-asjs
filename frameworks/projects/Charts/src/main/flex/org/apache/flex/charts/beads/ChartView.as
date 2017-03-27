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
	import org.apache.flex.charts.core.IChartDataGroup;
	import org.apache.flex.charts.core.IChartSeries;
	import org.apache.flex.charts.core.IChartDataModel;
	import org.apache.flex.charts.supportClasses.ChartDataGroup;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.ILayoutView;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IRollOverModel;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IStrand;
//	import org.apache.flex.core.IViewport;
//	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.geom.Rectangle;
    import org.apache.flex.geom.Size;
	import org.apache.flex.html.beads.GroupView;
//	import org.apache.flex.html.beads.models.ViewportModel;
//	import org.apache.flex.html.supportClasses.Viewport;
	import org.apache.flex.utils.CSSContainerUtils;
	
	/**
	 *  The ChartView class provides the visual elemental structure for a chart. This includes the
	 *  axis areas and the chart data area where the graphs are drawn.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ChartView extends GroupView implements IBeadView
	{
		/**
		 *  Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ChartView()
		{
			super();
		}
		
		protected var dataModel:IChartDataModel;
		
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
		}
		
		/**
		 * @private
		 */
		override protected function completeSetup():void
		{	
			super.completeSetup();
		}
		
		override protected function beadsAddedHandler(event:Event):void
		{
			super.beadsAddedHandler(event);
			
			dataModel = _strand.getBeadByType(IChartDataModel) as IChartDataModel;
			dataModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			
			IParent(_strand).addElement(dataGroup as IChild, false);
						
			var haxis:IHorizontalAxisBead = _strand.getBeadByType(IHorizontalAxisBead) as IHorizontalAxisBead;
			if (haxis && _horizontalAxisGroup == null) {
				var m1:Class = ValuesManager.valuesImpl.getValue(_strand, "iHorizontalAxisGroup");
				_horizontalAxisGroup = new m1();
				haxis.axisGroup = _horizontalAxisGroup;
				UIBase(_horizontalAxisGroup).className = "HorizontalAxis";
				IParent(_strand).addElement(_horizontalAxisGroup, false);
			}
			
			var vaxis:IVerticalAxisBead = _strand.getBeadByType(IVerticalAxisBead) as IVerticalAxisBead;
			if (vaxis && _verticalAxisGroup == null) {
				var m2:Class = ValuesManager.valuesImpl.getValue(_strand, "iVerticalAxisGroup");
				_verticalAxisGroup = new m2();
				vaxis.axisGroup = _verticalAxisGroup;
				UIBase(_verticalAxisGroup).className = "VerticalAxis";
				IParent(_strand).addElement(_verticalAxisGroup, false);
			}
		}
		
		override public function get contentView():ILayoutView
		{
			return dataGroup as ILayoutView;
		}
		
		private var _chartDataGroup:IChartDataGroup;
		
		/**
		 * 
		 */
		public function get dataGroup():IItemRendererParent
		{
			if (_chartDataGroup == null) {
				// pull out of valuesManager
				var c:Class = ValuesManager.valuesImpl.getValue(_strand, "iContentView");
				if (c) {
					_chartDataGroup = new c();
				}
			}
			return _chartDataGroup;
		}
		
		/**
		 *  The IAxisGroup that represents the horizontal axis.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get horizontalAxisGroup():IAxisGroup
		{
			return _horizontalAxisGroup;
		}
		
		/**
		 *  The IAxisGroup that represents the vertical axis.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get verticalAxisGroup():IAxisGroup
		{
			return _verticalAxisGroup;
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if (verticalAxisGroup) {
				verticalAxisGroup.removeAllElements();
			}
			
			if (horizontalAxisGroup) {
				horizontalAxisGroup.removeAllElements();
			}
			
			dataGroup.removeAllItemRenderers();
		}
				
		/**
		 * ChartView overrides performLayout so that the exact area of the ChartDataGroup can
		 * be calculated so the chart's layout algorithm knows precisely the dimensions of 
		 * chart for its item renderers.
		 */		
		override protected function layoutViewBeforeContentLayout():void
		{			
			var metrics:Rectangle = CSSContainerUtils.getBorderAndPaddingMetrics(_strand);
			
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
			
			var strandWidth:Number = UIBase(_strand).width;
			var strandHeight:Number = UIBase(_strand).height;
			
			var chartArea:UIBase = dataGroup as UIBase;
			
			chartArea.x = widthAdjustment + metrics.left;
			chartArea.y = metrics.top;
			chartArea.setWidthAndHeight(strandWidth - widthAdjustment - metrics.right - metrics.left,
				strandHeight - heightAdjustment - metrics.bottom - metrics.top);
			COMPILE::JS {
				chartArea.element.style.position = "absolute";
			}
			
//            viewport.setPosition(widthAdjustment + metrics.left, metrics.top);
//			viewport.layoutViewportBeforeContentLayout(strandWidth - widthAdjustment - metrics.right - metrics.left,
//                                                        strandHeight - heightAdjustment - metrics.bottom - metrics.top);
            
			if (verticalAxisGroup) {
				UIBase(verticalAxisGroup).x = metrics.left;
				UIBase(verticalAxisGroup).y = metrics.top;
				UIBase(verticalAxisGroup).width = widthAdjustment;
				UIBase(verticalAxisGroup).height = strandHeight - heightAdjustment - metrics.bottom - metrics.top;
				COMPILE::JS {
					verticalAxisGroup.element.style.position = "absolute";
				}
			}
			
			if (horizontalAxisGroup) {
				UIBase(horizontalAxisGroup).x = widthAdjustment + metrics.left;
				UIBase(horizontalAxisGroup).y = strandHeight - heightAdjustment - metrics.bottom;
				UIBase(horizontalAxisGroup).width = strandWidth - widthAdjustment - metrics.left - metrics.right;
				UIBase(horizontalAxisGroup).height = heightAdjustment;
				COMPILE::JS {
					horizontalAxisGroup.element.style.position = "absolute";
				}
			}
		}
		
		/**
		 * @private
		 */
		protected var lastSelectedSeries:IChartSeries;
		
		/**
		 * @private
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var model:IChartDataModel = event.currentTarget as IChartDataModel;
			var chartDataGroup:ChartDataGroup = dataGroup as ChartDataGroup;
			var ir:ISelectableItemRenderer = null;
			
			if (lastSelectedIndex != -1)
			{
				ir = chartDataGroup.getItemRendererForSeriesAtIndex(lastSelectedSeries, lastSelectedIndex) as ISelectableItemRenderer;
				ir.selected = false;
			}
			if (model.selectedIndex != -1)
			{
				ir = chartDataGroup.getItemRendererForSeriesAtIndex(model.selectedSeries, model.selectedIndex) as ISelectableItemRenderer;
				ir.selected = true;
			}
			lastSelectedIndex = model.selectedIndex;
			lastSelectedSeries = model.selectedSeries;
		}
		
		/**
		 * @private
		 */
		protected var lastRollOverSeries:IChartSeries;
		
		/**
		 * @private
		 */
		protected var lastRollOverIndex:Number = -1;
		
		/**
		 * @private
		 */
		protected var lastSelectedIndex:Number = -1
		
		/**
		 * @private
		 */
		COMPILE::SWF
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var model:IChartDataModel = event.currentTarget as IChartDataModel;
			var chartDataGroup:ChartDataGroup = dataGroup as ChartDataGroup;
			var ir:ISelectableItemRenderer = null;

			if (lastRollOverIndex != -1)
			{
				ir = chartDataGroup.getItemRendererForSeriesAtIndex(lastRollOverSeries, lastRollOverIndex) as ISelectableItemRenderer;
				ir.hovered = false;
			}
			if (model.rollOverIndex != -1)
			{
				ir = chartDataGroup.getItemRendererForSeriesAtIndex(model.rollOverSeries, model.rollOverIndex) as ISelectableItemRenderer;
				ir.hovered = true;
			}
			lastRollOverIndex = model.rollOverIndex;
			lastRollOverSeries = model.rollOverSeries;
		}
	}
}
