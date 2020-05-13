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
package org.apache.royale.jewel.supportClasses.datagrid
{
	import org.apache.royale.core.IStyledUIBase;
	import org.apache.royale.jewel.supportClasses.table.ITableColumn;

	/**
	 *  Jewel IDataGridColumn is the interface used by Jewel DataGridColumn in the Jewel DataGrid.
	 * 
	 *  Define which renderer to use for each cell in the column, and other optional data like
	 *  the width, the label (used in header), and the name of the field in the data containing the value to display 
	 *  in the column (for the simplest ItemRenderer).
	 */
	public interface IDataGridColumn extends ITableColumn
	{	
		/**
		 *  Returns a new instance of a UIBase component to be used as the actual
		 *  column in the grid.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function createColumn():IStyledUIBase;
	}
}