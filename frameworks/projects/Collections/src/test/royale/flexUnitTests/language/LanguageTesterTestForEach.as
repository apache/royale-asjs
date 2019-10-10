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
    import org.apache.royale.collections.IArrayList;
    
   // import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class LanguageTesterTestForEach
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
            _myList = new ArrayList(['dog', 'cat','mouse','gerbil'])
        }
        
        [After]
        public function tearDown():void
        {
        }
        private var _animal:String;
        private var _char:String;
        private var _myList:ArrayList 
        
      
        [Test]
        public function testNested1():void
        {
            var arrayList:ArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
            
            var foundItems:Array = [];
            var charItems:Array = [];
            for each(var animal:String in arrayList) {
                foundItems.push(animal);
                var deepList:ArrayList = new ArrayList(animal.split(''));
                for each(var char:String in deepList) {
                   // RoyaleUnitTestRunner.consoleOut(char);
                    charItems.push(char);
                }
            }
        //    RoyaleUnitTestRunner.consoleOut(value + '');
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for each result');
            //check nested loop content
            assertEquals(charItems.toString(), 'd,o,g,c,a,t,m,o,u,s,e,g,e,r,b,i,l', 'unexpected for each result');
        }
        

    
        [Test]
        public function testNested1a():void
        {
            var array:Array=['dog', 'cat','mouse','gerbil'];
        
            var foundItems:Array = [];
            var charItems:Array = [];
            for each(_animal in array) {
                foundItems.push(_animal);
                var deepList:Array = _animal.split('');
                for each(_char in deepList) {
                    // RoyaleUnitTestRunner.consoleOut(char);
                    charItems.push(_char);
                }
            }
            //    RoyaleUnitTestRunner.consoleOut(value + '');
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for each result');
            //check nested loop content
            assertEquals(charItems.toString(), 'd,o,g,c,a,t,m,o,u,s,e,g,e,r,b,i,l', 'unexpected for each result');
        }
    
        [Test]
        public function testNested1b():void
        {
            //using a target referenced externally
            var foundItems:Array = [];
            var charItems:Array = [];
            for each(_animal in _myList) {
                foundItems.push(_animal);
                var deepList:ArrayList = new ArrayList(_animal.split(''));
                for each(_char in deepList) {
                    // RoyaleUnitTestRunner.consoleOut(char);
                    charItems.push(_char);
                }
            }
            //    RoyaleUnitTestRunner.consoleOut(value + '');
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for each result');
            //check nested loop content
            assertEquals(charItems.toString(), 'd,o,g,c,a,t,m,o,u,s,e,g,e,r,b,i,l', 'unexpected for each result');
        }
        
        
        [Test]
        public function testNested2():void
        {
            var arrayList:ArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var foundItems:Array = [];
            var charItems:Array = [];
            for each(_animal in arrayList) {
                foundItems.push(_animal);
                var deepList:ArrayList = new ArrayList(_animal.split(''));
                for each(_char in deepList) {
                    // RoyaleUnitTestRunner.consoleOut(char);
                    charItems.push(_char);
                }
            }
            //    RoyaleUnitTestRunner.consoleOut(value + '');
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for each result');
            //check nested loop content
            assertEquals(charItems.toString(), 'd,o,g,c,a,t,m,o,u,s,e,g,e,r,b,i,l', 'unexpected for each result');
        }
    
    
        [Test]
        public function testNested3():void
        {
            var arrayList:IArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var foundItems:Array = [];
            var charItems:Array = [];
            for each(_animal in arrayList) {
                foundItems.push(_animal);
                var deepList:IArrayList = new ArrayList(_animal.split(''));
                for each(_char in deepList) {
                    // RoyaleUnitTestRunner.consoleOut(char);
                    charItems.push(_char);
                }
            }
            //    RoyaleUnitTestRunner.consoleOut(value + '');
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for each result');
            //check nested loop content
            assertEquals(charItems.toString(), 'd,o,g,c,a,t,m,o,u,s,e,g,e,r,b,i,l', 'unexpected for each result');
        }
        
        
    
    
        [Test]
        public function testTargetMutation():void{
            var arrayList:ArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
    
            var foundItems:Array = [];
            for each(var animal:String in arrayList) {
                foundItems.push(animal);
                if (arrayList.length) arrayList.removeAll();//should stop iterating after first item
            }
            assertEquals(foundItems.toString(), 'dog', 'unexpected for each result');
        }
    
    
        [Test]
        public function testForIn():void{
            var arrayList:ArrayList = new ArrayList(['dog', 'cat','mouse','gerbil']);
        
            var foundItems:Array = [];
            for (var key:String in arrayList) {
                foundItems.push(arrayList.getItemAt(uint(key)));
            }
            assertEquals(foundItems.toString(), 'dog,cat,mouse,gerbil', 'unexpected for in result');
        }
    }
}
