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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	import org.apache.royale.jewel.beads.models.TableModel;
	
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.Label;
	import org.apache.royale.jewel.Table;
	import org.apache.royale.jewel.TableCell;
	import org.apache.royale.jewel.TableHeader;
	import org.apache.royale.jewel.TableRow;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	
	public class TableMapperForArrayListData implements IBead
	{
		public function TableMapperForArrayListData()
		{
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("tableComplete", handleInitComplete);
		}
		
		private function handleInitComplete(event:Event):void
		{
			var model:TableModel = _strand.getBeadByType(IBeadModel) as TableModel;
			if (model == null) return;
			
			var dp:ArrayList = model.dataProvider as ArrayList;
			if (dp == null || dp.length == 0) return;
			
			var table:Table = _strand as Table;
			
			var createHeaderRow:Boolean = false;
			for(var c:int=0; c < model.columns.length; c++)
			{
				var test:TableColumn = model.columns[c] as TableColumn;
				if (test.label != null) {
					createHeaderRow = true;
					break;
				}
			}
			
			if (createHeaderRow) {
				var headerRow:TableRow = new TableRow();
				
				for(c=0; c < model.columns.length; c++)
				{
					test = model.columns[c] as TableColumn;
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
					var column:TableColumn = model.columns[j] as TableColumn;
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
