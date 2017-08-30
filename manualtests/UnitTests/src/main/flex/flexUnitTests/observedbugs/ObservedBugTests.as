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
package flexUnitTests.observedbugs
{
    import flexunit.framework.Assert;
    import org.apache.flex.reflection.*;
    
    public class ObservedBugTests
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
            //this was originally necessary to avoid a gcc-related bug in js for release mode only
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


        [Test]
        public function testTryCatchJSReleaseModeWorks_a():void
        {
            var js:int = 1;
            try {
                js = getDefinitionByName("flash.system.Capabilities") != null ? 1 : 0;
            } catch (e:Error) {
                js = 2;
            }
			
            Assert.assertTrue("Unexpected value following try/catch",(isJS ? (js == 2) : (js == 1)));

        }
		
		//This Observed bug is no longer present 0.9.0
		//it may be related to a Google Closure Compiler update since it was originally observed
		//leaving the tests in here for now...
		//[TestVariance(variance="JS",description="Variance in test, this test fails in JS-Release mode only")]
        [Test]
        public function testTryCatchJSReleaseModeFails_b():void
        {
            var js:Boolean = false;
            try {
                var check:* = getDefinitionByName("flash.system.Capabilities");
            } catch (e:Error) {
                js = true;
            }

            Assert.assertTrue("Unexpected value following try/catch",(isJS ? (js === true) : (js === false)));
        }
    }
}
