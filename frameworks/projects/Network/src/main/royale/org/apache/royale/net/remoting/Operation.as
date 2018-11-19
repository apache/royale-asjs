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
    import org.apache.royale.net.RemoteObject;
    import org.apache.royale.net.Responder;
    import org.apache.royale.net.remoting.messages.AcknowledgeMessage;
    import org.apache.royale.net.remoting.messages.AcknowledgeMessageExt;
    import org.apache.royale.net.remoting.messages.CommandMessage;
    import org.apache.royale.net.remoting.messages.RemotingMessage;
    import org.apache.royale.net.remoting.messages.ISmallMessage;
    
    import org.apache.royale.net.remoting.messages.AbstractMessage;
    import org.apache.royale.net.remoting.messages.IMessage;
    import org.apache.royale.net.remoting.messages.RoyaleClient;

    /**
     * used by RemoteObject implementation
     */
	public class Operation extends EventDispatcher
	{
        private var _name:String;
        private var _args:Array;
        private var _ro:RemoteObject;
        
        /**
         * This Operation is used by RemoteObject to deal with a BlazeDS, LCDS or CF AMF server
         */
        public function Operation(name:String, remoteObject:RemoteObject, args:Array)
        {
            _name = name;
            _args = args;
            _ro = remoteObject;
        }
		
        /**
         * performs the sendind. If we have a clientId, we send the message, if not we make a ping operation command
         * to make the server generate an UUID for us and use it in the rest of communications so the server knows who we are.
         */
		public function send():void
		{
            var id:String = RoyaleClient.getInstance().id;
            
            // check if we already get the DSId
            if(id != null)
            {
                destinationResultHandler(null);
            } else
            {
                var message:IMessage = new CommandMessage();

                (message as CommandMessage).operation = (id != null) ? CommandMessage.TRIGGER_CONNECT_OPERATION : CommandMessage.CLIENT_PING_OPERATION;
                setRoyaleClientIdOnMessage(message);
                message.headers[CommandMessage.MESSAGING_VERSION] = messagingVersion;

                //if "Small Messages" are enabled, send this form instead the normal message.
                if (_ro.enableSmallMessages && message is ISmallMessage)
                {
                    var smallMessage:IMessage = ISmallMessage(message).getSmallMessage();
                    if (smallMessage != null)
                    {
                        message = smallMessage;
                    }
                }
                _ro.nc.call(null, new Responder(destinationResultHandler, destinationFaultHandler), message);
            }
		}
		
        private function destinationResultHandler(param:Object):void
        {
            COMPILE::SWF
            {
                var message:RemotingMessage = new RemotingMessage();
                message.operation = _name;
                message.body = _args;
                message.destination = _ro.destination;
                setRoyaleClientIdOnMessage(message);
                _ro.nc.call(null, new Responder(_ro.resultHandler, _ro.faultHandler), message);
            }
            COMPILE::JS
            {
                //if we receive this kind of message it was from a PING operation and then we must retrieve the clientId for later use in all further communications
                if (param is AcknowledgeMessage || param is AcknowledgeMessageExt)
                {


                    // Set the server assigned RoyaleClient Id.
                    if (RoyaleClient.getInstance().id == null && param.headers[AbstractMessage.ROYALE_CLIENT_ID_HEADER] != null)
                    {
                        RoyaleClient.getInstance().id = param.headers[AbstractMessage.ROYALE_CLIENT_ID_HEADER];
                    }
                }

                var message:RemotingMessage = new RemotingMessage();
                message.operation = _name;
                message.body = _args;
                message.destination = _ro.destination;
                setRoyaleClientIdOnMessage(message);
                _ro.nc.call(null, new Responder(_ro.resultHandler, _ro.faultHandler), message);
            }
        }
            
        private function destinationFaultHandler(param:Object):void
        {
            trace("destination fault handler", param);            
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
            //trace("[*setRoyaleClientIdOnMessage] RoyaleClient.getInstance().id: " + RoyaleClient.getInstance().id);
            message.headers[AbstractMessage.ROYALE_CLIENT_ID_HEADER] = (id != null) ? id : RoyaleClient.NULL_ROYALECLIENT_ID;
        }

        /**
         * @private
         * The messaging version implies which features are enabled on this client
         * channel. Channel endpoints exchange this information through headers on
         * the ping CommandMessage exchanged during the connection handshake.
         */
        protected var messagingVersion:Number = 1.0;
    }
}
