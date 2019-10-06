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
	import org.apache.royale.test.runners.notification.IRunListener;

	/**
	 * The result of a test run.
	 */
	public class Result
	{
		/**
		 * Constructor.
		 */
		public function Result()
		{
			
		}

		/**
		 * @private
		 */
		protected var _listener:ResultListener = null;

		/**
		 * The number of tests that failed.
		 */
		public function get failCount():int
		{
			return _listener.failures.length;
		}

		/**
		 * The collection of test failures.
		 */
		public function get failures():Vector.<Failure>
		{
			return _listener.failures;
		}

		/**
		 * The number of tests that were ignored.
		 */
		public function get ignoreCount():int
		{
			return _listener.ignoreCount;
		}

		/**
		 * The number of tests that were run, whether they passed or failed.
		 */
		public function get runCount():int
		{
			return _listener.runCount;
		}

		/**
		 * The total run time of the test run, in milliseconds.
		 */
		public function get runTime():Number
		{
			return _listener.runTime;
		}

		/**
		 * Indicates if the test run was successful or not.
		 */
		public function get successful():Boolean
		{
			return _listener.failures.length === 0;
		}

		/**
		 * For internal use only.
		 */
		public function createListener():IRunListener
		{
			if(!_listener)
			{
				_listener = new ResultListener(this);
			}
			return _listener;
		}
	}
}

import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.Result;

class ResultListener implements IRunListener
{
	public function ResultListener(result:Result)
	{
		_result = result;
	}

	private var _result:Result = null;

	private var _ignoreCount:int = 0;

	public function get ignoreCount():int
	{
		return _ignoreCount;
	}

	private var _failures:Vector.<Failure> = new <Failure>[];

	public function get failures():Vector.<Failure>
	{
		return _failures;
	}

	private var _runCount:int = 0;

	public function get runCount():int
	{
		return _runCount;
	}

	private var _startTime:Number = 0;
	private var _runTime:Number = 0;

	public function get runTime():Number
	{
		return _runTime;
	}

	public function testRunStarted(description:String):void
	{
		_startTime = (new Date()).getTime();
		_runTime = 0;
		_runCount = 0;
		_ignoreCount = 0;
		_failures = new <Failure>[];
	}

	public function testRunFinished(result:Result):void
	{
		_runTime = ((new Date()).getTime() - _startTime);
	}

	public function testStarted(description:String):void
	{
	}

	public function testFinished(description:String):void
	{
		_runCount++;
	}

	public function testFailure(failure:Failure):void
	{
		_failures.push(failure);
	}

	public function testIgnored(description:String):void
	{
		_ignoreCount++;
	}
}