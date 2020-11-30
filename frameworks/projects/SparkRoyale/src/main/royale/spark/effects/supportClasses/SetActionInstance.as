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

package spark.effects.supportClasses
{

import mx.core.IFlexModule;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;

import mx.effects.effectClasses.ActionEffectInstance;
import mx.styles.StyleManager;

use namespace mx_internal;

/**
 *  The SetActionInstance class implements the instance class
 *  for the SetAction effect.
 *  Flex creates an instance of this class when it plays a SetAction
 *  effect; you do not create one yourself.
 *
 *  @see spark.effects.SetAction
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */  
public class SetActionInstance extends ActionEffectInstance
{
    //include "../../core/Version.as";

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
    public function SetActionInstance(target:Object)
    {
        super(target);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  property
    //----------------------------------

    /** 
     *  @copy spark.effects.SetAction#property
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

    /** 
     *  Storage for the value property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private var _value:*;
    
    /** 
     *  @copy spark.effects.SetAction#value
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get value():*
    {
        var val:*;
    
        if (playReversed)
        {
             val = getStartValue();
             if (val !== undefined)
                 return val;
        }
        
        return _value;
    }
    
    /** 
     *  @private
     */
    public function set value(val:*):void
    {
        _value = val;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override public function play():void
    {
        // Dispatch an effectStart event from the target.
        super.play();    
        
        if (value === undefined && propertyChanges)
        {
            if (property in propertyChanges.end &&
                propertyChanges.start[property] != propertyChanges.end[property])
                value = propertyChanges.end[property];
        }
        
        if (value !== undefined)
            setValue(property, value);
        
        //finishRepeat();
    }
    
    /**
     * Sets <code>property</code> to the value specified by 
     * <code>value</code>. This is done by setting the property
     * on the target if it is a property or the style on the target
     * if it is a style.  There are some special cases handled
     * for specific property types such as percent-based width/height
     * and string-based color values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function setValue(property:String, value:Object):void
    {
        var isStyle:Boolean = false;
        var propName:String = property;
        var val:Object = value;

        // Handle special case of width/height values being set in terms
        // of percentages. These are handled through the percentWidth/Height
        // properties instead                
        if (property == "width" || property == "height")
        {
            if (value is String && value.indexOf("%") >= 0)
            {
                propName = property == "width" ? "percentWidth" : "percentHeight";
                val = val.slice(0, val.indexOf("%"));
            }
        }
        else
        {
            var currentVal:Object = getValue(propName);
            // Handle situation of turning strings into Boolean values
            if (currentVal is Boolean)
            {
                if (val is String)
                    val = (value.toLowerCase() == "true");
            }
            // Handle turning standard string representations of colors
            // into numberic values
            else if (currentVal is Number &&
                propName.toLowerCase().indexOf("color") != -1)
            {
                var moduleFactory:IFlexModuleFactory = null;
                if (target is IFlexModule)
                    moduleFactory = target.moduleFactory;

                //val = StyleManager.getStyleManager(moduleFactory).getColorName(value);
                val = "dummy";
            }
        }
        
        if (propName in target)
            target[propName] = val;
        else
            target.setStyle(propName, val);
    }
    
    /**
     * Gets the current value of propName, whether it is a 
     * property or a style on the target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function getValue(propName:String):*
    {
        if (propName in target)
            return target[propName];
        else
            return target.getStyle(propName);
    }
    
    /** 
     *  @private
     */
    override protected function saveStartValue():*
    {
        if (property != null)
        {
            try
            {
                return getValue(property);
            }
            catch(e:Error)
            {
                // Do nothing. Let us return undefined.
            }
        }
        return undefined;
    }
}

}
