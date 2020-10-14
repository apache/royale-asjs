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
package org.apache.royale.html.test.models
{
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	[ExcludeClass]
	[Bindable]
	[Event(name='ready')]
	/**
	 * @private
	 */
	public class UITestVO extends EventDispatcher
	{
		public function UITestVO(description:String)
		{
			this.description = description;

			var index:int = description.lastIndexOf(".");
			testCaseName = description.substr(0, index);
			functionName = description.substr(index + 1);
		}

		public var description:String;

		public var functionName:String;
		public var testCaseName:String;

		public var ignored:Boolean = false;
		public var failure:Failure;


		private var _active:Boolean = false;
		public function get active():Boolean {
			return _active;
		}

		public function set active(value:Boolean):void {
			var finalized:Boolean = _active && !value;
			_active = value;
			if (finalized) {
				this.dispatchEvent(new Event('ready'));
			}
		}
	}
}