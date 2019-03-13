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

package mx.messaging
{

import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
import mx.logging.Log;
import mx.messaging.messages.AbstractMessage;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.IMessage;

use namespace mx_internal;

/**
 *  A Producer sends messages to a destination.
 *  Producers dispatch a MessageAckEvent or MessageFaultEvent 
 *  for each message they send depending upon whether the outbound message
 *  was sent and processed successfully or not.
 *  @mxml
 *  <p>
 *  The &lt;mx:Producer&gt; tag inherits all the tag attributes of its superclass, and adds the following tag attributes:
 *  </p>
 *  <pre>
 *   &lt;mx:Producer
 *    <b>Properties</b>
 *    defaultHeaders="<i>No default.</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class Producer extends AbstractProducer
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------

    /**
     *  The default message priority.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const DEFAULT_PRIORITY:int = 4;

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     * 
     *  @example
     *  <pre>
     *   function sendMessage():void
     *   {
     *       var producer:Producer = new Producer();
     *       producer.destination = "NASDAQ";
     *       var msg:AsyncMessage = new AsyncMessage();
     *       msg.headers.operation = "UPDATE";
     *       msg.body = {"SYMBOL":50.00};
     *       producer.send(msg);
     *   }
     *   </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function Producer()
    {
        super();
        _log = Log.getLogger("mx.messaging.Producer");
        _agentType = "producer";
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    //----------------------------------
    //  subtopic
    //----------------------------------    

    /**
     *  @private
     */
    private var _subtopic:String = "";
    
    [Bindable(event="propertyChange")]
    
    /**
     *  Provides access to the subtopic for the remote destination that the MessageAgent uses.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get subtopic():String
    {
        return _subtopic;
    }
    
    /**
     *  @private
     */
    public function set subtopic(value:String):void
    {
        if (_subtopic != value)
        {
            var event:PropertyChangeEvent;
            if (value == null)
                value = "";

            event = PropertyChangeEvent.createUpdateEvent(this, "subtopic", _subtopic, value);
            _subtopic = value;                

            dispatchEvent(event);
        }
    }

    //--------------------------------------------------------------------------
    //
    // Protected Methods
    // 
    //--------------------------------------------------------------------------

    /**
     * @private
     */ 
    override protected function internalSend(message:IMessage, waitForClientId:Boolean = true):void
    {
        if (subtopic.length > 0)
            message.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopic;    

        handlePriority(message);

        super.internalSend(message, waitForClientId);
    }

    //--------------------------------------------------------------------------
    //
    // Private Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  If the priority header has been set on the message, makes sure that the
     *  priority value is within the valid range (0-9). If no priority header
     *  has been set, tries to use Producer's priority level if one exists.
     * 
     */
    private function handlePriority(message:IMessage):void
    {
        // If message priority is already set, make sure it's within range.
        if (message.headers[AbstractMessage.PRIORITY_HEADER] != null)
        {
            var messagePriority:int = message.headers[AbstractMessage.PRIORITY_HEADER];
            if (messagePriority < 0)
                message.headers[AbstractMessage.PRIORITY_HEADER] = 0;
            else if (messagePriority > 9)
                message.headers[AbstractMessage.PRIORITY_HEADER] = 9;
        }
        // Otherwise, see if there's the default priority property is set.
        else if (priority > -1)
        {
            message.headers[AbstractMessage.PRIORITY_HEADER] = priority;
        }
    }
}

}
