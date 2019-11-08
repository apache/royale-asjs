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
    import org.apache.royale.reflection.utils.getMembersWithNameMatch;
    import org.apache.royale.reflection.utils.getMembersWithQNameMatch;
    import org.apache.royale.reflection.utils.MemberTypes;
    import org.apache.royale.reflection.utils.getMembers;

    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterTestEdgeCases
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
        public function testUndefined():void
        {
            var test:* = getDefinitionByName('undefined');
            assertTrue(test === undefined, 'getDefinitionByName for undefined should return undefined reference')
            
        }
    
    
        [Test]
        public function testNull():void
        {
            var err:Boolean;
            try{
                var test:* = getDefinitionByName('null');
            } catch(e:Error) {
                err = true;
            }
            assertTrue(err, 'getDefinitionByName for null should throw an error')
        }
    
    
        [Test]
        public function testCustomNamespace():void
        {
            var inst:TestClass6 = new TestClass6();
            var def:TypeDefinition = describeType(inst);
            
            var collection:Array;
            var subset:Array;
            collection = getMembers(def,false,MemberTypes.VARIABLES);
            
            assertEquals(collection.length, 2, 'unexpected variable count');
            
            subset = getMembersWithNameMatch(collection,'myVar');
            assertEquals(subset.length, 1, 'unexpected variable count');
            //default is public namespace
            assertEquals(MemberDefinitionBase(subset[0]).uri, '', 'unexpected namespace from query');
    
            subset = getMembersWithNameMatch(collection,'myVar', null, true);
            assertEquals(subset.length, 2, 'unexpected variable count');
    
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myVar'), null);
            assertEquals(subset.length, 1, 'unexpected variable count');

            assertEquals(MemberDefinitionBase(subset[0]).uri, String(testnamespace), 'unexpected namespace from query');
    
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, '*'), null);
            assertEquals(subset.length, 1, 'unexpected variable count');

            assertEquals(MemberDefinitionBase(subset[0]).uri, String(testnamespace), 'unexpected namespace from query');
    
            subset = getMembersWithQNameMatch(collection,null, null);
            assertEquals(subset.length, 2, 'unexpected variable count');
            
            collection = getMembers(def,false,MemberTypes.ACCESSORS);
            assertEquals(collection.length, 2, 'unexpected accessor count');
    
            collection = getMembers(def,false,MemberTypes.METHODS);
            assertEquals(collection.length, 2, 'unexpected method count');
            
            //no need to use extra scrutiny on the last two queries, because the variable tests already verified that.
            
            //now try read/write
            //first vars
            var varDefinition:VariableDefinition;
            collection = getMembers(def,false,MemberTypes.VARIABLES);
            //public myVar
            subset = getMembersWithNameMatch(collection,'myVar');
            varDefinition = subset[0];
            //read
            assertEquals(varDefinition.getValue(inst), inst.myVar, 'unexpected variable read result');

            //write
            varDefinition.setValue(inst, 'setViaPublicReflection');
            assertEquals('setViaPublicReflection', inst.myVar, 'unexpected variable write result');
            //testnamespace::myVar
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myVar'), null);
            varDefinition= subset[0];
            //read
            assertEquals(varDefinition.getValue(inst), inst.testnamespace::myVar, 'unexpected variable read result');
            //write
            varDefinition.setValue(inst, 'setViaCustomNSReflection');
            assertEquals('setViaCustomNSReflection', inst.testnamespace::myVar, 'unexpected variable write result');
            //next methods
            var methodDefinition:MethodDefinition;
            collection = getMembers(def,false,MemberTypes.METHODS);
            subset = getMembersWithNameMatch(collection,'myMethod');
            methodDefinition = subset[0];
            //public myMethod
            assertEquals(methodDefinition.getMethod(inst), inst.myMethod, 'unexpected method access result');
            //testnamespace::myMethod
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myMethod'), null);
            methodDefinition= subset[0];
            //testnamespace myMethod
            assertEquals(methodDefinition.getMethod(inst), inst.testnamespace::myMethod, 'unexpected method access result');
    
            //next accessors
            var accessorDefinition:AccessorDefinition;
            collection = getMembers(def,false,MemberTypes.ACCESSORS);
            subset = getMembersWithNameMatch(collection,'myAccessor');
            accessorDefinition = subset[0];
            //public myAccessor
            //read
            assertEquals(accessorDefinition.getValue(inst), inst.myAccessor, 'unexpected accessor access result');
            //write
            //this is readOnly, so...
            var hasError:Boolean;
            try{
                accessorDefinition.setValue(inst, 'setViaPublicReflection');
            } catch(e:Error) {
                hasError = true;
            }
            assertTrue(hasError, 'unexpected non-error read-only access write result');

            //testnamespace::myAccessor
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myAccessor'), null);
            accessorDefinition = subset[0];
            //testnamespace::myAccessor
            //read
            assertEquals(accessorDefinition.getValue(inst), inst.testnamespace::myAccessor, 'unexpected accessor access result');
    
            accessorDefinition.setValue(inst, 'setViaCustomNSReflection');
    
            assertEquals( inst.testnamespace::myAccessor,'setViaCustomNSReflection', 'unexpected accessor post-write access result');
    
        }
    
        [Test]
        public function testCustomNamespaceStatic():void
        {

            var def:TypeDefinition = describeType(TestClass6);
        
            var collection:Array;
            var subset:Array;
            collection = getMembers(def,true,MemberTypes.VARIABLES|MemberTypes.STATIC_ONLY);
        
            assertEquals(collection.length, 2, 'unexpected variable count');
        
            subset = getMembersWithNameMatch(collection,'myStaticVar');
            assertEquals(subset.length, 1, 'unexpected variable count');
            //default is public namespace
            assertEquals(MemberDefinitionBase(subset[0]).uri, '', 'unexpected namespace from query');
        
            subset = getMembersWithNameMatch(collection,'myStaticVar', null, true);
            assertEquals(subset.length, 2, 'unexpected variable count');
        
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myStaticVar'), null);
            assertEquals(subset.length, 1, 'unexpected variable count');
        
            assertEquals(MemberDefinitionBase(subset[0]).uri, String(testnamespace), 'unexpected namespace from query');
        
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, '*'), null);
            assertEquals(subset.length, 1, 'unexpected variable count');
        
            assertEquals(MemberDefinitionBase(subset[0]).uri, String(testnamespace), 'unexpected namespace from query');
        
            subset = getMembersWithQNameMatch(collection,null, null);
            assertEquals(subset.length, 2, 'unexpected variable count');
        
            collection = getMembers(def,true,MemberTypes.ACCESSORS|MemberTypes.STATIC_ONLY);
            var expectedCount:uint = isJS ? 2  : 3; //SWF has 'prototype' also as a readonly accessor
            assertEquals(collection.length, expectedCount, 'unexpected accessor count');
        
            collection = getMembers(def,true,MemberTypes.METHODS|MemberTypes.STATIC_ONLY);
            assertEquals(collection.length, 2, 'unexpected method count');
        
            //no need to use extra scrutiny on the last two queries, because the variable tests already verified that.
        
            //now try read/write
            //first: vars
            var varDefinition:VariableDefinition;
            collection = getMembers(def,true,MemberTypes.VARIABLES|MemberTypes.STATIC_ONLY);
            //public myVar
            subset = getMembersWithNameMatch(collection,'myStaticVar');
            varDefinition = subset[0];
            //read
            assertEquals(varDefinition.getValue(), TestClass6.myStaticVar, 'unexpected variable read result');
        
            //write
            varDefinition.setValue('setViaPublicReflection');
            assertEquals('setViaPublicReflection', TestClass6.myStaticVar, 'unexpected variable write result');
            //testnamespace::myVar
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myStaticVar'), null);
            varDefinition= subset[0];
            //read
            assertEquals(varDefinition.getValue(), TestClass6.testnamespace::myStaticVar, 'unexpected variable read result');
            //write
            varDefinition.setValue('setViaCustomNSReflection');
            assertEquals('setViaCustomNSReflection', TestClass6.testnamespace::myStaticVar, 'unexpected variable write result');
            //next: methods
            var methodDefinition:MethodDefinition;
            collection = getMembers(def,true,MemberTypes.METHODS|MemberTypes.STATIC_ONLY);
            subset = getMembersWithNameMatch(collection,'myStaticMethod');
            methodDefinition = subset[0];
            //public myMethod
            assertEquals(methodDefinition.getMethod(), TestClass6.myStaticMethod, 'unexpected method access result');
            //testnamespace::myMethod
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myStaticMethod'), null);
            methodDefinition= subset[0];
            //testnamespace myMethod
            assertEquals(methodDefinition.getMethod(), TestClass6.testnamespace::myStaticMethod, 'unexpected method access result');
        
            //next: accessors
            var accessorDefinition:AccessorDefinition;
            collection = getMembers(def,true,MemberTypes.ACCESSORS|MemberTypes.STATIC_ONLY);
            subset = getMembersWithNameMatch(collection,'myStaticAccessor');
            accessorDefinition = subset[0];
            //public myAccessor
            //read
            assertEquals(accessorDefinition.getValue(), TestClass6.myStaticAccessor, 'unexpected accessor access result');
            //write
            //this is readOnly, so...
            var hasError:Boolean;
            try{
                accessorDefinition.setValue('setViaPublicReflection');
            } catch(e:Error) {
                hasError = true;
            }
            assertTrue(hasError, 'unexpected non-error read-only access write result');
        
            //testnamespace::myAccessor
            subset = getMembersWithQNameMatch(collection,new QName(testnamespace, 'myStaticAccessor'), null);
            accessorDefinition = subset[0];
    
            //testnamespace::myAccessor
            //read
            assertEquals(accessorDefinition.getValue(), TestClass6.testnamespace::myStaticAccessor, 'unexpected accessor access result');
        
            accessorDefinition.setValue('setViaCustomNSReflection');
        
            assertEquals( TestClass6.testnamespace::myStaticAccessor,'setViaCustomNSReflection', 'unexpected accessor post-write access result');
        
        }
        
        public static var anything:*;
    
        [Test]
        public function testWrongSetValueType():void{
            var inst:TestClass1 = new TestClass1();
    
            var def:TypeDefinition = describeType(inst);
            var collection:Array;
            var subset:Array;
            collection = getMembers(def,false,MemberTypes.VARIABLES);
            subset = getMembersWithNameMatch(collection,'testVar');
            var testVarDef:VariableDefinition = subset[0];
            //assign a Number to the String typed testVar member:
            testVarDef.setValue(inst, 0.0);
            assertStrictlyEquals(inst.testVar, '0', 'unexpected assigned value');
            collection = getMembers(def,false,MemberTypes.ACCESSORS);
            subset = getMembersWithNameMatch(collection,'accessorTest');
            var accessorTestDef:AccessorDefinition = subset[0];
            accessorTestDef.setValue(inst, 0.0);
            assertStrictlyEquals(inst.accessorTest, '0', 'unexpected assigned value');
            
            def = describeType(this);
            collection = getMembers(def,true,MemberTypes.VARIABLES|MemberTypes.STATIC_ONLY);
            subset = getMembersWithNameMatch(collection,'anything');
            testVarDef = subset[0];
            testVarDef.setValue('anything');
            assertStrictlyEquals(ReflectionTesterTestEdgeCases.anything, 'anything', 'unexpected assigned value');
        }
        
    }
}
