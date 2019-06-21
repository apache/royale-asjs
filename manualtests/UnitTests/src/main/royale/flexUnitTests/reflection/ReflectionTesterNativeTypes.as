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
    import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterNativeTypes
    {
        
        public static var isJS:Boolean;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            isJS = COMPILE::JS;
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Before]
        public function setUp():void
        {
            ExtraData.addAll();
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
        public function testArrayClass():void
        {
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(Array), "Array");
            Assert.assertEquals("Unexpected type", getDefinitionByName("Array"), Array);
            var def:TypeDefinition = describeType(Array);
            Assert.assertTrue("unexpected value", def.accessors.length == 1);
            Assert.assertEquals("Unexpected type name", def.name, "Array");
        }
    
    
        [Test]
        public function testArrayInstance():void
        {
            var inst:Array = [];
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "Array");
            
            var def:TypeDefinition = describeType([]);
            Assert.assertTrue("unexpected value", def.accessors.length == 1);
            Assert.assertEquals("Unexpected type name", def.name, "Array");
            
        }
    
        [Test]
        public function testStringClass():void
        {
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(String), "String");
            Assert.assertEquals("Unexpected type", getDefinitionByName("String"), String);
            var def:TypeDefinition = describeType(String);
            Assert.assertTrue("unexpected value", def.accessors.length == 1);
            Assert.assertEquals("Unexpected type name", def.name, "String");           
        }
    
    
        [Test]
        public function testStringInstance():void
        {
            var inst:String = '';
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "String");
    
            var def:TypeDefinition = describeType(inst);
            Assert.assertTrue("unexpected value", def.accessors.length == 1);
            Assert.assertEquals("Unexpected type name", def.name, "String");
        }
    
    
        [Test]
        public function testNumberClass():void
        {
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(Number), "Number");
            Assert.assertEquals("Unexpected type", getDefinitionByName("Number"), Number);
            var def:TypeDefinition = describeType(Number);
            Assert.assertTrue("unexpected value", def.staticMethods.length == 18);
            Assert.assertEquals("Unexpected type name", def.name, "Number");
        }
    
    
        [Test]
        public function testNumberInstance():void
        {
            var inst:Number = 1.5;
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "Number");
            
            var def:TypeDefinition = describeType(inst);
            //This is resolved as Number
            Assert.assertEquals("Unexpected type name", def.name, "Number");
            Assert.assertTrue("unexpected value", def.staticMethods.length == 18);

        }
    
        [Test]
        public function testIntClass():void
        {
    
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(int), "int");
            Assert.assertEquals("Unexpected type", getDefinitionByName("int"), int);
            var def:TypeDefinition = describeType(int);
            
            Assert.assertEquals("Unexpected type name", def.name, "int");
        }
    
    
        [Test]
        public function testIntInstance():void
        {
            var inst:int = -268435456;
            
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "int");
            inst-=1;
            //resolves to Number outside boundary:
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "Number");
            inst = 268435455;
            
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "int");
            inst+=1;
            //resolves to Number outside boundary:
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "Number");
            inst = -268435456;
            
            var def:TypeDefinition = describeType(inst);

            //    RoyaleUnitTestRunner.consoleOut('def name is '+def.name);

            //This is treated as Number
            Assert.assertEquals("Unexpected type name", def.name, "int");
        
        }
    
        [Test]
        public function testUintClass():void
        {
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(uint), "uint");
            Assert.assertEquals("Unexpected type", getDefinitionByName("uint"), uint);
            
            var def:TypeDefinition = describeType(uint);
            Assert.assertEquals("Unexpected type name", def.name, "uint");
        
        }
    
    
        [Test]
        public function testUintInstance():void
        {
            var inst:uint = 1;
            //resolves to Number:
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "int");
    
            var def:TypeDefinition = describeType(inst);
            //This is treated as Number
            Assert.assertEquals("Unexpected type name", def.name, "int");
        
        }
    
    
        [Test]
        public function testSpecificVectorClass():void
        {
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(Vector.<uint>), "Vector.<uint>");
            Assert.assertEquals("Unexpected type", getDefinitionByName("Vector.<uint>"), Vector.<uint>);
            var def:TypeDefinition = describeType(Vector.<uint>);
         //   RoyaleUnitTestRunner.consoleOut(def.toString(true));
            Assert.assertEquals("Unexpected type name", def.name, "Vector.<uint>");
            
        }
    
    
        [Test]
        public function testSpecificVectorInstance():void
        {
            var inst:Vector.<uint> = new Vector.<uint>();
            //resolves to Number:
            Assert.assertEquals("Unexpected type name", getQualifiedClassName(inst), "Vector.<uint>");
            
            var def:TypeDefinition = describeType(inst);
            Assert.assertEquals("Unexpected type name", def.name, "Vector.<uint>");
        
        }
        
    }
}
