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

import mx.charts.effects.effectClasses.SeriesSlideInstance;
import mx.effects.IEffectInstance;

/**
 *  The SeriesSlide effect slides a data series
 *  into and out of the chart's boundaries.
 *  You use the <code>direction</code> property
 *  to specify the location from which the series slides.
 *
 *  <p>If you use SeriesSlide with a <code>hideDataEffect</code> effect trigger,
 *  the series slides from the current position onscreen to a position
 *  off of the screen, in the indicated direction.
 *  If you use SeriesSlide as a <code>showDataEffect</code>,
 *  the series slides from offscreen to a position onto the screen,
 *  in the indicated direction.</p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:SeriesSlide&gt;</code> tag
 *  inherits all the properties of its parent classes,
 *  and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:SeriesSlide
 *    <strong>Properties</strong>
 *    direction="<i>left|right|up|down</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SeriesSlideExample.mxml
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SeriesSlide extends SeriesEffect
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
	public function SeriesSlide(target:Object = null)
	{
		super(target);

		instanceClass = SeriesSlideInstance;
	}
   
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

 	//----------------------------------
	//  direction
	//----------------------------------

    private var _direction:String = "left";
    
	[Inspectable(category="General", enumeration="left,right,up,down", defaultValue="left")]

	/**
	 *  Defines the location from which the series slides.
	 *  Valid values are <code>"left"</code>, <code>"right"</code>,
	 *  <code>"up"</code>, and <code>"down"</code>.
	 *  The default value is <code>"left"</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get direction():String
    {
        return _direction;
    }
    public function set direction(value:String):void
    {
        _direction = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
	
	/**
	 *  @inheritDoc
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override protected function initInstance(inst:IEffectInstance):void
	{
		super.initInstance(inst);

		SeriesSlideInstance(inst).direction = direction;
	}
}

}
