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
    
    
    import flexunit.framework.Assert;
    
    import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLTesterGeneralTest
    {
        public static var isJS:Boolean = COMPILE::JS;
        
        private var xmlStr:String;
        
        private var quotedXML:XML;
        
        private var xml:XML;
        private var text:String;
        private var xml2:XML;
        
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
        
        [After]
        public function tearDown():void
        {
            xmlStr = null;
            quotedXML = null;
            xml = null;
            text = null;
            xml2 = null;
            
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
        public function testSimpleAttributes():void
        {
            
            var xml1:XML = <foo baz="true"/>;
            Assert.assertTrue('<foo baz="true"/> should have attribute @baz', xml1.hasOwnProperty("@baz"));
            Assert.assertFalse('<foo baz="true"/> should not have attribute @foo', xml1.hasOwnProperty("@foo"));
            Assert.assertFalse('<foo baz="true"/> should not have attribute baz', xml1.hasOwnProperty("baz"));
            Assert.assertTrue('<foo baz="true"/> toXMLString should be <foo baz="true"/>', xml1.toXMLString() == '<foo baz="true"/>');
            
            Assert.assertTrue('xml1.@baz.toString() should be "true"', xml1.@baz.toString() == 'true');
    
            var baz:XMLList = xml1.@baz;
            Assert.assertTrue('baz.toString() should be "true"', baz.toString() == 'true');
            Assert.assertEquals('baz.length() should be 1', baz.length(),1);
            var xml3:XML = <root/>;
            xml3.bar.baz = "baz";
            xml3.foo.@boo = "boo";
    
            Assert.assertEquals('xml3.bar.baz should be "baz"', xml3.bar.baz,'baz');
            Assert.assertEquals('xml3.foo.@boo should be "boo"', xml3.foo.@boo,'boo');

        }
        
       
        
        
        [Test]
        public function testSimpleXMLList():void
        {
            var xml1:XML = <foo baz="true"/>;
            
            Assert.assertTrue('toString value should be "true" ', xml1.@baz.toString() == "true");
            var xml3:XML = <root/>;
            xml3.bar.baz = "baz";
            xml3.foo.@boo = "boo";

            Assert.assertEquals('toString value should be "baz" ', xml3.bar.baz.toString(), "baz");
            Assert.assertEquals('toString value should be "boo" ', xml3.foo.@boo.toString(), "boo");
            
            var newContent:XML = <Content/>;
            newContent.Properties.Leading.@type = "string";
            newContent.Properties.Leading = 36;
            
            Assert.assertEquals("Leading should be @type=string", newContent.Properties.Leading.@type, "string");
            Assert.assertStrictlyEquals("Leading should be 36", newContent.Properties.Leading.toString(), "36");
            Assert.assertStrictlyEquals("unexpected toXMLString() value",
                    newContent.toXMLString(),
                    "<Content>\n" +
                    "  <Properties>\n" +
                    "    <Leading type=\"string\">36</Leading>\n" +
                    "  </Properties>\n" +
                    "</Content>");

            newContent.Properties.Leading = 72;
            Assert.assertStrictlyEquals("Leading should be 72", newContent.Properties.Leading.toString(), "72");
            
        }
        
        
        [Test]
        public function testXMLMethods1():void
        {
            var xml1:XML = <foo baz="true"/>;
            var child:XML = <pop><child name="Sam"/></pop>;
            xml1.appendChild(child);
            child = <pop><child name="George"/></pop>;
            xml1.appendChild(child);
            
            Assert.assertTrue('unexpected child result', xml1.pop[0].child.@name.toString() == 'Sam');
            Assert.assertTrue('unexpected child result', xml1.pop[1].child.@name.toString() == 'George');
            
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
            Assert.assertEquals('unexpected output with xml1.pop[0].toString()',
                    xml1.pop[0].toString(),
                    '<pop>\n' +
                    '  <child name="Sam"/>\n' +
                    '</pop>');
            Assert.assertEquals('unexpected output with xml1.pop[1].toString()',
                    xml1.pop[1].toString(),
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>');
            

            var pop:XMLList = xml1.pop;
            pop[pop.length()] = <pop>
                                    <child name="Fred"/>
                                </pop>;

            Assert.assertEquals('unexpected output with pop.toString()',
                    pop.toString(),
                    '<pop>\n' +
                    '  <child name="Sam"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>');
    
            Assert.assertEquals('unexpected output with xml1.toString()',
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
                    '</foo>');
            
            
            pop[0] =    <pop>
                            <child name="Fred"/>
                        </pop>;
    
            Assert.assertEquals('unexpected output with pop.toString()',
                    pop.toString(),
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="George"/>\n' +
                    '</pop>\n' +
                    '<pop>\n' +
                    '  <child name="Fred"/>\n' +
                    '</pop>');
    
            Assert.assertEquals('unexpected output with xml1.toString()',
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
                    '</foo>');
            
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
            
            Assert.assertEquals('unexpected output with xml1.toLocaleString()',
                    xml1.toLocaleString(),
                    expected);
            
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
    
            Assert.assertEquals('unexpected output with xml1.pop.toLocaleString()',
                    xml1.pop.toLocaleString(),
                    expected);

            
            var parentXML:XML = <parent/>;
            var childXML:XML = <child/>;
            parentXML.appendChild(childXML);
            Assert.assertTrue('child/parent relationship was unexpected', (childXML.parent() == parentXML));
            Assert.assertEquals('unexpected output following re-parenting',
                    parentXML.toXMLString(),
                    '<parent>\n' +
                    '  <child/>\n' +
                    '</parent>');
            
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
    
            Assert.assertEquals('unexpected output following re-parenting',
                    parentXML.toXMLString(),
                    expected);
    
            Assert.assertEquals('unexpected output following re-parenting',
                    newParent.toXMLString(),
                    '<newparent>\n' +
                    '  <child/>\n' +
                    '</newparent>');
            
            Assert.assertFalse('child/parent relationship was unexpected', (childXML.parent() == parentXML));
            
            var expectedLength:uint = getSwfVersion() < 21 ? 1 : 0;
            //another bug in old swf version, some 'remnant' of the old 'child' is still present in the'old' parent
            Assert.assertTrue('child/parent relationship was unexpected', (parentXML.children().length() == expectedLength));
            Assert.assertTrue('child/parent relationship was unexpected', (childXML.parent() == newParent));
            
            childXML = <Content>• <?ACE 7?>Some amazing content</Content>;
            var childXMLStr:String = childXML.text();

            Assert.assertEquals(" (should be) •Some amazing content", childXMLStr, '•Some amazing content');
        }
        [Test]
        public function testInvalidAppendChild():void{
            var root:XML = new XML('test');
            root.appendChild('test');
    
            Assert.assertEquals('testInvalidAppendChild 1 result is bad',root.toString(), 'test');
            Assert.assertEquals('testInvalidAppendChild 2 result is bad',root.toXMLString(), 'test');
        }
    
        [Test]
        public function testAppendNonXMLChild():void{
            var root:XML = <root/>;
            root.appendChild('test');
    
            Assert.assertEquals('testAppendNonXMLChild 1 result is bad',root.toString(), 'test');
            Assert.assertEquals('testAppendNonXMLChild 2 result is bad',root.toXMLString(), '<root>test</root>');
            
            root = <root><test><something/></test></root>;
            root.appendChild('test');
    
            Assert.assertEquals('testAppendNonXMLChild 3 result is bad',
                    root.toString(),
                    '<root>\n' +
                    '  <test>\n' +
                    '    <something/>\n' +
                    '  </test>\n' +
                    '  <test>test</test>\n' +
                    '</root>');
            
            Assert.assertEquals('testAppendNonXMLChild 4 result is bad',
                    root.toXMLString(),
                    '<root>\n' +
                    '  <test>\n' +
                    '    <something/>\n' +
                    '  </test>\n' +
                    '  <test>test</test>\n' +
                    '</root>');
            
        }
        
        
        [Test]
        public function testXMLNormalize():void{
            var xml:XML = <root/>;
            xml.appendChild("test1");
            xml.appendChild("test2");
            xml.appendChild(<element/>);
            xml.appendChild("test3");
            xml.appendChild("test4");
            
    
            Assert.assertEquals('testXMLNormalize 1 result is bad',
                    xml.toString(),
                    '<root>\n' +
                    '  test1\n' +
                    '  test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>');
    
            Assert.assertEquals('testXMLNormalize 2 result is bad',
                    xml.toXMLString(),
                    '<root>\n' +
                    '  test1\n' +
                    '  test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>');
            
   
            xml.normalize();
    
            Assert.assertEquals('testXMLNormalize 3 result is bad',
                    xml.toString(),
                    '<root>\n' +
                    '  test1test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>');
    
            Assert.assertEquals('testXMLNormalize 4 result is bad',
                    xml.toXMLString(),
                    '<root>\n' +
                    '  test1test2\n' +
                    '  <element/>\n' +
                    '  <element>test3</element>\n' +
                    '  <element>test4</element>\n' +
                    '</root>');

            
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
            
            Assert.assertTrue('string output was unexpected', rects.toXMLString() == expected);
        }
    
    
        [Test]
        public function testChildList():void{
            var xml:XML = <root> asdasdas <element/> asdasqdasd<otherElement/></root>;
    
    
            var list:XMLList = xml.*;
    
            //var list:XMLList = xml.child('*')
    
            Assert.assertEquals('Error in list length', 4, list.length());
            //trace(list.length());
            list = xml.element;
            Assert.assertEquals('Error in list length', 1, list.length());
            //list = xml.child('element')
    
           // trace(list.length())
            list = xml.otherElement;
            //list = xml.child('otherElement')
            Assert.assertEquals('Error in list length', 1, list.length());
        
        }
    
    
        [Test]
        public function testNamespaceRetrieval():void{
            var  content:XML = <Document>
                <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        " >
                </x:xmpmeta>
            </Document>;
        
            var namespace:Namespace = content.children()[0].namespace();
            Assert.assertEquals('Error in namespace prefix', namespace.prefix, 'x');
            Assert.assertEquals('Error in namespace uri', namespace.uri, 'adobe:ns:meta/');
        
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
            Assert.assertFalse('Unexpected Error state with duplicate namespace declarations', caughtError);
        
        }
    
        [Test]
        public function testDuplicateAttributesError():void{
            var caughtError:Boolean;
            try {
                var  content:XML = <root myVal="something" myVal="somethingElse"/>;
            } catch(e:Error) {
                caughtError = true;
            }
        
            Assert.assertTrue('Unexpected Error state with duplicate attribute declarations', caughtError);
        
        }
    
        [Test]
        public function testParsingWhitespaceSetting1():void{
            var originalSetting:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var script:XML = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;
    
            Assert.assertEquals('unexpected children number after parsing',1, script.children().length());
            Assert.assertEquals('unexpected toString value after parsing',
                    '<script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>', 
                    script.toXMLString());

            XML.ignoreWhitespace = false;
            script = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;
            Assert.assertEquals('unexpected children number after parsing',3, script.children().length());
            

            Assert.assertEquals('unexpected toString value after parsing',
                    '<script>\n' +
                    '  \n' +
                    '  <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>\n' +
                    '  \n' +
                    '</script>',
                    script.toXMLString());
            XML.ignoreWhitespace = originalSetting;
        }
        [Test]
        public function testSingleProcessingInstructions():void{
            var original:Boolean = XML.ignoreProcessingInstructions;
            XML.ignoreProcessingInstructions = true;
            var xml:XML = new XML('<?bar foo?>');
            Assert.assertEquals('unexpected nodeKind with XML.ignoreProcessingInstructions = true', 'text', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreProcessingInstructions = true', '', xml.toXMLString());
            XML.ignoreProcessingInstructions = false;
            xml = new XML('<?bar foo?>');
            Assert.assertEquals('unexpected nodeKind with XML.ignoreProcessingInstructions = false', 'processing-instruction', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreProcessingInstructions = false', '<?bar foo?>', xml.toXMLString());
    
            XML.ignoreProcessingInstructions = original;
        }
    
    
        [Test]
        public function testSingleCDATA():void{
            var original:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var xml:XML = new XML('   <![CDATA[ my cdata ]]>   ');
            Assert.assertEquals('unexpected cdata result with XML.ignoreWhitespace = true', 'text', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreWhitespace = true', '<![CDATA[ my cdata ]]>', xml.toXMLString());
            Assert.assertNull('unexpected name value with CDATA', xml.name());
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   <![CDATA[ my cdata ]]>   ');
            } catch(e:Error) {
                caughtError = true;
            }
            
            Assert.assertTrue('unexpected error status for single cdata string parsing with XML.ignoreWhitespace = false', caughtError);
        
            XML.ignoreWhitespace = original;
        }
    
    
        [Test]
        public function testSingleText():void{
            var original:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = true;
            var xml:XML = new XML('   my text   ');
            Assert.assertEquals('unexpected text result with XML.ignoreWhitespace = true', 'text', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreWhitespace = true', 'my text', xml.toXMLString());
            Assert.assertNull('unexpected name value with text', xml.name());
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   my text   ');
            } catch(e:Error) {
                caughtError = true;
            }
        
            Assert.assertFalse('unexpected error status for text string parsing with XML.ignoreWhitespace = false', caughtError);
            Assert.assertEquals('unexpected text result with XML.ignoreWhitespace = true', 'text', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreWhitespace = true', '   my text   ', xml.valueOf());
            XML.ignoreWhitespace = original;
        }
    
        [Test]
        public function testSingleComment():void{
            var original:Boolean = XML.ignoreWhitespace;
            var originalComments:Boolean = XML.ignoreComments;
            XML.ignoreWhitespace = true;
            XML.ignoreComments = false;
            var xml:XML = new XML('  <!-- my test comment -->  ');
            Assert.assertEquals('unexpected comment result with XML.ignoreWhitespace = true', 'comment', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreWhitespace = true', '<!-- my test comment -->', xml.toXMLString());
            Assert.assertNull('unexpected name value with text', xml.name());
            XML.ignoreWhitespace = false;
            var caughtError:Boolean = false;
            try {
                xml = new XML('   <!-- my test comment -->   ');
            } catch(e:Error) {
                caughtError = true;
            }
        
            Assert.assertTrue('unexpected error status for comment parsing with XML.ignoreWhitespace = false', caughtError);
    
            xml = new XML('<!-- my test comment -->');
            Assert.assertNull('unexpected name value with comment', xml.name());
            
            Assert.assertEquals('unexpected comment result with XML.ignoreWhitespace = true', 'comment', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreWhitespace = true', '<!-- my test comment -->', xml.toXMLString());
            XML.ignoreComments = true;
            xml = new XML('<!-- my test comment -->');
            Assert.assertNull('unexpected name value with text', xml.name());
    
            Assert.assertEquals('unexpected comment result with XML.ignoreComments = true', 'text', xml.nodeKind());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreComments = true', '', xml.toXMLString());
            
            
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
            Assert.assertEquals('unexpected comment result with XML.ignoreComments = false', 1, xml.children().length());

            Assert.assertEquals('unexpected toXMLString with XML.ignoreComments = false',
                    '<root>\n' +
                    '  <!-- my test comment -->\n' +
                    '</root>',
                    xml.toXMLString());
            Assert.assertNull('unexpected name value with comment', xml.children()[0].name());
            XML.ignoreComments = true;
            xml = new XML('<root><!-- my test comment --></root>');
            Assert.assertEquals('unexpected comment result with XML.ignoreComments = true', 0, xml.children().length());
            Assert.assertEquals('unexpected toXMLString with XML.ignoreComments = true', '<root/>', xml.toXMLString());
    
            XML.ignoreWhitespace = original;
            XML.ignoreComments = originalComments;
        }
        
        [Test]
        [TestVariance(variance="JS",description="Some browsers can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testLargeComplex():void{
            var xmlString:String = xml.toXMLString();
    
            var expected:String = '<catalog xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:dac="com.printui.view.components.DesignAreaComponents.*">\n' +
                    '  bla bla\n' +
                    '  <product description="Cardigan Sweater" product_image="cardigan.jpg">\n' +
                    '    <fx:catalog_item gender="Men\'s" fx:foo="bah">\n' +
                    '      <item_number>QWZ5671</item_number>\n' +
                    '      <price>39.95</price>\n' +
                    '      <size description="Medium">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Large">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '    </fx:catalog_item>\n' +
                    '    <script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>\n' +
                    '    <catalog_item gender="Women\'s">\n' +
                    '      <item_number>RRX9856</item_number>\n' +
                    '      <price>42.50</price>\n' +
                    '      <size description="Small">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Medium">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Large">\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Extra Large">\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '    </catalog_item>\n' +
                    '  </product>\n' +
                    '</catalog>';
    
            var alternate:String = '<catalog xmlns:dac="com.printui.view.components.DesignAreaComponents.*" xmlns:fx="http://ns.adobe.com/mxml/2009">\n' +
                    '  bla bla\n' +
                    '  <product product_image="cardigan.jpg" description="Cardigan Sweater">\n' +
                    '    <fx:catalog_item fx:foo="bah" gender="Men\'s">\n' +
                    '      <item_number>QWZ5671</item_number>\n' +
                    '      <price>39.95</price>\n' +
                    '      <size description="Medium">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Large">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '    </fx:catalog_item>\n' +
                    '    <script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>\n' +
                    '    <catalog_item gender="Women\'s">\n' +
                    '      <item_number>RRX9856</item_number>\n' +
                    '      <price>42.50</price>\n' +
                    '      <size description="Small">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Medium">\n' +
                    '        <color_swatch image="red_cardigan.jpg">Red</color_swatch>\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Large">\n' +
                    '        <color_swatch image="navy_cardigan.jpg">Navy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '      <size description="Extra Large">\n' +
                    '        <color_swatch image="burgundy_cardigan.jpg">Burgundy</color_swatch>\n' +
                    '        <color_swatch image="black_cardigan.jpg">Black</color_swatch>\n' +
                    '      </size>\n' +
                    '    </catalog_item>\n' +
                    '  </product>\n' +
                    '</catalog>';

            //RoyaleUnitTestRunner.consoleOut('testLargeComplex is alternate:\n' + (xmlString == alternate));
            
            //IE and MS Edge: inlcude alternate output check
            //account for variation in output order of attributes and namespace declarations (from native DOMParser)
            Assert.assertTrue('unexpected complex stringify results',  xmlString == expected || xmlString == alternate);
        }
    }
}
