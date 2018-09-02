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
package
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    [Event(name="triggered")]
    
    public class FiveSecondTrigger extends EventDispatcher
    {
        public function FiveSecondTrigger()
        {
            var t:Timer = new Timer(5000, 1);
            t.addEventListener(TimerEvent.TIMER, handleTimer);
            t.start();
        }
        
        private function handleTimer(event:TimerEvent):void
        {
            var e:Event = new Event("triggered");
            dispatchEvent(e);
        }

    }
}