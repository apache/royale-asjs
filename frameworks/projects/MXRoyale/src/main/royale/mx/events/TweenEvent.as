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

import org.apache.royale.events.Event;

/**
 *  Represents event objects that are specific to Flex tween effects. 
 *  Flex effects dispatch two types of tween events:
 *  <ul>
 *    <li><code>tweenUpdate</code></li>
 *    <li><code>tweenEnd</code></li>
 *  </ul>
 *
 *  @see mx.effects.TweenEffect
 *  @see mx.effects.Tween
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class TweenEvent extends Event
{
//    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  The <code>TweenEvent.TWEEN_END</code> constant defines the value of the 
	 *  event object's <code>type</code> property for a <code>tweenEnd</code> event. 
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
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the 
     *       <code>onTweenEnd()</code> method.</td></tr>
	 *  </table>
	 *
	 *  @see mx.effects.Effect
	 *  @see mx.effects.TweenEffect 
	 *  @see mx.events.EffectEvent
     *  @eventType tweenEnd 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const TWEEN_END:String = "tweenEnd";
	
	/**
	 *  The <code>TweenEvent.TWEEN_START</code> constant defines the value of the 
	 *  event object's <code>type</code> property for a <code>tweenStart</code> event. 
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
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the 
     *       <code>onTweenUpdate()</code> method.</td></tr>
	 *  </table>
	 *
     *  @eventType tweenStart
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const TWEEN_START:String = "tweenStart";
	
	/**
	 *  The <code>TweenEvent.TWEEN_UPDATE</code> constant defines the value of the 
	 *  event object's <code>type</code> property for a <code>tweenUpdate</code> event. 
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
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the 
     *       <code>onTweenUpdate()</code> method.</td></tr>
	 *  </table>
	 *
     *  @eventType tweenUpdate
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const TWEEN_UPDATE:String = "tweenUpdate";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the 
	 *  display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param value For a <code>tweenStart</code> or <code>tweenUpdate</code> event, the value passed to the 
	 *  <code>onTweenUpdate()</code> method; for a <code>tweenEnd</code> event, 
	 *  the value passed to the <code>onTweenEnd()</code> method.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function TweenEvent(type:String, bubbles:Boolean = false,
							   cancelable:Boolean = false,
							   value:Object = null)
	{
		super(type, bubbles, cancelable);
		
		this.value = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
    //  value
    //----------------------------------

	/**
	 *  For a <code>tweenStart</code> or <code>tweenUpdate</code> event, the value passed to the 
	 *  <code>onTweenUpdate()</code> method; for a <code>tweenEnd</code> event, 
	 *  the value passed to the <code>onTweenEnd()</code> method.
	 *
	 *  <p>For the exact value of this property, see the instance class 
	 *  for each tween effect.</p>
	 *
	 *  @see mx.effects.effectClasses.ActionEffectInstance
 	 *  @see mx.effects.effectClasses.BlurInstance
 	 *  @see mx.effects.effectClasses.DissolveInstance
 	 *  @see mx.effects.effectClasses.FadeInstance
 	 *  @see mx.effects.effectClasses.GlowInstance
 	 *  @see mx.effects.effectClasses.MaskEffectInstance
 	 *  @see mx.effects.effectClasses.MoveInstance
 	 *  @see mx.effects.effectClasses.ResizeInstance
 	 *  @see mx.effects.effectClasses.RotateInstance
 	 *  @see mx.effects.effectClasses.ZoomInstance
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var value:Object;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
    COMPILE::SWF { override }
	public function clone():Event
	{
		return new TweenEvent(type, bubbles, cancelable, value);
	}
}

}
