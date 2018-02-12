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
package org.apache.royale.express.supportClasses
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.html.List;
	import org.apache.royale.html.supportClasses.DataGridColumn;
	
	/**
	 * This class defines how a column in the DataGrid should look, including the label for
	 * the column and its width. In particular, the width may be given as a fixed pixel size
	 * (e.g., "80") or a percentage of the remaining space once all fixed-width columns have
	 * been taken into consideration (e.g., "100%"). That is, if the DataGrid has a width
	 * of 400 pixels with columns of "50", "100%", and "80", the "100%" column is the remainder
	 * of 400-50-80 or 260. If the DataGrid is resized to 500 pixels, the outer columns remain
	 * at 50 and 80 pixels, but the middle column expands to 360 pixels given its "100%" value.
	 */
	public class DataGridColumn extends org.apache.royale.html.supportClasses.DataGridColumn
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridColumn()
		{
			super();
		}
		
		private var _percentColumnWidth:Number = Number.NaN;
		
		/**
		 * Sets the size of the column as a percentage of the remaining space
		 * once the fixed columns have been accounted for.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get percentColumnWidth():Number
		{
			return _percentColumnWidth;
		}
		
		public function set percentColumnWidth(value:Number):void
		{
			_percentColumnWidth = value;
			_columnWidth= Number.NaN;
		}
		
		private var _columnWidth:Number = Number.NaN;
		
		/**
		 * Sets the size of the column as a fixed pixel width. In MXML you can set
		 * this propery as a percentage (e.g., columnWidth="75%") and it will automatically
		 * transfer to the percentWidth as 75.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		[PercentProxy("percentColumnWidth")]
		override public function get columnWidth():Number
		{
			return _columnWidth;
		}
		
		[PercentProxy("percentColumnWidth")]
		override public function set columnWidth(value:Number):void
		{
			_columnWidth = value;
			_percentColumnWidth = Number.NaN;
		}
		
	}
}