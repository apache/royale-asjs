/*
 * Copyright 2010 Swiz Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.apache.royale.crux.utils.services
{
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.channels.SecureAMFChannel;

	import org.apache.royale.crux.IInitializing;
	
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class ChannelSetHelper extends ChannelSet implements IInitializing
	{
		// Flash remoting config issues       
		private static const DEFAULT_CHANNEL_ID : String = "orca-amf";  
		private static const DEFAULT_PROTOCOL : String = "http";  
		private static const DEFAULT_SERVER_NAME : String = "localhost";    
		private static const DEFAULT_SERVER_PORT : int = 8080;    
		private static const DEFAULT_CONTEXT_ROOT : String = "/";   
		private static const DEFAULT_ENDPOINT_NAME : String = "messagebroker/amf";   
		
		public var channelId:String;
		public var protocol:String;
		public var serverName:String;
		public var serverPort:int;
		public var contextRoot:String;
		public var endPointName:String;
	
		public var parameterSource:Object;
		public var parameterName:String;
		
		private var url:String;
		private var channelCreated : Boolean = false;
		
		public function ChannelSetHelper(channelIds:Array=null, clusteredWithURLLoadBalancing:Boolean=false)
		{
			super(channelIds, clusteredWithURLLoadBalancing);
		}
		
		public function afterPropertiesSet() : void {
			if (!channelCreated) {
				checkParameters();
				createChannel();
			}
		}
		
		private function checkParameters():void
		{
			if( parameterSource != null && parameterName != null )
				url = parameterSource.parameters[ parameterName ];
		}
		
		/**
		 * Constructs the AMF Channel and adds to the channel set
		 */
		private function createChannel():void
		{
			if (!channelCreated) {
				
				var amfChannel:Channel;
				// create a new AMF Channel with our configuration
				if( PROTOCOL == "https" || AMF_ENDPOINT.indexOf("https") > -1 )
					amfChannel = new SecureAMFChannel(CHANNEL_ID, AMF_ENDPOINT);
				else
					amfChannel = new AMFChannel(CHANNEL_ID, AMF_ENDPOINT);
				addChannel(amfChannel);
				channelCreated = true;
			}
		}
		
		/**
		 * Creates a proper AMF Endpoint with configured parameters. Location depends on how 
		 * the application is accessed (http:// or file://)
		 **/
		private function get AMF_ENDPOINT() : String
		{
			if( url != null && url.length)
				return url;
			else
				return PROTOCOL+"://" + SERVER_NAME + ":" + SERVER_PORT + CONTEXT_ROOT +"/" + ENDPOINT_NAME;
		}
		
		/**
		 * returns either default or configured channel id
		 **/      
		private function get CHANNEL_ID() : String {
			return channelId != null ? channelId : DEFAULT_CHANNEL_ID;
		}
		
		/**
		 * returns either default or configured server name
		 **/      
		private function get PROTOCOL() : String {
			return protocol != null ? protocol : DEFAULT_PROTOCOL;
		}
		
		/**
		 * returns either default or configured server name
		 **/      
		private function get SERVER_NAME() : String {
			return serverName != null ? serverName : DEFAULT_SERVER_NAME;
		}
		
		/**
		 * returns either default or configured server port
		 **/      
		private function get SERVER_PORT() : int {
			return serverPort != 0 ? serverPort : DEFAULT_SERVER_PORT;
		}
		
		/**
		 * returns either default or configured context root
		 **/      
		private function get CONTEXT_ROOT() : String {
			return contextRoot != null ? contextRoot : DEFAULT_CONTEXT_ROOT;
		}
		
		private function get ENDPOINT_NAME() : String {
			return endPointName != null ? endPointName : DEFAULT_ENDPOINT_NAME;
		}
		
	}
}
