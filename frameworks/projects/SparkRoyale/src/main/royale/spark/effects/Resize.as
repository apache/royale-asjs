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
import mx.core.mx_internal;
import mx.effects.IEffectInstance;

import spark.effects.supportClasses.ResizeInstance;

use namespace mx_internal;

//not implemented
[Event(name="effectEnd", type="mx.events.EffectEvent")]

//not implemented
[Event(name="effectUpdate", type="mx.events.EffectEvent")]
/**
 *  The Resize effect changes the width, height, or both dimensions
 *  of a component over a specified time interval. 
 *  
 *  <p>If you specify only two of the three values of the
 *  <code>widthFrom</code>, <code>widthTo</code>, and
 *  <code>widthBy</code> properties, Flex calculates the third.
 *  If you specify all three, Flex ignores the <code>widthBy</code> value.
 *  If you specify only the <code>widthBy</code> or the
 *  <code>widthTo</code> value, the <code>widthFrom</code> property
 *  is set to be the object's current width.
 *  The same is true for <code>heightFrom</code>, <code>heightTo</code>,
 *  and <code>heightBy</code> property values.</p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Resize&gt;</code> tag
 *  inherits all of the tag attributes of its superclass, 
 *  and adds the following tab attributes:</p>
 *  
 *  <pre>
 *  &lt;s:Resize
 *    id="ID"
 *    widthFrom="val"
 *    heightFrom="val"
 *    widthTo="val"
 *    heightTo="val"
 *    widthBy="val"
 *    heightBy="val"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.effects.supportClasses.ResizeInstance
 *
 *  @includeExample examples/ResizeEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Resize extends Animate
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
    [
        "width", "height",
        "explicitWidth", "explicitHeight",
        "percentWidth", "percentHeight",
        "left", "right", "top", "bottom"
    ];
    private static var RELEVANT_STYLES:Array = 
        ["left", "right", "top", "bottom", "percentWidth", "percentHeight"];

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
    public function Resize(target:Object=null)
    {
        super(target);

        instanceClass = ResizeInstance;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  heightBy
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Number of pixels by which to modify the height of the component.
     *  Values may be negative.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var heightBy:Number;
    
    //----------------------------------
    //  heightFrom
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Initial height, in pixels.
     *  If omitted, Flex uses the current height of the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var heightFrom:Number;

    //----------------------------------
    //  heightTo
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Final height of the target, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var heightTo:Number;
            
    //----------------------------------
    //  widthBy
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Number of pixels by which to modify the width of the target.
     *  Values may be negative.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var widthBy:Number;

    //----------------------------------
    //  widthFrom
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Initial width of the target, in pixels.
     *  If omitted, Flex uses the current width.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var widthFrom:Number;
    
    //----------------------------------
    //  widthTo
    //----------------------------------

    [Inspectable(category="General", defaultValue="NaN")]

    /** 
     *  Final width of the target, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var widthTo:Number;

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
    override public function get relevantStyles():Array /* of String */
    {
        return RELEVANT_STYLES;
    }   

    /**
     *  @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        super.initInstance(instance);
        
        var resizeInstance:ResizeInstance = ResizeInstance(instance);

        if (!isNaN(widthFrom))
            resizeInstance.widthFrom = widthFrom;
        if (!isNaN(widthTo))
            resizeInstance.widthTo = widthTo;
        if (!isNaN(widthBy))
            resizeInstance.widthBy = widthBy;
        if (!isNaN(heightFrom))
            resizeInstance.heightFrom = heightFrom;
        if (!isNaN(heightTo))
            resizeInstance.heightTo = heightTo;
        if (!isNaN(heightBy))
            resizeInstance.heightBy = heightBy;
    }
    
    /**
     * @private
     * Tell the propertyChanges array to keep all values, unchanged or not.
     * This enables us to check later, when the effect is finished, whether
     * we need to restore explicit height/width values.
     */
    override mx_internal function captureValues(propChanges:Array,
        setStartValues:Boolean, targetsToCapture:Array = null):Array
    {
        var propertyChanges:Array = 
            super.captureValues(propChanges, setStartValues, targetsToCapture);
        
        if (setStartValues)
        {
            var n:int = propertyChanges.length;
            for (var i:int = 0; i < n; i++)
            {
                if (targetsToCapture == null || targetsToCapture.length == 0 ||
                    targetsToCapture.indexOf(propertyChanges[i].target) >= 0)
                {
                    propertyChanges[i].stripUnchangedValues = false;
                }
            }
        }
        return propertyChanges;
    }
                                                     
}
}
