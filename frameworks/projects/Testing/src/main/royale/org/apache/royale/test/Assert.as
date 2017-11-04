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
package org.apache.royale.test
{
	import org.apache.royale.test.AssertionError;

	public class Assert
	{
		public static function strictEqual(actual:*, expected:*, message:String = null):void
		{
			if(actual === expected)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function notStrictEqual(actual:*, expected:*, message:String = null):void
		{
			if(actual !== expected)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function equal(actual:*, expected:*, message:String = null):void
		{
			if(actual == expected)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function notEqual(actual:*, expected:*, message:String = null):void
		{
			if(actual != expected)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function true(actual:*, message:String = null):void
		{
			if(actual == true)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function false(actual:*, message:String = null):void
		{
			if(actual == false)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function null(actual:*, message:String = null):void
		{
			if(actual == null)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function notNull(actual:*, message:String = null):void
		{
			if(actual != null)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function nullStrict(actual:*, message:String = null):void
		{
			if(actual === null)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function notNullStrict(actual:*, message:String = null):void
		{
			if(actual !== null)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function undefined(actual:*, message:String = null):void
		{
			if(actual === undefined)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function defined(actual:*, message:String = null):void
		{
			if(actual !== undefined)
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function NaN(actual:*, message:String = null):void
		{
			if(isNaN(actual))
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function notNaN(actual:*, message:String = null):void
		{
			if(!isNaN(actual))
			{
				return;
			}
			throw new AssertionError(message);
		}

		public static function fail(message:String):void
		{
			throw new AssertionError(message);
		}
	}
}