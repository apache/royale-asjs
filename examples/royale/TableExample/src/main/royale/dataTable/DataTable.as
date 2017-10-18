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
package dataTable
{
	import dataTable.mapper.DataTableMapperForArrayListData;
	import dataTable.model.DataTableModel;
	
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Table;
	
	[DefaultProperty("columns")]
	
	/**
	 * The DataTable uses Table along with a data mapper and item renderers to generate
	 * a Table from a data source.
	 */
	public class DataTable extends Table
	{
		public function DataTable()
		{
			super();
			
			className = "DataTable";
		}
		
		public function get columns():Array
		{
			return DataTableModel(model).columns;
		}
		public function set columns(value:Array):void
		{
			DataTableModel(model).columns = value;
		}
		
		public function get dataProvider():Object
		{
			return DataTableModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			DataTableModel(model).dataProvider = value;
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
			
			addBead(new DataTableMapperForArrayListData());
			
			dispatchEvent( new Event("dataTableComplete") );
		}
	}
}
