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
    public class ReflectionTesterTestUseCache
    {
        
        public static var isJS:Boolean = COMPILE::JS;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            TypeDefinition.useCache = false;
        }
        
        [Before]
        public function setUp():void
        {
            TypeDefinition.useCache = true;
            TestClass2.testStaticVar = "testStaticVar_val";
            TestClass2.testStaticWriteOnly = "staticAccessor_initial_value";
        }
        
        [After]
        public function tearDown():void
        {
            TypeDefinition.useCache = false;
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
        public function testBasicCache():void
        {
            var def:TypeDefinition = describeType(TestClass2);
            
            var def2:TypeDefinition = describeType(TestClass2);
            
            assertEquals( def, def2, "cache not working");
            
        }
        
        
    }
}
