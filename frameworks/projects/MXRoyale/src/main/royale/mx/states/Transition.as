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

package mx.states
{

import mx.effects.IEffect;
import org.apache.royale.states.Transition;

[DefaultProperty("effect")]

/**
 *  The Transition class defines a set of effects that play in response
 *  to a change of view state. While a view state definition
 *  defines how to change states, a transition defines the order in which
 *  visual changes occur during the state change.
 *
 *  <p>To define a transition, you set the <code>transitions</code> property of an Application
 *  to an Array of Transition objects. </p>
 *
 *  <p>You use the <code>toState</code> and <code>fromState</code> properties of
 *  the Transition class to specify the state changes that trigger the transition.
 *  By default, both the <code>fromState</code> and <code>toState</code> properties
 *  are set to "&#42;", meaning apply the transition to any changes to the view state.</p>
 *
 *  <p>You can use the <code>fromState</code> property to explicitly specify a
 *  view state that your are changing from, and the <code>toState</code> property
 *  to explicitly specify a view state that you are changing to.
 *  If a state change matches two transitions, the <code>toState</code> property
 *  takes precedence over the <code>fromState</code> property. If more than one
 *  transition match, Flex uses the first definition in the transition array. </p>
 *
 *  <p>You use the <code>effect</code> property to specify the Effect object to play
 *  when you apply the transition. Typically, this is a composite effect object,
 *  such as the Parallel or Sequence effect, that contains multiple effects,
 *  as the following example shows:</p><pre>
 *
 *  &lt;mx:Transition id="myTransition" fromState="&#42;" toState="&#42;"&gt;
 *    &lt;mx:Parallel&gt;
 *        ...
 *    &lt;/mx:Parallel&gt;
 *  &lt;/mx:Transition&gt;
 *  </pre>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Transition&gt;</code> tag
 *  defines the following attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Transition
 *    <b>Properties</b>
 *    id="ID"
 *    effect=""
 *    fromState="&#42;"
 *    toState="&#42;"
 *    autoReverse="false"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.effects.AddChildAction
 *  @see mx.effects.RemoveChildAction
 *  @see mx.effects.SetPropertyAction
 *  @see mx.effects.SetStyleAction
 *
 *  @includeExample examples/TransitionExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Transition extends org.apache.royale.states.Transition
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function Transition()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  effect
    //----------------------------------

    /**
     *  The IEffect object to play when you apply the transition. Typically,
     *  this is a composite effect object, such as the Parallel or Sequence effect,
     *  that contains multiple effects.
     *
     *  <p>The <code>effect</code> property is the default property of the
     *  Transition class. You can omit the <code>&lt;mx:effect&gt;</code> tag 
     *  if you use MXML tag syntax.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     public function set effect(value:IEffect):void
     {
	if (!effects)
	{
		effects = [];
	}
	effects[0] = value;
     }

     public function get effect():IEffect
     {
	return effects && effects.length > 0 ? effects[0] as IEffect : null;
     }

    //----------------------------------
    //  fromState
    //----------------------------------

    //[Inspectable(category="General")]

    /**
     *  A String specifying the view state that your are changing from when
     *  you apply the transition. The default value is "&#42;", meaning any view state.
     *
     *  <p>You can set this property to an empty string, "",
     *  which corresponds to the base view state.</p>
     *
     *  @default "&#42;"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //public var fromState:String = "*";

    //----------------------------------
    //  toState
    //----------------------------------

    //[Inspectable(category="General")]

    /**
     *  A String specifying the view state that you are changing to when
     *  you apply the transition. The default value is "&#42;", meaning any view state.
     *
     *  <p>You can set this property to an empty string, "",
     *  which corresponds to the base view state.</p>
     *
     *  @default "&#42;"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //public var toState:String = "*";
    
    private var _autoReverse:Boolean = false;
    
    /**
     *  Set to <code>true</code> to specify that this transition applies 
     *  to both the forward and reverse view state changes. 
     *  Therefore, use this transition on a change from view state A to 
     *  view state B, and on the change from B to A. 
     *
     *  <p>While the transition from view state A to view state B is playing, 
     *  the reverse transition can occur to interrupt the current transition. 
     *  The reverse transition always halts the current transition at 
     *  its current location. 
     *  That is, the reverse transition always plays as if 
     *  the <code>interruptionBehavior</code> property was set to <code>stop</code>, 
     *  regardless of the real value of <code>interruptionBehavior</code>.</p>
     * 
     *  <p>This property is only checked when the new transition is going in the
     *  exact opposite direction of the currently playing one. That is, if
     *  a transition is playing between states A and B and then a transition
     *  to return to A is started. </p>
     *  
     *  <p>If a transition uses the <code>toState</code> and <code>fromState</code> 
     *  properties to explicitly handle the transition from view state B to A, 
     *  then Flex ignores the <code>autoReverse</code> property. </p>
     * 
     *  @default false 
     *
     *  @see Transition#interruptionBehavior
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get autoReverse():Boolean
    {
        return _autoReverse;
    }
    public function set autoReverse(value:Boolean):void
    {
        _autoReverse = value;
    }
    
    /**
     *  Flex does not support the playing of multiple transitions simultaneously. 
     *  If a transition is currently playing when a new transition occurs, 
     *  the current transition is interrupted. 
     *  This property controls how the current transition behaves when interrupted. 
     *  
     *  <p>By default, the current transition ends, which snaps all effects in 
     *  the transition to their end values. 
     *  This corresponds to a property value of <code>end</code>.
     *  If the value of this property is <code>stop</code>, the current transition 
     *  halts at its current location. 
     *  The new transition start playing from the halt location of 
     *  the previous transition.</p> 
     *
     *  <p>The value of <code>stop</code> can smooth out the appearance of an 
     *  interrupted transition. 
     *  That is because the user does not see the current transition snap 
     *  to its end state before the new transition begins.</p>
     *
     *  <p>In some cases, the interrupting transition can be the reverse of 
     *  the current transition. 
     *  For example, while the transition from view state A to view state B  
     *  is playing, the reverse transition occurs to interrupt the current transition. 
     *  If you set the <code>autoReverse</code> property of a transition instance  
     *  to <code>true</code>, you can use the same transition to handle both 
     *  the forward and reverse transitions.
     *  When the interrupting transition is the reverse transition of the  
     *  current transition and has <code>autoReverse</code> set to <code>true</code>, 
     *  the interrupting transition runs as if the 
     *  <code>interruptionBehavior</code> property was set to <code>stop</code>, 
     *  regardless of the real value of <code>interruptionBehavior</code>.</p>
     *
     *  <p>The mx.states.InterruptionBehavior class defines 
     *  the possible values for this property.</p>
     * 
     *  @default end
     *
     *  @see Transition#autoReverse
     *  @see mx.states.InterruptionBehavior
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    //[Inspectable(category="General", enumeration="end,stop", defaultValue="end")]
    //public var interruptionBehavior:String = InterruptionBehavior.END;
}

}
