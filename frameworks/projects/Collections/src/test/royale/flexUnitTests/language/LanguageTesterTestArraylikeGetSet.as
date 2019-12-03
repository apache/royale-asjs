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
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.collections.ArrayListView;
    import org.apache.royale.collections.IArrayList;
    import org.apache.royale.utils.BinaryData;
    //import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestArraylikeGetSet
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
            arrayList= new ArrayList(['dog', 'cat','mouse','gerbil']);
        }
        
        [After]
        public function tearDown():void
        {
        }
    
    
    
        public var arrayList:ArrayList;
    
        [Test]
        public function testImpl():void
        {
            var other:ArrayList = new ArrayList([1,2,3]);
            var local:ArrayList = new ArrayList(['gerbil','something else']);
            arrayList[0] = local[0];
            assertEquals(arrayList.getItemAt(0),'gerbil', 'unexpected get/set result')
            //RoyaleUnitTestRunner.consoleOut(arrayList.source.toString());
            arrayList.setItemAt('manually assigned gerbil',0);
           // RoyaleUnitTestRunner.consoleOut(arrayList.source.toString());
            if (arrayList[0] == 'manually assigned gerbil') {
                arrayList[0] = local[1];
            }
            assertEquals(arrayList.getItemAt(0),'something else', 'unexpected get/set result');
            var collect:Array = [];
            for(var i:int =0; i<other[2];i++) { // 'getItemAt' used in here
                collect.push(other[i]); //'getItemAt'
            }
            assertEquals(collect.toString(),'1,2,3', 'unexpected loop result');
        
            if (arrayList[0] == 'not the value') {
                arrayList[0] = 'bad assignment';
            } else {
                arrayList[0] = 'correct assignment';
            }
            assertEquals(arrayList.getItemAt(0),'correct assignment', 'unexpected assignment result in else block');
           // RoyaleUnitTestRunner.consoleOut(arrayList.source.toString());
        
            try{
                arrayList[0] = "inside try";
            } catch (e:Error)
            {
                //no error
            } finally{
                arrayList[1] = "inside finally";
            }
            assertEquals(arrayList.getItemAt(0),'inside try', 'unexpected try/catch/finally result');
            assertEquals(arrayList.getItemAt(1),'inside finally', 'unexpected try/catch/finally result');
        
        }
    
        [Test]
        public function testVariable():void{
            var original:ArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var content:Object = original[0];
            assertEquals(content, 'dog', 'bad arraylike access');
        
        }
    
        [Test]
        public function testSubClass():void{
            //test 'inheritance' via class (ArrayListView in this case)
            arrayList= new ArrayList(['dog', 'cat','mouse','gerbil']);
            var other:ArrayList = new ArrayList([1,2,3]);
            var local:ArrayList = new ArrayList(['gerbil','something else']);
        
            var alv:ArrayListView = new ArrayListView(arrayList);
            var alv1:ArrayListView = new ArrayListView(other);
            var alv2:ArrayListView = new ArrayListView(local);
            alv[0] = alv2[0];
            assertEquals(alv.getItemAt(0),'gerbil', 'unexpected get/set result');
            //RoyaleUnitTestRunner.consoleOut(arrayList.source.toString());
            alv.setItemAt('manually assigned gerbil',0);
           // RoyaleUnitTestRunner.consoleOut(alv.source.toString());
            if (alv[0] == 'manually assigned gerbil') {
                alv[0] = alv2[1];
            }
            assertEquals(alv.getItemAt(0),'something else', 'unexpected get/set result');
            var collect:Array = [];
            for(var i:int =0; i<alv1[2];i++) { // 'getItemAt' used in here
                collect.push(alv1[i]); //'getItemAt'
            }
            assertEquals(collect.toString(),'1,2,3', 'unexpected loop result');
        
            if (alv[0] == 'not the value') {
                alv[0] = 'bad assignment';
            } else {
                alv[0] = 'correct assignment';
            }
            assertEquals(alv.getItemAt(0),'correct assignment', 'unexpected assignment result in else block');
           // RoyaleUnitTestRunner.consoleOut(alv.source.toString());
        
            try{
                alv[0] = "inside try";
            } catch (e:Error)
            {
                //no error
            } finally{
                alv[1] = "inside finally";
            }
            assertEquals(alv.getItemAt(0),'inside try', 'unexpected try/catch/finally result');
            assertEquals(alv.getItemAt(1),'inside finally', 'unexpected try/catch/finally result');
        }
    
    
        [Test]
        public function testNested():void
        {
            arrayList= new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var f:Function = function something():String{
                arrayList[1] = 'another dog';
                return arrayList[1] as String;
            };
        
            var f2:Function = function():String{
                arrayList[1] = 'yet another dog';
                return arrayList[1] as String;
            };
        
            var check:String = f();
            assertEquals(check,'another dog', 'unexpected get/set result');
        
            assertEquals(arrayList.getItemAt(1),'another dog', 'unexpected get/set result');
        
            check = f2();
            assertEquals(check,'yet another dog', 'unexpected get/set result');
        
            assertEquals(arrayList.getItemAt(1),'yet another dog', 'unexpected get/set result');
        
        }
    
        private function localReturn(val:ArrayList):String{
            val[0] = 'get and set from localMethod';
            return val[0] as String;
        }
    
        [Test]
        public function testLocalMethodReturn():void{
            arrayList= new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var check:String = localReturn(arrayList);
            assertEquals(check,'get and set from localMethod', 'unexpected get/set result');
            assertEquals(arrayList.getItemAt(0),'get and set from localMethod', 'unexpected get/set result');
        }
    
    
        [Test]
        public function testExternalFunc():void{
            arrayList= new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var check:String = checkArrayLikeFunc(arrayList);
            assertEquals(check,'get and set from checkArrayLikeFunc', 'unexpected get/set result');
            assertEquals(arrayList.getItemAt(0),'get and set from checkArrayLikeFunc', 'unexpected get/set result');
        }
    
    
        public function testBinaryData():void{
            var bd:BinaryData = new BinaryData();
            bd.length = 100;
            var checkVal:uint = 0;
            for (var i:uint=0;i<100;i++) {
                checkVal += i;
                bd[i] = i;
            }
            var summationCheck:uint=0;
            for each(var byte:uint in bd) {
                summationCheck += byte;
            }
            assertEquals(bd[99], 99, 'unexpected value at index');
            assertEquals(summationCheck, checkVal, 'unexpected check on result')
        }
        
        
        
    }
}
