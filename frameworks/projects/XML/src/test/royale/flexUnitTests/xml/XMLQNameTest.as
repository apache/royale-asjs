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
    
    
    import flexUnitTests.xml.support.QNameTest;    
    import org.apache.royale.test.asserts.*;
    
   // import testshim.RoyaleUnitTestRunner;
    
    /**
     * @royalesuppresspublicvarwarning
     */
    public class XMLQNameTest
    {
    

        public static var ATOM_NS:Namespace = new Namespace("http://www.w3.org/2005/Atom");
        private var atom:Namespace = ATOM_NS;
        
        public static var isJS:Boolean = COMPILE::JS;
    
        private var settings:Object;
        
        private var source:String;
        
        [Before]
        public function setUp():void
        {
            settings = XML.settings();
        }
        
        [After]
        public function tearDown():void
        {
            source=null;
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
        public function testPrimitiveArgs():void{
            var qName:QName;
    
            qName = new QName('*');
            assertEquals(qName.uri,null, 'unexpected uri value');
            assertEquals(qName.localName,'*', 'unexpected localName value');
            assertEquals(qName,'*::*', 'unexpected toString value');
    
            qName = new QName(qName);
            assertEquals(qName.uri,null, 'unexpected uri value');
            assertEquals(qName.localName,'*', 'unexpected localName value');
            assertEquals(qName,'*::*', 'unexpected toString value');
    
            //anything/anywhere
            qName = new QName('*','*');
            assertEquals(qName.uri,'*', 'unexpected uri value');
            assertEquals(qName.localName,'*', 'unexpected localName value');
            assertEquals(qName,'*::*', 'unexpected toString value');
            //clone
            qName = new QName(qName);
            assertEquals(qName.uri,'*', 'unexpected uri value');
            assertEquals(qName.localName,'*', 'unexpected localName value');
            assertEquals(qName,'*::*', 'unexpected toString value');
            
            qName = new QName('localNameOnly');
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'localNameOnly', 'unexpected localName value');
            assertEquals(qName,'localNameOnly', 'unexpected toString value');
    
            qName = new QName(null, 'localNameOnly');
            assertEquals(qName.uri,null, 'unexpected uri value');
            assertEquals(qName.localName,'localNameOnly', 'unexpected localName value');
            assertEquals(qName,'*::localNameOnly', 'unexpected toString value');
    
            qName = new QName(qName);
            assertEquals(qName.uri,null, 'unexpected uri value');
            assertEquals(qName.localName,'localNameOnly', 'unexpected localName value');
            assertEquals(qName,'*::localNameOnly', 'unexpected toString value');
        }
    
        [Test]
        public function testCombos():void{
            var qName:QName;
            qName = new QName( 'test','something');
    
            qName = new QName(undefined, qName);
            assertEquals(qName.uri,'test', 'unexpected uri value');
            assertEquals(qName.localName,'something', 'unexpected localName value');
            assertEquals(qName,'test::something', 'unexpected toString value');
    
            qName = new QName( 'test','*');
    
            qName = new QName(undefined, qName);
            assertEquals(qName.uri,'test', 'unexpected uri value');
            assertEquals(qName.localName,'*', 'unexpected localName value');
            assertEquals(qName,'test::*', 'unexpected toString value');
        }
    
        [Test]
        public function testEquality():void{
            assertTrue(new QName('test') == new QName('test'), 'unexpected equality result');
            assertFalse(new QName('test') === new QName('test'), 'unexpected strict equality result');
        }
    
        [Test]
        public function testDefaultNamespaceDirective():void{
            var qName:QName;
            var pre1QName:QName=new QName();
            var pre2QName:QName=new QName('pre2');
            var pre3QName:QName=new QName('pre3NS','pre3');
            var pre4QName:QName=new QName(new Namespace('pre4NS'),'pre4');
            
            default xml namespace = 'foo';
            var post1QName:QName=new QName();
            var post2QName:QName=new QName('post2');
            var post3QName:QName=new QName('post3NS','post3');
            var post4QName:QName=new QName(new Namespace('post4NS'),'post4');
            
            
            
            qName = new QName('something');
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'something', 'unexpected localName value');
            assertEquals(qName,'foo::something', 'unexpected toString value');
    
    
            qName = new QName();
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'', 'unexpected localName value');
            assertEquals(qName,'foo::', 'unexpected toString value');
    
            qName = new QName('');
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'', 'unexpected localName value');
            assertEquals(qName,'foo::', 'unexpected toString value');
    
            qName = new QName(pre1QName);
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'', 'unexpected localName value');
            assertEquals(qName,'', 'unexpected toString value');
            
            qName = new QName(post1QName);
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'', 'unexpected localName value');
            assertEquals(qName,'foo::', 'unexpected toString value');
    
            qName = new QName(pre2QName);
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'pre2', 'unexpected localName value');
            assertEquals(qName,'pre2', 'unexpected toString value');
    
            qName = new QName(post2QName);
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'post2', 'unexpected localName value');
            assertEquals(qName,'foo::post2', 'unexpected toString value');
    
            qName = new QName(pre3QName);
            assertEquals(qName.uri,'pre3NS', 'unexpected uri value');
            assertEquals(qName.localName,'pre3', 'unexpected localName value');
            assertEquals(qName,'pre3NS::pre3', 'unexpected toString value');
    
            qName = new QName(post3QName);
            assertEquals(qName.uri,'post3NS', 'unexpected uri value');
            assertEquals(qName.localName,'post3', 'unexpected localName value');
            assertEquals(qName,'post3NS::post3', 'unexpected toString value');
    
            qName = new QName(pre4QName);
            assertEquals(qName.uri,'pre4NS', 'unexpected uri value');
            assertEquals(qName.localName,'pre4', 'unexpected localName value');
            assertEquals(qName,'pre4NS::pre4', 'unexpected toString value');
    
            qName = new QName(post4QName);
            assertEquals(qName.uri,'post4NS', 'unexpected uri value');
            assertEquals(qName.localName,'post4', 'unexpected localName value');
            assertEquals(qName,'post4NS::post4', 'unexpected toString value');
        }
    
    
        [Test]
        public function testDefaultNamespaceVariants():void{
            var qName:QName;
            var test:QNameTest = new QNameTest();
    
            qName = test.getStaticBeforeQName();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'staticBefore', 'unexpected localName value');
            assertEquals(qName,'staticBefore', 'unexpected toString value');
    
            qName = test.getStaticAfterQName();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'staticAfter', 'unexpected localName value');
            assertEquals(qName,'staticAfter', 'unexpected toString value');
    
            qName = test.getInstanceBeforeQName();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'instanceBefore', 'unexpected localName value');
            assertEquals(qName,'instanceBefore', 'unexpected toString value');
    
            qName = test.getInstanceAfterQName();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'instanceAfter', 'unexpected localName value');
            assertEquals(qName,'instanceAfter', 'unexpected toString value');
    
    
            qName = QNameTest.getInstanceDeclaredInsideStaticMethod();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'localfoo', 'unexpected localName value');
            assertEquals(qName,'localfoo', 'unexpected toString value');
    
    
            qName = test.getInstanceDeclaredInsideInstanceMethod();
            assertEquals(qName.uri,'', 'unexpected uri value');
            assertEquals(qName.localName,'localfoo', 'unexpected localName value');
            assertEquals(qName,'localfoo', 'unexpected toString value');
    
    
            qName = QNameTest.getInstanceWithDefaultChangeDeclaredInsideStaticMethod();
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'localfoo', 'unexpected localName value');
            assertEquals(qName,'foo::localfoo', 'unexpected toString value');
    
    
            qName = test.getInstanceWithDefaultChangeDeclaredInsideInstanceMethod();
            assertEquals(qName.uri,'foo', 'unexpected uri value');
            assertEquals(qName.localName,'localfoo', 'unexpected localName value');
            assertEquals(qName,'foo::localfoo', 'unexpected toString value');
            
           /* RoyaleUnitTestRunner.consoleOut('qName '+qName);
            qName = test.test2();
            RoyaleUnitTestRunner.consoleOut('qName '+qName);
            
            assertTrue(true);*/
        }
        
        [Test]
        public function testAdvancedWildcards():void{
            var ns:Namespace = new Namespace('*');
            var ns2:Namespace = new Namespace('');
            var test1:QName = new QName('*');
    
            var test2:QName = new QName(null,'*');
            var test3:QName = new QName('*','*');
            var test4:QName = new QName(ns,'*');
            var test5:QName = new QName(ns2,'*');
            var test6:QName = new QName(undefined,'*');
    
            assertEquals(test1.uri, null, 'unexpected toString');
            assertEquals(test2.uri, null, 'unexpected toString');
            assertEquals(test3.uri, '*', 'unexpected toString');
            assertEquals(test4.uri, '*', 'unexpected toString');
            assertEquals(test5.uri, '', 'unexpected toString');
            assertEquals(test6.uri, null, 'unexpected toString');
            
            assertEquals(test1.toString(), '*::*', 'unexpected toString');
            assertEquals(test2.toString(), '*::*', 'unexpected toString');
            assertEquals(test3.toString(), '*::*', 'unexpected toString');
            assertEquals(test4.toString(), '*::*', 'unexpected toString');
            assertEquals(test5.toString(), '*', 'unexpected toString');
            assertEquals(test6.toString(), '*::*', 'unexpected toString');
            
            assertTrue(test2 == test1, 'unexpected equality result');
            assertFalse(test3 == test1, 'unexpected equality result');
            assertFalse(test3 == test1, 'unexpected equality result');
            assertFalse(test4 == test1, 'unexpected equality result');
            assertFalse(test5 == test1, 'unexpected equality result');
            assertTrue(test6 == test1, 'unexpected equality result');
            
        }
        
       
    }
}
