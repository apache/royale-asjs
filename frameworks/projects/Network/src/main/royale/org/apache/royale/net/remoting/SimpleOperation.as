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
package org.apache.royale.net.remoting
{
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.net.SimpleRemoteObject;
    import org.apache.royale.net.Responder;
    import org.apache.royale.net.remoting.messages.AcknowledgeMessage;
    import org.apache.royale.net.remoting.messages.CommandMessage;
    import org.apache.royale.net.remoting.messages.RemotingMessage;
    import org.apache.royale.net.events.FaultEvent;
    import org.apache.royale.net.events.ResultEvent;

    /**
     * used by SimpleRemoteObject implementation
     */
	public class SimpleOperation extends EventDispatcher
	{
        private var _name:String;
        private var _args:Array;
        private var _ro:SimpleRemoteObject;
        
        public function SimpleOperation(name:String, remoteObject:SimpleRemoteObject, args:Array)
        {
            _name = name;
            _args = args;
            _ro = remoteObject;
        }
		
		public function send():void
		{
            var connectMessage:CommandMessage = new CommandMessage();
            connectMessage.operation = CommandMessage.TRIGGER_CONNECT_OPERATION;
            connectMessage.destination = _ro.destination;
             _ro.nc.call(null, new Responder(destinationResultHandler, destinationFaultHandler), connectMessage);
		}
		
        private function destinationResultHandler(param:Object):void
        {
            COMPILE::SWF
            {
                var message:RemotingMessage = new RemotingMessage();
                message.operation = _name;
                message.body = _args;
                message.source = _ro.source;
                message.destination = _ro.destination;
                _ro.nc.call(null, new Responder(_ro.resultHandler, _ro.faultHandler), message);
            }
            COMPILE::JS
            {
                if (param is AcknowledgeMessage)
                {
                    var message:RemotingMessage = new RemotingMessage();
                    message.operation = _name;
                    message.body = _args;
                    message.source = _ro.source;
                    message.destination = _ro.destination;
                    _ro.nc.call(null, new Responder(_ro.resultHandler, _ro.faultHandler), message);
                }
                else
                    trace("destination result handler", param);
            }
        }
            
        private function destinationFaultHandler(param:Object):void
        {
            trace("destination fault handler", param);
            _ro.faultHandler(param);
        }
    }
}
