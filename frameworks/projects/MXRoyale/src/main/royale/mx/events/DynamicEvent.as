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

import org.apache.royale.events.Event;
import org.apache.royale.reflection.getDynamicFields;
/**
 *  This subclass of Event is dynamic, meaning that you can set
 *  arbitrary event properties on its instances at runtime.
 *
 *  <p>By contrast, Event and its other subclasses are non-dynamic,
 *  meaning that you can only set properties that are declared
 *  in those classes.
 *  When prototyping an application, using a DynamicEvent can be
 *  easier because you don't have to write an Event subclass
 *  to declare the properties in advance.
 *  However, you should eventually eliminate your DynamicEvents
 *  and write Event subclasses because these are faster and safer.
 *  A DynamicEvent is so flexible that the compiler can't help you
 *  catch your error when you set the wrong property or assign it
 *  a value of an incorrect type.</p>
 *
 *  <p>Example:</p>
 *
 *  <pre>
 *  var event:DynamicEvent = new DynamicEvent("credentialsChanged");
 *  event.name = name;
 *  event.passsword = password; // misspelling won't be caught!
 *  dispatchEvent(event);
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public dynamic class DynamicEvent extends Event
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
	public function DynamicEvent(type:String, bubbles:Boolean = false,
                                 cancelable:Boolean = false)
	{
		super(type, bubbles, cancelable);
	}

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
		var event:DynamicEvent = new DynamicEvent(type, bubbles, cancelable);
		//@todo test/verify in general case:
		for each(var p:String in getDynamicFields(this))
		{
			event[p] = this[p];
		}

		return event;
	}
}

}
