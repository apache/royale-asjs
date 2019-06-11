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
    public class LanguageTesterTestIs
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
        public function testIsOwnType():void
        {
            var test1:TestClass1 = new TestClass1();
            Assert.assertTrue('Unexpected instance is {Class} check', test1 is TestClass1)
        }
        
        [Test]
        public function testIsAncestorType():void
        {
            var test2:TestClass2 = new TestClass2();
            Assert.assertTrue('Unexpected instance is {AncestorClass} check', test2 is TestClass1)
        }
        
        [Test]
        public function testIsDistantAncestorType():void
        {
            var test4:TestClass4 = new TestClass4();
            Assert.assertTrue('Unexpected instance is {DistantAncestorClass} check', test4 is TestClass1)
        }
        
        
        [Test]
        public function testIsImplementedInterface():void
        {
            var test1:TestClass1 = new TestClass1();
            Assert.assertTrue('Unexpected instance is {OwnInterface} check', test1 is ITestInterface)
        }
        
        
        [Test]
        public function testIsAncestorInterface():void
        {
            var test2:TestClass2 = new TestClass2();
            Assert.assertTrue('Unexpected instance is {AncestorInterface} check', test2 is ITestInterface)
        }
        
        [Test]
        public function testIsImplementedInterfaceAncestor():void
        {
            var test3:TestClass3 = new TestClass3();
            Assert.assertTrue('Unexpected instance is {InterfaceAncestor} check', test3 is ITestInterface)
            
        }
        
        [Test]
        public function testIsImplementedInterfaceAncestor2():void
        {
            var test4:TestClass4 = new TestClass4();
            Assert.assertTrue('Unexpected instance is {InterfaceAncestor} check', test4 is ITestInterface)
        }
        
        
        [Test]
        public function testNullCoercion():void
        {
            var val:Object = null;
            
            var s:String = String(val);
            Assert.assertEquals('Unexpected coercion check', s, 'null');
            var i:int = int(val);
            Assert.assertTrue('Unexpected coercion check', i === 0);
            var u:uint = uint(val);
            Assert.assertTrue('Unexpected coercion check', u === 0);
            var n:Number = Number(val);
            Assert.assertTrue('Unexpected coercion check', n === 0);
            var b:Boolean = Boolean(val);
            Assert.assertTrue('Unexpected coercion check', b === false);
            
            var t:TestClass1 = TestClass1(val);
            Assert.assertTrue('Unexpected coercion check', t === null);
            
            //with indirection
            var c:Class = String;
            var result:* = c(val);
            Assert.assertTrue('Unexpected coercion check', result === 'null');
            c = int;
            result = c(val);
            Assert.assertTrue('Unexpected coercion check', result === 0);
            c = uint;
            result = c(val);
            Assert.assertTrue('Unexpected coercion check', result === 0);
            c = Number;
            result = c(val);
            Assert.assertTrue('Unexpected coercion check', result === 0);
            
            c = Boolean;
            result = c(val);
            Assert.assertTrue('Unexpected coercion check', result === false);
            
            c = TestClass1;
            result = c(val);
            Assert.assertTrue('Unexpected coercion check', result === null);
        }
        
        [Test]
        public function testObjectCoercion():void
        {
            Assert.assertTrue('Unexpected null check', Object(undefined) != null);
            Assert.assertTrue('Unexpected null check', Object(null) != null);
            Assert.assertTrue('Unexpected null check', Object('test') === 'test');
            Assert.assertTrue('Unexpected null check', Object(1) === 1);
            Assert.assertTrue('Unexpected null check', Object(false) === false);
            Assert.assertTrue('Unexpected null check', Object(true) === true);
            var indirection:* = undefined;
            Assert.assertTrue('Unexpected null check', Object(indirection) != null);
            indirection = null;
            Assert.assertTrue('Unexpected null check', Object(indirection) != null);
            indirection = 'test';
            Assert.assertTrue('Unexpected null check', Object(indirection) === 'test');
            indirection = 1;
            Assert.assertTrue('Unexpected null check', Object(indirection) === 1);
            indirection = false;
            Assert.assertTrue('Unexpected null check', Object(indirection) === false);
            indirection = true;
            Assert.assertTrue('Unexpected null check', Object(indirection) === true);
            var dynObjectClass:Class = Object;
            //regular indirect coercion
            indirection = undefined;
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) != null);
            indirection = null;
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) != null);
            indirection = 'test';
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) === 'test');
            indirection = 1;
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) === 1);
            indirection = false;
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) === false);
            indirection = true;
            Assert.assertTrue('Unexpected null check', dynObjectClass(indirection) === true);
            //no need to test 'new Object(something)' as it is not permitted explicitly in actionscript
            //but it can be achieved via indirection:
            var dynObject:Class = Object;
            indirection = undefined;
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) != null);
            indirection = null;
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) != null);
            indirection = 'test';
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) === 'test');
            indirection = 1;
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) === 1);
            indirection = false;
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) === false);
            indirection = true;
            Assert.assertTrue('Unexpected null check', new dynObject(indirection) === true);
            
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
            
            Assert.assertTrue('Unexpected coercion check', caughtError);
            Assert.assertTrue('Unexpected coercion check', testClass3 == null);
        }
        
        [Test]
        public function testNullUndefined():void
        {
            Assert.assertTrue('Unexpected null check', null == null);
            Assert.assertTrue('Unexpected null check', null == undefined);
            Assert.assertTrue('Unexpected null check', null === null);
            Assert.assertTrue('Unexpected undefined check', undefined === undefined);
            Assert.assertFalse('Unexpected null/undefined check', undefined === null);
        }
        
        [Test]
        public function testString():void
        {
            Assert.assertTrue('Unexpected string check', String('test') == 'test');
            Assert.assertTrue('Unexpected string check', String('test') === 'test');
            Assert.assertTrue('Unexpected string check', new String('test') == 'test');
            Assert.assertTrue('Unexpected string check', new String('test') === 'test');
        }
        
        
    }
}
