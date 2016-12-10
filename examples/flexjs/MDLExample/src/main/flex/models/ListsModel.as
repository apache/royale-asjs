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
package models
{
	import org.apache.flex.events.EventDispatcher;
	import vos.*;

	public class ListsModel extends EventDispatcher
	{
		/**
		 * Used in the List example.
		 */
		private var _things:Array = [
			"A", 
			"Simple", 
			"List",
			"Example"
		];
		
		public function get things():Array
		{
			return _things;
		}

		/**
		 * Used in the List example.
		 */
		private var _actors:Array = [
			new ActorVO("Bryan Cranston", "62 Episodes", "Bryan Cranston played the role of Walter in Breaking Bad. He is also known for playing Hal in Malcom in the Middle."),
			new ActorVO("Aaron Paul", "61 Episodes", "Aaron Paul played the role of Jesse in Breaking Bad. He also featured in the 'Need For Speed' Movie."),
			new ActorVO("Bob Odenkirk", "59 Episodes", "Bob Odinkrik played the role of Saul in Breaking Bad. Due to public fondness for the character, Bob stars in his own show now, called 'Better Call Saul'.")
		];
		
		public function get actors():Array
		{
			return _actors;
		}		

	}
}
