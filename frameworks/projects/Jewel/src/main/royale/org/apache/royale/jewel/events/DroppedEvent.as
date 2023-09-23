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
package org.apache.royale.jewel.events
{
	import org.apache.royale.events.Event;

	/**
	 * Programmatic (not user/UI) based wizard navigation events.
	 */
	public class DroppedEvent extends Event
	{
		public static const DROPPED:String = "dropped";

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var data:Array;

		public function DroppedEvent(type:String, data:Array = null)
        {
			super(type);
			this.data = data;
		}
	}
}