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
    public class LanguageTesterTestIs
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
        public function testIsOwnType():void
        {
            var test1:TestClass1 = new TestClass1();
            assertTrue(  test1 is TestClass1,'Unexpected instance is {Class} check');
        }
        
        [Test]
        public function testIsAncestorType():void
        {
            var test2:TestClass2 = new TestClass2();
            assertTrue(  test2 is TestClass1,'Unexpected instance is {AncestorClass} check');
        }
        
        [Test]
        public function testIsDistantAncestorType():void
        {
            var test4:TestClass4 = new TestClass4();
            assertTrue( test4 is TestClass1,'Unexpected instance is {DistantAncestorClass} check');
        }
        
        
        [Test]
        public function testIsImplementedInterface():void
        {
            var test1:TestClass1 = new TestClass1();
            assertTrue( test1 is ITestInterface,'Unexpected instance is {OwnInterface} check');
        }
        
        
        [Test]
        public function testIsAncestorInterface():void
        {
            var test2:TestClass2 = new TestClass2();
            assertTrue( test2 is ITestInterface,'Unexpected instance is {AncestorInterface} check');
        }
        
        [Test]
        public function testIsImplementedInterfaceAncestor():void
        {
            var test3:TestClass3 = new TestClass3();
            assertTrue( test3 is ITestInterface,'Unexpected instance is {InterfaceAncestor} check');
            
        }
        
        [Test]
        public function testIsImplementedInterfaceAncestor2():void
        {
            var test4:TestClass4 = new TestClass4();
            assertTrue( test4 is ITestInterface,'Unexpected instance is {InterfaceAncestor} check');
        }
        
        
        [Test]
        public function testNullCoercion():void
        {
            var val:Object = null;
            
            var s:String = String(val);
            assertEquals( s, 'null','Unexpected coercion check');
            var i:int = int(val);
            assertTrue( i === 0,'Unexpected coercion check');
            var u:uint = uint(val);
            assertTrue( u === 0,'Unexpected coercion check');
            var n:Number = Number(val);
            assertTrue( n === 0,'Unexpected coercion check');
            var b:Boolean = Boolean(val);
            assertTrue( b === false,'Unexpected coercion check');
            
            var t:TestClass1 = TestClass1(val);
            assertTrue( t === null,'Unexpected coercion check');
            
            //with indirection
            var c:Class = String;
            var result:* = c(val);
            assertTrue( result === 'null','Unexpected coercion check');
            c = int;
            result = c(val);
            assertTrue( result === 0,'Unexpected coercion check');
            c = uint;
            result = c(val);
            assertTrue( result === 0,'Unexpected coercion check');
            c = Number;
            result = c(val);
            assertTrue( result === 0,'Unexpected coercion check');
            
            c = Boolean;
            result = c(val);
            assertTrue( result === false,'Unexpected coercion check');
            
            c = TestClass1;
            result = c(val);
            assertTrue( result === null,'Unexpected coercion check');
        }
        
        [Test]
        public function testObjectCoercion():void
        {
            assertTrue( Object(undefined) != null,'Unexpected null check');
            assertTrue( Object(null) != null,'Unexpected null check');
            assertTrue( Object('test') === 'test','Unexpected null check');
            assertTrue( Object(1) === 1,'Unexpected null check');
            assertTrue( Object(false) === false,'Unexpected null check');
            assertTrue( Object(true) === true,'Unexpected null check');
            var indirection:* = undefined;
            assertTrue( Object(indirection) != null,'Unexpected null check');
            indirection = null;
            assertTrue( Object(indirection) != null,'Unexpected null check');
            indirection = 'test';
            assertTrue( Object(indirection) === 'test','Unexpected null check');
            indirection = 1;
            assertTrue( Object(indirection) === 1,'Unexpected null check');
            indirection = false;
            assertTrue( Object(indirection) === false,'Unexpected null check');
            indirection = true;
            assertTrue( Object(indirection) === true,'Unexpected null check');
            var dynObjectClass:Class = Object;
            //regular indirect coercion
            indirection = undefined;
            assertTrue( dynObjectClass(indirection) != null,'Unexpected null check');
            indirection = null;
            assertTrue( dynObjectClass(indirection) != null,'Unexpected null check');
            indirection = 'test';
            assertTrue( dynObjectClass(indirection) === 'test','Unexpected null check');
            indirection = 1;
            assertTrue( dynObjectClass(indirection) === 1,'Unexpected null check');
            indirection = false;
            assertTrue( dynObjectClass(indirection) === false,'Unexpected null check');
            indirection = true;
            assertTrue( dynObjectClass(indirection) === true,'Unexpected null check');
            //no need to test 'new Object(something)' as it is not permitted explicitly in actionscript
            //but it can be achieved via indirection:
            var dynObject:Class = Object;
            indirection = undefined;
            assertTrue( new dynObject(indirection) != null,'Unexpected null check');
            indirection = null;
            assertTrue( new dynObject(indirection) != null,'Unexpected null check');
            indirection = 'test';
            assertTrue( new dynObject(indirection) === 'test','Unexpected null check');
            indirection = 1;
            assertTrue( new dynObject(indirection) === 1,'Unexpected null check');
            indirection = false;
            assertTrue( new dynObject(indirection) === false,'Unexpected null check');
            indirection = true;
            assertTrue( new dynObject(indirection) === true,'Unexpected null check');
            
        }
        
        [Test]
        public function testImplicitCoercion():void
        {
            var testclass2Class:Class = TestClass2;
            var testClass3:TestClass3;
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                testClass3 = new testclass2Class();
            } catch (e:Error)
            {
                caughtError = e is TypeError
            }
            
            assertTrue( caughtError,'Unexpected coercion check');
            assertTrue( testClass3 == null,'Unexpected coercion check');
        }
    
    
        [Test]
        //[TestVariance(variance="JS",description="Variance in js implementation with @royalesuppresscompleximplicitcoercion, outcome can be wrong")]
        /**
         * @royalesuppresscompleximplicitcoercion true
         */
        public function testImplicitCoercionAvoided():void
        {
            var testclass2Class:Class = TestClass2;
            var testClass3:TestClass3;
            var something:* = new testclass2Class();
            var caughtError:Boolean;
            try
            {
                caughtError = false;
                testClass3 = something;
            } catch (e:Error)
            {
                caughtError = e is TypeError
            }
        
            if (isJS) {
                assertFalse( caughtError, 'Unexpected coercion check');
                assertFalse(testClass3 == null, 'Unexpected coercion check');
            } else {
                assertTrue(caughtError, 'Unexpected coercion check');
                assertTrue(testClass3 == null, 'Unexpected coercion check');
            }
        
        }
        
        [Test]
        public function testNullUndefined():void
        {
            assertTrue( null == null,'Unexpected null check');
            assertTrue( null == undefined,'Unexpected null check');
            assertTrue( null === null,'Unexpected null check');
            assertTrue( undefined === undefined,'Unexpected undefined check');
            assertFalse( undefined === null,'Unexpected null/undefined check');
        }
        
        [Test]
        public function testString():void
        {
            assertTrue( String('test') == 'test','Unexpected string check');
            assertTrue( String('test') === 'test','Unexpected string check');
            assertTrue( new String('test') == 'test','Unexpected string check');
            assertTrue( new String('test') === 'test','Unexpected string check');
        }
        
        
    }
}
