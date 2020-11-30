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

    import org.apache.royale.reflection.*
    import org.apache.royale.reflection.utils.*;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class ReflectionTesterTestUtils
    {
        
        public static var isJS:Boolean ;
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            isJS = COMPILE::JS;
            ExtraData.addAll();
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            ExtraData.reset();
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
        public function testIsDerivedType():void
        {
            var check:Boolean;
            var targetCandidate:TypeDefinition;
            var ancestry:TypeDefinition;
            //various interface checks
            ancestry = describeType(ITestInterface);
            targetCandidate = describeType(ITestInterface2)
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            targetCandidate = describeType(ITestInterface4)
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            targetCandidate = describeType(ITestInterface)
            check = isDerivedType(targetCandidate, ancestry);
            assertFalse(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            targetCandidate = describeType(TestClass3);
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            targetCandidate = describeType(TestClass3ex);
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            ancestry = describeType(TestClass1);
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            targetCandidate = describeType(TestClass1);
            check = isDerivedType(targetCandidate, ancestry);
            //A class cannot be a derived type of itself
            assertFalse(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            //an interface is not considered to be derived from 'Object'
            targetCandidate = describeType(ITestInterface)
            ancestry = describeType(Object);
            check = isDerivedType(targetCandidate, ancestry);
            assertFalse(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );

            //an class is considered to be derived from 'Object'
            targetCandidate = describeType(TestClass1);
            check = isDerivedType(targetCandidate, ancestry);
            assertTrue(check, 'Unexpected ancestry check for '+targetCandidate.qualifiedName +"<--"+ancestry.qualifiedName );


        }

    }
}
