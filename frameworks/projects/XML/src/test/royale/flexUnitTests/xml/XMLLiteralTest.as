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

    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLLiteralTest
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
        public function testSimpleLiteral():void
        {
            var xml1:XML = <foo baz="true"/>;

            assertEquals( xml1.toXMLString(),'<foo baz="true"/>', 'unexpected result from simple XML literal roundtripping');
        }
        
       
        
        
        [Test]
        public function testLocalVarInsertion():void
        {
            var test:String='testVal';

            var xml1:XML =  <foo baz="true">
                                <testVar>{test}</testVar>
                            </foo>;
            
            assertEquals( xml1.testVar.toString() , "testVal", 'toString value should be "testVal" ');
            
        }

        [Test]
        public function testComplexInsertion():void
        {
            var contentSource:ExternalSource = new ExternalSource();

            var xml:XML = <outer xmlns='http://something' other="test" strange='"test"' another="'test'">
                <inner>
                    <something>anything</something>
                    <contentString att='someAttributeVal'>{contentSource.stringVal + ' with appended literal string'}</contentString>
                    <contentBoolVal att='someAttributeVal'>{String(contentSource.boolVal)}</contentBoolVal>
                    <contentNumVal att='someAttributeVal'>{contentSource.numVal}</contentNumVal>
                    <someExternalStaticValue att='someAttributeVal'>{ExternalSource.getAValue()}</someExternalStaticValue>
                </inner>
            </outer>;

            assertEquals( xml.toXMLString() , '<outer other="test" strange="&quot;test&quot;" another="\'test\'" xmlns="http://something">\n' +
                    '  <inner>\n' +
                    '    <something>anything</something>\n' +
                    '    <contentString att="someAttributeVal">stringVal with appended literal string</contentString>\n' +
                    '    <contentBoolVal att="someAttributeVal">true</contentBoolVal>\n' +
                    '    <contentNumVal att="someAttributeVal">10</contentNumVal>\n' +
                    '    <someExternalStaticValue att="someAttributeVal">ExternalSource.gotValue</someExternalStaticValue>\n' +
                    '  </inner>\n' +
                    '</outer>', 'unexpected result from XML literal complex insertion at construction');

        }
    }
}

class ExternalSource{

    public static function getAValue():String{
        return 'ExternalSource.gotValue';
    }

    public var stringVal:String = 'stringVal';
    public function get boolVal():Boolean{
        return true;
    }

    public var numVal:Number = 10;
}
