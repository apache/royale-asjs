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
package org.apache.royale.test.events
{
	public class TestEvent
	{
		public static const TEST_RUN_START:String = "testRunStart";
		public static const TEST_RUN_COMPLETE:String = "testRunComplete";
		public static const TEST_RUN_FAIL:String = "testRunFail";
		public static const TEST_START:String = "testStart";
		public static const TEST_COMPLETE:String = "testComplete";
		public static const TEST_FAIL:String = "testFail";

		public function TestEvent(type:String, testName:String = null, error:Error = null)
		{
			this._type = type;
			this._testName = testName;
			this._error = error;
		}

		private var _type:String;

		public function get type():String
		{
			return this._type;
		}

		private var _testName:String;

		public function get testName():String
		{
			return this._testName;
		}

		private var _error:Error;

		public function get error():Error
		{
			return this._error;
		}
	}
}