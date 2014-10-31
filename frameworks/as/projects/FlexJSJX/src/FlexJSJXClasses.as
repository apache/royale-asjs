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
internal class FlexJSJXClasses
{
	
	import org.apache.flex.charts.beads.ChartItemRendererFactory; ChartItemRendererFactory;
	import org.apache.flex.charts.beads.DataItemRendererFactoryForSeriesData; DataItemRendererFactoryForSeriesData;
	import org.apache.flex.charts.beads.HorizontalCategoryAxisBead; HorizontalCategoryAxisBead;
	import org.apache.flex.charts.beads.HorizontalLinearAxisBead; HorizontalLinearAxisBead;
	import org.apache.flex.charts.beads.VerticalCategoryAxisBead; VerticalCategoryAxisBead;
	import org.apache.flex.charts.beads.VerticalLinearAxisBead; VerticalLinearAxisBead;
	import org.apache.flex.charts.beads.layouts.BarChartLayout; BarChartLayout;
	import org.apache.flex.charts.beads.layouts.ColumnChartLayout; ColumnChartLayout;
	import org.apache.flex.charts.beads.layouts.LineChartCategoryVsLinearLayout; LineChartCategoryVsLinearLayout;
	import org.apache.flex.charts.beads.layouts.LineChartLinearVsLinearLayout; LineChartLinearVsLinearLayout;
	import org.apache.flex.charts.beads.layouts.PieChartLayout; PieChartLayout;
	import org.apache.flex.charts.beads.layouts.StackedBarChartLayout; StackedBarChartLayout;
	import org.apache.flex.charts.beads.layouts.StackedColumnChartLayout; StackedColumnChartLayout;
	import org.apache.flex.charts.supportClasses.BarSeries; BarSeries;
	import org.apache.flex.charts.supportClasses.LineSeries; LineSeries;
	import org.apache.flex.charts.supportClasses.PieSeries; PieSeries;
	import org.apache.flex.charts.supportClasses.BoxItemRenderer; BoxItemRenderer;
	import org.apache.flex.charts.supportClasses.LineSegmentItemRenderer; LineSegmentItemRenderer;
	import org.apache.flex.charts.supportClasses.WedgeItemRenderer; WedgeItemRenderer;
	import org.apache.flex.charts.supportClasses.optimized.SVGChartDataGroup; SVGChartDataGroup;
	import org.apache.flex.charts.supportClasses.optimized.SVGBoxItemRenderer; SVGBoxItemRenderer;
	import org.apache.flex.charts.supportClasses.optimized.SVGWedgeItemRenderer; SVGWedgeItemRenderer;
	import org.apache.flex.charts.supportClasses.optimized.SVGLineSegmentItemRenderer; SVGLineSegmentItemRenderer;
	
	import org.apache.flex.effects.Tween; Tween;
	import org.apache.flex.effects.Move; Move;
	import org.apache.flex.effects.Fade; Fade;
	
	import org.apache.flex.html.accessories.DateFormatMMDDYYYYBead; DateFormatMMDDYYYYBead;
	import org.apache.flex.html.beads.DataGridColumnView; DataGridColumnView;
	import org.apache.flex.html.beads.DataGridView; DataGridView;
	import org.apache.flex.html.beads.DateChooserView; DateChooserView;
	import org.apache.flex.html.beads.DateFieldView; DateFieldView;
	import org.apache.flex.html.beads.FormatableLabelView; FormatableLabelView;
	import org.apache.flex.html.beads.FormatableTextInputView; FormatableTextInputView;
	import org.apache.flex.html.beads.layouts.DataGridLayout; DataGridLayout;
    import org.apache.flex.html.beads.layouts.FlexibleFirstChildHorizontalLayout; FlexibleFirstChildHorizontalLayout;
	import org.apache.flex.html.beads.models.DataGridModel; DataGridModel;
	import org.apache.flex.html.beads.models.DateChooserModel; DateChooserModel;
	import org.apache.flex.html.beads.models.DataGridPresentationModel; DataGridPresentationModel;
	import org.apache.flex.html.beads.controllers.DateChooserMouseController; DateChooserMouseController;
	import org.apache.flex.html.beads.controllers.DateFieldMouseController; DateFieldMouseController;
	import org.apache.flex.html.supportClasses.DataGridColumn; DataGridColumn;
	import org.apache.flex.html.supportClasses.DateChooserButton; DateChooserButton;
    
    import org.apache.flex.html.beads.TitleBarView; TitleBarView;
    import org.apache.flex.html.beads.TitleBarMeasurementBead; TitleBarMeasurementBead;

    import org.apache.flex.core.ParentDocumentBead; ParentDocumentBead;
    import org.apache.flex.core.StatesWithTransitionsImpl; StatesWithTransitionsImpl;
}

}

