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
 *  Values for the <code>direction</code> property of the TileList component.
 *
 *  @see mx.controls.listClasses.TileBase#direction
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public final class TileBaseDirection
{
	//include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  Arrange children horizontally.
	 *  For controls, such as TileList, that arrange children in
	 *  two dimensions, arrange the children by filling up a row 
	 *  before going on to the next row.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const HORIZONTAL:String = "horizontal";
	
	/**
	 *  Arrange chidren vertically.
	 *  For controls, such as TileList, that arrange children in
	 *  two dimensions, arrange the children by filling up a column
	 *  before going on to the next column.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const VERTICAL:String = "vertical";
}

}
