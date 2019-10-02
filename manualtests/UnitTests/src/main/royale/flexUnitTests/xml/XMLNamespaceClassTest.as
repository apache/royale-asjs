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
    public class XMLNamespaceClassTest
    {
    
    //  private namespace atom = "http://www.w3.org/2005/Atom";
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
        public function basicNamespaceChecks():void{
            var ns:Namespace = new Namespace();
        
            assertStrictlyEquals(ns.uri,'', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,'', 'unexpected namespace prefix value');
            ns = new Namespace('');
            assertStrictlyEquals(ns.uri,'', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,'', 'unexpected namespace prefix value');
            ns = new Namespace("http://royale/");
            assertStrictlyEquals(ns.uri,"http://royale/", 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
            ns = new Namespace("royale", "http://royale/");
            assertStrictlyEquals(ns.uri,"http://royale/", 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,"royale", 'unexpected namespace prefix value');
        
            var ns2:Namespace = new Namespace(ns);
            assertStrictlyEquals(ns.uri,ns2.uri, 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,ns2.prefix, 'unexpected namespace prefix value');
            var err:Boolean = false;
            try{
                ns =  new Namespace("ns", "");
            } catch(e:Error){
                err = true;
            }
            assertTrue(err, 'expected an error')
        }
    
    
    
        [Test]
        public function basicNamespaceNamespaceArgs():void{
            var n:Namespace = new Namespace("http://example.org/");
            var n1:Namespace = new Namespace("n1Pre","http://example.org/n1");
            var n2:Namespace = new Namespace("n2Pre","http://example.org/n2");
    
            assertStrictlyEquals(n.uri,'http://example.org/', 'unexpected namespace uri value');
            assertStrictlyEquals(n.prefix,undefined, 'unexpected namespace prefix value');
            
            var ns:Namespace = new Namespace(n);
            assertStrictlyEquals(ns.uri,'http://example.org/', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
            
            ns = new Namespace(undefined, n);
            assertStrictlyEquals(ns.uri,'http://example.org/', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
            
            ns = new Namespace(n, undefined);
            assertStrictlyEquals(ns.uri,'undefined', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
    
            ns = new Namespace(n, null);
            assertStrictlyEquals(ns.uri,'null', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
    
            ns = new Namespace(n1, n2);
            assertStrictlyEquals(ns.uri,'http://example.org/n2', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
    
            ns = new Namespace(n2, n2);
            assertStrictlyEquals(ns.uri,'http://example.org/n2', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,undefined, 'unexpected namespace prefix value');
    
            ns = new Namespace(n2);
            assertStrictlyEquals(ns.uri,'http://example.org/n2', 'unexpected namespace uri value');
            assertStrictlyEquals(ns.prefix,'n2Pre', 'unexpected namespace prefix value');
            
        }
    
    
    
    }
}
