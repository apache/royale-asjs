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

import org.apache.royale.charts.supportClasses.BarSeries;



/**
 *  Defines a data series for a BarChart control.
 *  By default, this class uses the BoxItemRenderer class. 
 *  Optionally, you can define an itemRenderer for the data series.
 *  The itemRenderer must implement the IDataRenderer interface. 
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:BarSeries&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:BarSeries
 *    <strong>Properties</strong>
 *    barWidthRatio=".65"
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    labelField="<i>No default</i>"
 *    labelFunction="<i>No default</i>"
 *    maxBarWidth="<i>No default</i>"
 *    minField="null"
 *    offset="<i>No default</i>"
 *    stacker="<i>No default</i>"
 *    stackTotals="<i>No default</i>"
 *    verticalAxis="<i>No default</i>" 
 *    xField="null"
 *    yField="null"
 *  
 *    <strong>Styles</strong>
 *    fill="<i>IFill; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    fontFamily="Verdana"
 *    fontSize="10"
 *    fontStyle="italic|normal"
 *    fontWeight="bold|normal"
 *    labelAlign="center|left|right"
 *    labelPosition="none|inside|outside"
 *    labelSizeLimit="9"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    stroke="<i>IStroke; no default</i>"
 *    textDecoration="underline|none"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.BarChart
 *  
 *  @includeExample ../examples/Column_BarChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class BarSeries extends org.apache.royale.charts.supportClasses.BarSeries
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
    public function BarSeries()
    {
        super();

       
    }
    
  private var _displayName:String;

    /**
     *  The name of the series, for display to the user.
     *  This property is used to represent the series in user-visible labels,
     *  such as data tips.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
     public function get displayName():String
    {
        return _displayName;
    }  
    
    /**
     *  @private
     */
     public function set displayName(value:String):void
    {
        _displayName = value;
    } 
    
    
	
}

}

