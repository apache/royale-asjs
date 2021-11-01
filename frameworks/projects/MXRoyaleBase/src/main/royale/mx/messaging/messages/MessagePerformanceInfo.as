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
	[RemoteClass(alias="flex.messaging.messages.MessagePerformanceInfo")]
	
	/** 
	 * @private
	 * 
	 * The MessagePerformanceInfo class is used to capture various metrics about
	 * the sizing and timing of a message sent from a client to the server and its 
	 * response message, as well as pushed messages from the server to the client.	
	 * A response message should have two instances of this class among its headers,
	 * headers[MPII] - info for the client to server message,
	 * headers[MPIO] - info for the response message from server to client.
	 * A pushed message will have an extra headers and its headers will represent,
	 * headers[MPII] - info for the client to server message poll message (non RTMP)
	 * headers[MPIO] - info for the pushed message from server to client,
	 * headers[MPIP] - info for the message from the client that caused the push message
	 */
	public class MessagePerformanceInfo
	{
		
    	//--------------------------------------------------------------------------
    	//
    	// Constructor
    	// 
    	//--------------------------------------------------------------------------	
        public function MessagePerformanceInfo()
        {
            super();
        }    		

        //--------------------------------------------------------------------------
    	//
    	// Properties
    	// 
    	//--------------------------------------------------------------------------		
		
        private var _messageSize:int;
        
		/**
	 	 * Size of message in Bytes (message types depends on what header this MPI is in)
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */		
		public function get messageSize():int
        {
            return _messageSize;
        }
        public function set messageSize(value:int):void
        {
            _messageSize = value;
        }
		
        private var _sendTime:Number = 0;
        
		/**
	 	 * Millisecond timestamp of when this message was sent
	 	 * (origin depends on on what header this MPI is in)
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */			
		public function get sendTime():Number
        {
            return _sendTime;
        }
        public function set sendTime(value:Number):void
        {
            _sendTime = value;
        }
		
		/**
	 	 * Millisecond timestamp of when this message was received
	 	 * (destination depends on on what header this MPI is in)
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */			
		private var _receiveTime:Number;
		
        private var _overheadTime:Number;
        
		/**
	 	 * Amount of time in milliseconds that this message was being processed on the server
	 	 * in order to calculate and populate MPI metrics
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */			
		public function get overheadTime():Number
        {
            return _overheadTime;
        }
        public function set overheadTime(value:Number):void
        {
            _overheadTime = value;
        }
		
		/**
	 	 * "OUT" when this message originated on the server
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */			 	 	
		private var _infoType:String;
		
        private var _pushedFlag:Boolean;
        
		/**
	 	 * True if this is info for a message that was pushed from server to client
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */				
		public function get pushedFlag():Boolean
        {
            return _pushedFlag;
        }
        public function set pushedFlag(value:Boolean):void
        {
            _pushedFlag = value;
        }
		
        private var _serverPrePushTime:Number;
        
		/**
	 	 * Millisecond timestamp of when the server became ready to push this message out 
	 	 * to clients
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */			
		public function get serverPrePushTime():Number
        {
            return _serverPrePushTime;
        }
        public function set serverPrePushTime(value:Number):void
        {
            _serverPrePushTime = value;
        }
		
        private var _serverPreAdapterTime:Number;
        
		/**
	 	 * Millisecond timestamp of when the server called into the adapter associated with the
	 	 * destination of this message
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */				
		public function get serverPreAdapterTime():Number
        {
            return _serverPreAdapterTime;
        }
        public function set serverPreAdapterTime(value:Number):void
        {
            _serverPreAdapterTime = value;
        }

        private var _serverPostAdapterTime:Number;	
        
		/**
	 	 * Millisecond timestamp of when server processing returned from the adapater associated 
	 	 * with the destination of this message
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */				
		public function get serverPostAdapterTime():Number
        {
            return _serverPostAdapterTime;
        }
        public function set serverPostAdapterTime(value:Number):void
        {
            _serverPostAdapterTime = value;
        }
		
        private var _serverPreAdapterExternalTime:Number;
        
		/**
	 	 * Millisecond timestamp of when the adapter associated with the destination of this message
	 	 * made a call to an external component (for example a JMS server)
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */		
		public function get serverPreAdapterExternalTime():Number
        {
            return _serverPreAdapterExternalTime;
        }
		public function set serverPreAdapterExternalTime(value:Number):void
        {
            _serverPreAdapterExternalTime = value;
        }
        
        private var _serverPostAdapterExternalTime:Number;
        
		/**
	 	 * Millisecond timestamp of when processing came back to the adapter associated with the destination 
	 	 * of this message from a call to an external component (for example a JMS server)
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion BlazeDS 4
	 	 *  @productversion LCDS 3 
	 	 */				
		public function get serverPostAdapterExternalTime():Number
        {
            return _serverPostAdapterExternalTime;
        }
        public function set serverPostAdapterExternalTime(value:Number):void
        {
            _serverPostAdapterExternalTime = value;
        }
		
        private var _recordMessageTimes:Boolean;
        
		/**
	 	 * Flag is true when record-message-times is enabled for the communication channel
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
        public function set recordMessageTimes(value:Boolean):void
        {
            _recordMessageTimes = value;
        }
        
        private var _recordMessageSizes:Boolean;		
        
		/**
	 	 * Flag is true when record-message-sizes is enabled for the communication channel
	 	 *  
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
        public function set recordMessageSizes(value:Boolean):void
        {
            _recordMessageSizes = value;
        }
		
    	//--------------------------------------------------------------------------
    	//
    	// Public Methods
    	// 
    	//--------------------------------------------------------------------------
		
	  /**
	   *  Sets the info type of this message (IN or OUT).  Used to mark the MPI with the 
	   *  client receive time when this MPI is of type OUT (IN, OUT are from the perspective of the
	   *  server)
	   * 
	   * @param type - "IN" or "OUT" info type
	   *  
	   *  @langversion 3.0
	   *  @playerversion Flash 9
	   *  @playerversion AIR 1.1
	   *  @productversion BlazeDS 4
	   *  @productversion LCDS 3 
	   */		
		public function set infoType(type:String):void
		{
			_infoType = type;
			if (_infoType=="OUT")
			{			
				var curDate:Date = new Date();
				this._receiveTime = curDate.getTime();
			}
		}
		
	  /**
	   *  Get the info type of this message (IN or OUT).
	   * 
	   * @return "IN" or "OUT" (from the perspective of the server)
	   *  
	   *  @langversion 3.0
	   *  @playerversion Flash 9
	   *  @playerversion AIR 1.1
	   *  @productversion BlazeDS 4
	   *  @productversion LCDS 3 
	   */			
		public function get infoType():String
		{
			return this._infoType;
		}
        
        /**
         *  Sets reveive time of this message.  
         *  When the infoType is "OUT", we should skip override the receive time
         *  See the set infoType for details
         * 
         * @param time - the receive time to set
         */		
        public function set receiveTime(time:Number):void
        {
            // Check whether infoType is out and receiveTime would already set
            // If it is the case, we should skip the reset the receive time of the message
            if (_infoType == null || _infoType != "OUT")
            {			
                //var curDate:Date = new Date();
                this._receiveTime = time;
            }
        }
        
        /**
         *  Get the receive time of this message (IN or OUT).
         * 
         * @return Number the receive time that the client receives the message
         */			
        public function get receiveTime():Number
        {
            return this._receiveTime;
        }
      
    } 
}