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

import org.apache.royale.effects.Effect;
import mx.core.mx_internal;
use namespace mx_internal;
/**
 *  Effect is the base class for effects in Royale.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 *  @royalesuppresspublicvarwarning
 */

public class Effect extends org.apache.royale.effects.Effect
{
	public var instanceClass:Class = IEffectInstance;
	
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  <p>Starting an effect is usually a three-step process:</p>
     *
     *  <ul>
     *    <li>Create an instance of the effect object
     *    with the <code>new</code> operator.</li>
     *    <li>Set properties on the effect object,
     *    such as <code>duration</code>.</li>
     *    <li>Call the <code>play()</code> method
     *    or assign the effect to a trigger.</li>
     *  </ul>
     *
     *  @param target The Object to animate with this effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function Effect(target:Object = null)
    {
        super();
	
	//this.target = target;
        
    }
	public function end(effectInstance:IEffectInstance = null):void
    {
    }
    
    public function createInstance(effect:mx.effects.Effect):IEffectInstance
    {
        return null;
    }

    
   //--------------------------------------------------------------------------
   //  duration
   //--------------------------------------------------------------------------
	 
  override public function get duration():Number
	  {
	        return super.duration;
	  }
  override public function set duration(value:Number):void
	  {
	        super.duration = value;
	  } 

	// not implemented
	public function set targets(value:Array):void {}
	// not implemented
	public function set target(value:Object):void {}



  
    /**
     *  @copy mx.effects.IEffect#getAffectedProperties()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getAffectedProperties():Array /* of String */
    {
        // Every subclass should override this method.
        return [];
    }

    /**
     *  @private
     *  Storage for the relevantStyles property.
     */
    private var _relevantStyles:Array /* of String */ = [];
        
    /**
     *  @copy mx.effects.IEffect#relevantStyles
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get relevantStyles():Array /* of String */
    {
        return _relevantStyles;
    }

    /**
     *  @private
     */
    public function set relevantStyles(value:Array /* of String */):void
    {
        _relevantStyles = value;
    }

    /**
     *  Copies properties of the effect to the effect instance. 
     *
     *  <p>Flex calls this method from the <code>Effect.createInstance()</code>
     *  method; you do not have to call it yourself. </p>
     *
     *  <p>When you create a custom effect, override this method to 
     *  copy properties from the Effect class to the effect instance class. 
     *  In your override, call <code>super.initInstance()</code>. </p>
     *
     *  @param EffectInstance The effect instance to initialize.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function initInstance(instance:IEffectInstance):void
    {
        //instance.duration = duration;
        //Object(instance).durationExplicitlySet = durationExplicitlySet;
        //instance.effect = this;
        //instance.effectTargetHost = effectTargetHost;
        //instance.hideFocusRing = hideFocusRing;
        //instance.repeatCount = repeatCount;
        //instance.repeatDelay = repeatDelay;
        //instance.startDelay = startDelay;
        //instance.suspendBackgroundProcessing = suspendBackgroundProcessing;
    }
	
    /**
     *  Used internally by the Effect infrastructure.
     *  If <code>captureStartValues()</code> has been called,
     *  then when Flex calls the <code>play()</code> method, it uses this function
     *  to set the targets back to the starting state.
     *  The default behavior is to take the value captured
     *  using the <code>getValueFromTarget()</code> method
     *  and set it directly on the target's property. For example: <pre>
     *  
     *  target[property] = value;</pre>
     *
     *  <p>Only override this method if you need to apply
     *  the captured values in a different way.
     *  Note that style properties of a target are set
     *  using a different mechanism.
     *  Use the <code>relevantStyles</code> property to specify
     *  which style properties to capture and apply. </p>
     *
     *  @param target The effect target.
     *
     *  @param property The target property.
     *
     *  @param value The value of the property. 
     *
     *  @param props Array of Objects, where each Array element contains a 
     *  <code>start</code> and <code>end</code> Object
     *  for the properties that the effect is monitoring. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function applyValueToTarget(target:Object, property:String, 
                                          value:*, props:Object):void
    {
        //if (property in target)
        //{
            //// The "property in target" test only tells if the property exists
            //// in the target, but does not distinguish between read-only and
            //// read-write properties. Put a try/catch around the setter and 
            //// ignore any errors.
            //try
            //{
                //
                //if (applyActualDimensions &&
                    //target is IFlexDisplayObject &&
                    //property == "height")
                //{
                    //target.setActualSize(target.width,value);
                //}
                //else if (applyActualDimensions &&
                         //target is IFlexDisplayObject &&
                         //property == "width")
                //{
                    //target.setActualSize(value,target.height);
                //}
                //else
                //{
                    //target[property] = value;
                //}
            //}
            //catch(e:Error)
            //{
                //// Ignore errors
            //}
        //}
    }

    /**
     *  @private
     *  Used internally to grab the values of the relevant properties
     */
    mx_internal function captureValues(propChanges:Array,
                                       setStartValues:Boolean,
                                       targetsToCapture:Array = null):Array
    {
        //var n:int;
        //var i:int;
        //if (!propChanges)
        //{
            //propChanges = [];
                        //
            //// Create a new PropertyChanges object for the sum of all targets.
            //n = targets.length;
            //for (i = 0; i < n; i++)
                //propChanges.push(new PropertyChanges(targets[i]));
        //}
                    //
        //// Merge Effect.filterProperties and filterObject.filterProperties
        //var effectProps:Array = !filterObject ?
                                //relevantProperties :
                                //mergeArrays(relevantProperties,
                                //filterObject.filterProperties);
        //
        //var valueMap:Object;
        //var target:Object;      
        //var m:int;  
        //var j:int;
        //
        //// For each target, grab the property's value
        //// and put it into the propChanges Array. 
        //// Walk the targets.
        //if (effectProps && effectProps.length > 0)
        //{
            //n = propChanges.length;
            //for (i = 0; i < n; i++)
            //{
                //target = propChanges[i].target;
                //if (targetsToCapture == null || targetsToCapture.length == 0 ||
                    //targetsToCapture.indexOf(target) >= 0)
                //{
                    //valueMap = setStartValues ? propChanges[i].start : propChanges[i].end;
                                            //
                    //// Walk the properties in the target
                    //m = effectProps.length;
                    //for (j = 0; j < m; j++)
                    //{
                        //// Don't clobber values already set
                        //if (valueMap[effectProps[j]] === undefined)
                        //{
                            //valueMap[effectProps[j]] = 
                                //getValueFromTarget(target,effectProps[j]);
                        //}
                    //}
                //}
            //}
        //}
        //
        //var styles:Array = !filterObject ?
                           //relevantStyles :
                           //mergeArrays(relevantStyles,
                           //filterObject.filterStyles);
        //
        //if (styles && styles.length > 0)
        //{         
            //n = propChanges.length;
            //for (i = 0; i < n; i++)
            //{
                //target = propChanges[i].target;
                //if (targetsToCapture == null || targetsToCapture.length == 0 ||
                    //targetsToCapture.indexOf(target) >= 0)
                //{
                    //if (!(target is IStyleClient))
                        //continue;
                        //
                    //valueMap = setStartValues ? propChanges[i].start : propChanges[i].end;
                                            //
                    //// Walk the properties in the target.
                    //m = styles.length;
                    //for (j = 0; j < m; j++)
                    //{
                        //// Don't clobber values set by relevantProperties
                        //if (valueMap[styles[j]] === undefined)
                        //{
                            //var value:* = target.getStyle(styles[j]);
                            //valueMap[styles[j]] = value;
                        //}
                    //}
                //}
            //}
        //}
        //
        //return propChanges;
	return [];
    }
    /**
     *  @private
     *  Applies the start values found in the array of PropertyChanges
     *  to the relevant targets.
     */
    mx_internal function applyStartValues(propChanges:Array,
                                     targets:Array):void
    {
        //var effectProps:Array = relevantProperties;
                    //
        //var n:int = propChanges.length;
        //for (var i:int = 0; i < n; i++)
        //{
            //var m:int;
            //var j:int;
//
            //var target:Object = propChanges[i].target;
            //var apply:Boolean = false;
            //
            //m = targets.length;
            //for (j = 0; j < m; j++)
            //{
                //if (targets[j] == target)
                //{   
                    //apply = filterInstance(propChanges, target);
                    //break;
                //}
            //}
            //
            //if (apply)
            //{
                //// Walk the properties in the target
                //m = effectProps.length;
                //for (j = 0; j < m; j++)
                //{
                    //var propName:String = effectProps[j];
                    //var startVal:* = propChanges[i].start[propName];
                    //var endVal:* = propChanges[i].end[propName];
                    //if (propName in propChanges[i].start &&
                        //endVal != startVal &&
                        //(!(startVal is Number) ||
                         //!(isNaN(endVal) && isNaN(startVal))))
                    //{
                        //applyValueToTarget(target, effectProps[j],
                                //propChanges[i].start[effectProps[j]],
                                //propChanges[i].start);
                    //}
                //}
                //
                //// Walk the styles in the target
                //m = relevantStyles.length;
                //for (j = 0; j < m; j++)
                //{
                    //var styleName:String = relevantStyles[j];
                    //var startStyle:* = propChanges[i].start[styleName];
                    //var endStyle:* = propChanges[i].end[styleName];
                    //if (styleName in propChanges[i].start &&
                        //endStyle != startStyle &&
                        //(!(startStyle is Number) ||
                         //!(isNaN(endStyle) && isNaN(startStyle))) &&
                        //target is IStyleClient)
                    //{
                        //if (propChanges[i].end[relevantStyles[j]] !== undefined)
                            //target.setStyle(relevantStyles[j], propChanges[i].start[relevantStyles[j]]);
                        //else
                            //target.clearStyle(relevantStyles[j]);
                    //}
                //}
            //}
        //}
    }

    /**
     *  @private
     *  Applies the start values found in the array of PropertyChanges
     *  to the relevant targets.
     */
    mx_internal function applyEndValues(propChanges:Array,
                                    targets:Array):void
    {
        //// For now, only new Flex4 effects will apply end values when transitions
        //// are over, to preserve the previous behavior of Flex3 effects
        //if (!applyTransitionEndProperties)
            //return;
            //
        //var effectProps:Array = relevantProperties;
                    //
        //var n:int = propChanges.length;
        //for (var i:int = 0; i < n; i++)
        //{
            //var m:int;
            //var j:int;
//
            //var target:Object = propChanges[i].target;
            //var apply:Boolean = false;
            //
            //m = targets.length;
            //for (j = 0; j < m; j++)
            //{
                //if (targets[j] == target)
                //{   
                    //apply = filterInstance(propChanges, target);
                    //break;
                //}
            //}
            //
            //if (apply)
            //{
                //// Walk the properties in the target
                //m = effectProps.length;
                //for (j = 0; j < m; j++)
                //{
                    //var propName:String = effectProps[j];
                    //var startVal:* = propChanges[i].start[propName];
                    //var endVal:* = propChanges[i].end[propName];
                    //if (propName in propChanges[i].end &&
                        //(!(endVal is Number) ||
                         //!(isNaN(endVal) && isNaN(startVal))))
                    //{
                        //applyValueToTarget(target, propName,
                                //propChanges[i].end[propName],
                                //propChanges[i].end);
                    //}
                //}
                //
                //// Walk the styles in the target
                //m = relevantStyles.length;
                //for (j = 0; j < m; j++)
                //{
                    //var styleName:String = relevantStyles[j];
                    //var startStyle:* = propChanges[i].start[styleName];
                    //var endStyle:* = propChanges[i].end[styleName];
                    //if (styleName in propChanges[i].end &&
                        //(!(endStyle is Number) ||
                         //!(isNaN(endStyle) && isNaN(startStyle))) &&
                        //target is IStyleClient)
                    //{
                        //if (propChanges[i].end[styleName] !== undefined)
                            //target.setStyle(styleName, propChanges[i].end[styleName]);
                        //else
                            //target.clearStyle(styleName);
                    //}
                //}
            //}
        //}
    }
}

}
