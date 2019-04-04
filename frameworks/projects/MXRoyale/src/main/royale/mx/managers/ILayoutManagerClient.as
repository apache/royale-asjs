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

// import flash.events.IEventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The ILayoutManagerClient interface defines the interface 
 *  that a component must implement to participate in the 
 *  LayoutManager's commit/measurement/layout sequence.  
 *
 *  <p>Objects that implement this interface can be passed to the
 *  LayoutManager's <code>invalidateProperties()</code> method.
 *  When the LayoutManager reaches the commit properties phase,
 *  the LayoutManager invokes this object's <code>validateProperties()</code>
 *  method.</p>
 *
 *  <p>Similarly, if an object is passed to the LayoutManager's
 *  <code>invalidateSize()</code> method, then the LayoutManager
 *  calls that object's <code>validateSize()</code> method
 *  during its measurement phase, and if an object is passed
 *  to LayoutManager's <code>invalidateDisplayList()</code> method,
 *  then the LayoutManager  calls its <code>validateDisplayList()</code> method 
 *  during the layout phase.</p>
 *
 *  <p>The ILayoutManagerClient interface is implemented by the UIComponent 
 *  and ProgrammaticSkin classes.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface ILayoutManagerClient extends IEventDispatcher
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  initialized
    //----------------------------------

    /**
     *  A flag that determines if an object has been through all three phases
     *  of layout validation (provided that any were required)
     *  This flag should only be modified by the LayoutManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get initialized():Boolean;
    
    /**
     *  @private
     */
    function set initialized(value:Boolean):void;

    //----------------------------------
    //  nestLevel
    //----------------------------------

    /**
     *  The top-level SystemManager has a nestLevel of 1.
     *  Its immediate children (the top-level Application and any pop-up
     *  windows) have a <code>nestLevel</code> of 2.
     *  Their children have a <code>nestLevel</code> of 3, and so on.  
     *
     *  The <code>nestLevel</code> is used to sort ILayoutManagerClients
     *  during the measurement and layout phases.
     *  During the commit phase, the LayoutManager commits properties on clients
     *  in order of increasing <code>nestLevel</code>, so that an object's
     *  children have already had their properties committed before Flex 
     *  commits properties on the object itself.
     *  During the measurement phase, the LayoutManager measures clients
     *  in order of decreasing <code>nestLevel</code>, so that an object's
     *  children have already been measured before Flex measures
     *  the object itself.
     *  During the layout phase, the LayoutManager lays out clients
     *  in order of increasing <code>nestLevel</code>, so that an object
     *  has a chance to set the sizes of its children before the child
     *  objects are asked to position and size their children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get nestLevel():int;
    
    /**
     *  @private
     */
    function set nestLevel(value:int):void;

    //----------------------------------
    //  processedDescriptors
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#processedDescriptors
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get processedDescriptors():Boolean;
    
    /**
     *  @private
     */
    function set processedDescriptors(value:Boolean):void;

    //----------------------------------
    //  updateCompletePendingFlag
    //----------------------------------

    /**
     *  A flag that determines if an object is waiting to have its
     *  <code>updateComplete</code> event dispatched.
     *  This flag should only be modified by the LayoutManager.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get updateCompletePendingFlag():Boolean;
    
    /**
     *  @private
     */
    function set updateCompletePendingFlag(value:Boolean):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Validates the properties of a component.
     *  If the <code>LayoutManager.invalidateProperties()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateProperties()</code> method
     *  is called when it's time to commit property values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateProperties():void;
    
    /**
     *  Validates the measured size of the component
     *  If the <code>LayoutManager.invalidateSize()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateSize()</code> method
     *  is called when it's time to do measurements.
     *
     *  @param recursive If <code>true</code>, call this method
     *  on the objects children.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateSize(recursive:Boolean = false):void;
    
    /**
     *  Validates the position and size of children and draws other
     *  visuals.
     *  If the <code>LayoutManager.invalidateDisplayList()</code> method is called with
     *  this ILayoutManagerClient, then the <code>validateDisplayList()</code> method
     *  is called when it's time to update the display list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function validateDisplayList():void;
}

}
