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
package crux.event
{

	import org.apache.royale.events.Event;
	
	/**
	 * @royalesuppresspublicvarwarning
	 */
	public class ServiceEvent extends Event
	{
		public static const RESET_COMMITS : String = "resetCommits";
		public static const REQUEST_REPO_COMMITS : String = "requestRepoCommits";
		public var repo : String;
		
		/**
		 * This is just a normal Royale event which will be dispatched from a view instance.
		 * The only thing to note is that we set 'bubbles' to true, so that the event will bubble
		 * up the 'display' list, allowing Crux to listen for your events.
		 */ 
		public function ServiceEvent( type:String )
		{
			super( type, true );
		}
	}
}
