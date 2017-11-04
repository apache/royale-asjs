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
package org.apache.royale.test.listeners
{
	import org.apache.royale.test.TestRunner;
	import org.apache.royale.test.events.TestEvent;
	import org.apache.royale.test.errors.AssertionError;

	public class TraceListener
	{
		public function TraceListener(runner:TestRunner)
		{
			runner.addEventListener(TestEvent.TEST_RUN_START, testRunStartHandler);
			runner.addEventListener(TestEvent.TEST_RUN_COMPLETE, testRunCompleteHandler);
			runner.addEventListener(TestEvent.TEST_RUN_FAIL, testRunFailHandler);
			runner.addEventListener(TestEvent.TEST_START, testStartHandler);
			runner.addEventListener(TestEvent.TEST_COMPLETE, testCompleteHandler);
			runner.addEventListener(TestEvent.TEST_FAIL, testFailHandler);
		}

		private var _startTime:Number;
		private var _passCount:int;
		private var _failCount:int;
		private var _failures:Vector.<String>;

		private function finish():void
		{
			var totalTime:Number = ((new Date()).getTime() - this._startTime) / 1000;
			trace("Time: " + totalTime);

			var failureMessageCount:int = this._failures.length;
			if(failureMessageCount > 0)
			{
				if(this._failCount == 1)
				{
					trace("There was 1 failure:");
				}
				else
				{
					trace("There were " + this._failCount + " failures:");
				}
				for(var i:int = 0; i < failureMessageCount; i++)
				{
					trace((i + 1) + " " + this._failures[i]);
				}
			}

			var totalCount:int = this._passCount + this._failCount;
			var testString:String = "tests";
			if(totalCount == 1)
			{
				testString = "test";
			}

			if(this._failCount > 0)
			{
				var failureString:String = "failures";
				if(this._failCount == 1)
				{
					failureString = "failure";
				}
				trace("FAILURE (" + totalCount + " " + testString + ", " + this._failCount + " " + failureString + ")");
			}
			else
			{
				trace("OK (" + this._passCount + " " + testString + ")");
			}
		}

		private function testRunStartHandler(event:TestEvent):void
		{
			this._startTime = (new Date()).getTime();
			this._passCount = 0;
			this._failCount = 0;
			this._failures = new <String>[];
		}

		private function testRunFailHandler(event:TestEvent):void
		{
			finish();
		}

		private function testRunCompleteHandler(event:TestEvent):void
		{
			finish();
		}

		private function testStartHandler(event:TestEvent):void
		{
			trace(event.testName + " .");
		}

		private function testCompleteHandler(event:TestEvent):void
		{
			this._passCount++;
		}

		private function testFailHandler(event:TestEvent):void
		{
			this._failCount++;
			var error:Error = event.error;
			if(error is AssertionError)
			{
				trace(event.testName + " F");
			}
			else //some other error
			{
				trace(event.testName + " E");
			}

			var message:String = event.testName;
			if(error is Error)
			{
				var errorMessage:String = error.message;
				if(errorMessage)
				{
					message += " " + errorMessage;
				}
				message += " " + error.stack;
			}
			else //fall back to the normal toString()
			{
				message += " " + error;
			}
			this._failures.push(message);
		}
	}
}