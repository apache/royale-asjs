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

/**
 *  Used by the list-based classes to store information about their IListItemRenderers.
 *
 *  @see mx.controls.listClasses.ListBase#rowInfo
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ListRowInfo
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
	 *  @param y The y-position value for the row.
	 *
	 *  @param height The height of the row including margins.
	 *
	 *  @param uid The unique identifier of the item in the dataProvider
	 *
	 *  @param data The item in the dataprovider.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ListRowInfo(y:Number, height:Number,
								uid:String, data:Object = null)
	{
		super();

		this.y = y;
		this.height = height;
		this._uid = uid;
		this.data = data;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  data
	//----------------------------------

	/**
	 *  The item in the dataprovider. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var data:Object; 

	//----------------------------------
	//  height
	//----------------------------------

	/**
	 *  The height of the row including margins.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var height:Number; 

	//----------------------------------
	//  itemOldY
	//----------------------------------

	/**
	 *  The last Y value for the renderer.
	 *  Used in Tree's open/close effects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var itemOldY:Number; 

	//----------------------------------
	//  oldY
	//----------------------------------

	/**
	 *  The last Y value for the row.
	 *  Used in Tree's open/close effects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var oldY:Number; 

	//----------------------------------
	//  uid
	//----------------------------------
	private var _uid:String;
	/**
	 *  The unique identifier of the item in the dataProvider
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function get uid():String
	{
		return _uid;
	}

	/**
	 *  @private
	 */
	public function set uid(value:String):void
	{
		_uid = value;
	}

	//----------------------------------
	//  y
	//----------------------------------

	/**
	 *  The y-position value for the row.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var y:Number; 
}

}
