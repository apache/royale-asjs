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
package flexUnitTests.language
{
    
    import org.apache.royale.test.asserts.*;
    import flexUnitTests.language.support.*;
    
    import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestLoopVariants
    {
    
        public static var isJS:Boolean = COMPILE::JS;
    
    

        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Before]
        public function setUp():void
        {
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        

        
        [Test]
        public function testWhileLoopWithoutBody():void
        {
            var test:int=-1;
            var limit:int=100;
            //while loop with no body
            while (++test<limit);

            assertEquals(test, limit, 'unexpected result');
        }

        [Test]
        public function testWhileLoopWithEmptyBody():void
        {
            var test:int=-1;
            var limit:int=100;
            //while loop with empty body
            while (++test<limit){}

            assertEquals(test, limit, 'unexpected result');

        }

        [Test]
        public function testForLoopWithoutBody():void
        {
            var test:int=-1;
            var limit:int=100;
            //for loop with missing body
            for (test=-1;test<limit;test++);

            assertEquals(test, limit, 'unexpected result');

        }
        
    }
}

