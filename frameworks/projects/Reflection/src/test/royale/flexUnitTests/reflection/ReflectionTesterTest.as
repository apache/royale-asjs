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
    public class ReflectionTesterTest
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
            TestClass2.testStaticVar = "testStaticVar_val";
            TestClass2.testStaticWriteOnly = "staticAccessor_initial_value";
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        private static function retrieveItemWithName(collection:Array, name:String):DefinitionBase
        {
            var ret:DefinitionBase;
            var i:uint = 0, l:uint = collection.length;
            for (; i < l; i++)
            {
                if (collection[i].name == name)
                {
                    ret = collection[i];
                    break;
                }
            }
            
            return ret;
        }
        
        
        [Test]
        public function testBasicDescribeTypeClass():void
        {
            var def:TypeDefinition = describeType(TestClass2);

            
            assertEquals( def.packageName, "flexUnitTests.reflection.support", "Unexpected package name");
            assertEquals( def.name, "TestClass2", "Unexpected type name");
            
            var variables:Array = def.variables;
            assertEquals( 1, variables.length, "unexpected variables length");
            
            
            var methods:Array = def.methods;
            assertEquals( 2, methods.length, "unexpected methods length");
            
            var accessors:Array = def.accessors;
            assertEquals( 3, accessors.length, "unexpected accessors length");
            
            var constructor:MethodDefinition = def.constructorMethod;
            assertEquals( constructor.declaredBy.qualifiedName,
                    "flexUnitTests.reflection.support.TestClass2", "unexpected constructor declaredBy");
            
            assertEquals(
                    1,
                    constructor.parameters.length, "unexpected constructor params");
            
            var meta:Array = def.retrieveMetaDataByName("TestMeta");
            assertEquals(
                    1,
                    meta.length, "unexpected class specific meta length");
            
            
            def = describeType(TestClass4);
            assertEquals( def.packageName, "flexUnitTests.reflection.support", "Unexpected package name");
            assertEquals( def.name, "TestClass4", "Unexpected type name");
            
            variables = def.variables;
            assertEquals( 2, variables.length, "unexpected variables length");
            
            
            methods = def.methods;
            assertEquals( 4, methods.length, "unexpected methods length");
            
            accessors = def.accessors;
            assertEquals( 6, accessors.length, "unexpected accessors length");
            
            constructor = def.constructorMethod;
            assertEquals(
                    "flexUnitTests.reflection.support.TestClass4",
                    constructor.declaredBy.qualifiedName, "unexpected constructor declaredBy");

            assertEquals(
                    0,
                    constructor.parameters.length, "unexpected constructor params");
            //TestClass3 extends TestClass1
            def =  describeType(TestClass3);
            //TestClass3 has no explicit constructor defined, it should still be represented and has no parameters
            constructor = def.constructorMethod;

            assertEquals(
                    "flexUnitTests.reflection.support.TestClass3",
                    constructor.declaredBy.qualifiedName, "unexpected constructor declaredBy");

            assertEquals(
                    0,
                    constructor.parameters.length, "unexpected constructor params");

            def =  describeType(TestClass1);

            constructor = def.constructorMethod;

            assertEquals(
                    "flexUnitTests.reflection.support.TestClass1",
                    constructor.declaredBy.qualifiedName, "unexpected constructor declaredBy");


            //there is one optional parameter in the base class
            assertEquals(
                    1,
                    constructor.parameters.length, "unexpected constructor params");
            
            
        }

        
        [TestVariance(variance="JS", description="Variance in test due to current inability for js target to reflect into non-Royale base classes or typedefs")]
        [Test]
        public function testDescribeTypeClass():void
        {
            var def:TypeDefinition = describeType(TestClass1);
            var expected:*;
            assertEquals( "flexUnitTests.reflection.support", def.packageName, "Unexpected package name");
            assertEquals( def.name, "TestClass1", "Unexpected type name");
            
            var variables:Array = def.variables;
            assertEquals( 3, variables.length, "unexpected instance variables length");
            
            //there is a difference based on the EventDispatcher inheritance chain differences between js and swf:
            expected = isJS ? 5 : 7;
            var methods:Array = def.methods;
            assertEquals( expected, methods.length, "unexpected instance methods length");
            
            var accessors:Array = def.accessors;
            assertEquals( 4, accessors.length, "unexpected instance accessors length");
            
            var staticVariables:Array = def.staticVariables;
            assertEquals( 2, staticVariables.length, "unexpected static variables length");
            
            var staticMethods:Array = def.staticMethods;
            assertEquals( 1, staticMethods.length, "unexpected static methods length");
            //there is a difference based on the native inheritance of readonly 'prototype' not collected from 'Class' (or Object for js):
            expected = isJS ? 3 : 4;
            var staticAccessors:Array = def.staticAccessors;
            assertEquals( expected, staticAccessors.length, "unexpected static accessors length");
            
            
        }
        
        [TestVariance(variance="JS", description="Variance in test due to current inability for js target to reflect into non-Royale base classes or typedefs")]
        [Test]
        public function testDescribeTypeInstance():void
        {
            var def:TypeDefinition = describeType(new TestClass1());
            var expected:*;
            assertEquals( "flexUnitTests.reflection.support", def.packageName, "Unexpected package name");
            assertEquals( def.name, "TestClass1", "Unexpected type name");
            
            var variables:Array = def.variables;
            assertEquals( 3, variables.length, "unexpected instance variables length");
            
            //there is a difference based on the EventDispatcher inheritance chain differences between js and swf:
            expected = isJS ? 5 : 7;
            var methods:Array = def.methods;
            assertEquals( expected, methods.length, "unexpected instance methods length");
            
            var accessors:Array = def.accessors;
            assertEquals( 4, accessors.length, "unexpected instance accessors length");
            
            var staticVariables:Array = def.staticVariables;
            assertEquals( 2, staticVariables.length, "unexpected static variables length");
            
            var staticMethods:Array = def.staticMethods;
            assertEquals( 1, staticMethods.length, "unexpected static methods length");
            //there is a difference based on the native inheritance of readonly 'prototype' not collected from 'Class' (or Object for js):
            expected = isJS ? 3 : 4;
            var staticAccessors:Array = def.staticAccessors;
            assertEquals( expected, staticAccessors.length, "unexpected static accessors length");
            
            
        }
        
        [TestVariance(variance="JS", description="Variance in baseClasses due to current inability for js target to reflect into non-Royale base classes or typedefs")]
        [Test]
        public function testBaseClasses():void
        {
            var def:TypeDefinition = describeType(TestClass1);
            
            var baseClasses:Array = def.baseClasses;
            var expected:uint = isJS ? 1 : 3;
            assertEquals( expected, baseClasses.length, "unexpected baseclasses length");
        }
        
        
        [Test]
        public function testMemberAccess():void
        {
            //all of these should succeed without error
            var inst:TestClass2 = new TestClass2("");
            var def:TypeDefinition = describeType(inst);
            
            /** instance variables **/
            
            var variables:Array = def.variables;
            var variable:VariableDefinition = variables[0];
            assertEquals( "testVar", variable.name, "unexpected variable name");
            var meta:MetaDataDefinition = variable.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            var metaArg:MetaDataArgDefinition = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "instanceVariable", metaArg.value, "unexpected meta arg value");
            
            //       assertEquals("testVar_val",inst[variable.name], "unexpected reflection initial variable value");
            assertEquals( "testVar_val", variable.getValue(inst), "unexpected reflection initial variable value");
            variable.setValue(inst, "testVar_val_reflection_set");
            assertEquals( "testVar_val_reflection_set", variable.getValue(inst), "unexpected reflection initial variable value");
            inst.testVar = "testVar_val";
            
            var accessors:Array = def.accessors;
            var testReadOnly:AccessorDefinition = retrieveItemWithName(accessors, "testReadOnly") as AccessorDefinition;
            meta = testReadOnly.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            metaArg = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "instanceAccessor", metaArg.value, "unexpected meta arg value");
            
            /** instance accessors **/
            var testWriteOnly:AccessorDefinition = retrieveItemWithName(accessors, "testWriteOnly") as AccessorDefinition;
            var testReadWrite:AccessorDefinition = retrieveItemWithName(accessors, "testReadWrite") as AccessorDefinition;
            assertNotNull(testReadOnly);
            assertNotNull(testWriteOnly);
            assertNotNull(testReadWrite);
            
            assertEquals( "instanceAccessor_initial_value", inst[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "instanceAccessor_initial_value", inst[testReadWrite.name], "unexpected accessor initial value");
            
            inst[testWriteOnly.name] = "test";
            assertEquals( "test", inst[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "test", inst[testReadWrite.name], "unexpected accessor initial value");
            
            inst[testReadWrite.name] = "test2";
            assertEquals( "test2", inst[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "test2", inst[testReadWrite.name], "unexpected accessor initial value");
            
            /** instance methods **/
            var methods:Array = def.methods;
            var testMethod:MethodDefinition = retrieveItemWithName(methods, "testMethod") as MethodDefinition;
            meta = testMethod.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            metaArg = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "instanceMethod", metaArg.value, "unexpected meta arg value");
            assertEquals( 0, testMethod.parameters.length, "unexpected parameter count");
            inst[testMethod.name]();
            assertEquals( "testMethod was called", inst[testReadWrite.name], "unexpected method invocation result");
            
            var testMethodWithArgs:MethodDefinition = retrieveItemWithName(methods, "testMethodWithArgs") as MethodDefinition;
            assertEquals( 2, testMethodWithArgs.parameters.length, "unexpected parameter count");
            assertTrue( inst[testMethodWithArgs.name]("test"), "unexpected method invocation result");
            assertFalse( inst[testMethodWithArgs.name]("test", false), "unexpected method invocation result");
            assertEquals( "testMethodWithArgs was called", inst[testReadWrite.name], "unexpected method invocation result");
            
            
            /** static vars **/
            variables = def.staticVariables;
            
            
            variable = variables[0];
            assertEquals( "testStaticVar", variable.name, "unexpected variable name");
            meta = variable.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            metaArg = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "staticVariable", metaArg.value, "unexpected meta arg value");
            
            // assertEquals("testStaticVar_val",TestClass2[variable.name], "unexpected reflection initial variable value");
            assertEquals( "testStaticVar_val", variable.getValue(), "unexpected reflection initial variable value");
            variable.setValue("testStaticVar_val_reflection_set");
            assertEquals( "testStaticVar_val_reflection_set", variable.getValue(), "unexpected reflection initial variable value");
            TestClass2.testStaticVar = "testStaticVar_val";
            
            
            /** static accessors **/
            
            accessors = def.staticAccessors;
            
            
            testReadOnly = retrieveItemWithName(accessors, "testStaticReadOnly") as AccessorDefinition;
            meta = testReadOnly.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            metaArg = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "staticAccessor", metaArg.value, "unexpected meta arg value");
            
            
            testWriteOnly = retrieveItemWithName(accessors, "testStaticWriteOnly") as AccessorDefinition;
            testReadWrite = retrieveItemWithName(accessors, "testStaticReadWrite") as AccessorDefinition;
            assertNotNull(testReadOnly);
            assertNotNull(testWriteOnly);
            assertNotNull(testReadWrite);
            
            assertEquals( "staticAccessor_initial_value", TestClass2[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "staticAccessor_initial_value", TestClass2[testReadWrite.name], "unexpected accessor initial value");
            
            TestClass2[testWriteOnly.name] = "test";
            assertEquals( "test", TestClass2[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "test", TestClass2[testReadWrite.name], "unexpected accessor initial value");
            
            TestClass2[testReadWrite.name] = "test2";
            assertEquals( "test2", TestClass2[testReadOnly.name], "unexpected accessor initial value");
            assertEquals( "test2", TestClass2[testReadWrite.name], "unexpected accessor initial value");
            
            
            /** static methods **/
            methods = def.staticMethods;
            testMethod = retrieveItemWithName(methods, "testStaticMethod") as MethodDefinition;
            meta = testMethod.retrieveMetaDataByName("TestMeta")[0];
            assertEquals( "TestMeta", meta.name, "unexpected meta name");
            
            metaArg = meta.getArgsByKey("foo")[0];
            assertEquals( "foo", metaArg.name, "unexpected meta arg name");
            assertEquals( "staticMethod", metaArg.value, "unexpected meta arg value");
            assertEquals( 0, testMethod.parameters.length, "unexpected parameter count");
            TestClass2[testMethod.name]();
            assertEquals( "testStaticMethod was called", TestClass2[testReadWrite.name], "unexpected method invocation result");
            
            testMethodWithArgs = retrieveItemWithName(methods, "testStaticMethodWithArgs") as MethodDefinition;
            assertEquals( 2, testMethodWithArgs.parameters.length, "unexpected parameter count");
            assertTrue( TestClass2[testMethodWithArgs.name]("test"), "unexpected method invocation result");
            assertFalse( TestClass2[testMethodWithArgs.name]("test", false), "unexpected method invocation result");
            assertEquals( "testStaticMethodWithArgs was called", TestClass2[testReadWrite.name], "unexpected method invocation result");
            
        }
        
        
        [Test]
        public function testInterfaceReflection():void
        {
            var def:TypeDefinition = describeType(ITestInterface4);
            assertEquals( "interface", def.kind, "unexpected kind value");
            assertEquals( 3, def.interfaces.length, "unexpected interfaces length");
            assertEquals( 1, def.accessors.length, "unexpected accessors length");
            assertEquals( 1, def.methods.length, "unexpected methods length");
            
            assertEquals( 0, def.variables.length, "unexpected variables length");
            assertEquals( 0, def.staticVariables.length, "unexpected staticVariables length");
            assertEquals( 0, def.staticMethods.length, "unexpected variables length");
            assertEquals( 0, def.staticAccessors.length, "unexpected staticVariables length");
            assertNull( def.constructorMethod, "unexpected constructor Method definition");
        }
        
        
    }
}
