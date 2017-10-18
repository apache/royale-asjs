/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package vo
{
	[Bindable]
	public class UserVO
	{
	    public var username:String;
	    public var firstName:String;
	    public var lastName:String;
		public var email:String;
		
		public function UserVO(username:String = null, 
							   firstName:String = null,
							   lastName:String = null,
							   email:String = null)
		{
			this.username = username;
			this.firstName = firstName;
			this.lastName = lastName;
			this.email = email;	
		}
	}
}
