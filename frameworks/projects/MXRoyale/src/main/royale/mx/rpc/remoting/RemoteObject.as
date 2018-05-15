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

package mx.rpc.remoting
{
import org.apache.royale.events.EventDispatcher;
/*
import mx.core.mx_internal;
import mx.messaging.Channel;
import mx.messaging.ChannelSet;
import mx.messaging.channels.AMFChannel;
import mx.messaging.channels.SecureAMFChannel;
import mx.rpc.AbstractOperation;
import mx.rpc.AbstractService;
import mx.rpc.mxml.Concurrency;

use namespace mx_internal;
*/
/**
 * The RemoteObject class gives you access to classes on a remote application server.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public dynamic class RemoteObject 
	//		extends AbstractService
{
    //-------------------------------------------------------------------------
    //
    //              Constructor
    //
    //-------------------------------------------------------------------------

    /**
     * Creates a new RemoteObject.
     * @param destination [optional] Destination of the RemoteObject; should match a destination name in the services-config.xml file.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function RemoteObject(destination:String = null)
    {
        super();

    //    concurrency = Concurrency.MULTIPLE;
        makeObjectsBindable = true;
        showBusyCursor = false;
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------
    
    private var _concurrency:String;
    
//    private var _endpoint:String;

//    private var _source:String;
    
    private var _makeObjectsBindable:Boolean;

    private var _showBusyCursor:Boolean;

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    [Inspectable(enumeration="multiple,single,last", defaultValue="multiple", category="General")]
   /**
    * Value that indicates how to handle multiple calls to the same service. The default
    * value is multiple. The following values are permitted:
    * <ul>
    * <li>multiple - Existing requests are not cancelled, and the developer is
    * responsible for ensuring the consistency of returned data by carefully
    * managing the event stream. This is the default.</li>
    * <li>single - Making only one request at a time is allowed on the method; additional requests made 
    * while a request is outstanding are immediately faulted on the client and are not sent to the server.</li>
    * <li>last - Making a request causes the client to ignore a result or fault for any current outstanding request. 
    * Only the result or fault for the most recent request will be dispatched on the client. 
    * This may simplify event handling in the client application, but care should be taken to only use 
    * this mode when results or faults for requests may be safely ignored.</li>
    * </ul>
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
    */
    public function get concurrency():String
    {
        return _concurrency;
    }

    /**
     *  @private
     */
    public function set concurrency(c:String):void
    {
        _concurrency = c;
    }

	 //----------------------------------
    //  destination
    //----------------------------------

    [Inspectable(category="General")]

    /**
     * The destination of the service. This value should match a destination
     * entry in the services-config.xml file.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get destination():String
    {
        return "";
    }

    public function set destination(name:String):void
    {
        destination = name;
    }
	
    //----------------------------------
	//  makeObjectsBindable
	//----------------------------------

    [Inspectable(category="General", defaultValue="true")]
    
    /**
     * When this value is true, anonymous objects returned are forced to bindable objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get makeObjectsBindable():Boolean
    {
        return _makeObjectsBindable;
    }

    public function set makeObjectsBindable(b:Boolean):void
    {
        _makeObjectsBindable = b;
    }

	//----------------------------------
	//  showBusyCursor
	//----------------------------------

    [Inspectable(defaultValue="false", category="General")]
    /**
    * If <code>true</code>, a busy cursor is displayed while a service is executing. The default
    * value is <code>false</code>.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
    */
    public function get showBusyCursor():Boolean
    {
        return _showBusyCursor;
    }
	
    public function set showBusyCursor(sbc:Boolean):void
    {
        _showBusyCursor = sbc;
    }
	
	//----------------------------------
    //  channelSet
    //----------------------------------

    /**
     *  Provides access to the ChannelSet used by the service. The
     *  ChannelSet can be manually constructed and assigned, or it will be 
     *  dynamically created to use the configured Channels for the
     *  <code>destination</code> for this service.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get channelSet():Object
    {
        return "";
    }

    /**
     *  @private
     */
    public function set channelSet(value:Object):void
    {
        if (channelSet != value)
        {
            channelSet = value;
        }
    }
	
	//-------------------------------------------------------------------------
    //
    //              Methods
    //
    //-------------------------------------------------------------------------

	private var eventDispatcher:EventDispatcher;
	
	public function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        eventDispatcher.addEventListener(type, listener, useCapture, priority);
    }
}

}
