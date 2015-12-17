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
package org.apache.flex.geom
{
COMPILE::AS3
{
    import flash.geom.Rectangle;
}

/**
 *  The Rectangle class is a utility class for holding four coordinates of
 *  a rectangle
 *  
 *  The ActionScript version simply wraps flash.geom.Rectangle to enable cross
 *  compilation.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
COMPILE::AS3
public class Rectangle extends flash.geom.Rectangle
{
    public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
    {
        super(x, y, width, height);
    }
}

/**
 *  The Rectangle class is a utility class for holding four coordinates of
 *  a rectangle
 *  
 *  The ActionScript version simply wraps flash.geom.Rectangle to enable cross
 *  compilation.
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
 */
COMPILE::JS
public class Rectangle
{
    public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
    {
        left = x;
        top = y;
        this.width = width;
        this.height = height;
    }
    
    public var left:Number;
    public var top:Number;
    public var width:Number;
    public var height:Number;

    public function get right():Number
    {
        return left + width;
    }
    public function set right(value:Number):void
    {
        width = value - left;
    }
    
    public function get bottom():Number
    {
        return top + height;
    }
    public function set bottom(value:Number):void
    {
        height = value - top;
    }
}


}
