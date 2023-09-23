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
package flexUnitTests
{

	import org.apache.royale.test.asserts.*;
	import org.apache.royale.test.async.*;
	import org.apache.royale.functional.*;
	import org.apache.royale.functional.decorator.*;
	import org.apache.royale.test.asserts.assertTrue;
	import org.apache.royale.test.asserts.assertEquals;
	import org.apache.royale.utils.async.promiseToTask;
	import org.apache.royale.utils.async.PromiseTask;
	import org.apache.royale.utils.async.AsyncTask;
	import org.apache.royale.utils.async.taskToPromise;
	import org.apache.royale.test.asserts.assertNotEquals;
	
	public class TaskTests
	{		
			[Before]
			public function setUp():void
			{
			}
			
			[After]
			public function tearDown():void
			{
			}
			
			[BeforeClass]
			public static function setUpBeforeClass():void
			{
			}
			
			[AfterClass]
			public static function tearDownAfterClass():void
			{
			}

			[Test(async,timeout="50")]
			public function testPromiseToTask():void
			{
				var resolvePromise:Promise = new Promise(function(resolve:Function, reject:Function):void{
					resolve("resolved");
				});
				var resolvedTask:PromiseTask = promiseToTask(resolvePromise);
				resolvedTask.done(function(task:PromiseTask):void{
					assertEquals(task.result, "resolved");
				});
				resolvedTask.run();

				var rejectedPromise:Promise = new Promise(function(resolve:Function, reject:Function):void{
					reject("rejected");
				});
				var rejectedTask:PromiseTask = promiseToTask(rejectedPromise);
				rejectedTask.done(function(task:PromiseTask):void{
					assertEquals(task.error, "rejected");
				});
				rejectedTask.run();
			}

			[Test(async,timeout="300")]
			public function testTaskToPromise():void
			{
				var completeTask:AsyncTask = new CompleteTask();
				var completePromise:Promise = taskToPromise(completeTask);
				var failTask:AsyncTask = new FailTask();
				var promiseFailed:Boolean;
				var promiseCompleted:Boolean;
				taskToPromise(completeTask).then(function(result:*):void{
					promiseCompleted = true;
					// trace('assertEquals(result, "completed");');
					// assertEquals(result, "completed");
				}, function(error:*):void{
					promiseCompleted = false;
					// trace('assertTrue(false, "should not be called");')
					// assertTrue(false, "should not be called");
				});
				taskToPromise(failTask).then(function(result:*):void{
					promiseFailed = false;
					// trace('assertTrue(false, "should not be called");')
					// assertTrue(false, "should not be called");
				}, function(error:*):void{
					promiseFailed = true;
					// trace('assertEquals(error, "failed");');
					// assertEquals(error, "failed");
				});
				completeTask.run();
				failTask.run();

					Async.delayCall(this, function():void
					{
							assertTrue(promiseCompleted,"Promise should complete");
							assertTrue(promiseFailed,"Promise should fail");
					}, 200);
			}

	}
}
import org.apache.royale.utils.async.AsyncTask;

class CompleteTask extends AsyncTask
{
	public function CompleteTask()
	{
		super();
	}
	override public function run(data:Object=null):void{
		this.data = "completed";
		complete();
	}
}
class FailTask extends AsyncTask
{
	public function FailTask()
	{
		super();
	}
	override public function run(data:Object=null):void{
		this.data = "failed";
		fail();
	}
}