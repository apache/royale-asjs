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
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	
	/**
	 *  The IChartItemRenderer interface is the interface implemented by any
	 *  class that draws chart graphics.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface IChartItemRenderer extends IItemRenderer
	{
		/**
		 *  The series to which this itemRenderer instance belongs. Or, the series
		 *  being presented.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get series():IChartSeries;
		function set series(value:IChartSeries):void;
		
		/**
		 *  The index of this itemRenderer instance with its series.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get index():int;
		function set index(value:int):void;
		
		/**
		 *  The name of the field containing the X-axis value found
		 *  in the data property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get xField():String;
		function set xField(value:String):void;
		
		/**
		 *  The name of the field containing the Y-axis value found
		 *  in the data property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get yField():String;
		function set yField(value:String):void;
		
		/**
		 *  The x display position for the itemRenderer. This is set by
		 *  the chart's layout manager.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function set x(value:Number):void;
		function get x():Number;
		
		/**
		 *  The y display position for the itemRenderer. This is set by
		 *  the chart's layout manager.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function set y(value:Number):void;
		function get y():Number;
		
		/**
		 *  The display width for the itemRenderer. This is set by
		 *  the chart's layout manager.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function set width(value:Number):void;
		
		/**
		 *  The display height for the itemRenderer. This is set by
		 *  the chart's layout manager.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function set height(value:Number):void;
		
		/**
		 * Invoke this function to force the itemRenderer to redraw.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function updateRenderer():void;
        
        /**
         * Invoke this function to force the itemRenderer to redraw.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get itemRendererOwnerView():IItemRendererOwnerView;
        function set itemRendererOwnerView(value:IItemRendererOwnerView):void;

	}
}
