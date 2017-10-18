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
package org.apache.royale.mdl.supportClasses
{
    /**
     *  The IMdlTextColor interface must be implemented by any class that
     *  will apply textColor and textColorWeight provided by google style color.
     *
     *  https://material.google.com/style/color.html#color-color-palette
     *  https://gitlab.com/material/colors/blob/master/colors.html
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public interface IMdlTextColor
    {
        /**
         * Color name provided by color palette
         * Text color
         *
         * https://material.google.com/style/color.html#color-color-palette
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        function get textColor():String;
        function set textColor(value:String):void;

        /**
         * Color weight provided by color palette
         * Text color weight
         *
         * https://material.google.com/style/color.html#color-color-palette
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        function get textColorWeight():String;
        function set textColorWeight(value:String):void;
    }
}
