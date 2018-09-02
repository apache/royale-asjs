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

package mx.controls.advancedDataGridClasses
{
  //import spark.components.supportClasses.ItemRenderer;
  import mx.core.UIComponent;
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  The AdvancedDataGridItemRenderer class defines the default item renderer for a AdvancedDataGrid control. 
 *  By default, the item renderer 
 *  draws the text associated with each item in the grid.
 *
 *  <p>You can override the default item renderer by creating a custom item renderer.</p>
 *
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.core.IDataRenderer
 *  @see mx.controls.listClasses.IDropInListItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class MXAdvancedDataGridItemRenderer extends UIComponent
                                 
{
 /* extends UITextField
                                  implements IDataRenderer,
                                  IDropInListItemRenderer, ILayoutManagerClient,
                                  IListItemRenderer, IStyleClient
								   */
/*     include "../../core/Version.as";
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
     *  @productversion Royale 0.9.3
     */
    public function MXAdvancedDataGridItemRenderer()
	{
	
	}
    
    
  
}

}
