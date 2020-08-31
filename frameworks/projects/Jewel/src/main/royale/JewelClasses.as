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
import org.apache.royale.utils.observeElementSize;

/**
     *  @private
     *  This class is used to link additional classes into jewel.swc
     *  beyond those that are found by dependecy analysis starting
     *  from the classes specified in manifest.xml.
     */
    internal class JewelClasses
    {
        import org.apache.royale.jewel.beads.models.ImageModel; ImageModel;
        import org.apache.royale.jewel.beads.models.SliderRangeModel; SliderRangeModel;
        import org.apache.royale.jewel.beads.models.AlertModel; AlertModel;
        import org.apache.royale.jewel.beads.models.TitleBarModel; TitleBarModel;
        import org.apache.royale.jewel.beads.models.TextModel; TextModel;
        import org.apache.royale.jewel.beads.models.RangeModel; RangeModel;
        import org.apache.royale.jewel.beads.models.TableModel; TableModel;
        import org.apache.royale.jewel.beads.models.DateChooserModel; DateChooserModel;
        import org.apache.royale.jewel.beads.models.DataProviderModel; DataProviderModel;
        import org.apache.royale.jewel.beads.models.ComboBoxModel; ComboBoxModel;
		import org.apache.royale.jewel.beads.models.SnackbarModel; SnackbarModel;
		import org.apache.royale.jewel.beads.models.DropDownListModel; DropDownListModel;
        import org.apache.royale.jewel.beads.models.FormItemModel; FormItemModel;
        import org.apache.royale.jewel.beads.models.WizardModel; WizardModel;
        import org.apache.royale.jewel.beads.models.WizardStep; WizardStep;
        import org.apache.royale.jewel.beads.models.PopUpModel; PopUpModel;

        import org.apache.royale.jewel.beads.controllers.PopUpMouseController; PopUpMouseController;
        import org.apache.royale.jewel.beads.controllers.SpinnerMouseController; SpinnerMouseController;
        import org.apache.royale.jewel.beads.controllers.SliderMouseController; SliderMouseController;
        import org.apache.royale.jewel.beads.controllers.DateChooserMouseController; DateChooserMouseController;
        import org.apache.royale.jewel.beads.controllers.DateFieldMouseController; DateFieldMouseController;
        import org.apache.royale.jewel.beads.controllers.AlertController; AlertController;
        import org.apache.royale.jewel.beads.controllers.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
        import org.apache.royale.jewel.beads.controllers.ListKeyDownController; ListKeyDownController;
        import org.apache.royale.jewel.beads.controllers.TableKeyDownController; TableKeyDownController;
        import org.apache.royale.jewel.beads.controllers.VirtualListKeyDownController; VirtualListKeyDownController;
        import org.apache.royale.jewel.beads.controllers.TableCellSelectionMouseController; TableCellSelectionMouseController;
        import org.apache.royale.jewel.beads.controllers.ComboBoxController; ComboBoxController;
        import org.apache.royale.jewel.beads.controllers.NumericStepperController; NumericStepperController;
		import org.apache.royale.jewel.beads.controllers.SnackbarController; SnackbarController;
		import org.apache.royale.jewel.beads.controllers.DropDownListController; DropDownListController;
        import org.apache.royale.jewel.beads.controllers.WizardController; WizardController;

        import org.apache.royale.jewel.beads.views.PopUpView; PopUpView;
        import org.apache.royale.jewel.beads.views.ImageView; ImageView;
        import org.apache.royale.jewel.beads.views.SpinnerView; SpinnerView;
        import org.apache.royale.jewel.beads.views.NumericStepperView; NumericStepperView;
        import org.apache.royale.jewel.beads.views.SliderView; SliderView;
        import org.apache.royale.jewel.beads.views.AlertView; AlertView;
        import org.apache.royale.jewel.beads.views.TitleBarView; TitleBarView;
        import org.apache.royale.jewel.beads.views.AlertTitleBarView; AlertTitleBarView;
        import org.apache.royale.jewel.beads.views.ListView; ListView;
        import org.apache.royale.jewel.beads.views.TabBarView; TabBarView;
        import org.apache.royale.jewel.beads.views.DropDownListView; DropDownListView;
        import org.apache.royale.jewel.beads.views.DropDownListView; DropDownListView;
        import org.apache.royale.jewel.beads.views.DateChooserView; DateChooserView;
        import org.apache.royale.jewel.beads.views.TableView; TableView;
        import org.apache.royale.jewel.beads.views.ComboBoxView; ComboBoxView;
        import org.apache.royale.jewel.beads.views.ComboBoxPopUpView; ComboBoxPopUpView;
        import org.apache.royale.jewel.beads.views.VirtualComboBoxPopUpView; VirtualComboBoxPopUpView;
		import org.apache.royale.jewel.beads.views.SnackbarView; SnackbarView;
        import org.apache.royale.jewel.beads.views.FormItemView; FormItemView;
        import org.apache.royale.jewel.beads.views.FormHeadingView; FormHeadingView;
        import org.apache.royale.jewel.beads.views.WizardView; WizardView;
        import org.apache.royale.jewel.beads.views.ButtonBarView; ButtonBarView;
	    import org.apache.royale.jewel.beads.views.CheckBoxView; CheckBoxView;

        COMPILE::SWF
	    {
            import org.apache.royale.jewel.beads.views.TextFieldView; TextFieldView;

            import org.apache.royale.jewel.beads.views.SliderThumbView; SliderThumbView;
            import org.apache.royale.jewel.beads.views.SliderTrackView; SliderTrackView;

            import org.apache.royale.jewel.beads.views.RadioButtonView; RadioButtonView;
            import org.apache.royale.jewel.beads.views.ButtonView; ButtonView;

            // import org.apache.royale.jewel.beads.views.DropDownListView; DropDownListView;
            import org.apache.royale.jewel.beads.controllers.DropDownListController; DropDownListController;
            import org.apache.royale.jewel.supportClasses.list.DataGroup; DataGroup;
        }

        import org.apache.royale.jewel.supportClasses.ResponsiveSizes; ResponsiveSizes;

        import org.apache.royale.jewel.supportClasses.INavigationRenderer; INavigationRenderer;
        import org.apache.royale.jewel.supportClasses.ISelectableContent; ISelectableContent;
        import org.apache.royale.jewel.supportClasses.textinput.ITextInput; ITextInput;

        import org.apache.royale.jewel.supportClasses.Viewport; Viewport;
        import org.apache.royale.jewel.supportClasses.NoViewport; NoViewport;
        import org.apache.royale.jewel.supportClasses.scrollbar.ScrollingViewport; ScrollingViewport;
        import org.apache.royale.jewel.supportClasses.datechooser.DateChooserTable; DateChooserTable;
        import org.apache.royale.jewel.supportClasses.table.TBodyContentArea; TBodyContentArea;
        import org.apache.royale.jewel.supportClasses.combobox.ComboBoxPopUp; ComboBoxPopUp;
        import org.apache.royale.jewel.supportClasses.button.SelectableButtonBase; SelectableButtonBase;
        
        import org.apache.royale.jewel.beads.views.DataGridView; DataGridView;
        import org.apache.royale.jewel.beads.layouts.DataGridLayout; DataGridLayout;
        
        import org.apache.royale.jewel.supportClasses.LayoutProxy; LayoutProxy;

        import org.apache.royale.jewel.supportClasses.util.positionInsideBoundingClientRect; positionInsideBoundingClientRect;

        //import org.apache.royale.jewel.beads.views.JewelLabelViewBead; JewelLabelViewBead;

        import org.apache.royale.jewel.beads.validators.removeErrorTip; removeErrorTip;

        import org.apache.royale.jewel.supportClasses.validators.CreditCardValidatorCardType; CreditCardValidatorCardType;

        COMPILE::JS
        {
            import org.apache.royale.utils.transparentPixelElement; transparentPixelElement;
            import org.apache.royale.utils.observeElementSize; observeElementSize;
            import org.apache.royale.utils.transparentPixelElement; transparentPixelElement;
        }

        import org.apache.royale.jewel.itemRenderers.DatagridHeaderRenderer; DatagridHeaderRenderer;

        import org.apache.royale.jewel.beads.itemRenderers.IndexedItemRendererInitializer; IndexedItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.ClassSelectorListSelectableItemRendererBead; ClassSelectorListSelectableItemRendererBead;
        import org.apache.royale.jewel.beads.itemRenderers.ClassSelectorListHoverOnlySelectableItemRendererBead; ClassSelectorListHoverOnlySelectableItemRendererBead;
        
        import org.apache.royale.jewel.beads.itemRenderers.DataContainerItemRendererInitializer; DataContainerItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.ListItemRendererInitializer; ListItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.DataGridColumnListItemRendererInitializer; DataGridColumnListItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.ButtonBarItemRendererInitializer; ButtonBarItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.TabBarItemRendererInitializer; TabBarItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.TableItemRendererInitializer; TableItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.NavigationItemRendererInitializer; NavigationItemRendererInitializer;
        import org.apache.royale.jewel.beads.itemRenderers.DropDownListItemRendererInitializer; DropDownListItemRendererInitializer;
    }
}
