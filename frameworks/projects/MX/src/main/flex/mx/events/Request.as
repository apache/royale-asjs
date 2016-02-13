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

package mx.events
{

import org.apache.flex.events.Event;

/**
 *  This is an event that is expects its data property to be set by
 *  a responding listener.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Request extends Event
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    /**
     *  Dispatched from a sub-application or module to find the module factory of its parent
     *  application or module. The recipient of this request should set the data property to 
     *  their module factory.
     * 
     *  The message is dispatched from the content of a loaded module or application.
     */
    public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "getParentFlexModuleFactoryRequest";
    

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. Does not return anything, but the <code>value</code> property can be modified
     *  to represent a return value of a method.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
     *
     *  @param name Name of a property or method or name of a manager to instantiate.
     *
     *  @param value Value of a property, or an array of parameters
     *  for a method (if not null).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Request(type:String, bubbles:Boolean = false,
                                 cancelable:Boolean = false, 
                                 value:Object = null)
    {
        super(type, bubbles, cancelable);

        this.value = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  value
    //----------------------------------

    /**
     *  Value of property, or array of parameters for method.       
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var value:Object;

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function cloneEvent():Event
    {
        var cloneEvent:Request = new Request(type, bubbles, cancelable, 
                                                 value);

        return cloneEvent;
    }

}

}
