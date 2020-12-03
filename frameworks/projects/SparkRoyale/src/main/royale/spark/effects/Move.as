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
import flash.geom.Vector3D;

import mx.core.mx_internal;
import mx.effects.IEffectInstance;

import spark.effects.animation.MotionPath;
import spark.effects.supportClasses.AnimateTransformInstance;

use namespace mx_internal;
import spark.effects.Animate;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="motionPaths", kind="property")]

/**
 *  The Move effect move the target object
 *  in the x and y directions. 
 *  The x and y property specifications of the Move effect specify 
 *  the change in x and y that should occur to the transform center around
 *  which the overall transform occurs. 
 *  If, for example, the 
 *  <code>autoCenterTransform</code> property is set, then the from/to/by values
 *  in this effect will define how much to move the center of the target, not the 
 *  (x,y) coordinates of the target.
 * 
 *  <p>Like all transform-based effects, this effect only work on subclasses
 *  of UIComponent and GraphicElement.</p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Move&gt;</code> tag
 *  inherits all of the tag attributes of its of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:Move
 *    id="ID"
 *    xBy="val"
 *    xFrom="val" 
 *    xTo="val"
 *    yBy="val"
 *    yFrom="val"
 *    yTo="val"
 *   /&gt;
 *  </pre>
 *
 *  @includeExample examples/MoveEffectExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */   
public class Move extends Animate //AnimateTransform
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
    private static var AFFECTED_PROPERTIES:Array =
        ["translationX", "translationY", 
         "postLayoutTranslationX","postLayoutTranslationY",
         "left", "right", "top", "bottom",
         "horizontalCenter", "verticalCenter", "baseline",
         "width", "height"];

    private static var RELEVANT_STYLES:Array = 
        ["left", "right", "top", "bottom",
         "horizontalCenter", "verticalCenter", "baseline"];

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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Move(target:Object=null)
    {
        super(target);
        //instanceClass = AnimateTransformInstance;
        //transformEffectSubclass = true;
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  yBy
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Number of pixels by which to modify the y position of the target.
     *  Values can be negative.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var yBy:Number;
    
    //----------------------------------
    //  yFrom
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Initial y position of the target, in pixels.
     *  If omitted, Flex uses either the value in the start view state,
     *  if the effect is playing in a transition, or the current
     *  value of the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var yFrom:Number;

    //----------------------------------
    //  yTo
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Final y position of the target, in pixels.
     *  If omitted, Flex uses either the value in the end view state,
     *  if the effect is playing in a transition, or the current
     *  value of the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var yTo:Number;
            
    //----------------------------------
    //  xBy
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Number of pixels by which to modify the x position of the target.
     *  Values may be negative.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var xBy:Number;

    //----------------------------------
    //  xFrom
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Initial x position of the target, in pixels.
     *  If omitted, Flex uses either the value in the starting view state,
     *  if the effect is playing in a transition, or the current
     *  value of the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var xFrom:Number;
    
    //----------------------------------
    //  xTo
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Final x, in pixels.
     *  If omitted, Flex uses either the value in the starting state,
     *  if the effect is playing in a state transition, or the current
     *  value of the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var xTo:Number;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function get relevantStyles():Array /* of String */
    {
        return RELEVANT_STYLES;
    }   

    /**
     *  @private
     */
    override public function getAffectedProperties():Array /* of String */
    {
        return AFFECTED_PROPERTIES;
    }

    // TODO (chaase): Should try to remove this override. At a minimum, we could
    // put the motionPaths creation at the start of initInstance(). Ideally, we'd
    // remove that logic entirely, but there's a need to create motionPaths fresh
    // for every call to create/initInstance() or else multi-instance effects
    // will inherit the one motionPaths object created elsewhere.
    /**
     * @private
     */
    override public function createInstance(target:Object = null):IEffectInstance
    {
        motionPaths = new Vector.<MotionPath>();
        return super.createInstance(target);
    }

    /**
     * @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        //var xProp:String = applyChangesPostLayout ? "postLayoutTranslationX" : "translationX";
        //var yProp:String = applyChangesPostLayout ? "postLayoutTranslationY" : "translationY";
        
        //addMotionPath(xProp, xFrom, xTo, xBy);
        //addMotionPath(yProp, yFrom, yTo, yBy);
        
        super.initInstance(instance);
    }    
}
}
