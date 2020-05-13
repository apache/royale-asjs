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
// Apache Royale Crux example based on https://github.com/swiz/swiz-examples/tree/master/SwizQuickStartExample-Flex4
package crux.quickstart.controller
{
	import crux.quickstart.model.User;
	import crux.quickstart.service.UserService;
	import org.apache.royale.html.SimpleAlert;
	import mx.rpc.events.ResultEvent;	
	import org.apache.royale.crux.utils.services.ServiceHelper;
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class UserController
	{
		[Inject]
		public var userService : UserService;
		
		[Inject]
		/**
		 * Crux will automatically create any Bean for the built-in helper classes
		 * if one has not been defined.
		 */ 
		public var serviceHelper : ServiceHelper;
		
		[Bindable]
		public var currentUser : User;
		
		
		[PostConstruct]
		/**
		 * [PostConstruct] methods are invoked after all dependencies are injected.
		 * In this example, we set up a default user after the bean is created.
		 */
		public function createDefaultUser() : void
		{
			tracer('[PostConstruct] executing createDefaultUser in UserController');
			currentUser = new User();
		}
		
		
		[EventHandler( event="UserEvent.SAVE_USER_REQUESTED", properties="user" )]
		/**
		 * Perform a server request to save the user
		 */ 
		public function saveUser( user : User ) : void
		{
			tracer('[EventHandler] executing saveUser in UserController via EventHandler processing');
			serviceHelper.executeServiceCall( userService.saveUser( user ), handleSaveUserResult );
		}
		
		/**
		 * Handle the server call result
		 */ 
		private function handleSaveUserResult( event : ResultEvent ) : void
		{
			currentUser = event.result as User;
			tracer('User saved successfully! id:' + currentUser.id, 'Success' );
			COMPILE::JS{
				// Show an Alert just to make it obvious that the save was successful.
				SimpleAlert.show('User saved successfully! id:' + currentUser.id, 'Success' );
			}
		}
		
	}
}


