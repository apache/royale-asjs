////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
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
		import org.apache.royale.html.util.addElementToWrapper; addElementToWrapper;
		import org.apache.royale.html.util.addSvgElementToWrapper; addSvgElementToWrapper;
		import org.apache.royale.html.util.createSVG; createSVG;
		import org.apache.royale.html.util.removeCSSStyleProperty; removeCSSStyleProperty;
	}
	import org.apache.royale.html.ToolTip; ToolTip;
	import org.apache.royale.html.accessories.NumericOnlyTextInputBead; NumericOnlyTextInputBead;
	import org.apache.royale.html.accessories.RestrictTextInputBead; RestrictTextInputBead;
	import org.apache.royale.html.accessories.PasswordInputBead; PasswordInputBead;
	import org.apache.royale.html.accessories.PasswordInputRemovableBead; PasswordInputRemovableBead;
	import org.apache.royale.html.accessories.TextPromptBead; TextPromptBead;
	import org.apache.royale.html.beads.AbsolutePositioningViewBeadBase; AbsolutePositioningViewBeadBase;
	import org.apache.royale.html.beads.AlertView; AlertView;
	import org.apache.royale.html.beads.ColorSpectrumView; ColorSpectrumView;
	import org.apache.royale.html.supportClasses.ColorPickerPopUp; ColorPickerPopUp;
	import org.apache.royale.html.beads.controllers.AlertController; AlertController;
	import org.apache.royale.html.beads.controllers.ColorSpectrumMouseController; ColorSpectrumMouseController;
	
	import org.apache.royale.html.beads.DividedContainerView; DividedContainerView;
	import org.apache.royale.html.beads.models.DividedContainerModel; DividedContainerModel;
	import org.apache.royale.html.beads.layouts.HDividedContainerLayout; HDividedContainerLayout;
	import org.apache.royale.html.beads.layouts.VDividedContainerLayout; VDividedContainerLayout;
	import org.apache.royale.html.supportClasses.DividedContainerDivider; DividedContainerDivider;
	import org.apache.royale.html.supportClasses.HDividedContainerGripper; HDividedContainerGripper;
	import org.apache.royale.html.supportClasses.VDividedContainerGripper; VDividedContainerGripper;
	import org.apache.royale.html.beads.controllers.HDividedContainerMouseController; HDividedContainerMouseController;
	import org.apache.royale.html.beads.controllers.VDividedContainerMouseController; VDividedContainerMouseController;
	import org.apache.royale.html.beads.controllers.ItemRendererMouseController; ItemRendererMouseController;

	import org.apache.royale.html.MenuBar; MenuBar;
	import org.apache.royale.html.beads.models.MenuBarModel; MenuBarModel;
	import org.apache.royale.html.supportClasses.MenuBarItemRenderer; MenuBarItemRenderer;
	import org.apache.royale.html.beads.controllers.MenuBarMouseController; MenuBarMouseController;
	import org.apache.royale.html.Menu; Menu;
	import org.apache.royale.html.beads.MenuView; MenuView;
	import org.apache.royale.html.beads.MenuFactory; MenuFactory;
	import org.apache.royale.html.beads.controllers.MenuSelectionMouseController; MenuSelectionMouseController;
	import org.apache.royale.html.supportClasses.MenuItemRenderer; MenuItemRenderer;
	import org.apache.royale.html.supportClasses.CascadingMenuItemRenderer; CascadingMenuItemRenderer;
	import org.apache.royale.html.CascadingMenu; CascadingMenu;
	import org.apache.royale.html.CascadingMenuWithOnScreenCheck; CascadingMenuWithOnScreenCheck;
	import org.apache.royale.html.beads.CascadingMenuFactory; CascadingMenuFactory;
	import org.apache.royale.html.beads.models.CascadingMenuModel; CascadingMenuModel;
	import org.apache.royale.html.beads.controllers.CascadingMenuSelectionMouseController; CascadingMenuSelectionMouseController;
	import org.apache.royale.html.supportClasses.CascadingMenuItemRenderer; CascadingMenuItemRenderer;
	import org.apache.royale.html.beads.SolidBackgroundSelectableItemRendererBead; SolidBackgroundSelectableItemRendererBead;
	import org.apache.royale.html.beads.SolidBackgroundRuntimeSelectableItemRendererBead; SolidBackgroundRuntimeSelectableItemRendererBead;
	import org.apache.royale.html.beads.AlternatingBackgroundColorSelectableItemRendererBead; AlternatingBackgroundColorSelectableItemRendererBead;
	
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.BackgroundImageBead; BackgroundImageBead;
		import org.apache.royale.html.supportClasses.ContainerContentArea; ContainerContentArea;
		import org.apache.royale.html.beads.TextFieldViewBase; TextFieldViewBase;
	}
	import org.apache.royale.html.beads.ButtonBarView; ButtonBarView;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.CheckBoxView; CheckBoxView;
	}
	import org.apache.royale.html.beads.ComboBoxView; ComboBoxView;
	import org.apache.royale.html.beads.ColorPickerView; ColorPickerView;
	import org.apache.royale.html.MXMLBeadView; MXMLBeadView;
	import org.apache.royale.html.beads.GroupView; GroupView;
	import org.apache.royale.html.beads.ContainerView; ContainerView;
	import org.apache.royale.core.supportClasses.StyledImageBase; StyledImageBase;
	import org.apache.royale.html.beads.plugin.ModalDisplay; ModalDisplay;


	COMPILE::SWF
	{
		import org.apache.royale.html.beads.ControlBarMeasurementBead; ControlBarMeasurementBead;
		import org.apache.royale.html.beads.CSSButtonView; CSSButtonView;
		import org.apache.royale.html.beads.CSSImageAndTextButtonView; CSSImageAndTextButtonView;
		import org.apache.royale.html.beads.CSSTextButtonView; CSSTextButtonView;
		import org.apache.royale.html.beads.CSSTextToggleButtonView; CSSTextToggleButtonView;
		import org.apache.royale.html.beads.DropDownListView; DropDownListView;
		import org.apache.royale.html.beads.CloseButtonView; CloseButtonView;
		import org.apache.royale.html.beads.ImageAndTextButtonView; ImageAndTextButtonView;
		import org.apache.royale.html.beads.ImageView; org.apache.royale.html.beads.ImageView;
	}
	import org.apache.royale.html.beads.ImageButtonView; ImageButtonView;
	import org.apache.royale.html.beads.BinaryImageLoader; BinaryImageLoader;
	import org.apache.royale.html.beads.models.BinaryImageModel; BinaryImageModel;

	import org.apache.royale.html.beads.ListView; ListView;
	import org.apache.royale.html.beads.ListOwnerViewItemRendererInitializer; ListOwnerViewItemRendererInitializer;
	import org.apache.royale.html.beads.TreeItemRendererInitializer; TreeItemRendererInitializer;
	import org.apache.royale.html.beads.HorizontalListItemRendererInitializer; HorizontalListItemRendererInitializer;
	
	import org.apache.royale.html.beads.MultiSelectionListView; MultiSelectionListView;
	import org.apache.royale.html.beads.NumericStepperView; NumericStepperView;
	import org.apache.royale.html.beads.PanelView; PanelView;
	import org.apache.royale.html.supportClasses.PanelLayoutProxy; PanelLayoutProxy;
	import org.apache.royale.html.beads.SliderView; SliderView;
	import org.apache.royale.html.beads.layouts.HorizontalSliderLayout; HorizontalSliderLayout;
	import org.apache.royale.html.beads.layouts.VerticalSliderLayout; VerticalSliderLayout;
	import org.apache.royale.html.beads.PanelWithControlBarView; PanelWithControlBarView;
	import org.apache.royale.html.beads.AccordionItemRendererView; AccordionItemRendererView;
	import org.apache.royale.html.supportClasses.MXMLItemRenderer; MXMLItemRenderer;
	import org.apache.royale.core.StyledMXMLItemRenderer; StyledMXMLItemRenderer;

	COMPILE::SWF
	{
		import org.apache.royale.html.beads.RadioButtonView; RadioButtonView;
		import org.apache.royale.html.beads.VScrollBarView; VScrollBarView;
		import org.apache.royale.html.beads.HScrollBarView; HScrollBarView;
		import org.apache.royale.html.beads.ScrollBarView; ScrollBarView;
		import org.apache.royale.html.beads.SimpleAlertView; SimpleAlertView;
		import org.apache.royale.html.beads.SingleLineBorderBead; SingleLineBorderBead;
		import org.apache.royale.html.beads.SliderThumbView; SliderThumbView;
		import org.apache.royale.html.beads.SliderTrackView; SliderTrackView;
		import org.apache.royale.html.beads.SingleLineBorderWithChangeListenerBead; SingleLineBorderWithChangeListenerBead;
	}

	import org.apache.royale.html.beads.SpinnerView; SpinnerView;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.SolidBackgroundBead; SolidBackgroundBead;
		import org.apache.royale.html.beads.SolidBackgroundWithChangeListenerBead; SolidBackgroundWithChangeListenerBead;
		import org.apache.royale.html.beads.TextButtonMeasurementBead; TextButtonMeasurementBead;
		import org.apache.royale.html.beads.TextFieldLabelMeasurementBead; TextFieldLabelMeasurementBead;
		import org.apache.royale.html.beads.TextAreaView; TextAreaView;
		import org.apache.royale.html.beads.TextButtonView; TextButtonView;
		import org.apache.royale.html.beads.TextFieldView; TextFieldView;
		import org.apache.royale.html.beads.TextInputView; TextInputView;
		import org.apache.royale.html.beads.TextInputWithBorderView; TextInputWithBorderView;
	}
	import org.apache.royale.html.beads.models.AlertModel; AlertModel;
	import org.apache.royale.html.beads.models.ArraySelectionModel; ArraySelectionModel;
	import org.apache.royale.html.beads.models.ArrayListSelectionModel; ArrayListSelectionModel;
	import org.apache.royale.html.beads.models.SingleSelectionCollectionViewModel; SingleSelectionCollectionViewModel;
	import org.apache.royale.html.beads.models.MultiSelectionCollectionViewModel; MultiSelectionCollectionViewModel;
	import org.apache.royale.html.beads.models.TreeModel; TreeModel;
	import org.apache.royale.html.beads.models.MultiSelectionTreeModel; MultiSelectionTreeModel;
	import org.apache.royale.html.beads.models.MenuModel; MenuModel;
	import org.apache.royale.html.beads.models.RangeModel; RangeModel;
	import org.apache.royale.html.beads.models.RangeModelExtended; RangeModelExtended;
	import org.apache.royale.html.beads.models.ComboBoxModel; ComboBoxModel;
	import org.apache.royale.html.beads.models.ViewportModel; ViewportModel;

	COMPILE::SWF
	{
		import org.apache.royale.html.beads.models.ImageModel; ImageModel;
		import org.apache.royale.html.beads.models.ImageAndTextModel; ImageAndTextModel;
	}
	import org.apache.royale.html.beads.models.PanelModel; PanelModel;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.models.SingleLineBorderModel; SingleLineBorderModel;
	}

	import org.apache.royale.html.beads.models.ColorModel; ColorModel;
	import org.apache.royale.html.beads.models.ColorSpectrumModel; ColorSpectrumModel;
	import org.apache.royale.html.beads.models.TextModel; TextModel;
	import org.apache.royale.html.beads.models.NonNullTextModel; NonNullTextModel;
	import org.apache.royale.html.beads.models.TitleBarModel; TitleBarModel;
	import org.apache.royale.html.beads.models.ToggleButtonModel; ToggleButtonModel;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.models.ValueToggleButtonModel; ValueToggleButtonModel;
	}
	import org.apache.royale.html.beads.models.ViewportModel; ViewportModel;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.controllers.DropDownListController; DropDownListController;
		import org.apache.royale.html.beads.controllers.EditableTextKeyboardController; EditableTextKeyboardController;
	}
	import org.apache.royale.html.beads.controllers.ComboBoxController; ComboBoxController;
	import org.apache.royale.html.beads.controllers.AccordionItemRendererMouseController; AccordionItemRendererMouseController;
	import org.apache.royale.html.beads.controllers.ItemRendererMouseController; ItemRendererMouseController;
	import org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
	import org.apache.royale.html.beads.controllers.ListMultiSelectionMouseController; ListMultiSelectionMouseController;
	import org.apache.royale.html.beads.MultiSelectionItemRendererClassFactory; MultiSelectionItemRendererClassFactory;
	import org.apache.royale.html.beads.controllers.TreeMultiSelectionMouseController; TreeMultiSelectionMouseController;
	import org.apache.royale.html.beads.controllers.TreeSingleSelectionMouseController; TreeSingleSelectionMouseController;
	import org.apache.royale.html.beads.controllers.MenuSelectionMouseController; MenuSelectionMouseController;
	import org.apache.royale.html.beads.controllers.HSliderMouseController; HSliderMouseController;
	import org.apache.royale.html.beads.controllers.VSliderMouseController; VSliderMouseController;
	COMPILE::SWF
	{
		import org.apache.royale.html.beads.controllers.SpinnerMouseController; SpinnerMouseController;
		import org.apache.royale.html.beads.controllers.VScrollBarMouseController; VScrollBarMouseController;
		import org.apache.royale.html.beads.controllers.HScrollBarMouseController; HScrollBarMouseController;
	}
	import org.apache.royale.html.beads.layouts.ButtonBarLayout; ButtonBarLayout;
	import org.apache.royale.html.beads.layouts.VerticalLayout; VerticalLayout;
	import org.apache.royale.html.beads.layouts.VerticalLayoutWithPaddingAndGap; VerticalLayoutWithPaddingAndGap;
	import org.apache.royale.html.beads.layouts.VerticalFlexLayout; VerticalFlexLayout;
	import org.apache.royale.html.beads.layouts.HorizontalLayout; HorizontalLayout;
	import org.apache.royale.html.beads.layouts.HorizontalLayoutWithPaddingAndGap; HorizontalLayoutWithPaddingAndGap;
	import org.apache.royale.html.beads.layouts.HorizontalFlexLayout; HorizontalFlexLayout;
	import org.apache.royale.html.beads.layouts.BasicLayout; BasicLayout;
	import org.apache.royale.html.beads.layouts.RemovableBasicLayout; RemovableBasicLayout;
	import org.apache.royale.html.beads.layouts.OneFlexibleChildHorizontalLayout; OneFlexibleChildHorizontalLayout;
	import org.apache.royale.html.beads.layouts.OneFlexibleChildVerticalLayout; OneFlexibleChildVerticalLayout;



	COMPILE::SWF
	{
		import org.apache.royale.html.beads.layouts.HScrollBarLayout; HScrollBarLayout;
		import org.apache.royale.html.beads.layouts.VScrollBarLayout; VScrollBarLayout;
		import org.apache.royale.html.supportClasses.ContainerContentArea; ContainerContentArea;
	}
	import org.apache.royale.html.beads.layouts.TileLayout; TileLayout;
	import org.apache.royale.html.beads.TextItemRendererFactoryForArrayData; TextItemRendererFactoryForArrayData;
	import org.apache.royale.html.beads.DataItemRendererFactoryForArrayData; DataItemRendererFactoryForArrayData;
	import org.apache.royale.html.beads.DynamicItemsRendererFactoryForArrayListData; DynamicItemsRendererFactoryForArrayListData;
	import org.apache.royale.html.beads.DataItemRendererFactoryForArrayList; DataItemRendererFactoryForArrayList;
	import org.apache.royale.html.beads.DataItemRendererFactoryForHierarchicalData; DataItemRendererFactoryForHierarchicalData;
	import org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView; DataItemRendererFactoryForCollectionView;
	import org.apache.royale.html.supportClasses.DataGroup; DataGroup;
	import org.apache.royale.html.supportClasses.Border; Border;
	import org.apache.royale.html.supportClasses.Viewport; Viewport;
	import org.apache.royale.html.supportClasses.ScrollingViewport; ScrollingViewport;
	import org.apache.royale.html.supportClasses.TextButtonItemRenderer; TextButtonItemRenderer;
	import org.apache.royale.html.supportClasses.UIItemRendererBase; UIItemRendererBase;
	import org.apache.royale.html.DataGridButtonBarTextButton; DataGridButtonBarTextButton;
	import org.apache.royale.html.DataGridButtonBar; DataGridButtonBar;
	import org.apache.royale.html.beads.DataGridColumnView; DataGridColumnView;
	import org.apache.royale.html.beads.DataGridView; DataGridView;
	import org.apache.royale.html.beads.IDataGridView; IDataGridView;
	import org.apache.royale.html.beads.DataGridPercentageView; DataGridPercentageView;
	import org.apache.royale.html.beads.layouts.DataGridLayout; DataGridLayout;
	import org.apache.royale.html.beads.layouts.DataGridPercentageLayout; DataGridPercentageLayout;
	import org.apache.royale.html.beads.layouts.LayoutChangeNotifier; LayoutChangeNotifier;
	import org.apache.royale.html.beads.DateChooserView; DateChooserView;
	import org.apache.royale.html.beads.DateFieldView; DateFieldView;
	import org.apache.royale.html.beads.DecrementButtonView; DecrementButtonView;
	import org.apache.royale.html.beads.IncrementButtonView; IncrementButtonView;
	import org.apache.royale.html.beads.RangeStepperView; RangeStepperView;
	import org.apache.royale.html.beads.layouts.FlexibleFirstChildHorizontalLayout; FlexibleFirstChildHorizontalLayout;
	import org.apache.royale.html.beads.models.DataGridModel; DataGridModel;
	import org.apache.royale.html.beads.models.DataGridCollectionViewModel; DataGridCollectionViewModel;
	import org.apache.royale.html.beads.models.DateChooserModel; DateChooserModel;
	import org.apache.royale.html.beads.models.DataGridPresentationModel; DataGridPresentationModel;
	import org.apache.royale.html.beads.controllers.DateChooserMouseController; DateChooserMouseController;
	import org.apache.royale.html.beads.controllers.DateFieldMouseController; DateFieldMouseController;
	import org.apache.royale.html.beads.controllers.RangeStepperMouseController; RangeStepperMouseController;
	import org.apache.royale.html.supportClasses.DataGridColumn; DataGridColumn;
	import org.apache.royale.html.supportClasses.DateChooserButton; DateChooserButton;
	import org.apache.royale.html.supportClasses.DateHeaderButton; DateHeaderButton;
	import org.apache.royale.html.supportClasses.DateChooserList; DateChooserList;
	import org.apache.royale.html.supportClasses.DateItemRenderer; DateItemRenderer;
	import org.apache.royale.html.supportClasses.GraphicsItemRenderer; GraphicsItemRenderer;
	import org.apache.royale.html.supportClasses.NestedStringItemRenderer; NestedStringItemRenderer;

	import org.apache.royale.html.beads.TitleBarView; TitleBarView;
	import org.apache.royale.html.beads.TitleBarMeasurementBead; TitleBarMeasurementBead;

	import org.apache.royale.html.beads.WebBrowserView; WebBrowserView;
	import org.apache.royale.html.beads.models.WebBrowserModel; WebBrowserModel;

	import org.apache.royale.core.Lookalike; Lookalike;
	import org.apache.royale.core.FilledRectangle; FilledRectangle;
	import org.apache.royale.core.UIBase; UIBase;
	import org.apache.royale.core.StyledUIBase; StyledUIBase;
	import org.apache.royale.core.GroupBase; GroupBase;
	import org.apache.royale.core.ContainerBase; ContainerBase;
	import org.apache.royale.core.ViewBase; ViewBase;

	COMPILE::JS
	{
		import org.apache.royale.core.UIElement; UIElement;
	}
	import org.apache.royale.core.SimpleApplication; SimpleApplication;
	import org.apache.royale.svg.GraphicContainer; GraphicContainer;
	import org.apache.royale.svg.DOMWrapper; DOMWrapper;

	import org.apache.royale.svg.GraphicShape; GraphicShape;
	import org.apache.royale.svg.Rect; Rect;
	import org.apache.royale.svg.Ellipse; Ellipse;
	import org.apache.royale.svg.Circle; Circle;
	import org.apache.royale.svg.Image; Image;
	import org.apache.royale.svg.BinaryImage; BinaryImage;
	import org.apache.royale.svg.beads.ImageView; org.apache.royale.svg.beads.ImageView;
	import org.apache.royale.svg.Path; Path;
	import org.apache.royale.svg.Text; Text;
	import org.apache.royale.svg.CompoundGraphic; CompoundGraphic;
	import org.apache.royale.svg.TransformableCompoundGraphic; TransformableCompoundGraphic;

	import org.apache.royale.html.beads.models.DataProviderModel; DataProviderModel;
	import org.apache.royale.html.beads.DataContainerView; DataContainerView;

	COMPILE::SWF
	{
		import org.apache.royale.html.beads.HRuleView; HRuleView;
		import org.apache.royale.html.beads.VRuleView; VRuleView;
		import org.apache.royale.html.beads.MultilineTextFieldView; MultilineTextFieldView;
	}

	import org.apache.royale.html.SubAppLoader; SubAppLoader;

	import org.apache.royale.html.Table; Table;
	import org.apache.royale.html.TableRow; TableRow;
	import org.apache.royale.html.TableCell; TableCell;
	import org.apache.royale.html.TableHeader; TableHeader;
	import org.apache.royale.html.beads.TableCellView; TableCellView;
	import org.apache.royale.html.beads.layouts.SimpleTableLayout; SimpleTableLayout;
	import org.apache.royale.html.beads.layouts.TableCellLayout; TableCellLayout;
	import org.apache.royale.html.beads.layouts.TableHeaderLayout; TableHeaderLayout;

	import org.apache.royale.css2.Cursors; Cursors;
	COMPILE::SWF
	{
		import org.apache.royale.css2.Copy; Copy;
		import org.apache.royale.css2.DragMove; DragMove;
		import org.apache.royale.css2.DragReject; DragReject;
	}
	
	import org.apache.royale.html.TreeGrid; TreeGrid;
	import org.apache.royale.html.supportClasses.TreeGridColumn; TreeGridColumn;
	import org.apache.royale.html.supportClasses.TreeGridControlItemRenderer; TreeGridControlItemRenderer;
	import org.apache.royale.html.beads.models.TreeGridModel; TreeGridModel;
	import org.apache.royale.html.beads.layouts.TreeGridLayout; TreeGridLayout;
	import org.apache.royale.html.beads.TreeGridView; TreeGridView;
	
	import org.apache.royale.utils.UIModuleUtils; UIModuleUtils;


	import org.apache.royale.html.util.getLabelFromData; getLabelFromData;
	
	COMPILE::JS
	{
		import org.apache.royale.html.util.DialogPolyfill; DialogPolyfill;
	}
}

}

