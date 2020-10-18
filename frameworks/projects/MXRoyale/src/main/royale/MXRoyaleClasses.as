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
internal class MXRoyaleClasses
{
	import mx.automation.IAutomationObject; IAutomationObject;
	//import mx.controls.SWFLoader; SWFLoader;
	import mx.core.DPIClassification; DPIClassification;
	import mx.core.DesignLayer; DesignLayer;
	import mx.effects.AnimateProperty; AnimateProperty;
	//import mx.effects.easing.Cubic; Cubic;
	//import mx.effects.easing.Quintic; Quintic;
	//import mx.events.StateChangeEvent; StateChangeEvent;
	//import mx.graphics.BitmapFill; BitmapFill;
	//import mx.graphics.BitmapFillMode; BitmapFillMode;
	//import mx.managers.PopUpManagerChildList; PopUpManagerChildList;
	import mx.core.mx_internal; mx_internal;
	import mx.core.ScrollPolicy; ScrollPolicy;
	import mx.controls.beads.ToolTipBead; ToolTipBead;
	import mx.effects.IEffectInstance; IEffectInstance;
	import mx.events.EffectEvent; EffectEvent;
	import mx.graphics.IStroke; IStroke;
	import mx.graphics.IFill; IFill;
	import mx.core.EventPriority; EventPriority;
	import mx.core.IFactory; IFactory;
	import mx.core.ILayoutElement; ILayoutElement;
	import mx.collections.CursorBookmark; CursorBookmark;
	import mx.collections.ICollectionView; ICollectionView;
	import mx.collections.IViewCursor; IViewCursor;
	import mx.events.SandboxMouseEvent; SandboxMouseEvent;
	import mx.events.ResizeEvent; ResizeEvent;
	import mx.utils.StringUtil; StringUtil;
	import mx.core.DragSource; DragSource;
	import mx.events.DividerEvent; DividerEvent;
	import mx.events.ScrollEvent; ScrollEvent;
	import mx.events.MoveEvent; MoveEvent;
	import mx.events.ValidationResultEvent; ValidationResultEvent;
    import mx.containers.beads.AdvancedDataGridListVirtualListView; AdvancedDataGridListVirtualListView;
	import mx.containers.beads.DataGridListListView; DataGridListListView;
	import mx.containers.beads.AdvancedDataGridHeaderLayout; AdvancedDataGridHeaderLayout;
	import mx.containers.beads.ApplicationLayout; ApplicationLayout;
	import mx.containers.beads.BoxLayout; BoxLayout;
    import mx.containers.beads.DividedBoxLayout; DividedBoxLayout;
	import mx.containers.beads.CanvasLayout; CanvasLayout;
    import mx.containers.beads.layouts.BasicLayout; BasicLayout;
	import mx.containers.beads.PanelInternalContainer; PanelInternalContainer;
	import mx.containers.beads.PanelInternalContainerView; PanelInternalContainerView;
	import mx.controls.beads.AlertView; AlertView;
    import mx.controls.beads.controllers.AlertMouseController; AlertMouseController;
    import mx.containers.errors.ConstraintError; ConstraintError;
    import mx.containers.utilityClasses.ConstraintColumn; ConstraintColumn;
    import mx.containers.utilityClasses.ConstraintRow; ConstraintRow;
	import mx.containers.gridClasses.GridColumnInfo; GridColumnInfo;
	import mx.containers.gridClasses.GridRowInfo; GridRowInfo;
	import mx.events.CloseEvent; CloseEvent;
	import mx.controls.HRule; HRule;
	import mx.events.ListEvent; ListEvent;
	import mx.events.SliderEvent; SliderEvent;
	import mx.managers.FocusManager; FocusManager;
	import mx.utils.ArrayUtil; ArrayUtil;
	import mx.effects.Effect; Effect; 
	import mx.charts.ChartItem; ChartItem;
	import mx.core.ClassFactory; ClassFactory;
	import mx.effects.Tween; Tween;
	import mx.effects.Fade; Fade;
	import mx.core.Container;Container;

	import mx.system.ApplicationDomain; ApplicationDomain;
	import mx.rpc.http.HTTPService; mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject; mx.rpc.remoting.RemoteObject;
	import mx.rpc.remoting.CompressedRemoteObject; mx.rpc.remoting.CompressedRemoteObject;
	import mx.controls.treeClasses.ITreeDataDescriptor; ITreeDataDescriptor;
	import mx.controls.treeClasses.TreeListData; TreeListData;
    import mx.controls.listClasses.ListVerticalLayout; ListVerticalLayout;
	import mx.controls.listClasses.DataItemRendererFactoryForICollectionViewData; DataItemRendererFactoryForICollectionViewData;
    import mx.controls.listClasses.VirtualDataItemRendererFactoryForICollectionViewData; VirtualDataItemRendererFactoryForICollectionViewData;
    import mx.controls.listClasses.VirtualDataItemRendererFactoryForIListData; VirtualDataItemRendererFactoryForIListData;
	import mx.controls.treeClasses.DataItemRendererFactoryForICollectionViewHierarchicalData; DataItemRendererFactoryForICollectionViewHierarchicalData;
    import mx.controls.advancedDataGridClasses.DataItemRendererFactoryForICollectionViewAdvancedDataGridData; DataItemRendererFactoryForICollectionViewAdvancedDataGridData;
	import mx.charts.chartClasses.RenderData; RenderData;
	import mx.effects.EffectInstance; EffectInstance;
	import mx.effects.effectClasses.ActionEffectInstance; ActionEffectInstance;
	import mx.effects.effectClasses.CompositeEffectInstance; CompositeEffectInstance;
	import mx.charts.HitData; HitData;

	import mx.events.FlexEvent; FlexEvent;
	import mx.managers.PopUpManager; PopUpManager; 
	import mx.core.IVisualElementContainer; IVisualElementContainer;
	import mx.managers.BrowserManager; BrowserManager;
	import mx.charts.chartClasses.DataTransform; DataTransform;
	import mx.skins.Border; Border;
	import mx.effects.CompositeEffect; CompositeEffect;
	import mx.core.FlexVersion; FlexVersion;
	import mx.charts.chartClasses.CartesianTransform; CartesianTransform;
	import mx.charts.events.ChartItemEvent; ChartItemEvent;
	import mx.charts.chartClasses.DataTip; DataTip;
  	import mx.controls.textClasses.TextRange; TextRange;
	import mx.managers.CursorManagerPriority; CursorManagerPriority;
	import mx.logging.Log; Log;
	import mx.logging.LogLogger; LogLogger;
	import mx.logging.LogEvent; LogEvent;
	import mx.logging.LogEventLevel; LogEventLevel;
	import mx.logging.AbstractTarget; AbstractTarget;
	import mx.logging.ILogger; ILogger;
	import mx.logging.ILoggingTarget; ILoggingTarget;
	import mx.logging.errors.InvalidFilterError; InvalidFilterError;
	import mx.logging.targets.LineFormattedTarget; LineFormattedTarget;
	import mx.logging.targets.TraceTarget; TraceTarget;
	import mx.charts.chartClasses.Series; Series;
	import mx.charts.chartClasses.GraphicsUtilities; GraphicsUtilities; 
	import mx.effects.easing.Bounce; Bounce;
	import mx.effects.easing.Exponential; Exponential;
	import mx.effects.effectClasses.TweenEffectInstance; TweenEffectInstance;
	import mx.effects.effectClasses.AnimatePropertyInstance; AnimatePropertyInstance;
	import mx.effects.TweenEffect; TweenEffect; 
	import mx.rpc.Fault; Fault;
	import mx.rpc.events.InvokeEvent; InvokeEvent;
	import mx.rpc.events.ResultEvent; ResultEvent;
	import mx.rpc.AsyncResponder; AsyncResponder;
	import mx.rpc.Responder; Responder;
	import mx.printing.FlexPrintJobScaleType; FlexPrintJobScaleType; 
	import mx.skins.RectangularBorder; RectangularBorder;
	import mx.styles.IStyleClient; IStyleClient; 
	import mx.styles.ISimpleStyleClient; ISimpleStyleClient; 
	import mx.styles.StyleProxy; StyleProxy;
	import mx.styles.StyleManagerImpl; StyleManagerImpl;
	import mx.modules.IModuleInfo; IModuleInfo;
	import mx.formatters.SwitchSymbolFormatter; SwitchSymbolFormatter;
	import mx.formatters.ZipCodeFormatter; ZipCodeFormatter;
	import mx.printing.FlexPrintJob; FlexPrintJob; 
	import mx.utils.URLUtil; URLUtil;
	import mx.core.UITextField; UITextField;
	import mx.effects.Parallel; Parallel; 
	import mx.rpc.events.FaultEvent; FaultEvent;
	import mx.events.AdvancedDataGridEvent; AdvancedDataGridEvent;
	import mx.events.DataGridEvent; DataGridEvent;
	import mx.events.DataGridEventReason; DataGridEventReason;
	import mx.skins.ProgrammaticSkin; ProgrammaticSkin;
	import mx.rpc.soap.WebService; WebService;
	import mx.collections.ISort; ISort;
	import mx.collections.AsyncListView; AsyncListView;
	import mx.utils.Base64Encoder; Base64Encoder;
	import mx.utils.Base64Decoder; Base64Decoder;
	import mx.utils.BitFlagUtil; BitFlagUtil;
	import mx.events.IndexChangedEvent; IndexChangedEvent;
	import mx.events.ItemClickEvent; ItemClickEvent;
	import mx.events.ModuleEvent; ModuleEvent;
	import mx.events.MouseEvent; MouseEvent;
	import mx.managers.SystemManager; SystemManager;
	import mx.filters.BitmapFilter; BitmapFilter;
	import mx.filters.ColorMatrixFilter; ColorMatrixFilter;
	import mx.events.IOErrorEvent; IOErrorEvent;
	import mx.events.FocusEvent; FocusEvent;
	import mx.errors.EOFError; EOFError;
	import mx.events.TextEvent; TextEvent;
	import mx.display.Bitmap; Bitmap;
	import mx.display.Loader; Loader;
	import mx.external.ExternalInterface; ExternalInterface;
	import mx.events.KeyboardEvent; KeyboardEvent;
	import mx.geom.Matrix; Matrix;
	import mx.utils.ByteArray; mx.utils.ByteArray;
	import mx.controls.RichTextEditor; RichTextEditor;
	import mx.events.SecurityErrorEvent; SecurityErrorEvent;
	import mx.events.HTTPStatusEvent; HTTPStatusEvent;
	import mx.net.FileReference; FileReference;
	import mx.net.FileFilter; FileFilter;
	import mx.events.ProgressEvent; ProgressEvent;
	import mx.events.ColorPickerEvent; ColorPickerEvent;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnList; AdvancedDataGridColumnList;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridButtonBar; AdvancedDataGridButtonBar;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridListArea; AdvancedDataGridListArea;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridSingleSelectionMouseController; AdvancedDataGridSingleSelectionMouseController;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridSelectableItemRendererBead; AdvancedDataGridSelectableItemRendererBead;
    import mx.controls.dataGridClasses.DataGridColumnList; DataGridColumnList;
    import mx.controls.dataGridClasses.DataGridListArea; DataGridListArea;
	import mx.controls.dataGridClasses.DataGridListAreaViewport; DataGridListAreaViewport;
	import mx.controls.dataGridClasses.DataGridSingleSelectionMouseController; DataGridSingleSelectionMouseController;
    import mx.controls.beads.AdvancedDataGridView; AdvancedDataGridView;
    import mx.controls.beads.DataGridView; DataGridView;
    import mx.controls.beads.layouts.AdvancedDataGridLayout; AdvancedDataGridLayout;
    import mx.controls.beads.layouts.DataGridLayout; DataGridLayout;
    import mx.controls.beads.layouts.AdvancedDataGridVirtualListVerticalLayout; AdvancedDataGridVirtualListVerticalLayout;
	import mx.controls.beads.layouts.DataGridHeaderLayout; DataGridHeaderLayout;
	import mx.controls.listClasses.VirtualListVerticalLayout; VirtualListVerticalLayout;
    import mx.controls.listClasses.ListSingleSelectionMouseController; ListSingleSelectionMouseController;
    import mx.controls.treeClasses.TreeSingleSelectionMouseController; TreeSingleSelectionMouseController;
    import mx.controls.beads.TreeItemRendererMouseController; TreeItemRendererMouseController;
	import mx.formatters.Formatter; Formatter;
	import mx.formatters.IFormatter; IFormatter;
	import mx.formatters.NumberBase; NumberBase;
	import mx.formatters.NumberBaseRoundType; NumberBaseRoundType;
	import mx.formatters.CurrencyFormatter; CurrencyFormatter;
	import mx.events.CalendarLayoutChangeEvent; CalendarLayoutChangeEvent;
	import mx.net.SharedObject; SharedObject;
	import mx.net.SharedObjectJSON; SharedObjectJSON;
	import mx.modules.ModuleManager; ModuleManager;
	import mx.events.DragEvent; DragEvent;
	import mx.formatters.DateBase; DateBase;
	import mx.core.Keyboard; Keyboard;
	import mx.core.UIComponentGlobals; UIComponentGlobals;
	import mx.managers.ILayoutManagerClient; ILayoutManagerClient;
	import mx.core.LayoutDirection; LayoutDirection;
	import mx.styles.IAdvancedStyleClient; IAdvancedStyleClient;
	import mx.collections.IComplexSortField; IComplexSortField;
	import mx.core.IIMESupport; IIMESupport;
	import mx.core.InteractionMode; InteractionMode;
	import mx.collections.ComplexFieldChangeWatcher; ComplexFieldChangeWatcher;
	import mx.binding.BindabilityInfo; BindabilityInfo;
	import mx.binding.utils.ChangeWatcher; ChangeWatcher;
	import mx.binding.utils.BindingUtils; BindingUtils;
	import mx.validators.IValidatorListener; IValidatorListener;
	import mx.managers.IToolTipManagerClient; IToolTipManagerClient;
	import mx.events.ToolTipEvent; ToolTipEvent;
	import mx.core.Singleton; Singleton;
	import mx.effects.IAbstractEffect; IAbstractEffect;
	import mx.managers.ToolTipManager; ToolTipManager;
	import mx.managers.IToolTipManager2; IToolTipManager2;
	import mx.utils.PopUpUtil; PopUpUtil;
	import mx.rpc.http.HTTPMultiService; HTTPMultiService;
	import mx.messaging.messages.HTTPRequestMessage; HTTPRequestMessage;
	import mx.messaging.channels.DirectHTTPChannel; DirectHTTPChannel;
    import mx.messaging.channels.HTTPChannel; HTTPChannel;
	import mx.messaging.errors.MessageSerializationError; MessageSerializationError;
	import mx.rpc.http.SerializationFilter; SerializationFilter;
	import mx.rpc.http.AbstractOperation; AbstractOperation;
	import mx.events.MenuEvent; MenuEvent;
	import mx.rpc.CallResponder; CallResponder;
	import mx.rpc.http.Operation; Operation;
	import mx.events.TreeEvent; TreeEvent;
	import mx.messaging.channels.URLVariables; URLVariables;
	import mx.controls.Menu; Menu;
	import mx.events.NumericStepperEvent; NumericStepperEvent;
	import mx.controls.beads.DataProviderChangeNotifier; DataProviderChangeNotifier;
	import mx.events.DynamicEvent; DynamicEvent;
	
	import mx.controls.PopUpButton; PopUpButton;
	import mx.controls.PopUpMenuButton; PopUpMenuButton;

	COMPILE::SWF
	{
	import mx.controls.beads.CSSImageAndTextButtonView; CSSImageAndTextButtonView;
	import mx.controls.beads.CheckBoxView; CheckBoxView;
	import mx.controls.beads.RadioButtonView; RadioButtonView;
	}
    import mx.controls.beads.ComboBoxView; ComboBoxView;
	import mx.controls.beads.controllers.RadioButtonMouseController; RadioButtonMouseController;
    import mx.controls.beads.NumericStepperView; NumericStepperView;
    import mx.controls.beads.DateFieldView; DateFieldView;
    import mx.controls.dateFieldClasses.DateFieldDateChooser; DateFieldDateChooser;
    import mx.controls.beads.controllers.MenuBarMouseController; MenuBarMouseController;
    import mx.controls.beads.controllers.CascadingMenuSelectionMouseController; CascadingMenuSelectionMouseController;
    import mx.controls.beads.ListItemRendererInitializer; ListItemRendererInitializer;
    import mx.controls.beads.TreeItemRendererInitializer; TreeItemRendererInitializer;
    import mx.controls.beads.AdvancedDataGridItemRendererInitializer; AdvancedDataGridItemRendererInitializer;
    import mx.controls.beads.AdvancedDataGridSelectableItemRendererClassFactory; AdvancedDataGridSelectableItemRendererClassFactory;
    
    import mx.containers.PanelTitleBar; PanelTitleBar;
    import mx.containers.beads.PanelView; PanelView;
    import mx.containers.beads.models.PanelModel; PanelModel;
    import mx.containers.beads.TabNavigatorView; TabNavigatorView;
    import mx.controls.TabBar; TabBar;
    import mx.controls.beads.models.ComboBoxModel; ComboBoxModel;
    import mx.controls.beads.models.CascadingMenuModel; CascadingMenuModel;
    
	import mx.collections.errors.ItemPendingError; ItemPendingError;
	import mx.controls.scrollClasses.ScrollThumb; ScrollThumb;
	import mx.effects.EffectTargetFilter; EffectTargetFilter;
	import mx.effects.effectClasses.PropertyChanges; PropertyChanges;
	import mx.effects.IEffect; IEffect;
	import mx.effects.IEffectTargetHost; IEffectTargetHost;
	import mx.events.RSLEvent; RSLEvent;
	import mx.skins.halo.DataGridHeaderSeparator; DataGridHeaderSeparator;
	import mx.filters.BaseDimensionFilter; BaseDimensionFilter;
	import mx.filters.BaseFilter; BaseFilter;
	import mx.filters.IBitmapFilter; IBitmapFilter;

    import mx.controls.beads.models.SingleSelectionICollectionViewModel; SingleSelectionICollectionViewModel;
	import mx.controls.beads.models.DataGridColumnICollectionViewModel; DataGridColumnICollectionViewModel;
    import mx.controls.beads.models.DataGridICollectionViewModel; DataGridICollectionViewModel;
    import mx.controls.beads.models.DataGridPresentationModel; DataGridPresentationModel;
    import mx.controls.beads.models.ListPresentationModel; ListPresentationModel;
    import mx.controls.beads.models.SingleSelectionIListModel; SingleSelectionIListModel;
    import mx.controls.buttonBarClasses.TextButtonDataGridColumnItemRenderer; TextButtonDataGridColumnItemRenderer;
	import mx.controls.beads.DataGridItemRendererInitializer; DataGridItemRendererInitializer;
	import mx.controls.beads.DataGridSelectableItemRendererClassFactory; DataGridSelectableItemRendererClassFactory;
	import mx.controls.dataGridClasses.DataGridButtonBar; DataGridButtonBar;
	import mx.controls.dataGridClasses.DataGridItemRenderer; DataGridItemRenderer;
	import mx.controls.dataGridClasses.DataGridSelectableItemRendererBead; DataGridSelectableItemRendererBead;
    
    import mx.controls.menuClasses.MenuBarItemRenderer; MenuBarItemRenderer;
    import mx.controls.menuClasses.CascadingMenuItemRenderer; CascadingMenuItemRenderer;
    import mx.controls.menuClasses.CascadingMenuWithOnScreenCheck; CascadingMenuWithOnScreenCheck;

    import mx.containers.beads.FormItemView; FormItemView;
    import mx.containers.beads.FormItemContainer; FormItemContainer;


	// --- RpcClassAliasInitializer
	import org.apache.royale.reflection.registerClassAlias;

	import mx.messaging.messages.AcknowledgeMessage;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.CommandMessage;
	import mx.messaging.messages.RemotingMessage;
	registerClassAlias("flex.messaging.messages.CommandMessage", CommandMessage);
	registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
	registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
	registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);  

	import mx.messaging.messages.AcknowledgeMessageExt;
	import mx.messaging.messages.AsyncMessageExt;
	import mx.messaging.messages.CommandMessageExt;
	registerClassAlias("DSK", AcknowledgeMessageExt);
	registerClassAlias("DSA", AsyncMessageExt);
	registerClassAlias("DSC", CommandMessageExt);
	// RpcClassAliasInitializer ----------------------------------------
    
	import mx.net.URLLoader; URLLoader;
	import mx.events.FlexMouseEvent; FlexMouseEvent;
	import mx.controls.HSlider; HSlider;
	import mx.controls.sliderClasses.Slider; Slider;
	import mx.controls.sliderClasses.SliderDirection; SliderDirection;
	import mx.controls.HorizontalList; HorizontalList;
	import mx.effects.easing.Elastic; Elastic;
	import mx.controls.listClasses.TileListItemRenderer; TileListItemRenderer;
	import mx.controls.listClasses.TileBase; TileBase;
	import mx.controls.listClasses.TileBaseDirection; TileBaseDirection;
	
	import mx.utils.NameUtil; NameUtil;
}

}

