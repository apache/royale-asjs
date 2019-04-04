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
 *  The LogAxis class maps numeric values logarithmically
 *  between a minimum and maximum value along a chart axis.
 *  By default, it determines <code>minimum</code>, <code>maximum</code>,
 *  and <code>interval</code> values from the charting data
 *  to fit all of the chart elements on the screen.
 *  You can also explicitly set specific values for these properties.
 *  A LogAxis object cannot correctly render negative values,
 *  as Log10() of a negative number is <code>undefined</code>.
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LogAxis&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LogAxis
 *    <strong>Properties</strong>
 *    interval="10"
 *    maximum="null"
 *    maximumLabelPrecision="null"
 *    minimum="null"
 *  /&gt;
 *  </pre>
 * 
 *  @see mx.charts.chartClasses.IAxis
 *
 *  @includeExample examples/LogAxisExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LogAxis extends NumericAxis
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
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function LogAxis() 
	{
		super();

		computedInterval = 1;							
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
				computedMinimum = -Math.ceil(Math.log(_actualAssignedMaximum) / Math.LN10);
				assignedMinimum = computedMinimum;
			}
			if(!(isNaN(_actualAssignedMinimum)))
			{
				computedMaximum = -Math.floor(Math.log(_actualAssignedMinimum) / Math.LN10)
				assignedMaximum = computedMaximum;
			}
		}
		else
		{
			if(!(isNaN(_actualAssignedMaximum)))
			{
				computedMaximum = Math.ceil(Math.log(_actualAssignedMaximum) / Math.LN10);
				assignedMaximum = computedMaximum;
			}
			if(!(isNaN(_actualAssignedMinimum)))
			{
				computedMinimum = Math.floor(Math.log(_actualAssignedMinimum) / Math.LN10);
				assignedMinimum = computedMinimum;
			}
			
		}
		super.direction = value;
	}

	//----------------------------------------------------------------------------
	//
	// Properties
	//
	//----------------------------------------------------------------------------
	
	//----------------------------------
	//  interval
	//----------------------------------

    [Inspectable(category="General")]

	/**
	 *  Specifies the multiplier label values along the axis.
	 *  A value of 10 generates labels at 1, 10, 100, 1000, etc., 
	 *  while a value of 100 generates labels at 1, 100, 10000, etc.
	 *  Flex calculates the interval if this property
	 *  is set to <code>NaN</code>.
	 *  Intervals must be even powers of 10, and must be greater than or equal to 10.
	 *  The LogAxis rounds the interval down to an even power of 10, if necessary.
	 *
	 *  @default 10
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get interval():Number
	{
		return Math.pow(10, computedInterval);
	}

	/**
	 *  @private
	 */
	public function set interval(value:Number):void
	{
		if (!isNaN(value))
			value = Math.max(1, Math.floor(Math.log(value) / Math.LN10));

		if (isNaN(value))
			value = 1;

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
	 *  If <code>NaN</code>, Flex determines the maximum value
	 *  from the data in the chart. 
	 *  The maximum value must be an even power of 10.
	 *  The LogAxis rounds an explicit maximum value
	 *  up to an even power of 10, if necessary.
	 *  
	 *  @default NaN
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get maximum():Number
	{
		if(direction == "inverted")
			return Math.pow(10, -computedMinimum);
		else
			return Math.pow(10, computedMaximum);
	}
	
	/**
	 *  @private
	 */
	public function set maximum(value:Number):void
	{
		if(direction == "inverted")
		{
			computedMinimum = -Math.ceil(Math.log(value) / Math.LN10);
			assignedMinimum = computedMinimum;
		}
		else
		{
			computedMaximum = Math.ceil(Math.log(value) / Math.LN10);
			assignedMaximum = computedMaximum;
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
	 */	
	private var _maximumLabelPrecision:Number;

	/**
	 * @private
	 */
	public function get maximumLabelPrecision():Number
	{
		return _maximumLabelPrecision;
	}

	/**
	 *  Specifies the maximum number of decimal places for representing fractional 
	 *  values on the labels generated by this axis. By default, the 
	 *  Axis autogenerates this value from the labels themselves.  A value of 0 
	 *  round to the nearest integer value, while a value of 2 rounds to the nearest 
	 *  1/100th of a value.
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
	 *  The minimum value must be an even power of 10.
	 *  The LogAxis will round an explicit minimum value
	 *  downward to an even power of 10 if necessary.
	 *  
	 *  @default NaN
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get minimum():Number
	{
		if(direction == "inverted")
			return Math.pow(10, -computedMaximum);
		else
			return Math.pow(10, computedMinimum);
	}
	
	/**
	 *  @private
	 */
	public function set minimum(value:Number):void
	{
		if(direction == "inverted")
		{
			if (value == 0)
				assignedMaximum = NaN;
			else
			{			
				assignedMaximum = -(Math.floor(Math.log(value) / Math.LN10));
			}
			computedMaximum = assignedMaximum;
		}
		else
		{
			if (value == 0)
				assignedMinimum = NaN;
			else
			{			
				assignedMinimum = Math.floor(Math.log(value) / Math.LN10);
			}
			computedMinimum = assignedMinimum;
		}
		_actualAssignedMinimum = value;
		invalidateCache();

		dispatchEvent(new Event("mappingChange"));
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
	override protected function adjustMinMax(minValue:Number,
											 maxValue:Number):void
	{
		// esg: We always floor to the nearest power of 10
		//if (autoAdjust && isNaN(assignedMinimum)) 
			computedMinimum = Math.floor(computedMinimum);
		
		// esg: We always ceil o the nearest power of 10
		//if (autoAdjust && isNaN(assignedMaximum)) 
			computedMaximum = Math.ceil(computedMaximum);
	}

	/**
	 *  @private
	 */
	override public function mapCache(cache:Array /* of ChartItem */, field:String,
									  convertedField:String,
									  indexValues:Boolean = false):void
	{
		const ln10:Number = Math.LN10;

		var n:int = cache.length;
		var i:int;
		var v:Object;
		var vf:Number;
		var parseFunction:Function = this.parseFunction;
		
		if (parseFunction != null)
		{
			for (i = 0; i < n; i++)
			{
				v = cache[i];
				if(direction == "inverted")
					v[convertedField] = -(Math.log(-(Number(parseFunction(v[field])))) / ln10);
				else
					v[convertedField] =	Math.log(Number(parseFunction(v[field]))) / ln10;
			}		
		}
		else
		{
			for (i = 0; i < n && cache[i][field] == null; i++)
			{
			}
	
			if (i == n)
				return;
	
			if (cache[i][field] is String)
			{
				for (i = 0; i < n; i++)
				{
					v = cache[i];
					if(direction == "inverted")
						v[convertedField] = -(Math.log(-(Number(v[field]))) / ln10);
					else
						v[convertedField] = Math.log(Number(v[field]) / ln10);
				}
			}
			else if (cache[i][field] is XML ||
					 cache[i][field] is XMLList)
			{
				for (i = 0; i < n; i++)
				{
					v = cache[i];
					if(direction == "inverted")
						v[convertedField] = -(Math.log(-(Number(v[field].toString()))) / ln10);
					else
						v[convertedField] =	Math.log(Number(v[field].toString())) / ln10;
				}
			}
			else if (cache[i][field] is Number ||
					 cache[i][field] is int ||
					 cache[i][field] is uint)
			{
				for (i = 0; i < n; i++)
				{
					v = cache[i];
					if(direction == "inverted")
						v[convertedField] = v[field] == null ?
										NaN :
										-(Math.log(-(v[field])) / ln10);
					else
						v[convertedField] = v[field] == null ?
										NaN :
										Math.log(v[field]) / ln10;
				}
			}
			else
			{
				for (i = 0; i < n; i++)
				{
					v = cache[i];
					if(direction == "inverted")
						v[convertedField] = -(Math.log(-(parseFloat(v[field]))) / ln10);
					else
						v[convertedField] = Math.log(parseFloat(v[field])) / ln10;
				}
			}
		}
	}	

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
		
		var labelTop:Number = computedMaximum + 0.000001
		
		var labelFunction:Function = this.labelFunction;

		var i:Number;
		var v:Number;
		var roundedValue:Number;
		
		var roundBase:Number;
		if (!isNaN(_maximumLabelPrecision))
			roundBase = Math.pow(10, _maximumLabelPrecision);

		if (labelFunction != null)
		{
			var previousValue:Number = NaN;
			for (i = labelBase; i <= labelTop; i += computedInterval)
			{
				if(direction == "inverted")
					v = Math.pow(10, -i);
				else
					v = Math.pow(10, i);
					
				roundedValue = isNaN(_maximumLabelPrecision) ?
							   v :
							   Math.round(v * roundBase) / roundBase;
							   
				labelCache.push(new AxisLabel((i - computedMinimum) / r, v,
					labelFunction(roundedValue, previousValue, this)));
				
				previousValue = v;
			}		
		}
		else
		{
			for (i = labelBase; i <= labelTop; i += computedInterval)
			{
				if(direction == "inverted")
					v = Math.pow(10, -i);
				else
					v = Math.pow(10, i);
					
				roundedValue = isNaN(_maximumLabelPrecision) ?
							   v :
							   Math.round(v * roundBase) / roundBase;
				
				labelCache.push(new AxisLabel((i - computedMinimum)/r, v,
					roundedValue.toString()));
			}						
		}

		return true;
	}

	/**
	 *  @private
	 */
	override protected function buildMinorTickCache():Array /* of Number */
	{
		var cache:Array /* of Number */ = [];

		var n:int = labelCache.length;
		for (var i:int = 0; i < n; i++)
		{
			cache.push(labelCache[i].position);
		}

		return cache;
	}

	/**
	 *  @private
	 */
	override public function reduceLabels(intervalStart:AxisLabel,
										  intervalEnd:AxisLabel):AxisLabelSet
	{
		var intervalMultiplier:Number =
			Math.round((Math.log(Number(intervalEnd.value)) / Math.LN10) - 
			Math.log(Number(intervalStart.value)) / Math.LN10);
		intervalMultiplier =
			Math.floor(intervalMultiplier / computedInterval) + 1;
		
		var labels:Array /* of AxisLabel */ = [];
		var newMinorTicks:Array /* of Number */ = [];
		var newTicks:Array /* of Number */ = [];

		var r:Number = computedMaximum - computedMinimum;		
		
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum) / computedInterval) *
			computedInterval;
		
		var labelTop:Number = computedMaximum + 0.000001
		
		var n:int  = labelCache.length;
		for (var i:int = 0; i < n; i += intervalMultiplier)
		{
			var ci:AxisLabel = labelCache[i];
			labels.push(ci);
			newTicks.push(ci.position);
			newMinorTicks.push(ci.position);
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
	override public function invertTransform(value:Number):Object
	{
		update();

		return Math.pow(10,
			value * (computedMaximum - computedMinimum) + computedMinimum);
	}

	/**
	 *  @private
	 */
	override protected function guardMinMax(min:Number, max:Number):Array /* of int */
	{
		if (isNaN(min) || !isFinite(min))
			min = 0;
		if (isNaN(max) || !isFinite(max))
			max = min + 2;
		if (max == min)
			max = min + 2;

		return [min,max];
	}
}

}
