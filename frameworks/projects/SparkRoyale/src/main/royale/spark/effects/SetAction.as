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

import spark.effects.supportClasses.SetActionInstance;

import mx.effects.Effect;
import mx.effects.IEffectInstance;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="duration", kind="property")]

/**
 *  The SetAction class defines an action effect that sets 
 *  the value of a named property or style.
 *  You use a SetAction effect within a transition definition
 *  to control when the view state change defined by a
 *  property or style change occurs during the transition.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:SetAction&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 * 
 *  <pre>
 *  &lt;s:SetAction
 *    <b>Properties</b>
 *    id="ID"
 *    property=""
 *    value=""
 *  /&gt;
 *  </pre>
 *  
 *  @see spark.effects.supportClasses.SetActionInstance
 *
 *  @includeExample examples/SetActionEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SetAction extends Effect
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SetAction(target:Object = null)
    {
        super(target);
        duration = 0;
        instanceClass = SetActionInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  property
    //----------------------------------

    [Inspectable(category="General")]
    
    /** 
     *  The name of the property being changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var property:String;
    
    //----------------------------------
    //  value
    //----------------------------------

    [Inspectable(category="General")]
    
    /** 
     *  The new value for the property.
     *  When run within a transition and value is not specified, Flex determines 
     *  the value based on that set by the new view state.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var value:*;
        
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  relevantStyles
    //----------------------------------

    /**
     *  @private
     */
    override public function get relevantStyles():Array /* of String */
    {
        return [ property ];
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
        return [ property ];
    }

    /**
     *  @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        super.initInstance(instance);
        
        var actionInstance:SetActionInstance =
            SetActionInstance(instance);

        actionInstance.property = property;
        actionInstance.value = value;
    }
}

}
