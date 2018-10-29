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

import org.apache.royale.events.Event;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.NumericAxis;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The LinearAxis class maps numeric values evenly
 *  between a minimum and maximum value along a chart axis.
 *  By default, it determines <code>minimum</code>, <code>maximum</code>,
 *  and <code>interval</code> values from the charting data
 *  to fit all of the chart elements on the screen.
 *  You can also explicitly set specific values for these properties.
 *  
 *  <p>The auto-determination of range values works as follows:
 *
 *  <ol>
 *    <li> Flex determines a minimum and maximum value
 *    that accomodates all the data being displayed in the chart.</li>
 *    <li> If the <code>autoAdjust</code> and <code>baseAtZero</code> properties
 *    are set to <code>true</code>, Flex makes the following adjustments:
 *      <ul>
 *        <li>If all values are positive,
 *        Flex sets the <code>minimum</code> property to zero.</li>
 *  	  <li>If all values are negative,
 *        Flex sets the <code>maximum</code> property to zero.</li>
 *  	</ul>
 *    </li>
 *    <li> If the <code>autoAdjust</code> property is set to <code>true</code>,
 *    Flex adjusts values of the <code>minimum</code> and <code>maximum</code>
 *    properties by rounding them up or down.</li>
 *    <li> Flex checks if any of the elements displayed in the chart
 *    require extra padding to display properly (for example, for labels).
 *    It adjusts the values of the <code>minimum</code> and
 *    <code>maximum</code> properties accordingly.</li>
 *    <li> Flex determines if you have explicitly specified any padding
 *    around the <code>minimum</code> and <code>maximum</code> values,
 *    and adjusts their values accordingly.</li>
 *  </ol>
 *  </p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LinearAxis&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LinearAxis
 *    <strong>Properties</strong>
 *    interval="null"
 *    maximum="null"
 *    maximumLabelPrecision="null"
 *    minimum="null"
 *    minorInterval="null"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.chartClasses.IAxis
 *
 *  @includeExample examples/HLOCChartExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LinearAxis extends NumericAxis 
{
//    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function LinearAxis() 
	{
		super();
	}
	
	//-------------------------------------------------------------------------
	//
	//   Variables
	//
	//-------------------------------------------------------------------------
	
    private var _actualAssignedMaximum:Number;

    private var _actualAssignedMinimum:Number;
    
	
	//-----------------------------------------------------------------------
	//
	// Overridden properties
	//
	//-----------------------------------------------------------------------
	
	//------------------------------------------
	// direction
	//------------------------------------------
	[Inspectable(category="General", enumeration="normal,inverted", defaultValue="normal")]
	/**
	 *  @private
	 */
	override public function set direction(value:String):void
	{
		if(value == "inverted")
		{
			if(!(isNaN(_actualAssignedMaximum)))
			{
				computedMinimum = -_actualAssignedMaximum;
				assignedMinimum = -_actualAssignedMaximum;
			}
			if(!(isNaN(_actualAssignedMinimum)))
			{
				computedMaximum = -_actualAssignedMinimum;
				assignedMaximum = -_actualAssignedMinimum;
			}
		}
		else
		{
			if(!(isNaN(_actualAssignedMaximum)))
			{
				computedMaximum = _actualAssignedMaximum;
				assignedMaximum = _actualAssignedMaximum;
			}
			if(!(isNaN(_actualAssignedMinimum)))
			{
				computedMinimum = _actualAssignedMinimum;
				assignedMinimum = _actualAssignedMinimum;
			}
		}
		super.direction = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------
	// alignLabelsToInterval
	//--------------------------------------------
	
	/**
	 *  @private
	 *  Storage for alignLabelsToInterval property
	 */
	private var _alignLabelsToInterval:Boolean = true;

    	
    /**
	 * @private
	 */
	public function get alignLabelsToInterval():Boolean
	{
		return _alignLabelsToInterval;
	}
	/**
	* @private
	*/
	public function set alignLabelsToInterval(value:Boolean):void
	{
		if (value != _alignLabelsToInterval)
		{
			_alignLabelsToInterval = value;
			invalidateCache();
			dispatchEvent(new Event("mappingChange"));
			dispatchEvent(new Event("axisChange"));					
		}
	}
	
	
	//----------------------------------
	//  interval
	//----------------------------------

	/**
	 *  @private
	 */
	private var _userInterval:Number;

	[Inspectable(category="General")]

	/**
	 *  Specifies the numeric difference between label values along the axis.
	 *  Flex calculates the interval if this property
	 *  is set to <code>NaN</code>.  
	 *  The default value is <code>NaN</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get interval():Number
	{
		return computedInterval;
	}
	
	/**
	 *  @private
	 */
	public function set interval(value:Number):void
	{
		if (value <= 0)
			value = NaN;
			
		_userInterval = value;

		computedInterval = value;
		invalidateCache();

		dispatchEvent(new Event("axisChange"));
	}
	
	//----------------------------------
	//  maximum
	//----------------------------------

    [Inspectable(category="General")]

	/**
	 *  Specifies the maximum value for an axis label.
	 *  If you set the <code>autoAdjust</code> property to <code>true</code>,
	 *  Flex calculates this value. 
	 *  If <code>NaN</code>, Flex determines the maximum value
	 *  from the data in the chart. 
	 *  The default value is <code>NaN</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get maximum():Number
	{
		if(direction == "inverted")
			return -computedMinimum;
		else
			return computedMaximum;
	}
	
	/**
	 *  @private
	 */
	public function set maximum(value:Number):void
	{
		if(direction == "inverted")
		{
			assignedMinimum = -value;
			computedMinimum = -value;
		}
		else
		{
			assignedMaximum = value;
			computedMaximum = value;
		}
		_actualAssignedMaximum = value;
		invalidateCache();

		dispatchEvent(new Event("mappingChange"));
		dispatchEvent(new Event("axisChange"));
	}

	//----------------------------------
	//  maximumLabelPrecision
	//----------------------------------

	/**
	 *  @private
	 *  Storage for maximumLabelPrecision property
	 */	
	private var _maximumLabelPrecision:Number;
	
	/**
	 *  @private
	 */
	public function get maximumLabelPrecision():Number
	{
		return _maximumLabelPrecision;
	}
	
	/**
	 *  Specifies the maximum number of decimal places for representing fractional values on the labels
	 *  generated by this axis. By default, the axis autogenerates this value from the labels themselves.
	 *  A value of 0 rounds to the nearest integer value, while a value of 2 rounds to the nearest 1/100th 
	 *  of a value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function set maximumLabelPrecision(value:Number):void
	{
		_maximumLabelPrecision = value;

		invalidateCache();
	}

	//----------------------------------
	//  minimum
	//----------------------------------

    [Inspectable(category="General")]

	/**
	 *  Specifies the minimum value for an axis label.
	 *  If <code>NaN</code>, Flex determines the minimum value
	 *  from the data in the chart. 
	 *  The default value is <code>NaN</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get minimum():Number
	{
		if(direction == "inverted")
			return -computedMaximum;
		else
			return computedMinimum;
	}
	
	/**
	 *  @private
	 */
	public function set minimum(value:Number):void
	{
		if(direction == "inverted")
		{
			assignedMaximum = -value;
			computedMaximum = -value;
		}
		else
		{
			assignedMinimum = value;
			computedMinimum = value;
		}
		_actualAssignedMinimum = value;
		invalidateCache();

		dispatchEvent(new Event("mappingChange"));
		dispatchEvent(new Event("axisChange"));
		
	}

	//----------------------------------
	//  minorInterval
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the minorInterval property.
	 */
	private var _minorInterval:Number;

	/**
	 *  @private
	 */
	private var _userMinorInterval:Number;

    [Inspectable(category="General")]
	
	/**
	 *  Specifies the numeric difference between minor tick marks along the axis.
	 *  Flex calculates the difference if this property
	 *  is set to <code>NaN</code>.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get minorInterval():Number
	{
		return _minorInterval;
	}
	
	/**
	 *  @private
	 */
	public function set minorInterval(value:Number):void
	{
		if (value <= 0)
			value = NaN;
			
		_userMinorInterval = value;
		_minorInterval = value;

		invalidateCache();

		dispatchEvent(new Event("axisChange"));
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: NumericAxis
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function buildLabelCache():Boolean
	{
		if (labelCache)
			return false;

		labelCache = [];

		var r:Number = computedMaximum - computedMinimum;
				
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum) / computedInterval) *
			computedInterval;

		if (_alignLabelsToInterval)
			labelBase = Math.ceil(labelBase / computedInterval) * computedInterval;
			
		var labelTop:Number = computedMaximum;

		var i:Number;
		
		var precision:Number = _maximumLabelPrecision;
		if (isNaN(precision))
		{
			var decimal:Number = Math.abs(computedInterval) -
								 Math.floor(Math.abs(computedInterval));
			
			precision =
				decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10);
			
			decimal = Math.abs(computedMinimum) -
					  Math.floor(Math.abs(computedMinimum));
			
			precision = Math.max(precision,
				decimal == 0 ? 1: -Math.floor(Math.log(decimal) / Math.LN10));
		}
		var roundBase:Number = Math.pow(10, precision);

		var labelFunction:Function = this.labelFunction;

		var roundedValue:Number;

		if (labelFunction != null)
		{
			var previousValue:Number = NaN;
			for (i = labelBase; i <= labelTop; i += computedInterval)
			{
				roundedValue = Math.round(i * roundBase) / roundBase;
				if(direction == "inverted")
					roundedValue = -roundedValue;
				
				labelCache.push(new AxisLabel(
					(i - computedMinimum) / r, i,
					labelFunction(roundedValue, previousValue, this)));

				previousValue = roundedValue;
			}
		}
		else
		{
			for (i = labelBase; i <= labelTop; i += computedInterval)
			{
				roundedValue = Math.round(i * roundBase) / roundBase;
				if(direction == "inverted")
					roundedValue = -roundedValue;
				labelCache.push(new AxisLabel(
					(i - computedMinimum) / r, i, roundedValue.toString()));
			}
		}
				
		return true;
	}

	/**
	 *  @private
	 */
	override public function reduceLabels(intervalStart:AxisLabel,
										  intervalEnd:AxisLabel):AxisLabelSet
	{
		// What's this calculation?
		// We're trying to figure out how many labels we need to skip.
		// If we assume that every adjacent label is 1 computedInterval apart,
		// then we can guess the ordinal distance between any two labels by
		// dividing the difference in their values by computedInterval.
		// So, what's with the round? Well, in theory, the distance
		// between any two labels is an integral number of _intervals.
		// but floating-point rounding errors, especially on small intervals,
		// can throw us off by a little bit. So we add in a round()
		// to get us back to a nice whole integer.
		var intervalMultiplier:Number =
			Math.round((Number(intervalEnd.value) -
			Number(intervalStart.value)) / computedInterval) + 1;

		var newMinorInterval:Number = intervalMultiplier * _minorInterval;
		
		var labels:Array /* of AxisLabel */ = [];
		var newMinorTicks:Array /* of Number */ = [];
		var newTicks:Array /* of Number */ = [];		

		var n:int = labelCache.length;
		for (var i:int = 0; i < n; i += intervalMultiplier)
		{
			labels.push(labelCache[i]);
			newTicks.push(labelCache[i].position);
		}		
		
		var r:Number = computedMaximum - computedMinimum;	
			
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum)/newMinorInterval) * 
			newMinorInterval;

		if (_alignLabelsToInterval)
			labelBase = Math.ceil(labelBase / newMinorInterval) * newMinorInterval;

		var labelTop:Number = computedMaximum + 0.000001

		for (var j:Number = labelBase; j <= labelTop; j += newMinorInterval)
		{
			newMinorTicks.push((j - computedMinimum) / r);
		}		

		var labelSet:AxisLabelSet = new AxisLabelSet();
		labelSet.labels = labels;
		labelSet.minorTicks = newMinorTicks;
		labelSet.ticks = newTicks;
		labelSet.accurate = true;
		return labelSet;
	}

	/**
	 *  @private
	 */
	override protected function buildMinorTickCache():Array /* of Number */
	{
		var cache:Array /* of Number */ = [];

		var r:Number = computedMaximum - computedMinimum;		
		
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum) / _minorInterval) *
			_minorInterval;

		if (_alignLabelsToInterval)
			labelBase = Math.ceil(labelBase / _minorInterval) * _minorInterval;

		var labelTop:Number = computedMaximum;

		for (var i:Number = labelBase; i <= labelTop; i += _minorInterval)
		{
			cache.push((i - computedMinimum) / r);
		}
				
		return cache;
	}
	
	/**
	 *  @private
	 */
	override protected function adjustMinMax(minValue:Number,
											 maxValue:Number):void
	{
		var interval:Number = _userInterval;

		if (autoAdjust == false && 
			!isNaN(_userInterval) &&
			!isNaN(_userMinorInterval))
		{
			return;
		}

		// New calculations to accomodate negative values.
		// Find the nearest power of ten for y_userInterval
		// for line-grid and labelling positions.
		if (maxValue == 0 && minValue == 0)
			maxValue = 100;
		var maxPowerOfTen:Number =
			Math.floor(Math.log(Math.abs(maxValue)) / Math.LN10);
		var minPowerOfTen:Number =
			Math.floor(Math.log(Math.abs(minValue)) / Math.LN10);
		var powerOfTen:Number =
			Math.floor(Math.log(Math.abs(maxValue - minValue)) / Math.LN10)
		
		var y_userInterval:Number;
		
		if (isNaN(_userInterval))
		{
			y_userInterval = Math.pow(10, powerOfTen);

			if (Math.abs(maxValue - minValue) / y_userInterval < 4)
			{
				powerOfTen--;
				y_userInterval = y_userInterval * 2 / 10;
			}
		}
		else
		{
			y_userInterval = _userInterval;
		}

		// Bug 148745:
		// Using % to decide if y_userInterval divides maxValue evenly
		// is running into floating point errors.
		// For example, 3 % .2 == .2.
		// Multiplication and division don't seem to have the same problems,
		// so instead we divide, round and multiply.
		// If we get back to the same value, it means that either it fit evenly,
		// or the difference was trivial enough to get rounded out
		// by imprecision.
		
		var y_topBound:Number =
			Math.round(maxValue / y_userInterval) * y_userInterval == maxValue ?
			maxValue :
			(Math.floor(maxValue / y_userInterval) + 1) * y_userInterval;
		
		var y_lowerBound:Number;
		
		if (isFinite(minValue))
			y_lowerBound = 0;
		
		if (minValue < 0 || baseAtZero == false)
		{
			y_lowerBound =
				Math.floor(minValue / y_userInterval) * y_userInterval;
	
			if (maxValue < 0 && baseAtZero)
				y_topBound = 0;
		}
		else 
		{
			y_lowerBound = 0;
		}

		// OK, we've figured out our interval.
		// If the caller wants us to lower it based on layout rules,
		// we have more to do. Otherwise, return here.
		// If the user didn't provide us with an interval,
		// we'll use the one we just generated
			
		if (isNaN(_userInterval))
			computedInterval = y_userInterval;
			
		if (isNaN(_userMinorInterval))
			_minorInterval = computedInterval / 2;
		
		// If the user wanted to us to autoadjust the min/max
		// to nice clean values, record the ones we just caluclated.
		// If the user has provided us with specific min/max values,
		// we won't blow that away here.
		if (autoAdjust)
		{
			if (isNaN(assignedMinimum))
				computedMinimum = y_lowerBound;
			
			if (isNaN(assignedMaximum))
				computedMaximum = y_topBound;
		}
	}
}

}
