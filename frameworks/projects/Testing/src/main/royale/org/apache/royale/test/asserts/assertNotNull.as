/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.royale.test.asserts {
	COMPILE::SWF
	{
		import org.flexunit.Assert;
	}

	COMPILE::JS
	{
		import org.apache.royale.test.Assert;
	}

	/**
	 * Alias for org.flexunit.Assert assertNotNull method
	 * 
	 * @param rest
	 *			Accepts an argument of type Object.
	 * 			If two arguments are passed the first argument must be a String
	 * 			and will be used as the error message.
	 * 			
	 * 			<code>assertNotNull( String, Object );</code>
	 * 			<code>assertNotNull( Object );</code>
	 * 
	 * @see org.flexunit.Assert assertNotNull 
	 */
	public function assertNotNull(actual:*, message:String = null):void {
		COMPILE::SWF
		{
			if(message)
				Assert.assertNotNull(message, actual);
			else
				Assert.assertNotNull(actual);
		}
		COMPILE::JS
		{
			Assert.notNull(actual, message);
		}
	}
}