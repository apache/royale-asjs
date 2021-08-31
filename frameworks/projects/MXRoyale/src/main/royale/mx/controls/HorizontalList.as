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

package mx.controls
{

import mx.controls.listClasses.TileBase;
import mx.controls.listClasses.TileBaseDirection;
import mx.core.mx_internal;
import mx.core.ScrollPolicy;

use namespace mx_internal;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="direction", kind="property")]
[Exclude(name="maxColumns", kind="property")]
[Exclude(name="maxRows", kind="property")]
[Exclude(name="variableRowHeight", kind="property")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

[DefaultProperty("dataProvider")]

[DefaultTriggerEvent("change")]

//[IconFile("HorizontalList.png")]

/**
 *  The layout-specific List components in Flex 3 have been replaced by a more generic
 *  List component that takes a generic layout. To get similar behavior from the new
 *  List component, set the <code>layout</code> property to <code>HorizontalLayout</code>.
 */
[Alternative(replacement="spark.components.List", since="4.0")]

/**
 *  The HorizontalList control displays a horizontal list of items. 
 *  If there are more items than can be displayed at once, it
 *  can display a horizontal scroll bar so the user can access
 *  all items in the list.
 *
 *  <p>The HorizontalList control has the following default sizing 
 *     characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Four columns, with size determined by the 
 *               cell dimensions.</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels.</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>5000 by 5000.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:HorizontalList&gt;</code> tag inherits all of the 
 *  tag attributes of its superclass and it adds no new tag attributes.</p>
 *
 *  <pre>
 *  &lt;mx:HorizontalList/&gt
 *  </pre>
 *
 *  @includeExample examples/HorizontalListExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HorizontalList extends TileBase
{
	//include "../core/Version.as";

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
	public function HorizontalList()
	{
		super();

		_horizontalScrollPolicy = ScrollPolicy.AUTO;
		_verticalScrollPolicy = ScrollPolicy.OFF;

		direction = TileBaseDirection.VERTICAL;
		//maxRows = 1;
		defaultRowCount = 1;
	}
}

}
