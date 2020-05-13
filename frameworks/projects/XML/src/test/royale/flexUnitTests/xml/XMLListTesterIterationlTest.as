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
    public class XMLListTesterIterationlTest
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
        public function testXMLListIteration():void
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
            var count:uint = 0;
            for each(var xml:XML in xmllist) {
                count++;
            }

            assertEquals(count, 6, 'unexpected list count');

        }
        

        [Test]
        public function testAttributeXMLListIteration():void
        {
            
            var xml:XML = <TextFlow blockProgression="tb" color="0x0" columnCount="inherit" columnGap="inherit" columnWidth="inherit" direction="ltr" fontFamily="Arial" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineBreak="inherit" lineHeight="120%" locale="en" paddingBottom="inherit" paddingLeft="inherit" paddingRight="inherit" paddingTop="inherit" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="start" textAlignLast="start" textAlpha="1" textIndent="0" textJustify="interWord" textRotation="auto" trackingRight="0" verticalAlign="inherit" whiteSpaceCollapse="preserve" />;

            var count:int;
            for each(var att:XML in xml[0].attributes()) {
                count++;
            }

            assertEquals(count, 31, 'unexpected list count');
            count=0;
            for each(att in xml.attributes()) {
                count++;
            }
            assertEquals(count, 31, 'unexpected list count');

        }


        [Test]
        public function testChildrenXMLListIteration():void
        {

            var xml:XML = <monkeys><Mandrill/><Spidery/><Proboscis/><PygmyMarmoset/><RhesusMacaque/><Gibbon/><Howler/><Baboon/><Capuchin/></monkeys>
            var count:int;
            for each(var att:XML in xml[0].children()) {
                count++;
            }

            assertEquals(count, 9, 'unexpected list count');
            count=0;
            for each(att in xml.children()) {
                count++;
            }
            assertEquals(count, 9, 'unexpected list count');

        }
        
    }
}
