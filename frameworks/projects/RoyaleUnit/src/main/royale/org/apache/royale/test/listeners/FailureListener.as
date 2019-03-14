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
package org.apache.royale.test.listeners
{
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.runners.notification.Result;

	/**
	 * Determine if a test run fails or not.
	 */
	public class FailureListener implements IRunListener
	{
		public function FailureListener()
		{
		}

		/**
		 * @private
		 */
		protected var _failed:Boolean = false;

		/**
		 * Indicates of the test runner failed.
		 */
		public function get failed():Boolean
		{
			return _failed;
		}
	
		/**
		 * @private
		 */
		public function testStarted(description:String):void
		{
		}
	
		/**
		 * @private
		 */
		public function testFinished(description:String):void
		{
		}
	
		/**
		 * @private
		 */
		public function testFailure(failure:Failure):void
		{
			_failed = true;
		}
	
		/**
		 * @private
		 */
		public function testIgnored(description:String):void
		{
		}
	
		/**
		 * @private
		 */
		public function testRunStarted(description:String):void
		{
			_failed = false;
		}
	
		/**
		 * @private
		 */
		public function testRunFinished(result:Result):void
		{
			_failed = _failed || !result.successful;
		}
	}
}