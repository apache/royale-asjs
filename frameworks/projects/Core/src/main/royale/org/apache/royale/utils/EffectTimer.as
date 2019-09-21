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
package org.apache.royale.utils
{
COMPILE::SWF
{
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
}
COMPILE::JS
{
    import org.apache.royale.events.EventDispatcher;
}
import org.apache.royale.core.IEffectTimer;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.ValueEvent;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched as requested via the delay and
 *  repeat count parameters in the constructor.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[Event(name="update", type="org.apache.royale.events.ValueEvent")]

/**
 *  The Timer class dispatches events based on a delay
 *  and repeat count.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class EffectTimer extends EventDispatcher implements IEffectTimer
{
    /**
     *  Constructor.
     *
     *  @param delay The number of milliseconds
     *  to wait before dispatching the event.
     *  @param repeatCount The number of times to dispatch
     *  the event.  If 0, keep dispatching forever.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function EffectTimer()
    {
        interval = ValuesManager.valuesImpl.getValue(this, "effectTimerInterval");
        COMPILE::SWF
        {
            timer = new flash.utils.Timer(interval);
            timer.addEventListener("timer", timerHandler);
        }
    }

    private var interval:int=-1;

    COMPILE::SWF
    private var timer:flash.utils.Timer;

    COMPILE::JS
    private var timerInterval:Number = -1;

    public function start():Number
    {
        COMPILE::SWF
        {
            timer.start();
            return flash.utils.getTimer();
        }
        COMPILE::JS
        {
            if (timerInterval == -1)  {
                timerInterval = setInterval(timerHandler, interval);
            }
            var d:Date = new Date();
            return d.getTime();
        }
    }

    public function stop():void
    {
        COMPILE::SWF
        {
            timer.stop();
        }
        COMPILE::JS
        {
            if (timerInterval != -1) {
                clearInterval(timerInterval);
                timerInterval = -1;
            }
        }
    }

    COMPILE::SWF
    private function timerHandler(event:flash.events.TimerEvent):void
    {
        event.updateAfterEvent();
        dispatchEvent(new ValueEvent("update", flash.utils.getTimer()));
    }

    COMPILE::JS
    private function timerHandler():void
    {
        var d:Date = new Date();
        dispatchEvent(new ValueEvent('update', d.getTime()));
    }
}
}
