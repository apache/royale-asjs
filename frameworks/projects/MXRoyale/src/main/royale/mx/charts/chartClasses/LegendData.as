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

import mx.core.IFlexDisplayObject;

/**
 *  The LegendData structure is used by charts to describe the items
 *  that should be displayed in an auto-generated legend.
 *  A chart's <code>legendData</code> property contains an Array
 *  of LegendData objects, one for each item in the Legend. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class LegendData
{
//    include "../../core/Version.as";

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
	public function LegendData()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  aspectRatio
	//----------------------------------

	[Inspectable]

	/**
	 *  Determines
	 *  the size and placement of the legend marker.
	 *  If set, the LegendItem ensures that the marker's
	 *  width and height match this value.
	 *  If unset (<code>NaN</code>), the legend item chooses an appropriate
	 *  default width and height.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var aspectRatio:Number;
	
	//----------------------------------
	//  element
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  The chart item that generated this legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var element:IChartElement;
	
	//----------------------------------
	//  label
	//----------------------------------

	[Inspectable]

	/**
	 *  The text identifying the series or item displayed in the legend item.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var label:String = "";
	
	//----------------------------------
	//  marker
	//----------------------------------

	[Inspectable]

	/**
	 *  A visual indicator associating the legend item
	 *  with the series or item being represented. 
	 *  This DisplayObject is added as a child to the LegendItem. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var marker:IFlexDisplayObject;
}

}
