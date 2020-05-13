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

package mx.rpc.events
{

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 * The XMLLoadEvent class is a base class for events that are dispatched when an RPC service
 * successfully loaded an XML document.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class XMLLoadEvent extends Event
{
    /**
     * Constructor.
     *
     * @param type The event type; indicates the action that triggered the event.
     *
     * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     *
     * @param cancelable Specifies whether the behavior associated with the event can be prevented.
     *
     * @param xml The XML document loaded.
     *
     * @param location The path used to load the document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function XMLLoadEvent(type:String, bubbles:Boolean = false, 
        cancelable:Boolean = true, xml:XML = null, location:String = null)
    {
        super(type == null ? LOAD : type,
            bubbles,
            cancelable);

        this.xml = xml;
        this.location = location;
    }

    /**
     * The raw XML document.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var xml:XML;

    /**
     * The location from which the document was loaded.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var location:String;

    /**
     *  Returns a copy of this XMLLoadEvent object.
     *
     *  @return A copy of this XMLLoadEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function cloneEvent():IRoyaleEvent
    {
        return new XMLLoadEvent(type, bubbles, cancelable, xml, location);
    }

    /**
     *  Returns a String representation of this XMLLoadEvent object.
     *
     *  @return A String representation of this XMLLoadEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF {override}
    public function toString():String
    {
        return formatToString("XMLLoadEvent", "location", "type", "bubbles", 
            "cancelable", "eventPhase");
    }

    COMPILE::JS
    public function formatToString(className:String, ... rest):String
    {
        if (rest)
        {
            for (var s:String in rest)
                className += " " + s;
        }
        return className;
    }
    
    /**
     * A helper method to create a new XMLLoadEvent.
     * @private
     */
    public static function createEvent(xml:XML = null, location:String = null):XMLLoadEvent
    {
        return new XMLLoadEvent(LOAD, false, true, xml, location);
    }

    /**
     * The LOAD constant defines the value of the <code>type</code> property of the event object 
     * for a <code>xmlLoad</code> event.
     *
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     * <tr><th>Property</th><th>Value</th></tr>
     * <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
     * <tr><td><code>cancelable</code></td><td><code>true</code></td></tr>
     * <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *     event listener that handles the event. For example, if you use 
     *     <code>myButton.addEventListener()</code> to register an event listener, 
     *     myButton is the value of the <code>currentTarget</code>. </td></tr>
     * <tr><td><code>location</code></td><td>The location from which the document was loaded.</td></tr>
     * <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *     it is not always the Object listening for the event. 
     *     Use the <code>currentTarget</code> property to always access the 
     *     Object listening for the event.</td></tr>
     * <tr><td><code>xml</code></td><td>The raw XML document.</td></tr>
     * </table>
     *     
     * @eventType result      
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const LOAD:String = "xmlLoad";
}

}