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

import mx.errors.IllegalOperationError;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.utils.Timer;
import org.apache.royale.reflection.getDefinitionByName;

import mx.collections.ArrayCollection;
import mx.core.IMXMLObject;
import mx.core.mx_internal;
import mx.events.PropertyChangeEvent;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.RoyaleClient;
import mx.messaging.config.LoaderConfig;
import mx.messaging.config.ServerConfig;
import mx.messaging.errors.InvalidChannelError;
import mx.messaging.errors.InvalidDestinationError;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.AbstractMessage;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.AsyncDispatcher;
import mx.utils.URLUtil;

use namespace mx_internal;

/**
 *  Dispatched after the channel has connected to its endpoint.
 * <p>Channel and its subclasses issue a Channel.Connect.Failed code whenever there is an issue in a channel's  connect attempts to a remote destination. An AMFChannel object issues Channel.Call.Failed code when the channel is already connected but it gets a Call.Failed code from its underlying NetConnection.</p>
 *
 *  @eventType mx.messaging.events.ChannelEvent.CONNECT
 */
[Event(name="channelConnect", type="mx.messaging.events.ChannelEvent")]

/**
 *  Dispatched after the channel has disconnected from its endpoint.
 *
 *  @eventType mx.messaging.events.ChannelEvent.DISCONNECT
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
[Event(name="channelDisconnect", type="mx.messaging.events.ChannelEvent")]

/**
 *  Dispatched after the channel has faulted.
 * 
 *  @eventType mx.messaging.events.ChannelFaultEvent.FAULT
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3  
 */
[Event(name="channelFault", type="mx.messaging.events.ChannelFaultEvent")]

/**
 *  Dispatched when a channel receives a message from its endpoint.
 * 
 *  @eventType mx.messaging.events.MessageEvent.MESSAGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3  
 */
[Event(name="message", type="mx.messaging.events.MessageEvent")]

/**
 *  Dispatched when a property of the channel changes.
 * 
 *  @eventType mx.events.PropertyChangeEvent.PROPERTY_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
[Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]

//[ResourceBundle("messaging")]

/**
 *  The Channel class is the base message channel class that all channels in the messaging
 *  system must extend.
 *
 *  <p>Channels are specific protocol-based conduits for messages sent between 
 *  MessageAgents and remote destinations.
 *  Preconfigured channels are obtained within the framework using the
 *  <code>ServerConfig.getChannel()</code> method.
 *  You can create a Channel directly using the <code>new</code> operator and
 *  add it to a ChannelSet directly.</p>
 * 
 *  <p>
 *  Channels represent a physical connection to a remote endpoint.
 *  Channels are shared across destinations by default.
 *  This means that a client targetting different destinations may use
 *  the same Channel to communicate with these destinations.
 *  </p>
 *
 *  <p><b>Note:</b> This class is for advanced use only.
 *  Use this class for creating custom channels like the existing RTMPChannel,
 *  AMFChannel, and HTTPChannel.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class Channel extends EventDispatcher implements IMXMLObject
{
    //--------------------------------------------------------------------------
    //
    // Protected Static Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Channel config parsing constants. 
     */
    protected static const CLIENT_LOAD_BALANCING:String = "client-load-balancing"
    protected static const CONNECT_TIMEOUT_SECONDS:String = "connect-timeout-seconds";
    protected static const ENABLE_SMALL_MESSAGES:String = "enable-small-messages";
    protected static const FALSE:String = "false";
    protected static const RECORD_MESSAGE_TIMES:String = "record-message-times";
    protected static const RECORD_MESSAGE_SIZES:String = "record-message-sizes";
    protected static const REQUEST_TIMEOUT_SECONDS:String = "request-timeout-seconds";
    protected static const SERIALIZATION:String = "serialization";
    protected static const TRUE:String = "true";

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     *  Constructs an instance of a generic Channel that connects to the
     *  specified endpoint URI.
     *
     *  <b>Note</b>: The Channel type should not be constructed directly. Instead
     *  create instances of protocol specific subclasses such as RTMPChannel or
     *  AMFChannel.
     *
     *  @param id The id of this channel.
     * 
     *  @param uri The endpoint URI for this channel.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3      
     */
    public function Channel(id:String = null, uri:String = null)
    {
        super();

        _log = Log.getLogger("mx.messaging.Channel");
        _failoverIndex = -1;
        this.id = id;
        _primaryURI = uri;
        this.uri = uri; // Current URI
    }

    /**
     * @private
     */
    public function initialized(document:Object, id:String):void
    {
        this.id = id;
    }
        
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Used to prevent multiple logouts.
     */
    mx_internal var authenticating:Boolean;
    
    /**
     *  @private
     *  The credentials string that is passed via a CommandMessage to the server when the
     *  Channel connects. Channels inherit the credentials of connected ChannelSets that
     *  inherit their credentials from connected MessageAgents. 
     *  <code>MessageAgent.setCredentials(username, password)</code> is generally used
     *  to set credentials.
     */
    protected var credentials:String;

    /**
     * @private
     * A channel specific override to determine whether small messages should
     * be used. If set to false, small messages will not be used even if they
     * are supported by an endpoint.
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var enableSmallMessages:Boolean = true;

    /**
     *  @private
     *  Provides access to a logger for this channel.
     */
    protected var _log:ILogger;
    
    /**
     *  @private
     *  Flag indicating whether the Channel is in the process of connecting.
     */
    protected var _connecting:Boolean;

    /**
     *  @private
     *  Timer to track connect timeouts.
     */
    private var _connectTimer:Timer;   

    /**
     *  @private
     *  Current index into failover URIs during a failover attempt.
     *  When not failing over, this variable is reset to a sentinal
     *  value of -1.
     */
    private var _failoverIndex:int; 

    /**
     * @private
     * Flag indicating whether the endpoint has been calculated from the uri.
     */   
    private var _isEndpointCalculated:Boolean;

    /**
     * @private
     * The messaging version implies which features are enabled on this client
     * channel. Channel endpoints exchange this information through headers on
     * the ping CommandMessage exchanged during the connection handshake.
     */
    protected var messagingVersion:Number = 1.0;

    /**
     *  @private
     *  Flag indicating whether this Channel owns the wait guard for managing initial connect attempts.
     */
    private var _ownsWaitGuard:Boolean;
    
    /**
     *  @private
     *  Indicates whether the Channel was previously connected successfully. Used for pinned reconnect
     *  attempts before trying failover options.
     */
    private var _previouslyConnected:Boolean;
    
    /**
     *  @private
     *  Primary URI; the initial URI for this channel.
     */
    private var _primaryURI:String
    
    /**
     *  @private
     *  Used for pinned reconnect attempts.
     */
    mx_internal var reliableReconnectDuration:int = -1;
    private var _reliableReconnectBeginTimestamp:Number;
    private var _reliableReconnectLastTimestamp:Number;
    private var _reliableReconnectAttempts:int;

    /**
     *  @private
     */
    private var resourceManager:IResourceManager = ResourceManager.getInstance();   
    
    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    //----------------------------------
    //  channelSets
    //----------------------------------
    
    /**
     *  @private
     */
    private var _channelSets:Array = [];
    
    /**
     *  Provides access to the ChannelSets connected to the Channel.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get channelSets():Array
    {
        return _channelSets;   
    }    

    //----------------------------------
    //  connected
    //----------------------------------

    /**
     *  @private
     */
    private var _connected:Boolean = false;

    [Bindable(event="propertyChange")]
    /**
     *  Indicates whether this channel has established a connection to the 
     *  remote destination.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3      
     */
    public function get connected():Boolean
    {
        return _connected;
    }
    
    /**
     *  @private
     */
    protected function setConnected(value:Boolean):void
    {
        if (_connected != value)
        {
            if (_connected)
               _previouslyConnected = true;
            
            var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "connected", _connected, value)
            _connected = value;
            dispatchEvent(event);
            if (!value)
                setAuthenticated(false);
        }
    }
    
    //----------------------------------
    //  connectTimeout
    //----------------------------------
    
    /**
     *  @private
     */
    private var _connectTimeout:int = -1;   
    
    /**
     *  Provides access to the connect timeout in seconds for the channel. 
     *  A value of 0 or below indicates that a connect attempt will never 
     *  be timed out on the client.
     *  For channels that are configured to failover, this value is the total
     *  time to wait for a connection to be established.
     *  It is not reset for each failover URI that the channel may attempt 
     *  to connect to.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */ 
    public function get connectTimeout():int
    {
        return _connectTimeout;
    }
    
    /**
     *  @private
     */
    public function set connectTimeout(value:int):void
    {
        _connectTimeout = value;
    }   
    
    //----------------------------------
    //  endpoint
    //----------------------------------    

    /**
     *  @private
     */ 
    private var _endpoint:String;   
    
    /**
     *  Provides access to the endpoint for this channel.
     *  This value is calculated based on the value of the <code>uri</code>
     *  property.
     */
    public function get endpoint():String
    {
        if (!_isEndpointCalculated)
            calculateEndpoint();
        return _endpoint;
    }

    //----------------------------------
    //  recordMessageTimes
    //----------------------------------
        
    /**
     * @private
     */
    protected var _recordMessageTimes:Boolean = false;

    /**
     * Channel property determines the level of performance information injection - whether
     * we inject timestamps or not. 
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get recordMessageTimes():Boolean
    {
        return _recordMessageTimes;
    }   

    //----------------------------------    
    //  recordMessageSizes
    //----------------------------------
        
    /**
     * @private
     */
    protected var _recordMessageSizes:Boolean = false;

    /**
     * Channel property determines the level of performance information injection - whether
     * we inject message sizes or not.
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3      
     */   
    public function get recordMessageSizes():Boolean
    {
        return _recordMessageSizes;
    }         
    
    //----------------------------------
    //  reconnecting
    //----------------------------------

    /**
     *  @private
     */
    private var _reconnecting:Boolean = false;

    [Bindable(event="propertyChange")]
    /**
     *  Indicates whether this channel is in the process of reconnecting to an
     *  alternate endpoint.
     */
    public function get reconnecting():Boolean
    {
        return _reconnecting;
    }
    
    private function setReconnecting(value:Boolean):void
    {
        if (_reconnecting != value)
        {
            var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "reconnecting", _reconnecting, value);
            _reconnecting = value;
            dispatchEvent(event);
        }
    }
    
    //----------------------------------
    //  failoverURIs
    //----------------------------------    
    
    /**
     *  @private
     */
    private var _failoverURIs:Array;    
    
    /**
     *  Provides access to the set of endpoint URIs that this channel can
     *  attempt to failover to if the endpoint is clustered.
     *
     *  <p>This property is automatically populated when clustering is enabled.
     *  If you don't use clustering, you can set your own values.</p>
     */ 
    public function get failoverURIs():Array
    {
        return (_failoverURIs != null) ? _failoverURIs : [];
    }
    
    /**
     *  @private
     */
    public function set failoverURIs(value:Array):void
    {
        if (value != null)
        {
            _failoverURIs = value;
            _failoverIndex = -1; // Reset the index, because URIs have changed
        }
    }   

    //----------------------------------
    //  id
    //----------------------------------
    
    /**
     *  @private
     */
    private var _id:String; 
    
    /**
     *  Provides access to the id of this channel.
     */
    public function get id():String
    {
        return _id;
    }
    
    public function set id(value:String):void
    {
        if (_id != value)
            _id = value;
    }

    //----------------------------------
    //  authenticated
    //----------------------------------

    private var _authenticated:Boolean = false;
    
    [Bindable(event="propertyChange")]
    /**
     *  Indicates if this channel is authenticated.
     */
    public function get authenticated():Boolean
    {
        return _authenticated;
    }
    
    mx_internal function setAuthenticated(value:Boolean):void
    {
        if (value != _authenticated)
        {
            var event:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, "authenticated", _authenticated, value);
            _authenticated = value;

            var cs:ChannelSet;
            for (var i:int = 0; i < _channelSets.length; i++)
            {
                cs = ChannelSet(_channelSets[i]);
                cs.mx_internal::setAuthenticated(authenticated, credentials)
            }
                
            dispatchEvent(event);
        }
    }   

    //----------------------------------
    //  protocol
    //----------------------------------

    /**
     *  Provides access to the protocol that the channel uses.
     *
     *  <p><b>Note:</b> Subclasses of Channel must override this method and return 
     *  a string that represents their supported protocol.
     *  Examples of supported protocol strings are "rtmp", "http" or "https".
     * </p>
     */
    public function get protocol():String
    {
        throw new IllegalOperationError("Channel subclasses must override "
            + "the get function for 'protocol' to return the proper protocol "
            + "string.");     
    }

    //----------------------------------
    //  realtime
    //----------------------------------

    /**
     *  @private
     *  Returns true if the channel supports realtime behavior via server push or client poll.
     */
    mx_internal function get realtime():Boolean
    {
        return false;
    }
    
    //----------------------------------
    //  requestTimeout
    //----------------------------------
    
    /**
     *  @private
     */
    private var _requestTimeout:int = -1;   
    
    /**
     *  Provides access to the default request timeout in seconds for the 
     *  channel. A value of 0 or below indicates that outbound requests will 
     *  never be timed out on the client.
     *  <p>Request timeouts are most useful for RPC style messaging that 
     *  requires a response from the remote destination.</p>
     */ 
    public function get requestTimeout():int
    {
        return _requestTimeout;
    }
    
    /**
     *  @private
     */
    public function set requestTimeout(value:int):void
    {
        _requestTimeout = value;
    }

    //----------------------------------
    //  shouldBeConnected
    //----------------------------------
    
    /**
     *  @private  
     */
    private var _shouldBeConnected:Boolean;
    
    /**
     *  Indicates whether this channel should be connected to its endpoint.
     *  This flag is used to control when fail over should be attempted and when disconnect
     *  notification is sent to the remote endpoint upon disconnect or fault.
     */
    protected function get shouldBeConnected():Boolean
    {
        return _shouldBeConnected;
    }

    //----------------------------------
    //  uri
    //----------------------------------

    /**
     *  @private
     */
    private var _uri:String;

    /**
     *  Provides access to the URI used to create the whole endpoint URI for this channel. 
     *  The URI can be a partial path, in which case the full endpoint URI is computed as necessary.
     */
    public function get uri():String
    {
        return _uri;
    } 

    public function set uri(value:String):void
    {
        if (value != null)
        {
            _uri = value;
            calculateEndpoint(); 
        }
    }

    /**
     * @private
     * This alternate property for an endpoint URL is provided to match the
     * endpoint configuration attribute &quot;url&quot;. This property is
     * equivalent to the <code>uri</code> property.
     */
    public function get url():String
    {
        return uri;
    } 

    /**
     * @private
     */
    public function set url(value:String):void
    {
        uri = value;
    }

    //----------------------------------
    //  useSmallMessages
    //----------------------------------

    /**
     * @private
     */
    private var _smallMessagesSupported:Boolean;

    /**
     * This flag determines whether small messages should be sent if the
     * alternative is available. This value should only be true if both the
     * client channel and the server endpoint have successfully advertised that
     * they support this feature.
     * @private
     */
    public function get useSmallMessages():Boolean
    {
        return _smallMessagesSupported && enableSmallMessages;
    }

    /**
     * @private
     */
    public function set useSmallMessages(value:Boolean):void
    {
        _smallMessagesSupported = value;
    }

    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Subclasses should override this method to apply any settings that may be
     *  necessary for an individual channel.
     *  Make sure to call <code>super.applySettings()</code> to apply common settings for the channel. * *  This method is used primarily in Channel subclasses.
     *
     *  @param settings XML fragment of the services-config.xml file for this channel.
       */
    public function applySettings(settings:XML):void
    {
        if (Log.isInfo())
            _log.info("'{0}' channel settings are:\n{1}", id, settings);

        if (settings.properties.length() == 0)
            return;

        var props:XML = settings.properties[0];
        applyClientLoadBalancingSettings(props);
        if (props[CONNECT_TIMEOUT_SECONDS].length() != 0)
            connectTimeout = props[CONNECT_TIMEOUT_SECONDS].toString();
        if (props[RECORD_MESSAGE_TIMES].length() != 0)
            _recordMessageTimes = props[RECORD_MESSAGE_TIMES].toString() == TRUE;
        if (props[RECORD_MESSAGE_SIZES].length() != 0)
            _recordMessageSizes = props[RECORD_MESSAGE_SIZES].toString() == TRUE;
        if (props[REQUEST_TIMEOUT_SECONDS].length() != 0)
            requestTimeout = props[REQUEST_TIMEOUT_SECONDS].toString();
        var serializationProps:XMLList = props[SERIALIZATION];
        if (serializationProps.length() != 0 && serializationProps[ENABLE_SMALL_MESSAGES].toString() == FALSE)
            enableSmallMessages = false;
    }

    /**
     *  Applies the client load balancing urls if they exists. It randomly picks
     *  a url from the set of client load balancing urls and sets it as the channel's
     *  main url; then it assigns the rest of the urls as the <code>failoverURIs</code>
     *  of the channel.
     *
     *  @param props The properties section of the XML fragment of the services-config.xml
     *  file for this channel.
     */
    protected function applyClientLoadBalancingSettings(props:XML):void
    {
        var clientLoadBalancingProps:XMLList = props[CLIENT_LOAD_BALANCING];
        if (clientLoadBalancingProps.length() == 0)
            return;

        var urlCount:int = clientLoadBalancingProps.url.length();
        if (urlCount == 0)
            return;

        // Add urls to an array, so they can be shuffled.
        var urls:Array = [];
        for each (var url:XML in clientLoadBalancingProps.url)
            urls.push(url.toString());

        shuffle(urls);

        // Select the first url as the main url.
        if (Log.isInfo())
            _log.info("'{0}' channel picked {1} as its main url.", id, urls[0]);
        this.url = urls[0];

        // Assign the rest of the urls as failoverUris.
        var failoverURIs:Array = urls.slice(1);
        if (failoverURIs.length > 0)
            this.failoverURIs = failoverURIs;
    }

    /**
     *  Connects the ChannelSet to the Channel. If the Channel has not yet
     *  connected to its endpoint, it attempts to do so.
     *  Channel subclasses must override the <code>internalConnect()</code> 
     *  method, and call the <code>connectSuccess()</code> method once the
     *  underlying connection is established.
     * 
     *  @param channelSet The ChannelSet to connect to the Channel.
     */
    final public function connect(channelSet:ChannelSet):void
    {               
        var exists:Boolean = false;
        var n:int = _channelSets.length;
        for (var i:int = 0; i < _channelSets.length; i++)
        {
            if (_channelSets[i] == channelSet)
            {
                exists = true;
                break;   
            }
        }
        
        _shouldBeConnected = true;
        if (!exists)
        {
            _channelSets.push(channelSet);
            // Wire up ChannelSet's channel event listeners.
            addEventListener(ChannelEvent.CONNECT, channelSet.channelConnectHandler);
            addEventListener(ChannelEvent.DISCONNECT, channelSet.channelDisconnectHandler);
            addEventListener(ChannelFaultEvent.FAULT, channelSet.channelFaultHandler);
        }       
        // If we are already connected, notify the ChannelSet. Otherwise connect
        // if necessary.
        if (connected)
        {
            channelSet.channelConnectHandler(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, false, false, connected));
        }
        else if (!_connecting)
        {            
            _connecting = true;
         
            // If a connect timeout is defined, start the corresponding timer.
            if (connectTimeout > 0)
            {
                _connectTimer = new Timer(connectTimeout * 1000, 1);
                _connectTimer.addEventListener(Timer.TIMER, connectTimeoutHandler);
                _connectTimer.start();
            }
            
            // We have to prevent a race between multipe Channel instances attempting to connect concurrently
            // at application startup. We detect this situation by testing whether the RoyaleClient Id has been assigned or not.
            if (RoyaleClient.getInstance().id == null)
            {
                var royaleClient:RoyaleClient = RoyaleClient.getInstance();
                if (!royaleClient.waitForRoyaleClientId)
                {
                    royaleClient.waitForRoyaleClientId = true;
                    // This will cause other Channels to wait to attempt to connect.
                    // This Channel can continue its attempt.
                    _ownsWaitGuard = true;
                    internalConnect();
                }
                else
                {
                    // This Channel should wait to attempt to connect.
                    royaleClient.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, royaleClientWaitHandler);
                }                
            }
            else
            {
                // Another Channel has connected and we have an assigned RoyaleClient Id.
                internalConnect();
            }
        }
    }

    /**
     *  Disconnects the ChannelSet from the Channel. If the Channel is connected
     *  to its endpoint and it has no more connected ChannelSets it will 
     *  internally disconnect.
     *
     *  <p>Channel subclasses need to override the 
     *  <code>internalDisconnect()</code> method, and call the
     *  <code>disconnectSuccess()</code> method when the underlying connection
     *  has been terminated.</p>
     * 
     *  @param channelSet The ChannelSet to disconnect from the Channel.
     */
    final public function disconnect(channelSet:ChannelSet):void
    {
        // If we own the wait guard for initial Channel connects release it.
        // This will only be true if this Channel is the first to attempt to connect
        // but its connect attempt is still pending when disconnect() is invoked.
        if (_ownsWaitGuard)
        {
            _ownsWaitGuard = false;
            RoyaleClient.getInstance().waitForRoyaleClientId = false; // Allow other Channels to connect.
        }
        
        // Disconnect the channelSet.
        var i:int = channelSet != null ? _channelSets.indexOf(channelSet) : -1;
        if (i != -1)
        {
            _channelSets.splice(i, 1);
            // Remove the ChannelSet as a listener to this Channel.
            removeEventListener(ChannelEvent.CONNECT, channelSet.channelConnectHandler, false);
            removeEventListener(ChannelEvent.DISCONNECT, channelSet.channelDisconnectHandler, false);                
            removeEventListener(ChannelFaultEvent.FAULT, channelSet.channelFaultHandler, false);
            
            // Notify the ChannelSet of the disconnect.                
            if (connected) 
            {    
                channelSet.channelDisconnectHandler(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, false));
            }
        
            // Shut down the underlying connection if this Channel has no more 
            // ChannelSets using it.
            if (_channelSets.length == 0)
            {
                _shouldBeConnected = false;
                if (connected)
                    internalDisconnect();
            }
        }
    }
    
    /**
     *  Sends a CommandMessage to the server to logout if the Channel is connected.
     *  Current credentials are cleared.
     * 
     *  @param agent The MessageAgent to logout.
     */
    public function logout(agent:MessageAgent):void
    {
        if ((connected && authenticated && credentials) || (authenticating && credentials))
        {       
            var msg:CommandMessage = new CommandMessage();
            msg.operation = CommandMessage.LOGOUT_OPERATION;
            internalSend(new AuthenticationMessageResponder(agent, msg, this, _log));
            authenticating = true;
        }
        credentials = null;
    }

    /**
     *  Sends the specified message to its target destination.
     *  Subclasses must override the <code>internalSend()</code> method to
     *  perform the actual send.
     *
     *  @param agent The MessageAgent that is sending the message.
     * 
     *  @param message The Message to send.
     * 
     *  @throws mx.messaging.errors.InvalidDestinationError If neither the MessageAgent nor the
     *                                  message specify a destination.
     */
    public function send(agent:MessageAgent, message:IMessage):void
    {
        // Set the destination header of the message if it is not already set.
        if (message.destination.length == 0)
        {
            if (agent.destination.length == 0)
            {
                var msg:String = resourceManager.getString(
                    "messaging", "noDestinationSpecified");
                throw new InvalidDestinationError(msg);
            }
            message.destination = agent.destination;
        }

        if (Log.isDebug())
            _log.debug("'{0}' channel sending message:\n{1}", id, message.toString());

        // Tag the message with a header indicating the Channel/Endpoint used for transport.    
        message.headers[AbstractMessage.ENDPOINT_HEADER] = id;

        var responder:MessageResponder = getMessageResponder(agent, message);
        initializeRequestTimeout(responder);
        internalSend(responder);
    }

    /**
     *  Sets the credentials to the specified value. 
     *  If the credentials are non-null and the Channel is connected, this method also
     *  sends a CommandMessage to the server to login using the credentials.
     * 
     *  @param credentials The credentials string.
     *  @param agent The MessageAgent to login, that will handle the login result.
     *  @param charset The character set encoding used while encoding the
     *  credentials. The default is null, which implies the legacy charset of
     *  ISO-Latin-1.
     *
     *  @throws flash.errors.IllegalOperationError in two situations; if credentials
     *  have already been set and an authentication is in progress with the remote
     *  detination, or if authenticated and the credentials specified don't match
     *  the currently authenticated credentials.
     */
    public function setCredentials(credentials:String, agent:MessageAgent=null, charset:String=null):void
    {
        var changedCreds:Boolean = this.credentials !== credentials;

        if (authenticating && changedCreds)
            throw new IllegalOperationError("Credentials cannot be set while authenticating or logging out.");

        if (authenticated && changedCreds)
            throw new IllegalOperationError("Credentials cannot be set when already authenticated. Logout must be performed before changing credentials.");
        
        this.credentials = credentials;
        if (connected && changedCreds && credentials != null)
        {
            authenticating = true;
            var msg:CommandMessage = new CommandMessage();
            msg.operation = CommandMessage.LOGIN_OPERATION;
            msg.body = credentials;
            if (charset != null)
                msg.headers[CommandMessage.CREDENTIALS_CHARSET_HEADER] = charset;
            internalSend(new AuthenticationMessageResponder(agent, msg, this, _log));  
        }
    }
    
    /**
     * @private     
     * Should we record any performance metrics
     */       
    public function get mpiEnabled():Boolean
    {
        return _recordMessageSizes || _recordMessageTimes;
    }       

    //--------------------------------------------------------------------------
    //
    // Internal Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Internal hook for ChannelSet to assign credentials when it has authenticated
     *  successfully via a direct <code>login(...)</code> call to the server.
     */
    mx_internal function internalSetCredentials(credentials:String):void
    {
        this.credentials = credentials;
    }

    /**
     *  @private
     *  This is a hook for ChannelSet (not a MessageAgent) to send internal messages. 
     *  This is used for fetching info on clustered endpoints for a clustered destination
     *  as well as for optional heartbeats, etc.
     * 
     *  @param msgResp The message responder to use for the internal message.
     */
    mx_internal function sendInternalMessage(msgResp:MessageResponder):void
    {
        internalSend(msgResp);
    }

    //--------------------------------------------------------------------------
    //
    // Protected Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Processes a failed internal connect and dispatches the 
     *  <code>FAULT</code> event for the channel.
     *  If the Channel has <code>failoverURI</code> values, it will
     *  attempt to reconnect automatically by trying these URI values in order until 
     *  a connection is established or the available values are exhausted.
     * 
     *  @param event The ChannelFaultEvent for the failed connect.
     */
    protected function connectFailed(event:ChannelFaultEvent):void
    {            
        shutdownConnectTimer();
        setConnected(false);
        
        if (Log.isError())
            _log.error("'{0}' channel connect failed.", id);
            
        if (!event.rejected && shouldAttemptFailover())
        {
            _connecting = true;
            failover();            
        }
        else // Not attempting failover.
        {
            connectCleanup();
        }
        
        if (reconnecting)
            event.reconnecting = true;
        dispatchEvent(event);
    }

    /**
     *  Processes a successful internal connect and dispatches the 
     *  <code>CONNECT</code> event for the Channel.
     */
    protected function connectSuccess():void
    {
        shutdownConnectTimer();
        
        // If there were any attached agents that needed configuration they
        // should be reset.
        if (ServerConfig.fetchedConfig(endpoint))
        {
            for (var i:int = 0; i < channelSets.length; i++)
            {
                var messageAgents:Array = ChannelSet(channelSets[i]).messageAgents;
                for (var j:int = 0; j < messageAgents.length; j++)
                {
                    messageAgents[j].needsConfig = false;
                }
            }
        }
            
        setConnected(true);
        _failoverIndex = -1;
        
        if (Log.isInfo())
            _log.info("'{0}' channel is connected.", id);
              
        dispatchEvent(ChannelEvent.createEvent(ChannelEvent.CONNECT, this, reconnecting));
                                                                
        connectCleanup();
    }
    
    /**
     *  Handles a connect timeout by dispatching a ChannelFaultEvent. 
     *  Subtypes may overide this to shutdown the current connect attempt but must 
     *  call <code>super.connectTimeoutHandler(event)</code>.
     * 
     *  @param event The timer event indicating that the connect timeout has been reached.
     */
    protected function connectTimeoutHandler(event:Event):void
    {
        shutdownConnectTimer();
        if (!connected)
        {
            _shouldBeConnected = false;
            var errorText:String = resourceManager.getString(
                "messaging", "connectTimedOut");
            var faultEvent:ChannelFaultEvent = ChannelFaultEvent.createEvent(this, false, "Channel.Connect.Failed", "error", errorText);
            connectFailed(faultEvent);
        }                
    }

    /**
     *  Processes a successful internal disconnect and dispatches the 
     *  <code>DISCONNECT</code> event for the Channel.
     *  If the disconnect is due to a network failure and the Channel has 
     *  <code>failoverURI</code> values, it will attempt to reconnect automatically 
     *  by trying these URI values in order until a connection is established or the 
     *  available values are exhausted.
     *  
     *  @param rejected True if the disconnect should skip any
     *         failover processing that would otherwise be attempted; false
     *         if failover processing should be allowed to run.
     */
    protected function disconnectSuccess(rejected:Boolean = false):void
    {             
        setConnected(false);
        
        if (Log.isInfo())
            _log.info("'{0}' channel disconnected.", id);
        
        if (!rejected && shouldAttemptFailover())
        {
            _connecting = true;
            failover();
        }
        else
        {
            connectCleanup();
        }
        
        dispatchEvent(ChannelEvent.createEvent(ChannelEvent.DISCONNECT, this, 
                                            reconnecting, rejected));
    }

    /**
     *  Processes a failed internal disconnect and dispatches the
     *  <code>FAULT</code> event for the channel.
     * 
     *  @param event The ChannelFaultEvent for the failed disconnect.
     */
    protected function disconnectFailed(event:ChannelFaultEvent):void
    {
        _connecting = false;  
        setConnected(false);

        if (Log.isError())
            _log.error("'{0}' channel disconnect failed.", id);
        
        if (reconnecting)
        {
            resetToPrimaryURI();
            event.reconnecting = false;
        }       
        dispatchEvent(event);
    }
    
    /**
     *  Handles a change to the guard condition for managing initial Channel connect for the application.
     *  When this is invoked it means that this Channel is waiting to attempt to connect.
     * 
     *  @param event The PropertyChangeEvent dispatched by the RoyaleClient singleton.
     */
    protected function royaleClientWaitHandler(event:PropertyChangeEvent):void
    {
        if (event.property == "waitForRoyaleClientId")
        {
            var royaleClient:RoyaleClient = event.source as RoyaleClient;
            if (royaleClient.waitForRoyaleClientId == false) // The wait is over, claim it and attempt to connect.
            {               
                royaleClient.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, royaleClientWaitHandler);
                royaleClient.waitForRoyaleClientId = true;
                // This will cause other Channels to wait to attempt to connect.
                // This Channel can continue its attempt.
                _ownsWaitGuard = true;
                internalConnect();
            }
        }
    }

    /**
     *  Returns the appropriate MessageResponder for the Channel's
     *  <code>send()</code> method.
     *  Must be overridden.
     *
     *  @param agent The MessageAgent sending the message.
     * 
     *  @param message The Message to send.
     * 
     *  @return The MessageResponder to handle the result or fault.
     * 
     *  @throws flash.errors.IllegalOperationError If the Channel subclass does not override
     *                                this method.
     */
    protected function getMessageResponder(agent:MessageAgent, 
                                            message:IMessage):MessageResponder
    {
        throw new IllegalOperationError("Channel subclasses must override "
                                                + " getMessageResponder().");
    }

    /**
     *  Connects the Channel to its endpoint.
     *  Must be overridden.
     */
    protected function internalConnect():void {}

    /**
     *  Disconnects the Channel from its endpoint. 
     *  Must be overridden.
     * 
     *  @param rejected True if the disconnect was due to a connection rejection or timeout
     *                  and reconnection should not be attempted automatically; otherwise false. 
     */
    protected function internalDisconnect(rejected:Boolean = false):void {}
    
    /**
     *  Sends the Message out over the Channel and routes the response to the
     *  responder.
     *  Must be overridden.
     * 
     *  @param messageResponder The MessageResponder to handle the response.
     */
    protected function internalSend(messageResponder:MessageResponder):void {}

    /**
     * @private
     * Utility method to examine the reported server messaging version and
     * thus determine which features are available.
     */
    protected function handleServerMessagingVersion(version:Number):void
    {
        useSmallMessages = version >= messagingVersion;
    }

    /**
     *  @private
     *  Utility method used to assign the RoyaleClient Id value to outbound messages.
     * 
     *  @param message The message to set the RoyaleClient Id on.
     */
    protected function setRoyaleClientIdOnMessage(message:IMessage):void
    {
        var id:String = RoyaleClient.getInstance().id;
        message.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] = (id != null) ? id : RoyaleClient.NULL_ROYALECLIENT_ID;
    }


    //--------------------------------------------------------------------------
    //
    // Private Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private   
     *  This method calculates the endpoint value based on the current
     *  <code>uri</code>.
     */
    private function calculateEndpoint():void
    {
        if (uri == null)
        {
            var message:String = resourceManager.getString(
                "messaging", "noURLSpecified");
            throw new InvalidChannelError(message);
        }

        var uriCopy:String = uri;
        var proto:String = URLUtil.getProtocol(uriCopy);

        if (proto.length == 0)
            uriCopy = URLUtil.getFullURL(LoaderConfig.url, uriCopy);

        if (URLUtil.hasTokens(uriCopy) && !URLUtil.hasUnresolvableTokens())
        {
            _isEndpointCalculated = false;
            return;
        }

        uriCopy = URLUtil.replaceTokens(uriCopy);
        
        // Now, check for a final protocol after relative URLs and tokens
        // have been replaced
        proto = URLUtil.getProtocol(uriCopy);

        if (proto.length > 0)
            _endpoint = URLUtil.replaceProtocol(uriCopy, protocol);
        else
            _endpoint = protocol + ":" + uriCopy;

        _isEndpointCalculated = true;
        
        if (Log.isInfo())
            _log.info("'{0}' channel endpoint set to {1}", id, _endpoint);            
    }
    
    /**
     *  @private
     *  Initializes the request timeout for this message if the outbound message 
     *  defines a REQUEST_TIMEOUT_HEADER value. 
     *  If this header is not set and the default requestTimeout for the 
     *  channel is greater than 0, the channel default is used. 
     *  Otherwise, no request timeout is enforced on the client.
     * 
     *  @param messageResponder The MessageResponder to handle the response and monitor the outbound
     *                          request for a timeout.
     */
    private function initializeRequestTimeout(messageResponder:MessageResponder):void
    {
        var message:IMessage = messageResponder.message;
        // Turn on request timeout machinery if the message defines it.
        if (message.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER] != null)
        {
            messageResponder.startRequestTimeout(message.headers[AbstractMessage.REQUEST_TIMEOUT_HEADER]);
        }
        else if (requestTimeout > 0) // Use the channel default.
        {
            messageResponder.startRequestTimeout(requestTimeout);    
        }
    }    
    
    /**
     *  @private
     *  Convenience method to test whether the Channel should attempt to
     *  failover.
     * 
     *  @return <code>true</code> if the Channel should try to failover;
     *          otherwise <code>false</code>.
     */
    private function shouldAttemptFailover():Boolean
    {
        return (_shouldBeConnected && 
                   (_previouslyConnected ||
                   (reliableReconnectDuration != -1) || 
                   ((_failoverURIs != null) &&  (_failoverURIs.length > 0))));  
    } 
    
    /**
     *  @private
     *  This method attempts to fail the Channel over to the next available URI.
     */
    private function failover():void
    {
        // Potentially enter reliable reconnect loop.
        if (_previouslyConnected)
        {
            _previouslyConnected = false;              
                      
            var acs:Class = null;
            try
            {
                acs = getDefinitionByName("mx.messaging.AdvancedChannelSet") as Class;
            } 
            catch (ignore:Error) {}
            var duration:int = -1;                      
            if (acs != null)
            {                
                for each (var channelSet:ChannelSet in channelSets)
                {
                    if (channelSet is acs)
                    {
                        var d:int = (channelSet as acs)["reliableReconnectDuration"];
                        if (d > duration)
                            duration = d;
                    }                     
                }
            }
                       
            if (duration != -1)
            {
                setReconnecting(true);
                reliableReconnectDuration = duration;
                _reliableReconnectBeginTimestamp = new Date().valueOf();
                new AsyncDispatcher(reconnect, null, 1);
                return; // Exit early.
            }
        }
        
        // Potentially continue reliable reconnect loop.
        if (reliableReconnectDuration != -1)
        {
            _reliableReconnectLastTimestamp = new Date().valueOf();
            var remaining:Number = reliableReconnectDuration - (_reliableReconnectLastTimestamp - _reliableReconnectBeginTimestamp);            
            if (remaining > 0)
            {                                
                // Apply exponential backoff.
                var delay:int = 1000; // 1 second.
                delay = delay << ++_reliableReconnectAttempts;
                if (delay < remaining)
                {
                    new AsyncDispatcher(reconnect, null, delay);
                    return; // Exit early. 
                }
            }
            // At this point the reliable reconnect duration has been exhausted.
            reliableReconnectCleanup();
        }
        
        // General failover handling.
        ++_failoverIndex;
        if ((_failoverIndex + 1) <= failoverURIs.length)
        {
            setReconnecting(true);
            uri = failoverURIs[_failoverIndex];
            
            if (Log.isInfo())
            {
                _log.info("'{0}' channel attempting to connect to {1}.", id, endpoint);
            }
            // NetConnection based channels may have their underlying resources
            // GC'ed at the end of the execution of the handler that has
            // invoked this method, which means that the results of a call to 
            // internalConnect() for these channels may magically vanish once 
            // the handler exits. 
            // A timer introduces a slight delay in the reconnect attempt to
            // give the handler time to finish executing, at which point the 
            // internals of a NetConnection channel will be stable and we can 
            // attempt to connect successfully.
            // This timer is applied to all channels but the impact is small 
            // enough and the failover scenario rare enough that special casing 
            // this for only NetConnection channels is more trouble than it's 
            // worth. 
            new AsyncDispatcher(reconnect, null, 1);          
        }
        else
        {
            if (Log.isInfo())
            {
                _log.info("'{0}' channel has exhausted failover options and has reset to its primary endpoint.", id);
            }
            // Nothing left to failover to; reset to primary.
            resetToPrimaryURI();         
        }
    }
    
    /**
     *  @private
     *  Cleanup following a connect or failover attempt.
     */
    private function connectCleanup():void
    {
        // If we own the wait guard for initial Channel connects release it.
        if (_ownsWaitGuard)
        {
            _ownsWaitGuard = false;
            RoyaleClient.getInstance().waitForRoyaleClientId = false; // Allow other Channels to connect.
        }
        
        _connecting = false;
        
        setReconnecting(false); // Ensure the reconnecting flag is turned off; failover is not being attempted.
        
        reliableReconnectCleanup();
    }
    
    /**
     *  @private
     *  This method is invoked by a timer from failover() and it works around a 
     *  reconnect issue with NetConnection based channels by invoking 
     *  internalConnect() after a slight delay.
     */
    private function reconnect(event:Event=null):void
    {
        internalConnect();
    }

    /**
     *  @private
     *  Cleanup following a reliable reconnect attempt.
     */
    private function reliableReconnectCleanup():void
    {
        reliableReconnectDuration = -1;
        _reliableReconnectBeginTimestamp = 0;
        _reliableReconnectLastTimestamp = 0;
        _reliableReconnectAttempts = 0;
    }
    
    /**
     *  @private
     *  This method resets the channel back to its primary URI after
     *  exhausting all failover URIs.
     */
    private function resetToPrimaryURI():void
    {
        _connecting = false;
        setReconnecting(false);
        uri = _primaryURI;
        _failoverIndex = -1;
    }
    
    /**
     *  @private
     *  Shuffles the array.
     */
    private function shuffle(elements:Array):void
    {
        var length:int = elements.length;
        for(var i:int=0; i < length; i++)
        {
            var index:int = Math.floor(Math.random()* length);
            if (index != i)
            {
                var temp:Object = elements[i];
                elements[i] = elements[index];
                elements[index] = temp;
            }
        }
    }

    /**
     *  @private
     *  Shuts down and nulls out the connect timer.
     */
    private function shutdownConnectTimer():void
    {
        if (_connectTimer != null)
        {
            _connectTimer.stop();
            _connectTimer.removeEventListener(Timer.TIMER, connectTimeoutHandler);
            _connectTimer = null;
        }
    }

    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public static const SMALL_MESSAGES_FEATURE:String = "small_messages";
    
    /**
     *  @private
     *  Creates a compile time dependency on ArrayCollection to ensure
     *  it is present for response data containing collections.
     */ 
    private static const dep:ArrayCollection = null;
}

}

//------------------------------------------------------------------------------
//
// Private Classes
// 
//------------------------------------------------------------------------------

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.Channel;
import mx.messaging.MessageAgent;
import mx.messaging.MessageResponder;
import mx.messaging.events.ChannelEvent;
import mx.messaging.events.ChannelFaultEvent;
import mx.messaging.messages.CommandMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.events.PropertyChangeEvent;

/**
 *  @private
 *  Responder for processing channel authentication responses.
 */
class AuthenticationMessageResponder extends MessageResponder
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    public function AuthenticationMessageResponder(agent:MessageAgent,
                                message:IMessage, channel:Channel, log:ILogger)
    {
        super(agent, message, channel);
        _log = log;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Reference to the logger for the associated Channel.
     */
    private var _log:ILogger;
    
    //--------------------------------------------------------------------------
    //
    // Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Handles an authentication result.
     * 
     *  @param msg The result Message.
     */
    override protected function resultHandler(msg:IMessage):void
    {
        var cmd:CommandMessage = message as CommandMessage;
        channel.mx_internal::authenticating = false;
        if (cmd.operation == CommandMessage.LOGIN_OPERATION)
        {
            if (Log.isDebug())
                _log.debug("Login successful");    

            // we want to set the authenticated property last as it will dispatch
            // an event in this case and handler code shouldn't get called
            // util the system is stable.
            channel.mx_internal::setAuthenticated(true);
        }
        else // Logout operation.
        {
            if (Log.isDebug())
                _log.debug("Logout successful");
                
            channel.mx_internal::setAuthenticated(false);
        }
    }

    /**
     *  Handles an authentication failure.
     * 
     *  @param msg The failure Message.
     */
    override protected function statusHandler(msg:IMessage):void
    {
        var cmd:CommandMessage = CommandMessage(message);
        
        if (Log.isDebug())
        {
            _log.debug("{1} failure: {0}", msg.toString(), 
                        cmd.operation == CommandMessage.LOGIN_OPERATION ? "Login" : "Logout");    
        }

        channel.mx_internal::authenticating = false;
        channel.mx_internal::setAuthenticated(false);

        if (agent != null && agent.hasPendingRequestForMessage(message))
        {
            agent.fault(ErrorMessage(msg), message);
        }
        else
        {
            var errMsg:ErrorMessage = ErrorMessage(msg);
            var channelFault:ChannelFaultEvent = 
                                        ChannelFaultEvent.createEvent(channel, false, 
                                        "Channel.Authentication.Error", "warn", 
                                        errMsg.faultString);
            channelFault.rootCause = errMsg;                        
            channel.dispatchEvent(channelFault);
        }
    }
}
