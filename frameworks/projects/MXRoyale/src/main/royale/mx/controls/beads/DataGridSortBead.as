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
package mx.controls.beads
{
	import mx.controls.DataGrid;
	import mx.controls.beads.DataGridView;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.collections.ICollectionView;
	import mx.collections.ISort;
	import mx.collections.Sort;
	import mx.collections.SortField;

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.DataGridButtonBar;
    
	public class DataGridSortBead implements IBead
	{
		public function DataGridSortBead()
		{
			super();
		}
		
        private var dg:DataGrid;
        
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
            dg = value as DataGrid;
			(dg.view as DataGridView).header.addEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		/**
		 * @private
		 */
		private function mouseClickHandler(event:MouseEvent):void
		{
			var dgView:DataGridView = dg.view as DataGridView;
            var buttonBar:DataGridButtonBar = (dgView.header as DataGridButtonBar);
            // probably down on one button and up on another button
            // so the ButtonBar won't change selection
            if (event.target == buttonBar) return;
			var column:DataGridColumn = event.target.data as DataGridColumn;
			if (column && !column.sortable) {
				//ignore clicks on headers of columns that are not sortable
				return;
			}
			var collection:ICollectionView = dg.dataProvider as ICollectionView;
			if (collection && collection.length) {

				var oldSort:ISort = collection.sort;
				var sort:Sort = new Sort();
				var sortField:SortField = new SortField();
				sortField.name = column.dataField;

				if (oldSort && oldSort.fields[0].name == sortField.name)
					column.sortDescending = !column.sortDescending;
				sortField.descending = column.sortDescending;

				sort.fields = [ sortField ];
				collection.sort = sort;
				collection.refresh();
				// force redraw of column headers
				(dgView.header as DataGridButtonBar).model.dispatchEvent(new Event("dataProviderChanged"));
			}
		}

	}
}