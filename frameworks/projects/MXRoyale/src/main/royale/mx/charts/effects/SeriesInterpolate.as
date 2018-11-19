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

package mx.charts.effects
{

import mx.charts.effects.effectClasses.SeriesInterpolateInstance;

/**
 *  The SeriesInterpolate effect moves the graphics that represent
 *  the existing data in a series to the new points.
 *  Instead of clearing the chart and then repopulating it
 *  as with SeriesZoom and SeriesSlide,
 *  this effect keeps the data on the screen at all times.
 *
 *  <p>You only use the SeriesInterpolate effect
 *  with a <code>showDataEffect</code> effect trigger.
 *  It has no effect if set with a <code>hideDataEffect</code>.</p>
 *
 *  @includeExample examples/SeriesInterpolateExample.mxml
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SeriesInterpolate extends SeriesEffect
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
     *  @param target The target of the effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SeriesInterpolate(target:Object = null)
    {
        super(target);

        instanceClass = SeriesInterpolateInstance;
    }
}

}
