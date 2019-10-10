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
    
   // import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLTesterNamespaceQueries
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
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function minimalTest():void{
            var feed:XML = new XML(
                    '<feed xmlns:atom="http://www.w3.org/2005/Atom" xmlns:m="nothing">\n' +
                    '  <link rel="no_namespace" href="blah/12321/domain/"/>\n' +
                    '</feed>\n');
            
            var atomSpace:Namespace = new Namespace('http://www.w3.org/2005/Atom');
            var atom:XMLList = feed.child(new QName('http://www.w3.org/2005/Atom','link'));
            assertEquals(atom[0].name().uri,'', 'unexpected uri (should be empty)');
            //IE11... order is different:
            //assertEquals(atom.toXMLString(),'<link rel="no_namespace" href="blah/12321/domain/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:m="nothing"/>', 'unexpected content');
            assertEquals(atom.toXMLString().length,111, 'unexpected content');
            
            atom = feed.atomSpace::link;
            assertEquals(atom.length(),0, 'unexpected query result');
            
    
            atom = feed.child(new QName(atomSpace,'link'));
            assertEquals(atom[0].name().uri,'', 'unexpected uri (should be empty)');
            //IE11... order is different:
            //assertEquals(atom.toXMLString(),'<link rel="no_namespace" href="blah/12321/domain/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:m="nothing"/>', 'unexpected content');
            assertEquals(atom.toXMLString().length,111, 'unexpected content');
            
            
            atom = feed.child(atomSpace);
            assertEquals(atom.length(),0, 'unexpected query result');
            
        }
    
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testNamespace():void{
                var xml:XML = <test xmlns='testingspace' xmlns:other='otherspace'>
                    <child att='child:testingspace_attvalue' other:att='child:otherspace_attvalue' original="child"/>
                    <other:child att='other:child:testingspace_attvalue' other:att='other:child:otherspace_attvalue' original="other:child"/>
                </test>;
            
            assertEquals(xml.child.length(),0, 'unexpected child query length');
            assertEquals(xml.child.@att.length(),0, 'unexpected child att query length');
    
            default xml namespace ='testingspace';
    
            assertEquals(xml.child.length(),1, 'unexpected child query length');
            //IE11... order is different:
            //assertEquals(xml.child.toXMLString(),'<child att="child:testingspace_attvalue" other:att="child:otherspace_attvalue" original="child" xmlns="testingspace" xmlns:other="otherspace"/>', 'unexpected child query content');
            assertEquals(xml.child.toXMLString().length,143, 'unexpected child query content');
    
            assertEquals(xml.child.@att.length(),1, 'unexpected child att query length');
            assertEquals(xml.child.@att.toXMLString(),'child:testingspace_attvalue', 'unexpected child att query content');
            var ns:Namespace = new Namespace('otherspace');
            //IE11... order is different:
            //assertEquals(xml.ns::child.toXMLString(),'<other:child att="other:child:testingspace_attvalue" other:att="other:child:otherspace_attvalue" original="other:child" xmlns="testingspace" xmlns:other="otherspace"/>', 'unexpected child query content');
            assertEquals(xml.ns::child.toXMLString().length,167, 'unexpected child query content');
    
            assertEquals(xml.ns::child.@att.toXMLString(),'other:child:testingspace_attvalue', 'unexpected child att query content');
            
            assertEquals(xml.child.@ns::att.toXMLString(),'child:otherspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.ns::child.@ns::att.toXMLString(),'other:child:otherspace_attvalue', 'unexpected child att query content');
            default xml namespace ='otherspace';
    
            assertEquals(xml.child.@ns::att.toXMLString(),'other:child:otherspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.child.length(),1, 'unexpected child query length');
            //IE11... order is different:
            //assertEquals(xml.child.toXMLString(),'<other:child att="other:child:testingspace_attvalue" other:att="other:child:otherspace_attvalue" original="other:child" xmlns="testingspace" xmlns:other="otherspace"/>', 'unexpected child query content');
            assertEquals(xml.child.toXMLString().length,167, 'unexpected child query content');
    
    
            /* RoyaleUnitTestRunner.consoleOut('--');
             RoyaleUnitTestRunner.consoleOut(xml.child.toXMLString());
             RoyaleUnitTestRunner.consoleOut('--');
             RoyaleUnitTestRunner.consoleOut(xml.child.@att.toXMLString());*/
           
            assertEquals(xml.child.@att.length(),2, 'unexpected child att query length');
            //IE11... order is different:
            //assertEquals(xml.child.@att.toXMLString(),'other:child:testingspace_attvalue\n' +'other:child:otherspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.child.@att.toXMLString().length,65, 'unexpected child att query content');
    
        }
    
        [Test]
        [TestVariance(variance="JS",description="Some browsers (IE11/Edge legacy) can parse to a different order of attributes and namespace declarations (which affects stringified content comparisons)")]
        public function testNamespace2():void{
            var xml:XML = <test xmlns='testingspace' xmlns:other='otherspace' xmlns:also="testingspace">
                <child att='child:testingspace_attvalue' other:att='child:otherspace_attvalue' original="child"/>
                <other:child att='other:child:testingspace_attvalue' other:att='other:child:otherspace_attvalue' original="other:child"/>
                <also:child att='also:child:testingspace_attvalue' also:att='also:child:testingspace_attvalue' other:att='also:child:otherspace_attvalue' original="also:child"/>
            </test>;
            assertEquals(xml.child.length(),0, 'xml.child.length()');
            assertEquals(xml.child.@att.length(),0, 'xml.child.@att.length()');
            
            
         /*   RoyaleUnitTestRunner.consoleOut(xml.children()[2].toXMLString());
            RoyaleUnitTestRunner.consoleOut(xml.toXMLString());
            RoyaleUnitTestRunner.consoleOut("------");*/
            
            //IE11/Edge issues
            /*assertEquals(xml.toXMLString(),'<test xmlns="testingspace" xmlns:other="otherspace" xmlns:also="testingspace">\n' +
                    '  <child att="child:testingspace_attvalue" other:att="child:otherspace_attvalue" original="child"/>\n' +
                    '  <other:child att="other:child:testingspace_attvalue" other:att="other:child:otherspace_attvalue" original="other:child"/>\n' +
                    '  <child att="also:child:testingspace_attvalue" att="also:child:testingspace_attvalue" other:att="also:child:otherspace_attvalue" original="also:child"/>\n' +
                    '</test>', 'unexpected strinfification');*/
            assertEquals(xml.toXMLString().length,464, 'unexpected strinfgification');
    
            //change to default ns:
            default xml namespace ='testingspace';
            
            assertEquals(xml.child.length(),2, 'unexpected child query length');
            //IE11/Edge issues
           /* assertEquals(xml.child.toXMLString(),'<child att="child:testingspace_attvalue" other:att="child:otherspace_attvalue" original="child" xmlns="testingspace" xmlns:other="otherspace" xmlns:also="testingspace"/>\n' +
                    '<child att="also:child:testingspace_attvalue" att="also:child:testingspace_attvalue" other:att="also:child:otherspace_attvalue" original="also:child" xmlns="testingspace" xmlns:other="otherspace" xmlns:also="testingspace"/>', 'unexpected child query content');*/
            assertEquals(xml.child.toXMLString().length,393, 'unexpected child query content');
    
    
            assertEquals(xml.child.@att.length(),3, 'unexpected child att query length');
            assertEquals(xml.child.@att.toXMLString(),'child:testingspace_attvalue\n' +
                    'also:child:testingspace_attvalue\n' +
                    'also:child:testingspace_attvalue', 'unexpected child att query content');
            
            //use specific ns
            var ns:Namespace = new Namespace('otherspace');
            //IE11/Edge issue:
            /*assertEquals(xml.ns::child.toXMLString(),'<other:child att="other:child:testingspace_attvalue" other:att="other:child:otherspace_attvalue" original="other:child" xmlns="testingspace" xmlns:other="otherspace" xmlns:also="testingspace"/>', 'unexpected child query content');*/
            assertEquals(xml.ns::child.toXMLString().length,193, 'unexpected child query content');
            
            assertEquals(xml.ns::child.@att.toXMLString(),'other:child:testingspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.child.@ns::att.toXMLString(),'child:otherspace_attvalue\n' + 'also:child:otherspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.ns::child.@ns::att.toXMLString(),'other:child:otherspace_attvalue', 'unexpected child att query content');
            default xml namespace ='otherspace';
        
            assertEquals(xml.child.@ns::att.toXMLString(),'other:child:otherspace_attvalue', 'unexpected child att query content');
            assertEquals(xml.child.length(),1, 'unexpected child query length');
            //IE11/Edge issue:
            //assertEquals(xml.child.toXMLString(),'<other:child att="other:child:testingspace_attvalue" other:att="other:child:otherspace_attvalue" original="other:child" xmlns="testingspace" xmlns:other="otherspace" xmlns:also="testingspace"/>', 'unexpected child query content');
            assertEquals(xml.child.toXMLString().length,193, 'unexpected child query content');
            
            assertEquals(xml.child.@att.length(),2, 'unexpected child att query length');
            //IE11/Edge issue:
            /*assertEquals(xml.child.@att.toXMLString(),'other:child:testingspace_attvalue\n' +'other:child:otherspace_attvalue', 'unexpected child att query content');*/
            assertEquals(xml.child.@att.toXMLString().length,65, 'unexpected child att query content');
            
        }
        
    }
}
