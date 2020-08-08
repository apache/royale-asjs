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
import org.apache.royale.jewel.supportClasses.table.TableColumn;

/**
 *  The DataGridColumn class is the collection of properties that describe
 *  a column of the org.apache.royale.jewel.DataGrid: which renderer
 *  to use for each cell in the column, the width of the column, the label for the
 *  column, and the name of the field in the data containing the value to display
 *  in the column.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.9.7
 */
public class DataGridColumn extends TableColumn implements IDataGridColumn
{
	/**
	 *  constructor.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
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
	 *  @productversion Royale 0.9.7
	 */
	public function createColumn():IStyledUIBase
	{
		return new DataGridColumnList();
	}


	private var _visible:Boolean = true;
	public function set visible(value:Boolean):void{
		if (value != _visible) {
			_visible = value;
			//somehow, invalidate layout
		}
	}

	public function get visible():Boolean{
		return _visible;
	}
}
}
