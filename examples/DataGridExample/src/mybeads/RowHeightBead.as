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
package mybeads
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.List;
	import org.apache.flex.html.beads.DataGridView;
	import org.apache.flex.html.beads.IListView;
	
	public class RowHeightBead implements IBead
	{
		public function RowHeightBead()
		{
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			IEventDispatcher(_strand).addEventListener("layoutComplete",handleLayoutComplete);
		}
		
		private var _rowHeight:Number = 30;
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
			// dispatch some event which will trigger layout recalculation
		}
		
		private var _minRowHeight:Number = 30;
		public function get minRowHeight():Number
		{
			return _minRowHeight;
		}
		public function set minRowHeight(value:Number):void
		{
			_minRowHeight = value;
			// dispatch some event which will trigger layout recalculation
		}
		
		private var _variableRowHeight:Boolean = false;
		public function get variableRowHeight():Boolean
		{
			return _variableRowHeight;
		}
		public function set variableRowHeight(value:Boolean):void
		{
			_variableRowHeight = value;
			// dispatch some event which will trigger a layout recalculation
		}
		
		private function handleLayoutComplete(event:Event):void
		{
			if (variableRowHeight) {
				makeAllRowsVariableHeight(minRowHeight);
			}
			else {
				makeAllRowsSameHeight(rowHeight);
			}
		}
		
		private function makeAllRowsSameHeight(newHeight:Number):void
		{
			// this function forces every cell in the DataGrid to be the same height
			var view:DataGridView = _strand.getBeadByType(DataGridView) as DataGridView;
			var lists:Array = view.getColumnLists();
			
			for(var i:int=0; i < lists.length; i++)
			{
				var list:List = lists[i] as List;
				var listView:IListView = list.getBeadByType(IListView) as IListView;
				var p:IItemRendererParent = listView.dataGroup;
				var n:Number = (list.dataProvider as Array).length;

				for(var j:int=0; j < n; j++)
				{
					var c:UIBase = p.getItemRendererForIndex(j) as UIBase;
					c.height = newHeight;
				}
				
				IEventDispatcher(list).dispatchEvent( new Event("layoutNeeded") );
			}
		}
		
		private function makeAllRowsVariableHeight(minHeight:Number):void
		{
			// this function makes every cell in a row the same height
			// (at least minHeight) but all the rows can have different
			// heights
			var view:DataGridView = _strand.getBeadByType(DataGridView) as DataGridView;
			var lists:Array = view.getColumnLists();
			
			// future: maybe IDataGridModel.dataProvider should implement IDataProvider which
			// can have a length property and not assume that the .dataProvider is an Array.
			var n:Number = ((_strand.getBeadByType(IDataGridModel) as IDataGridModel).dataProvider as Array).length;
			
			for(var i:int=0; i < n; i++)
			{
				var maxHeight:Number = minHeight;
				for(var j:int=0; j < lists.length; j++)
				{
					var list:List = lists[j] as List;
					var listView:IListView = list.getBeadByType(IListView) as IListView;
					var p:IItemRendererParent = listView.dataGroup;
					var c:UIBase = p.getItemRendererForIndex(i) as UIBase;
					maxHeight = Math.max(maxHeight,c.height);
				}
				for(j=0; j < lists.length; j++)
				{
					list = lists[j] as List;
					listView = list.getBeadByType(IListView) as IListView;
					p = listView.dataGroup;
					c = p.getItemRendererForIndex(i) as UIBase;
					c.height = maxHeight;
				}
			}
			
			for(j=0; j < lists.length; j++)
			{
				list = lists[j] as List;
				IEventDispatcher(list).dispatchEvent( new Event("layoutNeeded") );
			}
		}
	}
}
