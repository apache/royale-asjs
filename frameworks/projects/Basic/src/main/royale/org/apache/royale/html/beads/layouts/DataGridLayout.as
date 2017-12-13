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
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IDataGridModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.ButtonBar;
	import org.apache.royale.html.beads.DataGridView;
	import org.apache.royale.html.beads.layouts.BasicLayout;
	import org.apache.royale.html.supportClasses.DataGridColumnList;
	import org.apache.royale.html.supportClasses.DataGridColumn;
	
	/**
	 * DataGridLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridLayout implements IDataGridLayout
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

		}
		
		private var _header:UIBase;
		
		/**
		 * The element that is the header for the DataGrid
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		
        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{						
			if (columns == null || columns.length == 0) {
				return false;
			}
			var host:UIBase = _strand as UIBase;
			
			var useWidth:Number = host.width;
			var useHeight:Number = host.height;

			if (host.height > 0) {
				useHeight = host.height - _header.height;
			}
			
			var thisisnothing:Number = -1234;

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
					if (!isNaN(colWidth)) list.width = colWidth;
					else list.width = listWidth;

					xpos += list.width;
					
					buttonWidths.push(list.width);
				}
			}
			
			var bar:ButtonBar = header as ButtonBar;
			var barLayout:ButtonBarLayout = bar.getBeadByType(ButtonBarLayout) as ButtonBarLayout;
			barLayout.buttonWidths = buttonWidths;
			bar.dispatchEvent(new Event("layoutNeeded"));
			
			_header.x = 0;
			_header.y = 0;
			_header.width = useWidth;
			_header.height = 25;
			_header.dispatchEvent(new Event("layoutNeeded"));
			
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
