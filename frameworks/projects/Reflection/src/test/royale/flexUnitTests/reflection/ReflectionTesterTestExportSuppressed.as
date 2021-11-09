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



    COMPILE::JS{
        import goog.DEBUG;
    }


    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterTestExportSuppressed
    {
        
        public static var isJS:Boolean;
        public static var isJSRelease:Boolean;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {

            isJS = COMPILE::JS;

            COMPILE::JS{
                isJSRelease = !goog.DEBUG;
            }

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
        public function testControlFunction():void
        {
            var f:Function = testFunction;
            var qName:String = f();
            // this should also work in release mode, because the function is exported
            var check:Function = getDefinitionByName(qName) as Function;

            assertStrictlyEquals(check, f, 'unexpected result in reflective function access')
            
        }

        [Test]
        public function testSuppressedFunction():void
        {
            var f:Function = testFunctionExportSuppressed;
            var qName:String = f();

            try{
                //this should work in all cases except js-release build
                var check:Function = getDefinitionByName(qName) as Function;
            } catch(e:Error) {
                //in js-release build the function is not accessible by its qName, so an error is thrown
                check = null;
            }

            if (!isJSRelease) {
                assertStrictlyEquals(check, f, 'unexpected result in suppressed reflective function access')
            } else {
                assertNull(check, 'unexpected result in suppressed reflective function access')
            }
        }

        [Test]
        public function testFullySuppressedClass():void
        {
            var c:Class = TestClassExportSuppressed1;
            var expected:String = TestClassExportSuppressed1.CLASSNAME;
            var qName:String = getQualifiedClassName(c);

            if (isJS) {
                //there will be no valid qualified name, it will return as 'Function'
                assertEquals(qName,'Function', 'unexpected result in suppressed reflective qName access')
            } else {
                assertEquals(qName, expected, 'unexpected result in suppressed reflective qName access')
            }

        }

        [Test]
        public function testPartiallySuppressedClass():void
        {
            var c:Class = TestClassExportSuppressed2;
            var expected:String = TestClassExportSuppressed2.CLASSNAME;
            var qName:String = getQualifiedClassName(c);
            assertEquals(qName, expected, 'unexpected result in suppressed reflective qName access')

            var def:TypeDefinition = describeType(c);

            //RoyaleUnitTestRunner.consoleOut(def.toString(true));
            if (isJS) {
                assertEquals(def.variables.length, 1, 'unexpected JS reflection data (instance vars)');
                assertEquals(def.accessors.length, 1, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.methods.length, 1, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.staticVariables.length, 1, 'unexpected JS reflection data (instance vars)');
                assertEquals(def.staticAccessors.length, 1, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.staticMethods.length, 1, 'unexpected JS reflection data (instance accessors)');

            } else {
                assertEquals(def.variables.length, 2, 'unexpected JS reflection data (instance vars)');
                assertEquals(def.accessors.length, 2, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.methods.length, 2, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.staticVariables.length, 2, 'unexpected JS reflection data (instance vars)');
                //note 'prototype' is included here, hence 3 instead of 2:
                assertEquals(def.staticAccessors.length, 3, 'unexpected JS reflection data (instance accessors)');
                assertEquals(def.staticMethods.length, 2, 'unexpected JS reflection data (instance accessors)');
            }
        }

    }
}
