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
	COMPILE::SWF {
		import flash.utils.Dictionary;
	}
	
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.Timer;
	
	import mx.core.mx_internal;
	//import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	/**
	 *
	 *   @royalesuppresspublicvarwarning
	 */
	public class MockDelegateHelper
	{

		COMPILE::SWF
		public var calls:Dictionary = new Dictionary();
		
		COMPILE::JS
		public var calls:Map = new Map();
		

		public var fault:Fault;
		
		/**
		 * If <code>true</code>, a busy cursor is displayed while the mock service is
		 * executing. The default value is <code>false</code>.
		 */
		public var showBusyCursor:Boolean;
		
		public function MockDelegateHelper(showBusyCursor:Boolean = false )
		{
			this.showBusyCursor = showBusyCursor;
		}
		
		public function createMockResult( mockData:Object, delay:int = 10 ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			token.data = mockData;
			
			var timer:Timer = new Timer( delay, 1 );
			timer.addEventListener( Timer.TIMER, sendMockResult );
			timer.start();
			COMPILE::SWF{
				calls[ timer ] = token;
			}
			COMPILE::JS{
				calls.set( timer, token);
			}
			
			/*if( showBusyCursor )
			{
				CursorManager.setBusyCursor();
			}*/
			
			return token;
		}
		
		protected function sendMockResult( event:Event ):void
		{
			/*if( showBusyCursor )
			{
				CursorManager.removeBusyCursor();
			}*/
			
			var timer:Timer = Timer( event.target );
			timer.removeEventListener( Timer.TIMER, sendMockResult );
			COMPILE::SWF{
				const check:* = calls[ timer ];
			}
			COMPILE::JS{
				const check:* = calls.get(timer);
			}

			if( check is AsyncToken )
			{
				var token:AsyncToken = AsyncToken(check);
				COMPILE::SWF{
					delete calls[ timer ];
				}
				COMPILE::JS{
					calls.delete(timer);
				}
				var mockData:Object = ( token.data ) ? token.data : {};
				token.mx_internal::applyResult(ResultEvent.createEvent(mockData, token));
			}
			
			timer = null;
		}
		
		public function createMockFault( fault:Fault = null, delay:int = 10 ):AsyncToken
		{
			var token:AsyncToken = new AsyncToken();
			token.data = fault;
			
			var timer:Timer = new Timer( delay, 1 );
			timer.addEventListener( Timer.TIMER, sendMockFault );
			timer.start();
			COMPILE::SWF{
				calls[ timer ] = token;
			}
			COMPILE::JS{
				calls.set(timer, token);
			}
			
			/*if( showBusyCursor )
			{
				CursorManager.setBusyCursor();
			}*/
			
			return token;
		}
		
		protected function sendMockFault( event:Event ):void
		{
			/*if( showBusyCursor )
			{
				CursorManager.removeBusyCursor();
			}*/
			
			var timer:Timer = Timer( event.target );
			timer.removeEventListener( Timer.TIMER, sendMockFault );
			COMPILE::SWF{
				const check:* = calls[ timer ];
			}
			COMPILE::JS{
				const check:* = calls.get(timer);
			}
			if( check is AsyncToken )
			{
				var token:AsyncToken = AsyncToken(check);
				COMPILE::SWF{
					delete calls[ timer ];
				}
				COMPILE::JS{
					calls.delete(timer);
				}
				
				var fault:Fault = ( token.data ) ? token.data : null;
				token.mx_internal::applyFault( FaultEvent.createEvent( fault, token ) );
			}
			
			timer = null;
		}
	}
}
