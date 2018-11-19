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

package mx.charts.chartClasses
{

import mx.charts.chartClasses.ChartBase;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;

import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

use namespace mx_internal;
/**
 *  The ChartElement class is the base class for visual chart elements.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ChartElement extends DualStyleObject implements IChartElement2
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static var nextID:uint = 0;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static function generateGlyphID():uint
    {
        return nextID++;
    }

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
    public function ChartElement()
    {
        super();

        _glyphID = generateGlyphID();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _userDataProvider:Object;
    
    /**
     *  @private
     */
    private var _glyphID:uint;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  chart
    //----------------------------------

    /**
     *  Refers to the chart component containing this element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    protected function get chart():ChartBase
    {
        var p:UIComponent = parent as UIComponent;

        while (!(p is ChartBase) && p)
        {
            p = p.parent as UIComponent;
        }   
                
        return p as ChartBase;
    }

    //----------------------------------
    //  chartDataProvider
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The data provider assigned to the enclosing chart.
     *  Element types can choose to inherit the data provider
     *  from the enclosing chart if necessary, or allow developers
     *  to assign data providers specifically to the element.
     *  Not all elements are necessarily driven by a data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set chartDataProvider(value:Object):void
    {
        if (_userDataProvider == null)
            processNewDataProvider(value);
    }
    
    //----------------------------------
    //  cursor
    //----------------------------------

    /**
     *  Each ChartElement carries a cursor associated with their dataProvider
     *  for their own internal use.
     *  ChartElements have sole ownership of this cursor;
     *  they can assume no other code will modify its position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var cursor:IViewCursor;

    //----------------------------------
    //  dataProvider
    //----------------------------------

    /**
     *  @private
     */
    private var _dataProvider:ICollectionView;
    
    [Inspectable]

    /**
     *  A data provider assigned to the this specific element.
     *  In general, elements inherit the dataProvider from the enclosing chart.
     *  But individual elements can override with a specific dataProvider
     *  of their own.
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
    public function set dataProvider(value:Object):void
    {
        if(_userDataProvider == value)
            return;
        _userDataProvider = value;
        processNewDataProvider(value);
    }

    //----------------------------------
    //  dataTransform
    //----------------------------------

    /**
     *  @private
     */
    private var _dataTransform:DataTransform;

    [Inspectable(environment="none")]
    
    /**
     *  The DataTransform object that the element is associated with.
     *  A DataTransform object represents an association between a set of elements
     *  and a set of axis objects used to transform those elements
     *  from data space to screen coordinates and back.
     *  A chart element uses its associated DataTransform object to calculate
     *  how to render its data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataTransform():DataTransform
    {
        return _dataTransform;
    }

    /**
     *  @private
     */
    public function set dataTransform(value:DataTransform):void
    {
        _dataTransform = value;
        var n:int = numChildren;
        for (var i:uint = 0; i < n; i++)
        {
            var g:IUIComponent = getChildAt(i);
            if (_dataTransform && g is IChartElement)
                IChartElement(g).dataTransform = _dataTransform;
        }

        if (_dataTransform)
            _dataTransform.dataChanged();

        invalidateDisplayList();
    }

    //----------------------------------
    //  labelContainer
    //----------------------------------

    [Inspectable(environment="none")]
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelContainer():UIComponent 
    {
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
    override public function addChild(child:IUIComponent):IUIComponent
    {
        super.addChild(child);
        
        if (_dataTransform && child is IChartElement)
            IChartElement(child).dataTransform = _dataTransform;

        return child;
    }

    /**
     * Adds a child DisplayObject instance to this DisplayObjectContainer 
     * instance. The child is added
     * at the index position specified. An index of 0 represents the back (bottom) 
     * of the display list for this DisplayObjectContainer object.
     * 
     * <p>If you add a child object that already has a different display object container as
     * a parent, the object is removed from the child list of the other display object container. </p>
     *
     * @return The DisplayObject instance that you pass in the 
     * <code>child</code> parameter.
     *
     * @param child The DisplayObject instance to add as a child of this 
     * DisplayObjectContainer instance.
     * 
     * @param index The index position to which the child is added. If you specify a 
     * currently occupied index position, the child object that exists at that position and all
     * higher positions are moved up one position in the child list. 
         *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
    override public function addChildAt(child:IUIComponent,
                                        index:int):IUIComponent
    {
        super.addChildAt(child, index);
        
        if (_dataTransform && child is IChartElement)
            IChartElement(child).dataTransform = _dataTransform;

        return child;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /** 
     *  Called when a new dataProvider is assigned to the element.
     *  Subclasses can override and define custom behavior
     *  when a new dataProvider is assigned.
     *  This method is called when either the <code>dataProvider</code> property
     *  is set, or when the <code>chartDataProvider</code> property is set
     *  if no specific dataProvider has been assigned directly.
     *  
     *  @param value The data provider. This is typically an Array, ArrayCollection, XMLList, XMLListCollection,
     *  or similar class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function processNewDataProvider(value:Object):void
    {
        if (_dataProvider != null)
        {
            _dataProvider.removeEventListener(
                CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
        }

        if (value is Array)
        {
            value = new ArrayCollection(value as Array);
        }
        else if (value is ICollectionView)
        {
        }
        else if (value is IList)
        {
            value = new ListCollectionView(IList(value));
        }
        else if (value is XMLList)
        {
            value = new XMLListCollection(XMLList(value));
        }
        else if (value != null)
        {
            value = new ArrayCollection([ value ]);
        }
        else
        {
            value = new ArrayCollection();
        }

        _dataProvider = ICollectionView(value);

        cursor = _dataProvider.createCursor();

        if (_dataProvider != null) //[Matt] not sure this would ever be null
        {
            // Weak listeners to collections and dataproviders.
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                collectionChangeHandler/*, false, 0, true*/);
        }

        dataChanged();
    }

    /**
     *  Called when the mapping of one or more associated axes changes.
     *  The DataTransform assigned to this ChartElement will call this method
     *  when any of the axes it represents is modified in some way.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function mappingChanged():void
    {
    }

    /**
     *  Indicates the underlying data represented by the element has changed.
     *  You should call this method whenever the data your series or element
     *  is displaying changes.  
     *  It gives any associated axes a chance to update their ranges
     *  if appropriate.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dataChanged():void
    {
        invalidateDisplayList();
        if (_dataTransform)
            _dataTransform.dataChanged();
        if (parent)
        {
            commitProperties();
            // I think setActualSize is called first
            updateDisplayList(width, height);
        }
    }

    /** 
     *  Finds the closest data point represented by the element
     *  under the given coordinates.
     *
     *  <p>This method returns either an array of  HitData structures
     *  describing the datapoints within range.
     *  Individual ChartElements may choose to only return a single dataPoint
     *  if their dataPoints are guaranteed not to overlap.</p>
     *
     *  @param x The X coordinate.
     *
     *  @param y The Y coordinate.
     *
     *  @param sensitivity2 How close, in pixels, the pointer must be
     *  to the exact coordinates to be considered "under".
     *  This property is similar to the value of the mouseSensitivity
     *  property of the chart control.
     * 
     *  @return An array of HitData.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findDataPoints(x:Number, y:Number,
                                   sensitivity2:Number):Array /* of HitData */
    {
        var result:Array /* of HitData */ = [];
        var n:int = numChildren;
        for (var i:int = n - 1; i >= 0; i--)
        {
            var g:IChartElement = getChildAt(i) as IChartElement;
            if (!g || g.visible == false)
                continue;
                
            var hds:Array /* of HitData */ = g.findDataPoints(x, y, sensitivity2);
            if (hds.length == 0)
                continue;

            result = result.concat(hds);
        }   
        
        return result;
    }
    
    /**
     *  Returns an array of HitData of the items of all the underlying 
     *  ChartElements whose dataTips are to be shown when 
     *  <code>showAllDataTips</code> is set to <code>true</code> on 
     *  chart
     * 
     *  @return The HitData objects describing the data points.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getAllDataPoints():Array /* of HitData */
    {
        var result:Array /* of HitData */ = [];
        var n:int = numChildren;
        for (var i:int = n - 1; i >= 0; i--)
        {
            var g:IChartElement2 = getChildAt(i) as IChartElement2;
            if (!g || g.visible == false)
                continue;
                
            var hds:Array /* of HitData */ = g.getAllDataPoints();
            if (hds.length == 0)
                continue;

            result = result.concat(hds);
        }   
        
        return result;
    }
    
    /**
     *  Creates a unique id to represent the dataPoint
     *  for comparison purposes.
     *  Derived classes can call this function with a locally unique
     *  data point ID to generate an ID that is unique across the application.
     *  
     *  @param dataPointID The dataPoint's current ID.
     *  
     *  @return An ID for the dataPoint that is unique across the application.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function createDataID(dataPointID:Number):Number
    {
        return (_glyphID << 16) + dataPointID;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function describeData(dimension:String,
                                 requiredFields:uint):Array /* of BoundedValue */
    {
        return [];
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function chartStateChanged(oldState:uint, v:uint):void
    {
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var c:IChartElement = getChildAt(i) as IChartElement;
            if (c)
                c.chartStateChanged(oldState, v);
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function collectTransitions(chartState:Number,
                                       transitions:Array /* of IEffectInstance */):void
    {
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var c:IChartElement = getChildAt(i) as IChartElement;
            if (c)
                c.collectTransitions(chartState, transitions);
        }
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function claimStyles(styles:Array /* of Object */, firstAvailable:uint):uint
    {
        return firstAvailable;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function dataToLocal(... dataValues):Point
    {
        return null;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function localToData(pt:Point):Array /* of Object */
    {
        return null;
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function collectionChangeHandler(event:CollectionEvent = null):void
    {
        if (event && event.kind == CollectionEventKind.RESET)
            cursor = _dataProvider.createCursor();
    
        dataChanged();
    }
    
    override public function addedToParent():void
    {
        super.addedToParent();
        COMPILE::JS
        {
            element.style.position = "absolute";
        }
        commitProperties();
        measure();
        updateDisplayList(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
    }
}

}
