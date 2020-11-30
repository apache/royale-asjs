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

package spark.effects.animation
{
import spark.effects.interpolation.MultiValueInterpolator;
    
    
/**
 *  The SimpleMotionPath class specifies the name of a property, and the values that
 *  that property takes over time, for instances of the Animate
 *  effect. 
 * 
 *  <p>This class is a simple subclass of MotionPath for defining 
 *  two keyframes to hold the <code>valueFrom</code>, <code>valueTo</code>, and
 *  <code>valueBy</code> properties. 
 *  The MotionPath class itself can define any number of keyframes.</p>
 *
 *  @see MotionPath
 *
 *  @includeExample examples/SimpleMotionPathEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SimpleMotionPath extends MotionPath
{
 
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. You can specify both the 
     *  <code>valueFrom</code> and <code>valueTo</code> parameters, 
     *  or specify the <code>valueBy</code> parameter and either the <code>valueFrom</code> 
     *  or <code>valueTo</code> parameter. 
     *  If you omit these parameters, Flex calculates them from the effect target.
     * 
     *  @param property The name of the property being animated.
     *
     *  @param valueFrom The initial value of the property.
     *  
     *  @param valueTo The final value of the property.
     *  
     *  @param valueBy An optional parameter that specifies the delta with
     *  which to calculate either the from or to values, if one is omitted. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function SimpleMotionPath(property:String = null, 
        valueFrom:Object = null, valueTo:Object = null, 
        valueBy:Object = null)
    {
        super();
        this.property = property;
        keyframes = new <Keyframe>[new Keyframe(0, valueFrom), 
            new Keyframe(NaN, valueTo, valueBy)];
        if (valueFrom !== null && valueTo !== null &&
            ((valueFrom is Array && valueTo is Array) ||
             (valueFrom is Vector.<Number> && valueTo is Vector.<Number>)))
        {
            if (!multiValueInterpolator)
                multiValueInterpolator = new MultiValueInterpolator();
            interpolator = multiValueInterpolator;
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private static var multiValueInterpolator:MultiValueInterpolator = null;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  The starting value for the property during the animation.
     * 
     *  <p>A value of Null or NaN (in the case of Numbers) specifies that a
     *  value must be determined dynamically at runtime, either by
     *  getting the value from the target property directly or calculating
     *  it if the other value is valid and there is also a valid 
     *  <code>valueBy</code> value supplied.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get valueFrom():Object
    {
        return keyframes[0].value;
    }
    public function set valueFrom(value:Object):void
    {
        keyframes[0].value = value;
    }

    /**
     *  The value that the named property will animate to.
     * 
     *  <p>A value of Null or NaN (in the case of Numbers) element specifies that a
     *  value must be determined dynamically at runtime, either by
     *  getting the value from the target property directly or calculating
     *  it if the other value is valid and there is also a valid <code>valueBy</code>
     *  value supplied.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get valueTo():Object
    {
        return keyframes[keyframes.length -1].value;
    }
    public function set valueTo(value:Object):void
    {
        keyframes[keyframes.length - 1].value = value;
    }

    /**
     *  Optional property which specifies the delta used to calculate
     *  either the <code>valueFrom</code> or <code>valueTo</code> value.
     *  Providing this optional property lets the effect 
     *  calculate the necessary from/to values if either
     *  are not provided or are to be determined dynamically when the animation 
     *  begins.
     * 
     *  <p>The way that the <code>valueBy</code> value is used depends on which of the
     *  other values are set. If neither are set, then the <code>valueFrom</code> 
     *  value is determined from the current property value in the target, 
     *  and the <code>valueTo</code> value is <code>valueFrom + valueBy</code>. 
     *  If one or the other is set, but not both, then
     *  the unset value is calculated by the other value: 
     *  <code>valueTo = valueFrom + valueBy</code> or  
     *  <code>valueFrom = valueTo - valueBy</code>). If both are set, then the
     *  <code>valueBy</code> property is ignored.</p>
     * 
     *  <p>Note that since <code>valueBy</code> is of type
     *  Object, the effect cannot directly calculate the other values
     *  from it. It uses the effect's interpolator
     *  to calculate the values by calling the interpolator's <code>increment()</code> 
     *  and <code>decrement()</code> methods.
     *  If no interpolator is set, then it will use NumberInterpolator by default.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get valueBy():Object
    {
        return keyframes[keyframes.length - 1].valueBy;
    }
    public function set valueBy(value:Object):void
    {
        keyframes[keyframes.length - 1].valueBy = value;
    }

}
}
