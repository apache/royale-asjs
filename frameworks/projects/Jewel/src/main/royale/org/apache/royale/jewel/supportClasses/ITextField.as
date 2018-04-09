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
package org.apache.royale.jewel.supportClasses
{
    /**
     *  ITextField is the interface that all text jewel classes.
     *  It's used mainly in org.apache.royale.jewel.supportClasses.TextFieldBase
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 9.2
     */
    public interface ITextField
    {
        COMPILE::JS
        {
            /**
            * the textNode
            *
            * @langversion 3.0
            * @playerversion Flash 10.2
            * @playerversion AIR 2.6
            * @productversion Royale 0.9.2
            */
            function get textNode():Text;
            function set textNode(value:Text):void;

            /**
            * the input
            *
            * @langversion 3.0
            * @playerversion Flash 10.2
            * @playerversion AIR 2.6
            * @productversion Royale 0.9.2
            */
            function get input():HTMLInputElement;
            function set input(value:HTMLInputElement):void;

            /**
            * the label
            *
            * @langversion 3.0
            * @playerversion Flash 10.2
            * @playerversion AIR 2.6
            * @productversion Royale 0.9.2
            */
            function get label():HTMLLabelElement;
            function set label(value:HTMLLabelElement):void;
        }
    }
}
