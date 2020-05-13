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
    
    
    import mx.net.SharedObject;
    import mx.net.SharedObjectJSON;
    import org.apache.royale.reflection.registerClassAlias;
    import org.apache.royale.test.asserts.*;
    import flexUnitTests.mxroyale.support.*;
    import testshim.RoyaleUnitTestRunner;
    
    
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class SharedObjectTest
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
            registerClassAlias('TestClass5', TestClass5);
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
    
        public function getPlayerVersion():Number{
            COMPILE::SWF{
                import flash.system.Capabilities;
                var parts:Array = Capabilities.version.split(' ')[1].split(',');
                return Number( parts[0]+'.'+parts[1])
            }
            //something for js, indicating javascript 'playerversion' is consistent with more recent flash player versions:
            return 30;
        }
        
        
        [Test]
        public function testSharedObjectSimple():void{
            var so:SharedObject = SharedObject.getLocal('myDynamicTest');
            var content:Object = so.data;

            var so2:SharedObject = SharedObject.getLocal('myDynamicTest');

            var content2:Object = so2.data;

            assertEquals(so,so2, 'unexpected non equivalency');
            assertEquals(content,content2, 'unexpected non equivalency');
            
            //content should either be empty or the last saved.
            var validContents:Array = [ '{"test":{"name":"an Object"}}', '{}'];
            assertTrue(validContents.indexOf(JSON.stringify(content)) != -1, 'contents not considered valid');
            so.data['test'] = {'name':'an Object'};
            so.flush();
        }
        
        [Test]
        public function testSharedObjectAMF():void{
            var so:SharedObject = SharedObject.getLocal('myTypedTest');
           
            //this will work first when saving, and subsequently when retrieving
            var object:Object = so.data['testClass'];
            RoyaleUnitTestRunner.consoleOut('testSharedObjectAMF found TestClass5 instance? '+(object is TestClass5));
            if (object == null) {
                so.data['testClass'] = new TestClass5();
                so.flush();
                object = so.data['testClass']
            }
            
            assertTrue(object is TestClass5, 'contents not considered valid');
        }
    
    
        [Test]
        public function testSharedObjectJSONSimple():void{
            var so:SharedObjectJSON = SharedObjectJSON.getLocal('myJSONTest');
            var content:Object = so.data;
        
            var so2:SharedObjectJSON = SharedObjectJSON.getLocal('myJSONTest');
        
            var content2:Object = so2.data;
        
            assertEquals(so,so2, 'unexpected non equivalency');
            assertEquals(content,content2, 'unexpected non equivalency');
            RoyaleUnitTestRunner.consoleOut('testSharedObjectJSONSimple content is '+JSON.stringify(content));
            //content should either be empty or the last saved.
            var validContents:Array = [ '{"test":{"name":"an Object"}}', '{}'];
            assertTrue(validContents.indexOf(JSON.stringify(content)) != -1, 'contents not considered valid');
            so.data['test'] = {'name':'an Object'};
            so.flush();
        }
    
    
        [Test]
        public function testSharedObjectNoFlush():void{
            var so:SharedObject = SharedObject.getLocal('myUnflushedObject');
           

            RoyaleUnitTestRunner.consoleOut('testSharedObjectNoFlush content is '+JSON.stringify(so.data));
            //content should either be empty object or the last saved from page refresh. It should be saved on page 'unload' ('pagehide')
            var validContents:Array = [ '{"myUnflushedObject":{"name":"myUnflushedObject"}}', '{}'];
            assertTrue(validContents.indexOf(JSON.stringify(so.data)) != -1, 'contents not considered valid');
            so.data['myUnflushedObject'] = {'name':'myUnflushedObject'};

        }
    
        [Test]
        public function testSharedObjectJSONNoFlush():void{
            var so:SharedObjectJSON = SharedObjectJSON.getLocal('myUnflushedJSONObject');
            
            RoyaleUnitTestRunner.consoleOut('testSharedObjectJSONNoFlush content is '+JSON.stringify(so.data));
            //content should either be empty object or the last saved from page refresh. It should be saved on page 'unload' ('pagehide')
            var validContents:Array = [ '{"myUnflushedJSONObject":{"name":"myUnflushedJSONObject"}}', '{}'];
            assertTrue(validContents.indexOf(JSON.stringify(so.data)) != -1, 'contents not considered valid');
            so.data['myUnflushedJSONObject'] = {'name':'myUnflushedJSONObject'};
        
        }
    }
}
