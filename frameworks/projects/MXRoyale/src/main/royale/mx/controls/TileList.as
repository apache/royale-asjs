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
import mx.controls.listClasses.TileListItemRenderer;
import mx.core.ClassFactory;
import mx.core.mx_internal;
import mx.core.ScrollPolicy;

use namespace mx_internal;

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

[DefaultProperty("dataProvider")]

[DefaultTriggerEvent("change")]

//[IconFile("TileList.png")]

//--------------------------------------
//  Effects
//--------------------------------------

/**
 *  The data effect to play when a change occur to the control's data provider.
 *
 *  <p>By default, the TileList control does not use a data effect. 
 *  For the TileList control, use an instance of the DefaultTileListEffect class.</p>
 *
 * @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Effect(name="itemsChangeEffect", event="itemsChange")]

/**
 *  The layout-specific List components in Flex 3 have been replaced by a more generic
 *  List component that takes a generic layout. To get similar behavior from the new
 *  List component, set the <code>layout</code> property to <code>TileLayout</code>.
 */
[Alternative(replacement="spark.components.List", since="4.0")]

/**
 *  The TileList control displays a number of items laid out in tiles.
 *  It displays a scroll bar on one of its axes to access all items
 *  in the list, depending on the <code>direction</code> property.
 *  You can set the size of the tiles by using <code>rowHeight</code>
 *  and <code>columnWidth</code> properties.
 *  Alternatively, Flex measures the item renderer for the first item
 *  in the dataProvider and uses that size for all tiles.
 *  
 *  <p>The TileList control has the following default sizing 
 *     characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Four columns and four rows. Using the default item 
 *               renderer, the total size is 66 by 126 pixels.</td>
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
 *  <p>The <code>&lt;mx:TileList&gt;</code> tag inherits
 *  all of the tag attributes of its superclass, but ignores the
 *  <code>variableRowHeight</code> and <code>wordWrap</code> tag attributes.  
 *  It adds no additional tag attributes.</p>
 *  
 *  <pre>
 *  &lt;mx:TileList/&gt;
 *  </pre>
 *
 *  @includeExample examples/TileListExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TileList extends TileBase
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
    public function TileList()
    {
        super();
        _horizontalScrollPolicy = ScrollPolicy.AUTO;
        itemRenderer = new ClassFactory(TileListItemRenderer);
    }
}

}
