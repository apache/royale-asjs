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

package mx.messaging.channels
{

COMPILE::SWF
{
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Responder;
}
COMPILE::JS
{
import mx.events.IOErrorEvent;
import mx.events.NetStatusEvent;
import mx.events.SecurityErrorEvent;
import mx.net.Responder;    
}

import mx.core.mx_internal;
import mx.logging.Log;
import mx.messaging.MessageResponder;
import mx.messaging.RoyaleClient;
import mx.messaging.config.ConfigMap;
import mx.messaging.config.ServerConfig;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.AbstractMessage;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

//[ResourceBundle("messaging")]

/**
 *  The AMFChannel class provides the AMF support for messaging.
 *  You can configure this Channel to poll the server at an interval
 *  to approximate server push.
 *  You can also use this Channel with polling disabled to send RPC messages
 *  to remote destinations to invoke their methods.
 *
 *  <p>
 *  The AMFChannel relies on network services native to Flash Player and AIR,
 *  and exposed to ActionScript by the NetConnection class.
 *  This channel uses NetConnection exclusively, and creates a new NetConnection
 *  per instance.
 *  </p>
 *
 *  <p>
 *  Channels are created within the framework using the
 *  <code>ServerConfig.getChannel()</code> method. Channels can be constructed
 *  directly and assigned to a ChannelSet if desired.
 *  </p>
 *
 *  <p>
 *  Channels represent a physical connection to a remote endpoint.
 *  Channels are shared across destinations by default.
 *  This means that a client targetting different destinations may use
 *  the same Channel to communicate with these destinations.
 *  </p>
 *
 *  <p>
 *  When used in polling mode, this Channel polls the server for new messages
 *  based on the <code>polling-interval-seconds</code> property in the configuration file,
 *  and this can be changed by setting the <code>pollingInterval</code> property.
 *  The default value is 3 seconds.
 *  To enable polling, the channel must be connected and the <code>polling-enabled</code>
 *  property in the configuration file must be set to <code>true</code>, or the
 *  <code>pollingEnabled</code> property of the Channel must be set to <code>true</code>.
 *  </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class AMFChannel extends NetConnectionChannel
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param id The id of this Channel.
     *
     *  @param uri The uri for this Channel.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function AMFChannel(id:String = null, uri:String = null)
    {
        super(id, uri);
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     * Flag used to indicate that the channel is in the process of reconnecting
     * with the session id in the url.
     */
    protected var _reconnectingWithSessionId:Boolean;

    /**
     *  @private
     *  Flag used to control when we need to handle NetStatusEvents.
     *  If the channel has shutdown due to reaching a connect timeout we need to
     *  continue listening for events (such as 404s) but we've already shutdown so
     *  we must ignore them.
     */
    private var _ignoreNetStatusEvents:Boolean;

    /**
     *  @private
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  piggybackingEnabled
    //----------------------------------

    /**
     *  Indicates whether this channel will piggyback poll requests along
     *  with regular outbound messages when an outstanding poll is not in
     *  progress. This allows the server to piggyback data for the client
     *  along with its response to client's message.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get piggybackingEnabled():Boolean
    {
        return internalPiggybackingEnabled;
    }

    /**
     *  @private
     */
    public function set piggybackingEnabled(value:Boolean):void
    {
        internalPiggybackingEnabled = value;
    }

    //----------------------------------
    //  pollingEnabled
    //----------------------------------

    /**
     *  Indicates whether this channel is enabled to poll.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get pollingEnabled():Boolean
    {
        return internalPollingEnabled;
    }

    /**
     *  @private
     */
    public function set pollingEnabled(value:Boolean):void
    {
        internalPollingEnabled = value;
    }

    //----------------------------------
    //  pollingInterval
    //----------------------------------

    /**
     *  Provides access to the polling interval for this Channel.
     *  The value is in milliseconds.
     *  This value determines how often this Channel requests messages from
     *  the server, to approximate server push.
     *
     *  @throws ArgumentError If the pollingInterval is assigned a value of 0 or
     *                        less.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get pollingInterval():Number
    {
        return internalPollingInterval;
    }

    /**
     *  @private
     */
    public function set pollingInterval(value:Number):void
    {
        internalPollingInterval = value;
    }

    //----------------------------------
    //  polling
    //----------------------------------

    /**
     *  Reports whether the channel is actively polling.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get polling():Boolean
    {
        return pollOutstanding;
    }

    //----------------------------------
    //  protocol
    //----------------------------------

    /**
     *  Returns the protocol for this channel (http).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    override public function get protocol():String
    {
        return "http";
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Public Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Processes polling related configuration settings.
     */
    override public function applySettings(settings:XML):void
    {
        super.applySettings(settings);
        applyPollingSettings(settings);
    }

    /**
     *  @private
     *  Overriding to be able to keep track of the fact that the Channel is in
     *  the process of reconnecting with the session id, so the initial
     *  NetConnection call can be discarded properly in the resultHandler.
     */
    override public function AppendToGatewayUrl(value:String):void
    {
        if (value != null && value != "" && _appendToURL != value)
        {
            super.AppendToGatewayUrl(value);
            _reconnectingWithSessionId = true;
        }
    }
    //--------------------------------------------------------------------------
    //
    // Protected Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Attempts to connect to the endpoint specified for this channel.
     */
    override protected function internalConnect():void
    {
        super.internalConnect();
        _ignoreNetStatusEvents = false;

        // Ping the server to make sure that it is reachable.
        var msg:CommandMessage = new CommandMessage();
        if (credentials != null)
        {
            msg.operation = CommandMessage.LOGIN_OPERATION;
            msg.body = credentials;
        }
        else
        {
            msg.operation = CommandMessage.CLIENT_PING_OPERATION;
        }

        // Report the messaging version for this Channel.
        msg.headers[CommandMessage.MESSAGING_VERSION] = messagingVersion;

        // Indicate if requesting the dynamic configuration from the server.
        if (ServerConfig.needsConfig(this))
            msg.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;

        // Add the RoyaleClient id header.
        setRoyaleClientIdOnMessage(msg);

        netConnection.call(null, new Responder(resultHandler, faultHandler), msg);
        if (Log.isDebug())
            _log.debug("'{0}' pinging endpoint.", id);
    }

    /**
     *  @private
     *  Disconnects from the remote destination.
     *  Because this channel uses a stateless HTTP connection, it sends a fire-and-forget
     *  message to the server as it disconnects to allow the server to shut down any
     *  session or other resources that it may be managing on behalf of this channel.
     */
    override protected function internalDisconnect(rejected:Boolean = false):void
    {
        // Attempt to notify the server of the disconnect.
        if (!rejected && !shouldBeConnected)
        {
            var msg:CommandMessage = new CommandMessage();
            msg.operation = CommandMessage.DISCONNECT_OPERATION;
            internalSend(new MessageResponder(null, msg, null));
        }
        // Shut down locally.
        setConnected(false);
        super.internalDisconnect(rejected);
    }

    /**
     *  @private
     */
    override protected function internalSend(msgResp:MessageResponder):void
    {
        handleReconnectWithSessionId(); // Adjust the session id, in case it's needed.
        super.internalSend(msgResp);
    }

    /**
     *  @private
     *  Shuts down the underlying NetConnection for the AMFChannel.
     *  The reason this override is necessary is because the NetConnection may dispatch
     *  a NetStatusEvent after it has been closed and if we're not registered to listen for
     *  that event the Player will throw an RTE.
     *  The only time this can occur when the channel has been shut down due to a connect
     *  timeout but an error (i.e. 404) response from the server returns later.
     */
    override protected function shutdownNetConnection():void
    {
        _nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        _nc.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        // Leave the NetStatusEvent statusHandler registered but set the ignore flag.
        _ignoreNetStatusEvents = true;
        _nc.close();
    }

    /**
     *  @private
     *  Called on the status event of the associated NetConnection when there is a
     *  problem with the connection for this channel.
     */
    override protected function statusHandler(event:NetStatusEvent):void
    {
        if (_ignoreNetStatusEvents)
            return; // Ignore NetStatusEvents that are dispatched after the NetConnection has been closed.

        var channelFault:ChannelFaultEvent;

        if (Log.isDebug())
            _log.debug("'{0}' channel got status. {1}", id, event.info.toString());

        var handled:Boolean = true;
        // We should always have a non-null info object.
        if (event.info != null)
        {
            var info:Object = event.info;
            // If the level is error we couldn't communicate with the server.
            if (info.level == "error")
            {
                // Suppress processing of "Client.Data.Underflow" status events which are dispatched for
                // any outstanding AMF messages in HTTP responses that are not fully received because
                // the underlying connection has closed mid-response.
                if (info.code == "Client.Data.UnderFlow")
                {
                    if (Log.isDebug())
                        _log.debug("'{0}' channel received a 'Client.Data.Underflow' status event.");

                    return; // Skip further processing.
                }

                if (connected)
                {
                    if (info.code.indexOf("Call.Failed") != -1)
                    {
                        channelFault = ChannelFaultEvent.createEvent(this,
                                        false, "Channel.Call.Failed", info.level,
                                        info.code + ": " + info.description)
                        channelFault.rootCause = info;
                        // Dispatch the fault.
                        dispatchEvent(channelFault);
                    }
                    /*
                     * A NetConnection.Call.Failed indicates that the server is
                     * not running or the URL to the channel endpoint is incorrect.
                     *
                     * If we didn't receive a NetConnection.Call.Failed, and the status
                     * info object has a level of "error" then we must have received one
                     * of:
                     *     NetConnection.Connect.AppShutdown
                     *     NetConnection.Connect.Failed
                     *     NetConnection.Connect.Rejected
                     * None of these have anything to do with call processing.
                     *
                     * In any case, at this point we need to indicate to the channel that
                     * it is disconnected which may trigger failover/hunting.
                     */
                    internalDisconnect();
                }
                else
                {
                    channelFault = ChannelFaultEvent.createEvent(this,
                                    false, "Channel.Connect.Failed", info.level,
                                    info.code + ": " + info.description + ": url: '" + endpoint + "'");
                    channelFault.rootCause = info;
                    connectFailed(channelFault);
                }
             }
             else
             {
                 // Ignore NetConnection.Connect.Closed events when the
                 // Channel is in the process of failing over to another url but
                 // it receives a delayed NetConnection.Connect.Closed for the
                 // previous failed url.
                 if (!connected)
                    handled = (info.level == "status" && info.code.indexOf("Connect.Closed") != -1);
                 else
                    handled = false;
             }
         }
         else
         {
             handled = false;
         }
         // If we haven't handled the status event, perform default handling.
         if (!handled)
         {
             var errorText:String = resourceManager.getString(
                "messaging", "invalidURL");
             connectFailed(ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", "error", errorText + " url: '" + endpoint + "'"));
         }
    }

    //--------------------------------------------------------------------------
    //
    // Protected Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Used by result and fault handlers to update the url of the underlying
     *  NetConnection with session id.
     */
    protected function handleReconnectWithSessionId():void
    {
        if (_reconnectingWithSessionId)
        {
            _reconnectingWithSessionId = false;
            shutdownNetConnection();
            super.internalConnect(); // To avoid another ping request.
            _ignoreNetStatusEvents = false;
        }
    }

    /**
     *  @private
     *  Called in response to the server ping to check connectivity.
     *  An error indicates that although the endpoint uri is reachable the Channel
     *  is still not able to connect.
     */
    protected function faultHandler(msg:ErrorMessage):void
    {
        if (msg != null)
        {
            var faultEvent:ChannelFaultEvent = null;
            // An authentication fault means we reached it which
            // still means we can connect.
            if (msg.faultCode == "Client.Authentication")
            {
                resultHandler(msg);
                faultEvent = ChannelFaultEvent.createEvent(this, false, "Channel.Authentication.Error", "warn", msg.faultString);
                faultEvent.rootCause = msg;
                dispatchEvent(faultEvent);
            }
            else
            {
                _log.debug("'{0}' fault handler called. {1}", id, msg.toString());

                // Set the server assigned RoyaleClient Id.
                if (RoyaleClient.getInstance().id == null && msg["headers"] != undefined && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
                    RoyaleClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];

                // Process the features advertised by the server endpoint.
                if (msg["headers"] != undefined && msg.headers[CommandMessage.MESSAGING_VERSION] != null)
                {
                    var serverVersion:Number = msg.headers[CommandMessage.MESSAGING_VERSION] as Number;
                    handleServerMessagingVersion(serverVersion);
                }
                faultEvent = ChannelFaultEvent.createEvent(this, false,
                                                "Channel.Ping.Failed",
                                                "error",
                                                msg.faultString + " url: '" + endpoint
                                                + (_appendToURL == null ? "" : _appendToURL + "'") + "'");
                faultEvent.rootCause = msg;
                connectFailed(faultEvent);
            }
        }

        handleReconnectWithSessionId();
    }

    /**
     *  @private
     *  This method will be called if the ping message sent to test connectivity
     *  to the server during the connection attempt succeeds.
     */
    protected function resultHandler(msg:IMessage):void
    {
        // Update the ServerConfig with dynamic configuration
        if (msg != null)
        {
            ServerConfig.updateServerConfigData(msg.body as ConfigMap, endpoint);

            // Set the server assigned RoyaleClient Id.
            if (RoyaleClient.getInstance().id == null && msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] != null)
                RoyaleClient.getInstance().id = msg.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER];

            // Process the features advertised by the server endpoint.
            if (msg.headers[CommandMessage.MESSAGING_VERSION] != null)
            {
                var serverVersion:Number = msg.headers[CommandMessage.MESSAGING_VERSION] as Number;
                handleServerMessagingVersion(serverVersion);
            }
        }

        handleReconnectWithSessionId();

        connectSuccess();
        if (credentials != null && !(msg is ErrorMessage))
            setAuthenticated(true);
    }
}

}