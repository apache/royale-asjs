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
    
    public class ReflectionTesterTestUseCache
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
            TypeDefinition.useCache = true;
            TestClass2.testStaticVar = "testStaticVar_val";
            TestClass2.testStaticWriteOnly = "staticAccessor_initial_value";
        }
        
        [After]
        public function tearDown():void
        {
            TypeDefinition.useCache = false;
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
        public function testBasicCache():void {
            var def:TypeDefinition = describeType(TestClass2);

            var def2:TypeDefinition = describeType(TestClass2);

            Assert.assertEquals("cache not working",def,def2);

        }



    }
}
