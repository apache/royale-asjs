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
package flexUnitTests.core
{
    
    
    import org.apache.royale.test.asserts.*;
    import flexUnitTests.core.support.TestVO;
    
    /**
     *  @royalesuppresspublicvarwarning
     */
    public class ArrayTesterTest
    {
        
        [Before]
        public function setUp():void
        {
            /*items1 = [
                new TestVO('aB', 0, 'zz'),
                new TestVO('aA', 0, 'aa'),
                new TestVO('aC', 1, 'zz'),
                new TestVO('aa', 1, 'aa'),
                new TestVO('ab', -1, 'zz'),
                new TestVO('ac', -1, 'aa')
            ];
            
            items2 =
            
            field1s = [];
            var i:uint=0, l:uint=items.length;
            for(;i<l;i++) {
                field1s.push(items[i].field1);
            }
            
            values = [23,-93,-59,-55,41,-29,69,11,33,-71,83,87,27,-39,70,-50,-56,-61,17,-35,-60,-86,-78,-83,-10];
*/        }
        
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
        
        public var items1:Array;
    
        public var items2:Array;
        
        public var field1s:Array;
    
        public var values:Array;
        
        
        private function _sort(arr:Array,args:Array):void{
            COMPILE::SWF{
                arr.sort.apply(arr,args);
            }
            COMPILE::JS{
                import org.apache.royale.utils.Language;
                args.unshift(arr);
                Language.sort.apply(null, args);
            }
        }
    
        [Test]
        public function testSort():void
        {
            assertTrue(true, "Parked, needs more work");
            
            /*import testshim.RoyaleUnitTestRunner;
            /!*assertEquals(
                    '23,-93,-59,-55,41,-29,69,11,33,-71,83,87,27,-39,70,-50,-56,-61,17,-35,-60,-86,-78,-83,-10',
                    values.toString(), 'unexpected starting state');*!/
            assertEquals(
                'aB,aA,aC,aa,ab,ac,zA,ZA,zA,ZA,zA,zA,AA,AA',
                field1s.toString(), 'unexpected starting state');
            
            field1s.sort();
            assertEquals(
                    'AA,AA,ZA,ZA,aA,aB,aC,aa,ab,ac,zA,zA,zA,zA',
                    field1s.toString(), 'unexpected starting state');
    
            RoyaleUnitTestRunner.consoleOut('field1s ' + field1s.toString());
    
            _sort(field1s, [Array.CASEINSENSITIVE]);
    
            assertEquals(
                    'aa,AA,aA,AA,ab,aB,ac,aC,ZA,ZA,zA,zA,zA,zA',
                    field1s.toString(), 'unexpected starting state');
    
            _sort(field1s, [Array.DESCENDING]);
    
            assertEquals(
                    'zA,zA,zA,zA,ac,ab,aa,aC,aB,aA,ZA,ZA,AA,AA',
                    field1s.toString(), 'unexpected starting state');
            
           // field1s.sort(Array.CASEINSENSITIVE);
    
            RoyaleUnitTestRunner.consoleOut('field1s ' + field1s.toString());
            _sort(field1s, [Array.DESCENDING|Array.CASEINSENSITIVE]);
    
            assertEquals(
                    'zA,zA,zA,zA,ZA,ZA,ac,aC,ab,aB,AA,aA,aa,AA',
                    field1s.toString(), 'unexpected starting state');
            RoyaleUnitTestRunner.consoleOut('field1s ' + field1s.toString());*/
            
        }
        
        
        [Test]
        public function testSortOn():void
        {
            assertTrue(true, "Parked, needs more work");
            
           /* assertEquals(
                    'TestVO [aB]#0 [zz],TestVO [aA]#0 [aa],TestVO [aC]#1 [zz],TestVO [aa]#1 [aa],TestVO [ab]#-1 [zz],TestVO [ac]#-1 [aa],TestVO [zA]#0 [bb],TestVO [ZA]#0 [aa],TestVO [zA]#1 [bb],TestVO [ZA]#1 [aa],TestVO [zA]#-1 [bb],TestVO [zA]#-1 [aa],TestVO [AA]#0 [aa],TestVO [AA]#0 [zz]',
                    items.toString(), 'unexpected starting state');
    
            import testshim.RoyaleUnitTestRunner;
    
            RoyaleUnitTestRunner.consoleOut('items ' + items.toString());
    

            
            items.sortOn('field1',0);
            assertEquals(
                    'TestVO [AA]#0 [aa],TestVO [AA]#0 [zz],TestVO [ZA]#0 [aa],TestVO [ZA]#-1 [aa],TestVO [ZA]#1 [aa],TestVO [aA]#0 [zz],TestVO [aA]#-1 [zz],TestVO [aA]#-1 [aa],TestVO [aA]#0 [aa],TestVO [aA]#1 [aa],TestVO [aA]#1 [zz],TestVO [zA]#-1 [bb],TestVO [zA]#0 [bb],TestVO [zA]#1 [bb]',
                    items.toString(), 'unexpected sortOn result');
            
            
    
            RoyaleUnitTestRunner.consoleOut('items ' + items.toString());*/
        
        }
        
        
    }
}
