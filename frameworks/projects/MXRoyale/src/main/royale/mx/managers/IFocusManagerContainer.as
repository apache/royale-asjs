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

package mx.managers
{

import org.apache.royale.events.IEventDispatcher;
import mx.core.IFlexDisplayObject;
import mx.managers.IFocusManager;
import mx.managers.ISystemManager;

/**
 *  The IFocusManagerContainer interface defines the interface that 
 *  containers implement to host a FocusManager.
 *  The PopUpManager automatically installs a FocusManager
 *  in any IFocusManagerContainer it pops up.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFocusManagerContainer extends IEventDispatcher 
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  focusManager
    //----------------------------------

    /**
     *  The FocusManager for this component. 
     *  The FocusManager must be in a <code>focusManager</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get focusManager():IFocusManager;
    
    /**
     *  @private
     */
    function set focusManager(value:IFocusManager):void;

    //----------------------------------
    //  defaultButton
    //----------------------------------
    
    /**
     *  The Button control designated as the default button
     *  for the container.
     *  When controls in the container have focus, pressing the
     *  Enter key is the same as clicking this Button control.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @default null
     */
    //function get defaultButton():IFlexDisplayObject;
    
    /**
     *  @private
     */
    //function set defaultButton(value:IFlexDisplayObject):void;
    
    //----------------------------------
    //  systemManager
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#systemManager
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get systemManager():ISystemManager;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Determines whether the specified display object is a child 
     *  of the container instance or the instance itself. 
     *  The search includes the entire display list including this container instance. 
     *  Grandchildren, great-grandchildren, and so on each return <code>true</code>.
     *
     *  @param child The child object to test.
     *
     *  @return <code>true</code> if the child object is a child of the container 
     *  or the container itself; otherwise <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    //function contains(child:DisplayObject):Boolean;
}

}
