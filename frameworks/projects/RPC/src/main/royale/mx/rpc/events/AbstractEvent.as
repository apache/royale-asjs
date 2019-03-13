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

import mx.core.mx_internal;
import mx.messaging.events.MessageEvent;
import mx.messaging.messages.IMessage;
import mx.rpc.AsyncToken;

use namespace mx_internal;

/**
 * The base class for events that RPC services dispatch.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AbstractEvent extends MessageEvent
{
    private var _token:AsyncToken;

    /**
     * @private
     */
    public function AbstractEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, 
        token:AsyncToken = null, message:IMessage = null)
    {
        super(type, bubbles, cancelable, message);

        _token = token;
    }

    /**
     * The token that represents the call to the method. Used in the asynchronous completion token pattern.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get token():AsyncToken
    {
        return _token;
    }

    mx_internal function setToken(t:AsyncToken):void
    {
        _token = t;
    }
    
    /**
     * Does nothing by default.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function callTokenResponders():void
    {
    }
}

}
