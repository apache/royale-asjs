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

package mx.effects.easing
{

/**
 *  The Bounce class defines three easing functions to implement 
 *  bounce motion with Flex effect classes. 
 *
 *  For more information, see http://www.robertpenner.com/profmx.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */  
public class Bounce
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>easeOut()</code> method starts the bounce motion fast, 
     *  and then decelerates motion as it executes. 
     *
     *  @param t Specifies time.
     *
     *  @param b Specifies the initial position of a component.
     *
     *  @param c Specifies the total change in position of the component.
     *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public static function easeOut(t:Number, b:Number,
                                   c:Number, d:Number):Number
    {
        if ((t /= d) < (1 / 2.75))
            return c * (7.5625 * t * t) + b;
        
        else if (t < (2 / 2.75))
            return c * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75) + b;
        
        else if (t < (2.5 / 2.75))
            return c * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375) + b;
        
        else
            return c * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375) + b;
    }

    /**
     *  The <code>easeIn()</code> method starts the bounce motion slowly, 
     *  and then accelerates motion as it executes. 
     *
     *  @param t Specifies time.
     *
     *  @param b Specifies the initial position of a component.
     *
     *  @param c Specifies the total change in position of the component.
     *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public static function easeIn(t:Number, b:Number,
                                  c:Number, d:Number):Number
    {
        return c - easeOut(d - t, 0, c, d) + b;
    }

    /**
     *  The <code>easeInOut()</code> method combines the motion
     *  of the <code>easeIn()</code> and <code>easeOut()</code> methods
     *  to start the bounce motion slowly, accelerate motion, then decelerate. 
     *
     *  @param t Specifies time.
     *
     *  @param b Specifies the initial position of a component.
     *
     *  @param c Specifies the total change in position of the component.
     *
     *  @param d Specifies the duration of the effect, in milliseconds.
     *
     *  @return Number corresponding to the position of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */  
    public static function easeInOut(t:Number, b:Number,
                                     c:Number, d:Number):Number
    {
        if (t < d/2)
            return easeIn(t * 2, 0, c, d) * 0.5 + b;
        else
            return easeOut(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b;
    }
}

}
