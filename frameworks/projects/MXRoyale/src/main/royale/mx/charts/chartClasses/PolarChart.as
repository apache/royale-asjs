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

import mx.events.KeyboardEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import mx.core.Keyboard;

import mx.charts.ChartItem;
import mx.charts.LinearAxis;
import mx.charts.events.ChartItemEvent;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

/**
 *  The PolarChart control serves as base class for circular charts
 *  based in polar coordinates.
 *  
 *  <p>A chart's minimum size is 20,20 pixels. </p>
 *  <p>A chart's maximum size is unbounded. </p>
 *  <p>A chart's preferred size is 400,400 pixels. </p>
 *  
 *  @see mx.charts.CategoryAxis
 *  @see mx.charts.LinearAxis 
 *  @see mx.charts.chartClasses.ChartBase
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PolarChart extends ChartBase
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
    

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
    public function PolarChart()
    {
        super();

        _transforms = [ new PolarTransform() ];
        
        var aa:LinearAxis = new LinearAxis();
        aa.autoAdjust = false;
        angularAxis = aa;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
//    private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true); 
    
    /**
     *  @private
     */
    private var axisLayoutDirty:Boolean = true;
    
    /**
     *  @private
     */
    private var _axisDirty:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  angularAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the angularAxis property.
     */
    private var _angularAxis:IAxis;

    [Inspectable(category="Data")]
    
    /**
     *  The axis object used to map data values to an angle
     *  between 0 and 2 * PI.
     *  By default, this is a linear axis with the <code>autoAdjust</code>
     *  property set to <code>false</code>.
     *  So, data values are mapped uniformly around the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get angularAxis():IAxis
    {
        return _angularAxis;
    }   
    
    /**
     *  @private
     */
    public function set angularAxis(value:IAxis):void
    {
        _transforms[0].setAxis(PolarTransform.ANGULAR_AXIS, value);
        _angularAxis = value;
        _axisDirty = true;

        invalidateData();
        invalidateProperties();
    }   

    //----------------------------------
    //  radialAxis
    //----------------------------------

    [Inspectable(category="Data")]
    
    /**
     *  The axis object used to map data values to a radial distance
     *  between the center and the outer edge of the chart.
     *  By default, this is a linear axis with the <code>autoAdjust</code>
     *  property set to <code>false</code>.
     *  So, data values are  mapped uniformly from the inside
     *  to the outside of the chart 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radialAxis():IAxis
    {
        return _transforms[0].getAxis(PolarTransform.RADIAL_AXIS);
    }   
    
    /**
     *  @private
     */
    public function set radialAxis(value:IAxis):void
    {
        _transforms[0].setAxis(PolarTransform.RADIAL_AXIS, value);
        _axisDirty = true;

        invalidateData();
        invalidateProperties();
    }   

    //--------------------------------------------------------------------------
    //
    //  Overriden methods: UIComponent
    //
    //--------------------------------------------------------------------------

	/**
     *  @private
     */
    private function initStyles():Boolean
    {
        HaloDefaults.init(styleManager);
		
		var polarChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.chartClasses.PolarChart");
		if (polarChartStyle)
		{
			polarChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			polarChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2))
		}		
        return true;
    }
    
    /**
     *   A module factory is used as context for using embedded fonts and for finding the style manager that controls the styles for this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        super.moduleFactory = factory;
        
        /*
        if (_moduleFactoryInitialized[factory])
            return;
        
        _moduleFactoryInitialized[factory] = true;
        */
        
        // our style settings
        initStyles();
    }
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        // If the angular or radial axes is re-set then you have to invalidate the series
        // as they might be using the same axes as the chart's
        if (_axisDirty == true)
        {
            var n:int = series.length;
            for (var i:int = 0; i < n; i++)
            {
                series[i].invalidateProperties();
            }
            
            n = annotationElements.length;
            for (i = 0; i < n; i++)
            {
                var h:Object;
                h = annotationElements[i];
                if (!h)
                    continue;
                if (h is IDataCanvas)
                    h.invalidateProperties();
            }
            
            n = backgroundElements.length;
            for (i = 0; i < n; i++)
            {
                h = backgroundElements[i];
                if (!h)
                    continue;
                if (h is IDataCanvas)
                    h.invalidateProperties();
            }
            
            _axisDirty = false;
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
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        // Force the range to update any automatic mappings.
        _angularAxis.getLabelEstimate();

        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");

        var rcElements:Rectangle = new Rectangle(
            paddingLeft, paddingTop,
            unscaledWidth - paddingLeft - paddingRight,
            unscaledHeight - paddingTop - paddingBottom);
                                     
        var i:int;
        var n: int = _transforms.length;
        for (i = 0; i < n; i++)
        {
            _transforms[i].setSize(rcElements.width,rcElements.height);
        }

        n = allElements.length;
        for (i = 0; i < n; i++)
        {
            var c:UIComponent = allElements[i];
            if (c is IUIComponent)
            {
                (c as IUIComponent).setActualSize(rcElements.width,
                                                 rcElements.height);
            }
            else 
            {
                c.width = rcElements.width;
                c.height = rcElements.height;
            }
            if (c is Series)
                PolarTransform((c as Series).dataTransform).setSize(rcElements.width,rcElements.height);
            if (c is IDataCanvas)
                PolarTransform((c as Object).dataTransform).setSize(rcElements.width, rcElements.height);
        }

        if (_seriesHolder.mask)
        {
            _seriesHolder.mask.width = rcElements.width;
            _seriesHolder.mask.height = rcElements.height;
        }

        if (_backgroundElementHolder.mask)
        {
            _backgroundElementHolder.mask.width = rcElements.width;
            _backgroundElementHolder.mask.height = rcElements.height;
        }

        if (_annotationElementHolder.mask)
        {
            _annotationElementHolder.mask.width = rcElements.width;
            _annotationElementHolder.mask.height = rcElements.height;
        }
        
        _seriesHolder.move(rcElements.left, rcElements.top);
        _backgroundElementHolder.move(rcElements.left, rcElements.top);
        _annotationElementHolder.move(rcElements.left, rcElements.top);

        axisLayoutDirty = false;
        advanceEffectState();
    }
    
    /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
    override protected function get dataRegion():Rectangle
    {
        return getBounds(this);
    }
     */
    
   /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getLastItem(direction:String):ChartItem
    {
        var item:ChartItem = null;
        
        if (_caretItem)
            item = Series(_caretItem.element).items[Series(_caretItem.element).items.length - 1];
        else
            item = getPreviousSeriesItem(series);
        
        return item;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getFirstItem(direction:String):ChartItem
    {
        var item:ChartItem = null;
        
        if (_caretItem)
            item = Series(_caretItem.element).items[0];
        else
            item = getNextSeriesItem(series);

        return item;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getNextItem(direction:String):ChartItem
    {
        if (direction == ChartBase.HORIZONTAL)   
            return getNextSeriesItem(series);
        else if (direction == ChartBase.VERTICAL)
            return getNextSeries(series);
        
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
    override public function getPreviousItem(direction:String):ChartItem
    {
        if (direction == ChartBase.HORIZONTAL)   
            return getPreviousSeriesItem(series);
        else if (direction == ChartBase.VERTICAL)
            return getPreviousSeries(series);

        return null;
    }

    /**
     *  @private
     */  
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (selectionMode == "none")
            return;
    
        var item:ChartItem = null;
        var bSpace:Boolean = false;
        
        switch (event.keyCode)
        {
            case Keyboard.UP:
            {
                item = getNextItem(ChartBase.VERTICAL);
                break;
            }
                
            case Keyboard.DOWN:
            {
                item = getPreviousItem(ChartBase.VERTICAL);                     
                break;
            }
    
            case Keyboard.LEFT:
            {
                item = getPreviousItem(ChartBase.HORIZONTAL);                       
                break;
            }
                
            case Keyboard.RIGHT:
            {
                item = getNextItem(ChartBase.HORIZONTAL);                       
                break;
            }

            case Keyboard.END:
            case Keyboard.PAGE_DOWN:
            {
                item = getLastItem(ChartBase.HORIZONTAL);
                break;
            }
                
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            {
                item = getFirstItem(ChartBase.HORIZONTAL);
                break;
            }
    
            case Keyboard.SPACE:
            {
                handleSpace(event);
                event.stopPropagation();
                return;
            }
           
            default:
            {
                break;
            }
        }
        
        if (item)
        {
            event.stopPropagation();
            handleNavigation(item,event);
        }
    }

    /**
     *  @private
     */
                
    override mx_internal function handleShift(item:ChartItem):void
    {
        var anchorSeries:Series = Series(_anchorItem.element);
        var itemSeries:Series = Series(item.element);
        
        if (anchorSeries != itemSeries)
            return;
            
        var index1:int = anchorSeries.items.indexOf(_anchorItem);
        var index2:int = itemSeries.items.indexOf(item);
        
        var len:int = anchorSeries.items.length;
        if (index1 > index2) // select everything
        {
            index1 = 0;
            index2 = len - 1;
        }
        var temp:ChartItem = _anchorItem;
        clearSelection();
        _anchorItem = temp;

        for (var i:int = index1; i <= index2; i++)
        {
            anchorSeries.addItemtoSelection(anchorSeries.items[i]);
        }

        _selectedSeries = anchorSeries;         
        _caretItem = item;
    }
    
    /**
     *  @private
     */
    override mx_internal function updateKeyboardCache():void
    {
        
        // Check whether all the series' transformations have been done, otherwise Series' renderdata would not be valid and hence the display too.
        // This is done as setting up KeyboardCache can take sometime, if done on first access.
        var n:int = _transforms.length;
        var m:int;
        for (var i:int = 0; i < n; i++)
        {
            m = _transforms[i].elements.length;
            for (var j:int = 0; j < m; j++)
            {
                if (_transforms[i].elements[j] is Series && getSeriesTransformState(_transforms[i].elements[j]) == true)
                    return;
            }
        }
                    
        // Restore Selection
        
        var arrObjects:Array /* of Object */ = [];
        var arrSelect:Array /* of ChartItem */ = [];
        var arrItems:Array /* of ChartItem */;
        var index:int;
        var bExistingSelection:Boolean = false;
        var nCount:int = 0;
        n = series.length;
        for (i = 0; i < n; i++)
        {
            arrItems = series[i].items;
            if (arrItems && series[i].selectedItems.length > 0)
            {
                bExistingSelection = true;
                m = arrItems.length;
                for (j = 0; j < m; j++)
                {
                    arrObjects.push(arrItems[j].item);
                }
                
                nCount += series[i].selectedItems.length;  
                m = series[i].selectedItems.length; 
                for (j = 0; j < m; j++)
                {
                    index = arrObjects.indexOf(series[i].selectedItems[j].item);
                    if (index != -1)
                        arrSelect.push(series[i].items[index]);
                }
                arrObjects = [];
                series[i].emptySelectedItems();
            }
        }
        if (bExistingSelection)
        {
            selectSpecificChartItems(arrSelect);
            if (nCount != arrSelect.length)
                dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
        }
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function calcAngle(x:Number, y:Number):Number
    {
        const twoMP:Number = Math.PI * 2;

        var angle:Number;
        
        var at:Number = Math.atan(-y / x);
        
        if (x < 0)
            angle = at + Math.PI;
        else if (y < 0)
            angle = at;
        else
            angle = at + twoMP;

        return angle;
    }
}

}
