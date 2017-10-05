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
package org.apache.flex.html.customControls.beads.models
{
	import org.apache.flex.core.IDataGridPresentationModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	public class DataGridPresentationModel extends EventDispatcher implements IDataGridPresentationModel
	{
		public function DataGridPresentationModel()
		{
			super();
		}
		
		private var _columnLabels:Array;
		public function get columnLabels():Array
		{
			return _columnLabels;
		}
		public function set columnLabels(value:Array):void
		{
			if (value != _columnLabels) {
				_columnLabels = value;
				dispatchEvent(new Event("columnsChanged"));
			}
		}
		
		private var _rowHeight:Number = 30;
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			if (value != _rowHeight) {
				_rowHeight = value;
				dispatchEvent(new Event("rowHeightChanged"));
			}
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}
