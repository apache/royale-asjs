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
package flexUnitTests.mxroyale
{
    
    

    import org.apache.royale.test.asserts.*;
    import org.apache.royale.test.async.Async;
    import flexUnitTests.mxroyale.support.*;
    
    
    COMPILE::SWF
    {
        import flash.utils.Timer;
        import flash.events.TimerEvent;

        //the 'emulation' swf versions should work the same also, to test swap the comment block between above and below
        /*import mx.utils.Timer;
        import mx.events.TimerEvent;*/

    }
    COMPILE::JS
    {
        import mx.utils.Timer;
        import mx.events.TimerEvent;
    }

    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class TimerEmulationTest
    {
    
        
        public static var isJS:Boolean = COMPILE::JS;
    

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
    
        private var timer:Timer;


        private function recordTimerEventHandler(into:Array):Function{
            return function(event:TimerEvent):void{
                into.push(event.type);
            }
        }


        [Test]
        public function testNoRun():void{
            var events:Array = [];
            timer = new Timer(100,1);
            var listener:Function  = recordTimerEventHandler(events);
            timer.addEventListener(TimerEvent.TIMER,listener);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,listener);
            var expected:Array = []; //should be no events at all
            timer.start();
            timer.stop();
            assertEquals(events.join(','), expected.join(','), 'Unexpected Timer Event sequence');
        }

    
        [Test(async)]
        public function testSingleRun():void{
            var events:Array = [];

            timer = new Timer(100,1);
            var listener:Function  = recordTimerEventHandler(events);
            timer.addEventListener(TimerEvent.TIMER,listener);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,listener);
            var expected:Array = [TimerEvent.TIMER, TimerEvent.TIMER_COMPLETE];
            timer.start();
            Async.delayCall(this, function():void
            {
                assertEquals(events.join(','), expected.join(','), 'Unexpected Timer Event sequence');
            }, 150);
        }


        [Test(async)]
        public function testDualRun():void{
            var events:Array = [];

            timer = new Timer(100,2);
            var listener:Function  = recordTimerEventHandler(events);
            timer.addEventListener(TimerEvent.TIMER,listener);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,listener);
            var expected:Array = [TimerEvent.TIMER, TimerEvent.TIMER, TimerEvent.TIMER_COMPLETE];
            timer.start();
            Async.delayCall(this, function():void
            {
                assertEquals(events.join(','), expected.join(','), 'Unexpected Timer Event sequence');
            }, 250);
        }
    
    
        
    }
}
