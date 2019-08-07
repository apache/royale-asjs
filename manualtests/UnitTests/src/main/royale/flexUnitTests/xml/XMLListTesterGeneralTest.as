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
    
    import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLListTesterGeneralTest
    {
        public static var isJS:Boolean = COMPILE::JS;
        
        
        private var settings:Object;
        
        public static function getSwfVersion():uint{
            COMPILE::SWF{
                return RoyaleUnitTestRunner.swfVersion;
            }
            COMPILE::JS {
                //this mimics the version of the flash player that has xml toString support 'fixed'
                return 21
            }
        }
        
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
        public function testXMLListBoolean():void
        {
            
            var xmllist:XMLList = XMLList(true);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'true', 'XMLList content was unexpected');
    
            xmllist = XMLList(false);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'false', 'XMLList content was unexpected');
        }
    
    
        [Test]
        public function testXMLListNull():void
        {
            var xmllist:XMLList;
            var caughtError:Boolean = false;
            try{
                xmllist = XMLList(null);
            } catch(e:Error) {
                caughtError = true;
            }
            //as3 docs say this is an error, but it is not (in AVM)
            assertFalse( caughtError, 'XMLList error status was unexpected');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');

        }
    
        [Test]
        public function testXMLListNumber():void
        {
            var xmllist:XMLList = XMLList(99.9);
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == '99.9', 'XMLList content was unexpected');
            
        }
    
        [Test]
        public function testXMLListString():void
        {
            var xmllist:XMLList = XMLList('test');
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == 'test', 'XMLList content was unexpected');
            
            xmllist = XMLList('');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');
        }
    
        [Test]
        public function testXMLListUndefined():void
        {
            var xmllist:XMLList;
            var caughtError:Boolean = false;
            try{
                xmllist = XMLList(undefined);
            } catch(e:Error) {
                caughtError = true;
            }
    
            //as3 docs say this is an error, but it is not (in AVM)
            assertFalse( caughtError, 'XMLList error status was unexpected');
            assertTrue( xmllist.length() == 0, 'XMLList length was unexpected');
        
        }
    
    
        [Test]
        public function testXMLListObject():void
        {
            var xmllist:XMLList  = XMLList({});
    
            //as3 docs say this is an error, but it is not (in AVM)
            assertTrue( xmllist.length() == 1, 'XMLList length was unexpected');
            assertTrue( xmllist[0].nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( xmllist.toString() == '[object Object]', 'XMLList content was unexpected');
        
        }
    
        [Test]
        public function testXMLListFromStringContent():void
        {
            var contentString:String = '<size description="Medium" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Small" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Medium" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>\n' +
                    '<size description="Extra Large" xmlns:fx="http://ns.adobe.com/mxml/2009" >\n' +
                    '  <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '  <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '</size>';
            
            var xmllist:XMLList  = XMLList(contentString);
        

            assertTrue( xmllist.length() == 6, 'XMLList length was unexpected');
            //use length here to account for variation in attribute/namespace sequence outputs
            assertTrue( xmllist.toXMLString().length == 1431, 'XMLList length was unexpected');
        }
        
        
    }
}
