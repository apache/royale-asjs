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
package dataTable.mapper
{
	import dataTable.DataColumn;
	import dataTable.model.DataTableModel;
	
	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.Table;
	import org.apache.flex.html.TableCell;
	import org.apache.flex.html.TableHeader;
	import org.apache.flex.html.TableRow;
	import org.apache.flex.html.supportClasses.DataItemRenderer;
	
	public class DataTableMapperForArrayListData implements IBead
	{
		public function DataTableMapperForArrayListData()
		{
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("initComplete", handleInitComplete);
		}
		
		private function handleInitComplete(event:Event):void
		{
			var model:DataTableModel = _strand.getBeadByType(IBeadModel) as DataTableModel;
			if (model == null) return;
			
			var dp:ArrayList = model.dataProvider as ArrayList;
			if (dp == null || dp.length == 0) return;
			
			var table:Table = _strand as Table;
			
			var createHeaderRow:Boolean = false;
			for(var c:int=0; c < model.columns.length; c++)
			{
				var test:DataColumn = model.columns[c] as DataColumn;
				if (test.label != null) {
					createHeaderRow = true;
					break;
				}
			}
			
			if (createHeaderRow) {
				var headerRow:TableRow = new TableRow();
				
				for(c=0; c < model.columns.length; c++)
				{
					test = model.columns[c] as DataColumn;
					var tableHeader:TableHeader = new TableHeader();
					var label:Label = new Label();
					tableHeader.addElement(label);
					label.text = test.label == null ? "" : test.label;
					headerRow.addElement(tableHeader);
				}
				
				table.addElement(headerRow);
			}
			
			for(var i:int=0; i < dp.length; i++)
			{
				var tableRow:TableRow = new TableRow();
				
				for(var j:int=0; j < model.columns.length; j++)
				{
					var column:DataColumn = model.columns[j] as DataColumn;
					var tableCell:TableCell = new TableCell();
					
					var ir:DataItemRenderer = column.itemRenderer.newInstance() as DataItemRenderer;
					tableCell.addElement(ir);
					tableRow.addElement(tableCell);
					
					ir.labelField = column.dataField;
					ir.index = i;
					ir.data = dp.getItemAt(i);
				}
				
				table.addElement(tableRow);
			}
			
			table.dispatchEvent(new Event("layoutNeeded"));
		}
	}
}