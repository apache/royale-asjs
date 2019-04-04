
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
package org.apache.royale.jewel
{
	COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.jewel.beads.models.TableModel;
	import org.apache.royale.jewel.supportClasses.DataContainerBase;
	import org.apache.royale.utils.IClassSelectorListSupport;

	
	[DefaultProperty("columns")]

	/**
	 *  Indicates that the initialization of the list is complete.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	[Event(name="initComplete", type="org.apache.royale.events.Event")]

	/**
	 * The change event is dispatched whenever the list's selection changes.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
    [Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 *  The Table class represents an HTML <table> element.
     *  
     *  This Table component uses a data mapper and item renderers to generate
     *  a Table from a data source, in opposite to SimpleTable component that is a 
	 *  declarative mxml.
	 * 
	 *  As well, DataGrid is a more complex component
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Table extends DataContainerBase implements IClassSelectorListSupport
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Table()
		{
			super();
			
			typeNames = "jewel table";
		}

		/**
		 *  The list of TableColumn objects displayed by this table. 
		 *  Each column selects different data provider item properties to display.
		 *  
		 *  The default value is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get columns():Array
		{
			return TableModel(model).columns;
		}
		public function set columns(value:Array):void
		{
			TableModel(model).columns = value;
		}

		private var _fixedHeader:Boolean;
		/**
		 *  Makes the header of the table fixed so the data rows will scroll
		 *  behind it.
		 *  
		 *  The default value is false.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get fixedHeader():Boolean
		{
			return _fixedHeader;
		}
		public function set fixedHeader(value:Boolean):void
		{
			_fixedHeader = value;

			toggleClass("fixedHeader", _fixedHeader);
		}

		// private var _tableDataHeight:Boolean;
		/**
		 *  Makes the header of the table fixed so the data rows will scroll
		 *  behind it.
		 *  
		 *  The default value is false.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		// public function get tableDataHeight():Boolean
		// {
		// 	return _tableDataHeight;
		// }
		// public function set tableDataHeight(value:Boolean):void
		// {
		// 	_tableDataHeight = value;
		// }
		
		/**
		 *  A list of data items that correspond to the rows in the table.
		 *  Each table column is associated with a property of the data items to display that property in the table cells.
		 *  
		 *  The default value is null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get dataProvider():Object
		{
			return TableModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			TableModel(model).dataProvider = value;
		}

		/**
		 *  The index of the currently selected item. Changing this value
		 *  also changes the selectedItem property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		[Bindable("change")]
        public function get selectedIndex():int
		{
			return ISelectionModel(model).selectedIndex;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedIndex(value:int):void
		{
			ISelectionModel(model).selectedIndex = value;
		}

		/**
		 *  The item currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		[Bindable("change")]
		public function get selectedItem():Object
		{
			return ISelectionModel(model).selectedItem;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedItem(value:Object):void
		{
			ISelectionModel(model).selectedItem = value;
		}

		/**
		 *  The item property currently selected. Changing this value also
		 *  changes the selectedIndex property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		[Bindable("change")]
		public function get selectedItemProperty():Object
		{
			return TableModel(model).selectedItemProperty;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 */
		public function set selectedItemProperty(value:Object):void
		{
			TableModel(model).selectedItemProperty = value;
		}

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            return addElementToWrapper(this, 'table');
        }
    }
}
