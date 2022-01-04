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
    import org.apache.royale.utils.functional.*;
    
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
            var value:Number = 0;
            var foo = function(){
                this.value = 0;
                this.increment = function(val:Number){
                    this.value+=val;
                }
            }
            var fooObj = new foo();
            var thisDebounced:Function = debounceLong(fooObj.increment,30,fooObj);
            setTimeout(thisDebounced, 10,5);
            setTimeout(thisDebounced, 10,4);
            setTimeout(thisDebounced, 10,3);
            setTimeout(thisDebounced, 10,2);
            setTimeout(thisDebounced, 10,1);
            function increment(val:Number){
                value+=val;
            }
            var debounced:Function = debounceLong(increment,30);
            setTimeout(debounced, 10,5);
            setTimeout(debounced, 10,4);
            setTimeout(debounced, 10,3);
            setTimeout(debounced, 10,2);
            setTimeout(debounced, 10,1);
            Async.delayCall(this, function():void
            {
                assertTrue(fooObj.value == 1,"foo value should be incremented by 1");
                assertTrue(value == 1,"Should be incremented by 1");
            }, 100);
        }

        [Test(async,timeout="300")]
        public function testDebounceShort():void
        {
            var foo = function(){
                this.value = 0;
                this.increment = function(val:Number){
                    this.value+=val;
                }
            }
            var fooObj = new foo();
            var thisDebounced:Function = debounceShort(fooObj.increment,30,fooObj);
            setTimeout(thisDebounced, 10,5);
            setTimeout(thisDebounced, 10,4);
            setTimeout(thisDebounced, 10,3);
            setTimeout(thisDebounced, 10,2);
            setTimeout(thisDebounced, 10,1);

            var value:Number = 0;
            function increment(val:Number){
                value+=val;
            }
            var debounced:Function = debounceShort(increment,30);
            setTimeout(debounced, 10,5);
            setTimeout(debounced, 10,4);
            setTimeout(debounced, 10,3);
            setTimeout(debounced, 10,2);
            setTimeout(debounced, 10,1);
            Async.delayCall(this, function():void
            {
                assertTrue(fooObj.value > 1,"foo value should be greater than 1");
                assertTrue(value > 1,"Should be greater than 1");
            }, 100);
        }


    }
}
