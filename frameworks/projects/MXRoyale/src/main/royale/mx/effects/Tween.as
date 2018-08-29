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

package mx.effects
{

import org.apache.royale.effects.Tween;


/**
 *  Tween is the underlying animation class for the effects in Royale.
 *
 *  The Tween class defines a tween, a property animation performed
 *  on a target object over a period of time.
 *  That animation can be a change in position, such as performed by
 *  the Move effect; a change in size, as performed by the Resize or
 *  Zoom effects; a change in visibility, as performed by the Fade or
 *  Dissolve effects; or other types of animations.
 *
 *  <p>A Tween instance accepts the <code>startValue</code>,
 *  <code>endValue</code>, and <code>duration</code> properties,
 *  and an optional easing function to define the animation.</p>
 *
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class Tween extends org.apache.royale.effects.Tween
{
   

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
     *  @productversion Royale 1.0.0
     */
    public function Tween(listener:Object,
                          startValue:Object, endValue:Object,
                          duration:Number = -1, minFps:Number = -1,
                          updateFunction:Function = null,
                          endFunction:Function = null)
    {
		super();
    }

   
}

}
