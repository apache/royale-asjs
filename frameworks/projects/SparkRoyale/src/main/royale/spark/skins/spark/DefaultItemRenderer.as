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

package spark.skins.spark
{
import mx.core.UIComponent;
import mx.core.IDataRenderer;

/*   
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point; 
import mx.controls.listClasses.*;
import mx.core.InteractionMode;
import mx.core.mx_internal;
import mx.events.FlexEvent;

import spark.components.IItemRenderer;
import spark.components.Label;
import spark.components.supportClasses.InteractionState;
import spark.components.supportClasses.InteractionStateDetector;
import spark.components.supportClasses.TextBase;
*/
 
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
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Event(name="dataChange", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//include "../../styles/metadata/BasicInheritingTextStyles.as"
//include "../../styles/metadata/AdvancedInheritingTextStyles.as"
//include "../../styles/metadata/SelectionFormatTextStyles.as"

/**
 *  @copy spark.components.supportClasses.GroupBase#style:alternatingItemColors
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:downColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
//[Style(name="downColor", type="uint", format="Color", inherit="yes", theme="mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:focusColor
 *   
 *  @default 0x70B2EE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:rollOverColor
 *   
 *  @default 0xCEDBEF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *   
 *  @default 0x000000
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
//[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

//[Exclude(name="focusBlendMode", kind="style")]
//[Exclude(name="focusThickness", kind="style")]

/**
 *  The DefaultItemRenderer class defines the default item renderer
 *  for a List control. 
 *  The default item renderer just draws the text associated
 *  with each item in the list.
 *
 *  <p>You can override the default item renderer
 *  by creating a custom item renderer.</p>
 *
 *  @see spark.components.List
 *  @see mx.core.IDataRenderer
 *  @see spark.components.IItemRenderer
 *  @see spark.components.supportClasses.ItemRenderer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class DefaultItemRenderer extends UIComponent
    //implements IDataRenderer  , IItemRenderer
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function DefaultItemRenderer()
    {
        super();
         
    }
     
}
    
}