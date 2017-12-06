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
    import org.apache.royale.utils.array.*;
    import org.apache.royale.core.Strand;
    import org.apache.royale.test.asserts.*;
    
    public class ArrayUtilsTest
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
        
        [Test]
        public function testRangeCheck():void
        {
            var arr:Array = [1,2,3,"a","b","c"];
            assertTrue(rangeCheck(0,arr),"0 should be valid");
            assertTrue(rangeCheck(5,arr),"5 should be valid");
            assertTrue(rangeCheck(-1,arr) == false,"-1 should not be valid");
            assertTrue(rangeCheck(6,arr) == false,"6 should not be valid");
        }

    }
}
