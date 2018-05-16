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

import mx.core.FlexGlobals;
//import mx.effects.effectClasses.GlowInstance;
//import mx.styles.StyleManager;

/**
 *  In Flex 4, use an AnimateFilter effect with a Glow bitmap filter.
 */
[Alternative(replacement="spark.effects.AnimateFilter", since="4.0")]

/**
 *  The Glow effect lets you apply a visual glow effect to a component. 
 *
 *  <p>The Glow effect uses the Flash GlowFilter class
 *  as part of its implementation. 
 *  For more information, see the flash.filters.GlowFilter class.
 *  If you apply a Glow effect to a component, you cannot apply a GlowFilter
 *  or a second Glow effect to the component.</p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Glow&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Glow
 *    id="ID"
 *    alphaFrom="val"
 *    alphaTo="val"
 *    blurXFrom="val"
 *    blurXTo="val"
 *    blurYFrom="val"
 *    blurYTo="val"
 *    color="<i>themeColor of the application</i>"
 *    inner="false|true"
 *    knockout="false|true"
 *    strength="2"
 *  /&gt;
 *  </pre>
 *  
 *  @see flash.filters.GlowFilter
 *  @see mx.effects.effectClasses.GlowInstance
 *
 *  @includeExample examples/GlowEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *  @royalesuppresspublicvarwarning
 */
public class Glow extends TweenEffect
{
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	//private static var AFFECTED_PROPERTIES:Array = [ "filters" ];

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
	public function Glow(target:Object = null)
	{
		super(target);

		//instanceClass = GlowInstance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  alphaFrom
	//----------------------------------

	[Inspectable(category="General", defaultValue="1")]
	
	/** 
	 *  Starting transparency level between 0.0 and 1.0,
	 *  where 0.0 means transparent and 1.0 means fully opaque.
	 * 
	 *  @default 1
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var alphaFrom:Number = 1;
	
	//----------------------------------
	//  alphaTo
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]
	
	/** 
	 *  Ending transparency level between 0.0 and 1.0,
	 *  where 0.0 means transparent and 1.0 means fully opaque.
	 * 
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var alphaTo:Number = 0;
	
	//----------------------------------
	//  blurXFrom
	//----------------------------------

	[Inspectable(category="General", defaultValue="5")]
	
	/** 
	 *  The starting amount of horizontal blur.
	 *  Valid values are from 0.0 to 255.0.
	 * 
	 *  @default 5 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var blurXFrom:Number = 5;
	
	//----------------------------------
	//  blurXTo
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]
	
	/** 
	 *  The ending amount of horizontal blur.
	 *  Valid values are from 0.0 to 255.0.
	 * 
	 *  @default 0 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var blurXTo:Number = 0;
	
	//----------------------------------
	//  blurYFrom
	//----------------------------------

	[Inspectable(category="General", defaultValue="5")]
	
	/** 
	 *  The starting amount of vertical blur.
	 *  Valid values are from 0.0 to 255.0. 
	 * 
	 *  @default 5
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var blurYFrom:Number = 5;
	
	//----------------------------------
	//  blurYTo
	//----------------------------------

	[Inspectable(category="General", defaultValue="0")]
	
	/** 
	 *  The ending amount of vertical blur.
	 *  Valid values are from 0.0 to 255.0. 
	 * 
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var blurYTo:Number = 0;
	
	//----------------------------------
	//  color
	//----------------------------------

	[Inspectable(category="General", format="Color", defaultValue="0xFFFFFFFF")]
	
	/** 
	 *  The color of the glow. 
	 *  The default value is the value of the <code>themeColor</code> style 
	 *  property of the application. The default value of this property
	 *  is <code>StyleManager.NOT_A_COLOR</code>. When <code>play()</code>
	 *  is called on the effect, if the color property is set to that default
	 *  value, the color value in the effect instance will be set to
	 *  the value of the current <code>themeColor</code> style for the
	 *  application.
	 * 
	 *  @default StyleManager.NOT_A_COLOR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var color:uint = 0xFFFFFFFF;//StyleManager.NOT_A_COLOR;
	
	//----------------------------------
	//  inner
	//----------------------------------

	//[Inspectable(category="General", defaultValue="false")]
	
	/** 
	 *  Specifies whether the glow is an inner glow. 
	 *  A value of <code>true</code> indicates an inner glow within
	 *  the outer edges of the object. 
	 *  The default value is <code>false</code>, to specify 
	 *  an outer glow around the outer edges of the object. 
	 *
	 *  @default false
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	//public var inner:Boolean;
	
	//----------------------------------
	//  knockout
	//----------------------------------

	//[Inspectable(defaultValue="false")]
	
	/** 
	 *  Specifies whether the object has a knockout effect. 
	 *  A value of <code>true</code> makes the object's fill color transparent 
	 *  to reveal the background color of the underlying object. 
	 *  The default value is <code>false</code> to specify no knockout effect. 
	 *
	 *  @default false
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	//public var knockout:Boolean;
	
	//----------------------------------
	//  strength
	//----------------------------------

	[Inspectable(category="General", defaultValue="2")]
	
	/** 
	 *  The strength of the imprint or spread. 
	 *  The higher the value, the more color is imprinted and the stronger the 
	 *  contrast between the glow and the background. 
	 *  Valid values are from <code>0</code> to <code>255</code>. 
	 *
	 *  @default 2 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var strength:Number = 2;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	 // override public function getAffectedProperties():Array /* of String */
	// {
		// return AFFECTED_PROPERTIES;
	// } 

	/**
	 *  @private
	 */
	/* override protected function initInstance(instance:IEffectInstance):void
	{
		super.initInstance(instance);
		
		var glowInstance:GlowInstance = GlowInstance(instance);

		glowInstance.alphaFrom = alphaFrom;
		glowInstance.alphaTo = alphaTo;
		glowInstance.blurXFrom = blurXFrom;
		glowInstance.blurXTo = blurXTo;
		glowInstance.blurYFrom = blurYFrom;
		glowInstance.blurYTo = blurYTo;
		glowInstance.color = 
		    color != StyleManager.NOT_A_COLOR ?
		    color : 
		    FlexGlobals.topLevelApplication.getStyle("themeColor");
		glowInstance.inner = inner;
		glowInstance.knockout = knockout;
		glowInstance.strength = strength;
	} */
}

}
