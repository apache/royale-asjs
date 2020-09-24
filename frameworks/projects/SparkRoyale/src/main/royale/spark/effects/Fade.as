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
import flash.display.DisplayObject;
import flash.display.MovieClip;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.mx_internal;
import mx.effects.IEffectInstance;

import spark.effects.supportClasses.FadeInstance;

use namespace mx_internal;

/**
 *  The Fade effect animates the <code>alpha</code> property of a component.
 *  If played manually (outside of a transition) on an object whose
 *  <code>visible</code> property is set to false, and told to animate
 *  <code>alpha</code> from zero to a nonzero value, it will set <code>visible</code>
 *  to true as a side-effect of fading it in. When run as part of a
 *  transition, it will respect state-specified values, but may use
 *  the <code>visible</code> property as well as whether the object
 *  is parented in the before/after states to determine the 
 *  values to animate <code>alpha</code> from and to if <code>alphaFrom</code>
 *  and <code>alphaTo</code> are not specified for the effect.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Fade&gt;</code> tag
 *  inherits the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:Fade 
 *    id="ID"
 *    alphaFrom="val"
 *    alphaTo="val"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.effects.supportClasses.FadeInstance
 * 
 *  @includeExample examples/FadeEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Fade extends Animate
{
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
    public function Fade(target:Object=null)
    {
        super(target);
        instanceClass = FadeInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alphaFrom
    //----------------------------------

    [Inspectable(category="General", defaultValue="undefined", minValue="0.0", maxValue="1.0")]
    
    /** 
     *  Initial value of the <code>alpha</code> property, between 0.0 and 1.0, 
     *  where 0.0 means transparent and 1.0 means fully opaque. 
     * 
     *  <p>If the effect causes the target component to disappear,
     *  the default value is the current value of the target's
     *  <code>alpha</code> property.
     *  If the effect causes the target component to appear,
     *  the default value is 0.0.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var alphaFrom:Number;
    
    //----------------------------------
    //  alphaTo
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN", minValue="0.0", maxValue="1.0")]
    
    /** 
     *  Final value of the <code>alpha</code> property, between 0.0 and 1.0,
     *  where 0.0 means transparent and 1.0 means fully opaque.
     *
     *  <p>If the effect causes the target component to disappear,
     *  the default value is 0.0.
     *  If the effect causes the target component to appear,
     *  the default value is the current value of the target's
     *  <code>alpha</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var alphaTo:Number;

    
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private 
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        super.initInstance(instance);
        
        var fadeInstance:FadeInstance = FadeInstance(instance);

        fadeInstance.alphaFrom = alphaFrom;
        fadeInstance.alphaTo = alphaTo;
    }

    /**
     *  @private
     */
    override public function getAffectedProperties():Array /* of String */
    {
        return ["alpha", "visible", "parent", "index", 
            "explicitWidth", "explicitHeight", "rotation", "x", "y",
            "left", "right", "top", "bottom",
            "percentWidth", "percentHeight"];
    }

    /**
     *  @private
     */
    override protected function getValueFromTarget(target:Object, property:String):*
    {
        // We track 'index' for use in the addDisappearingTarget() function in
        // AnimateInstance, in order to add the item in the correct order
        if (property == "index" && "parent" in target)
        {
            var container:* = target.parent;
            // if the target has no parent, return undefined for index to indicate that
            // it has no index value.
            if (container === undefined || container === null ||
                ("mask" in container && container.mask == target))
                return undefined;
            if (container is IVisualElementContainer)
                return IVisualElementContainer(container).
                    getElementIndex(target as IVisualElement);
            else if ("getChildIndex" in container)
                return container.getChildIndex(target);
        }
        
        return super.getValueFromTarget(target, property);
    }

    /**
     * @private
     * This override handles the case caused by transition interruption
     * where the target object may not have reached its final fade-in value, or 
     * may not have had the end value of '1' applied correctly because the
     * transition was interrupted and the animation stopped. The logic
     * checks to see whether the object was being faded in or out, based on
     * the 'visible' or 'parent' properties. It then sets the end alpha to either
     * the proper state value (the typical case) or to 1 (as a backup).
     * Note that a faded-out object due to going away or becoming invisible
     * should still have an alpha value of 1; it just won't be visible because
     * it is either invisible or has no parent. But we want the alpha value
     * to be opaque the next time it is made visible.
     */
    override mx_internal function applyEndValues(propChanges:Array,
                                                 targets:Array):void
    {
        super.applyEndValues(propChanges, targets);
        if (transitionInterruption && propChanges)
        {
            var n:int = propChanges.length;
            for (var i:int = 0; i < n; i++)
            {
                var target:Object = propChanges[i].target;
                if (this.targets.indexOf(target ) >= 0 &&
                    (propChanges[i].start["parent"] !== undefined &&
                     propChanges[i].end["parent"] !== undefined &&
                     propChanges[i].start["parent"] != propChanges[i].end["parent"]) ||
                    (propChanges[i].start["visible"] !== undefined &&
                        propChanges[i].end["visible"] !== undefined &&
                        propChanges[i].start["visible"] != propChanges[i].end["visible"]))
                {
                    target.alpha = (propChanges[i].end["alpha"] !== undefined) ?
                            propChanges[i].end["alpha"] : 1;
                }
            }
        }
    }

    /**
     *  @private
     */
    override protected function applyValueToTarget(target:Object,
                                                   property:String, 
                                                   value:*,
                                                   props:Object):void
    {
        // We only want to track "parent" as it affects how
        // we fade; we don't actually want to change target properties
        // other than alpha or visibility
        if (property == "parent" || property == "index" || 
            property == "explicitWidth" || property == "explicitHeight" ||
            property == "percentWidth" || property == "percentHeight" ||
            property == "rotation" || property == "x" || property == "y" ||
            property == "left" || property == "right" || property == "top" || property == "bottom")
        {
            return;
        }
            
        super.applyValueToTarget(target, property, value, props);
    }
}
}
