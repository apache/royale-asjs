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
package flexUnitTests.xml
{
    
    
    import org.apache.royale.test.asserts.*;
    
    //import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLTesterNullTest
    {
    
        public static var isJS:Boolean = COMPILE::JS;
    
        private var settings:Object;
        
        [Before]
        public function setUp():void
        {
            settings = XML.settings();
        }
        
        [After]
        public function tearDown():void
        {
            XML.setSettings(settings);
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        
        [Test]
        public function testSettingAttributes():void
        {
            var xml:XML = <foo/>;
            xml.@name = "";
            assertEquals( xml.toXMLString(), '<foo name=""/>', 'Error in blank attribute');

            xml = <foo/>;
            xml.@name = undefined;
            assertEquals( xml.toXMLString(), '<foo name="undefined"/>', 'Error in undefined attribute');

            xml = <foo/>;
            xml.@name = null;
            assertEquals( xml.toXMLString(), '<foo name="null"/>', 'Error in null attribute');

            xml = <foo name="undefined"/>;
            assertEquals( xml.toXMLString(), '<foo name="undefined"/>', 'Error in undefined attribute');

            xml = <foo name="null"/>;
            assertEquals( xml.toXMLString(), '<foo name="null"/>', 'Error in null attribute');

            xml = new XML('<foo name="undefined"/>');
            assertEquals( xml.toXMLString(), '<foo name="undefined"/>', 'Error in undefined attribute');

            xml = new XML('<foo name="null"/>');
            assertEquals( xml.toXMLString(), '<foo name="null"/>', 'Error in null attribute');

        }

        
    }
}
