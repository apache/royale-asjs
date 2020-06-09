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
    
    import org.apache.royale.test.Runtime;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLTesterGeneralTest
    {
        public static var isJS:Boolean = COMPILE::JS;
        
        private static var xmlStr:String;
        
        private static var quotedXML:XML;
        
        private static var xml:XML;
        private static var text:String;
        private static var xml2:XML;
        
        private var settings:Object;
        
        public static function getSwfVersion():uint{
            COMPILE::SWF{
                return Runtime.swfVersion;
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
            xmlStr ='<?xml version="1.0" encoding="UTF-8" ?>' +
                    '<catalog xmlns:fx="http://ns.adobe.com/mxml/2009"' +
                    '              xmlns:dac="com.printui.view.components.DesignAreaComponents.*">' +
                    '<' + '!' + '-' + '- just a comment -' + '-' + '>' +
                    '<?bla fud?>' +
                    '   bla bla<product description="Cardigan Sweater" product_image="cardigan.jpg">' +
                    '      <fx:catalog_item gender="Men\'s" fx:foo="bah">' +
                    '         <item_number>QWZ5671</item_number>' +
                    '         <price>39.95</price>' +
                    '         <size description="Medium">' +
                    '            <color_swatch image="red_cardigan.jpg">Red</color_swatch>' +
                    '            <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>' +
                    '         </size>' +
                    '         <size description="Large">' +
                    '            <color_swatch image="red_cardigan.jpg">Red</color_swatch>' +
                    '            <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>' +
                    '         </size>' +
                    '      </fx:catalog_item>' +
                    '      <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]' + ']>   </script>' +
                    '      <catalog_item gender="Women\'s">' +
                    '         <item_number>RRX9856</item_number>' +
                    '         <price>42.50</price>' +
                    '         <size description="Small">' +
                    '            <color_swatch image="red_cardigan.jpg">Red</color_swatch>' +
                    '            <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>' +
                    '            <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>' +
                    '         </size>' +
                    '         <size description="Medium">' +
                    '            <color_swatch image="red_cardigan.jpg">Red</color_swatch>' +
                    '            <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>' +
                    '            <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>' +
                    '            <color_swatch image="black_cardigan.jpg">Black</color_swatch>' +
                    '         </size>' +
                    '         <size description="Large">' +
                    '            <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>' +
                    '            <color_swatch image="black_cardigan.jpg">Black</color_swatch>' +
                    '         </size>' +
                    '         <size description="Extra Large">' +
                    '            <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>' +
                    '            <color_swatch image="black_cardigan.jpg">Black</color_swatch>' +
                    '         </size>' +
                    '      </catalog_item>' +
                    '   </product>' +
                    '</catalog>';

            quotedXML = <root title="That's Entertainment"/>;
            xml = new XML(xmlStr);
            text = "hi";
            xml2 = new XML('<root xmlns:fz="http://ns.adobe.com/mxml/2009"><a><b/></a><a name="fred"/><a>hi<b>yeah!</b></a><a name="frank"/><c/></root>');

        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            xmlStr = null;
            quotedXML = null;
            xml = null;
            text = null;
            xml2 = null;
        }
        
        
        [Test]
        public function testSimpleAttributes():void
        {
            
            var xml1:XML = <foo baz="true"/>;
            assertTrue( xml1.hasOwnProperty("@baz"), '<foo baz="true"/> should have attribute @baz');
            assertFalse( xml1.hasOwnProperty("@foo"), '<foo baz="true"/> should not have attribute @foo');
            assertFalse( xml1.hasOwnProperty("baz"), '<foo baz="true"/> should not have attribute baz');
            assertTrue( xml1.toXMLString() == '<foo baz="true"/>', '<foo baz="true"/> toXMLString should be <foo baz="true"/>');
            
            assertTrue( xml1.@baz.toString() == 'true', 'xml1.@baz.toString() should be "true"');
    
            var baz:XMLList = xml1.@baz;
            assertTrue( baz.toString() == 'true', 'baz.toString() should be "true"');
            assertEquals( baz.length(),1, 'baz.length() should be 1');
            var xml3:XML = <root/>;
            xml3.bar.baz = "baz";
            xml3.foo.@boo = "boo";
    
            assertEquals( xml3.bar.baz,'baz', 'xml3.bar.baz should be "baz"');
            assertEquals( xml3.foo.@boo,'boo', 'xml3.foo.@boo should be "boo"');

        }
        
       
        
        [Test]
        public function testSimpleXMLList():void
        {
            var xml1:XML = <foo baz="true"/>;
            
            assertTrue( xml1.@baz.toString() == "true", 'toString value should be "true" ');
            var xml3:XML = <root/>;
            xml3.bar.baz = "baz";
            xml3.foo.@boo = "boo";

            assertEquals( xml3.bar.baz.toString(), "baz", 'toString value should be "baz" ');
            assertEquals( xml3.foo.@boo.toString(), "boo", 'toString value should be "boo" ');
            
            var newContent:XML = <Content/>;
            newContent.Properties.Leading.@type = "string";
            newContent.Properties.Leading = 36;
            
            assertEquals( newContent.Properties.Leading.@type, "string", "Leading should be @type=string");
            assertStrictlyEquals(newContent.Properties.Leading.toString(), "36", "Leading should be 36");
            assertStrictlyEquals(
                    newContent.toXMLString(),
                    "<Content>\n" +
                    "  <Properties>\n" +
                    "    <Leading type=\"string\">36</Leading>\n" +
                    "  </Properties>\n" +
                    "</Content>",
                    "unexpected toXMLString() value"
            );

            newContent.Properties.Leading = 72;
            assertStrictlyEquals(newContent.Properties.Leading.toString(), "72", "Leading should be 72");
            
        }
        
        [Test]
        public function testMinimum():void{
            var xml:XML = new XML();
            assertEquals(xml.nodeKind(), 'text', 'unexpected default nodeKind');
            assertEquals(xml.toString(), '', 'unexpected default stringification');
        }
        
        
        [Test]
        public function testXMLMethods1():void
        {
            var xml1:XML = <foo baz="true"/>;
            var child:XML = <pop><child name="Sam"/></pop>;
            xml1.appendChild(child);
            child = <pop><child name="George"/></pop>;
            xml1.appendChild(child);
            
            assertTrue( xml1.pop[0].child.@name.toString() == 'Sam', 'unexpected child result');
            assertTrue( xml1.pop[1].child.@name.toString() == 'George', 'unexpected child result');
            
        }

    
        [TestVariance(variance="JS", description="toLocaleString has a substantially different output in javascript")]
        [TestVariance(variance="SWF", description="(observed) some of the XML methods for SWF had incorrect results before swf version 21")]
        [Test]
        public function testXMLMethods2():void
        {
            var xml1:XML = <foo baz="true"/>;
            var child:XML = <pop>
                                <child name="Sam"/>
                            </pop>;
            xml1.appendChild(child);
            child = <pop>
                        <child name="George"/>
                    </pop>;
            xml1.appendChild(child);
            assertEquals(
                    xml1.pop[0].toString(),
                    '<pop>\n' +
                    '  <child name="Sam"/>\n' +
                    '</pop>', 'unexpected output with xml1.pop[0].toString()');
            assertEquals(
                    xml1.pop[1].toString(),
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>', 'unexpected output with xml1.pop[1].toString()');
            

            var pop:XMLList = xml1.pop;
            pop[pop.length()] = <pop>
                                    <child name="Fred"/>
                                </pop>;

            assertEquals(
                    pop.toString(),
                    '<pop>\n' +
                    '  <child name="Sam"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>', 'unexpected output with pop.toString()');
    
            assertEquals(
                    xml1.toString(),
                    '<foo baz="true">\n' +
                    '  <pop>\n' +
                    '    <child name="Sam"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="George"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="Fred"/>\n' +
                    '  </pop>\n' +
                    '</foo>', 'unexpected output with xml1.toString()');
            
            
            pop[0] =    <pop>
                            <child name="Fred"/>
                        </pop>;
    
            assertEquals(
                    pop.toString(),
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>', 'unexpected output with pop.toString()');
    
            assertEquals(
                    xml1.toString(),
                    '<foo baz="true">\n' +
                    '  <pop>\n' +
                    '    <child name="Fred"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="George"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="Fred"/>\n' +
                    '  </pop>\n' +
                    '</foo>', 'unexpected output with xml1.toString()');
            
            //toLocaleString
            //VARIANCE
            
            var expected:String = isJS
                    ? '<foo baz="true">\n' +
                    '  <pop>\n' +
                    '    <child name="Fred"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="George"/>\n' +
                    '  </pop>\n' +
                    '  <pop>\n' +
                    '    <child name="Fred"/>\n' +
                    '  </pop>\n' +
                    '</foo>' //js
                    : '[object XML]';// swf
            
            assertEquals(
                    xml1.toLocaleString(),
                    expected, 'unexpected output with xml1.toLocaleString()');
            
            expected = isJS
                ?   '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>' //js
                    : '[object XMLList]';//swf
    
            assertEquals(
                    xml1.pop.toLocaleString(),
                    expected, 'unexpected output with xml1.pop.toLocaleString()');

            
            var parentXML:XML = <parent/>;
            var childXML:XML = <child/>;
            parentXML.appendChild(childXML);
            assertTrue( (childXML.parent() == parentXML), 'child/parent relationship was unexpected');
            assertEquals(
                    parentXML.toXMLString(),
                    '<parent>\n' +
                    '  <child/>\n' +
                    '</parent>', 'unexpected output following re-parenting');
            
            var newParent:XML = <newparent/>;
            newParent.appendChild(childXML);

            
            if (getSwfVersion() < 21) {
                //I think, a bug in old swf version, some 'remnant' of the old 'child' is still present in the'old' parent
                expected =  '<parent>\n' +
                            '  <child/>\n' +
                            '</parent>'
            } else {
                expected = '<parent/>';
            }
    
            assertEquals(
                    parentXML.toXMLString(),
                    expected, 'unexpected output following re-parenting');
    
            assertEquals(
                    newParent.toXMLString(),
                    '<newparent>\n' +
                    '  <child/>\n' +
                    '</newparent>', 'unexpected output following re-parenting');
            
            assertFalse( (childXML.parent() == parentXML), 'child/parent relationship was unexpected');
            
            var expectedLength:uint = getSwfVersion() < 21 ? 1 : 0;
            //another bug in old swf version, some 'remnant' of the old 'child' is still present in the'old' parent
            assertTrue( (parentXML.children().length() == expectedLength), 'child/parent relationship was unexpected');
            assertTrue( (childXML.parent() == newParent), 'child/parent relationship was unexpected');
            
            childXML = <Content>• <?ACE 7?>Some amazing content</Content>;
            var childXMLStr:String = childXML.text();

            assertEquals( childXMLStr, '•Some amazing content', " (should be) •Some amazing content");
        }
        [Test]
        public function testInvalidAppendChild():void{
            var root:XML = new XML('test');
            root.appendChild('test');
    
            assertEquals(root.toString(), 'test', 'testInvalidAppendChild 1 result is bad');
            assertEquals(root.toXMLString(), 'test', 'testInvalidAppendChild 2 result is bad');
        }
    
        [Test]
        public function testAppendNonXMLChild():void{
            var root:XML = <root/>;
            root.appendChild('test');
    
            assertEquals(root.toString(), 'test', 'testAppendNonXMLChild 1 result is bad');
            assertEquals(root.toXMLString(), '<root>test</root>', 'testAppendNonXMLChild 2 result is bad');
            
            root = <root><test><something/></test></root>;
            root.appendChild('test');
    
            assertEquals(
                    root.toString(),
                    '<root>\n' +
                    '  <test>\n' +
                    '    <something/>\n' +
                    '  </test>\n' +
                    '  <test>test</test>\n' +
                    '</root>', 'testAppendNonXMLChild 3 result is bad');
            
            assertEquals(
                    root.toXMLString(),
                    '<root>\n' +
                    '  <test>\n' +
                    '    <something/>\n' +
                    '  </test>\n' +
                    '  <test>test</test>\n' +
                    '</root>', 'testAppendNonXMLChild 4 result is bad');
            
        }
        
        
        [Test]
        public function testXMLNormalize():void{
            var xml:XML = <root/>;
            xml.appendChild("test1");
            xml.appendChild("test2");
            xml.appendChild(<element/>);
            xml.appendChild("test3");
            xml.appendChild("test4");
            
    
            assertEquals(
                    xml.toString(),
                    '<root>\n' +
                    '  test1\n' +
                    '  test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>', 'testXMLNormalize 1 result is bad');
    
            assertEquals(
                    xml.toXMLString(),
                    '<root>\n' +
                    '  test1\n' +
                    '  test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>', 'testXMLNormalize 2 result is bad');
            
   
            xml.normalize();
    
            assertEquals(
                    xml.toString(),
                    '<root>\n' +
                    '  test1test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>', 'testXMLNormalize 3 result is bad');
    
            assertEquals(
                    xml.toXMLString(),
                    '<root>\n' +
                    '  test1test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>', 'testXMLNormalize 4 result is bad');

            
        }
        
        [Test]
        public function testSVG():void
        {
            var svg:XML =   <svg>
                                <group>
                                    <rect id="1"/>
                                    <rect id="2"/>
                                </group>
                                <group>
                                    <rect id="3"/>
                                    <rect id="4"/>
                                </group>
                            </svg>;
            
            var rects:XMLList = svg..rect;
            rects[1].@width = "100px";
            rects.(@id == 3).@height = "100px";
            
            var expected:String =
                    '<rect id="1"/>' + '\n'
                    + '<rect id="2" width="100px"/>' + '\n'
                    + '<rect id="3" height="100px"/>' + '\n'
                    + '<rect id="4"/>';
            
            assertTrue( rects.toXMLString() == expected, 'string output was unexpected');
        }
    
    
        [Test]
        public function testChildList():void{
            var xml:XML = <root> asdasdas <element/> asdasqdasd<otherElement/></root>;
            
            var list:XMLList = xml.*;

            assertEquals( 4, list.length(), 'Error in list length');
            assertEquals( list.toXMLString(), 'asdasdas\n' + '<element/>\n' +'asdasqdasd\n' +'<otherElement/>', 'Error in list length');
            
            list = xml.element;
            assertEquals( 1, list.length(), 'Error in list length');
            assertEquals( list.toXMLString(),'<element/>', 'Error in list length');

            list = xml.otherElement;

            assertEquals( 1, list.length(), 'Error in list length');
            assertEquals( list.toXMLString(),'<otherElement/>', 'Error in list length');
    
            list = xml.otherElement;
            assertEquals( 1, list.length(), 'Error in list length');
    
        }
    
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testChildVariants():void{
            var xml:XML = <root xmlns:foo="foo" xmlns:other="other"> asdasdas <element/> asdasqdasd<otherElement/><foo:otherElement/><other:otherElement/></root>;
        
            var list:XMLList = xml.*::*;
        
            assertEquals( 4, list.length(), 'Error in list length');
            //IE11/Edge issues
            /*assertEquals( list.toXMLString(), '<element xmlns:foo="foo" xmlns:other="other"/>\n' +
                    '<otherElement xmlns:foo="foo" xmlns:other="other"/>\n' +
                    '<foo:otherElement xmlns:foo="foo" xmlns:other="other"/>\n' +
                    '<other:otherElement xmlns:foo="foo" xmlns:other="other"/>', 'Error in list content');*/
            assertEquals( list.toXMLString().length, 212, 'Error in list content');
        
            list = xml.otherElement;
            assertEquals( 1, list.length(), 'Error in list length');
            //IE11/Edge issues
           /* assertEquals( list.toXMLString(),'<otherElement xmlns:foo="foo" xmlns:other="other"/>', 'Error in list content');*/
            assertEquals( list.toXMLString().length,51, 'Error in list content');
        
            list = xml.*;
        
            assertEquals( 6, list.length(), 'Error in list length');
           /* assertEquals( list.toXMLString(),'asdasdas\n' +
                    '<element xmlns:foo="foo" xmlns:other="other"/>\n' +
                    'asdasqdasd\n' +
                    '<otherElement xmlns:foo="foo" xmlns:other="other"/>\n' +
                    '<foo:otherElement xmlns:foo="foo" xmlns:other="other"/>\n' +
                    '<other:otherElement xmlns:foo="foo" xmlns:other="other"/>', 'Error in list content');*/
            assertEquals( list.toXMLString().length,232, 'Error in list content');
        }
    
    
        [Test]
        public function testNamespaceRetrieval():void{
            var  content:XML = <Document>
                <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        " >
                </x:xmpmeta>
            </Document>;
        
            var namespace:Namespace = content.children()[0].namespace();
            assertEquals( namespace.prefix, 'x', 'Error in namespace prefix');
            assertEquals( namespace.uri, 'adobe:ns:meta/', 'Error in namespace uri');
        
        }
    
    
        [Test]
        [TestVariance(variance="JS",description="Javascript does not support duplicate namespace declarations (Error thrown)")]
        public function testNamespaceRetrieval2():void{
            var caughtError:Boolean;
            try {
                var  content:XML = <Document>
                    <x:xmpmeta xmlns:x="adobe:ns:meta/" xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        " >
                    </x:xmpmeta>
                </Document>;
            } catch(e:Error) {
                caughtError = true;
            }
        
            if (isJS) {
                caughtError = !caughtError;
            }
            assertFalse( caughtError, 'Unexpected Error state with duplicate namespace declarations');
        
        }
    
        [Test]
        public function testDuplicateAttributesError():void{
            var caughtError:Boolean;
            try {
                var  content:XML = <root myVal="something" myVal="somethingElse"/>;
            } catch(e:Error) {
                caughtError = true;
            }
        
            assertTrue( caughtError, 'Unexpected Error state with duplicate attribute declarations');
        
        }
    
        [Test]
        public function testParsingWhitespaceSetting1():void{
            var originalSetting:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var script:XML = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;
    
            assertEquals(1, script.children().length(), 'unexpected children number after parsing');
            assertEquals(
                    '<script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>', 
                    script.toXMLString(), 'unexpected toString value after parsing');

            XML.ignoreWhitespace = false;
            script = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;
            assertEquals(3, script.children().length(), 'unexpected children number after parsing');
            

            assertEquals(
                    '<script>\n' +
                    '  \n' +
                    '  <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>\n' +
                    '  \n' +
                    '</script>',
                    script.toXMLString(), 'unexpected toString value after parsing');
            XML.ignoreWhitespace = originalSetting;
        }
        [Test]
        public function testSingleProcessingInstructions():void{
            var original:Boolean = XML.ignoreProcessingInstructions;
            XML.ignoreProcessingInstructions = true;
            var xml:XML = new XML('<?bar foo?>');
            assertEquals( 'text', xml.nodeKind(), 'unexpected nodeKind with XML.ignoreProcessingInstructions = true');
            assertEquals( '', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreProcessingInstructions = true');
            XML.ignoreProcessingInstructions = false;
            xml = new XML('<?bar foo?>');
            assertEquals( 'processing-instruction', xml.nodeKind(), 'unexpected nodeKind with XML.ignoreProcessingInstructions = false');
            assertEquals( '<?bar foo?>', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreProcessingInstructions = false');
    
            XML.ignoreProcessingInstructions = original;
        }
    
    
        [Test]
        public function testSingleCDATA():void{
            var original:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var xml:XML = new XML('   <![CDATA[ my cdata ]]>   ');
            assertEquals( 'text', xml.nodeKind(), 'unexpected cdata result with XML.ignoreWhitespace = true');
            assertEquals( '<![CDATA[ my cdata ]]>', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreWhitespace = true');
            assertNull( xml.name(), 'unexpected name value with CDATA');
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   <![CDATA[ my cdata ]]>   ');
            } catch(e:Error) {
                caughtError = true;
            }
            
            assertTrue( caughtError, 'unexpected error status for single cdata string parsing with XML.ignoreWhitespace = false');
        
            XML.ignoreWhitespace = original;
        }
    
    
        [Test]
        public function testSingleText():void{
            var original:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var xml:XML = new XML('   my text   ');
            assertEquals( 'text', xml.nodeKind(), 'unexpected text result with XML.ignoreWhitespace = true');
            assertEquals( 'my text', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreWhitespace = true');
            assertNull( xml.name(), 'unexpected name value with text');
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   my text   ');
            } catch(e:Error) {
                caughtError = true;
            }
        
            assertFalse( caughtError, 'unexpected error status for text string parsing with XML.ignoreWhitespace = false');
            assertEquals( 'text', xml.nodeKind(), 'unexpected text result with XML.ignoreWhitespace = true');
            assertEquals( '   my text   ', xml.valueOf(), 'unexpected toXMLString with XML.ignoreWhitespace = true');
            XML.ignoreWhitespace = original;
        }
    
        [Test]
        public function testSingleComment():void{
            var original:Boolean = XML.ignoreWhitespace;
            var originalComments:Boolean = XML.ignoreComments;
            XML.ignoreWhitespace = true;
            XML.ignoreComments = false;
            var xml:XML = new XML('  <!-- my test comment -->  ');
            assertEquals( 'comment', xml.nodeKind(), 'unexpected comment result with XML.ignoreWhitespace = true');
            assertEquals( '<!-- my test comment -->', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreWhitespace = true');
            assertNull( xml.name(), 'unexpected name value with text');
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   <!-- my test comment -->   ');
            } catch(e:Error) {
                caughtError = true;
            }
        
            assertTrue( caughtError, 'unexpected error status for comment parsing with XML.ignoreWhitespace = false');
    
            xml = new XML('<!-- my test comment -->');
            assertNull( xml.name(), 'unexpected name value with comment');
            
            assertEquals( 'comment', xml.nodeKind(), 'unexpected comment result with XML.ignoreWhitespace = true');
            assertEquals( '<!-- my test comment -->', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreWhitespace = true');
            XML.ignoreComments = true;
            xml = new XML('<!-- my test comment -->');
            assertNull( xml.name(), 'unexpected name value with text');
    
            assertEquals( 'text', xml.nodeKind(), 'unexpected comment result with XML.ignoreComments = true');
            assertEquals( '', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreComments = true');
            
            
            XML.ignoreWhitespace = original;
            XML.ignoreComments = originalComments;
        }
        
        [Test]
        public function testIgnoreComments():void{
            var original:Boolean = XML.ignoreWhitespace;
            var originalComments:Boolean = XML.ignoreComments;
            XML.ignoreWhitespace = true;
            XML.ignoreComments = false;
            var xml:XML = new XML('<root><!-- my test comment --></root>');
            assertEquals( 1, xml.children().length(), 'unexpected comment result with XML.ignoreComments = false');

            assertEquals(
                    '<root>\n' +
                    '  <!-- my test comment -->\n' +
                    '</root>',
                    xml.toXMLString(), 'unexpected toXMLString with XML.ignoreComments = false');
            assertNull( xml.children()[0].name(), 'unexpected name value with comment');
            XML.ignoreComments = true;
            xml = new XML('<root><!-- my test comment --></root>');
            assertEquals( 0, xml.children().length(), 'unexpected comment result with XML.ignoreComments = true');
            assertEquals( '<root/>', xml.toXMLString(), 'unexpected toXMLString with XML.ignoreComments = true');
    
            XML.ignoreWhitespace = original;
            XML.ignoreComments = originalComments;
        }
        
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testLargeComplex():void{
            var xmlString:String = xml.toXMLString();

            //IE and MS Edge: inlcude alternate output check
            //account for variation in output order of attributes and namespace declarations (from native DOMParser)
            assertTrue(  xmlString.length == 2060, 'unexpected complex stringify results');
        }
        
        
        [Test]
        public function testTopLevelProcessingInstructions():void{
            var xmlSource:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n' +
                    '<?aid style="50" type="snippet" readerVersion="6.0" featureSet="257" product="14.0(209)" ?>\n' +
                    '<?aid SnippetType="PageItem"?>';
    
            XML.ignoreProcessingInstructions = true;
            var xml:XML = new XML(xmlSource);
            
            
            assertTrue( xml.toString() == '', 'unexpected toSting result');
            assertTrue( xml.nodeKind() == 'text', 'unexpected nodeKind result');
           
    
            XML.ignoreProcessingInstructions = false;
            var caughtError:Boolean;
            try {
                xml = new XML(xmlSource);
            } catch (e:Error)
            {
                //RoyaleUnitTestRunner.consoleOut(e.message);
                caughtError = true;
            }
            //RoyaleUnitTestRunner.consoleOut('testTopLevelProcessingInstructions '+xml.nodeKind());
            assertTrue( caughtError, 'error was expected');
        }
    
    
        [Test]
        public function testTopLevelWhitespace():void{
            var original:Boolean = XML.ignoreWhitespace;
            var xmlSource:String = '<?xml version="1.0" encoding="UTF-8"?>\n'
                    +' <?test ?>   <a>test</a>    ';
        
            XML.ignoreWhitespace = true;
            var xml:XML = new XML(xmlSource);
        
        
            assertTrue( xml.toString() == 'test', 'unexpected toSting result');
            assertTrue( xml.nodeKind() == 'element', 'unexpected nodeKind result');
        
        
            XML.ignoreWhitespace = false;
            xml = new XML(xmlSource);

            assertTrue( xml.toString() == 'test', 'unexpected toSting result');
            assertTrue( xml.nodeKind() == 'element', 'unexpected nodeKind result');
    
            XML.ignoreWhitespace = original;
        }
    
    
        [Test]
        public function testTopLevelMultipleTypes():void{
            var original:Object = XML.settings();
            var xmlSource:String = '<?xml version="1.0" encoding="UTF-8"?>\n'
                    +' <?test1 ?>  <!-- my test comment1 -->  <a>test</a>  <?test2 ?>  <!-- my test comment1 --> ';
    
            XML.ignoreComments = false;
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            var xml:XML = new XML(xmlSource);
        
        
            assertTrue( xml.toString() == 'test', 'unexpected toSting result');
            assertTrue( xml.nodeKind() == 'element', 'unexpected nodeKind result');
    
            xmlSource = '<?xml version="1.0" encoding="UTF-8"?>\n'
                    +' <?test1 ?>  <!-- my test comment1 -->   <?test2 ?>  <!-- my test comment2 --> ';

            var caughtError:Boolean = false;
            try {
                xml =new XML(xmlSource);
            } catch (e:Error)
            {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
            assertTrue( xml.toString() == 'test', 'unexpected toSting result');
            assertTrue( xml.nodeKind() == 'element', 'unexpected nodeKind result');
            
            XML.setSettings(original)
        }
    
    
        [Test]
        public function testTopLevelVariants():void{
            var original:Object = XML.settings();
            //error 2 root tags
            var xmlSource:String = ' <?test1 ?>  <!-- my test comment1 -->  <a>test</a>  <?test2 ?> <a>test</a> <!-- my test comment2 --> ';
        
            XML.ignoreComments = false;
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            var xml:XML;
            
            var caughtError:Boolean = false;
            
            try {
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
    
            assertTrue( caughtError, 'unexpected error statust');
            //repeat with all settings toggled (must remain an error)
            XML.ignoreComments = true;
            XML.ignoreProcessingInstructions = true;
            XML.ignoreWhitespace = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
    
            assertTrue( caughtError, 'unexpected error statust');
            //restore settings
            XML.ignoreComments = false;
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
    
            //error multiple non-element nodes with whitespace
            xmlSource = ' <?test1 ?>  <!-- my test comment1 -->  <?test2 ?>  <!-- my test comment2 --> ';
    
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
    
            //repeat with whiteSpace toggled (must remain an error)
            XML.ignoreWhitespace = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
            XML.ignoreWhitespace = false;
            //repeat with ignoreProcessingInstructions toggled
            XML.ignoreProcessingInstructions = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
            XML.ignoreProcessingInstructions = false;
            //repeat with ignoreComments toggled
            XML.ignoreComments = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
            XML.ignoreComments = false;
            
            
            //repeat with all settings toggled
            XML.ignoreComments = true;
            XML.ignoreProcessingInstructions = true;
            XML.ignoreWhitespace = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertFalse( caughtError, 'unexpected error status');
            assertTrue( xml.toString() == '', 'unexpected toSting result');
            XML.ignoreComments = false;
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            
            //another one with top level cdata just to cover more:
    
            xmlSource = ' <?test1 ?>  <!-- my test comment1 --> <![CDATA[ -<something>-  ]]>  <?test2 ?> <!-- my test comment2 --> ';
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertTrue( caughtError, 'unexpected error status');
            //repeat with all settings toggled
            XML.ignoreComments = true;
            XML.ignoreProcessingInstructions = true;
            XML.ignoreWhitespace = true;
            try {
                caughtError = false;
                xml = new XML(xmlSource);
            } catch(e:Error) {
                caughtError = true;
            }
            assertFalse( caughtError, 'unexpected error status');
            assertTrue( xml.toString() == ' -<something>-  ', 'unexpected toSting result');
            assertTrue( xml.toXMLString() == '<![CDATA[ -<something>-  ]]>', 'unexpected toXMLString result');
            XML.ignoreComments = false;
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            
            
            XML.setSettings(original)
        }
    
    
    
        [Test]
        public function testTopLevelCoercionFunction():void{
            
            var localXml:XML;
    
            localXml = XML(true);
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == 'true', 'XML content was unexpected');
    
    
            localXml = XML(false);
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == 'false', 'XML content was unexpected');
    
    
            localXml = XML('string');
            assertTrue( localXml.nodeKind() == 'text', 'XMLList content was unexpected');
            assertTrue( localXml.toString() == 'string', 'XMLList content was unexpected');
    
            localXml = XML(99.9);
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == '99.9', 'XML content was unexpected');
    
            
            //as3 docs say this is an error, but it is not (in AVM)
            localXml = XML(null);
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == '', 'XML content was unexpected');
    
            //as3 docs say this is an error, but it is not (in AVM)
            localXml = XML(undefined);
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == '', 'XML content was unexpected');
    
            //as3 docs say this is an error, but it is not (in AVM)
            localXml = XML({});
            assertTrue( localXml.nodeKind() == 'text', 'XML content was unexpected');
            assertTrue( localXml.toString() == '[object Object]', 'XML content was unexpected');
            
            var xmlContent:XML = xml;
            localXml = XML(xmlContent);
            assertTrue( localXml == xml, 'XML content was unexpected');
            
            var sizes:XMLList = localXml..size.(@description == 'Small');
            assertTrue( sizes.length() == 1, 'XML content was unexpected');
            localXml = XML(sizes);
            assertTrue( localXml == sizes[0], 'XML content was unexpected');
            
        }
        
        [Test]
        public function testChildren():void{
            XML.setSettings(XML.defaultSettings());
            var xml:XML = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            assertEquals(xml.children().length(),3 , 'unexpected default parsing children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  <test/>\n' +
                    '  Something\n' +
                    '  surrounded With Whitespace\n' +
                    '</root>' , 'unexpected default parsing string output');
        
            XML.ignoreComments = false;
            xml = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            assertEquals(xml.children().length(),4 , 'unexpected parsing with ignoreComments = false children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  <test/>\n' +
                    '  Something\n' +
                    '  <!-- comment -->\n' +
                    '  surrounded With Whitespace\n' +
                    '</root>' , 'unexpected parsing with ignoreComments = false string output');
            XML.ignoreProcessingInstructions= false;
            xml = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            assertEquals(xml.children().length(),5 , 'unexpected parsing with ignoreComments = false and ignoreProcessingInstructions= false children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  <test/>\n' +
                    '  <?foo bar?>\n' +
                    '  Something\n' +
                    '  <!-- comment -->\n' +
                    '  surrounded With Whitespace\n' +
                    '</root>' , 'unexpected parsing with ignoreComments = false and ignoreProcessingInstructions= false string output');
            XML.ignoreWhitespace= false;
            xml = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            assertEquals(xml.children().length(),6 , 'unexpected parsing with ignoreComments = false and ignoreProcessingInstructions= false and ignoreWhitespace= false children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  \n' +
                    '  <test/>\n' +
                    '  <?foo bar?>\n' +
                    '  Something\n' +
                    '  <!-- comment -->\n' +
                    '  surrounded With Whitespace\n' +
                    '</root>' , 'unexpected parsing with ignoreComments = false and ignoreProcessingInstructions= false and ignoreWhitespace= false string output');
            
            //try something different
    
            XML.ignoreComments = true;
            xml = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            //because ignoreComments is true, the following is parsed as an empty test node:
            xml.appendChild(<!-- appended comment -->);
            assertEquals(xml.children().length(),6 , 'unexpected parsing with ignoreComments = true and ignoreProcessingInstructions= false and ignoreWhitespace= false and appending comment... children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  \n' +
                    '  <test/>\n' +
                    '  <?foo bar?>\n' +
                    '  Something\n' +
                    '  surrounded With Whitespace\n' +
                    '  \n' +
                    '</root>' , 'unexpected parsing with ignoreComments = true and ignoreProcessingInstructions= false and ignoreWhitespace= false and appending comment... string output');
    
            XML.ignoreComments = false;
            var comment:XML = <xml><!-- appended comment --></xml>;
            comment = comment.comments()[0];
            assertEquals(comment.toXMLString(),'<!-- appended comment -->', 'unexpected toXMLString for comment');
            XML.ignoreComments = true;
            xml = <root>   <test/><?foo bar?>Something<!-- comment --> surrounded With Whitespace </root>;
            //because ignoreComments is true, the following is parsed as an empty test node:
            xml.appendChild(comment);
            
            assertEquals(xml.children().length(),6 , 'unexpected parsing with ignoreComments = true and ignoreProcessingInstructions= false and ignoreWhitespace= false and appending comment... children length');
            assertEquals(xml.toXMLString(),
                    '<root>\n' +
                    '  \n' +
                    '  <test/>\n' +
                    '  <?foo bar?>\n' +
                    '  Something\n' +
                    '  surrounded With Whitespace\n' +
                    '  <!-- appended comment -->\n' +
                    '</root>' , 'unexpected parsing with ignoreComments = true and ignoreProcessingInstructions= false and ignoreWhitespace= false and appending comment... string output');
            
            
    
            XML.setSettings(XML.defaultSettings());
        }

        [Test]
        public function testElements():void{
            XML.setSettings(XML.defaultSettings());
            var xml:XML = <root>   <test/><?foo bar?>Something<el1/><!-- comment --> surrounded With Whitespace <el2/></root>;


            var elements:XMLList = xml.elements();


            assertEquals(
                    elements.toString(),
                    '<test/>\n' +
                    '<el1/>\n' +
                    '<el2/>', 'elements only should be 3 elements');

            elements = xml.elements('el1')
            assertEquals(
                    elements.toXMLString(),
                    '<el1/>', 'elements query should return 1 element');

            var el:XML = <el1/>;
            xml.appendChild(el)

            elements = xml.elements('el1')
            assertEquals(
                    elements.toXMLString(),
                    '<el1/>\n<el1/>', 'elements query should return 2 elements');
        }

        [Test]
        public function testDelete():void{
            XML.setSettings(XML.defaultSettings());
            XML.prettyPrinting = false;
            var xml:XML = <root name="foo"><baz name="baz1"/><baz name="baz2"/></root>;
            delete xml.@name;
            assertEquals(xml.toString(),'<root><baz name="baz1"/><baz name="baz2"/></root>',"name attribute should have been removed.");
            delete xml.baz[0];
            assertEquals(xml.toString(),'<root><baz name="baz2"/></root>',"the first baz element should have been removed.");
            xml = <root name="foo"><baz name="baz1"/><baz name="baz2"/></root>;
            delete xml.baz;
            // delete xml.baz[0];
            assertEquals(xml.toXMLString(),'<root name="foo"/>',"the first baz element should have been removed.");
            XML.setSettings(XML.defaultSettings());
        }

        [Test]
        public function testDynamicAttributes():void{
            var xml:XML = <xml myAtt1="test1" myAtt2="test2"/>;

            assertEquals(xml.attributes().length(),2, 'unexpected attributes count');
            const MYAtt:String = 'myAtt1';
            const MYAttTestVal:String = 'myAttTestVal';
            delete xml.@[MYAtt];
            assertEquals(xml.attributes().length(),1, 'unexpected attributes count');

            xml.@[MYAtt] = MYAttTestVal;
            assertEquals(xml.attributes().length(),2, 'unexpected attributes count');

            assertEquals(xml.@myAtt1,'myAttTestVal', 'unexpected attributes value');

        }


        [Test]
        public function testAppendChildContentTransfer():void{
            var source:XML = <source att='attribute'><dog/><cat/><rat/><pig/><cow/><hen/></source>;
            var sourceChildren:XMLList = source.children();
            var attList:XMLList = source.@att;
            var att:XML = attList[0];
            var orig1:XML = sourceChildren[0];
            var dest:XML = <dest/>;

            assertTrue(orig1.parent() === source, 'unexpected parent');
            assertTrue(att.parent() === source, 'unexpected parent');
            dest.appendChild(sourceChildren);
            //element was re-parented:
            assertFalse(orig1.parent() === source, 'unexpected parent');
            //attribute was not moved:
            assertTrue(att.parent() === source, 'unexpected parent');
            assertTrue(orig1.parent() === dest, 'unexpected parent');

            //at this point the actual nodes are present in both xml trees when iterating downwards,
            //but the 'parent()' evaluation only resolves to the latest parent
            //this is the swf behavior, but may not conform to standard

            assertEquals(source.toXMLString(),
                    '<source att="attribute">\n' +
                    '  <dog/>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    '</source>', 'unexpected source toXMLString')

            assertEquals(dest.toXMLString(),
                    '<dest>\n' +
                    '  <dog/>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    '</dest>', 'unexpected dest toXMLString')

            dest.appendChild(attList);
            //swf has a strange variation here:
            var appendedAtt1:String = isJS ? '  <att>attribute</att>\n' : '  <att xmlns="flexUnitTests.xml:XMLTesterGeneralTest">attribute</att>\n'

            assertEquals(dest.toXMLString(),
                    '<dest>\n' +
                    '  <dog/>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    appendedAtt1 +
                    '</dest>', 'unexpected dest toXMLString');

            dest.appendChild(att);

            assertEquals(dest.toXMLString(),
                    '<dest>\n' +
                    '  <dog/>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    appendedAtt1 +
                    '  attribute\n' +
                    '</dest>', 'unexpected dest toXMLString');


            dest.appendChild(orig1);


            //the source remains unchanged
            assertEquals(source.toXMLString(),
                    '<source att="attribute">\n' +
                    '  <dog/>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    '</source>', 'unexpected source toXMLString');

            //this is effectively a re-ordering inside dest
            var expected1:String =     '<dest>\n' +
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    appendedAtt1 +
                    '  attribute\n' +
                    '  <dog/>\n' +
                    '</dest>'

            var expected2:String = '<dest>\n' +
                    '  <dog/>\n' + //this seems to be the case in standalone debug player
                    '  <cat/>\n' +
                    '  <rat/>\n' +
                    '  <pig/>\n' +
                    '  <cow/>\n' +
                    '  <hen/>\n' +
                    appendedAtt1 +
                    '  attribute\n' +
                    '  <dog/>\n' +
                    '</dest>'


            var actual:String = dest.toXMLString();

            assertTrue(actual==expected1 || actual==expected2
                   , 'unexpected dest toXMLString');

        }


        [Test]
        public function testAssignXMLListVariants():void{
            var xmlList:XMLList = new XMLList();
            var xml:XML = <root><foo/></root>;
            xml.foobaz = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foo/>\n' +
                    '</root>', 'unexpected empty XMLList assignment');
            xmlList = new XMLList('<foobazzer/><foobazzer/>');
            xml.foobaz = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foo/>\n' +
                    '  <foobazzer/>\n' +
                    '  <foobazzer/>\n' +
                    '</root>', 'unexpected  XMLList assignment');

            xml = <root><foo/><foobaz/><foobaz/></root>;
            xml.foobaz = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foo/>\n' +
                    '  <foobazzer/>\n' +
                    '  <foobazzer/>\n' +
                    '</root>', 'unexpected  XMLList assignment');

            xml = <root><foobaz/><foobaz/><foo/></root>;

            xml.foobaz = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foobazzer/>\n' +
                    '  <foobazzer/>\n' +
                    '  <foo/>\n' +
                    '</root>', 'unexpected  XMLList assignment');


            xml =<root><foo/><foobaz/><foo/><foobaz/><foo/></root>;
            xml.foobaz = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foo/>\n' +
                    '  <foobazzer/>\n' +
                    '  <foobazzer/>\n' +
                    '  <foo/>\n' +
                    '  <foo/>\n' +
                    '</root>', 'unexpected  XMLList assignment');


            xmlList = new XMLList();
            xml.foobazzer = xmlList;
            assertEquals(xml.toXMLString(), '<root>\n' +
                    '  <foo/>\n' +
                    '  <foo/>\n' +
                    '  <foo/>\n' +
                    '</root>', 'unexpected  XMLList assignment')
        }
        
        //@todo - Passes in Swf, fails in browser:
        /*[Test]
        public function checkNumericAttributeSupported():void{
            var xml:XML = XML('<test 1="23"/>');
            assertEquals(xml.toXMLString(), '<test 1="23"/>', 'roundtripping with numeric attributes did not work');
        }*/
    }
}
