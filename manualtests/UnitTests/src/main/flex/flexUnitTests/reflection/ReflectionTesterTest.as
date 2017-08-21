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
    
    public class ReflectionTesterTest
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
            TestClass2.testStaticVar = "testStaticVar_val";
            TestClass2.testStaticWriteOnly = "staticAccessor_initial_value";
        }
        
        [After]
        public function tearDown():void
        {
        }

        private static function retrieveItemWithName(collection:Array, name:String):DefinitionBase {
            var ret:DefinitionBase;
            var i:uint=0,l:uint=collection.length;
            for (;i<l;i++) {
                if (collection[i].name==name) {
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

            Assert.assertEquals("Unexpected package name",def.packageName,"flexUnitTests.reflection.support");
            Assert.assertEquals("Unexpected type name",def.name,"TestClass2");

            var variables:Array = def.variables;
            Assert.assertEquals("unexpected variables length",1,variables.length);


            var methods:Array = def.methods;
            Assert.assertEquals("unexpected methods length",2,methods.length);

            var accessors:Array = def.accessors;
            Assert.assertEquals("unexpected accessors length",3,accessors.length);

            var constructor:MethodDefinition = def.constructorMethod;
            Assert.assertEquals("unexpected constructor declaredBy",
                    "flexUnitTests.reflection.support.TestClass2",
                    constructor.declaredBy.qualifiedName);

            Assert.assertEquals("unexpected constructor params",
                    1,
                    constructor.parameters.length);

            var meta:Array = def.retrieveMetaDataByName("TestMeta");
            Assert.assertEquals("unexpected class specific meta length",
                    1,
                    meta.length);


            def = describeType(TestClass4);
            Assert.assertEquals("Unexpected package name",def.packageName,"flexUnitTests.reflection.support");
            Assert.assertEquals("Unexpected type name",def.name,"TestClass4");

            variables = def.variables;
            Assert.assertEquals("unexpected variables length",2,variables.length);


            methods = def.methods;
            Assert.assertEquals("unexpected methods length",4,methods.length);

            accessors = def.accessors;
            Assert.assertEquals("unexpected accessors length",6,accessors.length);

            constructor = def.constructorMethod;
            Assert.assertEquals("unexpected constructor declaredBy",
                    "flexUnitTests.reflection.support.TestClass4",
                    constructor.declaredBy.qualifiedName);

            Assert.assertEquals("unexpected constructor params",
                    0,
                    constructor.parameters.length);



        }




        [TestVariance(variance="JS",description="Variance in test due to current inability for js target to reflect into non-FlexJS base classes or typedefs")]
		[Test]
        public function testDescribeTypeClass():void
        {
            var def:TypeDefinition = describeType(TestClass1);
            var expected:*;
            Assert.assertEquals("Unexpected package name","flexUnitTests.reflection.support",def.packageName);
            Assert.assertEquals("Unexpected type name",def.name,"TestClass1");

            var variables:Array = def.variables;
            Assert.assertEquals("unexpected instance variables length",3,variables.length);

            //there is a difference based on the EventDispatcher inheritance chain differences between js and swf:
            expected = isJS ? 4 : 7;
            var methods:Array = def.methods;
            Assert.assertEquals("unexpected instance methods length",expected,methods.length);

            var accessors:Array = def.accessors;
            Assert.assertEquals("unexpected instance accessors length",4,accessors.length);

            var staticVariables:Array =def.staticVariables;
            Assert.assertEquals("unexpected static variables length",2,staticVariables.length);

            var staticMethods:Array = def.staticMethods;
            Assert.assertEquals("unexpected static methods length",1,staticMethods.length);
            //there is a difference based on the native inheritance of readonly 'prototype' not collected from 'Class' (or Object for js):
            expected = isJS ? 3 : 4;
            var staticAccessors:Array = def.staticAccessors;
            Assert.assertEquals("unexpected static accessors length",expected,staticAccessors.length);

			
        }

        [TestVariance(variance="JS",description="Variance in test due to current inability for js target to reflect into non-FlexJS base classes or typedefs")]
        [Test]
        public function testDescribeTypeInstance():void
        {
            var def:TypeDefinition = describeType(new TestClass1());
            var expected:*;
            Assert.assertEquals("Unexpected package name","flexUnitTests.reflection.support",def.packageName);
            Assert.assertEquals("Unexpected type name",def.name,"TestClass1");

            var variables:Array = def.variables;
            Assert.assertEquals("unexpected instance variables length",3,variables.length);

            //there is a difference based on the EventDispatcher inheritance chain differences between js and swf:
            expected = isJS ? 4 : 7;
            var methods:Array = def.methods;
            Assert.assertEquals("unexpected instance methods length",expected,methods.length);

            var accessors:Array = def.accessors;
            Assert.assertEquals("unexpected instance accessors length",4,accessors.length);

            var staticVariables:Array =def.staticVariables;
            Assert.assertEquals("unexpected static variables length",2,staticVariables.length);

            var staticMethods:Array = def.staticMethods;
            Assert.assertEquals("unexpected static methods length",1,staticMethods.length);
            //there is a difference based on the native inheritance of readonly 'prototype' not collected from 'Class' (or Object for js):
            expected = isJS ? 3 : 4;
            var staticAccessors:Array = def.staticAccessors;
            Assert.assertEquals("unexpected static accessors length",expected,staticAccessors.length);


        }

        [TestVariance(variance="JS",description="Variance in baseClasses due to current inability for js target to reflect into non-FlexJS base classes or typedefs")]
        [Test]
        public function testBaseClasses():void{
            var def:TypeDefinition = describeType(TestClass1);

            var baseClasses:Array = def.baseClasses;
            var expected:uint = isJS ? 1 : 3;
            Assert.assertEquals("unexpected baseclasses length",expected,baseClasses.length);
        }


        [Test]
        public function testMemberAccess():void{
            //all of these should succeed without error
            var inst:TestClass2 = new TestClass2("");
            var def:TypeDefinition = describeType(inst);

            /** instance variables **/

            var variables:Array = def.variables;
            var variable:VariableDefinition = variables[0];
            Assert.assertEquals("unexpected variable name","testVar",variable.name);
            var meta:MetaDataDefinition = variable.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            var metaArg:MetaDataArgDefinition = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","instanceVariable",metaArg.value);

            Assert.assertEquals("unexpected reflection initial variable value","testVar_val",inst[variable.name]);

            var accessors:Array = def.accessors;
            var testReadOnly:AccessorDefinition = retrieveItemWithName(accessors,"testReadOnly") as AccessorDefinition;
            meta = testReadOnly.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            metaArg = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","instanceAccessor",metaArg.value);

            /** instance accessors **/
            var testWriteOnly:AccessorDefinition = retrieveItemWithName(accessors,"testWriteOnly") as AccessorDefinition;
            var testReadWrite:AccessorDefinition = retrieveItemWithName(accessors,"testReadWrite") as AccessorDefinition;
            Assert.assertNotNull(testReadOnly);
            Assert.assertNotNull(testWriteOnly);
            Assert.assertNotNull(testReadWrite);

            Assert.assertEquals("unexpected accessor initial value","instanceAccessor_initial_value",inst[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","instanceAccessor_initial_value",inst[testReadWrite.name]);

            inst[testWriteOnly.name] = "test";
            Assert.assertEquals("unexpected accessor initial value","test",inst[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","test",inst[testReadWrite.name]);

            inst[testReadWrite.name] = "test2";
            Assert.assertEquals("unexpected accessor initial value","test2",inst[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","test2",inst[testReadWrite.name]);

            /** instance methods **/
            var methods:Array = def.methods;
            var testMethod:MethodDefinition = retrieveItemWithName(methods,"testMethod") as MethodDefinition;
            meta = testMethod.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            metaArg = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","instanceMethod",metaArg.value);
            Assert.assertEquals("unexpected parameter count",0,testMethod.parameters.length);
            inst[testMethod.name]();
            Assert.assertEquals("unexpected method invocation result","testMethod was called",inst[testReadWrite.name]);

            var testMethodWithArgs:MethodDefinition = retrieveItemWithName(methods,"testMethodWithArgs") as MethodDefinition;
            Assert.assertEquals("unexpected parameter count",2,testMethodWithArgs.parameters.length);
            Assert.assertTrue("unexpected method invocation result",inst[testMethodWithArgs.name]("test"));
            Assert.assertFalse("unexpected method invocation result",inst[testMethodWithArgs.name]("test", false));
            Assert.assertEquals("unexpected method invocation result","testMethodWithArgs was called",inst[testReadWrite.name]);



            /** static vars **/
            variables = def.staticVariables;

            
            variable = variables[0];
            Assert.assertEquals("unexpected variable name","testStaticVar",variable.name);
            meta = variable.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            metaArg = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","staticVariable",metaArg.value);

            Assert.assertEquals("unexpected reflection initial variable value","testStaticVar_val",TestClass2[variable.name]);

            /** static accessors **/

            accessors = def.staticAccessors;

            
            testReadOnly = retrieveItemWithName(accessors,"testStaticReadOnly") as AccessorDefinition;
            meta = testReadOnly.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            metaArg = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","staticAccessor",metaArg.value);


            testWriteOnly = retrieveItemWithName(accessors,"testStaticWriteOnly") as AccessorDefinition;
            testReadWrite = retrieveItemWithName(accessors,"testStaticReadWrite") as AccessorDefinition;
            Assert.assertNotNull(testReadOnly);
            Assert.assertNotNull(testWriteOnly);
            Assert.assertNotNull(testReadWrite);

            Assert.assertEquals("unexpected accessor initial value","staticAccessor_initial_value",TestClass2[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","staticAccessor_initial_value",TestClass2[testReadWrite.name]);

            TestClass2[testWriteOnly.name] = "test";
            Assert.assertEquals("unexpected accessor initial value","test",TestClass2[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","test",TestClass2[testReadWrite.name]);

            TestClass2[testReadWrite.name] = "test2";
            Assert.assertEquals("unexpected accessor initial value","test2",TestClass2[testReadOnly.name]);
            Assert.assertEquals("unexpected accessor initial value","test2",TestClass2[testReadWrite.name]);


            /** static methods **/
            methods = def.staticMethods;
            testMethod = retrieveItemWithName(methods,"testStaticMethod") as MethodDefinition;
            meta = testMethod.retrieveMetaDataByName("TestMeta")[0];
            Assert.assertEquals("unexpected meta name","TestMeta",meta.name);

            metaArg = meta.getArgsByKey("foo")[0];
            Assert.assertEquals("unexpected meta arg name","foo",metaArg.name);
            Assert.assertEquals("unexpected meta arg value","staticMethod",metaArg.value);
            Assert.assertEquals("unexpected parameter count",0,testMethod.parameters.length);
            TestClass2[testMethod.name]();
            Assert.assertEquals("unexpected method invocation result","testStaticMethod was called",TestClass2[testReadWrite.name]);

            testMethodWithArgs = retrieveItemWithName(methods,"testStaticMethodWithArgs") as MethodDefinition;
            Assert.assertEquals("unexpected parameter count",2,testMethodWithArgs.parameters.length);
            Assert.assertTrue("unexpected method invocation result",TestClass2[testMethodWithArgs.name]("test"));
            Assert.assertFalse("unexpected method invocation result",TestClass2[testMethodWithArgs.name]("test", false));
            Assert.assertEquals("unexpected method invocation result","testStaticMethodWithArgs was called",TestClass2[testReadWrite.name]);

        }


		[Test]
        public function testInterfaceReflection():void{
            var def:TypeDefinition = describeType(ITestInterface4);
            Assert.assertEquals("unexpected kind value","interface",def.kind);
            Assert.assertEquals("unexpected interfaces length",3,def.interfaces.length);
            Assert.assertEquals("unexpected accessors length",1,def.accessors.length);
            Assert.assertEquals("unexpected methods length",1,def.methods.length);

            Assert.assertEquals("unexpected variables length",0,def.variables.length);
            Assert.assertEquals("unexpected staticVariables length",0,def.staticVariables.length);
            Assert.assertEquals("unexpected variables length",0,def.staticMethods.length);
            Assert.assertEquals("unexpected staticVariables length",0,def.staticAccessors.length);
            Assert.assertNull("unexpected constructor Method definition",def.constructorMethod);
        }



    }
}
