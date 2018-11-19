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
	
import mx.collections.ArrayCollection;
import mx.core.mx_internal;
use namespace mx_internal;
	
/**
 * A set of disabled date range utilities
 * used by DateTimeAxis
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DateRangeUtilities
{
//	include "../../core/Version.as";
	
	//--------------------------------------------------------------------------
	//
	// Class Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private static const DAYS_IN_WEEK:Number = 7; 
	   
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_MINUTE:Number = 1000 * 60;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_HOUR:Number = 1000 * 60 * 60;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_DAY:Number = 1000 * 60 * 60 * 24;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_WEEK:Number = 1000 * 60 * 60 * 24 * 7;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_MONTH:Number = 1000 * 60 * 60 * 24 * 30;
    
    /**
     *  @private
     */
    private static const MILLISECONDS_IN_YEAR:Number = 1000 * 60 * 60 * 24 * 365;
    
    
    //--------------------------------------------------------------------------
	//
	// Class Variables
	//
	//--------------------------------------------------------------------------
	/**
	 * @private
	 */
	private static var disabledDayDifference:Number = 0;
	
	//--------------------------------------------------------------------------
	//
	//Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var disabledRangeSet:Array /* of Range */ = [];
	
	/**
	 * @private
	 */
	private var disabledDaySet:Array /* of int */ = [];	
	
	
	/**
	 * @private
	 */
	private var minimum:Number;
	
	/**
	 *  @private
	 */
	private var begin:Boolean = true;
	
    
	
	//---------------------------------------------------------------------------
	//
	// Methods
	//
	//---------------------------------------------------------------------------
	
	/**
	 * To build set of disabled ranges in terms of milliseconds
	 * for given sets of disabledDays and disabledRanges
	 * 
	 * @param disabledDays Array of disabledDays of a week
	 * 
	 * @param disabledRanges Array of disabled date ranges
	 * 
	 * @param computedMinimum Time in milliseconds from which disabledRangeSet is to be built
	 * 
	 * @param computedMaximum Time in milliseconds upto which disabledRangeSet is to be built
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	mx_internal function createDisabledRangeSet(disabledDays:Array /* of int */,
												 disabledRanges:Array /* of Object */,
												 computedMinimum:Number, 
												 computedMaximum:Number):void
	{
    	var rangeStart:Number;
    	var rangeEnd:Number;
		var i:int;
		var n:int;
		
		disabledRangeSet=[];
		disabledDaySet = [];
		minimum = computedMinimum;
		if (disabledDays)
		{
			n = disabledDays.length;
			for (i = 0; i < n; i++)
			{
				if (disabledDaySet.indexOf(disabledDays[i]) == -1 && disabledDays[i] >= 0 && disabledDays[i] <= 6)
					disabledDaySet.push(disabledDays[i]);
			}
		}		
		if (disabledRanges)
		{
			n = disabledRanges.length;
			for (i = 0; i < n; i++)
			{
				if (disabledRanges[i] is Date)
				{
					var startTime:Number = Date.parse(disabledRanges[i]);
					rangeStart = Math.max(computedMinimum, startTime);
					rangeEnd = Math.min(computedMaximum, startTime + MILLISECONDS_IN_DAY - 1);
					if (rangeStart < rangeEnd)
						disabledRangeSet.push(new Range(rangeStart, rangeEnd));
				}
				else if (disabledRanges[i] is Object)
				{
					if (!disabledRanges[i].rangeStart &&
					disabledRanges[i].rangeEnd)
                	{
                    	rangeStart = computedMinimum;
                    	if (disabledRanges[i].rangeEnd.getHours() == 0 && disabledRanges[i].rangeEnd.getMinutes() == 0 
					   		&& disabledRanges[i].rangeEnd.getSeconds() == 0 && disabledRanges[i].rangeEnd.getMilliseconds() == 0) 
                    		rangeEnd = Math.min(computedMaximum,
                    	                    (Date.parse(disabledRanges[i].rangeEnd) + MILLISECONDS_IN_DAY - 1));
                    	else
                    		rangeEnd = Math.min(computedMaximum,
                    	                    (Date.parse(disabledRanges[i].rangeEnd) - 1));
                    	if (rangeStart < rangeEnd)
                    		disabledRangeSet.push(new Range(rangeStart, rangeEnd));
                	}
                	else if (disabledRanges[i].rangeStart &&
						!disabledRanges[i].rangeEnd)
                	{
                    	rangeEnd = computedMaximum;
                    	rangeStart = Math.max(computedMinimum, Date.parse(disabledRanges[i].rangeStart));
                    	if (rangeStart < rangeEnd)
                    		disabledRangeSet.push(new Range(rangeStart, rangeEnd));
                	}
                	else if (disabledRanges[i].rangeStart &&
						 disabledRanges[i].rangeEnd)
                	{
                		if (disabledRanges[i].rangeEnd.getHours() == 0 && disabledRanges[i].rangeEnd.getMinutes() == 0 
					   		&& disabledRanges[i].rangeEnd.getSeconds() == 0 && disabledRanges[i].rangeEnd.getMilliseconds() == 0)
                    		rangeEnd = Math.min(computedMaximum, 
                    	                    (Date.parse(disabledRanges[i].rangeEnd) + MILLISECONDS_IN_DAY - 1));
                    	else
                    		rangeEnd = Math.min(computedMaximum, 
                    	                    (Date.parse(disabledRanges[i].rangeEnd) - 1));
                    	rangeStart = Math.max(computedMinimum, Date.parse(disabledRanges[i].rangeStart));
                    	if (rangeStart < rangeEnd)
                    		disabledRangeSet.push(new Range(rangeStart, rangeEnd));
                	}
				}
			}
		}
		
		var disabledRangeSetChanged:Boolean = true;
		var disabledArray:ArrayCollection = new ArrayCollection(disabledRangeSet);
		
		//merge overlapping disabled regions
		n = disabledRangeSet.length;	
		for (i = 0; i < n;)
		{
			var m:int = disabledArray.length;
			for (var j:int = 0; j < m;)
			{
				disabledRangeSetChanged = false;
				if (disabledArray[j].rangeStart >= disabledRangeSet[i].rangeStart && 
				   disabledArray[j].rangeEnd <= disabledRangeSet[i].rangeEnd && i!=j)
				{
					disabledArray[j].rangeStart = computedMinimum - 1;
					disabledRangeSetChanged = true;
				}
				else if (disabledArray[j].rangeStart >= disabledRangeSet[i].rangeStart && 
				        disabledArray[j].rangeStart <= disabledRangeSet[i].rangeEnd && 
				        disabledArray[j].rangeEnd >= disabledRangeSet[i].rangeEnd && i!=j)
				{
					disabledArray[i].rangeEnd = disabledArray[j].rangeEnd;
					disabledArray[j].rangeStart = computedMinimum - 1;
					disabledRangeSetChanged = true;
				}
				else if (disabledArray[j].rangeStart <= disabledRangeSet[i].rangeStart &&
				        disabledArray[j].rangeEnd >= disabledRangeSet[i].rangeStart && 
				        disabledArray[j].rangeEnd <= disabledRangeSet[i].rangeEnd && i!=j)
				{
					disabledArray[i].rangeStart = disabledArray[j].rangeStart;
					disabledArray[j].rangeStart = computedMinimum - 1;
					disabledRangeSetChanged = true;
				}
				if (disabledRangeSetChanged)
				{
					var l:int = disabledArray.length;
					for (var k:int = 0; k < l;)
					{
						if (disabledArray[k].rangeStart < computedMinimum)
						{
							disabledArray.removeItemAt(k);
							l = disabledArray.length;
							m = l;
						}
						else
							k++;
					}
					disabledRangeSet = [];
					l = disabledArray.length;
					for (k = 0; k < l; k++)
					{
						disabledRangeSet.push(disabledArray.getItemAt(k));
					}
					j = 0;
				}
				else
					j++;				
			}
			if (disabledRangeSetChanged)
				i = 0;
			else
				i++;
			n = disabledRangeSet.length;			
		}		
		disabledRangeSet.sortOn(["rangeStart","rangeEnd"],[Array.NUMERIC]);
	}
	
	/**
	 * Returns number of milliseconds disabled in a given range
	 * 
	 * @param start Time in milliseconds from which disabledTime is to be calculated
	 * 
	 * @param end Time in milliseconds upto which disabledTime is to be calculated
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	mx_internal function calculateDisabledRange(start:Number, end:Number):Number
	{
		var temp:Number;
		var difference:Number = 0;
		var range:Range;
		
		var tmpDate:Date = new Date(start);
		tmpDate.setHours(0,0,0,0);
		temp = tmpDate.getTime(); 
		temp = temp + MILLISECONDS_IN_DAY; // nearest full day
		var i:int = 0;
		var n:int;
		if (disabledDaySet.length > 0)
		{
			if (disabledDaySet.indexOf(tmpDate.day)!=-1)
			{
				range = new Range(start, temp - 1);
				difference = calculateActualDisabledRange(range, difference);
			}
			var tmpTime:Number = temp;
			n = disabledDaySet.length;
			for (i = 0; i < n; i++)
			{
				var disDay:Number = disabledDaySet[i];
				temp = tmpTime;
				while(temp < end)
				{
					tmpDate = new Date(temp);
					var tempDay:Number = tmpDate.day;
					if (tempDay == disDay)
					{
						range = new Range(temp, temp + MILLISECONDS_IN_DAY - 1);
						difference = calculateActualDisabledRange(range,difference);
						temp = temp + MILLISECONDS_IN_WEEK;
					}
					else if (tempDay < disDay)
					{
						var diff:Number = disDay - tempDay;
						temp = temp + diff * MILLISECONDS_IN_DAY;
						if (temp < end)
						{
							range = new Range(temp, temp + MILLISECONDS_IN_DAY - 1);
							difference = calculateActualDisabledRange(range,difference);
						}
						temp = temp + MILLISECONDS_IN_WEEK;
					}
					else
					{
						diff = DAYS_IN_WEEK - tempDay;
						temp = temp + (diff + disDay) * MILLISECONDS_IN_DAY;
						if (temp < end)
						{
							range = new Range(temp, temp + MILLISECONDS_IN_DAY - 1);
							difference = calculateActualDisabledRange(range,difference);
						}
						temp = temp + MILLISECONDS_IN_WEEK;
					}
				}
				if (temp == end)
				{
					tmpDate = new Date(temp);
					tempDay = tmpDate.day;
					if (tempDay == disDay)
					{
						range = new Range(temp , temp + MILLISECONDS_IN_DAY - 1);
						difference = calculateActualDisabledRange(range,difference);
					}
				}
			}			
		}
		
		n = disabledRangeSet.length;
		for (i = 0; i < n; i++)
        {
        	if (end > disabledRangeSet[i].rangeStart)
        		difference = difference + (disabledRangeSet[i].rangeEnd - disabledRangeSet[i].rangeStart);	
        	else
        		break;
        }
        return difference;
	}
	
	/**
	 * @private
	 * Returns effective disabled range by checking whether the given range overlaps with 
	 * any of the ranges in disabledRangeSet array
     */
	private function calculateActualDisabledRange(range:Range,
	                                               difference:Number):Number
	{
		var considered:Boolean = false;
		var n:int = disabledRangeSet.length;
		if (n != 0)
		{
			for (var i:int = 0; i < n;)
			{
				if (range.rangeStart >= disabledRangeSet[i].rangeStart && 
				   range.rangeEnd <= disabledRangeSet[i].rangeEnd)
				{
					//range is within a disabledRange that was already considered
					considered = true;
					break;
				}
				else if (range.rangeStart >= disabledRangeSet[i].rangeStart &&
				        range.rangeStart < disabledRangeSet[i].rangeEnd && 
				        range.rangeEnd > disabledRangeSet[i].rangeEnd)
				{
					range.rangeStart = disabledRangeSet[i].rangeEnd;
					i = 0;
				}
				else if (range.rangeStart <= disabledRangeSet[i].rangeStart && 
				        range.rangeEnd > disabledRangeSet[i].rangeStart && 
				        range.rangeEnd < disabledRangeSet[i].rangeEnd)
				{
					range.rangeEnd = disabledRangeSet[i].rangeStart;
					i = 0;
				}
				else
				{
					i++;
				}	
			}
		}
		if (!considered)
			difference = difference + (range.rangeEnd - range.rangeStart);
		
		considered = false;
		return difference;
	}
	
	/**
	 * Returns sum of milliseconds disabled in a given range 
	 * and milliseconds disabled before that range.
	 * 
	 * This is used for labels and minor ticks.
	 * 
	 * @param start Time in milliseconds from which disabledTime is to be calculated
	 * 
	 * @param end Time in milliseconds upto which disabledTime is to be calculated
	 * 
	 * @param units Units that axis uses to generate labels/minorTicks
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	mx_internal function getDisabledRange(start:Number, end:Number, units:String):Number
	{
		var temp:Number;
		var difference:Number = 0;
		var considered:Boolean = false;
		var tmpDate:Date;
		var maxUnitLength:Number;
		temp = start;
		switch (units)
		{
			case "years":
			{
				maxUnitLength = MILLISECONDS_IN_YEAR;
				break;
			}
			case "months":
			{
				maxUnitLength = MILLISECONDS_IN_MONTH;
				break;
			}
			default:
				maxUnitLength = MILLISECONDS_IN_DAY;
		}
		if (begin)
		{
			if (Math.abs(start - minimum) < maxUnitLength)
			{	
				disabledDayDifference = 0;
				begin = false;
			}
		}
		else
		{
			begin = true;
		}
			
		if (disabledDaySet)
		{
			for (; temp < end; temp = temp + MILLISECONDS_IN_DAY)
			{
				tmpDate = new Date(temp);
				if (disabledDaySet.indexOf(tmpDate.day)!=-1)
				{
					var range:Range = new Range(temp,Math.min(temp+MILLISECONDS_IN_DAY - 1, end));
					disabledDayDifference = calculateActualDisabledRange(range, disabledDayDifference);
				}
			}
		}
		difference = disabledDayDifference;
		var n:int = disabledRangeSet.length;
		var v:Object;
		for (var i:int = 0; i < n; i++)
        {
        	if (end > disabledRangeSet[i].rangeStart)
        		difference = difference + (disabledRangeSet[i].rangeEnd - disabledRangeSet[i].rangeStart);	
        	else
        		break;
        }
        return difference;
	}
	
	/**
	 * Returns true if given time is in disabled range
	 * 
	 * @param time Time in milliseconds which is to be checked
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	mx_internal function isDisabled(time:Number):Boolean
	{
		var disabled:Boolean = false;
		
		var n:int = disabledRangeSet.length;
		var tmpDate:Date = new Date(time);
		
		if (disabledDaySet)
			if (disabledDaySet.indexOf(tmpDate.day)!=-1)
				return true;
				
        for (var i:int = 0; i < n; i++)
        {
           	if (time >= disabledRangeSet[i].rangeStart && time <= disabledRangeSet[i].rangeEnd)
           	{
           		disabled = true;
           		break;
           	}
           	else if (time < disabledRangeSet[i].rangeStart)
           		break;
        }
        return(disabled);
	}
}

}

class Range
{
//	include "../../core/Version.as";
	
	//----------------------------------------------
	//
	// Constructor
	//
	//----------------------------------------------
	
	/**
	 * @private
	 */
	 
	public function Range(rangeStart:Number,rangeEnd:Number)
	{
		this.rangeStart = rangeStart;
		this.rangeEnd = rangeEnd;
	}
	
	/**
	 * @private
	 */
	public var rangeStart:Number;
	
	/**
	 * @private
	 */
	public var rangeEnd:Number;
}