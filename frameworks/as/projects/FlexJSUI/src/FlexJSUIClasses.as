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
	
	import org.apache.flex.html.accessories.NumericOnlyTextInputBead; NumericOnlyTextInputBead;
	import org.apache.flex.html.accessories.PasswordInputBead; PasswordInputBead;
	import org.apache.flex.html.accessories.TextPromptBead; TextPromptBead;
    import org.apache.flex.html.beads.AlertView; AlertView;
	import org.apache.flex.html.beads.ButtonBarView; ButtonBarView;
	import org.apache.flex.html.beads.CheckBoxView; CheckBoxView;
    import org.apache.flex.html.beads.ComboBoxView; ComboBoxView;
    import org.apache.flex.html.beads.ContainerView; ContainerView;
    import org.apache.flex.html.beads.ControlBarMeasurementBead; ControlBarMeasurementBead;
    import org.apache.flex.html.beads.CSSButtonView; CSSButtonView;
	import org.apache.flex.html.beads.CSSTextButtonView; CSSTextButtonView;
	import org.apache.flex.html.beads.DropDownListView; DropDownListView;
	import org.apache.flex.html.beads.ImageButtonView; ImageButtonView;
	import org.apache.flex.html.beads.ImageView; ImageView;
    import org.apache.flex.html.beads.ListView; ListView;
    import org.apache.flex.html.beads.NumericStepperView; NumericStepperView;
    import org.apache.flex.html.beads.PanelView; PanelView;
	import org.apache.flex.html.beads.RadioButtonView; RadioButtonView;
    import org.apache.flex.html.beads.ScrollBarView; ScrollBarView;
	import org.apache.flex.html.beads.SimpleAlertView; SimpleAlertView;
    import org.apache.flex.html.beads.SingleLineBorderBead; SingleLineBorderBead;
	import org.apache.flex.html.beads.SliderView; SliderView;
	import org.apache.flex.html.beads.SliderThumbView; SliderThumbView;
	import org.apache.flex.html.beads.SliderTrackView; SliderTrackView;
	import org.apache.flex.html.beads.SolidBackgroundBead; SolidBackgroundBead;
    import org.apache.flex.html.beads.SpinnerView; SpinnerView;
    import org.apache.flex.html.beads.TextButtonMeasurementBead; TextButtonMeasurementBead;
	import org.apache.flex.html.beads.TextFieldLabelMeasurementBead; TextFieldLabelMeasurementBead;
    import org.apache.flex.html.beads.TextAreaView; TextAreaView;
    import org.apache.flex.html.beads.TextButtonView; TextButtonView;
    import org.apache.flex.html.beads.TextFieldView; TextFieldView;
    import org.apache.flex.html.beads.TextInputView; TextInputView;
    import org.apache.flex.html.beads.TextInputWithBorderView; TextInputWithBorderView;
    import org.apache.flex.html.beads.TitleBarMeasurementBead; TitleBarMeasurementBead;
    import org.apache.flex.html.beads.models.AlertModel; AlertModel;
    import org.apache.flex.html.beads.models.ArraySelectionModel; ArraySelectionModel;
    import org.apache.flex.html.beads.models.ComboBoxModel; ComboBoxModel;
	import org.apache.flex.html.beads.models.ImageModel; ImageModel;
	import org.apache.flex.html.beads.models.PanelModel; PanelModel;
    import org.apache.flex.html.beads.models.SingleLineBorderModel; SingleLineBorderModel;
	import org.apache.flex.html.beads.models.TextModel; TextModel;
    import org.apache.flex.html.beads.models.TitleBarModel; TitleBarModel;
	import org.apache.flex.html.beads.models.ToggleButtonModel; ToggleButtonModel;
	import org.apache.flex.html.beads.models.ValueToggleButtonModel; ValueToggleButtonModel;
    import org.apache.flex.html.beads.controllers.AlertController; AlertController;
	import org.apache.flex.html.beads.controllers.ComboBoxController; ComboBoxController;
    import org.apache.flex.html.beads.controllers.DropDownListController; DropDownListController;
	import org.apache.flex.html.beads.controllers.EditableTextKeyboardController; EditableTextKeyboardController;
    import org.apache.flex.html.beads.controllers.ItemRendererMouseController; ItemRendererMouseController;
    import org.apache.flex.html.beads.controllers.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
	import org.apache.flex.html.beads.controllers.SliderMouseController; SliderMouseController;
	import org.apache.flex.html.beads.controllers.SpinnerMouseController; SpinnerMouseController;
    import org.apache.flex.html.beads.controllers.VScrollBarMouseController; VScrollBarMouseController;
	import org.apache.flex.html.beads.layouts.ButtonBarLayout; ButtonBarLayout;
    import org.apache.flex.html.beads.layouts.NonVirtualVerticalScrollingLayout; NonVirtualVerticalScrollingLayout;  
	import org.apache.flex.html.beads.layouts.NonVirtualHorizontalScrollingLayout; NonVirtualHorizontalScrollingLayout;
    import org.apache.flex.html.beads.layouts.VScrollBarLayout; VScrollBarLayout;
	import org.apache.flex.html.beads.layouts.TileLayout; TileLayout;
    import org.apache.flex.html.beads.TextItemRendererFactoryForArrayData; TextItemRendererFactoryForArrayData;
	import org.apache.flex.html.beads.DataItemRendererFactoryForArrayData; DataItemRendererFactoryForArrayData;
    import org.apache.flex.core.ItemRendererClassFactory; ItemRendererClassFactory;  
	import org.apache.flex.core.FilledRectangle; FilledRectangle;
	import org.apache.flex.events.CustomEvent; CustomEvent;
	import org.apache.flex.events.Event; Event;
	import org.apache.flex.utils.Timer; Timer;
	import org.apache.flex.utils.UIUtils; UIUtils;
    import org.apache.flex.core.SimpleStatesImpl; SimpleStatesImpl;
    
	import mx.core.ClassFactory; ClassFactory;
    import mx.states.AddItems; AddItems;
    import mx.states.SetProperty; SetProperty;
    import mx.states.State; State;
}

}

