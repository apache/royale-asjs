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

package mx.core
{

import org.apache.royale.geom.Rectangle;

/**
 *  The IRectangularBorder interface defines the interface that all classes 
 *  used for rectangular border skins should implement.
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IRectangularBorder extends IBorder
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  backgroundImageBounds
    //----------------------------------

    /**
     *  @copy mx.skins.RectangularBorder#backgroundImageBounds
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get backgroundImageBounds():Rectangle;
    function set backgroundImageBounds(value:Rectangle):void;

    //----------------------------------
    //  hasBackgroundImage
    //----------------------------------

    /**
     *  @copy mx.skins.RectangularBorder#hasBackgroundImage
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get hasBackgroundImage():Boolean;

    //----------------------------------
    //  adjustBackgroundImage
    //----------------------------------

    /**
     *  @copy mx.skins.RectangularBorder#layoutBackgroundImage()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function layoutBackgroundImage():void;
}

}
