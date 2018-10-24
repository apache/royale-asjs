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

/**
 *  The CartesianTransform object represents a set of axes 
 *  that maps data values to x/y Cartesian screen coordinates
 *  and vice versa.
 *
 *  <p>When using charts in your applications, you
 *  typically will not need to interact with the CartesianTransform object.
 *  Transforms are created automatically by the built-in chart types
 *  and used by the series contained within
 *  so that they can transform data into rendering coordinates.</p> 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class CartesianTransform extends DataTransform
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  A String representing the horizontal axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const HORIZONTAL_AXIS:String = "h";

    /**
     *  A String representing the vertical axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const VERTICAL_AXIS:String = "v";
    
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
    public function CartesianTransform()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  pixelWidth
    //----------------------------------

    /**
     *  @private
     */
    private var _pixelWidth:Number = 0;
    
    [Inspectable(environment="none")]

    /**
     *  The width of the data area that the CartesianTransform represents,
     *  in pixels.
     *  The containing chart sets this property explicitly during layout.  
     *  The CartesianTransform uses this property
     *  to map data values to screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set pixelWidth(value:Number):void
    {
        _pixelWidth = value;
    }

    //----------------------------------
    //  pixelHeight
    //----------------------------------

    /**
     *  @private
     */
    private var _pixelHeight:Number = 0;
    
    [Inspectable(environment="none")]

    /**
     *  The height of the data area that the CartesianTransform represents, 
     *  in pixels.
     *  The containing chart sets this property explicitly during layout.  
     *  The CartesianTransform uses this property
     *  to map data values to screen coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set pixelHeight(value:Number):void
    {
        _pixelHeight = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: DataTransform
    //
    //--------------------------------------------------------------------------

    /** 
     *  Transforms x and y coordinates relative to the DataTransform
     *  coordinate system into a 2-dimensional value in data space. 
     *  
     *  @param ...values The x and y positions (in that order).
     *  
     *  @return An Array containing the transformed values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */     
    override public function invertTransform(...values):Array /* of Object */
    {
        var xPos:Number = values[0] / _pixelWidth;
        var yPos:Number = 1 - values[1] / _pixelHeight;
        
        var xValue:Object = axes[HORIZONTAL_AXIS].invertTransform(xPos);
        var yValue:Object = axes[VERTICAL_AXIS].invertTransform(yPos);

        return [ xValue, yValue ];
    }
    
    /**
     *  Maps a set of numeric values representing data to screen coordinates.
     *  This method assumes the values are all numbers,
     *  so any non-numeric values must have been previously converted
     *  with the <code>mapCache()</code> method.
     *
     *  @param cache An array of objects containing the data values
     *  in their fields.
     *  This is also where this function stores the converted numeric values.
     *
     *  @param xField The field where the data values for the x axis are stored.
     *
     *  @param xConvertedField The field where the mapped x screen coordinate
     *  is stored.
     *
     *  @param yField The field where the data values for the y axis are stored.
     *
     *  @param yConvertedField The field where the mapped y screen coordinate
     *  is stored.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */     
    override public function transformCache(cache:Array /* of Object */,
                                            xField:String,
                                            xConvertedField:String,
                                            yField:String,
                                            yConvertedField:String):void
    {
        var w:Number = _pixelWidth;
        var h:Number = _pixelHeight;
        
        var c:Object;
        
        var len:uint = cache.length;
        if (len == 0)
            return;
        
        if (xField && xField != "")
            axes[HORIZONTAL_AXIS].transformCache(cache, xField, xConvertedField);

        if (yField && yField != "")
            axes[VERTICAL_AXIS].transformCache(cache, yField, yConvertedField);
            
        var i:int = len - 1;
        
        if (xConvertedField && xConvertedField.length &&
            yConvertedField && yConvertedField.length)
        {
            do
            {
                c = cache[i];
                c[xConvertedField] *= w;
                c[yConvertedField] = (1 - c[yConvertedField]) * h;
                i--;
            }
            while (i >= 0);
        }
        else if (xConvertedField && xConvertedField.length)
        {
            do
            {
                c = cache[i];
                c[xConvertedField] *= w;
                i--;
            }
            while (i >= 0);
        }
        else
        {
            do
            {
                c = cache[i];
                c[yConvertedField] = (1 - c[yConvertedField]) * h;
                i--;
            }
            while (i >= 0);
        }
    }
}

}
