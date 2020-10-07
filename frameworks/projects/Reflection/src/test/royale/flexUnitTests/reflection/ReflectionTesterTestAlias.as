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
    import org.apache.royale.test.asserts.*;
    
    import flexUnitTests.reflection.support.*;
    
    import org.apache.royale.reflection.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterTestAlias
    {
        
        public static var isJS:Boolean = COMPILE::JS;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            ExtraData.addAll()
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            ExtraData.reset();
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
        public function testBasicAlias():void
        {
            //no initial alias
            assertNull(getAliasByClass(TestClass2));
            registerClassAlias("fjsTest", TestClass2);
            //alias is registered
            assertEquals( "fjsTest", getAliasByClass(TestClass2), "unexpected Alias value");
            //register same alias for another class
            registerClassAlias("fjsTest", TestClass3);
            //original alias mapping is deregistered
            assertNull(getAliasByClass(TestClass2));
            //alias is registered for new class
            assertEquals( "fjsTest", getAliasByClass(TestClass3), "unexpected Alias value");
            
            //class is retrievable by alias
            assertEquals( TestClass3, getClassByAlias("fjsTest"), "unexpected Class value");
            
        }

        [Test]
        public function testNativeTypes():void
        {
            //no initial alias
            assertNull(getAliasByClass(String));
            registerClassAlias("myStringAlias", String);
            //alias is registered
            assertEquals( "myStringAlias", getAliasByClass(String), "unexpected Alias value");
            //register same alias for another class
            registerClassAlias("myStringAlias", TestClass3);
            //original alias mapping is deregistered
            assertNull(getAliasByClass(String));
            //alias is registered for new class
            assertEquals( "myStringAlias", getAliasByClass(TestClass3), "unexpected Alias value");

            //class is retrievable by alias
            assertEquals( TestClass3, getClassByAlias("myStringAlias"), "unexpected Class value");

        }
        
        
    }
}
