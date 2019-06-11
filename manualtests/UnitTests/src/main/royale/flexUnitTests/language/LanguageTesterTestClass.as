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
package flexUnitTests.language
{
    
    
    import flexunit.framework.Assert;
    
    import flexUnitTests.language.support.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestClass
    {
        
        public static var isJS:Boolean;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            var js:Boolean;
            COMPILE::JS {
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
        public function testNoConstruct():void
        {
            var c:Class = Class;
            var err:Boolean = false;
            try {
                var a:* = new c();
            } catch(e:Error) {
                err = true;
            }
            
            Assert.assertTrue('Class constructor call should throw error', err);
    
        }
    
    
        [Test]
        public function testDistinctType():void
        {
            var classType:* = Class;
            Assert.assertFalse('Class should be distinct from Object', classType == Object);
        }
    
    
        [Test]
        public function testNullishCoercions():void
        {
            var n:* = undefined;
            
            Assert.assertNull('Class coercion of undefined should return null', Class(n));
            
            n = null;
    
            Assert.assertNull('Class  coercion of null should return null', Class(n));
        }
        
        
        [Test]
        public function testNative():void
        {
           var n:* = Number;
           var nVal:* = 1;
           var c:Class; 
            
           Assert.assertTrue('Number is Class should be true', Number is Class);
           Assert.assertTrue('Number is Class should be true', n is Class);
    
           Assert.assertFalse('Number value is Class should be false', nVal is Class);
    
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('Number is Class should be true', err);
            Assert.assertEquals('c should be Number', c, Number);
            
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('Number is Class should be true', err);
            Assert.assertEquals('c should be Number', c, Number);
    
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('Number value Class coercion should throw error', err);

            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('Number value Class coercion should throw error', err);
            
        }
    
    
        [Test]
        public function testNative2():void
        {
            var n:* = Array;
            var nVal:* = [];
            var c:Class;
        
            Assert.assertTrue('Array is Class should be true', Array is Class);
            Assert.assertTrue('Array is Class should be true', n is Class);
        
            Assert.assertFalse('Array value is Class should be false', nVal is Class);
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('Array is Class should be true', err);
            Assert.assertEquals('c should be Array', c, Array);
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('Array is Class should be true', err);
            Assert.assertEquals('c should be Array', c, Array);
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('Array value Class coercion should throw error', err);
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('Array value Class coercion should throw error', err);
        
        }
    
        [Test]
        public function testJSSynthetic():void
        {
            var n:* = uint;
            var nVal:* = new n();
            var c:Class;
        
            Assert.assertTrue('uint is Class should be true', uint is Class);
            Assert.assertTrue('uint is Class should be true', n is Class);
        
            Assert.assertFalse('uint val is Class should be false ', nVal is Class);
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('uint Class coercion should succeed', err);
            Assert.assertEquals('c should be uint', c, uint);
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('uint Class coercion should succeed', err);
            Assert.assertEquals('c should be uint', c, uint);
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('uint value Class coercion should throw error', err);
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('uint value Class coercion should throw error', err);
        }
    
    
        [Test]
        public function testRoyaleClass():void
        {
            var n:* = TestClass1;
            var nVal:* = new TestClass1();
            var c:Class;
        
            Assert.assertTrue('TestClass1 is Class should be true', TestClass1 is Class);
            Assert.assertTrue('TestClass1 is Class should be true', n is Class);
        
            Assert.assertFalse('TestClass1 val is Class should be false ', nVal is Class);
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('TestClass1 Class coercion should succeed', err);
            Assert.assertEquals('c should be TestClass1', c, TestClass1);
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertFalse('TestClass1 Class coercion should succeed', err);
            Assert.assertEquals('c should be TestClass1', c, TestClass1);
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('TestClass1 value Class coercion should throw error', err);
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('TestClass1 value Class coercion should throw error', err);
        }
    
    
        [Test]
        public function testRoyaleInterface():void
        {
            var n:* = ITestInterface;
            var c:Class;
            //strange, perhaps, but true:
            Assert.assertTrue('ITestInterface is Class should be true', n is Class);
            
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            //ditto:
            Assert.assertFalse('ITestInterface Class coercion should not throw error', err);
        }
    
    
        [Test]
        public function testFunction():void
        {
            var n:* = testRoyaleInterface;
            var c:Class;
            Assert.assertFalse('method (function) is Class should be false', n is Class);
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }

            Assert.assertTrue('method (function) Class coercion should throw error', err);
            
            //local function
            n = function():void{};
            Assert.assertFalse('local function is Class should be false', n is Class);
    
            err = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            Assert.assertTrue('local function Class coercion should throw error', err);
        }
        
    }
}
