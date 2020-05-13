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

package mx.controls.listClasses
{

import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  Records used by list classes to keep track of what is selected.
 *  Each selected item is represented by an instance of this class. 
 *
 *  @see mx.controls.listClasses.ListBase#selectedData
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ListBaseSelectionData
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
	 *  @param data The data Object that is selected
	 *
	 *  @param index The index in the data provider of the selected item. (may be approximate) 
	 *
	 *  @param approximate If true, then the index property is an approximate value and not the exact value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ListBaseSelectionData(data:Object, index:int,
										  approximate:Boolean)
	{
		super();

		this.data = data;
		this.index = index;
		this.approximate = approximate;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
    
	/**
     *  @private
     *  The next ListBaseSelectionData in a linked list
	 *  of ListBaseSelectionData.
     *  ListBaseSelectionData instances are linked together and keep track
	 *  of the order in which the user selects items.
	 *  This order is reflected in selectedIndices and selectedItems.
     */
    mx_internal var nextSelectionData:ListBaseSelectionData;

    /**
     *  @private
     *  The previous ListBaseSelectionData in a linked list
	 *  of ListBaseSelectionData.
     *  ListBaseSelectionData instances are linked together and keep track
	 *  of the order in which the user selects items.
	 *  This order is reflected in selectedIndices and selectedItems.
     */
    mx_internal var prevSelectionData:ListBaseSelectionData;

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  approximate
	//----------------------------------

	/**
	 *  If true, then the index property is an approximate value and not the exact value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var approximate:Boolean;

	//----------------------------------
	//  data
	//----------------------------------

	/**
	 *  The data Object that is selected (selectedItem)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var data:Object;

	//----------------------------------
	//  index
	//----------------------------------

	/**
	 *  The index in the data provider of the selected item. (may be approximate)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var index:int;
}

}