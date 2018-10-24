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

package mx.charts.chartClasses
{

import org.apache.royale.geom.Point;
import mx.charts.chartClasses.DataTransform;

/**
 *  The PolarTransform object represents a set of axes
 *  used to map data values to angle/distance polar coordinates
 *  and vice versa.  
 *
 *  <p>You typically do not need to interact with the PolarTransform object.
 *  Transforms are created automatically by the built-in chart types
 *  and are used by the series contained within to transform data
 *  into rendering coordinates.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PolarTransform extends DataTransform
{   
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  A string representing the radial axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const RADIAL_AXIS:String = "r";
    
    /**
     *  A string representing the angular axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const ANGULAR_AXIS:String = "a";

    /**
     *  @private
     */
    private static const TWO_PI:Number = 2 * Math.PI;

    //--------------------------------------------------------------------------
    //
    //  Constructor 
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function PolarTransform()
    {
        super();
    }
        
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  origin
    //----------------------------------

    /**
     *  @private
     *  Storage for the origin property.
     */
    private var _origin:Point;
    
    [Inspectable(environment="none")]

    /**
     *  The origin of the polar transform.
     *  This point is used by associated series to convert data units
     *  to screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get origin():Point
    {
        return _origin;
    }
    
    //----------------------------------
    //  radius
    //----------------------------------

    /**
     *  @private
     *  Storage for the radius property.
     */
    private var _radius:Number;
    
    [Inspectable(environment="none")]

    /**
     *  The radius used by the transform to convert data units
     *  to polar coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radius():Number
    {
        return _radius;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DataTransform
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function invertTransform(...values):Array /* of Object */
    {
        var result:Array /* of Object */ = [];
                
        if (values.length > 0 && values[0] != null)
        {
            result[0] =
                getAxis(ANGULAR_AXIS).invertTransform(values[0] / TWO_PI);
        }
        
        if (values.length > 1 && values[1] != null)
        {
            result[1] =
                getAxis(RADIAL_AXIS).invertTransform(values[1] / _radius);
        }
        
        return result;
    }

    /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function transformCache(cache:Array /* of Object */, aField:String,
                                            aConvertedField:String,
                                            rField:String,
                                            rConvertedField:String):void
    {
         var i:int;
         var v:Object;
         var n:int;
         if (aField != null)
         {
            getAxis(ANGULAR_AXIS).transformCache(cache, aField,
                                                 aConvertedField);
            n = cache.length;
            for (i = 0; i < n; i++)
            {
                v = cache[i][aConvertedField];
                if (v != null)
                    cache[i][aConvertedField] = Number(v) * TWO_PI;
            }
        }

        if (rField != null)
        {
            getAxis(RADIAL_AXIS).transformCache(cache, rField,
                                                rConvertedField);
            n = cache.length;
            for (i = 0; i < n; i++)
            {
                v = cache[i][rConvertedField];
                if (v != null)
                    cache[i][rConvertedField] = Number(v) * _radius;
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Methods 
    //
    //--------------------------------------------------------------------------

    /**
     *  Sets the width and height that the PolarTransform uses
     *  when calculating origin and radius.
     *  The containing chart calls this method.
     *  You should not generally call this method directly. 
     *  
     *  @param width The width, in pixels, of the PolarTransform.
     *  
     *  @param height The height, in pixels, of the PolarTransform. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setSize(width:Number, height:Number):void
    {
        _radius = Math.min(width / 2, height / 2);
        _origin = new Point(width / 2, height / 2);
    }
}

}
