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

/**
 *  ChartElements that can be clustered along the vertical axis
 *  should implement this interface.
 *  Any element implementing this interface can be used
 *  as a child series of a ColumnSet element with its <code>type</code> property set to "clustered".
 *  The ColumnSeries, HLOCSeries, CandleStickSeries, and ColumnSet classes
 *  all implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IColumn
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

    //----------------------------------
	//  columnWidthRatio
    //----------------------------------

	/**
	 *  Specifies the width of items relative to the category size.
	 *  A value of <code>1</code> uses the entire space, while a value
	 *  of <code>0.6</code> uses 60% of the item's available space. 
	 *  You typically do not set this property directly.
	 *  A governing ColumSet or ColumnChart would implicitly assign this value.
	 *  The actual item width used is the smaller of the
	 *  <code>columnWidthRatio</code> and the <code>maxColumnWidth</code>
	 *  properties.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function set columnWidthRatio(value:Number):void;

    //----------------------------------
	//  maxColumnWidth
    //----------------------------------

	/**
	 *  Specifies how wide to draw the items, in pixels.
	 *  The actual item width used is the smaller of this property
	 *  and the <code>columnWidthRatio</code> property.
	 *  You typically do not set this property directly.
	 *  The ColumSet or ColumnChart object assigns this value.
	 *  The actual item width used is the smaller of the
	 *  <code>columnWidthRatio</code> and <code>maxColumnWidth</code>
	 *  properties.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function set maxColumnWidth(value:Number):void;

    //----------------------------------
	//  offset
    //----------------------------------

	/**
	 *  Specifies how far to offset the center of the items
	 *  from the center of the available space, relative the category size. 
	 *  The range of values is a percentage in the range
	 *  <code>-100</code> to <code>100</code>. 
	 *  Set to <code>0</code> to center the items in the space.
	 *  Set to <code>-50</code> to center the item
	 *  at the beginning of the available space.
	 *  You typically do not set this property directly.
	 *  The ColumSet or ColumnChart object assigns this value.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function set offset(value:Number):void;
}

}
