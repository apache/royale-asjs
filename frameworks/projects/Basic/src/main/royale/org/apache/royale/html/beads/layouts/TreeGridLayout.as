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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.ButtonBar;
	import org.apache.royale.html.beads.TreeGridView;
	import org.apache.royale.html.beads.models.ButtonBarModel;
	import org.apache.royale.html.beads.models.TreeGridModel;
	import org.apache.royale.html.supportClasses.TreeGridColumn;
	
	/**
	 * The TreeGridLayout class provides the sizing and positioning for the sub-components
	 * that make up the TreeGrid.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class TreeGridLayout implements IBeadLayout
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
		
		private var _strand:IStrand;
		
		/**
		 * @see org.apache.royale.core.IStrand
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			(_strand as IEventDispatcher).addEventListener("widthChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("heightChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("sizeChanged", handleSizeChanges);
			(_strand as IEventDispatcher).addEventListener("layoutNeeded", handleLayoutNeeded);
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
		 */
		public function layout():Boolean
		{
			var model:TreeGridModel = uiHost.model as TreeGridModel;
			var header:ButtonBar = (uiHost.view as TreeGridView).header;
			var contentArea:UIBase = (uiHost.view as TreeGridView).contentArea;
			var displayedColumns:Array = (uiHost.view as TreeGridView).displayedColumns;
			
			// size and position the header
			header.x = 0;
			header.y = 0;
			header.setWidthAndHeight(uiHost.width, 25); 
			
			// size and position the elements that make up the content
			var xpos:Number = 0;
			var defaultColumnWidth:Number = contentArea.width / model.columns.length;
			var columnWidths:Array = [];
			
			for(var i:int=0; i < displayedColumns.length; i++) {
				var columnDef:TreeGridColumn = model.columns[i] as TreeGridColumn;
				var columnList:UIBase = displayedColumns[i] as UIBase;
				columnList.x = xpos;
				columnList.y = 0;
				//columnList.setWidthAndHeight(columnWidth, _contentArea.height);
				if (isNaN(columnDef.columnWidth)) {
					columnList.width = defaultColumnWidth;
				} else {
					columnList.width = columnDef.columnWidth;
				}
				
				columnWidths.push(columnList.width);
				
				xpos += columnList.width;
			}
			
			var bbmodel:ButtonBarModel = header.getBeadByType(ButtonBarModel) as ButtonBarModel;
			bbmodel.buttonWidths = columnWidths;
			header.dispatchEvent(new Event("layoutNeeded"));
			
			// size and position the contentArea
			contentArea.x = 0;
			contentArea.y = header.height; 
			contentArea.setWidthAndHeight(uiHost.width, uiHost.height - header.height);
			
			return true;
		}
	}
}