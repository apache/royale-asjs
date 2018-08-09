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
	import mx.core.mx_internal; mx_internal;
	import mx.core.ScrollPolicy; ScrollPolicy;
	import mx.containers.beads.ApplicationLayout; ApplicationLayout;
	import mx.containers.beads.BoxLayout; BoxLayout;
	import mx.controls.beads.ToolTipBead; ToolTipBead;
	import mx.effects.IEffectInstance; IEffectInstance;
	import mx.events.EffectEvent; EffectEvent;
	import mx.graphics.IStroke; IStroke;
	import mx.graphics.IFill; IFill;
	import mx.core.EventPriority; EventPriority;
	import mx.core.IFactory; IFactory;
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
	import mx.containers.beads.ApplicationLayout; ApplicationLayout;
	import mx.containers.beads.BoxLayout; BoxLayout;
	import mx.containers.beads.CanvasLayout; CanvasLayout;
	import mx.controls.beads.ToolTipBead; ToolTipBead;
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
	import mx.system.ApplicationDomain; ApplicationDomain;
	import mx.rpc.remoting.RemoteObject; mx.rpc.remoting.RemoteObject;
	import mx.rpc.http.HTTPService; mx.rpc.http.HTTPService;
	import mx.controls.treeClasses.ITreeDataDescriptor; ITreeDataDescriptor;
	import mx.controls.treeClasses.TreeListData; TreeListData;
	import mx.charts.chartClasses.RenderData; RenderData;
	import mx.effects.EffectInstance; EffectInstance;
	import mx.effects.effectClasses.CompositeEffectInstance; CompositeEffectInstance;
	import mx.charts.HitData; HitData;
	import mx.events.MenuEvent; MenuEvent;
	import mx.events.FlexEvent; FlexEvent;
	import mx.managers.PopUpManager; PopUpManager; 
	import mx.core.IVisualElementContainer; IVisualElementContainer;
	import mx.managers.BrowserManager; BrowserManager;
	import mx.charts.chartClasses.DataTransform; DataTransform;
	import mx.skins.Border; Border;
	import mx.effects.CompositeEffect; CompositeEffect;
	import mx.logging.LogEventLevel; LogEventLevel;
	import mx.logging.ILogger; ILogger;
	import mx.core.FlexVersion; FlexVersion;
	import mx.charts.chartClasses.CartesianTransform; CartesianTransform;
	import mx.charts.events.ChartItemEvent; ChartItemEvent;
	import mx.charts.chartClasses.DataTip; DataTip;
  	import mx.controls.textClasses.TextRange; TextRange;
	import mx.managers.CursorManagerPriority; CursorManagerPriority;
	import mx.logging.Log; Log;
	import mx.charts.chartClasses.Series; Series;
	import mx.charts.chartClasses.GraphicsUtilities; GraphicsUtilities; 
	import mx.effects.easing.Exponential; Exponential;
	import mx.effects.effectClasses.TweenEffectInstance; TweenEffectInstance;
	import mx.effects.TweenEffect; TweenEffect; 
	import mx.rpc.Fault; Fault;
	import mx.rpc.events.InvokeEvent; InvokeEvent;
	import mx.rpc.events.ResultEvent; ResultEvent;
	import mx.rpc.AsyncResponder; AsyncResponder;
	import mx.rpc.Responder; Responder;
	import mx.printing.FlexPrintJobScaleType; FlexPrintJobScaleType; 
	import mx.skins.RectangularBorder; RectangularBorder;
	import mx.styles.ISimpleStyleClient; ISimpleStyleClient; 
	import mx.styles.StyleProxy; StyleProxy;
    import mx.styles.StyleManagerImpl; StyleManagerImpl;
	import mx.modules.IModuleInfo; IModuleInfo;
	import mx.formatters.SwitchSymbolFormatter; SwitchSymbolFormatter;
	import mx.printing.FlexPrintJob; FlexPrintJob; 
	import mx.utils.URLUtil; URLUtil;
	import mx.core.UITextField; UITextField;
	import mx.effects.Parallel; Parallel; 
	import mx.rpc.events.FaultEvent; FaultEvent;
	import mx.events.AdvancedDataGridEvent; AdvancedDataGridEvent;
	import mx.skins.ProgrammaticSkin; ProgrammaticSkin;
	import mx.rpc.soap.WebService; WebService;
	import mx.collections.ISort; ISort;
	import mx.utils.Base64Encoder; Base64Encoder;
	import mx.utils.Base64Decoder; Base64Decoder;
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
	import mx.external.ExternalInterface; ExternalInterface;
	import mx.events.KeyboardEvent; KeyboardEvent;
	import mx.geom.Matrix; Matrix;
	import mx.utils.ByteArray; mx.utils.ByteArray;
	import mx.controls.RichTextEditor; RichTextEditor;
	
	COMPILE::JS
    	{
		import mx.utils.TextEncoderLiteWrapper; TextEncoderLiteWrapper;
		import mx.utils.Base64JSWrapper; Base64JSWrapper;
	}

	COMPILE::SWF
	{
	import mx.controls.beads.CSSImageAndTextButtonView; CSSImageAndTextButtonView;
	import mx.controls.beads.CheckBoxView; CheckBoxView;
	import mx.controls.beads.RadioButtonView; RadioButtonView;
	}
    import mx.controls.beads.NumericStepperView; NumericStepperView;
    import mx.controls.beads.DateFieldView; DateFieldView;
    import mx.controls.dateFieldClasses.DateFieldDateChooser; DateFieldDateChooser;
    import mx.controls.beads.controllers.MenuBarMouseController;
    
    import mx.containers.beads.PanelView; PanelView;
    import mx.containers.beads.models.PanelModel; PanelModel;
    
    import mx.controls.beads.models.SingleSelectionICollectionViewModel; SingleSelectionICollectionViewModel;
    import mx.controls.beads.models.SingleSelectionIListModel; SingleSelectionIListModel;
}

}

