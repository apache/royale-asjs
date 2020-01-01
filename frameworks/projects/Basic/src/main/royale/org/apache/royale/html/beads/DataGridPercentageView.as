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
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.DataGridButtonBar;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.supportClasses.IDataGridColumn;
	import org.apache.royale.utils.sendEvent;

	/**
	 *  The DataGridPercentageView class is the visual bead for the org.apache.royale.html.DataGrid.
	 *  This class constructs the items that make the DataGrid: Lists for each column and a
	 *  org.apache.royale.html.ButtonBar for the column headers. This class interprets the
	 *  columnWidth value of each column to be a percentage rather than a pixel value.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridPercentageView extends DataGridView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridPercentageView()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);

			if (columnLists)
			{
				var host:UIBase = _strand as UIBase;
				var sharedModel:IDataGridModel = host.model as IDataGridModel;
				var columnListCount:int = sharedModel.columns.length;
				var buttonWidths:Array = [];

				for (var i:int = 0; i < columnListCount; i++)
				{
					var dgc:IDataGridColumn = sharedModel.columns[i] as IDataGridColumn;
					var colWidth:Number = dgc.columnWidth;
					buttonWidths.push(colWidth);

					var list:UIBase = columnLists[i] as UIBase;
					if (!isNaN(dgc.columnWidth))
					{
						list.width = NaN;
						list.percentWidth = Number(colWidth);
					}
				}

				var dgButtonBar:DataGridButtonBar = header as DataGridButtonBar;
				dgButtonBar.buttonWidths = buttonWidths;
				dgButtonBar.widthType = ButtonBarModel.PERCENT_WIDTHS;
				sendEvent(dgButtonBar,"layoutNeeded");
			}
		}
	}
}

