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
package crux.quickstart.event
{
	import crux.quickstart.model.User;
	import org.apache.royale.events.Event;
	
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class UserEvent extends Event
	{
		public static const SAVE_USER_REQUESTED : String = "saveUser";
		
		public var user : User;
		
		/**
		 * This is just a normal Royale event which will be dispatched from a view instance.
		 * The only thing to note is that we set 'bubbles' to true, so that the event will bubble
		 * up the 'display' list, allowing Crux to listen for your events.
		 */ 
		public function UserEvent( type:String )
		{
			super( type, true );
		}
	}
}
