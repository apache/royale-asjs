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

//import flash.events.Event;
//import flash.events.EventDispatcher;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
	
//import mx.charts.LinearAxis;
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the transformation from data space to screen space
 *  has changed, typically either because the axes that make up
 *  the transformation have changed in some way,
 *  or the data transform itself has size.
 *
 *  @eventType mx.events.FlexEvent.TRANSFORM_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="transformChange", type="mx.events.FlexEvent")]

/**
 *  The DataTransform object represents a portion of a chart
 *  that contains glyphs and can transform values
 *  to screen coordinates and vice versa.
 *  Each DataTransform object has a horizontal axis, a vertical axis,
 *  and a set of glyphs (background, data, and overlay) to render.  
 *  
 *  <p>In theory, a chart can contain multiple overlaid DataTransform objects.
 *  This allows you to display a chart with multiple data sets
 *  rendered in the same area but with different ranges.
 *  For example, you might want to show monthly revenues
 *  compared to the number of units sold. 
 *  If revenue was typically in millions while units was typically
 *  in the thousands, it would be difficult to render these effectively
 *  along the same range.
 *  Overlaying them in different DataTransform objects allows
 *  the end user to compare trends in the values
 *  when they are rendered with different ranges.</p>
 *
 *  <p>Charts can only contain one set of DataTransform.</p>
 *  
 *  <p>Most of the time, you will use the ChartBase object,
 *  which hides the existance of the DataTransform object
 *  between the chart and its contained glyphs and axis objects.
 *  If you create your own ChartElement objects, you must understand
 *  the methods of the DataTransform class to correctly implement their element.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class DataTransform extends org.apache.royale.events.EventDispatcher
{
/*     include "../../core/Version.as";
 */
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
    public function DataTransform()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
	//----------------------------------
    //  axes
    //----------------------------------

    /**
     *  @private
     *  Storage for the axes property.
     */
    private var _axes:Object = {};
    
    [Inspectable(environment="none")]

    /**
     *  The set of axes associated with this transform.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get axes():Object
    {
        return _axes;
    }

    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    
    /**
     *  Retrieves the axis instance responsible for transforming
     *  the data dimension specified by the <code>dimension</code> parameter.
     *  If no axis has been previously assigned, a default axis is created.
     *  The default axis for all dimensions is a LinearAxis
     *  with the <code>autoAdjust</code> property set to <code>false</code>. 
     *
     *  @param dimension The dimension whose axis is responsible
     *  for transforming the data.
     *  
     *  @return The axis instance.
     *  
     *  @see mx.charts.LinearAxis
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function getAxis(dimension:String):Object //IAxis
    {
        if (!(_axes[dimension]))
        {
          //  var newAxis:LinearAxis = new LinearAxis();
          //  newAxis.autoAdjust = false;
          //  setAxisNoEvent(dimension,newAxis);
        }

        return _axes[dimension];
    }

   
}

}
