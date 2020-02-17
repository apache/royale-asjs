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
package crux.quickstart.service
{
	import crux.quickstart.model.User;

	import mx.rpc.AsyncToken;

	import org.apache.royale.crux.utils.services.MockDelegateHelper;
	import org.apache.royale.events.IEventDispatcher;

	public class UserService
	{
		[Dispatcher]
		/**
		 * The [Dispatcher] metadata tag instructs Crux to inject an event dispatcher.
		 * Event's dispatched via this dispatcher can trigger event mediators.
		 */ 
		public var dispatcher : IEventDispatcher;
		
		/**
		 * To avoid a live server dependency, we use a Crux
		 * helper class to let us create fake AsyncTokens
		 */ 
		private var mockHelper : MockDelegateHelper;
		
		public function UserService()
		{
			mockHelper = new MockDelegateHelper();
		}
		
		/**
		 * In a real app, we'd invoke a RemoteObject, HTTPService, etc.
		 * For this simple example, we'll set a random ID on the returned User
		 * to simulate the process of saving a User.
		 */ 
		public function saveUser( user : User ) : AsyncToken
		{
			user = user.clone();//clone it to simulate a different object being returned from the server
			user.id = Math.round( Math.random() * 100 );
			return mockHelper.createMockResult( user );
		}
	}
}
