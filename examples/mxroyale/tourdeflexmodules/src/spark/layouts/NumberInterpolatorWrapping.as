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
package
{
import spark.effects.interpolation.IInterpolator;
    
public class NumberInterpolatorWrapping implements IInterpolator
{
    private var _rangeBegin:Number;
    private var _rangeEnd:Number;
    public function NumberInterpolatorWrapping(rangeBegin:Number, rangeEnd:Number)
    {
        _rangeBegin = rangeBegin;
        _rangeEnd = rangeEnd;
    }
        
    /**
     * Returns the type that an implementor can handle
     */
    public function get interpolatedType():Class
    {
        return Number;
    }
    
    /**
     * Given an elapsed fraction of an animation between 0 and 1,
     * and start and end values, this function returns some value
     * based on whatever interpolation the implementor chooses to
     * provide.
     */
    public function interpolate(fraction:Number, startValue:Object, endValue:Object):Object
    {
        if (fraction == 0)
            return startValue;
        else if (fraction == 1)
            return endValue;
        var start:Number = Number(startValue);
        var end:Number = Number(endValue);

        if (Math.abs(end - start) < Math.abs(_rangeEnd - _rangeBegin) - Math.abs(end - start))
        {
            return start + fraction * (end - start);
        }
        else
        {
            var result:Number;
            if (start < end)
            {
                result = start - fraction * (_rangeEnd - _rangeBegin - Math.abs(start - end));
                if (result < _rangeBegin)
                    result += _rangeEnd - _rangeBegin;
                return result;
            }
            else
            {
                result = start + fraction * (_rangeEnd - _rangeBegin - Math.abs(start - end));
                if (result > _rangeEnd)
                    result -= _rangeEnd - _rangeBegin;
                return result;
            }
        }        
    }
    
    public function increment(baseValue:Object, incrementValue:Object):Object
    {
        var result:Number = Number(baseValue) + Number(incrementValue);
        // This won't handle situations where we're adding more than
        // the range itself, but since this will only be called when
        // the user submits a 'byValue' that large, it seems unlikely
        // at the very least
        if (result > _rangeEnd)
            result = _rangeBegin + (result - _rangeEnd);
        return result;
    }
    
    public function decrement(baseValue:Object, decrementValue:Object):Object
    {
        var result:Number = Number(baseValue) - Number(decrementValue);
        // This won't handle situations where we're subtracting more than
        // the range itself, but since this will only be called when
        // the user submits a 'byValue' that large, it seems unlikely
        // at the very least
        if (result < _rangeBegin)
            result = _rangeEnd + (_rangeBegin - result);
        return result;
    }
    
    public function getLength(startValue:Number, endValue:Number):Number
    {
        return Math.min( Math.abs(startValue - endValue), Math.abs(_rangeEnd - _rangeBegin - Math.abs(startValue - endValue)));
    }   

}
}