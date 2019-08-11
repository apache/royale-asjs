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
package flexUnitTests.github
{
    import org.apache.royale.test.asserts.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class GithubIssues2018
    {
        public static var isJS:Boolean;
    
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            isJS = COMPILE::JS;
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
        
        
       
        //example, postfix the test method with issue reference:
        [Test]
        public function testIssue_273():void
        {
            //https://github.com/apache/royale-asjs/issues/273
            var a:Object = { a: int, b:uint, c:int, d:uint };
            
            //int
            var test:* = new (Class(a.a))(-21.5);
            assertEquals(-21, test, 'unexpected coercion check');
            //uint
            test = new (a.b as Class)(-21.5);
            assertEquals(4294967275, test, 'unexpected coercion check');

        }
    }
}
