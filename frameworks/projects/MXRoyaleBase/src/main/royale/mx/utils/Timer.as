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
package mx.utils
{

    import mx.events.TimerEvent;

    COMPILE::SWF{
        import flash.utils.Timer;
        import flash.events.TimerEvent;
    }

    COMPILE::JS{
        import org.apache.royale.utils.Timer;
        import org.apache.royale.events.Event;
    }



    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when timer stops
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
    [Event(name="timerComplete", type="mx.events.TimerEvent")]

    /**
     *  Dispatched as requested via the delay and
     *  repeat count parameters in the constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="timer", type="mx.events.TimerEvent")]


    /**
     *  The Timer class dispatches events based on a delay
     *  and repeat count.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     *
     *  @royalesuppresspublicvarwarning
     */
    COMPILE::JS
    public class Timer extends org.apache.royale.utils.Timer
    {
        public function Timer(delay:Number, repeatCount:int = 0)
        {
            super(delay, repeatCount);
        }

        override protected function timerEvent(evtType:String):Event{
            return new TimerEvent(evtType);
        }

        override protected function repeatsFinished():void{
            dispatchEvent(timerEvent(TimerEvent.TIMER_COMPLETE));
        }
    }

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when timer stops
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
    [Event(name="timerComplete", type="mx.events.TimerEvent")]

    /**
     *  Dispatched as requested via the delay and
     *  repeat count parameters in the constructor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="timer", type="mx.events.TimerEvent")]
    /**
     *  The Timer class dispatches events based on a delay
     *  and repeat count.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     *
     */
    COMPILE::SWF
    public class Timer extends flash.utils.Timer
    {
        public function Timer(delay:Number, repeatCount:int = 0)
        {
            super(delay, repeatCount);
            addEventListener("timer", interceptor, false, 9999);
            addEventListener("timerComplete", interceptor, false, 9999);
        }

        private function interceptor(event:flash.events.Event):void
        {
            if (event is flash.events.TimerEvent)
            {
                event.stopImmediatePropagation();
                dispatchEvent(new mx.events.TimerEvent(event.type));
            }
        }
    }
}
