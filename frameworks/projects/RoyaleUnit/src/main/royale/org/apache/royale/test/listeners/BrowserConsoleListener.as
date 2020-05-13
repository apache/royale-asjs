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
	import org.apache.royale.test.AssertionError;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.runners.notification.Result;


	/**
	 * Outputs the status of a test run to the debug console.
	 */
	public class BrowserConsoleListener implements IRunListener
	{
		/**
		 * @private
		 */
		public function BrowserConsoleListener()
		{
		}

		/**
		 * @private
		 */
		protected var _startTime:Number = 0;

		/**
		 * @private
		 */
		protected var _testCount:int = 0;

		/**
		 * @private
		 */
		protected var _ignoreCount:int = 0;

		/**
		 * @private
		 */
		protected var _failures:Vector.<Failure> = null;
	
		/**
		 * @private
		 */
		public function testStarted(description:String):void
		{
			tracer(description + " .");
		}
	
		/**
		 * @private
		 */
		public function testFinished(description:String):void
		{
			_testCount++;
		}
	
		/**
		 * @private
		 */
		public function testFailure(failure:Failure):void
		{
			_failures.push(failure);

			var error:Error = failure.exception;
			if(error is AssertionError)
			{
				tracer(failure.description + " F");
			}
			else //some other error
			{
				tracer(failure.description + " E");
			}
		}
	
		/**
		 * @private
		 */
		public function testIgnored(description:String):void
		{
			_ignoreCount++;
			tracer(description + " I");
		}
	
		/**
		 * @private
		 */
		public function testRunStarted(description:String):void
		{
			_startTime = (new Date()).getTime();
			_testCount = 0;
			_ignoreCount = 0;
			_failures = new <Failure>[];
		}
	
		/**
		 * @private
		 */
		public function testRunFinished(result:Result):void
		{
			var totalTime:Number = ((new Date()).getTime() - _startTime) / 1000;
			tracer("Time: " + totalTime);

			if(_failures.length > 0)
			{
				if(_failures.length === 1)
				{
					tracer("There was 1 failure:");
				}
				else
				{
					tracer("There were " + _failures.length + " failures:");
				}
				for(var i:int = 0; i < _failures.length; i++)
				{
					tracer((i + 1) + " " + getFailureMessage(_failures[i]));
				}
			}

			var testString:String = "tests";
			if(_testCount === 1)
			{
				testString = "test";
			}

			if(_ignoreCount > 0)
			{
				testString += ", " + _ignoreCount + " ignored";
			}

			if(_failures.length > 0)
			{
				var failureString:String = "failures";
				if(_failures.length === 1)
				{
					failureString = "failure";
				}
				tracer("FAILURE (" + _testCount + " " + testString + ", " + _failures.length + " " + failureString + ")");
			}
			else
			{
				tracer("OK (" + _testCount + " " + testString + ")");
			}
		}

		/**
		 * @private
		 */
		protected function getFailureMessage(failure:Failure):String
		{
			var message:String = failure.description;
			var exception:Error = failure.exception;
			if(exception.stack)
			{
				//message may be duplicated in some browsers, but it needs to be
				//included because Firefox omits it
				message += " " + exception.message + "\n" + exception.stack;
			}
			else if(exception.message)
			{
				message += " " + exception.message;
			}
			else
			{
				message += " " + exception;
			}
			return message;
		}
	}
}

function tracer(...args):void
{

	COMPILE::JS {
		args.unshift('[JS]');
		console.log.apply(console, args);
	}
	COMPILE::SWF{
		import flash.external.ExternalInterface;

		if (ExternalInterface.available)
		{
			try
			{
				args.unshift('[SWF]');
				const method:String = 'console.log.apply';
				ExternalInterface.call(method, null, args);
			} catch (e:Error)
			{
			}
		}
	}
}