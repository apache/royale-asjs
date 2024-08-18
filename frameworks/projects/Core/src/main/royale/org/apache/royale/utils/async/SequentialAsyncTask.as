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
   * The SequentialAsyncTask runs a list of tasks in sequential order.
   * Each sunsequent task is only run once the previous task is done.
   * The previous task is used as the argument for the next task's run method.
   * This enables the chaining of results.
   */
  public class SequentialAsyncTask extends CompoundAsyncTask
  {
    /**
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function SequentialAsyncTask(tasks:Array=null)
    {
      super(tasks);
    }
    override public function run(data:Object=null):void
    {
      _status = "pending";
      pendingTasks = tasks.slice();
      var task:IAsyncTask = pendingTasks.shift();
      task.done(handleDone);
      task.run();
    }
    private function handleDone(task:IAsyncTask):void
    {
      if(_status != "pending"){
        return;
      }
      switch(task.status){
        case "complete":
          completedTasks.push(task);
          break;
        // what to do for "mixed?
        // We're assuming this is "failed" and adding the result to the failed tasks.
        case "mixed":
				// canceled tasks are also added to failed tasks
				case "canceled":
        case "failed":
          failedTasks.push(task);
          if(failEarly){
            cancelTasks();
            fail();
            return;
          }
          break;
        default:// not sure why this would happen
          throw new Error("Unknown task status");

      }
      if(pendingTasks.length){
        var nextTask:IAsyncTask = pendingTasks.shift();
        nextTask.done(handleDone);
        nextTask.run(task);
      } else {
        setFinalStatus();
      }
    }
    /**
     * Static helper method for invoking the task in a single expression
     *  @langversion 3.0
     *  @productversion Royale 0.9.9
    */
		public static function execute(tasks:Array,callback:Function,failEarly:Boolean=false):void{
			var task:SequentialAsyncTask = new SequentialAsyncTask(tasks);
      task.failEarly = failEarly;
			task.done(function():void{
        callback(task);
      });
			task.run();
		}
  }
}