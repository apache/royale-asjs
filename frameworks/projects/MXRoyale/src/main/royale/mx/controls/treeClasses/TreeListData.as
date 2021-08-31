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

package mx.controls.treeClasses
{

import mx.controls.listClasses.BaseListData;
import mx.controls.listClasses.ListBase;

/**
 *  The TreeListData class defines the data type of the <code>listData</code> property 
 *  implemented by drop-in item renderers or drop-in item editors for the Tree control. 
 *  All drop-in item renderers and drop-in item editors must implement the 
 *  IDropInListItemRenderer interface, which defines the <code>listData</code> property.
 *
 *  <p>While the properties of this class are writable, you should considered them to 
 *  be read only. They are initialized by the Tree class, and read by an item renderer 
 *  or item editor. Changing these values can lead to unexpected results.</p>
 *
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TreeListData extends BaseListData
{
    //include "../../core/Version.as";

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
	 *  @param uid A unique identifier for the item.
	 *
	 *  @param owner A reference to the Tree control.
	 *
	 *  @param rowIndex The index of the item in the data provider for the Tree control.
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
	public function TreeListData(text:String, uid:String,
								 owner:ListBase, rowIndex:int = 0,
								 columnIndex:int = 0)
	{
		super(text, uid, owner, rowIndex, columnIndex);
	}

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  depth
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  The level of the item in the tree. The top level is 1.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var depth:int;

    //----------------------------------
	//  disclosureIcon
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  A Class representing the disclosure icon for the item in the Tree control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var disclosureIcon:Class;

    //----------------------------------
	//  hasChildren
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  Contains <code>true</code> if the node has children.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var hasChildren:Boolean; 

    //----------------------------------
	//  icon
    //----------------------------------
	
	[Bindable("__NoChangeEvent__")]

    /**
	 *  A Class representing the icon for the item in the Tree control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var icon:Class;

    //----------------------------------
	//  indent
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  The default indentation for this row of the Tree control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var indent:int;

    //----------------------------------
	//  node
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  The data for this item in the Tree control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var item:Object;

    //----------------------------------
	//  open
    //----------------------------------

	[Bindable("__NoChangeEvent__")]

    /**
	 *  Contains <code>true</code> if the node is open.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var open:Boolean; 

    /**
     *  TODO keeping this for backwards compatibility, consider removing
     *  @private
     */
	public function get isOpen():Boolean
	{
		return open;
	}
	
    /**
     *  TODO keeping this for backwards compatibility, consider removing
     *  @private
     */
	public function set isOpen(value:Boolean):void
	{
		open = value;
	}
}

}
