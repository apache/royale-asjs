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
package org.apache.flex.html.staticControls.beads
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.html.staticControls.supportClasses.DataGridColumn;
	
	/**
	 *  The DataGridColumnView class extends ListView and provides properties to
	 *  the List that makes a column in the DataGrid.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataGridColumnView extends ListView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataGridColumnView()
		{
		}
		
		/**
		 * @private
		 */
		private var _strand:IStrand;
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
		}
		
		/**
		 *  The zero-based index for the column.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _columnIndex:uint;
		public function get columnIndex():uint
		{
			return _columnIndex;
		}
		public function set columnIndex(value:uint):void
		{
			_columnIndex = value;
		}
		
		/**
		 *  The DataGridColumn containing information used to present the List as
		 *  a column in the DataGrid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private var _column:DataGridColumn;
		public function get column():DataGridColumn
		{
			return _column;
		}
		public function set column(value:DataGridColumn):void
		{
			_column = value;
		}
	}
}