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

package mx.geom
{
import org.apache.flex.geom.Rectangle;		

/**
 *  RoundedRectangle represents a Rectangle with curved corners
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class RoundedRectangle extends Rectangle
{	
	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param x The x coordinate of the top-left corner of the rectangle.
	 *
	 *  @param y The y coordinate of the top-left corner of the rectangle.
	 *
	 *  @param width The width of the rectangle, in pixels.
	 *
	 *  @param height The height of the rectangle, in pixels.
	 *
	 *  @param cornerRadius The radius of each corner, in pixels.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function RoundedRectangle(x:Number = 0, y:Number = 0,
									 width:Number = 0, height:Number = 0,
									 cornerRadius:Number = 0)
	{
		super(x, y, width, height);

		this.cornerRadius = cornerRadius;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  cornerRadius
	//----------------------------------

	[Inspectable]

	/**
	 *  The radius of each corner (in pixels).
	 *  
	 *  @default 0
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var cornerRadius:Number = 0;
	
}

}
