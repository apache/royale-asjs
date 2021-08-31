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
package flexUnitTests.network
{
    
    

    
    import org.apache.royale.test.asserts.*;

    
    import org.apache.royale.net.URLVariables;
    
    
    public class URLVariablesTesterTest
    {
        
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
        
        
        private function encodedStringContentsMatch(string1:String, string2:String):Boolean{
            if (string1.length == string2.length) {
                var content1:Array = string1.split('&');
                var content2:Array = string2.split('&');
                if (content1.length == content2.length) {
                    while(content1.length) {
                        if (content2.indexOf(content1.pop()) == -1) return false;
                    }
                    return true;
                }
            }
            return false;
        }
        
       
        [Test]
        public function testEncoding():void
        {
            var tester:URLVariables = new URLVariables();
            tester['test1'] = 'test1Value';
            assertEquals(tester.toString(), 'test1=test1Value', 'unexpected encoded string');
            
            tester['test2'] = 'test2Value';
            //handle arbitrary order of encoded values when testing:
            assertTrue(encodedStringContentsMatch(tester.toString(), 'test1=test1Value&test2=test2Value'), 'unexpected encoded string')
        }
        
        [Test]
        public function testDecoding():void
        {
            var tester:URLVariables = new URLVariables('test1=test1Value');
            assertEquals(tester['test1'], 'test1Value', 'unexpected decoded value');
            
            tester.decode('test2=test2Value');
    
            //cumulative:
            assertEquals(tester['test1'], 'test1Value', 'unexpected decoded value');
            assertEquals(tester['test2'], 'test2Value', 'unexpected decoded value');
            
            //test empty string as name in pair
            tester = new URLVariables('=EmptyStringValue');
            assertEquals(tester[''], 'EmptyStringValue', 'unexpected decoded value');
    
        }

        [Test]
        public function testDecodingWithPlus():void
        {
            var tester:URLVariables = new URLVariables('test1=test1Value+with+spaces');
            assertEquals(tester['test1'], 'test1Value with spaces', 'unexpected decoded value');

        }
    
    
    
        [Test]
        public function testDecodingError():void
        {
            
            var wasError:Boolean;
            var tester:URLVariables = new URLVariables();
            try{
                //test2 name does not include a value:
                tester.decode('test1=1&test2');
            }catch(e:Error){
                wasError = true;
            }
            assertTrue(wasError, 'Error should be thrown for incomplete name-value pair');
            assertEquals(tester['test1'], '1', 'partially decoded value should be present');
    
            
        }
        
    }
}
