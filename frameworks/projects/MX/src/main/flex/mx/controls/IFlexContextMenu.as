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

/**
 *  The IFlexContextMenu interface defines the interface for a 
 *  Flex context menus.  
 *
 *  @see mx.core.UIComponent#flexContextMenu
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFlexContextMenu
{
COMPILE::AS3
{
	import flash.display.InteractiveObject;		
}
COMPILE::JS
{
	import flex.display.InteractiveObject;		
}

    /**
     *  Sets the context menu of an InteractiveObject.  This will do 
     *  all the necessary steps to add the InteractiveObject as the context 
     *  menu for this InteractiveObject, such as adding listeners, etc..
     * 
     *  @param component InteractiveObject to set context menu on
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function setContextMenu(component:InteractiveObject):void;
    
    /**
     *  Unsets the context menu of a InteractiveObject.  This will do 
     *  all the necessary steps to remove the InteractiveObject as the context 
     *  menu for this InteractiveObject, such as removing listeners, etc..
     * 
     *  @param component InteractiveObject to unset context menu on
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    function unsetContextMenu(component:InteractiveObject):void;

}

}
