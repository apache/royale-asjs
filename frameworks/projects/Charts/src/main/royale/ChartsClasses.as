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
package
{

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class ChartsClasses
{	
	import org.apache.royale.charts.core.CartesianChart; CartesianChart;
	import org.apache.royale.charts.core.ChartBase; ChartBase;
	import org.apache.royale.charts.core.IAxisBead; IAxisBead;
	import org.apache.royale.charts.core.IAxisGroup; IAxisGroup;
	import org.apache.royale.charts.core.IChart; IChart;
	import org.apache.royale.charts.core.ICartesianChartLayout; ICartesianChartLayout;
	import org.apache.royale.charts.core.IChartDataGroup; IChartDataGroup;
	import org.apache.royale.charts.core.IChartDataModel; IChartDataModel;
	import org.apache.royale.charts.core.IChartSeries; IChartSeries;
	import org.apache.royale.charts.core.IHorizontalAxisBead; IHorizontalAxisBead;
	import org.apache.royale.charts.core.IVerticalAxisBead; IVerticalAxisBead;
	import org.apache.royale.charts.core.IChartItemRenderer; IChartItemRenderer;
	import org.apache.royale.charts.core.IConnectedItemRenderer; IConnectedItemRenderer;
	import org.apache.royale.charts.core.PolarChart; PolarChart;
	import org.apache.royale.charts.supportClasses.ChartAxisGroup; ChartAxisGroup;
	import org.apache.royale.charts.supportClasses.ChartDataGroup; ChartDataGroup;
	
	import org.apache.royale.charts.beads.ChartView; ChartView;
    import org.apache.royale.charts.beads.ChartSelectableItemRendererBead; ChartSelectableItemRendererBead;
	import org.apache.royale.charts.beads.ChartItemRendererFactory; ChartItemRendererFactory;
	import org.apache.royale.charts.beads.DataItemRendererFactoryForSeriesData; DataItemRendererFactoryForSeriesData;
	import org.apache.royale.charts.beads.DataItemRendererFactoryForSeriesArrayListData; DataItemRendererFactoryForSeriesArrayListData;
	import org.apache.royale.charts.beads.DataTipBead; DataTipBead;
	import org.apache.royale.charts.beads.HorizontalCategoryAxisBead; HorizontalCategoryAxisBead;
	import org.apache.royale.charts.beads.HorizontalCategoryAxisForArrayListBead; HorizontalCategoryAxisForArrayListBead;
	import org.apache.royale.charts.beads.HorizontalLinearAxisBead; HorizontalLinearAxisBead;
	import org.apache.royale.charts.beads.HorizontalLinearAxisForArrayListBead; HorizontalLinearAxisForArrayListBead;
	import org.apache.royale.charts.beads.VerticalCategoryAxisBead; VerticalCategoryAxisBead;
	import org.apache.royale.charts.beads.VerticalCategoryAxisForArrayListBead; VerticalCategoryAxisForArrayListBead;
	import org.apache.royale.charts.beads.VerticalLinearAxisBead; VerticalLinearAxisBead;
	import org.apache.royale.charts.beads.VerticalLinearAxisForArrayListBead; VerticalLinearAxisForArrayListBead;
	import org.apache.royale.charts.beads.controllers.ChartSeriesMouseController; ChartSeriesMouseController;
	import org.apache.royale.charts.beads.layouts.BarChartLayout; BarChartLayout;
//	import org.apache.royale.charts.beads.layouts.BarChartLayoutForArrayList; BarChartLayoutForArrayList;
//	import org.apache.royale.charts.beads.layouts.ColumnChartLayout; ColumnChartLayout;
//	import org.apache.royale.charts.beads.layouts.ColumnChartLayoutForArrayList; ColumnChartLayoutForArrayList;
//	import org.apache.royale.charts.beads.layouts.LineChartCategoryVsLinearLayout; LineChartCategoryVsLinearLayout;
//	import org.apache.royale.charts.beads.layouts.LineChartLinearVsLinearLayout; LineChartLinearVsLinearLayout;
//	import org.apache.royale.charts.beads.layouts.PieChartLayout; PieChartLayout;
//	import org.apache.royale.charts.beads.layouts.PieChartLayoutForArrayList; PieChartLayoutForArrayList;
//	import org.apache.royale.charts.beads.layouts.StackedBarChartLayout; StackedBarChartLayout;
//	import org.apache.royale.charts.beads.layouts.StackedBarChartLayoutForArrayList; StackedBarChartLayoutForArrayList;
//	import org.apache.royale.charts.beads.layouts.StackedColumnChartLayout; StackedColumnChartLayout;
//	import org.apache.royale.charts.beads.layouts.StackedColumnChartLayoutForArrayList; StackedColumnChartLayoutForArrayList;
	import org.apache.royale.charts.beads.models.ChartArraySelectionModel; ChartArraySelectionModel;
	import org.apache.royale.charts.beads.models.ChartArrayListSelectionModel; ChartArrayListSelectionModel;
	import org.apache.royale.charts.supportClasses.BarSeries; BarSeries;
	import org.apache.royale.charts.supportClasses.LineSeries; LineSeries;
	import org.apache.royale.charts.supportClasses.PieSeries; PieSeries;
	import org.apache.royale.charts.supportClasses.BoxItemRenderer; BoxItemRenderer;
	import org.apache.royale.charts.supportClasses.LineSegmentItemRenderer; LineSegmentItemRenderer;
	import org.apache.royale.charts.supportClasses.WedgeItemRenderer; WedgeItemRenderer;
	import org.apache.royale.charts.optimized.SVGChartAxisGroup; SVGChartAxisGroup;
	import org.apache.royale.charts.optimized.SVGChartDataGroup; SVGChartDataGroup;
	import org.apache.royale.charts.optimized.SVGBoxItemRenderer; SVGBoxItemRenderer;
	import org.apache.royale.charts.optimized.SVGWedgeItemRenderer; SVGWedgeItemRenderer;
	import org.apache.royale.charts.optimized.SVGLineSegmentItemRenderer; SVGLineSegmentItemRenderer;
}

}

