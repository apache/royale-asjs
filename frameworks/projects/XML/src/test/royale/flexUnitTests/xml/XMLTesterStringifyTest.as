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
            
            assertEquals( xml.toXMLString(), '<xml>\n  <item/>\n</xml>', 'Error in pretty Printing');
            XML.prettyIndent = 4;
            assertEquals( xml.toXMLString(), '<xml>\n    <item/>\n</xml>', 'Error in pretty Printing');
            XML.prettyIndent = 0;
            assertEquals( xml.toXMLString(), '<xml>\n<item/>\n</xml>', 'Error in pretty Printing');
    
            XML.prettyIndent = originalIndent;
            XML.prettyPrinting = originalPretty;
            
        }
    
        [Test]
        public function testToStringVariants():void{
            var ampXML:XML = new XML("<Content>Bat & Ball</Content>");
            var amp2XML:XML = new XML("<Content>Bat &amp; Ball</Content>");
            assertEquals( ampXML.toXMLString(),'<Content>Bat &amp; Ball</Content>', 'ampersand entities are output with toXMLString');
            assertEquals(amp2XML.toXMLString(),'<Content>Bat &amp; Ball</Content>', 'ampersand entities are output with toXMLString');
            assertEquals( ampXML.toString(),'Bat & Ball', 'ampersand entities are not output with toString');
            assertEquals( amp2XML.toString(),'Bat & Ball', 'ampersand entities are not output with toString');
        
        }
        
        
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
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
    
            assertEquals(correctStr, contentStr, 'testStringifyAdvanced 1:content.toXMLString() was incorrect');
    
    
            assertEquals(correctStr, content.toXMLString(), 'testStringifyAdvanced 1:content.toXMLString() was incorrect');
            
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
            
            assertTrue(
                    (contentStr == expected) || (contentStr == alternate), 'testStringifyAdvanced 1:content.toXMLString() was incorrect');
    

        }
    
        [Test]
        public function stringifyAdvanced2():void{
            XML.ignoreProcessingInstructions = true;
            var xmlSource:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n' +
                    '<?aid style="50" type="snippet" readerVersion="6.0" featureSet="257" product="14.0(209)" ?>\n' +
                    '<?aid SnippetType="PageItem"?>\n' +
                    '<Document LinkedSpreads="undefined" DOMVersion="14.0" Self="d">\n' +
                    '\t<Color Self="Color/Black" Model="Process" Space="CMYK" ColorValue="0 0 0 100" ColorOverride="Specialblack" AlternateSpace="NoAlternateColor" AlternateColorValue="" Name="Black" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch3" />\n' +
                    '\t<Swatch Self="Swatch/None" Name="None" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch0" />\n' +
                    '\t<Str Self="Str/$ID/Solid" Name="$ID/Solid" />\n' +
                    '\t<RCS Self="u77">\n' +
                    '\t\t<CharacterStyle Self="CharacterStyle/$ID/[No character style]" Imported="false" Spl="false" EmitCss="true" StyleUniqueId="$ID/" IncludeClass="true" Name="$ID/[No character style]" />\n' +
                    '\t</RCS>\n' +
                    '\t<Nu Self="Nu/$ID/[Default]" Name="$ID/[Default]" ContinueNumbersAcrossStories="false" ContinueNumbersAcrossDocuments="false" />\n' +
                    '\t<RootParagraphStyleGroup Self="u76">\n' +
                    '\t\t\n' +
                    '\t\t\n' +
                    '\t</RootParagraphStyleGroup>\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t<Story Self="u180" UserText="true" IsEndnoteStory="false" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n">\n' +
                    '\t\t<StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection" />\n' +
                    '\t\t<InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false" />\n' +
                    '\t\t<ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">\n' +
                    '\t\t\t<CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" PointSize="20">\n' +
                    '\t\t\t\t<Content>a</Content>\n' +
                    '\t\t\t\t<Br />\n' +
                    '\t\t\t\t<Content>s who work on the tickes.</Content>\n' +
                    '\t\t\t</CharacterStyleRange>\n' +
                    '\t\t</ParagraphStyleRange>\n' +
                    '\t</Story>\n' +
                    '\t<ColorGroup Self="ColorGroup/[Root Color Group]" Name="[Root Color Group]" IsRootColorGroup="true">\n' +
                    '\t\t<ColorGroupSwatch Self="u223ColorGroupSwatch0" SwatchItemRef="Swatch/None" />\n' +
                    '\t\t<ColorGroupSwatch Self="u223ColorGroupSwatch3" SwatchItemRef="Color/Black" />\n' +
                    '\t</ColorGroup>\n' +
                    '</Document>';
            
            var xml:XML = new XML(xmlSource);
        
            
            var expected:String = '<Document LinkedSpreads="undefined" DOMVersion="14.0" Self="d">\n' +
                    '  <Color Self="Color/Black" Model="Process" Space="CMYK" ColorValue="0 0 0 100" ColorOverride="Specialblack" AlternateSpace="NoAlternateColor" AlternateColorValue="" Name="Black" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch3"/>\n' +
                    '  <Swatch Self="Swatch/None" Name="None" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch0"/>\n' +
                    '  <Str Self="Str/$ID/Solid" Name="$ID/Solid"/>\n' +
                    '  <RCS Self="u77">\n' +
                    '    <CharacterStyle Self="CharacterStyle/$ID/[No character style]" Imported="false" Spl="false" EmitCss="true" StyleUniqueId="$ID/" IncludeClass="true" Name="$ID/[No character style]"/>\n' +
                    '  </RCS>\n' +
                    '  <Nu Self="Nu/$ID/[Default]" Name="$ID/[Default]" ContinueNumbersAcrossStories="false" ContinueNumbersAcrossDocuments="false"/>\n' +
                    '  <RootParagraphStyleGroup Self="u76"/>\n' +
                    '  <Story Self="u180" UserText="true" IsEndnoteStory="false" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n">\n' +
                    '    <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/>\n' +
                    '    <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>\n' +
                    '    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">\n' +
                    '      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" PointSize="20">\n' +
                    '        <Content>a</Content>\n' +
                    '        <Br/>\n' +
                    '        <Content>s who work on the tickes.</Content>\n' +
                    '      </CharacterStyleRange>\n' +
                    '    </ParagraphStyleRange>\n' +
                    '  </Story>\n' +
                    '  <ColorGroup Self="ColorGroup/[Root Color Group]" Name="[Root Color Group]" IsRootColorGroup="true">\n' +
                    '    <ColorGroupSwatch Self="u223ColorGroupSwatch0" SwatchItemRef="Swatch/None"/>\n' +
                    '    <ColorGroupSwatch Self="u223ColorGroupSwatch3" SwatchItemRef="Color/Black"/>\n' +
                    '  </ColorGroup>\n' +
                    '</Document>';
            
            var outString:String = xml.toString();

            //RoyaleUnitTestRunner.consoleOut('stringifyAdvanced2:\n' + outString );
            
            //the order of toString output can be quite different for some browsers, but the length should be identical
            assertTrue( outString.length == expected.length, 'unexpected toString result');
        }
    
        [Test]
        public function stringifyAdvanced3():void{
            //AS3 XML ignores processing instructions outside the root tag, even when it is told not to
            //This is (I think) because there is no concept of a 'Document' level XML that is different to a regular XML node
            XML.ignoreProcessingInstructions = false;
            var xmlSource:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n' +
                    '<?aid style="50" type="snippet" readerVersion="6.0" featureSet="257" product="14.0(209)" ?>\n' +
                    '<?aid SnippetType="PageItem"?>\n' +
                    '<Document LinkedSpreads="undefined" DOMVersion="14.0" Self="d">\n' +
                    '\t<Color Self="Color/Black" Model="Process" Space="CMYK" ColorValue="0 0 0 100" ColorOverride="Specialblack" AlternateSpace="NoAlternateColor" AlternateColorValue="" Name="Black" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch3" />\n' +
                    '\t<Swatch Self="Swatch/None" Name="None" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch0" />\n' +
                    '\t<Str Self="Str/$ID/Solid" Name="$ID/Solid" />\n' +
                    '\t<RCS Self="u77">\n' +
                    '\t\t<CharacterStyle Self="CharacterStyle/$ID/[No character style]" Imported="false" Spl="false" EmitCss="true" StyleUniqueId="$ID/" IncludeClass="true" Name="$ID/[No character style]" />\n' +
                    '\t</RCS>\n' +
                    '\t<Nu Self="Nu/$ID/[Default]" Name="$ID/[Default]" ContinueNumbersAcrossStories="false" ContinueNumbersAcrossDocuments="false" />\n' +
                    '\t<RootParagraphStyleGroup Self="u76">\n' +
                    '\t\t\n' +
                    '\t\t\n' +
                    '\t</RootParagraphStyleGroup>\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t\n' +
                    '\t<Story Self="u180" UserText="true" IsEndnoteStory="false" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n">\n' +
                    '\t\t<StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection" />\n' +
                    '\t\t<InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false" />\n' +
                    '\t\t<ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">\n' +
                    '\t\t\t<CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" PointSize="20">\n' +
                    '\t\t\t\t<Content>a</Content>\n' +
                    '\t\t\t\t<Br />\n' +
                    '\t\t\t\t<Content>s who work on the tickes.</Content>\n' +
                    '\t\t\t</CharacterStyleRange>\n' +
                    '\t\t</ParagraphStyleRange>\n' +
                    '\t</Story>\n' +
                    '\t<ColorGroup Self="ColorGroup/[Root Color Group]" Name="[Root Color Group]" IsRootColorGroup="true">\n' +
                    '\t\t<ColorGroupSwatch Self="u223ColorGroupSwatch0" SwatchItemRef="Swatch/None" />\n' +
                    '\t\t<ColorGroupSwatch Self="u223ColorGroupSwatch3" SwatchItemRef="Color/Black" />\n' +
                    '\t</ColorGroup>\n' +
                    '</Document>';
        
            var xml:XML = new XML(xmlSource);
            XML.ignoreProcessingInstructions = true;

            var outString:String = xml.toString();
            var expected:String = '<Document LinkedSpreads="undefined" DOMVersion="14.0" Self="d">\n' +
                    '  <Color Self="Color/Black" Model="Process" Space="CMYK" ColorValue="0 0 0 100" ColorOverride="Specialblack" AlternateSpace="NoAlternateColor" AlternateColorValue="" Name="Black" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch3"/>\n' +
                    '  <Swatch Self="Swatch/None" Name="None" ColorEditable="false" ColorRemovable="false" Visible="true" SwatchCreatorID="7937" SwatchColorGroupReference="u223ColorGroupSwatch0"/>\n' +
                    '  <Str Self="Str/$ID/Solid" Name="$ID/Solid"/>\n' +
                    '  <RCS Self="u77">\n' +
                    '    <CharacterStyle Self="CharacterStyle/$ID/[No character style]" Imported="false" Spl="false" EmitCss="true" StyleUniqueId="$ID/" IncludeClass="true" Name="$ID/[No character style]"/>\n' +
                    '  </RCS>\n' +
                    '  <Nu Self="Nu/$ID/[Default]" Name="$ID/[Default]" ContinueNumbersAcrossStories="false" ContinueNumbersAcrossDocuments="false"/>\n' +
                    '  <RootParagraphStyleGroup Self="u76"/>\n' +
                    '  <Story Self="u180" UserText="true" IsEndnoteStory="false" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n">\n' +
                    '    <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/>\n' +
                    '    <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>\n' +
                    '    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">\n' +
                    '      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]" PointSize="20">\n' +
                    '        <Content>a</Content>\n' +
                    '        <Br/>\n' +
                    '        <Content>s who work on the tickes.</Content>\n' +
                    '      </CharacterStyleRange>\n' +
                    '    </ParagraphStyleRange>\n' +
                    '  </Story>\n' +
                    '  <ColorGroup Self="ColorGroup/[Root Color Group]" Name="[Root Color Group]" IsRootColorGroup="true">\n' +
                    '    <ColorGroupSwatch Self="u223ColorGroupSwatch0" SwatchItemRef="Swatch/None"/>\n' +
                    '    <ColorGroupSwatch Self="u223ColorGroupSwatch3" SwatchItemRef="Color/Black"/>\n' +
                    '  </ColorGroup>\n' +
                    '</Document>';
            //RoyaleUnitTestRunner.consoleOut('stringifyAdvanced3:\n' + outString);
    
            //the order of toString output can be quite different for some browsers, but the length should be identical
            assertTrue( outString.length == expected.length, 'unexpected toString result');
        }
        
        
        [Test]
        public function testCDATA():void{
            var script:XML = <script>   <![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]>  </script>;

            assertEquals(
                    '<script><![CDATA[private function onStylesLoaded(ev:Event):void {currentState = "normal";facade = ApplicationFacade.getInstance();facade.notifyObservers(new Notification(ApplicationFacade.CMD_STARTUP, this));}  ]]></script>',
                    script.toXMLString(), 'unexpected toXMLString with child CDATA')
        }
    
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testDeclarationOrder():void{
            var xml:XML = <root xmlns:also="def" xmlns="def"><child/></root>;
            var check:String = xml.children().toXMLString();
            var options:Array = ['<also:child xmlns:also="def" xmlns="def"/>','<child xmlns="def" xmlns:also="def"/>'];
            if (options.indexOf(check) != 0) {
                trace('testDeclarationOrder: this browser does not conform to swf behavior')
                //RoyaleUnitTestRunner.consoleOut('testDeclarationOrder:0 this browser does not conform to swf behavior')
            }
            assertTrue(
                    options.indexOf(check) != -1, 'unexpected toXMLString with declaration order')
    
            xml = <root xmlns="def" xmlns:also="def"><child/></root>;
            check = xml.children().toXMLString();
            if (options.indexOf(check) != 1) {
                trace('testDeclarationOrder: this browser does not conform to swf behavior')
                //RoyaleUnitTestRunner.consoleOut('testDeclarationOrder:1 this browser does not conform to swf behavior')
            }
            assertTrue(
                    options.indexOf(check) != -1, 'unexpected toXMLString content')
    
        }
        
    }
}
