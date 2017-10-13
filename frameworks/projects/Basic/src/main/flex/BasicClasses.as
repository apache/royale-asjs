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
internal class BasicClasses
{
	COMPILE::JS
	{
		import org.apache.flex.html.util.addElementToWrapper; addElementToWrapper;
	}
    import org.apache.flex.html.ToolTip; ToolTip;
	import org.apache.flex.html.accessories.NumericOnlyTextInputBead; NumericOnlyTextInputBead;
    import org.apache.flex.html.beads.DispatchInputFinishedBead; DispatchInputFinishedBead;
	import org.apache.flex.html.accessories.PasswordInputBead; PasswordInputBead;
	import org.apache.flex.html.accessories.PasswordInputRemovableBead; PasswordInputRemovableBead;
	import org.apache.flex.html.accessories.TextPromptBead; TextPromptBead;
	import org.apache.flex.html.beads.AbsolutePositioningViewBeadBase; AbsolutePositioningViewBeadBase;
    import org.apache.flex.html.beads.AlertView; AlertView;
    import org.apache.flex.html.beads.models.AlertModel; AlertModel;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.BackgroundImageBead; BackgroundImageBead;
	}
	import org.apache.flex.html.beads.ButtonBarView; ButtonBarView;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.CheckBoxView; CheckBoxView;
	}
    import org.apache.flex.html.beads.ComboBoxView; ComboBoxView;
    import org.apache.flex.html.beads.ContainerView; ContainerView;
	import org.apache.flex.html.beads.GroupView; GroupView;
	COMPILE::SWF
	{
	    import org.apache.flex.html.beads.ControlBarMeasurementBead; ControlBarMeasurementBead;
	    import org.apache.flex.html.beads.CSSButtonView; CSSButtonView;
	    import org.apache.flex.html.beads.CSSImageAndTextButtonView; CSSImageAndTextButtonView;
		import org.apache.flex.html.beads.CSSTextButtonView; CSSTextButtonView;
	    import org.apache.flex.html.beads.CSSTextToggleButtonView; CSSTextToggleButtonView;
		import org.apache.flex.html.beads.DropDownListView; DropDownListView;
		import org.apache.flex.html.beads.CloseButtonView; CloseButtonView;
    	import org.apache.flex.html.beads.ImageAndTextButtonView; ImageAndTextButtonView;
		import org.apache.flex.html.beads.ImageView; org.apache.flex.html.beads.ImageView;
	}
	import org.apache.flex.html.beads.ImageButtonView; ImageButtonView;
	import org.apache.flex.html.beads.BinaryImageLoader; BinaryImageLoader;
	import org.apache.flex.html.beads.models.BinaryImageModel; BinaryImageModel;
	import org.apache.flex.html.beads.ListView; ListView;
	import org.apache.flex.html.beads.NumericStepperView; NumericStepperView;
    import org.apache.flex.html.beads.PanelView; PanelView;
	import org.apache.flex.html.supportClasses.PanelLayoutProxy; PanelLayoutProxy;
    import org.apache.flex.html.beads.SliderView; SliderView;
    import org.apache.flex.html.beads.PanelWithControlBarView; PanelWithControlBarView;
    import org.apache.flex.html.beads.AccordionItemRendererView; AccordionItemRendererView;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.RadioButtonView; RadioButtonView;
		import org.apache.flex.html.beads.VScrollBarView; VScrollBarView;
		import org.apache.flex.html.beads.HScrollBarView; HScrollBarView;
    	import org.apache.flex.html.beads.ScrollBarView; ScrollBarView;
		import org.apache.flex.html.beads.SimpleAlertView; SimpleAlertView;
    	import org.apache.flex.html.beads.SingleLineBorderBead; SingleLineBorderBead;
        import org.apache.flex.html.beads.SliderThumbView; SliderThumbView;
        import org.apache.flex.html.beads.SliderTrackView; SliderTrackView;
		import org.apache.flex.html.beads.SingleLineBorderWithChangeListenerBead; SingleLineBorderWithChangeListenerBead;
	}
	import org.apache.flex.html.beads.SpinnerView; SpinnerView;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.SolidBackgroundBead; SolidBackgroundBead;
		import org.apache.flex.html.beads.SolidBackgroundWithChangeListenerBead; SolidBackgroundWithChangeListenerBead;
    	import org.apache.flex.html.beads.TextButtonMeasurementBead; TextButtonMeasurementBead;
		import org.apache.flex.html.beads.TextFieldLabelMeasurementBead; TextFieldLabelMeasurementBead;
    	import org.apache.flex.html.beads.TextAreaView; TextAreaView;
    	import org.apache.flex.html.beads.TextButtonView; TextButtonView;
    	import org.apache.flex.html.beads.TextFieldView; TextFieldView;
    	import org.apache.flex.html.beads.TextInputView; TextInputView;
	    import org.apache.flex.html.beads.TextInputWithBorderView; TextInputWithBorderView;
	}
	import org.apache.flex.html.beads.models.AlertModel; AlertModel;
	import org.apache.flex.html.beads.models.ArraySelectionModel; ArraySelectionModel;
	import org.apache.flex.html.beads.models.ArrayListSelectionModel; ArrayListSelectionModel;
    import org.apache.flex.html.beads.models.RangeModel; RangeModel;
    import org.apache.flex.html.beads.models.RangeModelExtended; RangeModelExtended;
	import org.apache.flex.html.beads.models.ComboBoxModel; ComboBoxModel;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.models.ImageModel; ImageModel;
	    import org.apache.flex.html.beads.models.ImageAndTextModel; ImageAndTextModel;
	}
	import org.apache.flex.html.beads.models.PanelModel; PanelModel;
	COMPILE::SWF
	{
	    import org.apache.flex.html.beads.models.SingleLineBorderModel; SingleLineBorderModel;
	}
	import org.apache.flex.html.beads.models.TextModel; TextModel;
    import org.apache.flex.html.beads.models.TitleBarModel; TitleBarModel;
	import org.apache.flex.html.beads.models.ToggleButtonModel; ToggleButtonModel;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.models.ValueToggleButtonModel; ValueToggleButtonModel;
	}
	import org.apache.flex.html.beads.models.ViewportModel; ViewportModel;
	COMPILE::SWF
	{
	    import org.apache.flex.html.beads.controllers.AlertController; AlertController;
    	import org.apache.flex.html.beads.controllers.DropDownListController; DropDownListController;
		import org.apache.flex.html.beads.controllers.EditableTextKeyboardController; EditableTextKeyboardController;
	}
    import org.apache.flex.html.beads.controllers.ComboBoxController; ComboBoxController;
    import org.apache.flex.html.beads.controllers.AccordionItemRendererMouseController; AccordionItemRendererMouseController;
    import org.apache.flex.html.beads.controllers.ItemRendererMouseController; ItemRendererMouseController;
    import org.apache.flex.html.beads.controllers.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
	import org.apache.flex.html.beads.controllers.TreeSingleSelectionMouseController; TreeSingleSelectionMouseController;
    import org.apache.flex.html.beads.controllers.SliderMouseController; SliderMouseController;
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.controllers.SpinnerMouseController; SpinnerMouseController;
	    import org.apache.flex.html.beads.controllers.VScrollBarMouseController; VScrollBarMouseController;
		import org.apache.flex.html.beads.controllers.HScrollBarMouseController; HScrollBarMouseController;
	}
	import org.apache.flex.html.beads.layouts.ButtonBarLayout; ButtonBarLayout;
    import org.apache.flex.html.beads.layouts.VerticalLayout; VerticalLayout;
    import org.apache.flex.html.beads.layouts.VerticalLayoutWithPaddingAndGap; VerticalLayoutWithPaddingAndGap;
	import org.apache.flex.html.beads.layouts.VerticalFlexLayout; VerticalFlexLayout;
	import org.apache.flex.html.beads.layouts.HorizontalLayout; HorizontalLayout;
    import org.apache.flex.html.beads.layouts.HorizontalLayoutWithPaddingAndGap; HorizontalLayoutWithPaddingAndGap;
	import org.apache.flex.html.beads.layouts.HorizontalFlexLayout; HorizontalFlexLayout;
    import org.apache.flex.html.beads.layouts.BasicLayout; BasicLayout;
    import org.apache.flex.html.beads.layouts.RemovableBasicLayout; RemovableBasicLayout;
	import org.apache.flex.html.beads.layouts.OneFlexibleChildHorizontalLayout; OneFlexibleChildHorizontalLayout;
	import org.apache.flex.html.beads.layouts.OneFlexibleChildVerticalLayout; OneFlexibleChildVerticalLayout;
	
	COMPILE::SWF
	{
		import org.apache.flex.html.beads.layouts.HScrollBarLayout; HScrollBarLayout;
    	import org.apache.flex.html.beads.layouts.VScrollBarLayout; VScrollBarLayout;
		import org.apache.flex.html.supportClasses.ContainerContentArea; ContainerContentArea;
	}
	import org.apache.flex.html.beads.layouts.TileLayout; TileLayout;
    import org.apache.flex.html.beads.TextItemRendererFactoryForArrayData; TextItemRendererFactoryForArrayData;
	import org.apache.flex.html.beads.DataItemRendererFactoryForArrayData; DataItemRendererFactoryForArrayData;
    import org.apache.flex.html.beads.DynamicItemsRendererFactoryForArrayListData; DynamicItemsRendererFactoryForArrayListData;
	import org.apache.flex.html.beads.DataItemRendererFactoryForArrayList; DataItemRendererFactoryForArrayList;
	import org.apache.flex.html.beads.DataItemRendererFactoryForHierarchicalData; DataItemRendererFactoryForHierarchicalData;
	import org.apache.flex.html.supportClasses.DataGroup; DataGroup;
	import org.apache.flex.html.supportClasses.Viewport; Viewport;
	import org.apache.flex.html.supportClasses.ScrollingViewport; ScrollingViewport;
	import org.apache.flex.html.supportClasses.TextButtonItemRenderer; TextButtonItemRenderer;

	import org.apache.flex.html.DataGridButtonBarTextButton; DataGridButtonBarTextButton;
	import org.apache.flex.html.DataGridButtonBar; DataGridButtonBar;
	import org.apache.flex.html.beads.DataGridColumnView; DataGridColumnView;
	import org.apache.flex.html.beads.DataGridView; DataGridView;
	import org.apache.flex.html.beads.IDataGridView; IDataGridView;
	import org.apache.flex.html.beads.DataGridPercentageView; DataGridPercentageView;
	import org.apache.flex.html.beads.DateChooserView; DateChooserView;
	import org.apache.flex.html.beads.DateFieldView; DateFieldView;
	import org.apache.flex.html.beads.DecrementButtonView; DecrementButtonView;
	import org.apache.flex.html.beads.IncrementButtonView; IncrementButtonView;
	import org.apache.flex.html.beads.RangeStepperView; RangeStepperView;
    import org.apache.flex.html.beads.layouts.FlexibleFirstChildHorizontalLayout; FlexibleFirstChildHorizontalLayout;
	import org.apache.flex.html.beads.models.DataGridModel; DataGridModel;
	import org.apache.flex.html.beads.models.DateChooserModel; DateChooserModel;
	import org.apache.flex.html.beads.models.DataGridPresentationModel; DataGridPresentationModel;
	import org.apache.flex.html.beads.controllers.CalendarNavigation; CalendarNavigation;
	import org.apache.flex.html.beads.controllers.DateChooserMouseController; DateChooserMouseController;
	import org.apache.flex.html.beads.controllers.DateChooserKeyboardController; DateChooserKeyboardController;
	import org.apache.flex.html.beads.controllers.DateFieldMouseController; DateFieldMouseController;
	import org.apache.flex.html.beads.controllers.RangeStepperMouseController; RangeStepperMouseController;
	import org.apache.flex.html.supportClasses.DataGridColumn; DataGridColumn;
	import org.apache.flex.html.supportClasses.DateChooserButton; DateChooserButton;
	import org.apache.flex.html.supportClasses.DateHeaderButton; DateHeaderButton;
    import org.apache.flex.html.supportClasses.DateChooserList; DateChooserList;
    import org.apache.flex.html.supportClasses.DateItemRenderer; DateItemRenderer;
	import org.apache.flex.html.supportClasses.GraphicsItemRenderer; GraphicsItemRenderer;

    import org.apache.flex.html.beads.TitleBarView; TitleBarView;
    import org.apache.flex.html.beads.TitleBarMeasurementBead; TitleBarMeasurementBead;

	import org.apache.flex.html.beads.WebBrowserView; WebBrowserView;
	import org.apache.flex.html.beads.models.WebBrowserModel; WebBrowserModel;
	
	import org.apache.flex.core.ListBase; ListBase;
	import org.apache.flex.core.Lookalike; Lookalike;
	import org.apache.flex.core.FilledRectangle; FilledRectangle;
    import org.apache.flex.core.UIBase; UIBase;
	COMPILE::JS
	{
		import org.apache.flex.core.UIElement; UIElement;
	}
    import org.apache.flex.core.SimpleApplication; SimpleApplication;
	import org.apache.flex.svg.GraphicContainer; GraphicContainer;
	import org.apache.flex.svg.DOMWrapper; DOMWrapper;
	
	import org.apache.flex.svg.GraphicShape; GraphicShape;
	import org.apache.flex.svg.Rect; Rect;
	import org.apache.flex.svg.Ellipse; Ellipse;
	import org.apache.flex.svg.Circle; Circle;
	import org.apache.flex.svg.Image; Image;
	import org.apache.flex.svg.BinaryImage; BinaryImage;
	import org.apache.flex.svg.beads.ImageView; org.apache.flex.svg.beads.ImageView;
	import org.apache.flex.svg.Path; Path;
	import org.apache.flex.svg.Text; Text;
	import org.apache.flex.svg.CompoundGraphic; CompoundGraphic;

    import org.apache.flex.html.beads.models.DataProviderModel; DataProviderModel;
	import org.apache.flex.html.beads.DataContainerView; DataContainerView;

	COMPILE::SWF
	{
		import org.apache.flex.html.beads.HRuleView; HRuleView;
		import org.apache.flex.html.beads.VRuleView; VRuleView;
		import org.apache.flex.html.beads.MultilineTextFieldView; MultilineTextFieldView;
	}
	
	import org.apache.flex.html.SubAppLoader; SubAppLoader;
	
	import org.apache.flex.html.Table; Table;
	import org.apache.flex.html.TableRow; TableRow;
	import org.apache.flex.html.TableCell; TableCell;
	import org.apache.flex.html.TableHeader; TableHeader;
	import org.apache.flex.html.beads.TableCellView; TableCellView;
	import org.apache.flex.html.beads.layouts.SimpleTableLayout; SimpleTableLayout;
	import org.apache.flex.html.beads.layouts.TableCellLayout; TableCellLayout;
	import org.apache.flex.html.beads.layouts.TableHeaderLayout; TableHeaderLayout;
    
    import org.apache.flex.css2.Cursors; Cursors;
    COMPILE::SWF
    {
        import org.apache.flex.css2.Copy; Copy;
		import org.apache.flex.css2.DragMove; DragMove;
		import org.apache.flex.css2.DragReject; DragReject;
    }
}

}

