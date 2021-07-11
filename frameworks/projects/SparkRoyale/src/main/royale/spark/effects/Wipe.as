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
package spark.effects
{

import mx.effects.IEffectInstance;
import spark.effects.Animate;
import mx.utils.ByteArray;

/**
 *  The Wipe effect performs a bitmap transition effect by running a
 *  directional wipe between the first and second bitmaps.
 *  This wipe exposes the second bitmap over the course of the 
 *  animation in a direction indicated by the <code>direction</code>
 *  property.
 * 
 *  <p>A pixel-shader program loaded by the effect
 *  runs the underlying bitmap effect. 
 *  If you want to use 
 *  a different Wipe behavior, you can specify a custom pixel-shader program. 
 *  The pixel-shader program must adhere to the constraints 
 *  specified for the <code>shaderByteCode</code>
 *  property of AnimateTransitionShader class, and supply three additional
 *  parameters. 
 *  The extra parameters required by the Wipe shader 
 *  are:</p>
 *
 *  <ul>
 *    <li>An int <code>direction</code> parameter, 
 *  whose value means the same as the related String property
 *  in the Wipe class.</li>
 *    <li>Two floating point parameters: 
 *  <code>imageWidth</code> and <code>imageHeight</code>. </li>
 *  </ul>
 *
 *  <p>All of these parameters are set on the shader when the effect starts playing,
 *  so the parameters need to exist and do something appropriate in
 *  order for the effect to function correctly.</p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Wipe&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Wipe
 *    <b>Properties</b>
 *    id="ID"
 *    direction="right"
 *  /&gt;
 *  </pre>
 *  
 *  @see spark.effects.WipeDirection
 *  @see spark.effects.AnimateTransitionShader
 *  @see spark.effects.AnimateTransitionShader#shaderByteCode
 *
 *  @includeExample examples/WipeExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.8
 */
public class Wipe extends Animate
{
    public var shaderByteCode:Object;

  
    private static var WipeUpShaderClass:Object = "WipeUp.pbj";
    private static var wipeUpShaderCode:ByteArray = new WipeUpShaderClass();
    private static var WipeDownShaderClass:Object = "WipeDown.pbj";
    private static var wipeDownShaderCode:ByteArray = new WipeDownShaderClass();
    private static var WipeRightShaderClass:Object = "WipeRight.pbj";
    private static var wipeRightShaderCode:ByteArray = new WipeRightShaderClass();
    private static var WipeLeftShaderClass:Object = "WipeLeft.pbj";
    private static var wipeLeftShaderCode:ByteArray = new WipeLeftShaderClass();
    
    
    [Inspectable(enumeration="left,right,up,down", defaultValue="right")]
    /**
     *  The direction that the wipe moves during the animation: 
     *  <code>WipeDirection.RIGHT</code>, <code>WipeDirection.LEFT</code>, 
     *  <code>WipeDirection.UP</code>, or <code>WipeDirection.DOWN</code>. 
     *
     *  @default WipeDirection.RIGHT
     *
     *  @see WipeDirection#RIGHT
     *  @see WipeDirection#UP
     *  @see WipeDirection#LEFT
     *  @see WipeDirection#DOWN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.8
     */
    public var direction:String = WipeDirection.RIGHT;
    
    /**
     *  Constructor. 
     *
     *  @param target The Object to animate with this effect.  
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.8
     */
    public function Wipe(target:Object=null)
    {
        super(target);
        // Note that we do not need a separate WipeInstance; the only
        // addition that Wipe adds is specifying the Crossfade
        // Pixel Bender shader, which is done at instance creation time,
        // according to the value of the direction property. 
        // Everything else needed is in the superclass already.
    }

    /**
     *  @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        switch (direction)
        {
            case WipeDirection.RIGHT:
                shaderByteCode = wipeRightShaderCode;
                break;
            case WipeDirection.LEFT:
                shaderByteCode = wipeLeftShaderCode;
                break;
            case WipeDirection.UP:
                shaderByteCode = wipeUpShaderCode;
                break;
            case WipeDirection.DOWN:
                shaderByteCode = wipeDownShaderCode;
                break;
        }
        super.initInstance(instance);
    }
    
}
}
