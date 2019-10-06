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
package flexUnitTests.core
{
    import org.apache.royale.test.asserts.*;
    
    import org.apache.royale.utils.MD5;
    
    public class MD5Test
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
        public function testHash():void
        {
            assertEquals( "80338e79d2ca9b9c090ebaaa2ef293c7", MD5.hash("foobaz"), "Error testing foobaz");
            assertEquals("b6a013d5e2c00f894584ad577249dbc7", MD5.hash("bazfoo"), "Error testing bazfoo");
            assertEquals("bdc87b9c894da5168059e00ebffb9077", MD5.hash("password1234"), "Error testing password1234");
        }
    }
}
