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
	
//import flash.utils.Dictionary;
import mx.charts.chartClasses.StackedSeries;

/**
 *  The IStackable interface is implemented by any series that can be stacked.
 *  Stacking sets (ColumnSet, BarSet, AreaSet) require that any sub-series
 *  assigned to it when stacking implement this interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IStackable
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

    //----------------------------------
	//  stacker
    //----------------------------------

	/**
	 *  The StackedSeries associated with this series.
	 *  The stacker manages the series's stacking behavior.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get stacker():StackedSeries;
	
	/**
	 *  @private
	 */
	function set stacker(value:StackedSeries):void;

    //----------------------------------
	//  stackTotals
    //----------------------------------

	/**
	 *  The stack totals for the series.
	 *
	 *  @param value The totals to set.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function set stackTotals(value:Object):void;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Stacks the series. Normally, a series implements the <code>updateData()</code> method
	 *  to load its data out of the data provider. But a stacking series performs special 
	 *  operations because its values are not necessarily stored in its data provider. 
	 *  Its values are whatever is stored in its data provider, summed with the values 
	 *  that are loaded by the object it stacks on top of.
	 *  <p>A custom stacking series should implement the <code>stack()</code> method by loading its 
	 *  data out of its data provider, adding it to the base values stored in the dictionary
	 *  to get the real values it should render with, and replacing the values in the dictionary 
	 *  with its new, summed values.</p>
	 *  
	 *  @param stackedXValueDictionary Contains the base values that the series should stack 
	 *  on top of. The keys in the dictionary are the y values, and the values are the x values.
	 *  
	 *  @param previousElement The previous element in the stack. If, for example, the element
	 *  is of the same type, you can use access to this property to avoid duplicate effort when
	 *  rendering.
	 *  
	 *  @return The maximum value in the newly stacked series.	 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function stack(stackedXValueDictionary:Object,
				   previousElement:IStackable):Number;
}

}
