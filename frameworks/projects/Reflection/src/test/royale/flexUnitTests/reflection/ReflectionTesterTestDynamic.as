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
    public class ReflectionTesterTestDynamic
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
        
        private static function contentStringsMatch(arr1:Array, arr2:Array):Boolean
        {
            if (arr1 == arr2) return true;
            if (!arr1 || !arr2) return false;
            if (arr1.length != arr2.length) return false;
            const arr1Copy:Array = arr1.concat();
            var l:uint = arr1Copy.length;
            while (l--)
            {
                var s:String = arr1Copy.shift();
                if (arr2.indexOf(s) == -1) return false
            }
            return true;
        }
        
        
        [Test]
        public function testisDynamic():void
        {
            //class
            
            assertTrue( isDynamicObject(Object), "class should be dynamic");
            
            assertTrue( isDynamicObject(TestClass1), "class should be dynamic");
            //interface is dynamic (even if it doesn't make much sense)
            assertTrue( isDynamicObject(ITestInterface), "interface should be dynamic");
            //instance
            assertTrue( isDynamicObject({}), "generic object should be dynamic");
            
            assertFalse( isDynamicObject(new TestClass1()), "sealed class instance should not be dynamic");
            
            assertTrue( isDynamicObject(new DynamicTestClass()), "dynamic class instance should be dynamic");
            
            
            assertFalse( isDynamicObject("String"), "String instance should not be dynamic");
            assertFalse( isDynamicObject(99), "int instance should not be dynamic");
            assertFalse( isDynamicObject(99.99), "Number instance should not be dynamic");
            assertFalse( isDynamicObject(true), "Boolean instance should not be dynamic");
            
            
            assertTrue( isDynamicObject(function ():void
            {
            }), "function instance should be dynamic");
            assertTrue( isDynamicObject([]), "Array instance should be dynamic");
        }
        
        
        [TestVariance(variance="JS", description="Variance in test due to reliance on 'js-default-initializers=true' throughout entire inheritance chain for 'getDynamicFields' function")]
        [Test]
        public function testGetDynamicFields():void
        {
            
            const emptyArray:Array = [];
            const singleDynField:Array = ['test'];
            assertTrue( contentStringsMatch(getDynamicFields(Object), emptyArray), "dynamic fields should match reference list");
            Object['test'] = true;
            assertTrue( contentStringsMatch(getDynamicFields(Object), singleDynField), "dynamic fields should match reference list");
            delete Object['test'];
            
            assertTrue( contentStringsMatch(getDynamicFields(TestClass1), emptyArray), "dynamic fields should match reference list");
            TestClass1['test'] = true;
            assertTrue( contentStringsMatch(getDynamicFields(TestClass1), singleDynField), "dynamic fields should match reference list");
            delete TestClass1['test'];
            
            //interface is dynamic (even if it doesn't make much sense)
            assertTrue( contentStringsMatch(getDynamicFields(ITestInterface), emptyArray), "dynamic fields should match reference list");
            ITestInterface['test'] = true;
            assertTrue( contentStringsMatch(getDynamicFields(ITestInterface), singleDynField), "dynamic fields should match reference list");
            delete ITestInterface['test'];
            
            //instance
            assertTrue( contentStringsMatch(getDynamicFields({}), emptyArray), "dynamic fields should match reference list");
            assertTrue( contentStringsMatch(getDynamicFields({test: true}), singleDynField), "dynamic fields should match reference list");
            
            assertTrue( contentStringsMatch(getDynamicFields(new TestClass1()), emptyArray), "dynamic fields should match reference list");
            
            const dynInstance:DynamicTestClass = new DynamicTestClass();
            dynInstance.test = true;
            assertTrue( contentStringsMatch(getDynamicFields(dynInstance), singleDynField), "dynamic fields should match reference list");
            
            
            assertTrue( contentStringsMatch(getDynamicFields("String"), emptyArray), "dynamic fields should match reference list");
            assertTrue( contentStringsMatch(getDynamicFields(99), emptyArray), "dynamic fields should match reference list");
            assertTrue( contentStringsMatch(getDynamicFields(99.99), emptyArray), "dynamic fields should match reference list");
            assertTrue( contentStringsMatch(getDynamicFields(true), emptyArray), "dynamic fields should match reference list");
            
            assertTrue( contentStringsMatch(getDynamicFields(function ():void
            {
            }), emptyArray), "dynamic fields should match reference list");
            
            const numericFields:Array = ["0", "1", "2", "3"];
            var arr:Array = [1, 2, 3, 4];
            assertTrue( contentStringsMatch(getDynamicFields(arr), numericFields), "dynamic fields should match reference list");
            numericFields.push('test');
            arr['test'] = true;
            assertTrue( contentStringsMatch(getDynamicFields(arr), numericFields), "dynamic fields should match reference list");
            
            
            var testclass2:DynamicTestClass2 = new DynamicTestClass2();
            testclass2.test = true;
            testclass2.something = '*something*';
            assertTrue( contentStringsMatch(getDynamicFields(testclass2), singleDynField), "dynamic fields should match reference list");
            
            
            testclass2.test = 'test';
            testclass2.something = '*something else*';
            
            assertTrue( contentStringsMatch(getDynamicFields(testclass2), singleDynField), "dynamic fields should match reference list");
            var testClass3:DynamicTestClass3 = new DynamicTestClass3();
            var swapAssertion:Boolean;
            COMPILE::JS{
                var check:Boolean = new CompilationData(testClass3).hasSameAncestry(CompilationData.WITH_DEFAULT_INITIALIZERS);
                if (!check)
                {
                    //variance... due framework ancestry having different compilation settings
                    swapAssertion = true;
                }
            }
            
            if (!swapAssertion)
            {
                assertTrue( contentStringsMatch(getDynamicFields(testClass3), emptyArray), "dynamic fields should match reference list");
            } else
            {
                assertFalse( contentStringsMatch(getDynamicFields(testClass3), emptyArray), "dynamic fields should match reference list");
                trace('[WARN] Variance: a test is technically wrong in javascript, but is expected to be wrong, because the compilation settings do not support it throughout the inheritance chain');
            }
            testClass3.test = 'true';
            testClass3.x = 10;
            testClass3.className = 'hello';
            
            
            if (!swapAssertion)
            {
                assertTrue( contentStringsMatch(getDynamicFields(testClass3), singleDynField), "dynamic fields should match reference list");
            } else
            {
                assertFalse( contentStringsMatch(getDynamicFields(testClass3), singleDynField), "dynamic fields should not match reference list");
                trace('[WARN] Variance: a test is technically wrong in javascript, but is expected to be wrong, because the compilation settings do not support it throughout the inheritance chain');
            }
            
        }
        
        [Test]
        public function testGetDynamicFieldsWithPredicate():void
        {
            const test:Object = {
                'test1': true,
                'test2': true,
                '_underscore': true
            };
            const withoutUnderscores:Array = ['test1', 'test2'];
            var excludeUnderscores:Function = function (prop:String):Boolean
            {
                return prop && prop.charAt(0) != '_';
            };
            assertTrue( contentStringsMatch(getDynamicFields(test, excludeUnderscores), withoutUnderscores), "dynamic fields should match reference list");
            
        }
        
    }
}
