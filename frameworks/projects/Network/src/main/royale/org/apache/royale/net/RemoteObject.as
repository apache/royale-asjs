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
    import org.apache.royale.net.remoting.Operation;
    import org.apache.royale.net.remoting.amf.AMFNetConnection;

	[Event(name="result", type="org.apache.royale.net.events.ResultEvent")]
	[Event(name="fault", type="org.apache.royale.net.events.FaultEvent")]
	/**
	 * This is the RemoteObject that has a similar behaviour that Flex RemoteObject
	 * and can be use with BlazeDS, LCDS or CF backends
	 */
	public class RemoteObject extends EventDispatcher implements IBead
	{
		private var _endPoint:String;
		private var _destination:String;
        
        /**
         *  @private
         *  The connection to the server 
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var nc:AMFNetConnection = new AMFNetConnection();
		
		/**
		 * @private
		 * A channel specific override to determine whether small messages should
		 * be used. If set to false, small messages will not be used even if they
		 * are supported by an endpoint.
		 * 
		 * @royalesuppresspublicvarwarning
		 */
		public var enableSmallMessages:Boolean = true;

		/** 
		 * constructor
		 */ 
		public function RemoteObject()
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
		
		public function send(operation:String, params:Array):void
		{
            nc.connect(endPoint);
            
            var op:Operation = new Operation(operation, this, params);
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
