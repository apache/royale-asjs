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

import org.apache.royale.events.Event;

import mx.charts.AxisLabel;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The NumericAxis class acts as a common base class
 *  for axis types representing a continuous range of values
 *  between a defined minimum and maximum.
 *  The built-in LinearAxis, LogAxis, and DateTimeAxis
 *  classes all extend this base class.
 *  
 *  @see mx.charts.DateTimeAxis
 *  @see mx.charts.LinearAxis
 *  @see mx.charts.LogAxis
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class NumericAxis extends AxisBase implements IAxis
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
    public function NumericAxis()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private var _labelSet:AxisLabelSet;
    
    /**
     *  @private 
     */
    private var _cachedDataDescriptions:Array /* of DataDescription */;

    /**
     *  @private
     */
    private var _cachedValuesHaveBounds:Boolean;
    
    /**
     *  @private
     */
    private var _regenerateAutoValues:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  assignedMaximum
    //----------------------------------

    /**
     *  The explicitly assigned maximum value.
     *  If no value has been assigned, this will be <code>NaN</code>.
     *  Typically, calculations should be performed
     *  with the <code>computedMaximum</code> field.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var assignedMaximum:Number;

    //----------------------------------
    //  assignedMinimum
    //----------------------------------

    /**
     *  The explicitly assigned minimum value.
     *  If no value has been assigned, this will be <code>NaN</code>.
     *  Typically calculations should be performed
     *  with the <code>computedMinimum</code> field.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var assignedMinimum:Number;
    
    //----------------------------------
    //  autoAdjust
    //----------------------------------

    /**
     *  @private
     *  Storage for the autoAdjust property.
     */
    private var _autoAdjust:Boolean = true;

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Specifies whether Flex rounds values.
     *  If <code>false</code>, Flex does not round the values
     *  set by the <code>minimum</code> and <code>maximum</code> properties,
     *  or modify the default <code>minimum</code> and
     *  <code>maximum</code> values.
     *  
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get autoAdjust():Boolean 
    {
        return _autoAdjust;
    }
    
    /**
     *  @private
     */
    public function set autoAdjust(value:Boolean):void
    {
        _autoAdjust = value;

        dataChanged();
    }
    
    //----------------------------------
    //  baseAtZero
    //----------------------------------
    /**
     *  Storage for baseAtZero property
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _baseAtZero:Boolean = true;
    
    [Inspectable(category="General", defaultValue="true")]

    /**
     *  Specifies whether Flex tries to keep the <code>minimum</code>
     *  and <code>maximum</code> values rooted at zero.
     *  If all axis values are positive, the minimum axis value is zero.
     *  If all axis values are negative, the maximum axis value is zero.  
     *  
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */    
    public function get baseAtZero():Boolean
    {
        return _baseAtZero;
    }
    
    /**
     * @private
     */ 
    public function set baseAtZero(value:Boolean):void
    {
        _baseAtZero = value;
            
        dataChanged();      
    }

    //----------------------------------
    //  computedInterval
    //----------------------------------

    /**
     *  The computed interval represented by this axis.
     *  The <code>computedInterval</code> is used
     *  by the AxisRenderer and Gridlines classes
     *  to determine where to render tick marks and grid lines.
     *  The NumericAxis base class watches this field for changes
     *  to determine if the chart needs to be re-rendered.
     *  Derived classes are responsible for computing the value
     *  of this field.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var computedInterval:Number;
    
    //----------------------------------
    //  computedMaximum
    //----------------------------------

    /**
     *  The computed maximum value represented by this axis.
     *  If the user has explicitly assigned a maximum value,
     *  the <code>computedMaximum</code> and
     *  <code>assignedMaximum</code> properties
     *  are usually the same.
     *  Otherwise, the <code>computedMaximum</code> is generated
     *  from the values represented in the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var computedMaximum:Number;
    
    //----------------------------------
    //  computedMinimum
    //----------------------------------

    /**
     *  The computed minimum value represented by this axis.
     *  If the user has explicitly assigned a minimum value,
     *  the <code>computedMinimum</code> and
     *  <code>assignedMinimum</code> properties
     *  are usually be the same.
     *  Otherwise, the <code>computedMinimum</code> is generated
     *  from the values represented in the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var computedMinimum:Number;
    
	//----------------------------------
	//  direction
	//----------------------------------

	/**
	 *  @private
	 */
	private var _direction:String = "normal";

	[Inspectable(category="General", enumeration="normal,inverted", defaultValue="normal")]

	/**
 	 *  Determines the direction in which the axis is rendered.
     *  Possible values are <code>normal</code>,
     *  and <code>inverted</code>.
     * 
     *  All derived classes should take care of the way min and max
     *  are set depending on <code>direction</code>.
     * 
     *  All series should take care of the way it is rendered
     *  depending on the <code>direction</code> of its underlying axis. 
     * 
     *  @default "normal"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 4
	 */
	public function get direction():String
	{
		return _direction;
	}
	
	/**
	 *  @private
	 */
	public function set direction(value:String):void
	{
		if(_direction != value)
		{
			_direction = value;
			invalidateCache();
			dataChanged();
		}
	}

    //----------------------------------
    //  labelCache
    //----------------------------------

    /**
     *  The most recent set of AxisLabel objects
     *  generated to represent this axis.
     *  This property is <code>null</code> if the axis
     *  has been modified and requires new labels.
     *  To guarantee that the value of the <code>labelCache</code> property
     *  is correct, call the <code>buildLabelCache()</code> method
     *  before accessing the <code>labelCache</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var labelCache:Array /* of AxisLabel */;
    
    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function = null;

    [Inspectable(category="General")]
    
    /**
     *  Called to format axis values for display as labels.
     *  A <code>labelFunction</code> has the following signature:
     *  <pre>
     *  function <i>function_name</i>(<i>labelValue</i>:Object, <i>previousValue</i>:Object, <i>axis</i>:IAxis):String { ... }
     *  </pre>
     *  
     *  <p>If you know the types of the data your function will be formatting,
     *  you can specify an explicit type for the <code>labelValue</code>
     *  and <code>previousValue</code> parameters.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }
    
    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;

        invalidateCache();

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));
    }

    //----------------------------------
    //  labelMaximum
    //----------------------------------

    /**
     *  The maximum value where a label should be placed.
     *  After computing an adjusted minimum value,
     *  many axis types expand the range of the axis further
     *  to make room for additional rendering artifacts in the chart,
     *  such as labels and borders.
     *  This value represents the maximum value in the chart
     *  <em>before</em> it is adjusted for these artifacts.
     *  Typically axes generate labels to make sure
     *  this value is labeled, rather than the adjusted maximum of the axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var labelMaximum:Number;

    //----------------------------------
    //  labelMinimum
    //----------------------------------

    /**
     *  The minimum value where a label should be placed.
     *  After computing an adjusted minimum value,
     *  many axis types expand the range of the axis further
     *  to make room for additional rendering artifacts in the chart,
     *  such as labels and borders.
     *  This value represents the minimum value in the chart
     *  <em>before</em> it is adjusted for these artifacts.
     *  Typically axes will generate labels to make sure
     *  this value is labeled, rather than the adjusted minimum of the axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var labelMinimum:Number;
    
    //----------------------------------
    //  mappedMaximum
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The computed minimum value for the axis
     *  as long as this value is greater than 0.
     *  If the maximum value is less than or equal to 0,
     *  then the <code>baseline</code> property is the computed maximum.
     *  If neither value is greater than 0,
     *  then the <code>baseline</code> property is 0.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get baseline():Number
    {
        var baseVal:Number;
        
        if (computedMinimum >= 0)
            baseVal = computedMinimum;              
        else if (computedMaximum <= 0)
            baseVal = computedMaximum;
        else
            baseVal = 0;

        return baseVal;
    }

    //----------------------------------
    //  minorTickCache
    //----------------------------------

    /**
     *  The most recent set of minor tick marks generated to represent this axis.
     *  This property may be <code>null</code> if the axis
     *  has been modified and requires new labels and tick marks.
     *  Use the public accessor <code>minorTicks</code>
     *  to build the minor tick marks on demand.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var minorTickCache:Array /* of Number */;
    
    //----------------------------------
    //  minorTicks
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  An Array of minor tick marks generated to represent this axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minorTicks():Array /* of Number */
    {
        if (!minorTickCache)
            minorTickCache = buildMinorTickCache();
        
        return minorTickCache;
    }

    //----------------------------------
    //  padding
    //----------------------------------

    /**
     *  @private
     *  Storage for the padding property.
     */
    private var _padding:Number;

    [Inspectable(category="General")]

    /**
     *  Specifies padding that Flex adds to the calculated minimum and maximum
     *  values for the axis when rendering the values on the screen.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get padding():Number
    {
        return _padding;
    }

    /**
     *  @private
     */
    public function set padding(value:Number):void
    {
        _padding = value;

        invalidateCache();

        dispatchEvent(new Event("axisChange"));
    }
    
    //----------------------------------
    //  parseFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the parseFunction property.
     */
    private var _parseFunction:Function = null;  

    [Inspectable(category="Other")]
    
    /** 
     *  Specify a <code>parseFunction</code> to customize how
     *  the values rendered by your chart are converted into numeric values.
     *  A custom <code>parseFunction</code> is passed a data value
     *  and should return a corresponding number representing the same value.
     *  By default, this axis uses the ECMA function <code>parseFloat()</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get parseFunction():Function
    {
        return _parseFunction;
    }
    
    /**
     *  @private
     */
    public function set parseFunction(value:Function):void
    {
        _parseFunction = value;

        invalidateCache();
        _cachedDataDescriptions = null;

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange"));     
    }

    //----------------------------------
    //  requiredDescribedFields
    //----------------------------------

    /**
     *  The fields of the DescribeData structure that this axis is interested in.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get requiredDescribedFields():uint
    {
        return DataDescription.REQUIRED_MIN_MAX |
               DataDescription.REQUIRED_BOUNDED_VALUES;
    }

    //----------------------------------
    //  ticks
    //----------------------------------

    /**
     *  An Array of tick marks for this axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get ticks():Array /* of Number */
    {
        var result:Array /* of Number */ = [];

        var n:int = labelCache.length;
        for (var i:int = 0; i < n; i++)
        {
            result.push(labelCache[i].position);    
        }       
        
        return result;
    }

    //----------------------------------
    //  zeroValue
    //----------------------------------

    /**
     *  @private
     */
    mx_internal function get zeroValue():Number
    {
        return 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AxisBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function dataChanged():void
    {
        // We don't call invalidateCache() here, because invalidateCache()
        // forces a rebuild of the labels.
        // But just changing the data doesn't guarantee the labels have changed.
        // Instead, we need to recalc our autogenerated values,
        // and then see if the values have changed.
        minorTickCache = null;
        _cachedDataDescriptions = null;
        _regenerateAutoValues = true;           

		dispatchEvent(new Event("mappingChange"));
		
        if (isNaN(assignedMinimum) || isNaN(assignedMaximum))
        {
            dispatchEvent(new Event("axisChange"));
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @copy mx.charts.chartClasses.IAxis#mapCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function mapCache(cache:Array /* of Object */, field:String,
                             convertedField:String,
                             indexValues:Boolean = false):void
    {
        var n:int = cache.length;
        var i:int;
        
        var v:Object;
        
        if (_parseFunction != null)
        {
            for (i = 0; i < n; i++)
            {
                v = cache[i];               
                v[convertedField] = _parseFunction(v[field]);
            }       
        }
        else
        {
            for (i = 0; i < n && cache[i][field] == null; i++)
            {
            }
            if (i == n)
                return;
                
            if ((cache[i][field] is String))
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    v[convertedField] = Number(v[field]);
                }
            }
            else if (cache[i][field] is XML ||
                     cache[i][field] is XMLList)
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                     v[convertedField] =   parseFloat(v[field].toString());
                }               
            }
            else if (cache[i][field] is Number ||
                     cache[i][field] is int ||
                     cache[i][field] is uint)
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    if (v[field] == null || v[field].toString() == "")
                    	v[convertedField] = NaN;
                    else
                        v[convertedField] = v[field];
                }
            }
            else
            {
                for (; i < n; i++)
                {
                    v = cache[i];
                    v[convertedField] = parseFloat(v[field]);
                }
            }
        }
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#filterCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function filterCache(cache:Array /* of Object */, field:String,
                                filteredField:String):void
    {
        update();

        // Avoid roundoff errors.
        var max:Number = computedMaximum + 0.00001;
        var min:Number = computedMinimum - 0.00001;
        
        var n:int = cache.length;
        for (var i:int = 0; i < n; i++)
        {
            var v:Object = cache[i][field];
            cache[i][filteredField] = v >= min && v <= max ? v : NaN;
        }
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#transformCache()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function transformCache(cache:Array /* of Object */, field:String,
                                   convertedField:String):void
    {
        update();

        var r:Number = computedMaximum - computedMinimum; 

        var n:int = cache.length;
        for (var i:int = 0; i < n; i++)
        {
            cache[i][convertedField] = (cache[i][field] - computedMinimum) / r;
        }
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#invertTransform()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invertTransform(value:Number):Object
    {
        update();
        return value * (computedMaximum - computedMinimum) + computedMinimum;
    }
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#formatForScreen()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function formatForScreen(value:Object):String    
    {
    	if(direction == "inverted")
    		value = -(Number(value)) as Object;
    	else
    		value = Number(value) as Object;
        return value.toString();
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#getLabelEstimate()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getLabelEstimate():AxisLabelSet
    {
        update();
        
        var updated:Boolean = buildLabelCache();
        if (updated)
        {           
            _labelSet = new AxisLabelSet();
            _labelSet.labels = labelCache;
            _labelSet.accurate = _cachedValuesHaveBounds == false;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = ticks;
        } 

        return _labelSet;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#preferDropLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function preferDropLabels():Boolean
    {
        return true;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#getLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getLabels(minimumAxisLength:Number):AxisLabelSet
    {
        var updated:Boolean;
        if (_cachedValuesHaveBounds || !labelCache)
        {
            _regenerateAutoValues = true;       
            updateCache(true,minimumAxisLength);
            updated = buildLabelCache();
        }
        else
        {
            updated = false;
        }
    
        if (updated)
        {
            _labelSet = new AxisLabelSet();
            _labelSet.labels =  labelCache;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = ticks;
        }

        return _labelSet;
    }

    /**
     *  @copy mx.charts.chartClasses.IAxis#reduceLabels()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function reduceLabels(intervalStart:AxisLabel,
                                 intervalEnd:AxisLabel):AxisLabelSet
    {
        return _labelSet;
    }

    /**
     *  Populates the <code>labelCache</code> property with labels representing the current 
     *  values of the axis. Subclasses must implement this function. This function is called 
     *  many times, so you should check to see if the <code>labelCache</code> property 
     *  is <code>null</code> before performing any calculations.
     *  
     *  @return true if the labels were regenerated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function buildLabelCache():Boolean
    {
        return false;
    }

    /**
     *  Builds an Array of positions for the minor tick marks Array that is generated by this axis.  
     *  Subclasses must implement this function. This function is  called automatically 
     *  by the NumericAxis. You should access the <code>minorTicks</code> property 
     *  instead of calling this function directly.
     *  
     *  @return An Array of positions from 0 to 1 that represent points between the axis 
     *  minimum and maximum values where minor tick marks are rendered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function buildMinorTickCache():Array /* of Number */
    {
        return [];
    }

    /**
    * @private
     */
    private function updateCache(checkForMargins:Boolean,
                                   minimumAxisLength:Number):void
    {
        if (_regenerateAutoValues)
        {
            // We're going to remember these.
            // As an optimization, if after going through all of this
            // the values that generate our labels haven't changed,
            // we won't bother regenerating the labels.
            var oldMin:Number = computedMinimum;
            var oldMax:Number = computedMaximum;
            var oldInterval:Number = computedInterval;
            
            // First we check and see if the author has provided
            // any set min/max values.
            if (!isNaN(assignedMinimum))
                computedMinimum = assignedMinimum;
            if (!isNaN(assignedMaximum))
                computedMaximum = assignedMaximum;
                
            // If either min or max is unset, we need to generate it.
            var autoGen:Boolean = isNaN(assignedMinimum) ||
                                  isNaN(assignedMaximum);
            
            // If we still need either a min or a max, we'll autogenerate here.
            if (autoGen)
                autoGenerate(checkForMargins, minimumAxisLength);

            // At this point we know we've got a valid min/max pair,
            // either specified by the author or generated from the data.
            // Next, we go into our adjustment routine.
            // This is where we push those min/max values out to be nice,
            // clean values that look good when you make labels out of them.
            // The same algorithm is also how we generate a nice usable interval
            // from the min/max values we have.so we're going to execute
            // this section if either the user has asked us to autoadjust
            // the min/max to nice clean values, or if the interval hasn't
            // been set by the user.
            // Once we've invoked the routine, we'll decide what we want
            // to do with the numbers it generated based on why the routine
            // got called in the first place.
            adjustMinMax(computedMinimum,computedMaximum);
        
            // OK, we've now calculated the ideal min/max values
            // to show on the chart.
            // However, there may be reasons we want to make the actual range
            // of the chart spread a little bit further.
            // Specifically, if there are series that need a little extra space
            // around their data points, either for labels, or just pretty
            // drawing,or other reasons (like BubbleSeries which render more
            // than one axis in each dimension).
            // But whatever the final range ends up being, we'll use
            // the min/max values we have now as the outer labels of the chart.
            labelMinimum = computedMinimum;
            labelMaximum = computedMaximum;
            
            // When do we adjust for margins?
            // In general, it's if we autogenerated our min/max values
            // and the user has asked us to make nice clean numbers around them.
            // We also have two optimizations in here.
            // First of all, if we auto generated our min/max from data
            // and found that none of our data needed any space around
            // their values, then this would be wasted effort.
            // Secondly, there are times this function gets called
            // when we're looking for an estimate...so we don't want to bother
            // with margins at that point.
            if ((autoAdjust || autoGen) &&
                checkForMargins &&
                _cachedValuesHaveBounds)    
            {       
                adjustForMargins(minimumAxisLength);
            }
            
            // If the author asked for additional padding outside
            // the min/max values, give it to them here.
            // However, it's possible that our margin calculations
            // have already generated more padding than was requested.
            // In which case we don't add more.
            var us:Number = unitSize;
            if (!isNaN(_padding))
            {
                if (labelMinimum - computedMinimum < _padding * us)
                    computedMinimum = labelMinimum - _padding * us;
                
                if (computedMaximum - labelMaximum < _padding * us)
                    computedMaximum = labelMaximum + _padding * us;
            }

            // Authors don't get all the fun...
            // series can ask for padding too. 
            // Check and see if any series have asked for padding,
            // and do the same calculation for them.
            var cachedDataDescriptions:Array /* of DataDescription */ = dataDescriptions;
            var n:int = cachedDataDescriptions.length;
            for (var i:int = 0; i < n; i++) 
            {
                var desc:DataDescription =  cachedDataDescriptions[i]
                if (!isNaN(desc.padding))
                {
                    if (isNaN(assignedMinimum) &&
                        desc.min - computedMinimum < desc.padding * us)
                    {
                        computedMinimum = desc.min - desc.padding * us;
                    }
                    
                    if (isNaN(assignedMaximum) &&
                        computedMaximum - desc.max < desc.padding * us)
                    {
                        computedMaximum = desc.max + desc.padding * us;
                    }
                }
            }

            if (computedMinimum == computedMaximum)
            {
                var us2:Number = unitSize/2;
                computedMinimum -= us2;
                computedMaximum += us2;
            }

            // Finally, if the min/max/interval has changed, invalidate it here.
            if (oldMin != computedMinimum ||
                oldMax != computedMaximum ||
                oldInterval != computedInterval)
            {
                labelCache = null;
                minorTickCache = null;
            }

            _regenerateAutoValues = false;
        }
    }

    /**
     *  Invalidates the cached labels and tick marks that represent this axis's values. 
     *  Derived classes should call this function whenever values used in the calculation 
     *  of labels and tick marks change.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateCache():void
    {
        minorTickCache = null;
        _regenerateAutoValues = true;           
        labelCache = null;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function update():void
    {
        updateCache(true, 0);
    }

    /**
     *  @private
     */
    private function adjustForMargins(minimumAxisLength:Number):void
    {
        // Make sure we have room for bounded values.
        // These are values that specify required padding in screen space
        // (i.e., a bar chart will specify space for its label,
        // in screen space).
        // This is imperfect, because by necessity at this point we don't know
        // how much space we'll really have on the axis.
        // But if we calc now, and the axis gets smaller (it won't get bigger)
        // we'll be conservative but safe.
        
        var min:Number = computedMinimum;
        var max:Number = computedMaximum;

        var n:int;
        var i:int;

        var boundedValues:Array /* of BoundedValue */ = [];
        var cachedDataDescriptions:Array /* of DataDescription */ = dataDescriptions;
        var boundsWithinRegion:Boolean = true;
        n = cachedDataDescriptions.length;
        for (i = 0; i < n; i++)
        {
            if (cachedDataDescriptions[i].boundedValues)
            {
                boundedValues = boundedValues.concat(
                    cachedDataDescriptions[i].boundedValues);
            }
        }
        n = boundedValues.length;
        for (i = 0; i < n; i++)
        {
            if (!(boundedValues[i].lowerMargin < minimumAxisLength && boundedValues[i].upperMargin < minimumAxisLength))
                    boundsWithinRegion = false;
        }
                
        if (boundedValues.length > 0 && minimumAxisLength > 0 && boundsWithinRegion)
        {
            if (isNaN(min))
                min = boundedValues[0].value;
            if (isNaN(max))
                max = boundedValues[0].value;

            var axisLength:Number = minimumAxisLength;
            var currentRange:Number = max - min;
            var itrCount:int = 0;
            n = boundedValues.length;
            
            var verify:Boolean = true;
            while (verify)
            {
                var lowestOverlap:Number = minimumAxisLength;
                var lowestValue:BoundedValue;
                var highestOverlap:Number = 0;
                var highestValue:BoundedValue;

                var v1:Number = max;
                var m1:Number = 0;
                var v2:Number = min;
                var m2:Number = 0;

                for (i = 0; i < n; i++)
                {
                    var v:BoundedValue = boundedValues[i];
                    
                    var vpos:Number =
                        (v.value - min) / currentRange * minimumAxisLength;
                    
                    if ((!isNaN(v.lowerMargin)) &&
                        vpos - v.lowerMargin < lowestOverlap)
                    {
                        lowestOverlap = vpos - v.lowerMargin;
                        lowestValue = v;
                    }
                    
                    if ((!isNaN(v.upperMargin)) &&
                        vpos + v.upperMargin> highestOverlap)
                    {
                        highestOverlap = vpos + v.upperMargin;
                        highestValue = v;
                    }
                }

                if (lowestOverlap > -0.0001 &&
                    highestOverlap < minimumAxisLength + 0.0001)
                {
                    break;
                }

                if (highestOverlap > minimumAxisLength)
                {
                    v1 = highestValue.value;
                    m1 = highestValue.upperMargin;
                }
                else
                {
                    // If we're only adjusting one side of the equation,
                    // we know we're 100% accurate.
                    verify = false;
                }

                if (lowestOverlap < 0)
                {
                    v2 = lowestValue.value;
                    m2 = lowestValue.lowerMargin;
                }
                else
                {
                    // If we're only adjusting one side of the equation,
                    // we know we're 100% accurate.
                    verify = false;
                }

                var p1:Number = minimumAxisLength - m1;
                min = (p1 * v2 - m2 * v1) / Math.abs(p1 - m2);
                max = minimumAxisLength * (v1 - min) /
                      (minimumAxisLength - m1) + min;
                currentRange = max - min;

                if (itrCount++ == 3)
                    break;
            }
        }

        var adjusted:Array /* of Number */ = guardMinMax(min, max);
        if (adjusted)
        {
            min = adjusted[0];
            max = adjusted[1];  
        }

        if (isNaN(assignedMinimum))
            computedMinimum = min;
        if (isNaN(assignedMaximum))
            computedMaximum = max;
    }

    /**
     *  An Array of DataDescription structures describing the data being represented by the chart.
     *  An axis can use this property to generate values for properties, such as its range.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get dataDescriptions():Array /* of DataDescription */
    {
        if (!_cachedDataDescriptions)
        {
            _cachedDataDescriptions = describeData(requiredDescribedFields);
            _cachedValuesHaveBounds = false;            
        }
        return _cachedDataDescriptions;
    }

    /**
     *  @private
     */
    private function autoGenerate(checkForMargins:Boolean,
                                    minimumAxisLength:Number):void
    {
        
        var min:Number;
        var max:Number;
        var v:Object;
		
        var cachedDataDescriptions:Array /* of DataDescription */ = this.dataDescriptions;
        
        if (autoAdjust && baseAtZero)
        {
        	if(direction == "inverted")
        		max = zeroValue;
        	else
            	min = zeroValue;
        }
        
        var n:int = cachedDataDescriptions.length;
        var val:Number;
            
        if (n > 0)
        {
			var temp:int;
        	if(direction == "inverted")
        	{
           		min = (cachedDataDescriptions[0].min);
				if(!isNaN(max) && min > max)	//if min > max, swap them
				{
					temp = max;
					max = min;
					min = temp;
				}
            	if (isNaN(max))
            		max = (cachedDataDescriptions[0].max);
            	else if (!isNaN(cachedDataDescriptions[0].max))
            		max = Math.max(max, (cachedDataDescriptions[0].max));
         	}
         	else
         	{
         		max = (cachedDataDescriptions[0].max);
				if(!isNaN(min) && min > max)	//if min > max, swap them
				{
					temp = max;
					max = min;
					min = temp;
				}
             	if (isNaN(min))
            		min = (cachedDataDescriptions[0].min);
            	else if (!isNaN(cachedDataDescriptions[0].min))
            		min = Math.min(min, (cachedDataDescriptions[0].min));
         	}
            for (var i:int = 0; i < n; i++)
            {
                var desc:DataDescription = cachedDataDescriptions[i];
                if (isNaN(min))
                    min = desc.min;
                else if (!isNaN(desc.min))
                    min = Math.min(min,desc.min);
                if (isNaN(max))
                    max= desc.max;
                else if (!isNaN(desc.max))
                    max = Math.max(max,desc.max);

                _cachedValuesHaveBounds = _cachedValuesHaveBounds ||
                    (desc.boundedValues &&
                     desc.boundedValues.length > 0);
            }

        }

		var adjusted:Array /* of Number */ = guardMinMax(min,max);

        if (adjusted)
        {
            min = adjusted[0];
            max = adjusted[1];  
        }

        if (isNaN(assignedMinimum))
            computedMinimum = min;
        if (isNaN(assignedMaximum))
            computedMaximum = max;
    }

    /**
     *  Adjusts the generated or assigned range of the axis's labels. 
     *  This method is called during the update cycle of the axis. Subclasses can override this method 
     *  to do special processing on the values. By default, no adjustments are made to the range.
     *  
     *  @param minValue The computed minimum value.
     *  @param maxValue The computed maximum value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function adjustMinMax(minValue:Number,
                                    maxValue:Number):void
    {
    }


    /**
     *  Protects the range against invalid values for this axis type. 
     *  This function is called during the update cycle of the axis to guarantee that invalid 
     *  ranges are not generated. Subclasses can override this class and define logic that 
     *  is appropriate to their axis type.
     *  
     *  @param min The computed minimum value.
     *  @param max The computed maximum value.
     *  
     *  @return null if no adjustment is necessary, or an Array containing the adjusted 
     *  values of the form <code>[min,max]</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function guardMinMax(min:Number, max:Number):Array /* of Number */
    {
        if (isNaN(min) || !isFinite(min))
            return [ 0, 100 ];

        else if (isNaN(max) || !isFinite(max) || min == max)
            return [ min, min + 100 ];

        return null;
    }
    
    /**
     *  @private
     */
     mx_internal function getSortOrder():Boolean
     {
        return computedMinimum < computedMaximum
     }
}

}
