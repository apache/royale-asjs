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

import mx.resources.IResourceManager;
import mx.resources.ResourceManager;    

//--------------------------------------
//  Other metadata
//--------------------------------------

[ResourceBundle("sparkEffects")]
    
/**
 *  The MultiValueInterpolator class interpolates each element of Arrays or
 *  Vectors of start and end elements separately, using another interpolator 
 *  to do the interpolation for each element. 
 *  By default, the 
 *  interpolation for each element uses the NumberInterpolator class, but you 
 *  can construct a MultiValueInterpolator instance with a different interpolator.
 *  
 *  @see
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class MultiValueInterpolator implements IInterpolator
{
    
    /**
     *  Constructor. 
     *
     *  @param elementInterpolator The interpolator for each element
     *  of the Array.
     *  If no interpolator is specified, use the NumberInterpolator class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function MultiValueInterpolator(elementInterpolator:IInterpolator = null)
    {
        if (elementInterpolator != null)
            this.elementInterpolator = elementInterpolator;
    }

    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    // The internal per-element interpolator
    private var _elementInterpolator:IInterpolator = NumberInterpolator.getInstance();
    /**
     *  The interpolator for each element of the input Array or Vector. 
     *  A value of null specifies to use the NumberInterpolator class.
     *  
     *  @default NumberInterpolator
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get elementInterpolator():IInterpolator
    {
        return _elementInterpolator;
    }
    /**
     *  @private
     */
    public function set elementInterpolator(value:IInterpolator):void
    {
        _elementInterpolator = value ? 
            value : (NumberInterpolator.getInstance());
    }

    /**
     *  Given an elapsed fraction of an animation, between 0.0 and 1.0,
     *  and start and end values to interpolate, return the interpolated value.
     * 
     *  Interpolation for MultiValueInterpolator consists of running a separate
     *  interpolation on each element of the startValue and endValue
     *  arrays or vectors, returning a new Array or Vector that holds those 
     *  interpolated values. The returned object will be an Array if startValue
     *  and endValue are of type Array, otherwise the returned object will be
     *  of type Vector.
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
        if (startValue.length != endValue.length)
            throw new Error(resourceManager.getString("sparkEffects", "arraysNotOfEqualLength"));
        var returnObject:Object;
        if (startValue is Array)
            returnObject = [];
        else 
            // splice(0,0) seems to be the only way to create a Vector of the
            // same type
            returnObject = startValue.splice(0, 0);
        for (var i:int = 0; i < startValue.length; i++)
            returnObject[i] = _elementInterpolator.interpolate(fraction, 
                startValue[i], endValue[i]);

        return returnObject;
    }
    
    /**
     * @inheritDoc
     * 
     * Incrementing for MultiValueInterpolator consists of running a separate
     * increment operation on each element of the <code>baseValue</code> array,
     * adding the same <code>incrementValue</code> to each one and
     * returning a new Array or Vector that holds those incremented values.
     * The returned object will be an Array if startValue
     * and endValue are of type Array, otherwise the returned object will be
     * of type Vector.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function increment(baseValue:Object, incrementValue:Object):Object
    {
        var returnObject:Object;
        if (baseValue is Array)
            returnObject = [];
        else 
            // splice(0,0) seems to be the only way to create a Vector of the
            // same type
            returnObject = baseValue.splice(0, 0);
        for (var i:int = 0; i < baseValue.length; i++)
            returnObject[i] = _elementInterpolator.increment(
                baseValue[i], incrementValue);

        return returnObject;
    }
    
    /**
     * @inheritDoc
     * 
     * Decrementing for MultiValueInterpolator consists of running a separate
     * decrement operation on each element of the <code>baseValue</code> object,
     * subtracting the same <code>incrementValue</code> from each one and
     * returning a new Array or Vector that holds those decremented values.
     * The returned object will be an Array if startValue
     * and endValue are of type Array, otherwise the returned object will be
     * of type Vector.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function decrement(baseValue:Object, decrementValue:Object):Object
    {
        var returnObject:Object;
        if (baseValue is Array)
            returnObject = [];
        else 
            // splice(0,0) seems to be the only way to create a Vector of the
            // same type
            returnObject = baseValue.splice(0, 0);
        for (var i:int = 0; i < baseValue.length; i++)
            returnObject[i] = _elementInterpolator.decrement(
                baseValue[i], decrementValue);

        return returnObject;
    }
        
}
}
