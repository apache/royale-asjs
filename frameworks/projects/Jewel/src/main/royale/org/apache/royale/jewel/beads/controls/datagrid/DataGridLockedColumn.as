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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridButtonBar;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridListArea;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumnList;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumnWidth;
    import org.apache.royale.jewel.supportClasses.datagrid.DataGridColumn;
    import org.apache.royale.jewel.itemRenderers.DatagridHeaderRenderer;
    import org.apache.royale.jewel.beads.views.DataGridView;

	/**
	 *  The DataGridLockedColumn bead class is a specialty bead that can be use with a Jewel DataGrid control
	 *  when need to lock the columns
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.9
	 */
	public class DataGridLockedColumn implements IBead
	{
        private var view:IDataGridView;

        public var columnCount:int;

		public function DataGridLockedColumn()
		{
			super();
		}
        
		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
        public function set strand(value:IStrand):void
		{
            if (columnCount == 0)
                return;

            var dg:IDataGrid = value as IDataGrid;

            view = (dg as UIBase).view as DataGridView;
            (view.header as DataGridButtonBar).style = "overflow: visible";
            (view.listArea as DataGridListArea).style = "overflow: visible";
            view.header.addEventListener("headerLayout", headerLayoutHandler);
		}

        private function headerLayoutHandler(event:Event):void
        {
            var left:int = 0;
            for (var i:int = 0; i < columnCount; i++)
            {
                var width:int = ((view.header as DataGridButtonBar).buttonWidths[i] as DataGridColumnWidth).value;
                ((view.header as DataGridButtonBar).getElementAt(i) as DatagridHeaderRenderer).style = "position: sticky; left: " + left + "px; z-index: 100; width: " + width + "px;";
                (view.columnLists[i] as DataGridColumnList).style = "position: sticky; left: " + left + "px; z-index: 50;";
                if (((view.columnLists[i] as DataGridColumnList).columnInfo as DataGridColumn).visible)
                    left += width;
            }
        }
	}
}