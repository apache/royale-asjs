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
package org.apache.royale.core
{
    /**
     *  The IRangeModel interface describes the minimum set of properties
     *  available to control that let the user select from within a
     *  range of numbers like NumericStepper and Slider.  More sophisticated controls
     *  could have models that extend IRangeModel.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IRangeModel extends IBeadModel
	{
        /**
         *  The maximum value.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get maximum():Number;
		function set maximum(value:Number):void;
		
        /**
         *  The minimum value.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get minimum():Number;
		function set minimum(value:Number):void;

        /**
         *  The interval that the value is rounded to
         *  when the user is drag selecting the value
         *  or entering an arbitrary value.  For example,
         *  if the snapInterval is 0.5, then only integers
         *  and values ending in 0.5 are selectable.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get snapInterval():Number;
		function set snapInterval(value:Number):void;

        /**
         *  The change in value by which the increment
         *  and decrement buttons and arrow keys will
         *  affect the curent value..
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get stepSize():Number;
		function set stepSize(value:Number):void;

        /**
         *  The current value.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get value():Number;
		function set value(value:Number):void;
}
}
