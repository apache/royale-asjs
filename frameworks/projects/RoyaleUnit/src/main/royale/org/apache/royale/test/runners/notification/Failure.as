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
	 * The result of a failed test.
	 */
	public class Failure
	{
		/**
		 * Constructor.
		 */
		public function Failure(description:String, exception:Error)
		{
			_description = description;
			_exception = exception;
			_message = exception.message;
			COMPILE::SWF
			{
				_stackTrace = exception.getStackTrace();
			}
			COMPILE::JS
			{
				_stackTrace = exception.stack;
			}
		}

		/**
		 * @private
		 */
		protected var _description:String = null;

		/**
		 * The description of the test that failed.
		 */
		public function get description():String
		{
			return _description;
		}

		/**
		 * @private
		 */
		protected var _exception:Error = null;

		/**
		 * The exception that caused the test to fail.
		 */
		public function get exception():Error
		{
			return _exception;
		}

		/**
		 * @private
		 */
		protected var _stackTrace:String = null;

		/**
		 * The exception's stack trace.
		 */
		public function get stackTrace():String
		{
			return _stackTrace;
		}

		/**
		 * @private
		 */
		protected var _message:String = null;

		/**
		 * The exception's message.
		 */
		public function get message():String
		{
			return _message;
		}
	}
}