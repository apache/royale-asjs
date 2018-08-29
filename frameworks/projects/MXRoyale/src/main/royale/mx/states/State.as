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

package mx.states
{

import org.apache.royale.states.State;
import mx.core.mx_internal;
import mx.events.FlexEvent;

use namespace mx_internal;

/**
 *  Dispatched just before a view state is exited.
 *  This event is dispatched before the changes
 *  to the default view state have been removed.
 *
 *  @eventType mx.events.FlexEvent.EXIT_STATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="exitState", type="mx.events.FlexEvent")]

/**
 *  The State class defines a view state, a particular view of a component.
 *  For example, a product thumbnail could have two view states;
 *  a base view state with minimal information, and a rich view state with
 *  additional information.
 *  The <code>overrides</code> property specifies a set of child classes
 *  to add or remove from the base view state, and properties, styles, and event
 *  handlers to set when the view state is in effect.
 *
 *  <p>You use the State class in the <code>states</code> property
 *  of Flex components.
 *  You can only specify a <code>states</code> property at the root of an
 *  application or a custom control, not on child controls.</p>
 *
 *  <p>You enable a view state by setting a component's
 *  <code>currentState</code> property.</p>
 *
 *  @mxml
 *  <p>The <code>&lt;mx:State&gt;</code> tag has the following attributes:</p>
 *
 *  <pre>
 *  &lt;mx:State
 *  <b>Properties</b>
 *  basedOn="null"
 *  name="null"
 *  overrides="null"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.states.AddChild
 *  @see mx.states.RemoveChild
 *  @see mx.states.SetEventHandler
 *  @see mx.states.SetProperty
 *  @see mx.states.SetStyle
 *  @see mx.states.Transition
 *
 *  @includeExample examples/StatesExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class State extends org.apache.royale.states.State
{

    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble up
     *  the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function State(properties:Object = null)
    {
        super(properties);
    }

	 
}

}
