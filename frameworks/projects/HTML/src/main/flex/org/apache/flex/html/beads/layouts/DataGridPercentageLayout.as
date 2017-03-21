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
package org.apache.flex.html.beads.layouts
{	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.ButtonBar;
	import org.apache.flex.html.beads.DataGridView;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.html.beads.models.ButtonBarModel;
	import org.apache.flex.html.supportClasses.DataGridColumnList;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	
	/**
	 * DataGridPercentageLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns. The columns are sized on their
	 * percentage of the width of the DataGrid space.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataGridPercentageLayout implements IDataGridLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataGridPercentageLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var host:UIBase = value as UIBase;
			
			var view:DataGridView = host.view as DataGridView;
			
			header = view.header;
			listArea = view.listArea;
			
			var anylayout:IBead = listArea.getBeadByType(IBeadLayout);
			if (anylayout != null) {
				listArea.removeBead(anylayout);
			}
			listArea.addBead(new BasicLayout());
			
			host.addEventListener("widthChanged", handleSizeChanges);
			host.addEventListener("heightChanged", handleSizeChanges);
			host.addEventListener("sizeChanged", handleSizeChanges);
			host.addEventListener("layoutNeeded", handleSizeChanges);
			
			// listen for beadsAdded to signal that the strand is set with its size
			// and beads.
			host.addEventListener("beadsAdded", beadsAddedHandler);
		}
		
		private var runNeeded:Boolean = false;
		private var hostReady:Boolean = false;
		
		private var _header:UIBase;
		
		/**
		 * The element that is the header for the DataGrid
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get header():IUIBase
		{
			return _header;
		}
		public function set header(value:IUIBase):void
		{
			_header = UIBase(value);
		}
		
		private var _columns:Array;
		
		/**
		 * The array of column elements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get columns():Array
		{
			return _columns;
		}
		public function set columns(value:Array):void
		{
			_columns = value;
		}
		
		private var _listArea:IUIBase;
		
		public function get listArea():IUIBase
		{
			return _listArea;
		}
		public function set listArea(value:IUIBase):void
		{
			_listArea = value;
		}
		
		private function beadsAddedHandler(event:Event):void
		{
			var host:UIBase = _strand as UIBase;
			
			var useWidth:Number = host.width;
			var useHeight:Number = host.height;
			
			hostReady = true;
			if (runNeeded) {
				runNeeded = false;
				layout();
			}
		}
		
		/**
		 * @copy org.apache.flex.core.IBeadLayout#layout
		 */
		COMPILE::SWF
		public function layout():Boolean
		{			
			if (!hostReady) {
				runNeeded = true;
				return false;
			}
			
			if (columns == null || columns.length == 0) {
				return false;
			}
			var host:UIBase = _strand as UIBase;
			
			var useWidth:Number = host.width;
			var useHeight:Number = host.height;
			
			if (host.height > 0) {
				useHeight = host.height - _header.height;
			}
			
			_listArea.x = 0;
			_listArea.y = 26;
			_listArea.width = useWidth;
			_listArea.height = useHeight;
			
			var sharedModel:IDataGridModel = host.model as IDataGridModel;
			var buttonWidths:Array = [];
			
			if (_columns != null && _columns.length > 0) {
				var xpos:Number = 0;
				var listWidth:Number = host.width / _columns.length;
				for (var i:int=0; i < _columns.length; i++) {
					var list:DataGridColumnList = _columns[i] as DataGridColumnList;
					list.x = xpos;
					list.y = 0;
					
					var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
					var colWidth:Number = dataGridColumn.columnWidth;
					if (!isNaN(colWidth)) {
						list.percentWidth = colWidth;
						colWidth = host.width * (colWidth/100.0);
					}
					else {
						list.width = listWidth;
						colWidth = listWidth;
					}
					
					xpos += colWidth;
					
					buttonWidths.push(colWidth);
				}
			}
			
			var bar:ButtonBar = header as ButtonBar;
			bar.buttonWidths = buttonWidths;
			bar.widthType = ButtonBarModel.PERCENT_WIDTHS;
			bar.dispatchEvent(new Event("layoutNeeded"));
			
			_header.x = 0;
			_header.y = 0;
			_header.width = useWidth;
			_header.height = 25;
			_header.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
		
		/**
		 * @copy org.apache.flex.core.IBeadLayout#layout
		 */
		COMPILE::JS
		public function layout():Boolean
		{						
			if (columns == null || columns.length == 0) {
				return false;
			}
			var host:UIBase = _strand as UIBase;
			
			var sharedModel:IDataGridModel = host.model as IDataGridModel;
			var buttonWidths:Array = [];
			
			if (_columns != null && _columns.length > 0) {
				var listWidth:Number = host.width / _columns.length;
				for (var i:int=0; i < _columns.length; i++) {
					var list:DataGridColumnList = _columns[i] as DataGridColumnList;
					list.element.style["position"] = null;
					list.element.style["height"] = null;
					
					
					var dataGridColumn:DataGridColumn = sharedModel.columns[i] as DataGridColumn;
					var colWidth:Number = dataGridColumn.columnWidth;
					if (!isNaN(colWidth)) list.percentWidth = colWidth;
					else list.width = listWidth;
					
					buttonWidths.push(list.width);
				}
			}
			
			var bar:ButtonBar = header as ButtonBar;
			bar.buttonWidths = buttonWidths;
			bar.widthType = ButtonBarModel.PERCENT_WIDTHS;
			bar.dispatchEvent(new Event("layoutNeeded"));
			
			host.element.style.display = "flex";
			host.element.style["flex-flow"] = "column";
			host.element.style["justify-content"] = "stretch";
			
			_header.height = 25;
			_header.percentWidth = 100;
			
			_listArea.element.style["flex-grow"] = "2";
			_listArea.element.style["position"] = null;
			_listArea.element.style["height"] = null;
			
			var listView:ILayoutHost = UIBase(_listArea).view as ILayoutHost;
			listView.contentView.element.style["display"] = "flex";
			listView.contentView.element.style["flex-flow"] = "row";
			
			return true;
		}
		
		/**
		 * @private
		 */
		private function handleSizeChanges(event:Event):void
		{
			var view:DataGridView = UIBase(_strand).view as DataGridView;
			if (view == null) return;
			
			columns = view.columnLists;
			
			layout();
		}
	}
}
