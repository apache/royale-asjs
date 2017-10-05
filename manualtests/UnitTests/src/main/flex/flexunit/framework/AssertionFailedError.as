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
package flexunit.framework
{
	/**
	 * <code>Error</code> class used for failures in assertions
	 * 
	 * @see Assert
	 */
	public class AssertionFailedError extends Error
	{
		/**
		 * Throws a new <code>Error</code> of type <code>AssertionError</code>
		 * with the passed in message
		 * 
		 * @param message The message associated with the error (<code>null</code> okay)
		 * @param id The id of the error if desired (<code>null</code> okay)
		 */
		public function AssertionFailedError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}
