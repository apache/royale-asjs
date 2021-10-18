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

[RemoteClass(alias="flex.messaging.messages.ErrorMessage")]

/**
 *  The ErrorMessage class is used to report errors within the messaging system.
 *  An error message only occurs in response to a message sent within the
 *  system.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class ErrorMessage extends AcknowledgeMessage
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------

    /**
     *  If a message may not have been delivered, the <code>faultCode</code> will
     *  contain this constant. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */ 
    public static const MESSAGE_DELIVERY_IN_DOUBT:String = "Client.Error.DeliveryInDoubt";
     
    /**
     *  Header name for the retryable hint header.
     *  This is used to indicate that the operation that generated the error
     *  may be retryable rather than fatal.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const RETRYABLE_HINT_HEADER:String = "DSRetryableErrorHint";

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an ErrorMessage instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function ErrorMessage()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    private var _faultCode:String;
    
    /**
     *  The fault code for the error.
     *  This value typically follows the convention of
     *  "[outer_context].[inner_context].[issue]".
     *  For example: "Channel.Connect.Failed", "Server.Call.Failed", etc.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultCode():String
    {
        return _faultCode;
    }
    public function set faultCode(value:String):void
    {
        _faultCode = value;
    }

    private var _faultString:String;
    
    /**
     *  A simple description of the error.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultString():String
    {
        return _faultString;
    }
    public function set faultString(value:String):void
    {
        _faultString = value;
    }

    private var _faultDetail:String;
    
    /**
     *  Detailed description of what caused the error.
     *  This is typically a stack trace from the remote destination.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultDetail():String
    {
        return _faultDetail;
    }
    public function set faultDetail(value:String):void
    {
        _faultDetail = value;
    }

    private var _rootCause:Object;
    
    /**
     *  Should a root cause exist for the error, this property contains those details.
     *  This may be an ErrorMessage, a NetStatusEvent info Object, or an underlying
     *  Flash error event: ErrorEvent, IOErrorEvent, or SecurityErrorEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get rootCause():Object
    {
        return _rootCause;
    }
    public function set rootCause(value:Object):void
    {
        _rootCause = value;
    }
    
    private var _extendedData:Object;
    
    /**
     * Extended data that the remote destination has chosen to associate
     * with this error to facilitate custom error processing on the client.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get extendedData():Object
    {
        return _extendedData;
    }
    public function set extendedData(value:Object):void
    {
        _extendedData = value;
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
        return null;
    }
}

}