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
    import org.apache.royale.utils.string.*;
    import org.apache.royale.test.asserts.*;
    
    public class StringUtilsTest
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
        public function testContains():void
        {
            assertTrue(contains("food","foo"),"food contains foo");
            assertTrue(!contains("foo","food"),"foo does not contain food");
            assertTrue(!contains("food","baz"),"food does not contain baz");
        }

        [Test]
        public function testTrim():void
        {
            assertTrue(trim("  foo  ") == "foo","Should be 'foo'");
        }

        [Test]
        public function testTrimLeft():void
        {
            assertTrue(trimLeft("  foo  ") == "foo  ","Should be 'foo  ' (with spaces after)");
        }

        [Test]
        public function testTrimRight():void
        {
            assertTrue(trimRight("  foo  ") == "  foo","Should be '  foo' (with spaces before)");
        }


    }
}
