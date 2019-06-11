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
    
    import org.apache.royale.reflection.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterTestDynamic
    {
        
        public static var isJS:Boolean;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            var js:Boolean;
            COMPILE::JS{
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
            
            Assert.assertTrue("class should be dynamic", isDynamicObject(Object));
            
            Assert.assertTrue("class should be dynamic", isDynamicObject(TestClass1));
            //interface is dynamic (even if it doesn't make much sense)
            Assert.assertTrue("interface should be dynamic", true, isDynamicObject(ITestInterface));
            //instance
            Assert.assertTrue("generic object should be dynamic", isDynamicObject({}));
            
            Assert.assertFalse("sealed class instance should not be dynamic", isDynamicObject(new TestClass1()));
            
            Assert.assertTrue("dynamic class instance should be dynamic", isDynamicObject(new DynamicTestClass()));
            
            
            Assert.assertFalse("String instance should not be dynamic", isDynamicObject("String"));
            Assert.assertFalse("int instance should not be dynamic", isDynamicObject(99));
            Assert.assertFalse("Number instance should not be dynamic", isDynamicObject(99.99));
            Assert.assertFalse("Boolean instance should not be dynamic", isDynamicObject(true));
            
            
            Assert.assertTrue("function instance should be dynamic", isDynamicObject(function ():void
            {
            }));
            Assert.assertTrue("Array instance should be dynamic", isDynamicObject([]));
        }
        
        
        [TestVariance(variance="JS", description="Variance in test due to reliance on 'js-default-initializers=true' throughout entire inheritance chain for 'getDynamicFields' function")]
        [Test]
        public function testGetDynamicFields():void
        {
            
            const emptyArray:Array = [];
            const singleDynField:Array = ['test'];
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(Object), emptyArray));
            Object['test'] = true;
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(Object), singleDynField));
            delete Object['test'];
            
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(TestClass1), emptyArray));
            TestClass1['test'] = true;
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(TestClass1), singleDynField));
            delete TestClass1['test'];
            
            //interface is dynamic (even if it doesn't make much sense)
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(ITestInterface), emptyArray));
            ITestInterface['test'] = true;
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(ITestInterface), singleDynField));
            delete ITestInterface['test'];
            
            //instance
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields({}), emptyArray));
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields({test: true}), singleDynField));
            
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(new TestClass1()), emptyArray));
            
            const dynInstance:DynamicTestClass = new DynamicTestClass();
            dynInstance.test = true;
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(dynInstance), singleDynField));
            
            
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields("String"), emptyArray));
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(99), emptyArray));
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(99.99), emptyArray));
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(true), emptyArray));
            
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(function ():void
            {
            }), emptyArray));
            
            const numericFields:Array = ["0", "1", "2", "3"];
            var arr:Array = [1, 2, 3, 4];
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(arr), numericFields));
            numericFields.push('test');
            arr['test'] = true;
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(arr), numericFields));
            
            
            var testclass2:DynamicTestClass2 = new DynamicTestClass2();
            testclass2.test = true;
            testclass2.something = '*something*';
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(testclass2), singleDynField));
            
            
            testclass2.test = 'test';
            testclass2.something = '*something else*';
            
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(testclass2), singleDynField));
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
                Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(testClass3), emptyArray));
            } else
            {
                Assert.assertFalse("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(testClass3), emptyArray));
                trace('[WARN] Variance: a test is technically wrong in javascript, but is expected to be wrong, because the compilation settings do not support it throughout the inheritance chain');
            }
            testClass3.test = 'true';
            testClass3.x = 10;
            testClass3.className = 'hello';
            
            
            if (!swapAssertion)
            {
                Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(testClass3), singleDynField));
            } else
            {
                Assert.assertFalse("dynamic fields should not match reference list", contentStringsMatch(getDynamicFields(testClass3), singleDynField));
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
            Assert.assertTrue("dynamic fields should match reference list", contentStringsMatch(getDynamicFields(test, excludeUnderscores), withoutUnderscores));
            
        }
        
    }
}
