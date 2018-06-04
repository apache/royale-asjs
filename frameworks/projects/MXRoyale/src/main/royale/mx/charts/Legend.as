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

package mx.charts
{
   /*  import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.ApplicationDomain;
    import flash.text.TextField;
    import flash.text.TextLineMetrics;
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    
    import mx.binding.BindingManager;
    import mx.charts.chartClasses.ChartBase;
    import mx.charts.events.LegendMouseEvent;
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
    import mx.containers.utilityClasses.PostScaleAdapter;
    import mx.core.ComponentDescriptor;
    import mx.core.ContainerCreationPolicy;
    import mx.core.ContainerGlobals;
    import mx.core.EdgeMetrics;
    import mx.core.FlexGlobals;
    import mx.core.FlexSprite;
    import mx.core.FlexVersion;
    import mx.core.IChildList;
    import mx.core.IDeferredInstantiationUIComponent;
    import mx.core.IFlexDisplayObject;
    import mx.core.IFlexModuleFactory;
    import mx.core.IInvalidating;
    import mx.core.ILayoutDirectionElement;
    import mx.core.IRectangularBorder;
    import mx.core.IRepeater;
    import mx.core.IRepeaterClient;
    import mx.core.IUITextField;
    import mx.core.IVisualElement;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponentDescriptor;
    import mx.core.UIComponentGlobals;
    import mx.core.mx_internal;
    import mx.events.ChildExistenceChangedEvent;
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
    import mx.geom.RoundedRectangle;
    import mx.managers.ILayoutManagerClient;
    import mx.managers.ISystemManager;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.ISimpleStyleClient;
    import mx.styles.IStyleClient;
    import mx.styles.StyleProtoChain;
    import mx.core.IContainer;
    import mx.core.IUIComponent;

    use namespace mx_internal; */
    
    import mx.core.UIComponent;

    
    
    //--------------------------------------
    //  Other metadata
    //--------------------------------------
    
    [DefaultBindingProperty(destination="dataProvider")]
    
   // [DefaultTriggerEvent("itemClick")]
    
   // [IconFile("Legend.png")]
    
    /**
     *  The Legend control adds a legend to your charts,
     *  where the legend displays the label for each data series in the chart
     *  and a key showing the chart element for the series.
     *  
     *  <p>You can initialize a Legend control by binding a chart control
     *  identifier to the Legend control's <code>dataProvider</code> property,
     *  or you can define an Array of LegendItem objects.</p>
     *
     *  @mxml
     *  
     *  <p>The <code>&lt;mx:Legend&gt;</code> tag inherits all the properties
     *  of its parent classes and adds the following properties:</p>
     *  
     *  <pre>
     *  &lt;mx:Legend
     *    <strong>Properties</strong>
     *    autoLayout="true|false"
     *    clipContent="true|false"
     *    creationIndex="undefined"
     *    creationPolicy="auto|all|queued|none"
     *    dataProvider="<i>No default</i>"
     *    direction="horizontal|vertical"
     *    horizontalScrollPosition="0"
     *    legendItemClass="<i>No default</i>"
     *    verticalScrollPosition="0"   
     * 
     *    <strong>Styles</strong>
     *    backgroundAlpha="1.0"
     *    backgroundAttachment="scroll"
     *    backgroundColor="undefined"
     *    backgroundDisabledColor="undefined"
     *    backgroundImage="undefined"
     *    backgroundSize="auto" 
     *    barColor="undefined"
     *    borderColor="0xAAB3B3"
     *    borderSides="left top right bottom"
     *    borderSkin="mx.skins.halo.HaloBorder"
     *    borderStyle="inset|none|solid|outset"
     *    borderThickness="1"
     *    color="0x0B333C"
     *    cornerRadius="0"
     *    disabledColor="0xAAB3B3"
     *    disbledOverlayAlpha="undefined"
     *    dropShadowColor="0x000000"
     *    dropShadowEnabled="false"
     *    fontAntiAliasType="advanced"
     *    fontfamily="Verdana"
     *    fontGridFitType="pixel"
     *    fontSharpness="0""
     *    fontSize="10"
     *    fontStyle="normal"
     *    fontThickness="0"
     *    fontWeight="normal"
     *    horizontalAlign="left|center|right"
     *    horizontalGap="<i>8</i>"
     *    labelPlacement="right|left|top|bottom"
     *    markerHeight="15"
     *    markerWidth="10"
     *    paddingBottom="0"
     *    paddingLeft="0"
     *    paddingRight="0"
     *    paddingTop="0"
     *    shadowDirection="center"
     *    shadowDistance="2"
     *    stroke="<i>IStroke; no default</i>"
     *    textAlign="left"
     *    textDecoration="none|underline"
     *    textIndent="0"
     *    verticalAlign="top|middle|bottom"
     *    verticalGap="<i>6</i>"
     *    
     *    <strong>Events</strong>
     *    childAdd="<i>No default</i>"
     *    childIndexChange="<i>No default</i>"
     *    childRemove="<i>No default</i>"
     *    dataChange="<i>No default</i>"
     *    itemClick="<i>Event; no default</i>"
     *    itemMouseDown="<i>Event; no default</i>"
     *    itemMouseOut="<i>Event; no default</i>"
     *    itemMouseOver="<i>Event; no default</i>"
     *    itemMouseUp="<i>Event; no default</i>"
     *  /&gt;
     *  </pre>
     *
     *  @see mx.charts.LegendItem
     *
     *  @includeExample examples/PlotChartExample.mxml
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
     
    public class Legend extends UIComponent
        
    {
     //    include "../core/Version.as"
        
       
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function Legend()
        {
            super();
            
        
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        
        
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        //----------------------------------
        //  dataProvider
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dataProvider property.
         */
        private var _dataProvider:Object;
        
        [Bindable("collectionChange")]
        [Inspectable(category="Data")]
        
        /**
         *  Set of data to be used in the Legend.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dataProvider():Object
        {
            return _dataProvider;
        }
        
        /**
         *  @private
         */
        public function set dataProvider(
            value:Object /* String, ViewStack or Array */):void
        {
           /*  if (_dataProvider is ChartBase)
            {
                _dataProvider.removeEventListener("legendDataChanged",
                    legendDataChangedHandler);
            }
            
            _dataProvider = value ? value : [];
            
            if (_dataProvider is ChartBase)
            {
                // weak listeners to collections and dataproviders
                _dataProvider.addEventListener("legendDataChanged",
                    legendDataChangedHandler, false, 0, true);
            }
            else if (_dataProvider is ICollectionView)
            {
            }
            else if (_dataProvider is IList)
            {
                _dataProvider = new ListCollectionView(IList(_dataProvider));
            }
            else if (_dataProvider is Array)
            {
                _dataProvider = new ArrayCollection(_dataProvider as Array);
            }
            else if (_dataProvider != null)
            {
                _dataProvider = new ArrayCollection([_dataProvider]);
            }
            else
            {
                _dataProvider = new ArrayCollection();
            }
            
            invalidateProperties();
            invalidateSize();
            _childrenDirty = true;
            
            dispatchEvent(new Event("collectionChange")); */
        }
        
       
    }
}

