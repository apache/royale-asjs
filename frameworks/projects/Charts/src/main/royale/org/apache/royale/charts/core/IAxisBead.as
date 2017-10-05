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
package org.apache.royale.charts.core
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.graphics.IStroke;
	
	public interface IAxisBead extends IBead
	{
		/**
		 * The placement of the axis with respect to the chart area. Valid
		 * values are: top, bottom (for IHorizontalAxisBeads), left, and right
		 * (for IVerticalAxisBeads).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get placement():String;
		function set placement(value:String):void;
		
		/**
		 * The stroke used for the axis line
		 */
		function get axisStroke():IStroke;
		function set axisStroke(value:IStroke):void;
		
		/**
		 * The stroked used for the tick marks
		 */
		function get tickStroke():IStroke;
		function set tickStroke(value:IStroke):void;
		
		/**
		 * The group space to use as the drawing area for the axis parts
		 * (lines, ticks, labels, etc.).
		 */
		function get axisGroup():IAxisGroup;
		function set axisGroup(value:IAxisGroup):void;
	}
}
