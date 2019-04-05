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
	 * Responds to events that occur during a test run.
	 */
	public interface IRunListener
	{
		/**
		 * Called when an individual test has started.
		 */
		function testStarted(description:String):void;
		
		/**
		 * Called when an individual test has finished, regardless of whether it
		 * has passed or failed.
		 */
		function testFinished(description:String):void;
		
		/**
		 * Called when an individual test has failed.
		 */
		function testFailure(failure:Failure):void;
		
		/**
		 * Called when an individual test was ignored.
		 */
		function testIgnored(description:String):void;
		
		/**
		 * Called when a test run has started.
		 */
		function testRunStarted(description:String):void;
		
		/**
		 * Called when a test run has finished.
		 */
		function testRunFinished(result:Result):void;
	}
}