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
package org.apache.royale.html.beads.layouts
{	
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.ButtonBar;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.supportClasses.IDataGridColumn;
	
	/**
	 * DataGridPercentageLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns. The columns are sized on their
	 * percentage of the width of the DataGrid space.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridPercentageLayout extends DataGridLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridPercentageLayout()
		{
			super();
		}
		
		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
     * @royaleignorecoercion org.apache.royale.core.UIBase
     * @royaleignorecoercion org.apache.royale.core.IDataGridModel
     * @royaleignorecoercion org.apache.royale.html.ButtonBar
     * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
     * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumn
		 */
		override public function layout():Boolean
		{			
			// call the super function to get the basics laid out even
			// though the columns and header will not be right.
			if (!super.layout()) return false;
			
			var host:UIBase = _strand as UIBase;
			var header:IUIBase = (host.view as IDataGridView).header;
			var sharedModel:IDataGridModel = host.model as IDataGridModel;
			var columnLists:Array = (host.view as IDataGridView).columnLists;
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
			
			// list area needs a layout refresh because its contents were changed from
			// fixed size to percent size.
			var listArea:IUIBase = (host.view as IDataGridView).listArea;
			listArea.dispatchEvent(new Event("layoutNeeded"));
			
			var dgButtonBar:ButtonBar = header as ButtonBar;
			dgButtonBar.buttonWidths = buttonWidths;
			dgButtonBar.widthType = ButtonBarModel.PERCENT_WIDTHS;
			dgButtonBar.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
	}
}
