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

package mx.controls.menuClasses
{

import mx.controls.MenuBar;
import mx.controls.listClasses.IListItemRenderer;
import mx.core.IDataRenderer;
import mx.core.IUIComponent;
import mx.core.mx_internal;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

/**
 *  The IMenuBarItemRenderer interface defines the interface
 *  that an item renderer for the top-level menu bar of a 
 *  MenuBar control must implement.
 *  The item renderer defines the look of the individual buttons 
 *  in the top-level menu bar. 
 * 
 *  To implement this interface, you must define a 
 *  setter and getter method that implements the <code>menuBar</code>, 
 *  <code>menuBarItemIndex</code>, and <code>menuBarItemState</code> properties. 
 * 
 *  @see mx.controls.MenuBar 
 *  @see mx.controls.menuClasses.MenuBarItem 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */

public interface IMenuBarItemRenderer extends IDataRenderer, IUIComponent, ISimpleStyleClient, IListItemRenderer 
{
        
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  menuBar
    //----------------------------------

    /**
     *  Contains a reference to the item renderer's MenuBar control. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get menuBar():MenuBar;
    
    /**
     *  @private
     */
    function set menuBar(value:MenuBar):void;

    //----------------------------------
    //  menuBarItemIndex
    //----------------------------------

    /**
     *  Contains the index of this item renderer relative to
     *  other item renderers in the MenuBar control. 
     *  The index of the first item renderer,
     *  the left most renderer, is 0 and increases by 1 as you
     *  move to the right in the MenuBar control. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get menuBarItemIndex():int;
    
    /**
     *  @private
     */
    function set menuBarItemIndex(value:int):void;
    
    
    //----------------------------------
    //  menuBarItemState
    //----------------------------------

    /**
     *  Contains the current state of this item renderer. 
     *  The possible values are <code>"itemUpSkin"</code>, 
     *  <code>"itemDownSkin"</code>, and <code>"itemOverSkin"</code>. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get menuBarItemState():String;
    
    /**
     *  @private
     */
    function set menuBarItemState(value:String):void;


}
}
