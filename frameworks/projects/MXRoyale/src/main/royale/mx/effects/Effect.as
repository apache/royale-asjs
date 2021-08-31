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
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import mx.events.EffectEvent;
import mx.effects.effectClasses.PropertyChanges;

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
	
	public var propertyChangesArray:Array; 
	private var _instances:Array /* of EffectInstance */ = [];
	private var effectStopped:Boolean;
	public var filterObject:EffectTargetFilter;
	public var startDelay:int = 0;
   
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    /**
     *  This method is called when the effect instance starts playing. 
     *  If you override this method, ensure that you call the super method. 
     *
     *  @param event An event object of type EffectEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function effectStartHandler(event:EffectEvent):void 
    {
	dispatchEvent(event);
    }
    /**
     *  Called when an effect instance has stopped by a call
     *  to the <code>stop()</code> method. 
     *  If you override this method, ensure that you call the super method.
     *
     *  @param event An event object of type EffectEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function effectStopHandler(event:EffectEvent):void
    {
        dispatchEvent(event);
        // We use this event to determine whether we should set final
        // state values in the ensuing endHandler() call
        effectStopped = true;
    }
    
    /**
     *  Called when an effect instance has finished playing. 
     *  If you override this method, ensure that you call the super method.
     *
     *  @param event An event object of type EffectEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     protected function effectEndHandler(event:EffectEvent):void 
    {
       /* if (playReversed && propertyChangesArray != null)
        {
            for (var j:int = 0; j < propertyChangesArray.length; ++j)
            {
                var tmpStart:Object = propertyChangesArray[j].start;
                propertyChangesArray[j].start = propertyChangesArray[j].end;
                propertyChangesArray[j].end = tmpStart;
            }
        }
        var lastTime:Boolean = !_instances || _instances.length == 1;
        // Transitions should set the end values when done
        if (applyEndValuesWhenDone && !effectStopped && lastTime)   
            applyEndValues(propertyChangesArray, targets);
        var instance:IEffectInstance = IEffectInstance(event.effectInstance);
        
        deleteInstance(instance);
        
        dispatchEvent(event);
        
        if (lastTime)
        {
            propertyChangesArray = null;
            applyEndValuesWhenDone = false;    
        }  */
		dispatchEvent(event);
    }

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
	
	this.target = target;
        
    }
	public function end(effectInstance:IEffectInstance = null):void
    {
    }
    
    public function createInstances(targets:Array = null):Array /* of EffectInstance */
    {
        if (!targets)
            //targets = this.targets;
            
        var newInstances:Array = [];
        
        // Multiple target support
        var n:int = targets.length;
        var offsetDelay:Number = 0;
        
        for (var i:int = 0; i < n; i++) 
        {
            var newInstance:IEffectInstance = createInstance(targets[i]);
            
            if (newInstance)
            {
                newInstance.startDelay += offsetDelay;
                offsetDelay += perElementOffset;
                newInstances.push(newInstance);
            }
        }
        
        triggerEvent = null;
        
        return newInstances; 
    }
     //public function createInstance(effect:mx.effects.Effect):IEffectInstance
	public function createInstance(target:Object = null):IEffectInstance
    {
	    if (!target)
            //target = this.target;
        
        var newInstance:IEffectInstance = null;
        var props:PropertyChanges = null;
        var create:Boolean = true;
        var setPropsArray:Boolean = false;
                
        if (propertyChangesArray)
        {
            setPropsArray = true;
            create = filterInstance(propertyChangesArray,
                                    target);    
        }
         
        if (create) 
        {
            newInstance = IEffectInstance(new instanceClass(target));
            
            initInstance(newInstance);
            
            if (setPropsArray)
            {
                var n:int = propertyChangesArray.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (propertyChangesArray[i].target == target)
                    {
                        newInstance.propertyChanges =
                            propertyChangesArray[i];
                    }
                }
            }
                
            EventDispatcher(newInstance).addEventListener(EffectEvent.EFFECT_START, effectStartHandler); 
	    EventDispatcher(newInstance).addEventListener(EffectEvent.EFFECT_STOP, effectStopHandler);
            EventDispatcher(newInstance).addEventListener(EffectEvent.EFFECT_END, effectEndHandler);
            
            _instances.push(newInstance);
            
            if (triggerEvent)
                newInstance.initEffect(triggerEvent);
        }
        
        return newInstance;
        //return null;
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
	//not implemented
	public function get isPlaying():Boolean { return false; }



  
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
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------
    /**
     *  @private
     *  Storage for the triggerEvent property.
     */
    private var _triggerEvent:Event;
    
    /**
     *  @copy mx.effects.IEffect#triggerEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get triggerEvent():Event
    {
        return _triggerEvent;
    }
    
    /**
     *  @private
     */
    public function set triggerEvent(value:Event):void
    {
        _triggerEvent = value;
    }
	protected function filterInstance(propChanges:Array, target:Object):Boolean 
    {
        if (filterObject)
            return filterObject.filterInstance(propChanges, effectTargetHost, target);
        
        return true;
    }
	
    //----------------------------------
    //  effectTargetHost
    //----------------------------------
    /**
     *  @private
     *  Storage for the effectTargetHost property.
     */
    private var _effectTargetHost:IEffectTargetHost;
    
    /**
     *  @copy mx.effects.IEffect#effectTargetHost
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get effectTargetHost():IEffectTargetHost
    {
        return _effectTargetHost;
    }
    /**
     *  @private 
     */
    public function set effectTargetHost(value:IEffectTargetHost):void
    {
        _effectTargetHost = value;
    }
	
    //----------------------------------
    //  perElementOffset
    //----------------------------------
    /**
     *  @private
     *  Storage for the perElementOffset property.
     */
    private var _perElementOffset:Number = 0;
    [Inspectable(defaultValue="0", category="General", verbose="0", minValue="0.0")]
    /**
     *  @copy mx.effects.IEffect#perElementOffset
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function get perElementOffset():Number
    {
        return _perElementOffset;
    }
    /**
     *  @private
     */
    public function set perElementOffset(value:Number):void
    {
        _perElementOffset = value;
    }
}

}
