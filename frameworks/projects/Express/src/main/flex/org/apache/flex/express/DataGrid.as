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
package org.apache.flex.express
{
	import org.apache.flex.html.DataGrid;
	import org.apache.flex.html.beads.DataGridColumnReorderView;
	import org.apache.flex.html.beads.SingleSelectionDragSourceBead;
	import org.apache.flex.html.beads.SingleSelectionDragImageBead;
	import org.apache.flex.html.beads.SingleSelectionDropTargetBead;
	import org.apache.flex.html.beads.SingleSelectionDropIndicatorBead;
	import org.apache.flex.html.beads.DataGridWithDrawingLayerLayout;
	import org.apache.flex.html.beads.DataGridDrawingLayerBead;

	/**
	 * This class extends DataGrid and adds beads for drag and drop and
	 * column reordering.
	 */
	public class DataGrid extends org.apache.flex.html.DataGrid
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
