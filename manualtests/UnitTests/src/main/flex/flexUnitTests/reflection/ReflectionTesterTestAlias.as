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
package flexUnitTests.reflection
{
    import flexunit.framework.Assert;
	import flexUnitTests.reflection.support.*;
    import org.apache.flex.reflection.*;
    
    public class ReflectionTesterTestAlias
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
            //appears to be optimized away in js-release mode
            //a separate test has been created for this
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
        public function testBasicAlias():void {
            //no initial alias
            Assert.assertNull(getAliasByClass(TestClass2));
            registerClassAlias("fjsTest", TestClass2);
            //alias is registered
            Assert.assertEquals("unexpected Alias value","fjsTest",getAliasByClass(TestClass2));
            //register same alias for another class
            registerClassAlias("fjsTest", TestClass3);
            //original alias mapping is deregistered
            Assert.assertNull(getAliasByClass(TestClass2));
            //alias is registered for new class
            Assert.assertEquals("unexpected Alias value","fjsTest",getAliasByClass(TestClass3));

            //class is retrievable by alias
            Assert.assertEquals("unexpected Class value",TestClass3,getClassByAlias("fjsTest"));


        }



    }
}
