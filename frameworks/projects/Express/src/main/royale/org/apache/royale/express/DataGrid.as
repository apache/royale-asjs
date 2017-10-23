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
package org.apache.royale.express
{
	import org.apache.royale.html.DataGrid;
	import org.apache.royale.html.beads.DataGridColumnReorderView;
	import org.apache.royale.html.beads.SingleSelectionDragSourceBead;
	import org.apache.royale.html.beads.SingleSelectionDragImageBead;
	import org.apache.royale.html.beads.SingleSelectionDropTargetBead;
	import org.apache.royale.html.beads.SingleSelectionDropIndicatorBead;
	import org.apache.royale.html.beads.DataGridWithDrawingLayerLayout;
	import org.apache.royale.html.beads.DataGridDrawingLayerBead;

	/**
	 * This class extends DataGrid and adds beads for drag and drop and
	 * column reordering.
	 *
	 * @flexcomponent spark.components.DataGrid
	 * @flexdocurl https://flex.apache.org/asdoc/spark/components/DataGrid.html
	 * @commentary The Royale DataGrid is very similar to the Flex DataGrid. You define the DataGrid using DataGridColumn, assigning to each column a field in the data provider and an itemRenderer to display the data.
	 * @commentary The Royale Express DataGrid is packaged with support for drag-and-drop and column re-ordering.
	 * @example &lt;js:DataGrid width=\"300\" height=\"400\"&gt;
	 * @example &nbsp;&nbsp;&lt;js:beads&gt;
	 * @example &nbsp;&nbsp;&nbsp;&lt;js:ConstantBinding
	 * @example &nbsp;&nbsp;&nbsp;&nbsp;sourceID=\"applicationModel\"
	 * @example &nbsp;&nbsp;&nbsp;&nbsp;sourcePropertyName=\"productList\"
	 * @example &nbsp;&nbsp;&nbsp;&nbsp;destinationPropertyName=\"dataProvider\" /&gt;
	 * @example &nbsp;&nbsp;&lt;/js:beads&gt;
	 * @example &nbsp;&nbsp;&lt;js:columns&gt;
	 * @example &nbsp;&nbsp;&nbsp;&lt;js:DataGridColumn label=\"Image\" dataField=\"image\" columnWidth=\"50\" itemRenderer=\"products.ProductItemRenderer\" /&gt;
	 * @example &nbsp;&nbsp;&nbsp;&lt;js:DataGridColumn label=\"Title\" dataField=\"title\" columnWidth=\"150\" /&gt;
	 * @example &nbsp;&nbsp;&nbsp;&lt;js:DataGridColumn label=\"Sales\" dataField=\"sales\" columnWidth=\"100\" /&gt;
	 * @example &nbsp;&nbsp;&lt;/js:columns&gt;
	 * @example &lt;/js:DataGrid&gt;
	 */
	public class DataGrid extends org.apache.royale.html.DataGrid
	{
		public function DataGrid()
		{
			super();

			addBead(new SingleSelectionDragSourceBead());
			addBead(new SingleSelectionDragImageBead());
			addBead(new SingleSelectionDropTargetBead());
			addBead(new SingleSelectionDropIndicatorBead());
			addBead(new DataGridWithDrawingLayerLayout());
			addBead(new DataGridDrawingLayerBead());
			addBead(new DataGridColumnReorderView());
		}
	}
}
