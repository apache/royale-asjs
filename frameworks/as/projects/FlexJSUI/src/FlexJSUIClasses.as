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
internal class FlexJSUIClasses
{
	import org.apache.flex.charts.beads.BarChartView; BarChartView;
	import org.apache.flex.charts.beads.ChartItemRendererFactory; ChartItemRendererFactory;
	import org.apache.flex.charts.beads.XAxisBead; XAxisBead;
	import org.apache.flex.charts.beads.layouts.BarChartLayout; BarChartLayout;
	import org.apache.flex.charts.supportClasses.BarChartSeries; BarChartSeries;
	import org.apache.flex.charts.supportClasses.BoxItemRenderer; BoxItemRenderer;
	
	import org.apache.flex.html.staticControls.accessories.NumericOnlyTextInputBead; NumericOnlyTextInputBead;
	import org.apache.flex.html.staticControls.accessories.PasswordInputBead; PasswordInputBead;
	import org.apache.flex.html.staticControls.accessories.TextPromptBead; TextPromptBead;
    import org.apache.flex.html.staticControls.beads.AlertView; AlertView;
	import org.apache.flex.html.staticControls.beads.ButtonBarView; ButtonBarView;
	import org.apache.flex.html.staticControls.beads.CheckBoxView; CheckBoxView;
    import org.apache.flex.html.staticControls.beads.ComboBoxView; ComboBoxView;
    import org.apache.flex.html.staticControls.beads.ContainerView; ContainerView;
    import org.apache.flex.html.staticControls.beads.ControlBarMeasurementBead; ControlBarMeasurementBead;
	import org.apache.flex.html.staticControls.beads.CSSTextButtonView; CSSTextButtonView;
	import org.apache.flex.html.staticControls.beads.DataGridColumnView; DataGridColumnView;
	import org.apache.flex.html.staticControls.beads.DataGridView; DataGridView;
    import org.apache.flex.html.staticControls.beads.DropDownListView; DropDownListView;
	import org.apache.flex.html.staticControls.beads.ImageView; ImageView;
    import org.apache.flex.html.staticControls.beads.ListView; ListView;
    import org.apache.flex.html.staticControls.beads.NumericStepperView; NumericStepperView;
    import org.apache.flex.html.staticControls.beads.PanelView; PanelView;
	import org.apache.flex.html.staticControls.beads.RadioButtonView; RadioButtonView;
    import org.apache.flex.html.staticControls.beads.ScrollBarView; ScrollBarView;
	import org.apache.flex.html.staticControls.beads.SimpleAlertView; SimpleAlertView;
    import org.apache.flex.html.staticControls.beads.SingleLineBorderBead; SingleLineBorderBead;
	import org.apache.flex.html.staticControls.beads.SliderView; SliderView;
	import org.apache.flex.html.staticControls.beads.SliderThumbView; SliderThumbView;
	import org.apache.flex.html.staticControls.beads.SliderTrackView; SliderTrackView;
    import org.apache.flex.html.staticControls.beads.SpinnerView; SpinnerView;
    import org.apache.flex.html.staticControls.beads.TextButtonMeasurementBead; TextButtonMeasurementBead;
	import org.apache.flex.html.staticControls.beads.TextFieldLabelMeasurementBead; TextFieldLabelMeasurementBead;
    import org.apache.flex.html.staticControls.beads.TextAreaView; TextAreaView;
    import org.apache.flex.html.staticControls.beads.TextButtonView; TextButtonView;
    import org.apache.flex.html.staticControls.beads.TextFieldView; TextFieldView;
    import org.apache.flex.html.staticControls.beads.TextInputView; TextInputView;
    import org.apache.flex.html.staticControls.beads.TextInputWithBorderView; TextInputWithBorderView;
    import org.apache.flex.html.staticControls.beads.TitleBarMeasurementBead; TitleBarMeasurementBead;
    import org.apache.flex.html.staticControls.beads.models.AlertModel; AlertModel;
    import org.apache.flex.html.staticControls.beads.models.ArraySelectionModel; ArraySelectionModel;
    import org.apache.flex.html.staticControls.beads.models.ComboBoxModel; ComboBoxModel;
	import org.apache.flex.html.staticControls.beads.models.DataGridModel; DataGridModel;
	import org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel; DataGridPresentationModel;
	import org.apache.flex.html.staticControls.beads.models.ImageModel; ImageModel;
	import org.apache.flex.html.staticControls.beads.models.PanelModel; PanelModel;
    import org.apache.flex.html.staticControls.beads.models.SingleLineBorderModel; SingleLineBorderModel;
	import org.apache.flex.html.staticControls.beads.models.TextModel; TextModel;
    import org.apache.flex.html.staticControls.beads.models.TitleBarModel; TitleBarModel;
	import org.apache.flex.html.staticControls.beads.models.ToggleButtonModel; ToggleButtonModel;
	import org.apache.flex.html.staticControls.beads.models.ValueToggleButtonModel; ValueToggleButtonModel;
    import org.apache.flex.html.staticControls.beads.controllers.AlertController; AlertController;
	import org.apache.flex.html.staticControls.beads.controllers.ComboBoxController; ComboBoxController;
    import org.apache.flex.html.staticControls.beads.controllers.DropDownListController; DropDownListController;
	import org.apache.flex.html.staticControls.beads.controllers.EditableTextKeyboardController; EditableTextKeyboardController;
    import org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController; ItemRendererMouseController;
    import org.apache.flex.html.staticControls.beads.controllers.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
	import org.apache.flex.html.staticControls.beads.controllers.SliderMouseController; SliderMouseController;
	import org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController; SpinnerMouseController;
    import org.apache.flex.html.staticControls.beads.controllers.VScrollBarMouseController; VScrollBarMouseController;
	import org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout; ButtonBarLayout;
    import org.apache.flex.html.staticControls.beads.layouts.NonVirtualVerticalScrollingLayout; NonVirtualVerticalScrollingLayout;  
	import org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalScrollingLayout; NonVirtualHorizontalScrollingLayout;
    import org.apache.flex.html.staticControls.beads.layouts.VScrollBarLayout; VScrollBarLayout;
    import org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData; TextItemRendererFactoryForArrayData;
	import org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData; DataItemRendererFactoryForArrayData;
	import org.apache.flex.html.staticControls.supportClasses.DataGridColumn; DataGridColumn;
    import org.apache.flex.core.ItemRendererClassFactory; ItemRendererClassFactory;  
	import org.apache.flex.core.FilledRectangle; FilledRectangle;
	import org.apache.flex.events.CustomEvent; CustomEvent;
	import org.apache.flex.events.Event; Event;
	import org.apache.flex.utils.Timer; Timer;
    import org.apache.flex.core.SimpleStatesImpl; SimpleStatesImpl;
    
	import mx.core.ClassFactory; ClassFactory;
    import mx.states.AddItems; AddItems;
    import mx.states.SetProperty; SetProperty;
    import mx.states.State; State;
}

}
