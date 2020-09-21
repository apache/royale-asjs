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
	import org.apache.royale.collections.IArrayListView;
	import org.apache.royale.collections.Sort;
	import org.apache.royale.collections.SortField;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.DataGrid;
	import org.apache.royale.jewel.beads.views.DataGridView;
	import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumn;
	import org.apache.royale.core.IDataGridHeader;

	/**
	 *  The DataGridSort bead class is a specialty bead that can be use with a Jewel DataGrid control
	 *  when need to add sorting capabilities pushing the header's buttons.
	 * 
	 *  Note that dataProvider need to be IArrayListView to have sorting capabilities for this bead to work
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DataGridSort implements IBead
	{
		public function DataGridSort()
		{
			super();
		}
		
        private var dg:DataGrid;
        private var header:IDataGridHeader;

		private var descending:Boolean;
        
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function set strand(value:IStrand):void
		{
            dg = value as DataGrid;
			var dgView:DataGridView = dg.view as DataGridView;
			header = dgView.header;
			header.addEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		/**
		 * @private
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		protected function mouseClickHandler(event:MouseEvent):void
		{
            // probably down on one button and up on another button
            // so the ButtonBar won't change selection
            if (event.target == header) return;
			var column:DataGridColumn = event.target.data as DataGridColumn;
			var collection:IArrayListView = dg.dataProvider as IArrayListView;
			if (collection && collection.length)
			{
				if (collection.sort && collection.sort.fields[0].name == column.dataField)
					descending = !descending;

				var sort:Sort = new Sort();
				var sortField:SortField = new SortField(column.dataField, false, descending);

				sort.fields = [ sortField ];
				collection.sort = sort;

				// force redraw of column headers
				collection.refresh();
				
				dg.model.dispatchEvent(new Event("sortChanged"));
				header.model.dispatchEvent(new Event("dataProviderChanged"));
			}
		}
	}
}