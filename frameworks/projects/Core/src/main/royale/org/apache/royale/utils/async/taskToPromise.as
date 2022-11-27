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
package org.apache.royale.utils.async
{
	/**
	 * Utility function which takes a IAsyncTask and returns a Promise which 
	 * resolves when the task completes or rejects if the task fails.
	 * 
	 * Useful for converting IAsyncTask to Promise based APIs.
	 * 
	 * @langversion 3.0
	 * @productversion Royale 0.9.10
	 * 
	 */
	public function taskToPromise(task:IAsyncTask):Promise
	{
		var promise:Promise = new Promise(function(resolve:Function, reject:Function):void
		{
			task.done(function(task:IAsyncTask):void
			{
				if(task.completed)
					resolve(task.data);

				else
					reject(task.data);

			});
		});
		return promise;
	}
}