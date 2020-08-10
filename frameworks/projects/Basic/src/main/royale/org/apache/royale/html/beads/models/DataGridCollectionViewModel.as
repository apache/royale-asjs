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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.html.beads.models.SingleSelectionCollectionViewModel;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.events.Event;

	/**
	 *  The DataGridCollectiomModel class bead extends org.apache.royale.html.beads.models.SingleSelectionCollectionViewModel
	 *  to facilitate using an ICollectionView as the dataProvider for the DataGrid. Use this with
	 *  org.apache.royale.html.beads.DataItemRenderFactoryForCollectionView for each DataGridColumn.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridCollectionViewModel extends SingleSelectionCollectionViewModel implements IDataGridModel
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridCollectionViewModel()
		{
			super();
		}

		private var _columns:Array;

		/**
		 *  The array of org.apache.royale.html.supportClasses.DataGridColumns used to
		 *  define each column of the org.apache.royale.html.DataGrid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get columns():Array
		{
			return _columns ? _columns.slice() : []; //return a copy. Internal state is not externally mutable
		}
		public function set columns(value:Array):void
		{
			var change:Boolean;
			var oldCols:Array = _columns;
			if (oldCols) {
				var l:uint = oldCols.length;
				if (value) {
					change = value.length != l; //different columns lengths
					if (!change) {
						for (var i:uint = 0; i < l; i++) {
							if (oldCols[i] != value[i]) {
								change = true; //at least one non-matching column
								break;
							}
						}
					}
				} else {
					change = l > 0; //reset to empty
				}
			} else {
				change = value && value.length; //set to something after previously empty
			}
			if (change) {
				_columns = value ? value.slice() : [];
				dispatchEvent( new Event("columnsChanged"));
			}
		}

		private var _headerModel:IBeadModel;

		/**
		 * The model to use for the DataGrid's header.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get headerModel():IBeadModel
		{
			return _headerModel;
		}
		public function set headerModel(value:IBeadModel):void
		{
			if (_headerModel != value) {
				_headerModel = value;
				dispatchEvent(new Event("headerModelChanged"));

				_headerModel.addEventListener("dataProviderChanged", handleHeaderModelChange);
			}
		}

		private function handleHeaderModelChange(event:Event):void
		{
			dispatchEvent(new Event("headerModelChanged"));
		}
	}
}
