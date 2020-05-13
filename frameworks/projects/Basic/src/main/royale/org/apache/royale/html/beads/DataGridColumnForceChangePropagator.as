
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
package org.apache.royale.html.beads
{
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IChangePropagator;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.supportClasses.DataGridColumnList;
	import org.apache.royale.html.supportClasses.DataGridColumn;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.sendBeadEvent;
	/**
	 *  The DataGridColumnForceChangePropagator picks up the dataProviderChanged event
	 *  and lets the data grid columns know about it, whether or not the data provider object was changed.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DataGridColumnForceChangePropagator implements IChangePropagator
	{
		
		private var _strand:IStrand;
		
		public function DataGridColumnForceChangePropagator()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			var model:IEventDispatcher = value.getBeadByType(IBeadModel) as IEventDispatcher;
			model.addEventListener('dataProviderChanged', handleDataProviderChanged);
		}
		
		protected function handleDataProviderChanged(e:Event):void
		{
			var dataGridView:IDataGridView = _strand.getBeadByType(IDataGridView) as IDataGridView;
			var lists:Array = dataGridView.columnLists;
			var sharedModel:IDataGridModel = _strand.getBeadByType(IBeadModel) as IDataGridModel;
			for (var i:int=0; i < lists.length; i++)
			{
				var list:DataGridColumnList = lists[i] as DataGridColumnList;
				var listModel:ISelectionModel = list.getBeadByType(IBeadModel) as ISelectionModel;
				if (listModel.dataProvider != sharedModel.dataProvider)
				{
					listModel.dataProvider = sharedModel.dataProvider;
				} else
				{
					sendBeadEvent(listModel,'dataProviderChanged');
				}
			}
		}
	}
}
