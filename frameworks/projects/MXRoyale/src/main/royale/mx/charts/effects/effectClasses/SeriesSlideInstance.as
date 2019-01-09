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

package mx.charts.effects.effectClasses
{

import org.apache.royale.geom.Rectangle;

/**
 *  The SeriesSlideInstance class implements the instance class
 *  for the SeriesSlide effect.
 *  Flex creates an instance of this class when it plays a SeriesSlide effect;
 *  you do not create one yourself.
 *
 *  @see mx.charts.effects.SeriesSlide
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */  
public class SeriesSlideInstance extends SeriesEffectInstance
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @param target The target of the effect.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SeriesSlideInstance(target:Object)
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
    private var _startingBounds:Array /* of Rectangle */;
    
    /**
     *  @private
     */
    private var _slideDistance:Number;  
    
    /**
     *  @private
     */
    private var _horizontal:Boolean;

    /**
     *  @private
     */
    private var seriesRenderData:Object;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    [Inspectable(category="General", enumeration="left,right,up,down", defaultValue="left")]

    /**
     *  Defines the location from which the series slides.
     *  Valid values are <code>"left"</code>, <code>"right"</code>,
     *  <code>"up"</code>, and <code>"down"</code>.
     *  The default value is <code>"left"</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var direction:String = "left";

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
    *   @private
    */
    override public function play():void
    {
        seriesRenderData = targetSeries.getRenderDataForTransition(type);
        
        targetSeries.getElementBounds(seriesRenderData);

        var startingBounds:Array /* of Rectangle */ = seriesRenderData.elementBounds;
        var visibleRegion:Rectangle = seriesRenderData.visibleRegion;
        if (!visibleRegion)
        {
            visibleRegion = new Rectangle(0, 0,
                                          targetSeries.width / Math.abs(targetSeries.scaleX),
                                          targetSeries.height / Math.abs(targetSeries.scaleY));
        }
        if (seriesRenderData.bounds)
        {   
            if (type == "show")
            {
                switch (direction)
                {
                    case "right":
                    {
                        _slideDistance = seriesRenderData.bounds.right;
                        _horizontal = true;
                        break;
                    }

                    case "left":
                    {
                        _slideDistance = -(visibleRegion.right -
                                           seriesRenderData.bounds.left);
                        _horizontal = true;
                        break;
                    }

                    case "down":
                    {
                        _slideDistance = seriesRenderData.bounds.bottom;
                        _horizontal = false;
                        break;
                    }

                    case "up":
                    {
                        _slideDistance = -(visibleRegion.bottom -
                                           seriesRenderData.bounds.top);
                        _horizontal = false;
                        break;
                    }
                }
            }
            else 
            {
                switch (direction)
                {
                    case "left":
                    {
                        _slideDistance = -seriesRenderData.bounds.right;
                        _horizontal = true;
                        break;
                    }

                    case "right":
                    {
                        _slideDistance = visibleRegion.right -
                                         seriesRenderData.bounds.left;
                        _horizontal = true;
                        break;
                    }

                    case "up":
                    {
                        _slideDistance = -seriesRenderData.bounds.bottom;
                        _horizontal = false;
                        break;
                    }

                    case "down":
                    {
                        _slideDistance = visibleRegion.bottom -
                                         seriesRenderData.bounds.top;
                        _horizontal = false;
                        break;
                    }
                }
            }
        }
        var activeBounds:Array /* of Rectangle */ = [];
        startingBounds = seriesRenderData.elementBounds;
        var n:int = startingBounds.length;
        var i:int;
        var v:Rectangle;

        if (type == "show")
        {
            if (_horizontal)
            {
                for (i = 0; i < n; i++)
                {
                    v = startingBounds[i];
                    activeBounds[i] = new Rectangle(v.left - _slideDistance,
                                                    v.top,
                                                    v.width, v.height);         

                }
            }
            else
            {
                for (i = 0; i < n; i++)
                {
                    v = startingBounds[i];
                    activeBounds[i] = new Rectangle(v.left,
                                                    v.top - _slideDistance,
                                                    v.width, v.height);
                }
            }
        
        }
        else
        {
            for (i = 0; i < n; i++)
            {
                activeBounds[i] = startingBounds[i].clone();
            }
        }
        
        seriesRenderData.elementBounds = activeBounds;
        targetSeries.transitionRenderData = seriesRenderData;
        _startingBounds = startingBounds;

        beginTween(n);
    }

    /**
     *  @private
     */
    override public function onTweenUpdate(value:Object):void
    {
        super.onTweenUpdate(value);

        var startingBounds:Array /* of Rectangle */ = _startingBounds;
        var activeBounds:Array /* of Rectangle */ = seriesRenderData.elementBounds;
        var n:int = startingBounds.length;
        var i:int;
        var interpolation:Number;
        var v:Rectangle;
        var a:Rectangle;
        
        if (type == "show")
        {
            if (_horizontal)
            {
                for (i = 0; i < n; i++)
                {
                    interpolation = 1 - interpolationValues[i];
                    v= startingBounds[i];
                    a = activeBounds[i];
                    a.left = v.left - interpolation * _slideDistance;
                    a.right = v.right - interpolation * _slideDistance;
                    a.top = v.top;
                    a.bottom = v.bottom;
                }
            }
            else
            {
                for (i = 0; i < n; i++)
                {
                    interpolation = 1 - interpolationValues[i];
                    v= startingBounds[i];
                    a = activeBounds[i];
                    a.top = v.top - interpolation * _slideDistance;
                    a.bottom = v.bottom - interpolation * _slideDistance;
                    a.left = v.left;
                    a.right = v.right;
                }
            }
        }
        else
        {
            if (_horizontal)
            {
                for (i = 0; i < n; i++)
                {
                    interpolation = interpolationValues[i];
                    v= startingBounds[i];
                    a = activeBounds[i];
                    a.left = v.left + interpolation * _slideDistance;
                    a.right = v.right + interpolation * _slideDistance;
                    a.top = v.top;
                    a.bottom = v.bottom;
                }
            }
            else
            {
                for (i = 0; i < n; i++)
                {
                    interpolation = interpolationValues[i];
                    v= startingBounds[i];
                    a = activeBounds[i];
                    a.top = v.top + interpolation * _slideDistance;
                    a.bottom = v.bottom + interpolation * _slideDistance;
                    a.left = v.left;
                    a.right = v.right;
                }
            }
        }
        targetSeries.invalidateDisplayList();
    }
    
    /**
     *  @private
     */
    override public function onTweenEnd(value:Object):void 
    {
        super.onTweenEnd(value);

        targetSeries.transitionRenderData = null;
    }
}

}
