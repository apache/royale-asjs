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

package mx.rpc
{

import org.apache.royale.events.Event;
import org.apache.royale.utils.Timer;

[ExcludeClass]
/**
 *  This class provides a mechanism for dispatching a method asynchronously.
 *  @private
 */
public class AsyncDispatcher
{
    /**
     *  @private
     */
    public function AsyncDispatcher(method:Function, args:Array, delay:Number)
    {
        super();
        _method = method;
        _args = args;
        _timer = new Timer(delay);
        _timer.addEventListener(Timer.TIMER, timerEventHandler);
        _timer.start();
    }

    //--------------------------------------------------------------------------
    //
    // Private Methods
    //
    //--------------------------------------------------------------------------

    private function timerEventHandler(event:Event):void
    {
        _timer.stop();
        _timer.removeEventListener(Timer.TIMER, timerEventHandler);
        // This call may throw so do not put code after it
        _method.apply(null, _args);
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    //
    //--------------------------------------------------------------------------

    private var _method:Function;
    private var _args:Array;
    private var _timer:Timer;
}

}
