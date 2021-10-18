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

import mx.effects.effectClasses.RotateInstance;
import mx.effects.TweenEffect;
[Alternative(replacement="spark.effects.Rotate", since="4.0")]

/**
 *  The Rotate effect rotates a component around a specified point. 
 *  You can specify the coordinates of the center of the rotation, 
 *  and the starting and ending angles of rotation. 
 *  You can specify positive or negative values for the angles. 
 *
 *  <p><b>Note:</b> To use the Rotate effect with text,
 *  you must use an embedded font, not a device font.</p> 
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Rotate&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Rotate
 *    id="ID"
 *    angleFrom="0"
 *    angleTo="360"
 *    originX="0"
 *    originY="0"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.effects.effectClasses.RotateInstance
 *
 *  @includeExample examples/RotateEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Rotate extends TweenEffect
{
  //  include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var AFFECTED_PROPERTIES:Array = [ "rotation" ];

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
	public function Rotate(target:Object = null)
	{
		super(target);
		
		instanceClass = RotateInstance;
		hideFocusRing = true;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  angleFrom
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]

	/** 
	 *  The starting angle of rotation of the target object,
	 *  expressed in degrees.
	 *  Valid values range from 0 to 360.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var angleFrom:Number = 0;

	//----------------------------------
	//  angleTo
	//----------------------------------

	[Inspectable(category="General", defaultValue="360")]

	/** 
	 *  The ending angle of rotation of the target object,
	 *  expressed in degrees.
	 *  Values can be either positive or negative.
	 *
	 *  <p>If the value of <code>angleTo</code> is less
	 *  than the value of <code>angleFrom</code>,
	 *  the target rotates in a counterclockwise direction.
	 *  Otherwise, it rotates in clockwise direction.
	 *  If you want the target to rotate multiple times,
	 *  set this value to a large positive or small negative number.</p>
	 *  
	 *  @default 360
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var angleTo:Number = 360;
	
	//----------------------------------
	//  originX
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]

	/**
	 *  The x-position of the center point of rotation.
	 *  The target rotates around this point.
	 *  The valid values are between 0 and the width of the target.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var originX:Number;

	//----------------------------------
	//  originY
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]

	/**
	 *  The y-position of the center point of rotation.
	 *  The target rotates around this point.
	 *  The valid values are between 0 and the height of the target.
	 *
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var originY:Number;

	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Determines whether the effect should hide the focus ring when starting the
	 *  effect. The target itself is responsible for the actual hiding of the focus ring. 
	 *  @default true
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	// override 
	public function set hideFocusRing(value:Boolean):void
	{
		//super.hideFocusRing = value;
	}
	
	//override 
	public function get hideFocusRing():Boolean
	{
		return true;
		//return super.hideFocusRing;
	}
	
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
		return AFFECTED_PROPERTIES;
	}

	/**
	 *  @private
	 */
	override protected function initInstance(instance:IEffectInstance):void
	{
		//super.initInstance(instance);
		
		var rotateInstance:RotateInstance = RotateInstance(instance);

		rotateInstance.angleFrom = angleFrom;
		rotateInstance.angleTo = angleTo;
		rotateInstance.originX = originX;
		rotateInstance.originY = originY;
	}
}
	
}
