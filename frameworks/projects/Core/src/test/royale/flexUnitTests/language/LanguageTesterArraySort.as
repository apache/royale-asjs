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
    
    
    import org.apache.royale.test.asserts.*;
    
    import flexUnitTests.language.support.*;



/**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterArraySort
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
        public function testSortOnIndexedArray():void
        {
            var arr:Array = [{'value':2},{'value':4},{'value':6},{'value':8},{'value':10}];
            var ret:Array;
            //without Array.RETURNINDEXEDARRAY
            ret = arr.sortOn('value', Array.NUMERIC|Array.DESCENDING);

            assertEquals(JSON.stringify(arr), '[{"value":10},{"value":8},{"value":6},{"value":4},{"value":2}]', 'unexpected result');
            assertEquals(arr,ret, 'unexpected result');
            //with Array.RETURNINDEXEDARRAY
            arr = [{'value':2},{'value':4},{'value':6},{'value':8},{'value':10}];
            ret = arr.sortOn('value',Array.NUMERIC|Array.DESCENDING|Array.RETURNINDEXEDARRAY);


            assertEquals(JSON.stringify(arr), '[{"value":2},{"value":4},{"value":6},{"value":8},{"value":10}]', 'unexpected result');
            assertNotEquals(arr,ret, 'unexpected result');
            assertEquals(ret.join(','), '4,3,2,1,0', 'unexpected result');

            //with duplicate sortables
            arr = [{'value':2, 'idx':0},{'value':4, 'idx':1},{'value':6, 'idx':2},{'value':8, 'idx':3},{'value':6, 'idx':4},{'value':2, 'idx':5},{'value':10, 'idx':6}];
            //[{'value':10},{'value':8},{'value':6},{'value':6},{'value':4},{'value':2},{'value':2}]
            //[6,3,4,2,1,0,5] or [6,3,2,4,1,0,5] or [6,3,4,2,1,5,0] or [6,3,2,4,1,5,0]
            ret = arr.sortOn('value',Array.NUMERIC|Array.DESCENDING|Array.RETURNINDEXEDARRAY);
            //"The array is modified to reflect the sort order; multiple elements that have identical sort fields
            // are placed consecutively in the sorted array in no particular order."
            var validResults:Array = ["6,3,4,2,1,0,5" , "6,3,2,4,1,0,5" , "6,3,4,2,1,5,0" , "6,3,2,4,1,5,0"];
            //JSON field order can vary
            var validJSONs:Array = [
                '[{"value":2,"idx":0},{"value":4,"idx":1},{"value":6,"idx":2},{"value":8,"idx":3},{"value":6,"idx":4},{"value":2,"idx":5},{"value":10,"idx":6}]',
                '[{"idx":0,"value":2},{"idx":1,"value":4},{"idx":2,"value":6},{"idx":3,"value":8},{"idx":4,"value":6},{"idx":5,"value":2},{"idx":6,"value":10}]'
            ]

            assertTrue(validJSONs.indexOf(JSON.stringify(arr))!=-1, 'unexpected result');
            assertNotEquals(arr,ret, 'unexpected result');
            assertTrue(validResults.indexOf(ret.join(',')) != -1, 'unexpected result');

        }

        [Test]
        public function testSortIndexedArray():void
        {
            var arr:Array = [2,4,6,8,10];
            var ret:Array;
            //without Array.RETURNINDEXEDARRAY
            ret = arr.sort(Array.NUMERIC|Array.DESCENDING);

            assertEquals(arr.join(','), '10,8,6,4,2', 'unexpected result');
            assertEquals(arr,ret, 'unexpected result');

            //with Array.RETURNINDEXEDARRAY
            arr = [2,4,6,8,10];
            ret = arr.sort(Array.NUMERIC|Array.DESCENDING|Array.RETURNINDEXEDARRAY);

            assertEquals(arr.join(','), '2,4,6,8,10', 'unexpected result');
            assertNotEquals(arr,ret, 'unexpected result');
            assertEquals(ret.join(','), '4,3,2,1,0', 'unexpected result');



            //with duplicates
            arr = [2,4,6,8,6,2,10];
            //[10,8,6,6,4,2,2]
            //[6,3,4,2,1,0,5] or [6,3,2,4,1,0,5] or [6,3,4,2,1,5,0] or [6,3,2,4,1,5,0]
            ret = arr.sort(Array.NUMERIC|Array.DESCENDING|Array.RETURNINDEXEDARRAY);



            //"The array is modified to reflect the sort order; multiple elements that have identical sort fields
            // are placed consecutively in the sorted array in no particular order."
            var validResults:Array = ["6,3,4,2,1,0,5" , "6,3,2,4,1,0,5" , "6,3,4,2,1,5,0" , "6,3,2,4,1,5,0"];

            assertEquals(arr.join(','), '2,4,6,8,6,2,10', 'unexpected result');
            assertNotEquals(arr,ret, 'unexpected result');
            assertTrue(validResults.indexOf(ret.join(',')) != -1, 'unexpected result');
        }


        
    }
}
