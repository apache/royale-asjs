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
    
    /**
     *  The ILayoutDirectionElement interface defines the minimum properties and methods 
     *  required for an Object to support the layoutDirection property.
     *  
     *  @see mx.core.LayoutDirection
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.1
     */
    public interface ILayoutDirectionElement
    {
        
        /**
         *  Specifies the desired layout direction for an element: one of LayoutDirection.LTR 
         *  (left to right), LayoutDirection.RTL (right to left), or null (inherit).   
         * 
         *  This property is typically backed by an inheriting style.  If null,
         *  the layoutDirection style will be set to undefined.
         * 
         *  Classes like GraphicElement, which implement ILayoutDirectionElement but do not 
         *  support styles, must additionally support a null value for this property 
         *  which means the layoutDirection must be inherited from its parent. 
         *  
         *  @see mx.core.LayoutDirection
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4.1
         */
        function get layoutDirection():String;
        
        /**
         *  @private
         */
        function set layoutDirection(value:String):void;
        
        /**
         *  An element must call this method when its layoutDirection changes or
         *  when its parent's layoutDirection changes.  
         * 
         *  If they differ, this method is responsible for mirroring the element’s contents
         *  and for updating the element’s post-layout transform so that descendants inherit
         *  a mirrored coordinate system.  IVisualElements typically implement
         *  mirroring by using postLayoutTransformOffsets to scale the X axis by -1 and 
         *  to translate the x coordinate of the origin by the element's width.
         * 
         *  The net effect of this "mirror" transform is to reverse the direction
         *  in which the X axis increases without changing the element's location
         *  relative to its parent's origin.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 1.5
         *  @productversion Flex 4.1
         */
        function invalidateLayoutDirection():void;
    }
}
