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

package mx.events
{

import flash.events.Event;
import mx.effects.IEffectInstance;

/**
 *  Represents event objects that are specific to Flex effects. 
 *  Flex effects dispatch the following types of events:
 *  <ul>
 *    <li><code>effectStart</code></li>
 *    <li><code>effectStop</code></li>
 *    <li><code>effectRepeat</code></li>
 *    <li><code>effectEnd</code></li>
 *    <li><code>effectRepeat</code></li>
 *  </ul>
 *
 *  @see mx.effects.Effect
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class EffectEvent extends Event
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

    /**
     *  The <code>EffectEvent.EFFECT_END</code> constant defines the value of the 
     *  <code>type</code> property of the event object for an 
     *  <code>effectEnd</code> event. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
     *       for the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @see mx.effects.Effect
     *
     *  @eventType effectEnd
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const EFFECT_END:String = "effectEnd";
    
    /**
     *  The <code>EffectEvent.EFFECT_STOP</code> constant defines the value of the 
     *  <code>type</code> property of the event object for an 
     *  <code>effectStop</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
     *       for the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @see mx.effects.Effect
     *
     *  @eventType effectStop
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const EFFECT_STOP:String = "effectStop";
    
	/**
     *  The <code>EffectEvent.EFFECT_START</code> constant defines the value of the 
     *  <code>type</code> property of the event object for an 
     *  <code>effectStart</code> event. 
     *  
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
     *       for the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
	 *  @see mx.effects.Effect
     *
     *  @eventType effectStart
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const EFFECT_START:String = "effectStart";
	
    /**
     *  The <code>EffectEvent.EFFECT_REPEAT</code> constant defines the value of the 
     *  <code>type</code> property of the event object for an 
     *  <code>effectRepeat</code> event. 
     *  
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
     *       for the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @see mx.effects.Effect
     *
     *  @eventType effectRepeat
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const EFFECT_REPEAT:String = "effectRepeat";

    /**
     *  The <code>EffectEvent.EFFECT_UPDATE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for an 
     *  <code>effectUpdate</code> event. 
     *  
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>effectInstance</code></td><td>The effect instance object 
     *       for the event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @see mx.effects.Effect
     *
     *  @eventType effectUpdate
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const EFFECT_UPDATE:String = "effectUpdate";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param eventType The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the 
	 *  display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param effectInstance The effect instance that triggered the event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function EffectEvent(eventType:String, bubbles:Boolean = false,
								cancelable:Boolean = false,
								effectInstance:IEffectInstance = null)
	{
		super(eventType, bubbles, cancelable);

		this.effectInstance = effectInstance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  effectInstance
	//----------------------------------
	
	/**
	 *  The effect instance object for the event.
	 *  You can use this property to access the properties of the effect
	 *  instance object from within your event listener.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var effectInstance:IEffectInstance;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	override public function clone():Event
	{
		return new EffectEvent(type, bubbles, cancelable, effectInstance);
	}
}

}
