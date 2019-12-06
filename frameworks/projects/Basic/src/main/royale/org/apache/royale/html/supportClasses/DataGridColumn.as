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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.html.List;

	/**
	 *  The DataGridColumn class is the collection of properties that describe
	 *  a column of the org.apache.royale.html.DataGrid: which renderer 
	 *  to use for each cell in the column, the width of the column, the label for the 
	 *  column, and the name of the field in the data containing the value to display 
	 *  in the column. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DataGridColumn extends EventDispatcher implements IDataGridColumn
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridColumn()
		{
		}
		
		/**
		 * Returns a new instance of a UIBase component to be used as the actual
		 * column in the grid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function createColumn():IUIBase
		{
			return new List();
		}
		
		private var _itemRenderer:IFactory;
		
		/**
		 *  The itemRenderer class or factory to use to make instances of itemRenderers for
		 *  display of data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
		}
		
		private var _columnWidth:Number = Number.NaN;
		
		/**
		 *  The width of the column.  If not set,
         *  the columns will be sized to fit.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get columnWidth():Number
		{
			return _columnWidth;
		}
		public function set columnWidth(value:Number):void
		{
			_columnWidth = value;
		}
		
		private var _label:String;
		
		/**
		 *  The label for the column (appears in the header area).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
		}
		
		private var _dataField:String;
		
		/**
		 *  The name of the field containing the data value presented by the column. This value is used
		 *  by the itemRenderer is select the property from the data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			_dataField = value;
		}
		
		private var _className:String;
		
		/**
		 * The name of the style class to use for this column. If this is not set
		 * it defaults to DataGridColumnList.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		public function get className():String
		{
			return _className;
		}
		public function set className(value:String):void
		{
			_className = value;
		}
	}
}
