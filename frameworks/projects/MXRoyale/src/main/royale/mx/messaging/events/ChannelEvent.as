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

package mx.messaging.events
{

import org.apache.royale.events.Event;
import mx.messaging.Channel;

/**
 *  The ChannelEvent is used to propagate channel events within the messaging system.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 * 
 *  @royalesuppresspublicvarwarning
 */
public class ChannelEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  The CONNECT event type; indicates that the Channel connected to its
     *  endpoint.
     *  <p>The value of this constant is <code>"channelConnect"</code>.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>channel</code></td><td>The channel that generated this event.</td></tr>   
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>reconnecting</code></td><td> Indicates whether the channel
     *       that generated this event is reconnecting.</td></tr>
     *     <tr><td><code>rejected</code></td><td> Indicates whether the channel that
     *       generated this event was rejected. This would be true in the event that
     *       the channel has been disconnected due to inactivity and should not attempt to
     *       failover or connect on an alternate channel.</td></tr>   
     *  </table>
     *  @eventType channelConnect 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */     
    public static const CONNECT:String = "channelConnect";

    /**
     *  The DISCONNECT event type; indicates that the Channel disconnected from its
     *  endpoint.
     *  <p>The value of this constant is <code>"channelDisconnect"</code>.</p>
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>channel</code></td><td>The channel that generated this event.</td></tr>   
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>reconnecting</code></td><td> Indicates whether the channel
     *       that generated this event is reconnecting.</td></tr>
     *     <tr><td><code>rejected</code></td><td> Indicates whether the channel that
     *       generated this event was rejected. This would be true in the event that
     *       the channel has been disconnected due to inactivity and should not attempt to
     *       failover or connect on an alternate channel.</td></tr>   
     *  </table>
     *  @eventType channelDisconnect
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */     
    public static const DISCONNECT:String = "channelDisconnect";
    
    //--------------------------------------------------------------------------
    //
    // Static Methods
    // 
    //--------------------------------------------------------------------------    

    /**
     *  Utility method to create a new ChannelEvent that doesn't bubble and
     *  is not cancelable.
     * 
     *  @param type The ChannelEvent type.
     *  
     *  @param channel The Channel generating the event.
     * 
     *  @param reconnecting Indicates whether the Channel is in the process of
     *  reconnecting or not.
     * 
     *  @param rejected Indicates whether the Channel's connection has been rejected,
     *  which suppresses automatic reconnection.
     * 
     *  @param connected Indicates whether the Channel that generated this event 
     *  is already connected.
     * 
     *  @return New ChannelEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */ 
    public static function createEvent(type:String, channel:Channel = null, 
            reconnecting:Boolean = false, rejected:Boolean = false, connected:Boolean = false):ChannelEvent
    {
        return new ChannelEvent(type, false, false, channel, reconnecting, rejected, connected);
    }
    
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  Constructs an instance of this event with the specified type and Channel
     *  instance.
     * 
     *  @param type The ChannelEvent type.
     * 
     *  @param bubbles Specifies whether the event can bubble up the display 
     *  list hierarchy.
     * 
     *  @param cancelable Indicates whether the behavior associated with the 
     *  event can be prevented; used by the RPC subclasses.
     *
     *  @param channel The Channel generating the event.
     * 
     *  @param reconnecting Indicates whether the Channel is in the process of
     *  reconnecting or not.
     * 
     *  @param rejected Indicates whether the Channel's connection has been rejected,
     *  which suppresses automatic reconnection.
     * 
     *  @param connected Indicates whether the Channel that generated this event 
     *  is already connected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function ChannelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, 
            channel:Channel = null, reconnecting:Boolean = false, rejected:Boolean = false, 
            connected:Boolean = false)
    {
        super(type, bubbles, cancelable);

        this.channel = channel;
        this.reconnecting = reconnecting;
        this.rejected = rejected;
        this.connected = connected;
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  The Channel that generated this event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var channel:Channel;

    /**
     * Indicates whether the Channel that generated this event is already connected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */  
    public var connected:Boolean;
        
    /**
     *  Indicates whether the Channel that generated this event is reconnecting.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var reconnecting:Boolean;
    
    /**
     *  Indicates whether the Channel that generated this event was rejected. 
     *  This would be true in the event that the channel has been
     *  disconnected due to inactivity and should not attempt to failover or
     *  connect on an alternate channel.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var rejected:Boolean;
    
    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------    

	//----------------------------------
	//  channelId
	//----------------------------------

    /**
     * @private
     */
    public function get channelId():String
    {
        if (channel != null)
        {
            return channel.id;
        }
        return null;
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    // 
    //--------------------------------------------------------------------------    

    /**
     *  Clones the ChannelEvent.
     *
     *  @return Copy of this ChannelEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    [SWFOverride(returns="flash.events.Event"))]
    COMPILE::SWF { override }
    public function clone():Event
    {
        return new ChannelEvent(type, bubbles, cancelable, channel, reconnecting, rejected, connected);
    }

    /**
     *  Returns a string representation of the ChannelEvent.
     *
     *  @return String representation of the ChannelEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    COMPILE::SWF { override }
    public function toString():String
    {
        return formatToString("ChannelEvent", "channelId", "reconnecting", "rejected", "type", "bubbles", "cancelable", "eventPhase");
    }
    
    COMPILE::JS
    public function formatToString(className:String, ... args):String
    {
        for each (var s:String in args)
        className += " " + s;
        
        return className;
    }

}

}