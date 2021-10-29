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
	COMPILE::SWF {
		import flash.events.EventDispatcher;
	}
		
	COMPILE::JS {
		import org.apache.royale.events.EventDispatcher;
	}
		
	import mx.rpc.IResponder;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	
	import mx.utils.ArrayUtil;
	
	/**
	 * Dispatched when an Operation invocation successfully returns.
	 * @eventType mx.rpc.events.ResultEvent.RESULT 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="result", type="mx.rpc.events.ResultEvent")]
	
	/**
	 * Dispatched when an Operation call fails.
	 * @eventType mx.rpc.events.FaultEvent.FAULT 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="fault", type="mx.rpc.events.FaultEvent")]
	
	/**
	 *  This component helps you manage the results for asynchronous calls made from
	 *  RPC based services, typically from MXML components.  While each individual service
	 *  and operation dispatches result and fault events, it is common to need to use the
	 *  same operation in different parts of your application.  Using one event listener
	 *  or lastResult value across the entire application can be awkward.  Rather than creating
	 *  two service components which refer to the same service, you can use a simple lightweight
	 *  CallResponder to manage the event listeners and lastResult value for a specific invocation
	 *  of a service.
	 *  <p>
	 *  You set the token property of this component to the AsyncToken returned by the 
	 *  service.  You can then add event listeners on this component instead of having to
	 *  add them to each AsyncToken returned.   This component also maintains the
	 *  lastResult property which is a copy of the value returned by the last successful
	 *  result event dispatched by a token monitored by this service.  Though you can
	 *  bind to either the <code>callResponder.token.result</code> or 
	 *  <code>callResponder.lastResult</code>, the latter will be preserved while a second
	 *  call to the same service is in progress while the former will be reset as soon
	 *  as a new service invocation is started.
	 *  </p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class CallResponder extends EventDispatcher implements IResponder 
	{
		private var _token:AsyncToken;
		
		[Bindable]
		/**
		 *  Each CallResponder dispatches result and fault events received
		 *  from a single token.  This property value specifies that token.  You typically
		 *  set this property to the AsyncToken object returned by the service.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function set token(t:AsyncToken):void
		{
			if (_token != null)
			{
				var resps:Array = _token.responders;
				var ix:int = ArrayUtil.getItemIndex(this, resps);
				if (ix != -1)
					resps.splice(ix, 1);
			}
			if (t != null)
				t.addResponder(this);
			_token = t;
		}
		
		public function get token():AsyncToken
		{
			return _token;
		}
		
		/**
		 *  This method is called by the AsyncToken when it wants to deliver a 
		 *  <code>ResultEvent</code> to the CallResponder.  You do not call
		 *  this method directly.
		 *
		 *  @param data The ResultEvent delivered by the AsyncToken
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function result(data:Object):void
		{
			var resultEvent:ResultEvent = ResultEvent(data);
			lastResult = resultEvent.result;
			
			dispatchEvent(resultEvent);
		}
		
		/**
		 *  This method is called by the AsyncToken when it wants to deliver a 
		 *  <code>FaultEvent</code> to the CallResponder.  You do not call
		 *  this method directly.
		 *
		 *  @param data The FaultEvent delivered by the AsyncToken
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function fault(data:Object):void
		{
			var faultEvent:FaultEvent = FaultEvent(data);
			
			// Not clearing lastResult here... this will allow developers to keep using
			// lastResult even in the event of a fault.
			dispatchEvent(faultEvent);
		}
		
		[Bindable]
		/**
		 *  This property stores the result property of the token each time it
		 *  delivers a successful result.  You can bind to or access this property 
		 *  instead of the token.result property to keep your code from seeing that
		 *  value cleared out on the second and subsequent call to a particular service
		 *  method.  Additionally, if a fault occurs this value will still be set to
		 *  the last successful result returned by a token monitored by this CallResponder.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var lastResult:*;
		
	}
	
}
