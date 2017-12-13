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
package flexUnitTests.jira
{
    import flexunit.framework.Assert;

    
    public class JiraTesterTest
    {		
		public static var isJS:Boolean;
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            var js:Boolean = false;
            try {
                var check:* = getDefinitionByName("flash.system.Capabilities");
            } catch (e:Error) {
                js = true;
            }
            //if this next reference to 'check' is not included, then the above try/catch code
            // appears to be optimized away in js-release mode
            //todo: this is inconsistent with swf, need to create simple test case for jx compiler/gcc
            if (check == null) {
                js = true;
            }
            isJS = js;
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
        
       
        /*
		// TEST METHODS 
		*/
        
		//example, postfix the test method with JIRA issue reference:
        /*[Test]
        public function testJIRA_FLEX_9999():void
        {

        }*/    
    }
}
