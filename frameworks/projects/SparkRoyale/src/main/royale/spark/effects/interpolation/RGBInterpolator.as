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
package spark.effects.interpolation
{
/**
 *  The RGBInterpolator class provides interpolation between 
 *  <code>uint</code> start and end values that represent RGB colors. 
 *  Interpolation is done by treating
 *  the start and end values as integers with color channel information in
 *  the least-significant 3 bytes, and then interpolating each of the channels
 *  separately.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class RGBInterpolator implements IInterpolator
{   
    private static var theInstance:RGBInterpolator;
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function RGBInterpolator()
    {
        super();
    }
   
    /**
     *  Returns the singleton of this class. Since all RGBInterpolators
     *  have the same behavior, there is no need for more than one instance.
     *
     *  @return The singleton of this class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function getInstance():RGBInterpolator
    {
        if (!theInstance)
            theInstance = new RGBInterpolator();
        return theInstance;
    }

    /**
     *  Interpolation for the RGBInterpolator class takes the form of parametric
     *  calculations on each of the bottom three bytes of 
     *  <code>startValue</code> and <code>endValue</code>. 
     * 
     *  @param fraction The fraction elapsed of the 
     *  animation, between 0.0 and 1.0.
     *
     *  @param startValue The start value of the interpolation.
     *
     *  @param endValue The end value of the interpolation.
     *
     *  @return The interpolated value.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function interpolate(fraction:Number, startValue:Object, 
        endValue:Object):Object
    {
        // Quick test for start or end
        if (fraction == 0)
            return startValue;
        else if (fraction == 1)
            return endValue;
        var startR:int;
        var startG:int;
        var startB:int;
        var endR:int;
        var endG:int;
        var endB:int;
        var deltaR:int;
        var deltaG:int;
        var deltaB:int;
        fraction = Math.min(1, Math.max(0, fraction));
        startR = (uint(startValue) & 0xff0000) >> 16;
        startG = (uint(startValue) & 0xff00) >> 8;
        startB = uint(startValue) & 0xff;
        endR = (uint(endValue) & 0xff0000) >> 16;
        endG = (uint(endValue) & 0xff00) >> 8;
        endB = uint(endValue) & 0xff;
        deltaR = endR - startR;
        deltaG = endG - startG;
        deltaB = endB - startB;
        var newR:uint = startR + deltaR * fraction;
        var newG:uint = startG + deltaG * fraction;
        var newB:uint = startB + deltaB * fraction;
        return newR << 16 | newG << 8 | newB;
    }

    /**
     * @private
     * 
     * Utility function called by increment() and decrement()
     */
    private function combine(baseValue:uint, deltaValue:uint,
        increment:Boolean):Object
    {
        var baseR:int = (baseValue & 0xff0000) >> 16;
        var baseG:int = (baseValue & 0xff00) >> 8;
        var baseB:int = baseValue & 0xff;
        var deltaR:int = (deltaValue & 0xff0000) >> 16;
        var deltaG:int = (deltaValue & 0xff00) >> 8;
        var deltaB:int = deltaValue & 0xff;
        var newR:uint, newG:uint, newB:uint;
        if (increment)
        {
            newR = Math.min(baseR + deltaR, 255);
            newG = Math.min(baseG + deltaG, 255);
            newB = Math.min(baseB + deltaB, 255);
        }
        else
        {
            newR = Math.max(baseR - deltaR, 0);
            newG = Math.max(baseG - deltaG, 0);
            newB = Math.max(baseB - deltaB, 0);
        }
        return newR << 16 | newG << 8 | newB;
    }

    /**
     *  Returns the result of the two values added
     *  together on a per-channel basis. Each channel has a maximum 
     *  value of 255 to avoid overflow problems.
     *
     *  @param baseValue The start value of the interpolation.
     *
     *  @param incrementValue The change to apply to the <code>baseValue</code>.
     *
     *  @return The interpolated value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function increment(baseValue:Object, incrementValue:Object):Object
    {
        return combine(uint(baseValue), uint(incrementValue), true);
    }

    /**
     *  Returns the result of the two values subtracted
     *  on a per-channel basis. Each channel has a minimum
     *  value of 0 to avoid underflow problems.
     *
     *  @param baseValue The start value of the interpolation.
     *
     *  @param decrementValue The change to apply to the <code>baseValue</code>.
     *
     *  @return The interpolated value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
   public function decrement(baseValue:Object, decrementValue:Object):Object
   {
        return combine(uint(baseValue), uint(decrementValue), false);
   }
}
}
