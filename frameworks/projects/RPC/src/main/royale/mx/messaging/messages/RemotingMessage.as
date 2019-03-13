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

[RemoteClass(alias="flex.messaging.messages.RemotingMessage")]

/**
 *  RemotingMessages are used to send RPC requests to a remote endpoint.
 *  These messages use the <code>operation</code> property to specify which
 *  method to call on the remote object.
 *  The <code>destination</code> property indicates what object/service should be
 *  used.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class RemotingMessage extends AbstractMessage
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Constructs an uninitialized RemotingMessage.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function RemotingMessage()
    {
        super();
        operation = "";
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------    

    private var _operation:String;
    
    /**
     *  Provides access to the name of the remote method/operation that
     *  should be called.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get operation():String
    {
        return _operation;
    }
    public function set operation(value:String):void
    {
        _operation = value;
    }

    private var _source:String;
    
    /**
     *  This property is provided for backwards compatibility. The best
     *  practice, however, is to not expose the underlying source of a
     *  RemoteObject destination on the client and only one source to
     *  a destination. Some types of Remoting Services may even ignore
     *  this property for security reasons.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get source():String
    {
        return _source;
    }
    public function set source(value:String):void
    {
        _source = value;
    }
}

}
