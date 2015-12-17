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
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataGridModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.ButtonBar;
	import org.apache.flex.html.supportClasses.DataGridColumn;
	
	/**
	 * DataGridLayout is a class that handles the size and positioning of the
	 * elements of a DataGrid. This includes the ButtonBar used for the column
	 * headers and the Lists that are the columns.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DataGridLayout implements IBeadLayout
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DataGridLayout()
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
		}
		
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
		
        /**
         * @copy org.apache.flex.core.IBeadLayout#layout
         */
		public function layout():Boolean
		{						
			var sw:Number = UIBase(_strand).width;
			var sh:Number = UIBase(_strand).height;
			
			var columnHeight:Number = Math.floor(sh - header.height);
			var columnWidth:Number  = Math.floor(sw / columns.length);
			
			var xpos:Number = 0;
			var ypos:Number = Math.floor(header.height);
			
			// TODO: change the layout so that the model's DataGridColumn.columnWidth
			// isn't used blindly, but is considered in the overall width. In other words,
			// right now the width could exceed the strand's width.
			var model:IDataGridModel = _strand.getBeadByType(IDataGridModel) as IDataGridModel;
			
			var buttonWidths:Array = new Array();
			
			for(var i:int=0; i < columns.length; i++) {
				var column:UIBase = columns[i] as UIBase;
				column.x = xpos;
				column.y = ypos;
				column.height = columnHeight;
				
				var dgc:DataGridColumn = model.columns[i];
				if (!isNaN(dgc.columnWidth)) column.width = dgc.columnWidth;
				else column.width  = columnWidth;
				
				xpos += column.width;
				
				buttonWidths.push(column.width);
			}
			
			var bar:ButtonBar = header as ButtonBar;
			var barLayout:ButtonBarLayout = bar.getBeadByType(ButtonBarLayout) as ButtonBarLayout;
			barLayout.buttonWidths = buttonWidths;
			
			header.x = 0;
			header.y = 0;
			header.width = sw;
			header.dispatchEvent(new Event("layoutNeeded"));
			
			return true;
		}
	}
}