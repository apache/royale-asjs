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
package flexUnitTests.mxroyale
{
    
    

    import org.apache.royale.test.asserts.*;
    import flexUnitTests.mxroyale.support.*;


    import mx.collections.ArrayCollection;



/**
     * @royalesuppresspublicvarwarning
     */
    public class CollectionsTest
    {
    
        
        public static var isJS:Boolean = COMPILE::JS;
    

        [Before]
        public function setUp():void
        {
        
        }
        
        [After]
        public function tearDown():void
        {

        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }

        
        private var testAC2:ACTestTwo = new ACTestTwo();
    
        [Test]
        public function testForEachViaMemberAccess():void{
            var testOut:Array = [];

            for each(var item:Object in testAC2.nestedOne.ac) {
                testOut.push(item)
            }

            var expected:Array = testAC2.nestedOne.getOriginalContents();
            assertEquals(testOut.toString(), expected.toString(), 'unexpected results from for-each iteration');

        }


        private var localMemberAC:ArrayCollection = new ArrayCollection(['localMember1', 'localMember2']);

        [Test]
        public function testForEachViaLocalMember():void{
            var testOut:Array = [];

            for each(var item:Object in localMemberAC) {
                testOut.push(item)
            }

            var expected:Array = ['localMember1', 'localMember2'];
            assertEquals(testOut.toString(), expected.toString(), 'unexpected results from for-each iteration');

        }


        [Test]
        public function testForEachViaLocalVar():void{
            var testOut:Array = [];
            var localVarAC:ArrayCollection = new ArrayCollection(['localVar1', 'localVar2']);

            for each(var item:Object in localVarAC) {
                testOut.push(item)
            }

            var expected:Array = ['localVar1', 'localVar2'];
            assertEquals(testOut.toString(), expected.toString(), 'unexpected results from for-each iteration');

        }
        
    }
}
