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
import __AS3__.vec.Vector;

import mx.core.IUIComponent;

import spark.effects.animation.Keyframe;
import spark.effects.animation.MotionPath;
import spark.effects.animation.SimpleMotionPath;
    
/**
 *  The ResizeInstance class implements the instance class
 *  for the Resize effect.
 *  Flex creates an instance of this class when it plays a Resize
 *  effect; you do not create one yourself.
 *
 *  @see spark.effects.Resize
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */  
public class ResizeInstance extends AnimateInstance
{
    //include "../../core/Version.as";

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
    public function ResizeInstance(target:Object)
    {
        super(target);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var heightSet:Boolean;
    
    /**
     *  @private
     */
    private var widthSet:Boolean;
    
    /**
     *  @private
     */
    private var explicitWidthSet:Boolean;
    
    /**
     *  @private
     */
    private var explicitHeightSet:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  heightBy
    //----------------------------------

    /**
     *  @private
     *  Storage for the heightBy property.
     */
    private var _heightBy:Number;
    
    /** 
     *  Number of pixels by which to modify the height of the component.
     *  Values may be negative.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get heightBy():Number
    {
        return _heightBy;
    }   
    
    /**
     *  @private
     */
    public function set heightBy(value:Number):void
    {
        _heightBy = value;
        heightSet = !isNaN(value);
    }
    
    //----------------------------------
    //  heightFrom
    //----------------------------------

    /** 
     *  @copy spark.effects.Resize#heightFrom
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
    
    /**
     *  @private
     *  Storage for the heightTo property.
     */
    private var _heightTo:Number;
    
    /** 
     *  @copy spark.effects.Resize#heightTo
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get heightTo():Number
    {
        return _heightTo;
    }   
    
    /**
     *  @private
     */
    public function set heightTo(value:Number):void
    {
        _heightTo = value;
        heightSet = !isNaN(value);
    }
    
    //----------------------------------
    //  widthBy
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the widthBy property.
     */
    private var _widthBy:Number;

    /** 
     *  @copy spark.effects.Resize#widthBy
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function get widthBy():Number
    {
        return _widthBy;
    }   
    
    /**
     *  @private
     */
    public function set widthBy(value:Number):void
    {
        _widthBy = value;
        widthSet = !isNaN(value);
    }

    //----------------------------------
    //  widthFrom
    //----------------------------------

    /** 
     *  @copy spark.effects.Resize#widthFrom
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

    /**
     *  @private
     *  Storage for the widthTo property.
     */
    private var _widthTo:Number;
    
    /** 
     *  @copy spark.effects.Resize#widthTo
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get widthTo():Number
    {
        return _widthTo;
    }   
    
    /**
     *  @private
     */
    public function set widthTo(value:Number):void
    {
        _widthTo = value;
        widthSet = !isNaN(value);
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
        calculateDimensionChanges();

        motionPaths = new <MotionPath>[new MotionPath("width"),
            new MotionPath("height")];
        motionPaths[0].keyframes = new <Keyframe>[new Keyframe(0, widthFrom), 
            new Keyframe(duration, widthTo, widthBy)];
        motionPaths[1].keyframes = new <Keyframe>[new Keyframe(0, heightFrom), 
            new Keyframe(duration, heightTo, heightBy)];
                
        // Also animate any size-related constraints that change between
        // transition states
        if (propertyChanges && !disableLayout)
        {
            var wStart:* = propertyChanges.start["width"];
            var wEnd:* = propertyChanges.end["width"];
            var hStart:* = propertyChanges.start["height"];
            var hEnd:* = propertyChanges.end["height"];
            if (wStart !== undefined && wEnd != undefined && (wStart != wEnd))
            {
                setupConstraintAnimation("left");
                setupConstraintAnimation("right");
            }
            if (hStart !== undefined && hEnd != undefined && (hStart != hEnd))
            {
                setupConstraintAnimation("top");
                setupConstraintAnimation("bottom");
            }
        }
        
        super.play();        
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    private function calculateDimensionChanges():void
    {
        var explicitWidth:* = propertyChanges ? propertyChanges.end["explicitWidth"] : undefined;
        var explicitHeight:* = propertyChanges ? propertyChanges.end["explicitHeight"] : undefined;
        var percentWidth:* = propertyChanges ? propertyChanges.end["percentWidth"] : undefined;
        var percentHeight:* = propertyChanges ? propertyChanges.end["percentHeight"] : undefined;

        // The user may have supplied some combination of widthFrom,
        // widthTo, and widthBy. If either widthFrom or widthTo is
        // not explicitly defined, calculate its value based on the
        // other two values.
        if (isNaN(widthFrom))
        {
            if (!isNaN(widthTo) && !isNaN(widthBy))
                widthFrom = widthTo - widthBy;
        }
        if (isNaN(widthTo))
        {       
            if (isNaN(widthBy) &&
                propertyChanges &&
                ((propertyChanges.end["width"] !== undefined &&
                  propertyChanges.end["width"] != propertyChanges.start["width"]) ||
                 (explicitWidth !== undefined && !isNaN(explicitWidth))))
            {
                if (explicitWidth !== undefined && !isNaN(explicitWidth))
                {
                    explicitWidthSet = true;
                    _widthTo = explicitWidth;
                }
                else
                {
                    _widthTo = propertyChanges.end["width"];
                }
            }
            else
            {
                if (!isNaN(widthBy) && !isNaN(widthFrom))
                    _widthTo = widthFrom + widthBy;
            }
        }

        // Ditto for heightFrom, heightTo, and heightBy.
        if (isNaN(heightFrom))
        {
            if (!isNaN(heightTo) && !isNaN(heightBy))
                heightFrom = heightTo - heightBy;
        }
        if (isNaN(heightTo))
        {       
            if (isNaN(heightBy) &&
                propertyChanges &&
                ((propertyChanges.end["height"] !== undefined &&
                  propertyChanges.end["height"] != propertyChanges.start["height"]) ||
                 (explicitHeight !== undefined && !isNaN(explicitHeight))))
            {
                if (explicitHeight !== undefined && !isNaN(explicitHeight))
                {
                    explicitHeightSet = true;
                    _heightTo = explicitHeight;
                }
                else
                {
                    _heightTo = propertyChanges.end["height"];
                }
            }
            else
            {
                if (!isNaN(heightBy) && !isNaN(heightFrom))
                    _heightTo = heightFrom + heightBy;
            }
        }
    }

}
}
