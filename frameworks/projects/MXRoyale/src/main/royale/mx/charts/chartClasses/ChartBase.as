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
package mx.charts.chartClasses
{
	import org.apache.royale.charts.core.ChartBase;
	/**
	 *  The ChartBase class contains all of the properties common to most
	 *  charts. Some charts may not make any or full use of the properties
	 *  however.
	 * 
	 *  A chart is based on List which provides data and item renderers to
	 *  draw the chart graphics. Charts are essentially lists with a
	 *  different visualization.
	 * 
	 *  Similar to a List, the chart's layout provides the structure of
	 *  chart while the itemRenderers take care of the actual drawing.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ChartBase extends org.apache.royale.charts.core.ChartBase
	{
	 /**
     *  @private
     */
    private var _showDataTips:Boolean = false;
	
		/**
		 *  constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function ChartBase()
		{
			super();
			
		}
		/**
     *  Specifies whether Flex shows DataTip controls for the chart.
     *  DataTip controls are similar to tool tips,
     *  except that they display an appropriate value
     *  that represents the nearest chart data point under the mouse pointer.
     *  
     *  <p>Different chart elements might show different styles
     *  of DataTip controls.
     *  For example, a stacked chart element might show both the values
     *  of the column and the percentage that it contributes to the whole.</p>
     *
     *  <p>You can customize DataTip controls with the
     *  <code>dataTipFunction</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
		public function get showDataTips():Boolean
		{
			return _showDataTips;
		}

		/**
		 *  @private
		 */
		public function set showDataTips(value:Boolean):void
		{
			/* if (_showDataTips == value)
				return;
				
			_showDataTips = value;

			if (_showDataTips)
			{
				if (_mouseEventsInitialzed == false)
					setupMouseDispatching();
			}

			updateDataTips(); */
		}
    
	}
}
