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

/* import flash.events.Event;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.NumericAxis;
import mx.core.mx_internal;

use namespace mx_internal; */
 import org.apache.royale.events.Event;
 import org.apache.royale.events.EventDispatcher;

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
public class LinearAxis  extends org.apache.royale.events.EventDispatcher
{
//extends NumericAxis 
    //include "../core/Version.as";

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
	
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------


	 //----------------------------------
    //  baseAtZero copied from NumericAxis
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
            
       // dataChanged();      
    }
	 
	 
	//formatForScreen copied from NumericAxis
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
    	/* if(direction == "inverted")
    		value = -(Number(value)) as Object;
    	else
    		value = Number(value) as Object; */
        return value.toString();
    }

	//----------------------------------
    //  labelFunction copied from NumericAxis
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

      /*   invalidateCache(); */

        dispatchEvent(new Event("mappingChange"));
        dispatchEvent(new Event("axisChange")); 
    }
	
	//----------------------------------
    //  title copied from AxisBase
    //----------------------------------

    /**
     *  @private
     *  Storage for the title property.
     */
    private var _title:String = "";

    [Inspectable(category="General")]
    
    /**
     *  @copy mx.charts.chartClasses.IAxis#title
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get title():String
    {
        return _title;
    }
    
    /**
     *  @private
     */
    public function set title(value:String):void
    {
        dispatchEvent(new Event("titleChange"));

        _title = value;
    }
}

}
