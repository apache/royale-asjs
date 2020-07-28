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
package org.apache.royale.jewel.beads.models
{
	import org.apache.royale.core.ITableModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.beads.models.TableArrayListSelectionModel;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	
	public class TableModel extends TableArrayListSelectionModel implements ITableModel
	{
		public function TableModel()
		{
			super();
		}
		
		private var _columns:Array;
		/**
         *  The set of Table Columns.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get columns():Array
		{
			return _columns;
		}
		public function set columns(value:Array):void
		{
			_columns = value;
			dispatchEvent( new Event("columnsChanged") );
		}

		private var _selectedItemProperty:Object;

        /**
		 * The selected item property
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
		 */
		public function get selectedItemProperty():Object
		{
			return _selectedItemProperty;
		}

        /**
         *  @private
         */
		public function set selectedItemProperty(value:Object):void
		{
			if(labelField == null || labelField == "") return;
            if (value == _selectedItemProperty) return;

			_selectedItemProperty = value;

			if (dataProvider)
			{
				var n:int = dataProvider.length;
				for (var i:int = 0; i < n; i++)
				{
					if(dataProvider.getItemAt(i) == selectedItem && dataProvider.getItemAt(i)[labelField] == value)
					{
						selectedIndex = i;
						break;
					}
				}
			}

			dispatchEvent(new Event("selectedItemPropertyChanged"));
		}

		/**
         * @private
		 * @royaleignorecoercion rg.apache.royale.jewel.supportClasses.table.TableColumn
         */
        public function getIndexForSelectedItemProperty():Number
        {
            if (!selectedItemProperty) return -1;

			var index:int = 0;
            for(var i:int=0; i < dataProvider.length; i++) {
				for(var j:int=0; j < _columns.length; j++) {
					var column:TableColumn = _columns[j] as TableColumn;
					var test:Object = dataProvider.getItemAt(i)[column.dataField] as Object;
					
					if (dataProvider.getItemAt(i) == selectedItem && labelField == column.dataField)
					{
						return index;
					}
					index++;
				}
            }
            return -1;
		}
	}
}
