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
package org.apache.royale.charts.supportClasses
{
	import org.apache.royale.charts.core.IChartItemRenderer;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;

	/**
	 *  The IWedgeItemRenderer interface must be implemented by any class that
	 *  is used as an itemRenderer for a PieSeries. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IWedgeItemRenderer extends IChartItemRenderer
	{
		/**
		 *  The X coordinate of the center point of the pie. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get centerX():Number;
		function set centerX(value:Number):void;
		
		/**
		 *  The Y coordinate of the center of the pie.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get centerY():Number;
		function set centerY(value:Number):void;
		
		/**
		 *  The angle (radians) at which the wedge begins. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get startAngle():Number;
		function set startAngle(value:Number):void;
		
		/**
		 *  The sweep (radians) of the wedge relative to the startAngle. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get arc():Number;
		function set arc(value:Number):void;
		
		/**
		 *  The radius of the pie. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get radius():Number;
		function set radius(value:Number):void;
		
		/**
		 *  The color of the wedge. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get fill():IFill;
		function set fill(value:IFill):void;
		
		/**
		 *  The color of the outline of the wedge. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get stroke():IStroke;
		function set stroke(value:IStroke):void;
	}
}
