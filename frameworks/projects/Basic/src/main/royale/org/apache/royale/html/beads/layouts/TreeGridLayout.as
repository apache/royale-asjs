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
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.ButtonBar;
	import org.apache.royale.html.beads.TreeGridView;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.beads.models.TreeGridModel;
	import org.apache.royale.html.supportClasses.IDataGridColumn;
	import org.apache.royale.html.supportClasses.TreeGridColumn;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.Bead;
	
	/**
	 * The TreeGridLayout class provides the sizing and positioning for the sub-components
	 * that make up the TreeGrid.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TreeGridLayout extends Bead implements IBeadLayout
	{
		/**
		 * Constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TreeGridLayout()
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
		
		private function get host():IUIBase
		{
			return _strand as IUIBase;
		}
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
		 * Performs the layout function, placing the ButtonBar header at the top
		 * and spread across the width and the columns below that, laid out horizontally.
		 * The size of the columns is taken from the TreeGridColumn definitions stored
		 * in the TreeGridModel.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 *  @royaleignorecoercion org.apache.royale.html.beads.models.TreeGridModel
		 *  @royaleignorecoercion org.apache.royale.html.beads.TreeGridView
		 *  @royaleignorecoercion org.apache.royale.html.ButtonBar
		 */
		public function layout():Boolean
		{

			COMPILE::JS 
			{
				var renderedObject:IRenderedObject = IRenderedObject(host);
				if (!renderedObject.element.style.position || renderedObject.element.style.position == 'static')
				{
					renderedObject.element.style.position = 'relative';
				}
			}
			var model:TreeGridModel = uiHost.model as TreeGridModel;
			var header:ButtonBar = (uiHost.view as TreeGridView).header as ButtonBar;
			var contentArea:UIBase = (uiHost.view as TreeGridView).listArea as UIBase;
			var displayedColumns:Array = (uiHost.view as TreeGridView).columnLists;
			
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(_strand as IUIBase);
			var useWidth:Number = uiHost.width - (borderMetrics.left + borderMetrics.right);
			var useHeight:Number = uiHost.height - (borderMetrics.top + borderMetrics.bottom);
			
			// size and position the header
			header.x = borderMetrics.left;
			header.y = borderMetrics.top;
			COMPILE::SWF {
				header.width = useWidth;
			}
			COMPILE::JS {
				(header as UIBase).percentWidth = 100;
			}
			// header's height is set in CSS
			
			// size and position the elements that make up the content
			var xpos:Number = 0;
			var defaultColumnWidth:Number = (useWidth) / model.columns.length;
			var columnWidths:Array = [];
			
			COMPILE::JS {
				contentArea.element.style["position"] = "absolute";
			}
			
			for(var i:int=0; i < displayedColumns.length; i++) {
				var columnDef:IDataGridColumn = model.columns[i] as IDataGridColumn;
				var columnList:UIBase = displayedColumns[i] as UIBase;
				
				// probably do not need to set (x,y), but if the Container's layout requires it, they will be set.
				columnList.x = xpos;
				columnList.y = 0;
				
				var columnWidth:Number = defaultColumnWidth;
				if (!isNaN(columnDef.columnWidth)) {
					columnWidth = (columnDef.columnWidth / uiHost.width) * useWidth;
				}
				
				columnList.width = columnWidth;
				columnWidths.push(columnWidth);
				
				xpos += columnList.width;
			}
			
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.buttonWidths = columnWidths;
			header.dispatchEvent(new Event("layoutNeeded"));
			
			// size and position the contentArea
			contentArea.x = borderMetrics.left;
			contentArea.y = header.height + header.y; 
			COMPILE::SWF {
				contentArea.width = useWidth;
			}
			COMPILE::JS {
				(contentArea as UIBase).percentWidth = 100;
			}
			contentArea.height = useHeight - header.height;
			
			return true;
		}
	}
}