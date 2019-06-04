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
  import org.apache.royale.events.EventDispatcher;
  import org.apache.royale.events.Event;

  /**
   * AsyncTask is a base class for AsyncTasks which let the caller know when they are done.
   * AsyncTask is an OOP replacement for Promises and simple callbacks which allows for
   * strongly typed async requests with any kind of payload and behavior.
   * AsyncTask must be subclassed to be used.
   * The subclass must implement the `run` method to define the behavior when the task is "run".
   */

  [Event(name="complete", type="org.apache.royale.events.Event")]
  [Event(name="failed", type="org.apache.royale.events.Event")]
  [Event(name="done", type="org.apache.royale.events.Event")]
  public abstract class AsyncTask extends EventDispatcher
  {
    public function AsyncTask()
    {

    }
    public static const INITIALIZED:String = "initialized";
    public static const PENDING:String = "pending";
    public static const COMPLETE:String = "complete";
    public static const CANCELED:String = "canceled";
    public static const FAILED:String = "failed";
    /**
     * Used in compound tasks
     */
    public static const MIXED:String = "mixed";
    protected var _status:String = "initialized";
    /**
     * One of: initialized, pending, complete, failed or mixed (for compound tasks)
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get status():String
    {
      return _status;
    }
    
    /**
     * completed (and a status of `complete`) means the task completed successfully
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get completed():Boolean
    {
    	return _status == "complete";
    }
    public function set completed(value:Boolean):void
    {
    	_status = "complete";
    }

    /**
     * failed (and a status of `failed`) means the task resolved to a failed state
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get failed():Boolean
    {
    	return _status == "failed";
    }
    public function set failed(value:Boolean):void
    {
    	_status = "failed";
    }
    /**
     * resolves the task as complete
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function complete():void{
      _status = "complete";
      dispatchEvent(new Event("complete"));
      notifyDone();
    }
    /**
     * Resolves the task as failed
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function fail():void{
      _status = "failed";
      dispatchEvent(new Event("failed"));
      notifyDone();
    }
    protected function notifyDone():void{
      dispatchEvent(new Event("done"));
      if(!doneCallbacks){
        return;
      }
      for(var i:int=0;i<doneCallbacks.length;i++){
        doneCallbacks[i](this);
      }
    }
    private var doneCallbacks:Array;

    /**
     * done accepts a callback which is called when the task is resolved.
     * The callback is resolved whether the task is successfully completed or not.
     * The properties of the task should be examined in the callback to determine the results.
     * The `done` event can be listened too as well.
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function done(callback:Function):AsyncTask{
      if(!doneCallbacks){
        doneCallbacks = [];
      }
      doneCallbacks.push(callback);
      return this;
    }
    public abstract function run(data:Object=null):void;

    /**
     * cancel resolves the task as "canceled"
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function cancel():void
    {
      _status = "canceled";
      notifyDone();
    }

    private var _data:Object;
    /**
     * The data of the task
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get data():Object
    {
    	return _data;
    }

    public function set data(value:Object):void
    {
    	_data = value;
    }

  }
}