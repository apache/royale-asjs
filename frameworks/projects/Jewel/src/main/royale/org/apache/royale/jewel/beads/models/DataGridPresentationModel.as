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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel;
	
	/**
	 *  The DataGridPresentationModel class contains the data to label the columns
	 *  of the org.apache.royale.jewel.DataGrid along with the height of the rows or
	 *  the align of column labels. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGridPresentationModel extends DataGridColumnListPresentationModel implements IDataGridPresentationModel
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGridPresentationModel()
		{
			super();	
		}
		
		private var _columnLabels:Array;
		/**
		 *  The labels used in each column header.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		[Bindable("columnLabelsChanged")]
		public function get columnLabels():Array
		{
			return _columnLabels;
		}
		public function set columnLabels(value:Array):void
		{
			if (value != _columnLabels) {
				_columnLabels = value;
				if(_strand)
					(_strand as IEventDispatcher).dispatchEvent(new Event("columnLabelsChanged"));
			}
		}

		// private var _columnLabelAlign:String = "left"
		/**
		 *  How column label aligns in the header
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		// public function get columnLabelAlign():String
		// {
		// 	return _columnLabelAlign;
		// }
		// public function set columnLabelAlign(value:String):void
		// {
		// 	if (value != _columnLabelAlign) {
		// 		_columnLabelAlign = value;
		// 		dispatchEvent(new Event("columnsLabelAlignChanged"));
		// 	}
		// }
	}
}
