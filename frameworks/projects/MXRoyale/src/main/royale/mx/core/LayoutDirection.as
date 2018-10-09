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
     *  The LayoutDirection class defines the constant values
     *  for the <code>layoutDirection</code> style of an IStyleClient and the 
     *  <code>layoutDirection</code> property of an ILayoutDirectionElement.
     *  
     *  Left-to-right layoutDirection is typically used with Latin-style 
     *  scripts. Right-to-left layoutDirection is used with scripts such as 
     *  Arabic or Hebrew.
     * 
     *  If an IStyleClient, set the layoutDirection style to undefined to
     *  inherit the layoutDirection from its ancestor.
     * 
     *  If an ILayoutDirectionElement, set the layoutDirection property to null to
     *  inherit the layoutDirection from its ancestor.
     * 
     *  @see mx.styles.IStyleClient
     *  @see mx.core.ILayoutDirectionElement
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.1
     */
    public final class LayoutDirection
    {
        // include "Version.as";
        
        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------
        
        /**
         *  Specifies left-to-right layout direction for a style client or a
         *  visual element.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.0
         *  @productversion Flex 4.1
         */
        public static const LTR:String = "ltr";
        
        /**
         *  Specifies right-to-left layout direction for a style client or a
         *  visual element.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.0
         *  @productversion Flex 4.1
         */
        public static const RTL:String = "rtl";
    }
}
