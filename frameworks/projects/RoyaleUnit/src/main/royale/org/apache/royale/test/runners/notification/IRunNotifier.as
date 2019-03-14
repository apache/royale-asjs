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
package org.apache.royale.test.runners.notification
{
	/**
	 * Listens for notifications from an <code>ITestRunner</code>.
	 */
	public interface IRunNotifier
	{
		/**
		 * Notification when an individual test has started.
		 */
		function fireTestStarted(description:String):void;
		
		/**
		 * Notification when an individual test has finished, regardless of
		 * whether it passed or failed.
		 */
		function fireTestFinished(description:String):void;
		
		/**
		 * Notification when an individual test has failed.
		 */
		function fireTestFailure(failure:Failure):void;

		/**
		 * Notification when an individual test was ignored.
		 */
		function fireTestIgnored(description:String):void;

		/**
		 * Notification when a test run has started.
		 */
		function fireTestRunStarted(description:String):void;

		/**
		 * Notification when a test run has finished.
		 */
		function fireTestRunFinished(result:Result):void;

		/**
		 * Adds a listener.
		 */
		function addListener(listener:IRunListener):void;

		/**
		 * Adds a listener to the beginning of the collection of listeners.
		 */
		function addFirstListener(listener:IRunListener):void;

		/**
		 * Removes a listener.
		 */
		function removeListener(listener:IRunListener):void;

		/**
		 * Removes all listeners.
		 */
		function removeAllListeners():void;
	}
}