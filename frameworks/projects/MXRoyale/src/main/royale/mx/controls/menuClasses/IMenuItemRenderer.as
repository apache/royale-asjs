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

import mx.controls.Menu;

/**
 *  The IMenuItemRenderer interface defines the interface
 *  that a menu item renderer for a Menu control must implement.
 * 
 *  <p>The menu item renderers are often recycled. Once they are created, 
 *  they may be used again simply by being given new data. 
 *  Therefore, in individual implementations, component developers must 
 *  make sure that component properties are not assumed to contain 
 *  specific initial, or default values.</p>
 *
 *  <p>To implement this interface, a component developer must define a 
 *  setter and getter method that implements the <code>menu</code> property.
 *  Typically, the setter method writes the value of the data property
 *  to an internal variable, and the getter method returns the current
 *  value of the internal variable, as the following example shows:</p>
 *  <pre>
 *     // Internal variable for the property value.
 *     private var _menu:Menu;
 * 
 *     // Define the getter method.
 *     public function get menu():Menu
 *     {
 *         return _menu;
 *     }
 * 
 *     // Define the setter method.
 *     public function set menu(value:Menu):void
 *     {
 *         _menu = value;
 *     }
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IMenuItemRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  menu
    //----------------------------------

    /**
     *  A reference to this menu item renderer's Menu control, 
     *  if it contains one. This indicates that this menu item
     *  renderer is a branch node, capable of popping up a sub menu.
     * 
     *  @return The reference to the Menu control. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get menu():Menu;
    
    /**
     *  @private
     */
    function set menu(value:Menu):void;
    
    /**
     *  The width of the icon.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get measuredIconWidth():Number;
    
    /**
     *  The width of the type icon (radio/check).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get measuredTypeIconWidth():Number;
    
    /**
     *  The width of the branch icon.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get measuredBranchIconWidth():Number;
}

}
