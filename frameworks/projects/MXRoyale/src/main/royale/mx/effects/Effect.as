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

  


	
}

}
