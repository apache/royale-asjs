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
package crux.quickstart.model
{
	
	[Bindable]
	public class User
	{
		public var id : int;
		public var firstName : String;
		public var lastName : String;
		public var email : String;
		
		
		public function clone():User{
			var usr:User = new User();
			usr.id = id;
			usr.firstName = firstName;
			usr.lastName = lastName;
			usr.email = email;
			return usr;
		}
		
	}
}
