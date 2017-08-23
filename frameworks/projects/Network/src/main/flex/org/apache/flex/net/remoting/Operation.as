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
package org.apache.flex.net.remoting
{
    COMPILE::SWF
    {
        import flash.events.AsyncErrorEvent;
        import flash.events.IOErrorEvent;
        import flash.events.NetStatusEvent;
        import flash.events.SecurityErrorEvent;
        import flash.net.Responder;
    }
        
        
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.net.RemoteObject;
    import org.apache.flex.net.remoting.messages.CommandMessage;
    import org.apache.flex.net.remoting.messages.RemotingMessage;
    import org.apache.flex.net.events.FaultEvent;
    import org.apache.flex.net.events.ResultEvent;
    import org.apache.flex.reflection.getClassByAlias;
    import org.apache.flex.reflection.registerClassAlias;
    

	public class Operation extends EventDispatcher
	{
        private var _name:String;
        private var _args:Array;
        private var _ro:RemoteObject;
        
        public function Operation(name:String, remoteObject:RemoteObject, args:Array)
        {
            _name = name;
            _args = args;
            _ro = remoteObject;
        }
		
		public function send():void
		{
            COMPILE::SWF
            {
                _ro.nc.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
                _ro.nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                _ro.nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                _ro.nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                var connectMessage:CommandMessage = new CommandMessage();
                connectMessage.destination = _ro.destination;
                connectMessage.operation = CommandMessage.TRIGGER_CONNECT_OPERATION;
                _ro.nc.call(null, new Responder(destinationResultHandler, destinationFaultHandler), connectMessage);
            }
			COMPILE::JS
			{				
				var amfClient:Object = new ((window as Object).amf).Client(_destination, _endPoint);
				var amfReq:Object = amfClient.invoke(_source, operation, params[0]);
				amfReq.then(resultHandler , faultHandler);
			}
		}
		
        COMPILE::SWF
        private function statusHandler(event:NetStatusEvent):void
        {
            trace("statusHandler", event);
        }
        
        COMPILE::SWF
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            trace("securityErrorHandler", event);
        }
        
        COMPILE::SWF
        private function ioErrorHandler(event:IOErrorEvent):void
        {
            trace("ioErrorHandler", event);
        }
        
        COMPILE::SWF
        private function asyncErrorHandler(event:AsyncErrorEvent):void
        {
            trace("asyncErrorHandler", event);
        }
        
        private function destinationResultHandler(param:Object):void
        {
            var message:RemotingMessage = new RemotingMessage();
            message.operation = _name;
            message.body = _args;
            message.source = _ro.source;
            message.destination = _ro.destination;
            _ro.nc.call(null, new Responder(_ro.resultHandler, _ro.faultHandler), message);

        }
            
        private function destinationFaultHandler(param:Object):void
        {
            trace("destination fault handler", param);            
        }
        
    }
}
