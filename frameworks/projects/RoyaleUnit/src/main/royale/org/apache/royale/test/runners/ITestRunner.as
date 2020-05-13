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
package org.apache.royale.test.runners
{
	import org.apache.royale.test.runners.notification.IRunNotifier;

	/**
	 * An interface for test runner implementations, such as
	 * <code>MetadataRunner</code> and <code>SuiteRunner</code>.
	 * 
	 * @see org.apache.royale.test.runners.MetadataRunner
	 * @see org.apache.royale.test.runners.SuiteRunner
	 */
	public interface ITestRunner
	{
		/**
		 * A description of this test runner.
		 */
		function get description():String;

		/**
		 * Requests that the runner stops running the tests. Phrased politely
		 * because the test that is currently running may not be interrupted
		 * before completing.
		 */
		function pleaseStop():void;

		/**
		 * Runs the tests.
		 */
		function run(notifier:IRunNotifier):void;
	}
}