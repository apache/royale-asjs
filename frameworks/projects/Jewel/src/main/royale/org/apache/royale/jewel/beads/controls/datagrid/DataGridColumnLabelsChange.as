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
package org.apache.royale.jewel.beads.controls.datagrid
{
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IDataGridHeader;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.DataGrid;
	import org.apache.royale.jewel.beads.views.DataGridView;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;
	import org.apache.royale.jewel.supportClasses.datagrid.IDataGridPresentationModel;

	/**
	 *  The DataGridColumnLabelsChange bead class is a specialty bead that can be use with a Jewel DataGrid control
	 *  when need to change column labels at runtime.
	 *  
	 *  Users can change labels throught datagrid presentation model "columnLabels" Array
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class DataGridColumnLabelsChange extends Bead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function DataGridColumnLabelsChange()
		{
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		override public function set strand(value:IStrand):void
		{	
			_strand = value;
			listenOnStrand("columnLabelsChanged", columnLabelsChangedHandler);
        }

		/**
		 *  Iterate the columns array and change each column's label with the corresponding string
		 *  in the presentation model columnLabels Array.
		 * 
		 *  @param event 
		 */
		protected function columnLabelsChangedHandler(event:Event):void
        {
			var _dg:DataGrid = _strand as DataGrid;
			var _sharedModel:IDataGridModel = _dg.model as IDataGridModel;
			var _presentationModel:IDataGridPresentationModel = _dg.presentationModel as IDataGridPresentationModel;
            var _header:IDataGridHeader = (_dg.view as DataGridView).header;

            var dp:Array = _sharedModel.columns as Array;
            var len:int = dp.length;
            for (var index:int = 0; index < len; index++)
            {
                var column:IDataGridColumn = dp[index] as IDataGridColumn;
                column.label = _presentationModel.columnLabels[index];
            }
            _header.dataProvider = new ArrayList(_sharedModel.columns);
        }
	}
}
