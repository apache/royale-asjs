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

package mx.controls.dataGridClasses
{

import mx.controls.listClasses.BaseListData;
import mx.core.IUIComponent;

/**
 *  The DataGridListData class defines the data type of the <code>listData</code> property that is
 *  implemented by drop-in item renderers or drop-in item editors for the DataGrid control. 
 *  All drop-in item renderers and drop-in item editors must implement the 
 *  IDropInListItemRenderer interface, which defines the <code>listData</code> property.
 *
 *  <p>Although the properties of this class are writable, you should consider them to 
 *  be read-only. They are initialized by the DataGrid class, and read by an item renderer 
 *  or item editor. Changing these values can lead to unexpected results.</p>
 *
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataGridListData extends BaseListData
{
//	include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param text Text representation of the item data.
	 *
	 *  @param dataField Name of the field or property 
	 *    in the data provider associated with the column.
	 *
	 *  @param columnIndex The column index of the item in the 
	 *    columns for the DataGrid control.
	 *
	 *  @param uid A unique identifier for the item.
	 *
	 *  @param owner A reference to the DataGrid control.
	 *
	 *  @param rowIndex The index of the item in the data provider
	 *  for the DataGrid control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function DataGridListData(text:String, dataField:String,
									 columnIndex:int, uid:String,
									 owner:IUIComponent, rowIndex:int = 0)
	{
		super(text, uid, owner, rowIndex, columnIndex);

		this.dataField = dataField;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  Name of the field or property in the data provider associated with the column. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var dataField:String;

}

}
