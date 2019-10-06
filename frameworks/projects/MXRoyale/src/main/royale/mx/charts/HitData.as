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

import mx.charts.chartClasses.IChartElement;
import mx.styles.ISimpleStyleClient;
import mx.styles.IStyleClient;
import mx.charts.chartClasses.GraphicsUtilities;

/**
 *  The HitData class represents information about the data item
 *  at a specific location on the screen.
 *  Flex returns the HitData structure for mouse events on chart data points.
 *  It describes what data points are under the current mouse position. 
 *
 *  <p>You can also get a HitData structure describing the data point
 *  at a specific location in the chart using the chart control's
 *  <code>findDataPoints()</code> method.</p>
 *  
 *  @see mx.charts.ChartItem
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class HitData
{
//    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 *
	 *  @param id Specifies a unique identifier representing the data point.
	 *
	 *  @param distance Specifies the distance between the data item
	 *  on the screen and the location of the mouse pointer, in pixels.
	 *
	 *  @param x Specifies the x coordinate of the data item on the screen.
	 *
	 *
	 *  @param y Specifies the y coordinate of the data item on the screen.
	 *
	 *  @param chartItem The chart item described by the hit data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function HitData(id:Number, distance:Number, x:Number, y:Number,
							chartItem:ChartItem)
	{
		super();

		this.id = id;
		this.distance = distance;
		this.x = x;
		this.y = y;
		this.chartItem = chartItem;
		this.item = chartItem.item;
		
		if (chartItem.element is IStyleClient)
		{
			var f:Object = IStyleClient(chartItem.element).getStyle("fill");
			
			contextColor = GraphicsUtilities.colorFromFill(f);
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  chartItem
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  The chart item described by the hit data.
	 *  A chart item represents the data a series uses
	 *  to describe an individual item from its <code>dataProvider</code>. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var chartItem:ChartItem;
	
	//----------------------------------
	//  contextColor
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  An RGB value that can be used to associate an on-screen
	 *  representation of the associated <code>chartItem</code>.
	 *  DataTips use this field to help render their data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var contextColor:uint = 0;
	
	//----------------------------------
	//  dataTipFunction
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  A function provided by the HitData creator
	 *  to generate a user-suitable String for display on screen
	 *  that describes the referenced item. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var dataTipFunction:Function;
	
	//----------------------------------
	//  displayText
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  A description of the associated item for display on screen. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get displayText():String
	{
		return dataTipFunction(this);	
	}
	
	//----------------------------------
	//  distance
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies the distance between the data item on the screen
	 *  and the location of the mouse pointer, in pixels.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var distance:Number;
	
	//----------------------------------
	//  element
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies the chart element rendering this data item
	 *  that generated the HitData structure.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get element():IChartElement 
	{
		return chartItem.element;
	}

	//----------------------------------
	//  id
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies a unique identifier representing the data point.
	 *  You can use this identifier to test for equality
	 *  between two HitData objects. 
	 *  If two different chart elements represent the same <code>dataProvider</code> entry,
	 *  they will have two different identifiers.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var id:Number;

	//----------------------------------
	//  item
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies the data item that the HitData structure describes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var item:Object;
	
	//----------------------------------
	//  x
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies the X coordinate of the data item on the screen.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var x:Number;
	
	//----------------------------------
	//  y
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  Specifies the Y coordinate of the data item on the screen.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var y:Number;
}

}
