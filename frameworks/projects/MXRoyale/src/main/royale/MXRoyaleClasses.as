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
	import mx.collections.ArrayList; ArrayList;
  import mx.core.mx_internal; mx_internal;
  import mx.core.UIComponent; UIComponent;
	import mx.core.Container; Container;
	import mx.core.ScrollPolicy; ScrollPolicy;
	import mx.containers.beads.ApplicationLayout; ApplicationLayout;
	import mx.containers.beads.BoxLayout; BoxLayout;
	import mx.containers.ControlBar; ControlBar;
    import mx.containers.Panel; Panel;
	import mx.controls.ToolTip; ToolTip;
	import mx.controls.beads.ToolTipBead; ToolTipBead;
	import mx.effects.IEffectInstance; IEffectInstance;
	import mx.events.EffectEvent; EffectEvent;
	import mx.graphics.Stroke; Stroke;
	import mx.graphics.SolidColor; SolidColor;
	import mx.graphics.SolidColorStroke; SolidColorStroke;
	import mx.graphics.IStroke; IStroke;
	import mx.graphics.IFill; IFill;
	import mx.graphics.GradientEntry; GradientEntry;
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
	import mx.containers.Tile; Tile;
	import mx.containers.DividedBox; DividedBox;
	import mx.containers.beads.ApplicationLayout; ApplicationLayout;
	import mx.containers.beads.BoxLayout; BoxLayout;
	import mx.containers.beads.CanvasLayout; CanvasLayout;
	import mx.controls.ToolTip; ToolTip;
	import mx.controls.beads.ToolTipBead; ToolTipBead;
	import mx.containers.gridClasses.GridColumnInfo; GridColumnInfo;
	import mx.containers.gridClasses.GridRowInfo; GridRowInfo;
	import mx.events.CloseEvent; CloseEvent;
	import mx.controls.VRule; VRule;
	import mx.controls.HRule; HRule;
	import mx.events.ListEvent; ListEvent;
	import mx.events.SliderEvent; SliderEvent;
  import mx.managers.FocusManager; FocusManager;
	import mx.utils.ArrayUtil; ArrayUtil;
	import mx.effects.Effect; Effect; 
	import mx.effects.Sequence; Sequence; 
	import mx.charts.ChartItem; ChartItem;
	import mx.core.ClassFactory; ClassFactory;
	import mx.charts.LineChart; LineChart;
	import mx.charts.PieChart; PieChart;
	import mx.charts.BarChart; BarChart;
	import mx.charts.ColumnChart; ColumnChart;
	import mx.effects.Resize; Resize;
	import mx.effects.Tween; Tween;
	import mx.effects.Move; Move;
	import mx.graphics.LinearGradient; LinearGradient;
	import mx.system.ApplicationDomain; ApplicationDomain;
	import mx.controls.listClasses.ListBase; ListBase;
	import mx.controls.treeClasses.ITreeDataDescriptor; ITreeDataDescriptor;
	import mx.controls.treeClasses.TreeListData; TreeListData;
	import mx.charts.chartClasses.RenderData; RenderData;
	import mx.effects.EffectInstance; EffectInstance;
	import mx.effects.effectClasses.CompositeEffectInstance; CompositeEffectInstance;
	import mx.charts.HitData; HitData;
	import mx.collections.GroupingField; GroupingField;
	import mx.collections.Grouping; Grouping;
	import mx.core.IVisualElementContainer; IVisualElementContainer;
	import mx.managers.BrowserManager; BrowserManager;
	import mx.containers.FormHeading; FormHeading;
	import mx.charts.chartClasses.DataTransform; DataTransform;
	import mx.skins.Border; Border;
	import mx.effects.CompositeEffect; CompositeEffect;
	import mx.logging.LogEventLevel; LogEventLevel;
	import mx.logging.ILogger; ILogger;
	import mx.core.FlexVersion; FlexVersion;
	import mx.charts.chartClasses.CartesianTransform; CartesianTransform;
	import mx.charts.series.BarSeries; BarSeries;
	import mx.states.State; State;
	import mx.collections.XMLListCollection; XMLListCollection;
	import mx.controls.treeClasses.TreeItemRenderer; TreeItemRenderer;
	import mx.charts.events.ChartItemEvent; ChartItemEvent;
	import mx.charts.chartClasses.DataTip; DataTip;
  import mx.charts.series.ColumnSeries; ColumnSeries;
	import mx.charts.CategoryAxis; CategoryAxis;
	import mx.charts.LinearAxis; LinearAxis;
	import mx.charts.renderers.ShadowLineRenderer; ShadowLineRenderer;
	import mx.charts.Legend; Legend;
	import mx.charts.series.AreaSeries; AreaSeries;
	import mx.controls.textClasses.TextRange; TextRange;
	import mx.controls.ToggleButtonBar; ToggleButtonBar;
	import mx.managers.DragManager; DragManager;
	import mx.logging.targets.TraceTarget; TraceTarget; 
	import mx.managers.CursorManagerPriority; CursorManagerPriority;
	import mx.logging.Log; Log;
	import mx.collections.GroupingCollection2; GroupingCollection2;
	import mx.charts.chartClasses.Series; Series;
	import mx.charts.chartClasses.GraphicsUtilities; GraphicsUtilities; 
	import mx.effects.easing.Exponential; Exponential;
	import mx.controls.listClasses.AdvancedListBase; AdvancedListBase;
	import mx.effects.effectClasses.TweenEffectInstance; TweenEffectInstance;
	import mx.effects.TweenEffect; TweenEffect; 
	import mx.rpc.Fault; Fault;
	import mx.rpc.AsyncToken; AsyncToken;
	import mx.rpc.events.InvokeEvent; InvokeEvent;
	import mx.rpc.events.ResultEvent; ResultEvent;
	import mx.controls.VScrollBar; VScrollBar;
	import mx.graphics.LinearGradientStroke; LinearGradientStroke;
	import mx.rpc.AsyncResponder; AsyncResponder;
	import mx.rpc.Responder; Responder;
	import mx.printing.FlexPrintJobScaleType; FlexPrintJobScaleType; 
	import mx.skins.RectangularBorder; RectangularBorder;
	import mx.styles.ISimpleStyleClient; ISimpleStyleClient; 
	import mx.styles.StyleProxy; StyleProxy;
	import mx.modules.IModuleInfo; IModuleInfo;
	import mx.managers.CursorManager; CursorManager;
	import mx.validators.Validator; Validator;
	import mx.formatters.DateFormatter; DateFormatter;
	import mx.controls.MenuBar; MenuBar;
	import mx.formatters.SwitchSymbolFormatter; SwitchSymbolFormatter;

    COMPILE::SWF
    {
        import mx.controls.beads.CSSImageAndTextButtonView; CSSImageAndTextButtonView;
        import mx.controls.beads.CheckBoxView; CheckBoxView;
        import mx.controls.beads.RadioButtonView; RadioButtonView;
    }
}

}

