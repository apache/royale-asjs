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
  import org.apache.royale.events.Event;

  /**
   * The CompoundAsyncTask class allows running a number of AsyncTasks in parallel and resolves when they are done.
   *  @langversion 3.0
   *  @playerversion Flash 10.2
   *  @playerversion AIR 2.6
   *  @productversion Royale 0.9.6
   */
  public class CompoundAsyncTask extends AsyncTask
  {
    public function CompoundAsyncTask(tasks:Array=null)
    {
      super();
      if(!tasks){
        tasks = [];
      }
      this.tasks = tasks;
      completedTasks = [];
      failedTasks = [];
    }
    protected var tasks:Array;

    private var _failEarly:Boolean;
    /**
     * If <code>failEarly</code> is true, the task will fail as soon as the first subtask fails.
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get failEarly():Boolean
    {
    	return _failEarly;
    }

    public function set failEarly(value:Boolean):void
    {
    	_failEarly = value;
    }
    /**
     * Adds a task to the task list.
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function addTask(task:IAsyncTask):void{
      tasks.push(task);
    }
    
    protected var pendingTasks:Array;

    /**
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     *  @royalesuppresspublicvarwarning
     */
    public var completedTasks:Array;
    /**
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     *  @royalesuppresspublicvarwarning
     */
    public var failedTasks:Array;

    override public function run(data:Object=null):void
    {
      if(_status == "pending"){// don't allow running twice
        return;
      }
      _status = "pending";

      pendingTasks = tasks.slice();

      for each(var task:IAsyncTask in tasks){
        task.done(handleDone);
        task.run();
      }
    }
    private function handleDone(task:IAsyncTask):void
    {
      if(_status != "pending")
      {
        return;
      }
      var idx:int = pendingTasks.indexOf(task);
      pendingTasks.splice(idx,1);
      switch(task.status){
        case "complete":
          completedTasks.push(task);
          break;
        // what to do for "mixed?
        // We're assuming this is "failed" and adding the result to the failed tasks.
        case "mixed":
        case "failed":
          failedTasks.push(task);
          if(failEarly)
          {
            while(pendingTasks.length)
            {
              var pending:IAsyncTask = pendingTasks.pop();
              pending.cancel();
            }
            fail();
            return;
          }
          break;
        default:// not sure why this would happen
          throw new Error("Unknown task status");
      }
      if(pendingTasks.length == 0)
      {
        setFinalStatus();
      }
    }
    protected function setFinalStatus():void
    {
      if(failedTasks.length == 0)
      {
        complete();
      }
      else if(completedTasks.length == 0)
      {
        fail();
      }
      else
      {// Some passed and some failed -- Does this make sense?
        _status = "mixed";
        dispatchEvent(new Event("failed"));
        dispatchEvent(new Event("complete"));
        notifyDone();
      }      
    }

    /**
     * Static helper method for invoking the task in a single expression
     *  @langversion 3.0
     *  @productversion Royale 0.9.9
     */
		public static function execute(tasks:Array,callback:Function,failEarly:Boolean=false):void{
			var task:CompoundAsyncTask = new CompoundAsyncTask(tasks);
			task.failEarly = failEarly;
      task.done(function():void{
        callback(task);
      });
			task.run();
		}    
  }
}