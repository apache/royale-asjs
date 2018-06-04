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

/* import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer; 
import mx.effects.effectClasses.PropertyChanges;

*/
import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.utils.Timer;	
import org.apache.royale.core.IEffectTimer;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.ValueEvent;	

import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
/* import mx.utils.NameUtil;
 */
use namespace mx_internal;

/**
 *  The EffectInstance class represents an instance of an effect
 *  playing on a target.
 *  Each target has a separate effect instance associated with it.
 *  An effect instance's lifetime is transitory.
 *  An instance is created when the effect is played on a target
 *  and is destroyed when the effect has finished playing. 
 *  If there are multiple effects playing on a target at the same time 
 *  (for example, a Parallel effect), there is a separate effect instance
 *  for each effect.
 * 
 *  <p>Effect developers must create an instance class
 *  for their custom effects.</p>
 *
 *  @see mx.effects.Effect
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class EffectInstance extends EventDispatcher implements IEffectInstance
{
/*     include "../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target UIComponent object to animate with this effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function EffectInstance(target:Object)
    {
        super();

        this.target = target;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	    
    //----------------------------------
    //  duration
    //----------------------------------

    /**
     *  @private
     *  Storage for the duration property.
     */
    private var _duration:Number = 500;
    
    [Inspectable(category="General", defaultValue="500")]
    
    /** 
     *  @copy mx.effects.IEffectInstance#duration
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get duration():Number
    {
/*         if (!durationExplicitlySet &&
            parentCompositeEffectInstance)
        {
            return parentCompositeEffectInstance.duration;
        }
        else
        { */
            return _duration;
       /*  } */
    }
    
    /**
     *  @private
     */
    public function set duration(value:Number):void
    {
	/*   durationExplicitlySet = true;
	*/
        _duration = value;
    }

   
    
    //----------------------------------
    //  target
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the target property. 
     */
    private var _target:Object;

    /**
     *  @copy mx.effects.IEffectInstance#target
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get target():Object
    {
        return _target;
    }

    /**
     *  @private
     */
    public function set target(value:Object):void
    {
        _target = value;
    }
    
   
            
    /**
     *  @copy mx.effects.IEffectInstance#play()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function play():void
    {
        //playCount++;
        
        dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
        
        if (target && (target is IEventDispatcher))
		{
            target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
		}
    }
    
   
}

}
