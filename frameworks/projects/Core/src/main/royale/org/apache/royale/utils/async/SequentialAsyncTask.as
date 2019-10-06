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
      var task:AsyncTask = pendingTasks.shift();
      task.done(handleDone);
      task.run();
    }
    private function handleDone(task:AsyncTask):void
    {
      if(_status != "pending"){
        return;
      }
      switch(task.status){
        case "complete":
          completedTasks.push(task);
          break;
        case "failed":
          failedTasks.push(task);
          if(failEarly){
            pendingTasks = [];
            fail();
            return;
          }
          break;
        default:// not sure why this would happen
          throw new Error("Unknown task status");

      }
      if(pendingTasks.length){
        var nextTask:AsyncTask = pendingTasks.shift();
        nextTask.done(handleDone);
        nextTask.run(task);
      } else {
        setFinalStatus();
      }
    }
  }
}