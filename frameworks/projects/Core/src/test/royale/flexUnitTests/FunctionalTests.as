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
    COMPILE::SWF{
        import flash.utils.setTimeout;
    }

    import org.apache.royale.test.asserts.*;
	import org.apache.royale.test.async.*;
    import org.apache.royale.functional.*;
    import org.apache.royale.functional.decorator.*;
    import org.apache.royale.test.asserts.assertTrue;
    import org.apache.royale.test.asserts.assertEquals;
    
    public class FunctionalTests
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

        [Test(async,timeout="300")]
        public function testDebounceLong():void
        {
            var foo:Foo = new Foo();
            var thisDebounced:Function = debounceLong(foo.increment,30);
            setTimeout(function():void{
                thisDebounced(5);
            },0);            
            setTimeout(function():void{
                thisDebounced(4);
            },5);
            setTimeout(function():void{
                thisDebounced(3);
            },10);
            setTimeout(function():void{
                thisDebounced(2);
            },100);
            setTimeout(function():void{
                thisDebounced(1);
            },110);
            
            var value:Number = 0;
            function increment(val:Number):void{
                value+=val;
                trace(val);
            }
            var debounced:Function = debounceLong(increment,30);
            setTimeout(function():void{
                debounced(5);
            },0);
            setTimeout(function():void{
                debounced(4);
            },5);
            setTimeout(function():void{
                debounced(3);
            },10);
            setTimeout(function():void{
                debounced(2);
            },100);
            setTimeout(function():void{
                debounced(1);
            },110);
            Async.delayCall(this, function():void
            {
                assertTrue(foo.value < 7,foo.value+": foo value should be incremented by 4");
                assertTrue(value < 7,value+": value should be incremented by 4");
            }, 300);
        }

        [Test(async,timeout="300")]
        public function testDebounceShort():void
        {
            var foo:Foo = new Foo();
            var thisDebounced:Function = debounceShort(foo.increment,30);
            
            setTimeout(function():void{
                thisDebounced(5);
            },0);
            setTimeout(function():void{
                thisDebounced(4);
            },5);
            setTimeout(function():void{
                thisDebounced(3);
            },10);
            setTimeout(function():void{
                thisDebounced(2);
            },100);
            setTimeout(function():void{
                thisDebounced(1);
            },110);

            var value:Number = 0;
            function increment(val:Number):void{
                value+=val;
            }
            var debounced:Function = debounceShort(increment,30);

            setTimeout(function():void{
                debounced(5);
            },0);
            setTimeout(function():void{
                debounced(4);
            },5);
            setTimeout(function():void{
                debounced(3);
            },10);
            setTimeout(function():void{
                debounced(2);
            },100);
            setTimeout(function():void{
                debounced(1);
            },110);
            Async.delayCall(this, function():void
            {
                assertTrue(foo.value > 6 && foo.value < 9, foo.value +": foo value should be 7");
                assertTrue(value > 6 && value < 9, value + ": value should be 7");
            }, 300);
        }
        [Test(async,timeout="300")]
        public function testThrottle():void
        {
            var foo:Foo = new Foo();
            var thisThrottled:Function = throttle(foo.increment,30);
            setTimeout(function():void{
                thisThrottled(5);
            },0);
            setTimeout(function():void{
                thisThrottled(4);
            },5);
            setTimeout(function():void{
                thisThrottled(3);
            },10);
            setTimeout(function():void{
                thisThrottled(2);
            },100);
            setTimeout(function():void{
                thisThrottled(1);
            },110);
            var value:Number = 0;
            function increment(val:Number):void{
                value+=val;
            }
            var throttled:Function = throttle(increment,30);
            setTimeout(function():void{
                throttled(5);
            },0);
            setTimeout(function():void{
                throttled(4);
            },5);
            setTimeout(function():void{
                throttled(3);
            },10);
            setTimeout(function():void{
                throttled(2);
            },100);
            setTimeout(function():void{
                throttled(1);
            },110);
            Async.delayCall(this, function():void
            {
                assertTrue(foo.value > 6 && foo.value < 9, foo.value +": foo value should be 7");
                assertTrue(value > 6 && value < 9, value + ": value should be 7");
            }, 300);
        }
        [Test(async,timeout="300")]
        public function testAnimate():void
        {
            var foo:Foo = new Foo();
            var animateThis:Function = animateFunction(foo.increment,20);
            for(var i:int=0;i<30;i++){
                animateThis(1);
            }
            var savedThisValue:Number;
            setTimeout(function():void{
                savedThisValue = foo.value;
            },75);

            var value:Number = 0;
            function increment(val:Number):void{
                value+=val;
            }
            var animated:Function = animateFunction(increment,20);
            var savedValue:Number;
            for(i=0;i<30;i++){
                animated(1);
            }

            setTimeout(function():void{
                savedValue = value;
            },75);

            var stoppedValue:Number = 0;
            function incrementStopped(val:Number):void{
                stoppedValue+=val;
            }
            var stopped:Function = animateFunction(incrementStopped,20);
            for(i=0;i<30;i++){
                var stoppedRef:Animated = stopped(1) as Animated;
            }
            setTimeout(function():void{
                stoppedRef.stop();
            },10);


            Async.delayCall(this, function():void
            {
                assertTrue(savedThisValue > 1 && savedThisValue < 4,savedThisValue + ": foo value should be 2");
                assertTrue(savedValue > 1 && savedValue < 4,savedValue + ": value should be 2");
                assertEquals(stoppedValue,1,"value should be 1");
            }, 300);
        }
        public function testDelay():void
        {
            var foo:Foo = new Foo();
            var delayedThis:Function = delayFunction(foo.increment,20);

            delayedThis(1);

            var firstThisValue:Number = foo.value;

            var savedThisValue:Number;
            setTimeout(function():void{
                savedThisValue = foo.value;
            },75);

            var value:Number = 0;
            function increment(val:Number):void{
                value+=val;
            }
            var delayed:Function = delayFunction(increment,20);
            delayed(1);
            var firstValue:Number = value;
            var savedValue:Number;
            setTimeout(function():void{
                savedValue = value;
            },75);
            Async.delayCall(this, function():void
            {
                assertEquals(firstThisValue,0,"foo value should be 0")
                assertEquals(savedThisValue,1,"foo value should be 1")
                assertEquals(firstValue,0,"value should be 0")
                assertEquals(savedValue,1,"value should be 1")
            }, 200);
        }


    }
}
class Foo
{
    public var value:Number = 0;
    public function increment(value:int):void{
        this.value += value;
        trace(this.value);
    }
}