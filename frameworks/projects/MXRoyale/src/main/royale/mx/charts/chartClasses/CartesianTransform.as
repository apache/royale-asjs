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
 *  @productversion Royale 0.9.3
 */
public class CartesianTransform extends DataTransform
{
  //  include "../../core/Version.as";

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
     *  @productversion Royale 0.9.3
     */
    public static const HORIZONTAL_AXIS:String = "h";

    /**
     *  A String representing the vertical axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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
     *  @productversion Royale 0.9.3
     */
    public function CartesianTransform()
    {
        super();
    }

   
}

}
