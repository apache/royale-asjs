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

package mx.charts.series
{
import mx.charts.chartClasses.Series;
/*
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.renderers.DiamondItemRenderer;
import mx.charts.series.items.PlotSeriesItem;
import mx.charts.series.renderData.PlotSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;
*/ 
  
public class PlotSeries extends Series
{
    
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
     *  @productversion Royale 0.9.3
     */
    
    private var _yField:String = "";    
    
    /**
     *  Specifies the field of the data provider
     *  that determines the y-axis location of each data point. 
     *  If <code>null</code>, the PlotSeries assumes the data provider
     *  is an Array of numbers, and uses the numbers as values. 
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get yField():String
    {
        return _yField;
    }
 
    public function set yField(value:String):void
    {
        _yField = value; 
    }

     
}
}
