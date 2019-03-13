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

package mx.rpc
{

import mx.core.mx_internal;
import mx.messaging.Producer;
import mx.messaging.messages.AcknowledgeMessage;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.ErrorMessage;
import mx.messaging.messages.IMessage;
import mx.messaging.events.MessageEvent;
import mx.messaging.events.MessageFaultEvent;

use namespace mx_internal;

/**
 *  The AsyncRequest class provides an abstraction of messaging for RPC call invocation.
 *  An AsyncRequest allows multiple requests to be made on a remote destination
 *  and will call back to the responder specified within the request when
 *  the remote request is completed.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AsyncRequest extends mx.messaging.Producer
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

	/**
	 *  Constructs a new asynchronous request.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function AsyncRequest()
	{
		super();
	}
	
    //--------------------------------------------------------------------------
    //
    // Public Methods
    // 
    //--------------------------------------------------------------------------

	/**
	 *  Delegates to the results to responder
	 *  @param    ack Message acknowlegdement of message previously sent
	 *  @param    msg Message that was recieved the acknowledgement
	 *  @private
	 */
	override public function acknowledge(ack:AcknowledgeMessage, msg:IMessage):void
	{
        var error:Boolean = ack.headers[AcknowledgeMessage.ERROR_HINT_HEADER];
        // super will clean the error hint from the message
        super.acknowledge(ack, msg);
        // if acknowledge is *not* for a message that caused an error
        // dispatch a result event
        if (!error)
        {
			var act:String = ack.correlationId;
			var resp:IResponder = IResponder(_pendingRequests[act]);
			if (resp)
			{
				delete _pendingRequests[act];
				resp.result(MessageEvent.createEvent(MessageEvent.RESULT, ack));
			}
		}
	}
	
	/**
	 *  Delegates to the fault to responder
	 *  @param    error message.
	 *            The error codes and information are contained in the
	 *            <code>headers</code> property
	 *  @param    msg Message original message that caused the fault.
	 *  @private
	 */
	override public function fault(errMsg:ErrorMessage, msg:IMessage):void
	{
	    super.fault(errMsg, msg);		
	    
	    if (_ignoreFault)
	    	return;     	       	    	       
	    
        // This used to use the errMsg.correlationId here but
        // if the server fails to deserialize the message (like if
        // the body references a non-existent server class)
        // it cannot supply a correlationId to the error message.  
        var act:String = msg.messageId;
		var resp:IResponder = IResponder(_pendingRequests[act]); 
		if (resp)
		{
			delete _pendingRequests[act];
			resp.fault(MessageFaultEvent.createEvent(errMsg));
		}
	}		
	
   /**
    * Returns <code>true</code> if there are any pending requests for the passed in message.
    * 
    * @param msg The message for which the existence of pending requests is checked.
    *
    * @return Returns <code>true</code> if there are any pending requests for the 
    * passed in message; otherwise, returns <code>false</code>.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
	override public function hasPendingRequestForMessage(msg:IMessage):Boolean
	{
		var act:String = msg.messageId;
		return _pendingRequests[act];
	}
	

	/**
	 *  Dispatches the asynchronous request and stores the responder to call
	 *  later.
         *
         * @param msg The message to be sent asynchronously.
         *
         * @param responder The responder to be called later.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function invoke(msg:IMessage, responder:IResponder):void
	{
		_pendingRequests[msg.messageId] = responder;
		send(msg);
	}
	
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

	/**
	 *  manages a list of all pending requests.  each request must implement
	 *  IResponder
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	private var _pendingRequests:Object = {};
}
}
