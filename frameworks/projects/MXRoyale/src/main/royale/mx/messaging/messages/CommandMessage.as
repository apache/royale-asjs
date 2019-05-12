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

package mx.messaging.messages
{

import org.apache.royale.utils.net.IDataInput;
import org.apache.royale.utils.net.IDataOutput;
import org.apache.royale.utils.net.IExternalizable;

[RemoteClass(alias="flex.messaging.messages.CommandMessage")]

/**
 *  The CommandMessage class provides a mechanism for sending commands to the
 *  server infrastructure, such as commands related to publish/subscribe
 *  messaging scenarios, ping operations, and cluster operations.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3
 */
public class CommandMessage extends AsyncMessage
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  This operation is used to subscribe to a remote destination.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const SUBSCRIBE_OPERATION:uint = 0;

    /**
     *  This operation is used to unsubscribe from a remote destination.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const UNSUBSCRIBE_OPERATION:uint = 1;

    /**
     *  This operation is used to poll a remote destination for pending,
     *  undelivered messages.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const POLL_OPERATION:uint = 2;

    /**
     *  This operation is used by a remote destination to sync missed or cached messages
     *  back to a client as a result of a client issued poll command.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const CLIENT_SYNC_OPERATION:uint = 4;

    /**
     *  This operation is used to test connectivity over the current channel to
     *  the remote endpoint.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const CLIENT_PING_OPERATION:uint = 5;
    
    /**
     *  This operation is used to request a list of failover endpoint URIs
     *  for the remote destination based on cluster membership.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const CLUSTER_REQUEST_OPERATION:uint = 7;
    
    /**
     * This operation is used to send credentials to the endpoint so that
     * the user can be logged in over the current channel.
     * The credentials need to be Base64 encoded and stored in the <code>body</code>
     * of the message.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const LOGIN_OPERATION:uint = 8;
    
    /**
     * This operation is used to log the user out of the current channel, and
     * will invalidate the server session if the channel is HTTP based.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const LOGOUT_OPERATION:uint = 9;

    /**
     * Endpoints can imply what features they support by reporting the
     * latest version of messaging they are capable of during the handshake of
     * the initial ping CommandMessage.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const MESSAGING_VERSION:String = "DSMessagingVersion";

    /**
     * This operation is used to indicate that the client's subscription with a
     * remote destination has timed out.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const SUBSCRIPTION_INVALIDATE_OPERATION:uint = 10;

    /**
     * Used by the MultiTopicConsumer to subscribe/unsubscribe for more
     * than one topic in the same message.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const MULTI_SUBSCRIBE_OPERATION:uint = 11;
    
    /**
     *  This operation is used to indicate that a channel has disconnected.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const DISCONNECT_OPERATION:uint = 12;
    
    /**
     *  This operation is used to trigger a ChannelSet to connect.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const TRIGGER_CONNECT_OPERATION:uint = 13;
    
    /**
     *  This is the default operation for new CommandMessage instances.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const UNKNOWN_OPERATION:uint = 10000;
    
    /**
     *  The server message type for authentication commands.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const AUTHENTICATION_MESSAGE_REF_TYPE:String = "flex.messaging.messages.AuthenticationMessage";

    /**
     *  Subscribe commands issued by a Consumer pass the Consumer's <code>selector</code>
     *  expression in this header.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const SELECTOR_HEADER:String = "DSSelector";
    
    /**
     *  Durable JMS subscriptions are preserved when an unsubscribe message
     *  has this parameter set to true in its header.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const PRESERVE_DURABLE_HEADER:String = "DSPreserveDurable";

    /**
     * Header to indicate that the Channel needs the configuration from the
     * server.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const NEEDS_CONFIG_HEADER:String = "DSNeedsConfig";

    /**
     * Header used in a MULTI_SUBSCRIBE message to specify an Array of subtopic/selector
     * pairs to add to the existing set of subscriptions.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const ADD_SUBSCRIPTIONS:String = "DSAddSub";

    /**
     * Like the above, but specifies the subtopic/selector array of to remove
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const REMOVE_SUBSCRIPTIONS:String = "DSRemSub";
    
    /**
     * The separator string used for separating subtopic and selectors in the
     * add and remove subscription headers.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const SUBTOPIC_SEPARATOR:String = "_;_";
    
    /**
     * Header to drive an idle wait time before the next client poll request.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const POLL_WAIT_HEADER:String = "DSPollWait";
    
    /**
     * Header to suppress poll response processing. If a client has a long-poll
     * parked on the server and issues another poll, the response to this subsequent poll
     * should be tagged with this header in which case the response is treated as a
     * no-op and the next poll will not be scheduled. Without this, a subsequent poll
     * will put the channel and endpoint into a busy polling cycle.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const NO_OP_POLL_HEADER:String = "DSNoOpPoll";

    /**
     * Header to specify which character set encoding was used while encoding
     * login credentials.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const CREDENTIALS_CHARSET_HEADER:String = "DSCredentialsCharset";

    /**
     * Header to indicate the maximum number of messages a Consumer wants to
     * receive per second.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static const MAX_FREQUENCY_HEADER:String = "DSMaxFrequency";
    
    /**
     * Header that indicates the message is a heartbeat.
     */
    public static const HEARTBEAT_HEADER:String = "DS<3";

    //--------------------------------------------------------------------------
    //
    // Private Static Constants for Serialization
    //
    //--------------------------------------------------------------------------

    private static const OPERATION_FLAG:uint = 1;

    //--------------------------------------------------------------------------
    //
    // Static Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Map of operations to semi-descriptive operation text strings.
     */
    private static var operationTexts:Object = null;

    
    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an instance of a CommandMessage with an empty body and header
     *  and a default <code>operation</code> of <code>UNKNOWN_OPERATION</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public function CommandMessage()
    {
        super();
        operation = UNKNOWN_OPERATION;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

    private var _operation:uint;
    
    /**
     *  Provides access to the operation/command for the CommandMessage.
     *  Operations indicate how this message should be processed by the remote
     *  destination.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public function get operation():uint
    {
        return _operation;
    }
    public function set operation(value:uint):void
    {
        _operation = value;
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    override public function getSmallMessage():IMessage
    {
        // We shouldn't use small messages for PING or LOGIN operations as the
        // messaging version handshake would not yet be complete... for now just
        // optimize POLL operations.
        if (operation == POLL_OPERATION)
        {
            return new CommandMessageExt(this);
        }

        return null;
    }

    /**
     *  @private
     */
    override protected function addDebugAttributes(attributes:Object):void
    {
        super.addDebugAttributes(attributes);
        attributes["operation"] = getOperationAsString(operation);
    }
    
    /**
     *  Returns a string representation of the message.
     *
     *  @return String representation of the message.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
    override public function toString():String
    {
        return getDebugString();
    }
     */

    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Provides a description of the operation specified.
     *  This method is used in <code>toString()</code> operations on this
     *  message.
     *
     *  @param op One of the CommandMessage operation constants.
     *
     *  @return Short name for the operation.
     *
     *  @example
     *  <code><pre>
     *     var msg:CommandMessage = CommandMessage(event.message);
     *     trace("Current operation -'"+
     *            CommandMessage.getOperationAsString(msg.operation)+ "'.");
     *  </pre></code>
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3
     */
    public static function getOperationAsString(op:uint):String
    {
        if (operationTexts == null)
        {
            operationTexts = {};
            operationTexts[SUBSCRIBE_OPERATION] = "subscribe";
            operationTexts[UNSUBSCRIBE_OPERATION] = "unsubscribe";
            operationTexts[POLL_OPERATION] = "poll";
            operationTexts[CLIENT_SYNC_OPERATION] = "client sync";
            operationTexts[CLIENT_PING_OPERATION] = "client ping";
            operationTexts[CLUSTER_REQUEST_OPERATION] = "cluster request";
            operationTexts[LOGIN_OPERATION] = "login";
            operationTexts[LOGOUT_OPERATION] = "logout";
            operationTexts[SUBSCRIPTION_INVALIDATE_OPERATION] = "subscription invalidate";
            operationTexts[MULTI_SUBSCRIBE_OPERATION] = "multi-subscribe";
            operationTexts[DISCONNECT_OPERATION] = "disconnect";
            operationTexts[TRIGGER_CONNECT_OPERATION] = "trigger connect";
            operationTexts[UNKNOWN_OPERATION] = "unknown";
        }
        var result:* = operationTexts[op];
        return result == undefined ? op.toString() : String(result);
    }

    /**
     * @private
     */
    override public function readExternal(input:IDataInput):void
    {
        super.readExternal(input);

        var flagsArray:Array = readFlags(input);
        for (var i:uint = 0; i < flagsArray.length; i++)
        {
            var flags:uint = flagsArray[i] as uint;
            var reservedPosition:uint = 0;

            if (i == 0)
            {
                if ((flags & OPERATION_FLAG) != 0)
                    operation = input.readObject() as uint;

                reservedPosition = 1;
            }

            // For forwards compatibility, read in any other flagged objects
            // to preserve the integrity of the input stream...
            if ((flags >> reservedPosition) != 0)
            {
                for (var j:uint = reservedPosition; j < 6; j++)
                {
                    if (((flags >> j) & 1) != 0)
                    {
                        input.readObject();
                    }
                }
            }
        }
    }

    /**
     * @private
     */
    override public function writeExternal(output:IDataOutput):void
    {
        super.writeExternal(output);

        var flags:uint = 0;

        if (operation != 0)
            flags |= OPERATION_FLAG;

        output.writeByte(flags);

        if (operation != 0)
            output.writeObject(operation);
    }
    
}

}
