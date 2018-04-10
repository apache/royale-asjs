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

package mx.containers.gridClasses
{

import mx.core.UIComponent;

[ExcludeClass]

/**
 *  @private
 *  Internal helper class used to exchange information between
 *  Grid and GridRow.
 */
public class GridRowInfo
{
	/* include "../../core/Version.as";
 */
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function GridRowInfo()
	{
		super();

		_min = 0;
		_preferred = 0;
		_max = UIComponent.DEFAULT_MAX_HEIGHT;
		_flex = 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  flex
	//----------------------------------

	/**
	 *  Input: Measurement for the GridRow.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _flex:Number;
	public function set flex(value:Number):void
	{
	_flex = value;
	}
	
	public function get flex():Number
	{
	return _flex;
	}
	//----------------------------------
	//  height
	//----------------------------------

	/**
	 *  Output: The actual height of each row,
	 *  as determined by updateDisplayList().
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _height:Number;
	public function set height(value:Number):void
	{
	_height = value;
	}
	
	public function get height():Number
	{
	return _height;
	}
	//----------------------------------
	//  max
	//----------------------------------

	/**
	 *  Input: Measurement for the GridRow.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _max:Number;
	public function set max(value:Number):void
	{
	_max = value;
	}
	
	public function get max():Number
	{
	return _max;
	}
	//----------------------------------
	//  min
	//----------------------------------

	/**
	 *  Input: Measurement for the GridRow.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _min:Number;
	public function set min(value:Number):void
	{
	_min = value;
	}
	
	public function get min():Number
	{
	return _min;
	}
	//----------------------------------
	//  _preferred
	//----------------------------------

	/**
	 *  Input: Measurement for the GridRow.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _preferred:Number;
	public function set preferred(value:Number):void
	{
	_preferred = value;
	}
	
	public function get preferred():Number
	{
	return _preferred;
	}
	//----------------------------------
	//  y
	//----------------------------------

	/**
	 *  Output: The actual position of each row,
	 *  as determined by updateDisplayList().
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _y:Number;
	public function set y(value:Number):void
	{
	_y = value;
	}
	
	public function get y():Number
	{
	return _y;
	}
}

}
