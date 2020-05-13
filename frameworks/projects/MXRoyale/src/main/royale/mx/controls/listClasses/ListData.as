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

import mx.core.IUIComponent;

/**
 *  The ListData class defines the data type of the <code>listData</code>
 *  property implemented by drop-in item renderers or drop-in item editors
 *  for the List control. 
 *  All drop-in item renderers and drop-in item editors must implement 
 *  the IDropInListItemRenderer interface, which defines
 *  the <code>listData</code> property.
 *
 *  <p>While the properties of this class are writable,
 *  you should consider them to be read only.
 *  They are initialized by the List class,
 *  and read by an item renderer or item editor.
 *  Changing these values can lead to unexpected results.</p>
 *
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ListData extends BaseListData
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
	 *  @param icon A Class or String object representing the icon 
	 *  for the item in the List control.
	 *
	 *  @param labelField The name of the field of the data provider 
	 *  containing the label data of the List component.
	 *
	 *  @param uid A unique identifier for the item.
	 *
	 *  @param owner A reference to the List control.
	 *
	 *  @param rowIndex The index of the item in the data provider
	 *  for the List control.
	 * 
	 *  @param columnIndex The index of the column in the currently visible columns of the 
     *  control.
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ListData(text:String, icon:Class, labelField:String,
							 uid:String, owner:IUIComponent, rowIndex:int = 0,
							 columnIndex:int = 0)
	{
		super(text, uid, owner, rowIndex, columnIndex);
		
		this.icon = icon;
		this.labelField = labelField;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  icon
	//----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  A Class representing the icon for the item in the List control computed
	 *  from the list class's <code>itemToIcon()</code> method
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var icon:Class;

	//----------------------------------
	//  labelField
	//----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  The value of the <code>labelField</code> property in the list class.
	 *  This is the value normally used to calculate which property should
	 *  be taken from the item in the data provider for the text displayed
	 *  in the item renderer, but is also used by DateField and other
	 *  components to indicate which field to take from the data provider item
	 *  that contains a Date or other non-text property.
	 *
	 *  <p>For example, if a data provider item contains a "hiredDate" property,
	 *  the <code>labelField</code> property can be set to "hiredDate" 
	 *  and the <code>itemRenderer</code> property 
	 *  can be set to DateField. The DateField control then uses the hiredDate
	 *  property.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var labelField:String;
}

}
