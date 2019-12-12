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
package org.apache.royale.jewel.beads.layouts
{	
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.models.ButtonBarModel;
    import org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn;
	
	/**
	 * DataGridLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DataGridLayout implements IBeadLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DataGridLayout()
		{
		}
		
		protected var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			(_strand as IEventDispatcher).addEventListener("widthChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("heightChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("sizeChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("layoutNeeded", handleLayoutNeeded);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function get uiHost():UIBase
		{
			return _strand as UIBase;
		}
		
		private function handleSizeChanges(event:Event):void
		{
			layout();
		}
		
		private function handleLayoutNeeded(event:Event):void
		{
			layout();
		}
		
		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         * @royaleignorecoercion org.apache.royale.core.IDataGridModel
         * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.datagrid.IDataGridColumn
		 */
		public function layout():Boolean
		{
			var header:IUIBase = (uiHost.view as IDataGridView).header;
            // fancier DG's will filter invisible columns and only put visible columns
            // in the bbmodel, so do all layout based on the bbmodel, not the set
            // of columns that may contain invisible columns
            var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
            var bblayout:ButtonBarLayout = header.getBeadByType(ButtonBarLayout) as ButtonBarLayout;
			// (header as ButtonBar).widthType = ButtonBarModel.PROPORTIONAL_WIDTHS;
			var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
			
			var displayedColumns:Array = (uiHost.view as IDataGridView).columnLists;
			var model:IDataGridModel = uiHost.model as IDataGridModel;
			
			var defaultColumnWidth:Number = (uiHost.percentWidth) / bbmodel.dataProvider.length;
			var columnWidths:Array = [];
			
			for(var i:int=0; i < bbmodel.dataProvider.length; i++) {
				var columnDef:IDataGridColumn = (bbmodel.dataProvider as ArrayList).getItemAt(i) as IDataGridColumn;
				var columnList:UIBase = displayedColumns[i] as UIBase;
				
				//temporal- if only 1 isNaN(columnDef.columnWidth) make it true so widthType = ButtonBarModel.PIXEL_WIDTHS
				var pixelflag:Boolean = false;
				var columnWidth:Number = defaultColumnWidth;
				if (!isNaN(columnDef.columnWidth)) {
					columnWidth = columnDef.columnWidth;
					pixelflag = true;
				}
				
				columnList.width = columnWidth;
				columnWidths.push(columnWidth);
			}
			
			bbmodel.buttonWidths = columnWidths;
			if(pixelflag)
			{
				// bbmodel.widthType = ButtonBarModel.PIXEL_WIDTHS;
				bblayout.widthType = ButtonBarModel.PIXEL_WIDTHS;
				// bblayout.layout();
			}
			
			header.dispatchEvent(new Event("layoutNeeded"));
			listArea.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
	}
}