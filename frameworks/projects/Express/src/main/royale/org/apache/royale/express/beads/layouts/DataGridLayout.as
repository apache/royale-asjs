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
package org.apache.royale.express.beads.layouts
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.express.supportClasses.DataGridColumn;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.IDrawingLayerBead;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.supportClasses.ScrollingViewport;
	
	/**
	 * This DataGridLayout class sizes and positions all of the elements of the DataGrid
	 * in the Express package. The ButtonBar header, the container content area for the
	 * the list columns, and the positioning and sizing of the list columns within that
	 * container. On top of the contain a drawing layer is floating to allow for the
	 * graphics of a drag-and-drop indicator.
	 */
	public class DataGridLayout implements IBeadLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function get uiHost():UIBase
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
		 * This layout algorithm handles columns of both pixel and percent widths. The percent
		 * width represents the amount of space remaining after the fixed width columns have
		 * been placed. For example, with three columns of widths, "50", "100%", and "80" the
		 * 100% size represents the amount left over after the 130 pixels have been removed from
		 * whatever width the DataGrid currently has at the time this layout is executed.
		 * 
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.IParent
		 * @royaleignorecoercion org.apache.royale.core.ILayoutChild
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 * @royaleemitcoercion org.apache.royale.html.supportClasses.DataGridColumn
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 * @royaleignorecoercion org.apache.royale.html.beads.IDrawingLayerBead
		 */
		public function layout():Boolean
		{
			var header:IUIBase = (uiHost.view as IDataGridView).header;
			var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
			
			var displayedColumns:Array = (uiHost.view as IDataGridView).columnLists;
			var model:IDataGridModel = uiHost.model as IDataGridModel;
			
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);			
			var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
			var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom);
			
			var xpos:Number = 0;
			var defaultColumnWidth:Number = (useWidth) / model.columns.length;
			var columnWidths:Array = [];
			
			// first determine the amount of space remaining once the fixed width
			// columns are accounted for.
			var remainingSpace:Number = useWidth;
			for (var i:int=0; i < displayedColumns.length; i++) {
				var columnDef:DataGridColumn = model.columns[i] as DataGridColumn;
				if (isNaN(columnDef.percentColumnWidth) && !isNaN(columnDef.columnWidth)) {
					remainingSpace -= (columnDef.columnWidth / uiHost.width) * useWidth;
				}
			}
			
			for(i=0; i < displayedColumns.length; i++) {
				columnDef = model.columns[i] as DataGridColumn;
				var columnList:IUIBase = displayedColumns[i] as IUIBase;
				
				// probably do not need to set (x,y), but if the Container's layout requires it, they will be set.
				columnList.x = xpos;
				columnList.y = 0;
				
				var columnWidth:Number = defaultColumnWidth;
				if (isNaN(columnDef.columnWidth) && !isNaN(columnDef.percentColumnWidth)) {
					columnWidth = (columnDef.percentColumnWidth/100.0) * remainingSpace;
				}
				else if (isNaN(columnDef.percentColumnWidth) && !isNaN(columnDef.columnWidth)) {
					columnWidth = (columnDef.columnWidth / uiHost.width) * useWidth;
				}
				
				columnList.width = columnWidth;
				columnWidths.push(columnWidth);
				
				xpos += columnList.width;
			}
			
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.buttonWidths = columnWidths;
			
			header.x = borderMetrics.left;
			header.y = borderMetrics.top;
			COMPILE::SWF {
				header.width = useWidth;
			}
			COMPILE::JS {
				(header as ILayoutChild).percentWidth = 100;
			}
			// header's height is set in CSS
			
			listArea.x = borderMetrics.left;
			listArea.y = header.height + header.y;
			COMPILE::SWF {
				listArea.width = useWidth;
			}
			COMPILE::JS {
				(listArea as ILayoutChild).percentWidth = 100;
			}
			listArea.height = useHeight - header.height;
			
			// Get the drawing layer, if there is one, so it can be positioned at the
			// top of the z-order and sized properly.
			var layerBead:IDrawingLayerBead = _strand.getBeadByType(IDrawingLayerBead) as IDrawingLayerBead;
			
			// Put the drawing layer back, sizing it to fit over the listArea.
			if (layerBead != null && layerBead.layer != null) {				
				IParent(_strand).removeElement(layerBead.layer);
				IParent(_strand).addElement(layerBead.layer); // always keep it on top
				
				var layerX:Number = listArea.x;
				var layerY:Number = listArea.y;
				useWidth = listArea.width;
				useHeight = listArea.height;
				
				COMPILE::SWF {
					var scrollViewport:ScrollingViewport = listArea.getBeadByType(ScrollingViewport) as ScrollingViewport;
					if (scrollViewport) {
						var vbar:UIBase = scrollViewport.verticalScroller as UIBase;
						if (vbar != null && vbar.visible) useWidth -= vbar.width;
						var hbar:UIBase = scrollViewport.horizontalScroller as UIBase;
						if (hbar != null && hbar.visible) useHeight -= hbar.height;
					}
				}
					
				layerBead.layer.x = layerX;
				layerBead.layer.y = layerY;
				layerBead.layer.setWidthAndHeight(useWidth, useHeight, true);
			}
			
			header.dispatchEvent(new Event("layoutNeeded"));
			listArea.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
	}
}