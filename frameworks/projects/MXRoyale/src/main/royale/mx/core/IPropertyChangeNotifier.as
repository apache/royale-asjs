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

package mx.core
{

import org.apache.royale.events.IEventDispatcher;

/**
 *  The <code>IPropertyChangeNotifier</code> interface defines a marker 
 *  interface.
 *  Classes that support this interface declare support for event propagation
 *  in a specialized manner.
 *  Classes that implement this interface must dispatch events for each property
 *  of this class and any nested classes publicly exposed as properties.
 *  For those properties that are anonymous (complex and not strongly typed),
 *  implementing classes provide custom support or directly use the
 *  ObjectProxy class.
 *  Implementors of this interface should use the 
 *  <code>PropertyChangeEvent.createUpdateEvent()</code> method to construct an
 *  appropriate update event for dispatch.
 *  @example
 *  <code><pre>
 *   
 * function set myProperty(value:Object):void
 * {
 *    var oldValue:IPropertyChangeNotifier = _myProperty;
 *    var newValue:IPropertyChangeNotifier = value;
 *    
 *    // Need to ensure to dispatch changes on the new property.
 *    // Listeners use the source property to determine which object 
 *    // actually originated the event.
 *    // In their event handler code, they can tell if an event has been 
 *    // propagated from deep within the object graph by comparing 
 *    // event.target and event.source. If they are equal, then the property
 *    // change is at the surface of the object. If they are not equal, the
 *    // property change is somewhere deeper in the object graph.
 *    newValue.addEventListener(
 *                PropertyChangeEvent.PROPERTY_CHANGE, 
 *                dispatchEvent);
 * 
 *    // need to stop listening for events from the old property
 *    oldValue.removeEventListener(
 *                PropertyChangeEvent.PROPERTY_CHANGE,
 *                dispatchEvent);
 * 
 *    _myProperty = newValue;
 * 
 *    // now notify anyone that is listening
 *    if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
 *    {
 *         var event:PropertyChangeEvent = 
 *                         PropertyChangeEvent.createUpdateEvent(
 *                                                       this,
 *                                                       "myProperty",
 *                                                       newValue,
 *                                                       oldValue);
 *        dispatchEvent(event);
 *     }
 *  }
 * 
 *      
 *  </pre></code>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IPropertyChangeNotifier extends IEventDispatcher, IUID
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	// Inherits uid property from IUID
}

}
