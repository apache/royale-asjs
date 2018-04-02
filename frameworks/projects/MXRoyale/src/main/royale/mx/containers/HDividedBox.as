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

package mx.containers
{
/*
import mx.core.mx_internal;
use namespace mx_internal;
*/

/**
 *  The HDividedBox container lays out its children horizontally
 *  in the same way as HBox container, but it inserts
 *  a draggable divider in the gap between each child.
 *  A user can drag the divider to resize the area allotted to each child.
 *  The <code>&lt;mx:HDividedBox/&gt;</code> tag is the same as
 *  <code>&lt;mx:DividedBox direction="horizontal"/&gt;</code>.
 *  
 *  <p>An HDividedBox container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Width is large enough to hold all of its children at the 
 *               default or explicit widths of the children, plus any horizontal gap between the children, plus the left and 
 *               right padding of the container. Height is the default or explicit height of the tallest child 
 *               plus the top and bottom padding of the container.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *        <tr>
 *           <td>Default gap</td>
 *           <td>10 pixels for the horizontal and vertical gaps.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:HDividedBox&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass except <code>direction</code> and adds 
 *  no new tag attributes.</p>
 *  
 *  @includeExample examples/HDividedBoxExample.mxml
 *
 *  @see mx.containers.DividedBox
 *  @see mx.containers.VDividedBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HDividedBox extends DividedBox
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
	public function HDividedBox()
	{
		super();
		typeNames = "HDividedBox";
		
		super.direction = BoxDirection.HORIZONTAL;				
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  direction
	//----------------------------------
	
	[Inspectable(environment="none")]	

	/**
	 *  @private
	 *  Don't allow user to change the direction
	 */
	override public function set direction(value:String):void
	{
	}
}

}
