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

import mx.events.FlexEvent;

/**
 *  The SeriesInterpolateInstance class implements the instance class
 *  for the SeriesInterpolate effect.
 *  Flex creates an instance of this class when it plays a SeriesInterpolate effect;
 *  you do not create one yourself.
 *
 *  @see mx.charts.effects.SeriesInterpolate
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */  
public class SeriesInterpolateInstance extends SeriesEffectInstance
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
    public function SeriesInterpolateInstance(target:Object)
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
    private var _sourceRenderData:Object;
    
    /**
     *  @private
     */
    private var _destRenderData:Object;
    
    /**
     *  @private
     */
    private var _len:Number;
    
    /**
     *  @private
     */
    private var _customIData:Object;
    
    /**
     *  @private
     */
    private var seriesRenderData:Object;

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
        if (type == FlexEvent.HIDE)
        {
            end();
            return;
        }
        
        _sourceRenderData = targetSeries.getRenderDataForTransition("hide");
        
        _destRenderData = targetSeries.getRenderDataForTransition("show");

        _len = Math.max(_sourceRenderData.length,_destRenderData.length);
        
        if (_sourceRenderData && _destRenderData)
            _customIData = targetSeries.beginInterpolation(_sourceRenderData,
                                                      _destRenderData);     
        
        beginTween(_len);
    }

    /**
     *  @private
     */
    override public function onTweenUpdate(value:Object):void
    {
        super.onTweenUpdate(value);
        
        if (_sourceRenderData && _destRenderData)
        {
            targetSeries.interpolate(interpolationValues, _customIData);                        
            
            targetSeries.invalidateDisplayList();

//          updateDisplayList(targetSeries.unscaledWidth,
//                            targetSeries.unscaledHeight);
        }
    }
    
    /**
     *  @private
     */
    override public function onTweenEnd(value:Object):void 
    {
        super.onTweenEnd(value);

        if (_sourceRenderData && _destRenderData)
            targetSeries.endInterpolation(_customIData);
    }   
}

}
