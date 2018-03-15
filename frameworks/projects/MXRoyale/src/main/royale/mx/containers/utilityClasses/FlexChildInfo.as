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

package mx.containers.utilityClasses
{

import mx.core.IUIComponent;

[ExcludeClass]

/**
 *  @private
 *  Helper class for the Flex.flexChildrenProportionally() method.
 */
public class FlexChildInfo
{
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
	public function FlexChildInfo()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  child
	//----------------------------------

	/**
	 *  @private
	 */
	private var _child:IUIComponent;
	public function get child():IUIComponent
	{
		return _child;
	}
	public function set child(value:IUIComponent):void
	{
		_child = value;
	}

	//----------------------------------
	//  size
	//----------------------------------

	/**
	 *  @private
	 */
	private var _size:Number = 0;
	public function get size():Number
	{
		return _size;
	}
	public function set size(value:Number):void
	{
		_size = value;
	}

	//----------------------------------
	//  preferred
	//----------------------------------

	/**
	 *  @private
	 */
	private var _preferred:Number = 0;
	public function get preferred():Number
	{
		return _preferred;
	}
	public function set preferred(value:Number):void
	{
		_preferred = value;
	}

	//----------------------------------
	//  flex
	//----------------------------------

	/**
	 *  @private
	 */
	private var _flex:Number = 0;
	public function get flex():Number
	{
		return _flex;
	}
	public function set flex(value:Number):void
	{
		_flex = value;
	}
	
	//----------------------------------
	//  percent
	//----------------------------------

	/**
	 *  @private
	 */
	private var _percent:Number;
	public function get percent():Number
	{
		return _percent;
	}
	public function set percent(value:Number):void
	{
		_percent = value;
	}

	//----------------------------------
	//  min
	//----------------------------------

	/**
	 *  @private
	 */
	private var _min:Number;
	public function get min():Number
	{
		return _min;
	}
	public function set min(value:Number):void
	{
		_min = value;
	}

	//----------------------------------
	//  max
	//----------------------------------

	/**
	 *  @private
	 */
	private var _max:Number;
	public function get max():Number
	{
		return _max;
	}
	public function set max(value:Number):void
	{
		_max = value;
	}

	//----------------------------------
	//  width
	//----------------------------------

	/**
	 *  @private
	 */
	private var _width:Number;
	public function get width():Number
	{
		return _width;
	}
	public function set width(value:Number):void
	{
		_width = value;
	}

	//----------------------------------
	//  height
	//----------------------------------

	/**
	 *  @private
	 */
	private var _height:Number;
	public function get height():Number
	{
		return _height;
	}
	public function set height(value:Number):void
	{
		_height = value;
	}
}

}
