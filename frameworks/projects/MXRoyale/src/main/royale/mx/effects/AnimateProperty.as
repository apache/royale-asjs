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

import mx.effects.effectClasses.AnimatePropertyInstance;

/**
 *  The AnimateProperty effect animates a property or style of a component. 
 *  You specify the property name, start value, and end value
 *  of the property to animate. 
 *  The effect sets the property to the start value, and then updates
 *  the property value over the duration of the effect
 *  until it reaches the end value. 
 *
 *  <p>For example, to change the width of a Button control, 
 *  you can specify <code>width</code> as the property to animate, 
 *  and starting and ending width values to the effect.</p> 
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:AnimateProperty&gt;</code> tag
 *  inherits all the tag attributes of its superclass
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:AnimateProperty 
 *    id="ID"
 *	  fromValue="0"
 *    isStyle="false|true"	 
 *    property="<i>required</i>"
 *    roundValue="false|true"
 *    toValue="0" 
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.effects.effectClasses.AnimatePropertyInstance
 *
 *  @includeExample examples/AnimatePropertyEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AnimateProperty extends TweenEffect
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param target The Object to animate with this effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function AnimateProperty(target:Object = null)
	{
		super(target);
		
		instanceClass = AnimatePropertyInstance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  toValue
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]

	/**
	 *  The ending value for the effect.
	 *  The default value is the target's current property value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var toValue:Number;
	
	//----------------------------------
	//  isStyle
	//----------------------------------

	[Inspectable(category="General", defaultValue="false")]

	/**
	 *  If <code>true</code>, the property attribute is a style and you set
	 *  it by using the <code>setStyle()</code> method. 
	 *  @default false
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var isStyle:Boolean = false;

	//----------------------------------
	//  property
	//----------------------------------

	[Inspectable(category="General", defaultValue="")]

	/**
	 *  The name of the property on the target to animate.
	 *  This attribute is required.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var property:String;

	//----------------------------------
	//  roundValue
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="false")]

	/**
	 *  If <code>true</code>, round off the interpolated tweened value
	 *  to the nearest integer. 
	 *  This property is useful if the property you are animating
	 *  is an int or uint.
	 *  @default false
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var roundValue:Boolean = false;

	//----------------------------------
	//  fromValue
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]

	/**
	 *  The starting value of the property for the effect.
	 *  The default value is the target's current property value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var fromValue:Number;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function getAffectedProperties():Array /* of String */
	{
		return [ property ];
	}

	/**
	 *  @private
	 */
	override public function get relevantStyles():Array /* of String */
	{
		return isStyle ? [ property ] : [];
	}
	
	/**
	 *  @private
	 */
	override protected function initInstance(instance:IEffectInstance):void
	{
		super.initInstance(instance);
		
		var animatePropertyInstance:AnimatePropertyInstance =
			AnimatePropertyInstance(instance);

		animatePropertyInstance.fromValue = fromValue;
		animatePropertyInstance.toValue = toValue;
		animatePropertyInstance.property = property;
		animatePropertyInstance.isStyle = isStyle;
		animatePropertyInstance.roundValue = roundValue;
	}
}
	
}
