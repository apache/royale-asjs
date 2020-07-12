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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.ILayoutHost;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.html.beads.DataGridView;
    import org.apache.royale.html.beads.IDataGridView;
    import org.apache.royale.html.beads.models.ButtonBarModel;
    import org.apache.royale.html.supportClasses.IDataGridColumn;
    import org.apache.royale.core.Bead;
	
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
	public class DataGridLayout extends Bead implements IBeadLayout
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
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			listenOnStrand("widthChanged", handleSizeChanges);
			listenOnStrand("heightChanged", handleSizeChanges);
			listenOnStrand("sizeChanged", handleSizeChanges);
			listenOnStrand("layoutNeeded", handleLayoutNeeded);
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function get uiHost():UIBase
		{
			return _strand as UIBase;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 */
		private function handleSizeChanges(event:Event):void
		{
			var viewBead:ILayoutHost = uiHost.view as ILayoutHost;
			if (viewBead.beforeLayout())
				layout();
		}
		
		private function handleLayoutNeeded(event:Event):void
		{
			var viewBead:ILayoutHost = uiHost.view as ILayoutHost;
			if (viewBead.beforeLayout())
				layout();
		}
		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 * @royaleignorecoercion Array
		 */
		protected function getColumnsForLayout():Array
		{
			var header:IUIBase = (uiHost.view as IDataGridView).header;
			// fancier DG's will filter invisible columns and only put visible columns
			// in the bbmodel, so do all layout based on the bbmodel, not the set
			// of columns that may contain invisible columns
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			return bbmodel.dataProvider as Array;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 */
		protected function setHeaderWidths(columnWidths:Array):void
		{
			var header:IUIBase = (uiHost.view as IDataGridView).header;
			// fancier DG's will filter invisible columns and only put visible columns
			// in the bbmodel, so do all layout based on the bbmodel, not the set
			// of columns that may contain invisible columns
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.buttonWidths = columnWidths;
		}
        
		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 * @royaleignorecoercion org.apache.royale.core.IDataGridModel
		 * @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
		 * @royaleignorecoercion org.apache.royale.html.beads.models.ButtonBarModel
		 * @royaleignorecoercion org.apache.royale.html.supportClasses.IDataGridColumn
		 */
		public function layout():Boolean
		{
			var header:IUIBase = (uiHost.view as IDataGridView).header;
            var arrayOfColumns:Array = getColumnsForLayout();
			var listArea:IUIBase = (uiHost.view as IDataGridView).listArea;
			
			var displayedColumns:Array = (uiHost.view as IDataGridView).columnLists;
			var model:IDataGridModel = uiHost.model as IDataGridModel;
			
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);			
			var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
			var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom);
			
			var xpos:Number = 0;
			var defaultColumnWidth:Number = (useWidth) / arrayOfColumns.length;
			var columnWidths:Array = [];
			
			for(var i:int=0; i < arrayOfColumns.length; i++) {
				var columnDef:IDataGridColumn = arrayOfColumns[i] as IDataGridColumn;
				var columnList:UIBase = displayedColumns[i] as UIBase;
				
				// probably do not need to set (x,y), but if the Container's layout requires it, they will be set.
				columnList.x = xpos;
				columnList.y = 0;
				
				var columnWidth:Number = defaultColumnWidth;
				if (!isNaN(columnDef.columnWidth)) {
					columnWidth = columnDef.columnWidth;
				}
				
				columnList.width = columnWidth;
				columnWidths.push(columnWidth);
				
				xpos += columnList.width;
			}
			
            setHeaderWidths(columnWidths);
			
			COMPILE::SWF {
                header.y = borderMetrics.top;
                header.x = borderMetrics.left;
				header.width = useWidth;
			}
			COMPILE::JS {
				(header as UIBase).percentWidth = 100;
				listArea.element.style.position = "absolute";
                if (!(uiHost.element.style.position == 'absolute' ||
                      uiHost.element.style.position == 'relative' ||
                      uiHost.element.style.position == 'fixed'))
                    uiHost.element.style.position = 'relative';
			}
			// header's height is set in CSS
			
            listArea.y = header.height + header.y;
			COMPILE::SWF {
                listArea.x = borderMetrics.left;
				listArea.width = useWidth;
			}
			COMPILE::JS {
				(listArea as UIBase).percentWidth = 100;
			}
			listArea.height = useHeight - header.height;
			
			header.dispatchEvent(new Event("layoutNeeded"));
			listArea.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
	}
}
