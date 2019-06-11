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
    public class XMLTesterStringifyTest
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
        public function testPrettyPrintingSimple():void
        {
            var originalIndent:uint = XML.prettyIndent;
            var originalPretty:Boolean = XML.prettyPrinting;
            XML.prettyIndent = 2;
            XML.prettyPrinting = true;
            var xml:XML = <xml><item/></xml>;
            
            Assert.assertEquals('Error in pretty Printing', xml.toXMLString(), '<xml>\n  <item/>\n</xml>');
            XML.prettyIndent = 4;
            Assert.assertEquals('Error in pretty Printing', xml.toXMLString(), '<xml>\n    <item/>\n</xml>');
            XML.prettyIndent = 0;
            Assert.assertEquals('Error in pretty Printing', xml.toXMLString(), '<xml>\n<item/>\n</xml>');
    
            XML.prettyIndent = originalIndent;
            XML.prettyPrinting = originalPretty;
            
        }
    
        [Test]
        public function testToStringVariants():void{
            var ampXML:XML = new XML("<Content>Bat & Ball</Content>");
            var amp2XML:XML = new XML("<Content>Bat &amp; Ball</Content>");
            Assert.assertEquals('ampersand entities are output with toXMLString', ampXML.toXMLString(),'<Content>Bat &amp; Ball</Content>');
            Assert.assertEquals('ampersand entities are output with toXMLString', amp2XML.toXMLString(),'<Content>Bat &amp; Ball</Content>');
            Assert.assertEquals('ampersand entities are not output with toString', ampXML.toString(),'Bat & Ball');
            Assert.assertEquals('ampersand entities are not output with toString', amp2XML.toString(),'Bat & Ball');
        
        }
        
        
        [Test]
        [TestVariance(variance="JS",description="Some browsers can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testStringifyAdvanced():void{
            XML.ignoreWhitespace = true;
            XML.prettyPrinting = false;
            var content:XML = new XML(
                    '<root>' +
                    '	<content><![CDATA[<?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>' +
                    '<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        ">' +
                    '   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">' +
                    '      <rdf:Description rdf:about=""/>' +
                    '   </rdf:RDF>' +
                    '</x:xmpmeta>' +
                    '<?xpacket end="r"?>]'+']></content>' +
                    '</root>');
            var contentStr:String = content.toXMLString();
            var correctStr:String = '<root><content><![CDATA[<?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?><x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        ">   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">      <rdf:Description rdf:about=""/>   </rdf:RDF></x:xmpmeta><?xpacket end="r"?>]'+']></content></root>';
    
            Assert.assertEquals('testStringifyAdvanced 1:content.toXMLString() was incorrect',correctStr, contentStr);
    
    
            Assert.assertEquals('testStringifyAdvanced 1:content.toXMLString() was incorrect',correctStr, content.toXMLString());
            
            content = <Document>
                <?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
                <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        ">
                    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                        <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" rdf:about="">
                            <dc:format>application/x-indesign</dc:format>
                        </rdf:Description>
                        <rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:xmpGImg="http://ns.adobe.com/xap/1.0/g/img/" rdf:about="">
                            <xmp:CreatorTool>Adobe InDesign CS6 (Windows)</xmp:CreatorTool>
                            <xmp:CreateDate>2018-02-19T09:17:41Z</xmp:CreateDate>
                            <xmp:MetadataDate>2018-02-19T09:17:41Z</xmp:MetadataDate>
                            <xmp:ModifyDate>2018-02-19T09:17:41Z</xmp:ModifyDate>
                            <xmp:Thumbnails>
                                <rdf:Alt>
                                    <rdf:li rdf:parseType="Resource">
                                        <xmpGImg:format>JPEG</xmpGImg:format>
                                        <xmpGImg:width>512</xmpGImg:width>
                                        <xmpGImg:height>512</xmpGImg:height>
                                        <xmpGImg:image>FOO</xmpGImg:image>
                                    </rdf:li>
                                </rdf:Alt>
                            </xmp:Thumbnails>
                        </rdf:Description>
                    </rdf:RDF>
                </x:xmpmeta>
                <?xpacket end="r"?>
            </Document>;
            
            
            contentStr = content.toXMLString();
            //RoyaleUnitTestRunner.consoleOut(contentStr);
            var expected:String =  '<Document><x:xmpmeta x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        " xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:format>application/x-indesign</dc:format></rdf:Description><rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:xmpGImg="http://ns.adobe.com/xap/1.0/g/img/"><xmp:CreatorTool>Adobe InDesign CS6 (Windows)</xmp:CreatorTool><xmp:CreateDate>2018-02-19T09:17:41Z</xmp:CreateDate><xmp:MetadataDate>2018-02-19T09:17:41Z</xmp:MetadataDate><xmp:ModifyDate>2018-02-19T09:17:41Z</xmp:ModifyDate><xmp:Thumbnails><rdf:Alt><rdf:li rdf:parseType="Resource"><xmpGImg:format>JPEG</xmpGImg:format><xmpGImg:width>512</xmpGImg:width><xmpGImg:height>512</xmpGImg:height><xmpGImg:image>FOO</xmpGImg:image></rdf:li></rdf:Alt></xmp:Thumbnails></rdf:Description></rdf:RDF></x:xmpmeta></Document>';
            //IE and Edge:
            var alternate:String = '<Document><x:xmpmeta x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        " xmlns:x="adobe:ns:meta/"><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/"><dc:format>application/x-indesign</dc:format></rdf:Description><rdf:Description rdf:about="" xmlns:xmpGImg="http://ns.adobe.com/xap/1.0/g/img/" xmlns:xmp="http://ns.adobe.com/xap/1.0/"><xmp:CreatorTool>Adobe InDesign CS6 (Windows)</xmp:CreatorTool><xmp:CreateDate>2018-02-19T09:17:41Z</xmp:CreateDate><xmp:MetadataDate>2018-02-19T09:17:41Z</xmp:MetadataDate><xmp:ModifyDate>2018-02-19T09:17:41Z</xmp:ModifyDate><xmp:Thumbnails><rdf:Alt><rdf:li rdf:parseType="Resource"><xmpGImg:format>JPEG</xmpGImg:format><xmpGImg:width>512</xmpGImg:width><xmpGImg:height>512</xmpGImg:height><xmpGImg:image>FOO</xmpGImg:image></rdf:li></rdf:Alt></xmp:Thumbnails></rdf:Description></rdf:RDF></x:xmpmeta></Document>';
            
            Assert.assertTrue('testStringifyAdvanced 1:content.toXMLString() was incorrect',
                    (contentStr == expected) || (contentStr == alternate));
    

        }
        
        [Test]
        public function testCDATA():void{
            var script:XML = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;

            Assert.assertEquals('unexpected toXMLString with child CDATA',
                    '<script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>',
                    script.toXMLString())
        }
        

        
    }
}
