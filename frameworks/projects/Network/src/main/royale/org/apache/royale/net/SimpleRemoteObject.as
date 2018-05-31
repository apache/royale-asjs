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
package org.apache.royale.net
{
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.net.events.FaultEvent;
    import org.apache.royale.net.events.ResultEvent;
    import org.apache.royale.net.remoting.SimpleOperation;
    import org.apache.royale.net.remoting.amf.AMFNetConnection;

	[Event(name="result", type="org.apache.royale.net.events.ResultEvent")]
	[Event(name="fault", type="org.apache.royale.net.events.FaultEvent")]
	/**
	 * This is the most simple implementation os a RemoteObject it can be use with
	 * simple backends like AMFPHP. To use with BlazeDS better us RemoteObject since
	 * it manages clientId and small messages
	 */
	public class SimpleRemoteObject extends EventDispatcher implements IBead
	{
		private var _endPoint:String;
		private var _destination:String;
		private var _source:String;
        
        /**
         *  @private
         *  The connection to the server 
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var nc:AMFNetConnection = new AMFNetConnection();
		
		/** 
		 * 
		 */ 
		public function SimpleRemoteObject()
		{
		}
		
        private var _strand:IStrand;
        
        public function set strand(value:IStrand):void
        {
            _strand = value;	
        }
        
		public function set endPoint(value:String):void
		{
			_endPoint = value;	
		}
		public function get endPoint():String
		{
			return _endPoint;	
		}
		
		public function set destination(value:String):void
		{
			_destination = value;	
		}
		public function get destination():String
		{
			return _destination;	
		}
		
		/**
		 * source is a deprecated property. It exposes
		 * backend resources and it used by old AMF backend implementations.
		 * You should use "destination" property instead. This property is for 
		 * backward compatibility with old implementations.
		 * Use at your own risk.
		 */
		public function set source(value:String):void
		{
			_source = value;	
		}
		public function get source():String
		{
			return _source;	
		}
		
		public function send(operation:String, params:Array):void
		{
            nc.connect(endPoint);
            
            var op:SimpleOperation = new SimpleOperation(operation, this, params);
            op.send();
		}
		
		public function resultHandler(param:Object):void
		{			
    		dispatchEvent(new ResultEvent(ResultEvent.RESULT, param.body));
		}
		
		public function faultHandler(param:Object):void
		{
			dispatchEvent(new FaultEvent(FaultEvent.FAULT, param));
		}		
	}
}
