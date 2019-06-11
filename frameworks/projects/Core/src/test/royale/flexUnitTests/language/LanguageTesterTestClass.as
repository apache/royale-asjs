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
    
    
    import org.apache.royale.test.asserts.*;
    
    import flexUnitTests.language.support.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestClass
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
            
            assertTrue( err,'Class constructor call should throw error');
    
        }
    
    
        [Test]
        public function testDistinctType():void
        {
            var classType:* = Class;
            assertFalse( classType == Object,'Class should be distinct from Object');
        }
    
    
        [Test]
        public function testNullishCoercions():void
        {
            var n:* = undefined;
            
            assertNull( Class(n),'Class coercion of undefined should return null');
            
            n = null;
    
            assertNull( Class(n),'Class  coercion of null should return null');
        }
        
        
        [Test]
        public function testNative():void
        {
           var n:* = Number;
           var nVal:* = 1;
           var c:Class; 
            
           assertTrue( Number is Class,'Number is Class should be true');
           assertTrue( n is Class,'Number is Class should be true');
    
           assertFalse( nVal is Class,'Number value is Class should be false');
    
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'Number is Class should be true');
            assertEquals( c, Number,'c should be Number');
            
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'Number is Class should be true');
            assertEquals( c, Number,'c should be Number');
    
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'Number value Class coercion should throw error');

            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'Number value Class coercion should throw error');
            
        }
    
    
        [Test]
        public function testNative2():void
        {
            var n:* = Array;
            var nVal:* = [];
            var c:Class;
        
            assertTrue( Array is Class,'Array is Class should be true');
            assertTrue( n is Class,'Array is Class should be true');
        
            assertFalse( nVal is Class,'Array value is Class should be false');
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'Array is Class should be true');
            assertEquals( c, Array,'c should be Array');
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'Array is Class should be true');
            assertEquals( c, Array,'c should be Array');
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'Array value Class coercion should throw error');
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'Array value Class coercion should throw error');
        
        }
    
        [Test]
        public function testJSSynthetic():void
        {
            var n:* = uint;
            var nVal:* = new n();
            var c:Class;
        
            assertTrue( uint is Class,'uint is Class should be true');
            assertTrue( n is Class,'uint is Class should be true');
        
            assertFalse( nVal is Class,'uint val is Class should be false ');
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'uint Class coercion should succeed');
            assertEquals( c, uint,'c should be uint');
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'uint Class coercion should succeed');
            assertEquals( c, uint,'c should be uint');
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'uint value Class coercion should throw error');
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'uint value Class coercion should throw error');
        }
    
    
        [Test]
        public function testRoyaleClass():void
        {
            var n:* = TestClass1;
            var nVal:* = new TestClass1();
            var c:Class;
        
            assertTrue( TestClass1 is Class,'TestClass1 is Class should be true');
            assertTrue( n is Class,'TestClass1 is Class should be true');
        
            assertFalse( nVal is Class,'TestClass1 val is Class should be false ');
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'TestClass1 Class coercion should succeed');
            assertEquals( c, TestClass1,'c should be TestClass1');
        
            err = false;
            c = Class;
            try {
                c = c(n)
            } catch(e:Error) {
                err = true;
            }
            assertFalse( err,'TestClass1 Class coercion should succeed');
            assertEquals( c, TestClass1,'c should be TestClass1');
        
            err = false;
            try {
                c = Class(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'TestClass1 value Class coercion should throw error');
        
            err = false;
            c = Class;
            try {
                c = c(nVal)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'TestClass1 value Class coercion should throw error');
        }
    
    
        [Test]
        public function testRoyaleInterface():void
        {
            var n:* = ITestInterface;
            var c:Class;
            //strange, perhaps, but true:
            assertTrue( n is Class,'ITestInterface is Class should be true');
            
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            //ditto:
            assertFalse( err,'ITestInterface Class coercion should not throw error');
        }
    
    
        [Test]
        public function testFunction():void
        {
            var n:* = testRoyaleInterface;
            var c:Class;
            assertFalse( n is Class,'method (function) is Class should be false');
        
            var err:Boolean = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }

            assertTrue( err,'method (function) Class coercion should throw error');
            
            //local function
            n = function():void{};
            assertFalse( n is Class,'local function is Class should be false');
    
            err = false;
            try {
                c = Class(n)
            } catch(e:Error) {
                err = true;
            }
            assertTrue( err,'local function Class coercion should throw error');
        }
        
    }
}
